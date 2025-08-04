import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobileapp/pages/buttonNav.dart';
import 'package:mobileapp/pages/login.dart';
import 'package:mobileapp/pages/service/Shared_pref.dart';
import 'package:mobileapp/pages/service/database.dart';
import 'package:mobileapp/widget/widget_support.dart';
import 'package:random_string/random_string.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String email = "", password = "", name = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Thêm biến để điều khiển ẩn/hiện mật khẩu
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  registration() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      String userId = userCredential.user!.uid;
      Map<String, dynamic> addUserInfo = {
        "name": nameController.text,
        "Email": emailController.text,
        "wallet": "0",
        "Id": userId, // lưu lại nếu muốn, nhưng docId phải là userId
      };
      await DatabaseMethods().addUserDetail(addUserInfo, userId);
      await SharedPreferenceHelper().saveUserName(nameController.text);
      await SharedPreferenceHelper().saveUserEmail(emailController.text);
      await SharedPreferenceHelper().saveUserWallet('0');
      await SharedPreferenceHelper().saveUserID(userId);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => buttonNav()),
      );
    } on FirebaseException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text("Mật khẩu quá yếu!", style: TextStyle(fontSize: 18)),
          ),
        );
      } else if (e.code == 'email đã được sử dụng') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "tài khoản đã tồn tại!",
              style: TextStyle(fontSize: 18),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.5,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2A8C51), Color(0xFF1B5E20)],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 3,
              ),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Text(''),
            ),
            Container(
              margin: EdgeInsets.only(top: 60, left: 20, right: 20),
              child: Column(
                children: [
                  Center(
                    child: Image.asset(
                      'images/logo.png',
                      width: MediaQuery.of(context).size.width / 3.5,
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(height: 40),
                  Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      height: MediaQuery.of(context).size.height / 1.7,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            Text(
                              "Đăng kí",
                              style: AppWidget.HeadlineTextFeildStyle(),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập email';
                                }
                                return null;
                              },
                              controller: nameController,
                              decoration: InputDecoration(
                                hintText: 'Tên đăng nhập',
                                hintStyle: AppWidget.SemiBoldTextFeildStyle(),
                                prefixIcon: Icon(Icons.person_outlined),
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              controller: emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập tên đăng nhập';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                hintText: 'Email',
                                hintStyle: AppWidget.SemiBoldTextFeildStyle(),
                                prefixIcon: Icon(Icons.email_outlined),
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              controller: passwordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập mật khẩu';
                                }
                                return null;
                              },
                              obscureText: _obscurePassword,
                              decoration: InputDecoration(
                                hintText: 'Mật khẩu',
                                hintStyle: AppWidget.SemiBoldTextFeildStyle(),
                                prefixIcon: Icon(Icons.password_outlined),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: 30),
                            TextFormField(
                              controller: confirmPasswordController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Vui lòng nhập lại mật khẩu';
                                }
                                if (value != passwordController.text) {
                                  return 'Mật khẩu nhập lại không khớp';
                                }
                                return null;
                              },
                              obscureText: _obscureConfirmPassword,
                              decoration: InputDecoration(
                                hintText: 'Nhập lại mật khẩu',
                                hintStyle: AppWidget.SemiBoldTextFeildStyle(),
                                prefixIcon: Icon(Icons.password_outlined),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscureConfirmPassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscureConfirmPassword =
                                          !_obscureConfirmPassword;
                                    });
                                  },
                                ),
                              ),
                            ),

                            SizedBox(height: 80),
                            GestureDetector(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  setState(() {
                                    email = emailController.text;
                                    password = passwordController.text;
                                    name = nameController.text;
                                  });
                                  registration();
                                }
                              },
                              child: Material(
                                elevation: 5,
                                borderRadius: BorderRadius.circular(20),
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8),
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Color(0xFF2A8C51),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "ĐĂNG KÍ",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 70),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LogIn()),
                      );
                    },
                    child: Text(
                      "Bạn đã có tài khoản? Đăng nhập ngay",
                      style: AppWidget.SemiBoldTextFeildStyle(),
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
