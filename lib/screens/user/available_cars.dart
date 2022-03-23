import 'package:car_rental/components/car_details_dialog.dart';
import 'package:car_rental/components/continue_dialog.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/model/car.dart';
import 'package:car_rental/screens/admin/edit_car.dart';
import 'package:car_rental/screens/admin/tab_pages/cars.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/screens/user/payment_screen.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:car_rental/services/database.dart';
import 'package:flutter/material.dart';

class AvailableCars extends StatelessWidget {
  static const String id = "/availableCars";
  final Map<String, dynamic>? args;
  const AvailableCars({Key? key, this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          toolbarHeight: 67,
          elevation: 2,
          shadowColor: Colors.white,
          title: const Padding(
            padding: EdgeInsets.only(
              top: 8.0,
              left: 16.0,
            ),
            child: Text(
              'Available Cars',
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
          ),
          automaticallyImplyLeading: false,
          centerTitle: true,
        ),
        body: Scrollbar(
          child: AvailableCarsStream(
            args: args,
          ),
        ),
      ),
    );
  }
}

class AvailableCarsStream extends StatelessWidget {
  final Map<String, dynamic>? args;
  const AvailableCarsStream({Key? key, this.args}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 20.0,
        left: 20.0,
        right: 20.0,
      ),
      child: StreamBuilder<List<Car?>>(
        stream: Database.availableCarsStream(
            args!["pickUpDate"], args!["dropOffDate"]),
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

              if (car == null) {
                return Container();
              }

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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(right: 18.0),
                                child: InkWell(
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) =>
                                            const CarDetailsDialog(
                                              brand: "brand",
                                              type: "type",
                                              totalSeats: "totalSeats",
                                              mileage: "mileage",
                                              registrationNumber:
                                                  "registrationNumber",
                                              ratePerDay: "ratePerDay",
                                            ));
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
                                    args!["car"] = car.docID;
                                    args!["placedBy"] = Authentication.userID;
                                    args!["timestamp"] =
                                        DateTime.now().toString();
                                    navigatorKey.currentState!
                                        .pushNamed(Payment.id, arguments: args);
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 35,
                                    decoration: const BoxDecoration(
                                      color: Colors.green,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(
                                          16.0,
                                        ),
                                      ),
                                    ),
                                    child: const Icon(
                                      // Icons.cancel,
                                      Icons.check,
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
