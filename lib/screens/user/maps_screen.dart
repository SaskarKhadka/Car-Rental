import 'package:car_rental/components/custom_button.dart';
import 'package:car_rental/constants/constants.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/screens/user/available_cars.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class MapsPage extends StatefulWidget {
  static const String id = "/mapsPage";
  final Map<String, dynamic>? args;
  const MapsPage({
    Key? key,
    this.args,
  }) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  List<Marker>? markers = [];
  GoogleMapController? _mapController;
  bool? isPickUpLocation;
  bool? isViewMode;

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  void dispose() {
    _mapController!.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    isPickUpLocation = true;
    isViewMode = widget.args!["isViewMode"] ?? false;
    if (isViewMode!) {
      List pickUpLocation =
          widget.args!["pickUpLocation"].toString().split(",");
      List dropOffLocation =
          widget.args!["dropOffLocation"].toString().split(",");
      markers!.add(Marker(
        infoWindow: const InfoWindow(title: "Pickup Location"),
        markerId: const MarkerId('pickUpLocation'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        position: LatLng(
          double.parse(pickUpLocation[0].toString()),
          double.parse(pickUpLocation[1].toString()),
        ),
      ));
      markers!.add(Marker(
        infoWindow: const InfoWindow(title: "Dropoff Location"),
        markerId: const MarkerId('Dropoff Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        position: LatLng(
          double.parse(dropOffLocation[0].toString()),
          double.parse(dropOffLocation[1].toString()),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: const CameraPosition(
                target: LatLng(27.6915, 85.3420), zoom: 16),
            mapType: MapType.normal,
            markers: Set.from(markers!),
            // circles: Set.from(_circles),
            zoomControlsEnabled: true,
            // myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onLongPress: isViewMode! || markers!.length == 2
                ? (latlng) {
                    print(isViewMode);
                  }
                : (latLng) {
                    setState(() {
                      if (isPickUpLocation!) {
                        markers!.add(
                          Marker(
                            infoWindow:
                                const InfoWindow(title: "Pickup Location"),
                            markerId: const MarkerId('pickUpLocation'),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueBlue),
                            position: LatLng(latLng.latitude, latLng.longitude),
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 15.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "Delete Marker",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25.0,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        const Text(
                                          "Are you sure you want to continue?",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                navigatorKey.currentState!
                                                    .pop();
                                                setState(() {
                                                  markers!.removeWhere(
                                                    (marker) =>
                                                        marker.markerId.value ==
                                                        "pickUpLocation",
                                                  );
                                                  isPickUpLocation = true;
                                                });
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  Colors.black,
                                                ),
                                              ),
                                              child: const Text("Yes"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                navigatorKey.currentState!
                                                    .pop();
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  Colors.black,
                                                ),
                                              ),
                                              child: const Text("No"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                        isPickUpLocation = false;
                      } else {
                        markers!.add(
                          Marker(
                            infoWindow:
                                const InfoWindow(title: "Dropoff Location"),
                            markerId: const MarkerId('dropOffLocation'),
                            icon: BitmapDescriptor.defaultMarkerWithHue(
                                BitmapDescriptor.hueRed),
                            position: LatLng(latLng.latitude, latLng.longitude),
                            onTap: () async {
                              await showDialog(
                                context: context,
                                builder: (context) => Dialog(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 15.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Text(
                                          "Delete Marker",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 25.0,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        const Text(
                                          "Are you sure you want to continue?",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16.0,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            ElevatedButton(
                                              onPressed: () async {
                                                navigatorKey.currentState!
                                                    .pop();
                                                setState(() {
                                                  markers!.removeWhere(
                                                    (marker) =>
                                                        marker.markerId.value ==
                                                        "dropOffLocation",
                                                  );
                                                  isPickUpLocation = false;
                                                });
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  Colors.black,
                                                ),
                                              ),
                                              child: const Text("Yes"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () {
                                                navigatorKey.currentState!
                                                    .pop();
                                              },
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                  Colors.black,
                                                ),
                                              ),
                                              child: const Text("No"),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }
                    });
                  },
          ),
          isViewMode!
              ? Container()
              : Positioned(
                  bottom: 15.0,
                  left: 15.0,
                  right: 15.0,
                  child: CustomButton(
                    onPressed: () {
                      if (markers!.isEmpty || markers!.length != 2) {
                        getToast(
                          message:
                              "You need to select both pick up and drop off location",
                          color: Colors.red,
                        );
                        return;
                      }
                      if (markers![0].markerId.value == "pickUpLocation") {
                        final pickUpPosition = markers![0].position;
                        widget.args!["pickUpLocation"] =
                            "${pickUpPosition.latitude.toString()},${pickUpPosition.longitude.toString()}";

                        final dropOffPosition = markers![1].position;
                        widget.args!["dropOffLocation"] =
                            "${dropOffPosition.latitude.toString()},${dropOffPosition.longitude.toString()}";
                      } else {
                        final pickUpPosition = markers![1].position;
                        widget.args!["pickUpLocation"] =
                            "${pickUpPosition.latitude.toString()},${pickUpPosition.longitude.toString()}";

                        final dropOffPosition = markers![0].position;
                        widget.args!["dropOffLocation"] =
                            "${dropOffPosition.latitude.toString()},${dropOffPosition.longitude.toString()}";
                      }
                      navigatorKey.currentState!.pushNamed(
                        AvailableCars.id,
                        arguments: widget.args,
                      );
                    },
                    width: double.infinity,
                    buttonContent: const Text(
                      "CONFIRM",
                      style: kButtonContentTextStye,
                    ),
                  ),
                ),
          isViewMode!
              ? Container()
              : const Positioned(
                  top: 35.0,
                  left: 15.0,
                  right: 15.0,
                  child: Text(
                    "Please select your pickup and dropoff location",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Montserrat",
                      fontSize: 25.0,
                    ),
                  ))
        ],
      ),
    );
  }
}
