import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:chatlinxs/widgets/custom_loader.dart';
import 'package:chatlinxs/widgets/gradient_icon_button.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? currentLocation;

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pop(context, currentLocation);
        },
        backgroundColor: Colors.transparent,
        child: const GradientIconButton(size: 55, iconData: Icons.send),
      ),
      body: currentLocation != null
          ? FlutterMap(
              options: MapOptions(
                  center: currentLocation,
                  zoom: 13.0,
                  onTap: (tp, latLong) {
                    setState(() {
                      currentLocation = latLong;
                    });
                  }), children: const [
                    //se ocupaba el children
                  ],
              // layers: [
              //   TileLayerOptions(
              //     urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              //   ),
              //   MarkerLayerOptions(
              //     markers: [
              //       Marker(
              //         width: 20.0,
              //         height: 20.0,
              //         point: currentLocation!,
              //         builder: (ctx) => const Icon(
              //           Icons.location_pin,
              //           color: greenColor,
              //         ),
              //       ),
              //     ],
              //   ),
              // ],
            )
          : const Center(
              child: CustomLoader(),
            ),
    );
  }

  getCurrentLocation() async {
    var position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best);
    setState(() {
      currentLocation = LatLng(position.latitude, position.longitude);
    });
  }
}
