import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:swe2109772_assignment1/database/db_service.dart';
import 'package:swe2109772_assignment1/main_home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swe2109772_assignment1/screens/signup_page.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> {
  late Size mediaSize;
  bool remUser = false;
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 80, top: 30),
              child: Image.asset(
                'assets/images/bg1.png',
                width: 250,
                height: 300,
              ),
            ),
            const SizedBox(height: 18),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50),
              child: Column(
                textDirection: TextDirection.ltr,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome Back',
                    style: TextStyle(
                        color: HexColor("#212A91"),
                        fontSize: 25,
                        fontFamily: 'NotoSerif',
                        fontWeight: FontWeight.w800
                    ),
                  ),
                  const SizedBox(height: 25),
                  TextField(
                    controller: userNameController,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: HexColor("#212A91"),
                        fontSize: 13,
                        fontFamily: 'NotoSerif',
                        fontWeight: FontWeight.w600
                    ),
                    decoration:  InputDecoration(
                      labelText: 'Username',
                      labelStyle: TextStyle(
                          color: HexColor("#212A91"),
                          fontSize: 15,
                          fontFamily: 'NotoSerif',
                          fontWeight: FontWeight.w600
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: HexColor("#212A91"),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: HexColor("#212A91"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: passwordController,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: HexColor("#212A91"),
                        fontSize: 13,
                        fontFamily: 'NotoSerif',
                        fontWeight: FontWeight.w600
                    ),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(
                        color: HexColor("#212A91"),
                        fontSize: 15,
                        fontFamily: 'NotoSerif',
                        fontWeight: FontWeight.w600,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: HexColor("#212A91"),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        borderSide: BorderSide(
                          width: 1,
                          color: HexColor("#212A91"),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                    child: SizedBox(
                      width: 329,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () async {
                          final username = userNameController.text.trim();
                          final password = passwordController.text.trim();

                          if (username.isEmpty || password.isEmpty) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Login Failed'),
                                  content: const Text('Please enter both username and password.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                            return;
                          }

                          final user = await DatabaseService.getUser(username);

                          if (user != null && user['password'] == password) {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            await prefs.setString('username', user['username']);
                            await prefs.setString('email', user['email']);
                            await prefs.setString('phoneNo', user['phoneNo']);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const MainHomePage()),
                                  (Route<dynamic> route) => false,
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Login Failed'),
                                  content: const Text('Invalid username or password'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('OK'),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: HexColor("#212A91"),
                        ),
                        child: const Text(
                          'Sign In',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'NotoSerif',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    children: [
                      Text(
                        'Don’t have an account?',
                        style: TextStyle(
                          color: HexColor("#212A91"),
                          fontSize: 13,
                          fontFamily: 'NotoSerif',
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(
                        width: 2.5,
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Signup()),
                          );
                        },
                        child: Text(
                          'Sign Up Here',
                          style: TextStyle(
                            color: HexColor("#212A91"),
                            fontSize: 13,
                            fontFamily: 'NotoSerif',
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
