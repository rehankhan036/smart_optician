import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_optician/common_function/snackbar.dart';
import 'package:smart_optician/firebase/firebase_auth/auth.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerLName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerPhoneNum = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  signUp(BuildContext context) {
    if (_controllerName.text.isEmpty) {
      showSnackBarFailed(context, 'Name is required');
    } else if (_controllerLName.text.isEmpty) {
      showSnackBarFailed(context, 'Last name is required');
    } else if (_controllerEmail.text.isEmpty) {
      showSnackBarFailed(context, 'Email is required');
    } else if (_controllerAddress.text.isEmpty) {
      showSnackBarFailed(context, 'Address is required');
    } else if (_controllerPhoneNum.text.isEmpty) {
      showSnackBarFailed(context, 'Phone num is required');
    } else if (_controllerPassword.text.isEmpty) {
      showSnackBarFailed(context, 'Password is required');
    } else {
      AuthOperations().signUp(
          context: context,
          email: _controllerEmail.text,
          password: _controllerPassword.text,
          firstName: _controllerName.text,
          lastName: _controllerLName.text,
          address: _controllerAddress.text,
          phoneNum: _controllerPhoneNum.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child: Scaffold(
      backgroundColor: Colors.white.withOpacity(0.95),
      body: Container(
        width: size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * 0.04,
              ),
              Container(
                  alignment: Alignment.center,
                  width: size.width * 0.32,
                  height: size.width * 0.32,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 2,
                            spreadRadius: 2,
                            offset: Offset(1, 1))
                      ]),
                  child: Image.asset('assets/images/logo.png')),
              const SizedBox(
                height: 17,
              ),
              Text(
                "Sign Up",
                style: GoogleFonts.rubik(
                  color: Colors.black,
                  fontWeight: FontWeight.w700,
                  fontSize: size.width * 0.05,
                ),
              ),
              SizedBox(
                height: size.height * 0.034,
              ),
              Container(
                width: size.width,
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _controllerName,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    hintText: "First name",
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                width: size.width,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _controllerLName,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    hintText: "Last name",
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                width: size.width,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _controllerEmail,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    hintText: "Enter your email",
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                width: size.width,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _controllerAddress,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.home,
                      color: Colors.black,
                    ),
                    hintText: "Address",
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                width: size.width,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _controllerPhoneNum,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                    hintText: "Enter your phone number",
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.01,
              ),
              Container(
                width: size.width,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.black, width: 0.1),
                    borderRadius: BorderRadius.circular(10)),
                child: TextField(
                  controller: _controllerPassword,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(
                      Icons.vpn_key,
                      color: Colors.black,
                    ),
                    hintText: "Enter your password",
                  ),
                ),
              ),
              SizedBox(
                height: size.height * 0.06,
              ),
              InkWell(
                onTap: () {
                  signUp(context);
                },
                child: Container(
                  width: size.width * 0.9,
                  height: size.height * 0.07,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Text(
                    'Sign up',
                    style: GoogleFonts.cabin(
                      color: Colors.white,
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  width: size.width * 0.9,
                  height: size.height * 0.07,
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: Text(
                    'Login',
                    style: GoogleFonts.cabin(
                      color: Colors.white,
                      fontSize: size.width * 0.045,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
