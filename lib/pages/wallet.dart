import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:mobileapp/pages/service/Shared_pref.dart';
import 'package:mobileapp/pages/service/database.dart';
import 'package:mobileapp/widget/app_constant.dart';
import 'package:mobileapp/widget/widget_support.dart';
import 'package:http/http.dart' as http;


class Wallet extends StatefulWidget {
  const Wallet({super.key});

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {
String?wallet , id;
int? add;
TextEditingController amountcontroller = new TextEditingController();
getthesharedpref() async {
     wallet = await SharedPreferenceHelper().getUserWallet();
     id = await SharedPreferenceHelper().getUserID();
    setState(() {
    });
  }
  ontheload()async{
    await getthesharedpref();
    setState(() {
      
    });
  }
  @override
  void initState() {
    ontheload();
    super.initState();
  }


  Map<String, dynamic>? paymentIntent;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: wallet == null? CircularProgressIndicator(): Container(
        margin: EdgeInsets.only(top: 60.0),
        child : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
      Material(
        elevation: 2.0,
        child: Container(
          padding: EdgeInsets.only(bottom: 10.0),  
          child: Center(child: Text("Ví", style: AppWidget.HeadlineTextFeildStyle(),),))),
          SizedBox(height: 30.0,),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: Color(0xfff2f2f2)),
            child: Row(children: [
              Image.asset(
                "images/wallet.png",
                width: 60,
                height: 60, 
                fit: BoxFit.cover,),
                SizedBox(width: 40.0,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Text("Ví của bạn", style: AppWidget.LigthtlineTextFeildStyle(),),
                  SizedBox(height: 5.0,),
                  Text("\$${wallet!}", style: AppWidget.boldTextFeildStyle(),)
                ],),
                
            ],),
          ),
          SizedBox(height: 20.0,),
          Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text("Nạp tiền", style: AppWidget.SemiBoldTextFeildStyle(),),
                ),
                SizedBox(height: 10.0,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: () {
                        makePayment("50000");
                      },
                      child: Container(
                        padding:  EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffe9e2e2)),
                          borderRadius: BorderRadius.circular(5)),
                          child: Text("\$" "50.000", style: AppWidget.SemiBoldTextFeildStyle(),)),
                    ), 
                    GestureDetector(
                      onTap: () {
                        makePayment("100000");
                      },
                      child: Container(
                        padding:  EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffe9e2e2)),
                          borderRadius: BorderRadius.circular(5)),
                          child: Text("\$" "100.000", style: AppWidget.SemiBoldTextFeildStyle(),)),
                    ), 
                      GestureDetector(
                      onTap: () {
                        makePayment("200000");
                      },
                      child: Container(
                        padding:  EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffe9e2e2)),
                          borderRadius: BorderRadius.circular(5)),
                          child: Text("\$" "200.000", style: AppWidget.SemiBoldTextFeildStyle(),)),
                    ), 
                      GestureDetector(
                      onTap: () {
                        makePayment("500000");
                      },
                      child: Container(
                        padding:  EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xffe9e2e2)),
                          borderRadius: BorderRadius.circular(5)),
                          child: Text("\$" "500.000", style: AppWidget.SemiBoldTextFeildStyle(),)),
                    ), 
                  
              ],
            ),

            SizedBox(height: 50.0,),
            GestureDetector(
              onTap: () {
                openEdit(amountcontroller, context, makePayment);
              },
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20.0),
                padding: EdgeInsets.symmetric(vertical: 12.0),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Color(0xff008080), borderRadius: BorderRadius.circular(8)
                ),
                child: Center(child: Text("Nạp tiền", style: TextStyle(color: Colors.white, fontSize: 16.0, fontFamily: 'Roboto',fontWeight:FontWeight.bold),),
              ),),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> makePayment(String amount) async {
    try{
      paymentIntent = await createPaymentIntent(amount, 'VND');
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent!['client_secret'],
          style: ThemeMode.dark,
          merchantDisplayName: 'Adnan'
        )
      ).then((value) => null);
      displayPaymentSheet(amount);
    }catch (e, s) {
      print('exception: $e$s');
    }
  }
  displayPaymentSheet(String amount) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {

        add = int.parse(wallet!) + int.parse(amount);
        await SharedPreferenceHelper().saveUserWallet(add.toString());
        await DatabaseMethods().UpdateUserWallet(id!, add.toString());
        showDialog(context: context, builder:(_) =>AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            Row(children: [
              Icon(Icons.check_circle, color: Colors.green, ), Text('Thanh toán thành công', style: AppWidget.SemiBoldTextFeildStyle(),)
            
            ],)
          ],),
        ));
        await getthesharedpref();

        paymentIntent = null; 
      }).onError((error, stackTrace) {
        print('Error is: $error $stackTrace');
      });
    }on StripeException catch (e){
      print('Error is: $e');
      showDialog(context: context, builder: (_) => AlertDialog(
        content: Text("Thanh toán thất bại"),
      ));
    }catch (e) {
      print('Error is: $e');
    }
  }
  createPaymentIntent(String amount , String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': calculateAmount(amount),
        'currency': currency,
        'payment_method_types[]': 'card',
      };
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization':'Bearer $secretKey',
          'content-Type': 'application/x-www-form-urlencoded'},
          body: body,
      );
      print('Nội dung thanh toán: ${response.body.toString()}');
      return jsonDecode(response.body);
  }
  catch (err) {
      print('Lỗi thanh toán: ${err.toString()}');
    } 
  }
  calculateAmount(String amount){
    final calculatedAmount = (int.parse(amount) * 1).toInt();
    return calculatedAmount.toString();
  }
}


Future openEdit(
  TextEditingController amountcontroller,
  BuildContext context,
  Future<void> Function(String) makePaymentCallback,
) =>
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: SingleChildScrollView(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.cancel)),
                    SizedBox(
                      width: 10.0,
                    ),
                    Center(
                        child: Text("Nạp tiền",
                            style: TextStyle(
                              color: Color(0xff008080),
                              fontWeight: FontWeight.bold,
                            )))
                  ],
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text("Số tiền"),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black38,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    child: TextField(
                      controller: amountcontroller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Nhập số tiền bạn muốn nạp",
                      ),
                    )),
                SizedBox(
                  height: 20.0,
                ),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      makePaymentCallback(amountcontroller.text);
                    },
                    child: Container(
                      width: 100,
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Color(0xff008080),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          "Thanh toán",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );

