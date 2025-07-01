// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:mobileapp/pages/home.dart';
import 'package:mobileapp/widget/content_model.dart';
import 'package:mobileapp/widget/widget_support.dart';

class Onboard extends StatefulWidget {
  const Onboard({super.key});

  @override
  State<Onboard> createState() => _OnboardState();
}

class _OnboardState extends State<Onboard> {
  int currentIndex = 0;
  late PageController _controller;
  @override
  void initState() {
    _controller = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _controller,
              itemCount: contests.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, top: 40),
                  child: Column(
                    children: [
                      Image.asset(
                        contests[i].image,
                        height: 450,
                        width: MediaQuery.of(context).size.width,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 40),
                      Text(
                        contests[i].title,
                        style: AppWidget.SemiBoldTextFeildStyle(),
                      ),
                      SizedBox(height: 20),
                      Text(
                        contests[i].description,
                        style: AppWidget.LigthtlineTextFeildStyle(),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contests.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              if (currentIndex == contests.length - 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              }
              _controller.nextPage(
                duration: Duration(milliseconds: 100),
                curve: Curves.bounceIn,
              );
            },
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF2A8C51),
                borderRadius: BorderRadius.circular(20),
              ),
              height: 60,
              margin: EdgeInsets.all(40),
              width: double.infinity,
              child: Center(
                child: Text(
                  "Next",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 18 : 7,
      margin: EdgeInsets.only(right: 5, left: 5, top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: Colors.black38,
      ),
    );
  }
}
