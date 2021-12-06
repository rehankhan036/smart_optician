import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:smart_optician/common_function/nav_functions.dart';
import 'package:smart_optician/common_function/snackbar.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? firstName;
  String? lastName;
  String? email;
  String? address;
  String? phoneNumber;
  bool isUploaded = false;
  late firebase_storage.Reference refChild;
  String? imageAddress =
      'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png';
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerAddress = TextEditingController();
  final TextEditingController _controllerPhoneNum = TextEditingController();
  final imagePicker = ImagePicker();
  var imagePath1;
  String? link1;
  var image1;

  Future getImage(BuildContext _buildContext, Size size) async {
    image1 = await imagePicker.getImage(
        preferredCameraDevice: CameraDevice.front, source: ImageSource.gallery);

    setState(() {
      imagePath1 = image1.path;
    });
    if (image1 != null) {}
  }

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      firstName = value.get('firstName');
      lastName = value.get('lastName');
      address = value.get('address');
      phoneNumber = value.get('phoneNum');
      imageAddress = value.get('image');
    }).whenComplete(() {
      _controllerFirstName.text = firstName.toString();
      _controllerLastName.text = lastName.toString();
      _controllerAddress.text = address.toString();
      _controllerEmail.text =
          FirebaseAuth.instance.currentUser!.email!.toString();
      _controllerPhoneNum.text = phoneNumber.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {Navigator.pop(context);},
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        title: Text(
          'Profile',
          style: GoogleFonts.rubik(color: Colors.white),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        margin: EdgeInsets.only(top: size.height * 0.02),
        width: size.width,
        height: size.height,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  if (imagePath1 == null)
                    Container(
                      width: size.width * 0.3,
                      height: size.width * 0.3,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: NetworkImage(
                                  'https://upload.wikimedia.org/wikipedia/commons/8/89/Portrait_Placeholder.png'))),
                    ),
                  if (imagePath1 != null)
                    Container(
                      width: size.width * 0.3,
                      height: size.width * 0.3,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade700,
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: FileImage(File(imagePath1)),
                              fit: BoxFit.fill)),
                    ),
                  IconButton(
                    icon: Icon(
                      Icons.camera_alt,
                      color: Colors.grey.shade700,
                    ),
                    onPressed: () {
                      getImage(context, size);
                    },
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextField(
                  controller: _controllerFirstName,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade700,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextField(
                  controller: _controllerLastName,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade700,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextField(
                  controller: _controllerPhoneNum,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade700,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextField(
                  controller: _controllerAddress,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade700,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10)),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: TextField(
                  readOnly: true,
                  controller: _controllerEmail,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade700,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10)),
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              InkWell(
                onTap: isUploaded == false
                    ? () {
                        if (image1 != null) {
                          uploadImage(context);
                        } else {
                          updateData(context);
                        }
                        setState(() {
                          isUploaded = true;
                        });
                      }
                    : null,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  width: size.width,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  height: size.height * 0.06,
                  child: isUploaded == false
                      ? const Text(
                          'Update',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w500),
                        )
                      : const CircularProgressIndicator(
                          color: Colors.white,
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  uploadImage(BuildContext context) async {
    refChild = firebase_storage.FirebaseStorage.instance.ref().child("Users");
    refChild.putFile(File(image1.path)).whenComplete(() async {
      imageAddress = await refChild.getDownloadURL();
      updateData(context);
    });
  }

  updateData(BuildContext context) async {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'firstName': _controllerFirstName.text,
      'lastName': _controllerLastName.text,
      'address': _controllerAddress.text,
      'phoneNum': _controllerPhoneNum.text,
      'image': imageAddress
    }).whenComplete(() {
      showSnackBarSuccess(context, 'Updated');
      goBackPreviousScreen(context);
    });
  }
}
