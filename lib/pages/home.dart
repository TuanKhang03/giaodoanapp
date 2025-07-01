import 'dart:math';
import 'package:mobileapp/pages/buttonNav.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/pages/detail.dart';
import 'package:mobileapp/widget/widget_support.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool iceCream = false, pizza = false, salad = false, burger = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Xin chào , TuanKhang",
                  style: AppWidget.boldTextFeildStyle(),
                ),
                Container(
                  margin: EdgeInsets.only(right: 20.0),
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.shopping_cart_outlined,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Text("Món Ăn ngon", style: AppWidget.HeadlineTextFeildStyle()),
            Text(
              "Khám phá và những món ăn tuyệt vời ",
              style: AppWidget.LigthtlineTextFeildStyle(),
            ),
            SizedBox(height: 20.0),
            Container(margin: EdgeInsets.only(right: 20.0), child: showItem()),
            SizedBox(height: 30.0),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Detail()),
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.all(4.0),
                      child: Material(
                        elevation: 5.0,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          padding: EdgeInsets.all(14.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.asset(
                                "images/salad2.png",
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                              Text(
                                "Món rau taco hash",
                                style: AppWidget.SemiBoldTextFeildStyle(),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                "Sạch và tốt",
                                style: AppWidget.LigthtlineTextFeildStyle(),
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                "45.000đ",
                                style: AppWidget.SemiBoldTextFeildStyle(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 15.0),
                  Container(
                    margin: EdgeInsets.all(4.0),
                    child: Material(
                      elevation: 5.0,
                      borderRadius: BorderRadius.circular(20),
                      child: Container(
                        padding: EdgeInsets.all(14.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "images/salad2.png",
                              height: 150,
                              width: 150,
                              fit: BoxFit.cover,
                            ),
                            Text(
                              "Rau Trộn",
                              style: AppWidget.SemiBoldTextFeildStyle(),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "Sạch và tốt",
                              style: AppWidget.LigthtlineTextFeildStyle(),
                            ),
                            SizedBox(height: 5.0),
                            Text(
                              "45.000đ",
                              style: AppWidget.SemiBoldTextFeildStyle(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 30.0),
            Container(
              margin: EdgeInsets.only(right: 20.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.all(5.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "images/salad2.png",
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 20.0),
                      Column(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              "Rau trộn gà địa trung hải",
                              style: AppWidget.SemiBoldTextFeildStyle(),
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              "Sạch và tốt",
                              style: AppWidget.LigthtlineTextFeildStyle(),
                            ),
                          ),
                          SizedBox(width: 5.0),
                          Container(
                            width: MediaQuery.of(context).size.width / 2,
                            child: Text(
                              "36.000đ",
                              style: AppWidget.SemiBoldTextFeildStyle(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showItem() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            iceCream = true;
            pizza = false;
            salad = false;
            burger = false;
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: iceCream ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              height: 40,
              width: 40,
              child: Image.asset(
                "images/ice-cream.png",
                fit: BoxFit.cover,
                color: iceCream ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            iceCream = false;
            pizza = true;
            salad = false;
            burger = false;
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: pizza ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              height: 40,
              width: 40,
              child: Image.asset(
                "images/pizza.png",
                fit: BoxFit.cover,
                color: pizza ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            iceCream = false;
            pizza = false;
            salad = true;
            burger = false;
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: salad ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              height: 40,
              width: 40,
              child: Image.asset(
                "images/salad.png",
                fit: BoxFit.cover,
                color: salad ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            iceCream = false;
            pizza = false;
            salad = false;
            burger = true;
            setState(() {});
          },
          child: Material(
            elevation: 5.0,
            borderRadius: BorderRadius.circular(10),
            child: Container(
              decoration: BoxDecoration(
                color: burger ? Colors.black : Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.all(8),
              height: 40,
              width: 40,
              child: Image.asset(
                "images/burger.png",
                fit: BoxFit.cover,
                color: burger ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
