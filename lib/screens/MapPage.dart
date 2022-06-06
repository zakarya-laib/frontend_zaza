import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapPage extends StatefulWidget {
  final Set<Marker> markers ;
  const MapPage({Key? key,required this.markers}) : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}
class _MapPageState extends State<MapPage> {
  late GoogleMapController mapController;
  final LatLng _center = const LatLng(36, 6);
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(appBar: AppBar(automaticallyImplyLeading:false,centerTitle:true,title: Text('Offers Locations', style: TextStyle(letterSpacing: 2, fontSize: 15,color:Colors.white)),),
        body: GoogleMap(
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers:widget.markers,
        ),
      ),
    );
  }
}
