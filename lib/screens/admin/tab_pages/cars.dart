import 'package:car_rental/components/car_details_field.dart';
import 'package:car_rental/components/continue_dialog.dart';
import 'package:car_rental/components/custom_button.dart';
import 'package:car_rental/components/custom_text_field.dart';
import 'package:car_rental/constants/constants.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/model/car.dart';
import 'package:car_rental/screens/admin/add_new_car.dart';
import 'package:car_rental/screens/admin/edit_car.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:car_rental/services/database.dart';
import 'package:car_rental/state/car_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
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
            const Padding(
              padding: EdgeInsets.only(
                top: 8.0,
                left: 20.0,
                right: 15.0,
              ),
            ),
            Theme(
              data: Theme.of(context).copyWith(
                  textTheme: const TextTheme().apply(bodyColor: Colors.black),
                  dividerColor: Colors.black,
                  iconTheme: const IconThemeData(color: Colors.white)),
              child: PopupMenuButton<int>(
                color: Colors.white,
                itemBuilder: (BuildContext context) => [
                  const PopupMenuItem<int>(
                    value: 0,
                    child: Text(
                      "About us",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: Colors.black,
                        letterSpacing: 1.8,
                      ),
                    ),
                  ),
                  const PopupMenuItem<int>(
                      value: 1,
                      child: Text(
                        "Help",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          color: Colors.black,
                          letterSpacing: 1.8,
                        ),
                      )),
                  const PopupMenuDivider(),
                  PopupMenuItem<int>(
                      value: 2,
                      child: Row(
                        children: const [
                          Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 7,
                          ),
                          Text(
                            "Sign Out",
                            style: TextStyle(
                              fontFamily: "Montserrat",
                              color: Colors.black,
                              letterSpacing: 1.8,
                            ),
                          )
                        ],
                      )),
                ],
                onSelected: (item) => selectedItem(context, item),
                offset: const Offset(0, 70),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigator.pushNamed(context, AddNewCar.id);
            navigatorKey.currentState!.pushNamed(AddNewCar.id);
          },
          backgroundColor: const Color(0xffd17842),
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
      // Navigator.pushNamedAndRemoveUntil(context, Signin.id, (route) => false);
      navigatorKey.currentState!
          .pushNamedAndRemoveUntil(Signin.id, (route) => false);
      break;
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
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16.0),
                      child: Image.asset(
                        "images/lambo.jpg",
                        height: 100.0,
                        width: 100.0,
                        fit: BoxFit.fill,
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
                            car!.brand +
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
