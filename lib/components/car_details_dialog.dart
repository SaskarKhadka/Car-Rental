import 'package:car_rental/main.dart';
import 'package:flutter/material.dart';

class CarDetailsDialog extends StatelessWidget {
  final String brand;
  final String type;
  final String totalSeats;
  final String mileage;
  final String registrationNumber;
  final String ratePerDay;
  const CarDetailsDialog(
      {Key? key,
      required this.brand,
      required this.type,
      required this.totalSeats,
      required this.mileage,
      required this.registrationNumber,
      required this.ratePerDay})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      // elevation: 10.0,
      // backgroundColor: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size.width,
            padding: const EdgeInsets.only(
              top: 15.0,
              bottom: 20.0,
              left: 20.0,
              right: 20.0,
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const [
                BoxShadow(
                  color: Colors.white30,
                  offset: Offset(0, 2),
                  blurRadius: 10.0,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // const Padding(
                //   padding: EdgeInsets.only(top: 10.0, left: 20.0),
                //   child: Text(
                //     'Car Details:',
                //     style: TextStyle(
                //       fontFamily: "Montserrat",
                //       fontSize: 24.0,
                //       // color: Colors.blue[400],
                //       color: Colors.white,
                //       letterSpacing: 1.3,
                //       // color: Colors.white,
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: size.height * 0.02,
                // ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    "images/lambo.jpg",
                    height: 100.0,
                    width: 150.0,
                    fit: BoxFit.fill,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.02,
                ),

                // RatingBar.builder(
                //   initialRating: prosData.avgRating,
                //   glowColor: Colors.amber,
                //   itemSize: 20,
                //   unratedColor: Colors.white54,
                //   ignoreGestures: true,
                //   glowRadius: 1,
                //   itemPadding: EdgeInsets.all(5),
                //   minRating: 1,
                //   direction: Axis.horizontal,
                //   allowHalfRating: true,
                //   itemCount: 5,
                //   // itemPadding: EdgeInsets.symmetric(
                //   //     horizontal: 4.0),
                //   itemBuilder: (context, index) => Icon(
                //     EvaIcons.star,
                //     color: Colors.amber,
                //   ),
                //   onRatingUpdate: (rating) {
                //     // proRating = rating;
                //   },
                // ),

                const SizedBox(
                  width: 180,
                  child: Divider(
                    thickness: 2,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(
                  height: size.height * 0.01,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Brand: $brand',
                      style: const TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 16.0,
                        color: Colors.white,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.005,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Type: $type",
                      style: const TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 16.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.005,
                ),
                // Flexible(
                //   child: Padding(
                //     padding: const EdgeInsets.only(left: 16.0),
                //     child: Text(
                //       'Brand: Toyota',
                //       style: const TextStyle(
                //         fontFamily: "Montserrat",
                //         fontSize: 16.0,
                //         color: Colors.white,
                //         letterSpacing: 1.3,
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(
                //   height: size.height * 0.005,
                // ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Total Seats: $totalSeats',
                      style: const TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 16.0,
                        color: Colors.white,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.005,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Mileage: $mileage km/lt',
                      style: const TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 16.0,
                        color: Colors.white,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.005,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Registration: $registrationNumber',
                      style: const TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 16.0,
                        color: Colors.white,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.005,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16.0),
                    child: Text(
                      'Rate: Rs. $ratePerDay/day',
                      style: const TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 16.0,
                        color: Colors.white,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                ),

                SizedBox(
                  height: size.height * 0.035,
                ),
                GestureDetector(
                  onTap: () {
                    navigatorKey.currentState!.pop();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 20.0,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF5962DA),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: const Text(
                      'OK',
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        color: Colors.white,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
