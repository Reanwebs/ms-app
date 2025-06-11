import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class AddSitePage extends StatefulWidget {
  const AddSitePage({super.key});

  @override
  State<AddSitePage> createState() => _AddSitePageState();
}

class _AddSitePageState extends State<AddSitePage> {
  LatLng? _selectedLocation;

  Future<void> _pickLocationFromMap() async {
    LatLng? picked = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PickLocationPage(),
      ),
    );

    if (picked != null) {
      setState(() {
        _selectedLocation = picked;
      });
    }
  }

  void _saveSite() {
    if (_selectedLocation == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please pick a location first")),
      );
      return;
    }

    // Save site details with lat/lng to DB or backend here

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Site saved at Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),
      appBar: AppBar(
        backgroundColor: const Color(0xff2B55C7),
        title: const Text('Add Site', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _pickLocationFromMap,
              icon: const Icon(Icons.location_on),
              label: const Text("Pick Location from Google Map"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1A5293),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
              ),
            ),
            const SizedBox(height: 30),
            if (_selectedLocation != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("📍 Latitude: ${_selectedLocation!.latitude}"),
                  const SizedBox(height: 10),
                  Text("📍 Longitude: ${_selectedLocation!.longitude}"),
                ],
              ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _saveSite,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff1A5293),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("Save Site", style: TextStyle(color: Colors.white, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class PickLocationPage extends StatefulWidget {
  const PickLocationPage({super.key});

  @override
  State<PickLocationPage> createState() => _PickLocationPageState();
}

class _PickLocationPageState extends State<PickLocationPage> {
  LatLng? _pickedLocation;
  GoogleMapController? _mapController;

  Future<LatLng> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    return LatLng(position.latitude, position.longitude);
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation().then((loc) {
      setState(() {
        _pickedLocation = loc;
      });
    });
  }

  void _onMapTap(LatLng latLng) {
    setState(() {
      _pickedLocation = latLng;
    });
  }

  void _confirmLocation() {
    if (_pickedLocation != null) {
      Navigator.pop(context, _pickedLocation);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Location'),
        backgroundColor: const Color(0xff2B55C7),
        foregroundColor: Colors.white,
      ),
      body: _pickedLocation == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  onMapCreated: (controller) => _mapController = controller,
                  initialCameraPosition: CameraPosition(
                    target: _pickedLocation!,
                    zoom: 16,
                  ),
                  onTap: _onMapTap,
                  markers: _pickedLocation != null
                      ? {
                          Marker(
                            markerId: const MarkerId("picked"),
                            position: _pickedLocation!,
                          )
                        }
                      : {},
                ),
                Positioned(
                  bottom: 30,
                  left: 24,
                  right: 24,
                  child: ElevatedButton(
                    onPressed: _confirmLocation,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff2B55C7),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Confirm Location",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                )
              ],
            ),
    );
  }
}
