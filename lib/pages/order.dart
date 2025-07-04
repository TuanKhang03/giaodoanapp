import 'package:flutter/material.dart';
import 'package:mobileapp/widget/widget_support.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {


  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
              elevation: 2.0,
              child: Container(
                padding: EdgeInsets.only(bottom: 10.0),
                child: Center(
                  child: Text(
                    "Giỏ hàng",
                    style: AppWidget.HeadlineTextFeildStyle(),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              margin: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Material(
                elevation: 5.0,
                borderRadius: BorderRadius.circular(25),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), 
                  ),
                  child: Row(
                    children: [
                      Container(
                      height: 90,
                      width: 40,
                      decoration: BoxDecoration(border: Border.all(), borderRadius: BorderRadius.circular(25)),
                      child: Center(child: Text("2")),
                    ),
                    SizedBox(width: 20.0,),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Image.asset("images/food.jpg", width: 90, height: 90, fit: BoxFit.cover,),),
                      SizedBox(width: 20.0,),
                      Column(
                        children: [
                          Text("Pizza", style: AppWidget.SemiBoldTextFeildStyle(),),
                            Text("40.000đ", style: AppWidget.SemiBoldTextFeildStyle(),)
                        ],
                      )
                  ],),
                ),
              ),
            ),
            Spacer(),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Tổng tiền: ",style: AppWidget.boldTextFeildStyle(),),
                  Text("40.000đ", style: AppWidget.SemiBoldTextFeildStyle(),)
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10.0),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.black,borderRadius: BorderRadius.circular(10)),
              margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
              child: Center(child: Text("Thanh toán", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.bold),)),
            ),
          ],
        ),
      ),
    );
  }
}
