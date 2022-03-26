// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:car_rental/screens/admin/tab_pages/cars.dart';
import 'package:car_rental/screens/admin/tab_pages/comingup_orders.dart';
import 'package:car_rental/services/notification.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'tab_pages/orders.dart';

class AdminHomePage extends StatefulWidget {
  static const id = '/AdminHomePage';

  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage>
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
          const OrdersForTodayAndTomorrow(),
          const Orders(),
          Cars(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        // selectedItemColor: const Color(0xffd17842),
        selectedItemColor: Colors.white,
        unselectedItemColor: const Color(0xff4d4f52),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.next_plan_outlined), label: "Coming Up"),
          BottomNavigationBarItem(
              icon: Icon(EvaIcons.archiveOutline), label: "All Orders"),
          BottomNavigationBarItem(
              icon: Icon(EvaIcons.carOutline), label: "Cars"),
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
