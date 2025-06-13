import 'package:flutter/material.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:slide_to_act/slide_to_act.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MarkAttendancePage(),
    ),
  );
}

class MarkAttendancePage extends StatefulWidget {
  const MarkAttendancePage({super.key});

  @override
  State<MarkAttendancePage> createState() => _MarkAttendancePageState();
}

class _MarkAttendancePageState extends State<MarkAttendancePage> {
  final GlobalKey<SlideActionState> _slideKey = GlobalKey();
  bool _isLoading = false;
  bool isCheckedIn = false;
  String checkInTime = "--:--";
  String checkOutTime = "--:--";
  String locationInfo = "Location not captured yet";
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
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
              content: Text(
                'Location permission is required to mark attendance',
              ),
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
            builder:
                (context) => AlertDialog(
                  title: const Text('Location Services Disabled'),
                  content: const Text(
                    'Please enable location services to continue.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
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

      // Step 3: Get current position with loading indicator
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

      // Step 4: Update attendance status
      final now = TimeOfDay.now().format(context);
      if (mounted) {
        setState(() {
          if (!isCheckedIn) {
            checkInTime = now;
            isCheckedIn = true;
            locationInfo =
                'Checked in at ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
          } else {
            checkOutTime = now;
            isCheckedIn = false;
            locationInfo =
                'Checked out at ${position.latitude.toStringAsFixed(4)}, ${position.longitude.toStringAsFixed(4)}';
          }
        });
      }

      if (mounted) {
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
      if (mounted) {
        setState(() => _isLoading = false);
        // Safely reset the slide action in the next frame
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

  Future<bool> _checkLocationPermission() async {
    var status = await Permission.location.status;

    if (status.isDenied) {
      status = await Permission.location.request();
    }

    if (status.isPermanentlyDenied) {
      if (mounted) {
        await showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),
              const Text(
                'MARK ATTENDANCE',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0A2342),
                ),
              ),
              const SizedBox(height: 30),
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Today's Attendance",
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff0A57CF),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _attendanceCard(
                icon: Icons.login,
                title: "Check-In",
                time: checkInTime,
                isActive: isCheckedIn && checkInTime != "--:--",
              ),
              const SizedBox(height: 16),
              _attendanceCard(
                icon: Icons.logout,
                title: "Check-Out",
                time: checkOutTime,
                isActive: !isCheckedIn && checkOutTime != "--:--",
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  locationInfo,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 24),

              if (_isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      Color(0xff0A57CF),
                    ),
                  ),
                )
              else if (!isCheckedIn)
                SlideAction(
                  key: _slideKey,
                  borderRadius: 30,
                  elevation: 0,
                  outerColor: const Color(0xffC5FFD9),
                  innerColor: Colors.white,
                  sliderButtonIcon: const Icon(
                    Icons.arrow_forward,
                    color: Color(0xff55C099),
                  ),
                  text: "Swipe to Check In",
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff0A2342),
                  ),
                  onSubmit: _handleLocationAndAttendance,
                  sliderRotate: false,
                )
              else
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: SwipeButton(
                    thumb: const Icon(Icons.arrow_forward, color: Colors.white),
                    child: const Text(
                      "Swipe to Check Out",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff0A2342),
                      ),
                    ),
                    activeThumbColor: const Color(0xffFF6B6B),
                    activeTrackColor: const Color(0xffFFD6D6),
                    onSwipe: _handleLocationAndAttendance,
                    // loading: _isLoading,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _attendanceCard({
    required IconData icon,
    required String title,
    required String time,
    required bool isActive,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xff0A57CF) : const Color(0xffCCE4FF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isActive ? const Color(0xff0A2342) : const Color(0xff94C0F1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isActive ? Colors.white : const Color(0xff0A57CF),
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: isActive ? Colors.white : const Color(0xff0A57CF),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            time,
            style: TextStyle(
              fontSize: 22,
              color: isActive ? Colors.white : const Color(0xff0A2342),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            isActive ? "recorded" : "no record",
            style: TextStyle(
              color: isActive ? Colors.white70 : Colors.grey,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
