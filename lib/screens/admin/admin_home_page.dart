// import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:car_rental/screens/admin/tab_pages/cars.dart';
import 'package:car_rental/screens/admin/tab_pages/history.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'tab_pages/requests_page.dart';

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
          Requests(),
          Cars(),
          History(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: const Color(0xffd17842),
        unselectedItemColor: const Color(0xff4d4f52),
        showSelectedLabels: true,
        showUnselectedLabels: false,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(EvaIcons.homeOutline), label: "Requests"),
          BottomNavigationBarItem(
              icon: Icon(EvaIcons.carOutline), label: "Cars"),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: "History"),
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
