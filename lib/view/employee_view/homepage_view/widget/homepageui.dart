import 'dart:developer' as developer;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:slide_to_act/slide_to_act.dart';

class HomeContentPage extends StatefulWidget {
  const HomeContentPage({super.key});

  @override
  State<HomeContentPage> createState() => _HomeContentPageState();
}

class _HomeContentPageState extends State<HomeContentPage> {
  final GlobalKey<SlideActionState> _slideKey = GlobalKey();
  bool _isLoading = false;
  bool isCheckedIn = false;
  String checkInTime = "--:--";
  String checkOutTime = "--:--";
  String? username;
  bool _isDisposed = false;
  String locationInfo = "Location not captured yet";
  bool _isStatusLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsername();
    checkAttendanceStatus();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> fetchUsername() async {
    try {
      var response = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      if (mounted && !_isDisposed) {
        setState(() {
          username = response['username'] ?? 'Unknown';
        });
      }
    } catch (e) {
      developer.log("Error fetching username: $e");
    }
  }

  Future<void> checkAttendanceStatus() async {
    try {
      setState(() => _isStatusLoading = true);
      final today = DateTime.now();
      final dateStr =
          "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
      final userId = FirebaseAuth.instance.currentUser!.uid;

      final doc = await FirebaseFirestore.instance
          .collection('attendance')
          .doc(userId)
          .collection('records')
          .doc(dateStr)
          .get();

      if (mounted && !_isDisposed) {
        setState(() {
          if (doc.exists) {
            final data = doc.data()!;
            isCheckedIn =
                data['checkOutTime'] == null && data['checkInTime'] != null;
            checkInTime = data['checkInTime'] ?? '--:--';
            checkOutTime = data['checkOutTime'] ?? '--:--';
            locationInfo = data['checkOutTime'] == null &&
                    data['checkInTime'] != null
                ? 'Checked in at ${data['checkInLocation'] ?? 'N/A'} (Site: ${data['siteName'] ?? 'N/A'})'
                : data['checkOutTime'] != null
                    ? 'Checked out at ${data['checkOutLocation'] ?? 'N/A'}'
                    : 'Location not captured yet';
          } else {
            isCheckedIn = false;
            checkInTime = '--:--';
            checkOutTime = '--:--';
            locationInfo = 'Location not captured yet';
          }
          _isStatusLoading = false;
        });
      }
    } catch (e) {
      developer.log("Error checking attendance status: $e");
      if (mounted && !_isDisposed) {
        setState(() {
          _isStatusLoading = false;
          isCheckedIn = false;
          locationInfo = 'Error loading attendance status';
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load attendance status'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  Future<bool> _checkLocationPermission() async {
    var status = await Permission.location.status;

    if (status.isDenied) {
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Location Permission Required'),
            content: const Text(
              'Please enable location permissions in app settings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context);
                  await openAppSettings();
                },
                child: const Text('Open Settings'),
              ),
            ],
          ),
        );
      }
      return false;
    }

    return status.isGranted;
  }

  Future<Map<String, dynamic>?> _isWithinSiteRadius(Position position) async {
    try {
      final sitesSnapshot =
          await FirebaseFirestore.instance.collection('sites').get();
      if (sitesSnapshot.docs.isEmpty) {
        return null;
      }

      for (var doc in sitesSnapshot.docs) {
        final site = doc.data();
        final siteLocation = site['location'] as GeoPoint;
        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          siteLocation.latitude,
          siteLocation.longitude,
        );
        if (distance <= 500) {
          return {
            'site_name': site['site_name'] ?? 'Unknown Site',
            'siteId': doc.id,
          };
        }
      }
      return null;
    } catch (e) {
      developer.log("Error checking site radius: $e");
      return null;
    }
  }

  Future<void> _handleLocationAndAttendance() async {
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      // Step 1: Check and request location permission
      final permissionStatus = await _checkLocationPermission();
      if (!permissionStatus) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Location permission is required to mark attendance'),
              duration: Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      // Step 2: Check if location services are enabled
      if (!await Geolocator.isLocationServiceEnabled()) {
        if (mounted) {
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Location Services Disabled'),
              content: const Text(
                'Please enable location services to continue.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await Geolocator.openLocationSettings();
                  },
                  child: const Text('Open Settings'),
                ),
              ],
            ),
          );
        }
        return;
      }

      // Step 3: Get current position
      Position position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        ).timeout(const Duration(seconds: 15));
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to get location: ${e.toString()}'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
        return;
      }

      // Step 4: Check if within 500 meters of any site and get siteName
      final siteData = await _isWithinSiteRadius(position);
      if (siteData == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('You are not within 500 meters of any site'),
              duration: Duration(seconds: 3),
            ),
          );
        }
        return;
      }

      // Step 5: Update attendance in Firestore
      final now = TimeOfDay.now().format(context);
      final today = DateTime.now();
      final dateStr =
          "${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}";
      final userId = FirebaseAuth.instance.currentUser!.uid;
      final attendanceRef = FirebaseFirestore.instance
          .collection('attendance')
          .doc(userId)
          .collection('records')
          .doc(dateStr);

      if (isCheckedIn) {
        // Check-out
        await attendanceRef.set({
          'checkOutTime': now,
          'checkOutLocation':
              '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}',
          'checkOutTimestamp': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      } else {
        // Check-in
        await attendanceRef.set({
          'checkInTime': now,
          'checkInLocation':
              '${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}',
          'checkInTimestamp': FieldValue.serverTimestamp(),
          'site_name': siteData['site_name'],
        }, SetOptions(merge: true));
      }

      // Step 6: Update UI
      if (mounted && !_isDisposed) {
        setState(() {
          if (!isCheckedIn) {
            checkInTime = now;
            isCheckedIn = true;
            locationInfo =
                'Checked in at ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)} (Site: ${siteData['siteName']})';
          } else {
            checkOutTime = now;
            isCheckedIn = false;
            locationInfo =
                'Checked out at ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
          }
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              isCheckedIn
                  ? 'Checked in successfully!'
                  : 'Checked out successfully!',
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted && !_isDisposed) {
        setState(() => _isLoading = false);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!_isDisposed && _slideKey.currentState?.mounted == true) {
            try {
              _slideKey.currentState?.reset();
            } catch (e) {
              debugPrint('Error resetting slide action: $e');
            }
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20).r,
      child: ListView(
        children: [
          const SizedBox(height: 10),
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.w),
                ),
                child: ClipOval(
                  child: SvgPicture.asset('assets/profile_icon.svg',
                      width: 80.w, height: 80.h, fit: BoxFit.fitHeight),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                username ?? '',
                style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Text('Hi, Welcome Back!',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.sp,
                  decoration: TextDecoration.underline,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 15.h),
          Text('Mark Your Attendance',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              checkInCheckoutWidget(
                  'Check - In', checkInTime, Icons.login_rounded),
              checkInCheckoutWidget(
                  'Check - Out', checkOutTime, Icons.logout_rounded),
            ],
          ),
          SizedBox(height: 20.h),
          if (_isStatusLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          else if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            )
          else if (!isCheckedIn)
            SlideAction(
              key: _slideKey,
              borderRadius: 30,
              elevation: 0,
              outerColor: Colors.black,
              innerColor: Colors.white,
              sliderButtonIcon: const Icon(
                Icons.arrow_forward,
                color: Colors.black,
              ),
              text: "Swipe to Check In",
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              onSubmit: _handleLocationAndAttendance,
              sliderRotate: false,
            )
          else
            SlideAction(
              key: _slideKey,
              borderRadius: 30,
              elevation: 0,
              reversed: true,
              outerColor: Colors.red,
              innerColor: Colors.white,
              sliderButtonIcon: const Icon(
                Icons.arrow_forward,
                color: Colors.red,
              ),
              text: "Swipe to Check Out",
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              onSubmit: _handleLocationAndAttendance,
              sliderRotate: false,
            ),
          SizedBox(height: 20.h),
          Text('My Activities',
              style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold)),
          SizedBox(height: 20.h),
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('attendance')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('records')
                .orderBy('checkInTimestamp', descending: true)
                .limit(10)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return const Center(
                    child: Text('No attendance records available'));
              }

              final records = snapshot.data!.docs;
              return ListView.builder(
                shrinkWrap: true,
                itemCount: records.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final data = records[index].data() as Map<String, dynamic>;
                  final date = records[index].id;
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12).r,
                    padding: const EdgeInsets.all(12).r,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(12).r,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          date,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14.sp,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            const Icon(Icons.login_rounded,
                                color: Colors.black),
                            SizedBox(width: 8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['checkInTime'] ?? '--:--',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 14.sp,
                                      color: Colors.black),
                                ),
                                Text(
                                  data['checkInLocation'] ?? 'N/A',
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10.w),
                            const Icon(Icons.logout_rounded,
                                color: Colors.black),
                            SizedBox(width: 8.w),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data['checkOutTime'] ?? '--:--',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  data['checkOutLocation'] ?? 'N/A',
                                  style: TextStyle(
                                      fontSize: 12.sp, color: Colors.black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Expanded checkInCheckoutWidget(
      String title, String checkInCheckoutTime, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10).r,
        margin: EdgeInsets.only(right: 10.w),
        decoration: BoxDecoration(
          color: const Color(0xffCCE4FF),
          borderRadius: BorderRadius.circular(10).r,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.black),
                SizedBox(width: 5.w),
                Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Text(
              checkInCheckoutTime,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h),
          ],
        ),
      ),
    );
  }
}
