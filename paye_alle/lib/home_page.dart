import 'package:flutter/material.dart';
import 'package:paye_alle/qrscanner.dart';
import 'cart.dart';

import 'home.dart';
//import 'product_list_tab.dart';
//import 'shopping_cart_tab.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController pageController=PageController();
  List<Widget> _pages=[HomePage1(),QrCodeScanner(),Cart()];

  int selectIndex=0;
  void onPageChanged(int index){
    setState(() {
      selectIndex=index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      if (selectIndex != 0) {
        setState(() {
          selectIndex = 0;
        });
        return false;
      }
      return false;
    },
    child: Scaffold(
      body: _pages[selectIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectIndex,
      backgroundColor: Color(0xffc8e6c9),
      showUnselectedLabels: false,
      selectedItemColor: Color(0xff009688),
      iconSize: 35,
      onTap: onPageChanged,
      items: [
      BottomNavigationBarItem(
        icon: Icon(Icons.home,
        color: selectIndex == 0 ? Color(0xff009688) : Color(0xff757575),),
        label: 'Home'
      ),

      BottomNavigationBarItem(
        icon: Icon(Icons.qr_code_scanner_sharp,
        color: selectIndex == 1 ? Color(0xff009688) : Color(0xff757575),),
        label: 'Scan',
      ),


      BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart_outlined,
        color: selectIndex == 2 ? Color(0xff009688) : Color(0xff757575),),
        label: 'Cart',
      ),
      ],
      )
    )
    );
  }
}
