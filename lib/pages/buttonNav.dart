import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/pages/home.dart';
import 'package:mobileapp/pages/order.dart';
import 'package:mobileapp/pages/profile.dart';
import 'package:mobileapp/pages/wallet.dart';

class buttonNav extends StatefulWidget {
  const buttonNav({super.key});

  @override
  State<buttonNav> createState() => _buttonNavState();
}

class _buttonNavState extends State<buttonNav> {
  int currentTabIndex = 0;
  late List<Widget> pages;
  late Widget currentPage;
  late Home homePage;
  late Profile profile;
  late Order order;
  late Wallet wallet;
  @override
  void initState() {
    homePage = Home();
    order = Order();
    profile = Profile();
    wallet = Wallet();
    pages = [homePage, order, wallet, profile];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: CurvedNavigationBar(
        height: 65,
        backgroundColor: Colors.white,
        color: Colors.black,
        animationDuration: Duration(milliseconds: 500),
        onTap: (int index) {
          setState(() {
            currentTabIndex = index;
            currentPage = pages[index];
          });
        },
        items: [
          Icon(Icons.home_outlined, color: Colors.white),
          Icon(Icons.shopping_cart_outlined, color: Colors.white),
          Icon(Icons.wallet_outlined, color: Colors.white),
          Icon(Icons.person_outline, color: Colors.white),
        ],
      ),
      body: pages[currentTabIndex],
    );
  }
}
