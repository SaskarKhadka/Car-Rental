import 'package:car_rental/components/car_details_field.dart';
import 'package:car_rental/components/continue_dialog.dart';
import 'package:car_rental/components/custom_button.dart';
import 'package:car_rental/components/custom_exception.dart';
import 'package:car_rental/components/custom_text_field.dart';
import 'package:car_rental/components/scroll_behaviour.dart';
import 'package:car_rental/constants/constants.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/model/car.dart';
import 'package:car_rental/screens/admin/add_new_car.dart';
import 'package:car_rental/screens/admin/edit_car.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:car_rental/services/database.dart';
import 'package:car_rental/services/google_auth.dart';
import 'package:car_rental/state/car_state.dart';
import 'package:car_rental/state/image_index_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
// import 'package:dropdown_button2/dropdown_button2.dart';

class Cars extends StatelessWidget {
  final carTypeController = TextEditingController();

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  Cars({Key? key}) : super(key: key);

  List<DropdownMenuItem<String>>? dropDownItems() {
    List<String> items = ["All", "Avialable", "Not Available"];
    List<DropdownMenuItem<String>> dropDown = [];
    for (String item in items) {
      dropDown.add(
        DropdownMenuItem(
          value: item,
          child: Text(
            item,
            style: const TextStyle(
              color: Colors.black,
              fontFamily: "Montserrat",
            ),
          ),
        ),
      );
    }
    return dropDown;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        // drawer: DrawerItems(),
        appBar: AppBar(
          backgroundColor: Colors.black,
          toolbarHeight: 67,
          elevation: 2,
          shadowColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
              left: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Cars',
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    // color: Color(0xff131313),
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 1.5,
                    // decoration: TextDecoration.underline,
                  ),
                ),
                // DropdownButton(
                //   items: dropDownItems(),
                //   style: TextStyle(
                //     color: Colors.white,
                //   ),
                //   value: Provider.of<CarState>(context, listen: true).carState,
                //   onChanged: (value) {
                //     Provider.of<CarState>(context, listen: false)
                //         .changeState(value);
                //   },
                // ),
              ],
            ),
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () async {
                  try {
                    await GoogleAuthentication.signOut();
                    await Authentication.signOut();
                    navigatorKey.currentState!
                        .pushNamedAndRemoveUntil(Signin.id, (route) => false);
                  } on PlatformException catch (ex) {
                    await Authentication.signOut();
                    navigatorKey.currentState!
                        .pushNamedAndRemoveUntil(Signin.id, (route) => false);
                  } on CustomException catch (ex) {
                    getToast(
                      message: "Couldnot sign out",
                      color: Colors.red,
                    );
                  }
                },
                child: const Icon(
                  EvaIcons.logOutOutline,
                  color: Colors.white,
                  size: 20.0,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigator.pushNamed(context, AddNewCar.id);
            navigatorKey.currentState!.pushNamed(AddNewCar.id);
          },
          // backgroundColor: const Color(0xffd17842),
          backgroundColor: Colors.blue,
          child: const Icon(
            EvaIcons.plus,
            color: Colors.black,
          ),
        ),
        body: Scrollbar(
          child: CarStream(),
        ),
      ),
    );
  }
}

class CarStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
      ),
      child: StreamBuilder<List<Car?>>(
        stream: Database.carsStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'You have no cars',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                ),
              ),
            );
          }
          final cars = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            itemCount: cars.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              final Car? car = cars[index];

              return Container(
                margin: const EdgeInsets.only(bottom: 30.0),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: const Color(0xFF18171A),
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 5.0,
                        offset: Offset(7, 7),
                      ),
                    ]),
                child: Row(
                  // crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        await Provider.of<ImageIndexState>(context,
                                listen: false)
                            .resolveTotalPics(car!.docID);
                        showDialog(
                          context: context,
                          builder: (context) => Dialog(
                            // backgroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          Provider.of<ImageIndexState>(context,
                                                  listen: false)
                                              .changeState(-1);
                                        },
                                        child: const Icon(
                                          EvaIcons.arrowBackOutline,
                                        ),
                                      ),
                                      Image.network(
                                          car.picsUrl[
                                              Provider.of<ImageIndexState>(
                                                      context,
                                                      listen: true)
                                                  .imageIndex!],
                                          height: 200.0,
                                          width: 200.0,
                                          fit: BoxFit.fill, loadingBuilder:
                                              (_, child, loadingProgress) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 30.0),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              CircularProgressIndicator(
                                                color: Colors.black,
                                                value: loadingProgress
                                                            .expectedTotalBytes !=
                                                        null
                                                    ? loadingProgress
                                                            .cumulativeBytesLoaded /
                                                        loadingProgress
                                                            .expectedTotalBytes!
                                                    : null,
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                      GestureDetector(
                                          onTap: () {
                                            Provider.of<ImageIndexState>(
                                                    context,
                                                    listen: false)
                                                .changeState(1);
                                          },
                                          child: const Icon(
                                              EvaIcons.arrowForwardOutline)),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0),
                        child: Image.network(
                          car!.coverPicUrl,
                          height: 100.0,
                          width: 100.0,
                          fit: BoxFit.fill,
                          loadingBuilder: (_, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return CircularProgressIndicator(
                              color: Colors.white,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 15.0,
                    ),
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            car.brand +
                                ", " +
                                car.type +
                                ", " +
                                car.numberOfSeats +
                                " seats",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17.0,
                              fontFamily: "Montserrat",
                            ),
                          ),
                          const SizedBox(
                            height: 12.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                car.mileage + " km/lt",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(5.0),
                                decoration: BoxDecoration(
                                  color: Colors.blue[400],
                                  borderRadius: BorderRadius.circular(20.0),
                                ),
                                child: Text(
                                  "Rs." + car.ratePerDay + "/day",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14.0,
                                    fontFamily: "Montserrat",
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15.0),
                          Row(
                            children: [
                              const Text(
                                "Hide Car: ",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontFamily: "Montserrat",
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await showDialog(
                                    context: context,
                                    builder: (context) => continueDialog(
                                      title: "Hide Car",
                                      message:
                                          "Are you sure you want to continue?",
                                      onYes: () async {
                                        navigatorKey.currentState!.pop();
                                        showDialog(
                                          context: context,
                                          builder: (context) => Column(
                                            mainAxisSize: MainAxisSize.min,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: const [
                                              CircularProgressIndicator(
                                                color: Colors.white,
                                                backgroundColor: Colors.black,
                                              ),
                                            ],
                                          ),
                                        );

                                        try {
                                          await Database.hideCar(
                                            car.hideCar == "true"
                                                ? "false"
                                                : "true",
                                            car.docID,
                                          );
                                          navigatorKey.currentState!.pop();
                                          car.hideCar == "true"
                                              ? getToast(
                                                  message:
                                                      "The car is now hidden from all users",
                                                  color: Colors.green,
                                                )
                                              : getToast(
                                                  message:
                                                      "The car is now visible to all users",
                                                  color: Colors.green,
                                                );
                                        } on CustomException catch (ex) {
                                          navigatorKey.currentState!.pop();
                                          return getToast(
                                            message: "Car couldnot be hidden",
                                            color: Colors.red,
                                          );
                                        }
                                      },
                                      onNo: () {
                                        navigatorKey.currentState!.pop();
                                      },
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                    horizontal: 10.0,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    car.hideCar,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: InkWell(
                                  onTap: () {
                                    navigatorKey.currentState!
                                        .pushNamed(EditCar.id, arguments: {
                                      "type": car.type,
                                      "mileage": car.mileage,
                                      "brand": car.brand,
                                      "numberOfSeats": car.numberOfSeats,
                                      "ratePerDay": car.ratePerDay,
                                      "docID": car.docID,
                                    });
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF5962DA),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          16.0,
                                        ),
                                      ),
                                    ),

                                    child: const Icon(
                                      Icons.description,
                                      color: Colors.white,
                                      size: 20.0,
                                    ),
                                    // ],
                                    // ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: InkWell(
                                  onTap: () async {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (context) => continueDialog(
                                        title: "Delete Car",
                                        message:
                                            "Are you sure you want to continue?",
                                        onYes: () async {
                                          // Navigator.of(context,
                                          //         rootNavigator: true)
                                          //     .pop();
                                          navigatorKey.currentState!.pop();
                                          showDialog(
                                            context: context,
                                            builder: (context) => Column(
                                              mainAxisSize: MainAxisSize.min,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: const [
                                                CircularProgressIndicator(
                                                  color: Colors.white,
                                                  backgroundColor: Colors.black,
                                                ),
                                              ],
                                            ),
                                          );
                                          await Database.deleteCar(
                                            id: car.docID,
                                          );
                                          navigatorKey.currentState!.pop();
                                          getToast(
                                              message:
                                                  "Car successfully deleted",
                                              color: Colors.green);
                                        },
                                        onNo: () {
                                          navigatorKey.currentState!.pop();
                                        },
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFFDA5D59),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          16.0,
                                        ),
                                      ),
                                    ),
                                    child: const Icon(
                                      // Icons.cancel,
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
