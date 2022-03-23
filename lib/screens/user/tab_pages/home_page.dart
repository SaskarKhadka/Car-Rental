import 'package:car_rental/components/continue_dialog.dart';
import 'package:car_rental/components/custom_button.dart';
import 'package:car_rental/components/custom_text_field.dart';
import 'package:car_rental/components/location_field.dart';
import 'package:car_rental/components/waiting_dialog.dart';
import 'package:car_rental/constants/constants.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/screens/user/available_cars.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:car_rental/services/database.dart';
import 'package:car_rental/state/date_state.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

// const double pinnedVisible = 0;
// const double pinnedInvisible = -250;

// class HomePage extends StatefulWidget {
// static const String id = "/homePage";

//   const HomePage();

//   @override
//   _HomePageState createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   DateTime? _pickedDate;
//   List<Marker>? markers = [];
//   BitmapDescriptor? usericon;
//   GoogleMapController? _mapController;

// String? pickUpDate;
// String? dropOffDate;

//   void setIcon() async {
//     usericon = await BitmapDescriptor.fromAssetImage(
//         const ImageConfiguration(), 'images/blue.png');
//   }

//   void _setMapStyle() async {
//     String style = await DefaultAssetBundle.of(context)
//         .loadString('images/map_style.json');
//     _mapController!.setMapStyle(style);
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//     _setMapStyle();
//   }

//   @override
//   void dispose() {
//     _mapController!.dispose();
//     super.dispose();
//   }

//   @override
//   void initState() {
//     // _distanceValue = '250 meter';
//     // _distanceValueNum = _distanceMap[_distanceValue];
//     _pickedDate = DateTime.now();

//     super.initState();

//     markers!.add(
//       Marker(
//         markerId: const MarkerId('user'),
//         icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
//         position: const LatLng(27.6915, 85.3420),
//       ),
//     );

//     setIcon();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: _onMapCreated,
//             initialCameraPosition: const CameraPosition(
//                 target: LatLng(27.6915, 85.3420), zoom: 16),
//             mapType: MapType.normal,
//             markers: Set.from(markers!),
//             // circles: Set.from(_circles),
//             zoomControlsEnabled: true,
//             // myLocationEnabled: true,
//             myLocationButtonEnabled: true,
//             onTap: (LatLng latLng) {
//               // setState(() {});
//             },
//           ),
//         ],
//       ),
//     );
//   }

// _pickDate(bool? isPickUpDate) async {
//   DateTime? date = await showDatePicker(
//     context: context,
//     initialDate: _pickedDate!,
//     firstDate: DateTime(
//       DateTime.now().year,
//       DateTime.now().month,
//       DateTime.now().day,
//     ),
//     lastDate: DateTime(
//       DateTime.now().year,
//       DateTime.now().month,
//       DateTime.now().day + 29,
//     ),
//     // lastDate: DateTime(DateTime.now().month + 5),
//   );
//   if (date != null) {
//     setState(() {
//       _pickedDate = date;
//       if (isPickUpDate!) {
//         pickUpDate =
//             "${_pickedDate!.year}/${_pickedDate!.month}/${_pickedDate!.day}";
//       } else {
//         dropOffDate =
//             "${_pickedDate!.year}/${_pickedDate!.month}/${_pickedDate!.day}";
//       }
//     });
//   }
// }
// }

class HomePage extends StatefulWidget {
  static const String id = "/homePage";
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final pickUpLocationController = TextEditingController();
  final dropOffLocationController = TextEditingController();
  final GlobalKey<FormState>? formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState>? scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void dispose() {
    pickUpLocationController.dispose();
    dropOffLocationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 30.0,
              right: 20.0,
              top: 70.0,
              bottom: 25.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Welcome back,",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 35.0,
                    fontWeight: FontWeight.w700,
                    color: Color(0xffECECEC),
                    letterSpacing: 1.5,
                  ),
                ),
                const Center(
                  child: Image(
                    image: AssetImage('images/vector.png'),
                    height: 250,
                    width: 250,
                  ),
                ),
                // const SizedBox(
                //   height: 15.0,
                // ),

                const SizedBox(
                  height: 30.0,
                ),
                const Text(
                  'When would you like us to come?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 15.0,
                    // fontWeight: FontWeight.w700,
                    color: Color(0xffaaabac),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: const Color(0xff101010),
                  ),
                  child: GestureDetector(
                    child: ListTile(
                      title: Text(
                        "Pickup Date: ${Provider.of<DateState>(context, listen: true).pickUpDate}",
                        style: const TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 16.0,
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.w900,
                          color: Color(0xffaaabac),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xffaaabac),
                      ),
                    ),
                    onTap: () {
                      _pickDate(context, true);
                    },
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    color: const Color(0xff101010),
                  ),
                  child: GestureDetector(
                    child: ListTile(
                      title: Text(
                        "Dropoff Date: ${Provider.of<DateState>(context, listen: true).dropOffDate}",
                        style: const TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 16.0,
                          letterSpacing: 1.3,
                          fontWeight: FontWeight.w900,
                          color: Color(0xffaaabac),
                        ),
                      ),
                      trailing: const Icon(
                        Icons.keyboard_arrow_down,
                        color: Color(0xffaaabac),
                      ),
                    ),
                    onTap: () async {
                      _pickDate(context, false);
                    },
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                const Text(
                  'Where would you like us to come?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 15.0,
                    // fontWeight: FontWeight.w700,
                    color: Color(0xffaaabac),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      LocationCustomTextField(
                          controller: pickUpLocationController,
                          labelText: "Pickup Location",
                          icon: Icons.location_on_outlined),
                      const SizedBox(
                        height: 15.0,
                      ),
                      LocationCustomTextField(
                        controller: dropOffLocationController,
                        labelText: "Dropoff Location",
                        icon: Icons.location_on_outlined,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 30.0,
                ),
                CustomButtonGray(
                  // color: Colors.white,
                  buttonContent: Text(
                    "CONFIRM",
                    style: kButtonContentTextStye.copyWith(
                      color: Colors.black,
                    ),
                  ),
                  width: double.infinity,
                  onPressed: () async {
                    final pickUpDate =
                        Provider.of<DateState>(context, listen: false)
                            .pickUpDate
                            .split("/");
                    final dropOffDate =
                        Provider.of<DateState>(context, listen: false)
                            .dropOffDate
                            .split("/");
                    if (DateTime(
                      int.parse(pickUpDate[0]),
                      int.parse(pickUpDate[1]),
                      int.parse(pickUpDate[2]),
                    ).isAfter(
                      DateTime(
                        int.parse(dropOffDate[0]),
                        int.parse(dropOffDate[1]),
                        int.parse(dropOffDate[2]),
                      ),
                    )) {
                      return getToast(
                        message: "Invalid pickup and dropoff date",
                        color: Colors.red,
                      );
                    }
                    if (formKey!.currentState!.validate()) {
                      await showDialog(
                          context: context,
                          builder: (context) => continueDialog(
                                title: "Place Order",
                                message: "Are you sure you want to continue?",
                                onYes: () async {
                                  // Navigator.of(context,
                                  //         rootNavigator: true)
                                  //     .pop();
                                  navigatorKey.currentState!.pop();
                                  // showDialog(
                                  //   context: context,
                                  //   builder: (context) => Column(
                                  //     mainAxisSize: MainAxisSize.min,
                                  //     mainAxisAlignment:
                                  //         MainAxisAlignment.center,
                                  //     children: const [
                                  //       CircularProgressIndicator(
                                  //         color: Colors.white,
                                  //         backgroundColor: Colors.black,
                                  //       ),
                                  //     ],
                                  //   ),
                                  // );
                                  // await Database.placeOrder({
                                  //   "pickUpDate": Provider.of<DateState>(
                                  //           context,
                                  //           listen: false)
                                  //       .pickUpDate,
                                  //   "dropOffDate": Provider.of<DateState>(
                                  //           context,
                                  //           listen: false)
                                  //       .dropOffDate,
                                  //   "pickUpLocation":
                                  //       pickUpLocationController.text.trim(),
                                  //   "dropOffLocation":
                                  //       dropOffLocationController.text.trim(),
                                  //   "timeStamp": DateTime.now(),
                                  //   "placedBy": Authentication.userID,
                                  // });

                                  // navigatorKey.currentState!.pop();

                                  navigatorKey.currentState!
                                      .pushNamed(AvailableCars.id, arguments: {
                                    "pickUpDate": Provider.of<DateState>(
                                            scaffoldKey!.currentContext!,
                                            listen: false)
                                        .pickUpDate,
                                    "dropOffDate": Provider.of<DateState>(
                                            scaffoldKey!.currentContext!,
                                            listen: false)
                                        .dropOffDate,
                                    "pickUpLocation":
                                        pickUpLocationController.text.trim(),
                                    "dropOffLocation":
                                        dropOffLocationController.text.trim(),
                                  });
                                  // Provider.of<DateState>(context, listen: false)
                                  //                                   .reset();
                                  // getToast(
                                  //     message: "Order placed successfully",
                                  //     color: Colors.green);
                                },
                                onNo: () {
                                  navigatorKey.currentState!.pop();
                                },
                              ));
                    }
                  },
                  // color: Colors.red,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context, bool? isPickUpDate) async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
      ),
      lastDate: DateTime(
        DateTime.now().year,
        DateTime.now().month + 1,
        DateTime.now().day,
      ),
      // lastDate: DateTime(DateTime.now().month + 5),
    );
    if (date != null) {
      // _pickedDate = date;
      if (isPickUpDate!) {
        Provider.of<DateState>(context, listen: false)
            .updatePickUpDate("${date.year}/${date.month}/${date.day}");
      } else {
        Provider.of<DateState>(context, listen: false)
            .updateDropOffDate("${date.year}/${date.month}/${date.day}");
      }
    }
  }
}

Future<void> selectedItem(BuildContext context, int item) async {
  switch (item) {
    case 0:
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => AboutPage()),
      // );
      break;
    case 1:
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => HelpPage()),
      // );
      break;
    case 2:
      await Authentication.signOut();
      navigatorKey.currentState!
          .pushNamedAndRemoveUntil(Signin.id, (route) => false);
      break;
  }
}
