import 'package:flutter/material.dart';
import 'package:mobileapp/widget/widget_support.dart';

class Detail extends StatefulWidget {
  const Detail({super.key});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  int a = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.only(top: 50, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back_ios_new_outlined,
                color: Colors.black,
              ),
            ),
            Image.asset(
              "images/salad2.png",
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              fit: BoxFit.fill,
            ),
            SizedBox(height: 15),

            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Món rau taco hash",
                      style: AppWidget.SemiBoldTextFeildStyle(),
                    ),
                    Text(
                      "gà trộn salad",
                      style: AppWidget.boldTextFeildStyle(),
                    ),
                  ],
                ),
                Spacer(),
                GestureDetector(
                  onTap: () {
                    if (a > 1) {
                      --a;
                    }

                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.remove, color: Colors.white),
                  ),
                ),
                SizedBox(width: 20),
                Text(a.toString(), style: AppWidget.SemiBoldTextFeildStyle()),
                SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    ++a;
                    setState(() {});
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.add, color: Colors.white),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Gà trộn salad là một món ăn phổ biến, kết hợp hài hòa giữa vị ngọt mềm của thịt gà và sự tươi mát, giòn ngon của các loại rau củ. Đây là lựa chọn ưa thích cho những ai theo đuổi chế độ ăn uống lành mạnh, hay đơn giản là muốn một bữa ăn nhẹ nhàng,",
              maxLines: 3,
              style: AppWidget.LigthtlineTextFeildStyle(),
            ),
            SizedBox(height: 30),
            Row(
              children: [
                Text(
                  "Thời gian vận chuyển",
                  style: AppWidget.SemiBoldTextFeildStyle(),
                ),
                SizedBox(width: 25),
                Icon(Icons.alarm, color: Colors.black54),
                SizedBox(width: 5),
                Text("30 phút", style: AppWidget.SemiBoldTextFeildStyle()),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Tổng tiền",
                        style: AppWidget.SemiBoldTextFeildStyle(),
                      ),
                      Text(
                        "45.000 VND",
                        style: AppWidget.HeadlineTextFeildStyle(),
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Thêm vào giỏ hàng",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: 'Roboto',
                          ),
                        ),
                        SizedBox(width: 30),
                        Container(
                          padding: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(width: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
