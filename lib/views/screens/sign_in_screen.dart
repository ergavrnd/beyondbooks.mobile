import 'dart:developer';

import 'package:ecommerce_app_firebase/views/screens/home_page.dart';
import 'package:flutter/material.dart';

import '../../controller/helper_classes/firebase_auth_helper.dart';
import '../../models/resources.dart';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  TextEditingController user = TextEditingController();
  TextEditingController pass = TextEditingController();

  Future register() async {
    var url =
        Uri.http("10.0.2.2", '/flutter-mobile/register.php', {'q': '{http}'});
    var response = await http.post(url, body: {
      "username": user.text.toString(),
      "password": pass.text.toString(),
    });
    log(
      user.text.toString(),
    );
    var data = json.decode(response.body);
    if (data == "Error") {
      Fluttertoast.showToast(
        backgroundColor: Colors.orange,
        textColor: Colors.white,
        msg: 'User already exit!',
        toastLength: Toast.LENGTH_SHORT,
      );
    } else {
      Fluttertoast.showToast(
        backgroundColor: Colors.green,
        textColor: Colors.white,
        msg: 'Registration Successful',
        toastLength: Toast.LENGTH_SHORT,
      );
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, 'logInScreen');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: ElevatedButton(
              onPressed: () async {
                Map res = await FirebaseAuthHelper.firebaseAuthHelper
                    .SignInAnonymously();
                if (res['user'] != null) {
                  person = res['email'];
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.green,
                      content: Text(
                        'Successfully Sign in as a guest',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                  Navigator.pushReplacementNamed(context, "homePage");
                } else if (res['error'] != null) {
                  try {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        duration: const Duration(microseconds: 500),
                        dismissDirection: DismissDirection.down,
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: Colors.red,
                        content: Text(
                          '${res['error']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  } catch (e, s) {
                    print(s);
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.red,
                      content: Text(
                        'Unsuccessful operation',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Text(
                'Guest',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: Colors.grey.shade600),
              ),
            ),
          ),
        ],
        backgroundColor: const Color.fromRGBO(96, 126, 170, 1),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(
            Icons.arrow_back_ios_rounded,
            size: 20,
          ),
        ),
      ),
      body: Container(
        color: const Color.fromRGBO(96, 126, 170, 1),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Container(
                color: const Color.fromRGBO(96, 126, 170, 1),
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 20, left: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.w900,
                              color: Colors.black),
                        ),
                      ),
                      SizedBox(
                        height: 14,
                      ),
                      Text(
                        'Hey, Welcome to the app, here provide your \nemail and password to sign up.',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 7,
              child: Container(
                decoration: const BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black26,
                          offset: Offset(-1, -2),
                          blurRadius: 15),
                    ],
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(70))),
                child: Form(
                  key: SignInKey,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'User email',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold),
                              contentPadding: const EdgeInsets.all(25),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Icon(
                                  Icons.email_rounded,
                                  size: 25,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              fillColor: Colors.grey.shade200,
                              focusColor: Colors.grey.shade200,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                            ),
                            controller: user,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter your Email...';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              email = val;
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade400,
                                  fontWeight: FontWeight.bold),
                              contentPadding: const EdgeInsets.all(25),
                              prefixIcon: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Icon(
                                  Icons.password,
                                  size: 25,
                                  color: Colors.grey.shade400,
                                ),
                              ),
                              fillColor: Colors.grey.shade200,
                              focusColor: Colors.grey.shade200,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: const BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide:
                                    const BorderSide(color: Colors.white),
                              ),
                              suffix: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    {
                                      if (viewPassword == true) {
                                        viewPassword = false;
                                      } else {
                                        viewPassword = true;
                                      }
                                    }
                                  });
                                },
                                child: (viewPassword == true)
                                    ? const Icon(
                                        Icons.remove_red_eye_outlined,
                                        size: 20,
                                        color: Colors.grey,
                                      )
                                    : const Icon(
                                        Icons.remove_red_eye,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                            obscuringCharacter: '*',
                            obscureText: viewPassword,
                            controller: pass,
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'Please enter your password...';
                              }
                              return null;
                            },
                            onSaved: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GestureDetector(
                            onTap: () {},
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                'Forgot Password?',
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              shadowColor: MaterialStateProperty.all(
                                Colors.black,
                              ),
                              backgroundColor: MaterialStateProperty.all(
                                Colors.black,
                              ),
                            ),
                            onPressed: () => {register()},
                            child: const SizedBox(
                              height: 60,
                              width: double.infinity,
                              child: Align(
                                alignment: Alignment.center,
                                child: Text(
                                  'Sign Up',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height / 4,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                            colors: [
                              Colors.grey.shade50,
                              Colors.grey.shade50,
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    gradient: LinearGradient(
                                        colors: [
                                          Colors.grey.shade50,
                                          Colors.white,
                                        ],
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        offset: const Offset(2, 3),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Transform.scale(
                                        scale: 0.5,
                                        child: Image.asset(
                                          'assets/images/stocks/google.png',
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 0,
                                      ),
                                      Text(
                                        'Continue with Google',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                            color: Colors.grey.shade800),
                                      ),
                                      const SizedBox(
                                        width: 60,
                                      ),
                                      const Icon(
                                        Icons.arrow_forward,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Container(
                                  height: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.grey.shade50,
                                        Colors.white,
                                      ],
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.shade300,
                                        offset: const Offset(2, 3),
                                        blurRadius: 10,
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    children: [
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      Transform.scale(
                                        scale: 0.5,
                                        child: Image.asset(
                                          'assets/images/stocks/fb.png',
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 0,
                                      ),
                                      Text(
                                        'Continue with facebook',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 14,
                                            color: Colors.grey.shade800),
                                      ),
                                      const SizedBox(
                                        width: 45,
                                      ),
                                      const Icon(
                                        Icons.arrow_forward,
                                        size: 30,
                                        color: Colors.black,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
