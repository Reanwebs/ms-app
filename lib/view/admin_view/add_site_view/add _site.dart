import 'dart:developer';
import 'package:construction_app/controller/admin_controller/admin_controller.dart';
import 'package:construction_app/view/common_widgets/common_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';

bool isSearchedSO = false;

class AddSite extends StatefulWidget {
  const AddSite({super.key});

  @override
  State<AddSite> createState() => _AddSiteState();
}

class _AddSiteState extends State<AddSite> {
  GoogleMapController? _mapController;
  final AdminController adminController = Get.put(AdminController());
  LatLng? _currentLocation;
  LatLng? _selectedLocation;
  LatLng? _lastMapPosition;
  String _locationName = '';
  String _locality = '';
  Set<Marker> _markers = {};
  bool _isLoading = true;
  bool _isInitialLocation = true;
  LatLng? _initialPosition;
  final TextEditingController siteNamecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoading = false;
          _locality = 'Unknown Location';
          _locationName = '';
        });
        _showErrorDialog(
          "Location services are disabled. Please enable them in your device settings.",
        );
        return;
      }

      // Check and request location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoading = false;
            _locality = 'Unknown Location';
            _locationName = '';
          });
          _showErrorDialog(
            "Location permission denied. Please allow location access to use this feature.",
          );
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoading = false;
          _locality = 'Unknown Location';
          _locationName = '';
        });
        _showErrorDialog(
          "Location permission is permanently denied. Please enable it in your device settings.",
        );
        return;
      }

      // Fetch current location
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      if (!mounted) return;

      setState(() {
        _currentLocation = LatLng(position.latitude, position.longitude);
        _selectedLocation = _currentLocation;
        _lastMapPosition = _currentLocation;
        _initialPosition = _currentLocation;
        _isLoading = false;
      });

      // Update markers and location name
      await _updateMarkers();
      await _getLocationName();

      Future.delayed(const Duration(milliseconds: 100), () {
        if (_mapController != null && _currentLocation != null) {
          _moveCameraToLocation(_currentLocation!);
        }
      });
    } catch (e) {
      log("Error in initialization: $e");
      setState(() {
        _isLoading = false;
        _locality = 'Unknown Location';
        _locationName = '';
      });
      _showErrorDialog(
        "Failed to initialize location. Please ensure location services are enabled and try again.",
      );
    }
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    return Geolocator.distanceBetween(
      point1.latitude,
      point1.longitude,
      point2.latitude,
      point2.longitude,
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      if (!mounted) return;

      setState(() {
        _isInitialLocation = false;
        _currentLocation = LatLng(position.latitude, position.longitude);
        _selectedLocation = _currentLocation;
        _lastMapPosition = _currentLocation;
      });

      await _updateMarkers();
      await _getLocationName();
      if (_mapController != null && _currentLocation != null) {
        _moveCameraToLocation(_currentLocation!);
      }
    } catch (e) {
      log("Error getting location: $e");
      _showErrorDialog(
        "Failed to get current location. Please ensure location services are enabled.",
      );
    }
  }

  void _moveCameraToLocation(LatLng location) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(location, 20),
    );
  }

  Future<void> _updateMarkers() async {
    try {
      if (_selectedLocation == null) return;
      final Uint8List markerIcon = await _customSelectedLocationMarker();
      setState(() {
        _markers = {
          Marker(
            markerId: const MarkerId('selected_location'),
            position: _selectedLocation!,
            icon: BitmapDescriptor.bytes(
              markerIcon,
              height: 80,
              width: 250,
            ),
            anchor: const Offset(0.5, 1.0),
          ),
        };
      });
    } catch (e) {
      log("Error updating markers: $e");
    }
  }

  Future<Uint8List> _customSelectedLocationMarker() async {
    const double width = 500;
    const double height = 180;
    const double borderRadius = 20;

    final recorder = ui.PictureRecorder();
    final Canvas canvas =
        Canvas(recorder, const Rect.fromLTWH(0, 0, width, height));

    canvas.save();
    canvas.translate(width / 2, height / 2);
    canvas.rotate(0);
    canvas.translate(-width / 2, -height / 2);

    final paint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.fill;

    final rrect = RRect.fromRectAndRadius(
        const Rect.fromLTWH(0, 0, width, height - 20),
        const Radius.circular(borderRadius));

    canvas.drawRRect(rrect, paint);

    final pointerPath = Path()
      ..moveTo(width / 2 - 10, height - 20)
      ..lineTo(width / 2, height)
      ..lineTo(width / 2 + 10, height - 20)
      ..close();

    canvas.drawPath(pointerPath, paint);

    final textPainter1 = TextPainter(
      text: TextSpan(
        text: 'Yes, this is the site located at',
        style: TextStyle(
          fontFamily: GoogleFonts.dmSans().fontFamily,
          color: Colors.white,
          fontSize: 28,
          fontWeight: FontWeight.w600,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter1.layout(maxWidth: width - 60);
    textPainter1.paint(canvas, const Offset(30, 30));

    final textPainter2 = TextPainter(
      text: TextSpan(
        text: 'Mark the exact location on the map',
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.7),
          fontSize: 24,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter2.layout(maxWidth: width - 60);
    textPainter2.paint(canvas, const Offset(30, 80));

    final image =
        await recorder.endRecording().toImage(width.toInt(), height.toInt());
    final pngBytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return pngBytes!.buffer.asUint8List();
  }

  Future<void> _getLocationName() async {
    if (!mounted || _selectedLocation == null) return;

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        _selectedLocation!.latitude,
        _selectedLocation!.longitude,
      );

      if (!mounted) return;

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        setState(() {
          _locality = place.name ?? 'Unknown Location';
          _locationName =
              '${place.thoroughfare ?? ''},${place.street ?? ''}, ${place.subLocality ?? ''},${place.locality ?? ''},${place.postalCode ?? ''},${place.country ?? ''}';
        });
      } else {
        setState(() {
          _locality = 'Unknown Location';
          _locationName = '';
        });
      }
    } catch (e) {
      log("Error getting location name: $e");
      setState(() {
        _locality = 'Unknown Location';
        _locationName = '';
      });
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      _mapController = controller;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      if (_selectedLocation != null) {
        _moveCameraToLocation(_selectedLocation!);
      }
    });
  }

  void _onCameraMove(CameraPosition position) {
    setState(() {
      _lastMapPosition = position.target;
      _selectedLocation = position.target;
      if (_isInitialLocation) {
        _isInitialLocation = false;
      }
    });
    _updateMarkers();

    if (!_isInitialLocation && _initialPosition != null) {
      double distance = _calculateDistance(_initialPosition!, position.target);
      if (distance > 10) {
        _getLocationName();
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CommonWidgets().commonappbar('Add Site'),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Positioned.fill(
                    top: 10.r,
                    child: GoogleMap(
                      onMapCreated: _onMapCreated,
                      initialCameraPosition: CameraPosition(
                        target: _currentLocation ?? const LatLng(0, 0),
                        zoom: 18,
                      ),
                      markers: _markers,
                      onCameraMove: _onCameraMove,
                      onCameraIdle: () {},
                      myLocationEnabled: true,
                      myLocationButtonEnabled: false,
                      mapToolbarEnabled: false,
                      zoomControlsEnabled: false,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            right: width * 0.09,
                            bottom: height * 0.02,
                          ),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: TextButton.icon(
                                onPressed: _getCurrentLocation,
                                icon: Icon(
                                  Icons.my_location,
                                  color: const Color(0xFFFF8A00),
                                  size: 18.sp,
                                ),
                                label: Text(
                                  'Locate me',
                                  style: TextStyle(
                                    color: const Color(0xFFFF8A00),
                                    fontSize: 14.sp,
                                  ),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: width * 0.03,
                                    vertical: height * 0.01,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.all(width * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.location_pin,
                                      color: Colors.orange, size: width * 0.06),
                                  SizedBox(width: width * 0.02),
                                  Expanded(
                                    child: Text(
                                      _locality,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: width * 0.04,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: width * 0.08),
                                child: Text(
                                  _locationName,
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: width * 0.035,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              SizedBox(height: height * 0.02),
                              CommonWidgets().commonButton(
                                title: 'Save Site',
                                ontap: () async {
                                  if (_selectedLocation != null) {
                                    CommonWidgets().showFeedbackDialogue(
                                      context,
                                      siteNamecontroller,
                                      lines: 2,
                                      title: 'Enter Site Name',
                                      () async {
                                        var status =
                                            await adminController.addSite(
                                                _locality,
                                                _locationName,
                                                _selectedLocation!.latitude,
                                                _selectedLocation!.longitude,
                                                siteNamecontroller.text);
                                        if (status) {
                                          CommonWidgets().successAlertBox(
                                              context,
                                              'New Site Added Successfully');
                                        }
                                      },
                                    );
                                  } else {
                                    _showErrorDialog(
                                        "Location not available. Please try again.");
                                  }
                                },
                              ),
                              SizedBox(height: 20.h),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
