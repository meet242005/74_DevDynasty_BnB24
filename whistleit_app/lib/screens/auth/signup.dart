import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:get/instance_manager.dart';
import 'package:get/route_manager.dart';
import 'package:whistleit_app/screens/auth/signin.dart';

import '../../constants/colors.dart';
import '../home/home.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  TextEditingController _usernameController = new TextEditingController();
  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _password2Controller = new TextEditingController();
  var isPasswordVisible = false;
  var isPassword2Visible = false;

  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Column(
                    children: [
                      SizedBox(
                        height: 100,
                      ),
                      Row(
                        children: [
                          Text(
                            'Hello,',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 30,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text('Welcome to WhistleIt!',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 30,
                              )),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Text('Easily Report,Track and Manage Cases',
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                  color: secondaryColor))
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 60,
                  ),
                  Column(
                    children: [
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                            color: thirdColor,
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: TextFormField(
                            controller: _usernameController,
                            cursorColor: Colors.black,
                            decoration: const InputDecoration(
                              hintText: 'Username',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: secondaryColor),
                              prefixIcon: Icon(
                                Icons.person_outline,
                                color: secondaryColor,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                            color: thirdColor,
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: TextFormField(
                            controller: _emailController,
                            cursorColor: Colors.black,
                            decoration: const InputDecoration(
                              hintText: 'Email',
                              hintStyle: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: secondaryColor),
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: secondaryColor,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                            color: thirdColor,
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: TextFormField(
                            obscureText: isPasswordVisible ? false : true,
                            controller: _passwordController,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: secondaryColor),
                              prefixIcon: const Icon(
                                Icons.password,
                                color: secondaryColor,
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isPasswordVisible = !isPasswordVisible;
                                  });
                                },
                                child: Icon(
                                  isPasswordVisible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: secondaryColor,
                                ),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                            color: thirdColor,
                            border: Border.all(
                              color: Colors.grey.shade200,
                            ),
                            borderRadius: BorderRadius.circular(10)),
                        child: Center(
                          child: TextFormField(
                            obscureText: isPassword2Visible ? false : true,
                            controller: _password2Controller,
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              hintStyle: const TextStyle(
                                  fontWeight: FontWeight.w300,
                                  color: secondaryColor),
                              prefixIcon: const Icon(
                                Icons.password,
                                color: secondaryColor,
                              ),
                              suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isPassword2Visible = !isPassword2Visible;
                                  });
                                },
                                child: Icon(
                                  isPassword2Visible
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: secondaryColor,
                                ),
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      InkWell(
                        onTap: () async {
                          try {
                            Get.dialog(const Center(
                                child: CircularProgressIndicator()));
                            _passwordController.text ==
                                    _password2Controller.text
                                ? await FirebaseAuth.instance
                                    .createUserWithEmailAndPassword(
                                        email: _emailController.text,
                                        password: _passwordController.text)
                                : Get.snackbar(
                                    "Error Signing Up!",
                                    "Passwords do not match",
                                  );

                            await FirebaseAuth.instance.currentUser
                                ?.updateDisplayName(_usernameController.text);

                            await FirebaseFirestore.instance
                                .collection("users")
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .set(
                              {
                                'uid': FirebaseAuth.instance.currentUser!.uid,
                                'name': _usernameController.text,
                                'email': _emailController.text,
                                'is_anonymous': 'false',
                              },
                            );
                            Get.offAll(const Home(),
                                transition: Transition.fadeIn);
                          } on FirebaseAuthException catch (e) {
                            Get.back();
                            Get.snackbar("Error Signing Up!", e.toString());
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                              color: primaryColor,
                              borderRadius: BorderRadius.circular(10)),
                          child: const Center(
                            child: Text(
                              'Register',
                              style: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Already have an account? ',
                            style: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 14,
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              Get.offAll(const SignIn(),
                                  transition: Transition.fadeIn);
                            },
                            child: const Text(
                              'Log In',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: primaryColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 1,
                    color: Colors.grey.shade500,
                  ),
                ),
                const Text(
                  'OR',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 1,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () async {
                try {
                  Get.dialog(const Center(child: CircularProgressIndicator()));
                  await FirebaseAuth.instance.signInAnonymously();
                  await FirebaseFirestore.instance
                      .collection("users")
                      .doc(FirebaseAuth.instance.currentUser!.uid)
                      .set(
                    {
                      'uid': FirebaseAuth.instance.currentUser!.uid,
                      'name': '',
                      'email': '',
                      'is_anonymous': 'true',
                    },
                  );

                  Get.offAll(const Home(), transition: Transition.fadeIn);
                } on FirebaseAuthException catch (e) {
                  Get.snackbar("Error Signing In!", e.toString());
                  Get.back();
                }
              },
              child: Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                    color: primaryColor,
                    borderRadius: BorderRadius.circular(10)),
                child: const Center(
                  child: Text(
                    'Continue Anonymously',
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 15,
                      color: Colors.white,
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
