import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xchange/logic/controller/nav_controller.dart';
import 'package:xchange/presentation/home/home_page.dart';
import 'package:xchange/presentation/barter/barter_list.dart';
import 'package:xchange/presentation/wallet/wallet_screen.dart';
import 'package:xchange/presentation/chat/chat_list.dart';
import 'package:xchange/presentation/profile/profile_screen.dart';
import 'package:xchange/core/app_color.dart';

class BottomNavScreen extends StatelessWidget {
  final NavController controller = Get.put(NavController());

  final List<Widget> screens = [
     HomePage(),
    BarterListScreen(),
    const WalletScreen(),
    ChatListScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
      backgroundColor: darkBackgroundColor,
      body: screens[controller.currentIndex.value],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: controller.currentIndex.value,
        onTap: controller.changeTabIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.swap_horiz),
            label: "Barter",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_wallet),
            label: "Wallet",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    ));
  }
}
