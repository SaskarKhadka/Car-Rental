import 'package:car_rental/components/custom_button.dart';
import 'package:car_rental/components/location_field.dart';
import 'package:car_rental/constants/constants.dart';
import 'package:car_rental/main.dart';
import 'package:car_rental/screens/signin_screen.dart';
import 'package:car_rental/screens/user/available_cars.dart';
import 'package:car_rental/services/authentication.dart';
import 'package:car_rental/state/date_state.dart';
import 'package:car_rental/state/time_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                      // GoogleAuthentication.signOut();
                      // Authentication.signOut();
                      // return;
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
                        "Pickup Time: ${Provider.of<TimeState>(context, listen: true).pickUpTime}",
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
                      // GoogleAuthentication.signOut();
                      // Authentication.signOut();
                      // return;
                      _pickTime(context, true);
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
                      // Authentication.signOut();
                      _pickDate(context, false);
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
                        "Dropoff Time: ${Provider.of<TimeState>(context, listen: true).dropOffTime}",
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
                      // GoogleAuthentication.signOut();
                      // Authentication.signOut();
                      // return;
                      _pickTime(context, false);
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
                        "pickUpTime": Provider.of<TimeState>(
                                scaffoldKey!.currentContext!,
                                listen: false)
                            .pickUpTime,
                        "dropOffTime": Provider.of<TimeState>(
                                scaffoldKey!.currentContext!,
                                listen: false)
                            .dropOffTime,
                        "pickUpLocation": pickUpLocationController.text.trim(),
                        "dropOffLocation":
                            dropOffLocationController.text.trim(),
                      });
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
        DateTime.now().month + 2,
        DateTime.now().day,
      ),
    );
    if (date != null) {
      if (isPickUpDate!) {
        Provider.of<DateState>(context, listen: false)
            .updatePickUpDate("${date.year}/${date.month}/${date.day}");
      } else {
        Provider.of<DateState>(context, listen: false)
            .updateDropOffDate("${date.year}/${date.month}/${date.day}");
      }
    }
  }

  Future<void> _pickTime(BuildContext context, bool? isPickUpTime) async {
    final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!,
          );
        });

    if (pickedTime != null) {
      if (isPickUpTime!) {
        Provider.of<TimeState>(context, listen: false).updatePickUpTime(
            "${pickedTime.hourOfPeriod}:${pickedTime.minute} ${pickedTime.period.name}");
      } else {
        Provider.of<TimeState>(context, listen: false).updateDropOffTime(
            "${pickedTime.hourOfPeriod}:${pickedTime.minute} ${pickedTime.period.name}");
      }
    }
  }
}
