// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:car_rental/screens/admin/tab_pages/cars.dart';
import 'package:car_rental/screens/admin/tab_pages/comingup_orders.dart';
import 'package:car_rental/screens/user/tab_pages/home_page.dart';
import 'package:car_rental/screens/user/tab_pages/user_orders.dart';
import 'package:car_rental/screens/user/tab_pages/user_profile.dart';
import 'package:car_rental/services/notification.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';

class UserHomePage extends StatefulWidget {
  static const id = '/userHomePage';
  const UserHomePage({Key? key}) : super(key: key);
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    NotificationHandler.onMessageHandler();
    NotificationHandler.resolveToken();
  }

  @override
  void dispose() {
    super.dispose();
    tabController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get.put(TextController());
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        // dragStartBehavior: DragStartBehavior.down,
        controller: tabController,
        children: [
          HomePage(),
          const UserOrders(),
          const UserProfile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        // backgroundColor: const Color(0xff22232C),
        // selectedItemColor: const Color(0xffd17842),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xff4d4f52),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Requests"),
          BottomNavigationBarItem(
              icon: Icon(EvaIcons.carOutline), label: "Orders"),
          BottomNavigationBarItem(
              icon: Icon(EvaIcons.personOutline), label: "Profile"),
        ],
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
            tabController!.index = _selectedIndex;
          });
        },
      ),
    );
  }
}
