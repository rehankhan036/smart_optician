import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sound_lite/flutter_sound.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smart_optician/firebase/fire_store/firestore_fun.dart';
import 'components/message_bubble.dart';

class ChatScreenWithUser extends StatefulWidget {
  static const String routeName = 'chat_screen';
  final String? receiverName;
  final receiverId;
  const ChatScreenWithUser({
    required this.receiverId,
    required this.receiverName,
  });
  @override
  _ChatScreenWithUserState createState() => _ChatScreenWithUserState();
}

class _ChatScreenWithUserState extends State<ChatScreenWithUser>
    with WidgetsBindingObserver {
  final messageTextController = TextEditingController();
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  /// Voice recorder variables
  Duration? duration;
  Timer? _timer;
  Timer? _ampTimer;
  late FlutterSoundRecorder _audioRecorder;
  bool voiceIsRecorded = false;

  /// Image variables
  late String messageText;
  XFile? image;
  bool imageIsSelected = false;
  bool fileIsUploading = false;
  @override
  void initState() {
    _audioRecorder = FlutterSoundRecorder();
    Permission.microphone.request().then((value) {
      if (value == PermissionStatus.granted) {
        _audioRecorder.openAudioSession();
      }
    });
    super.initState();

    SchedulerBinding.instance!.addPostFrameCallback((_) async {
      /// set state here online
      FireStoreDatabase()
          .changeState(FirebaseAuth.instance.currentUser!.uid.toString(), 1);
    });

    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _ampTimer?.cancel();
    _audioRecorder.closeAudioSession();
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        FireStoreDatabase()
            .changeState(FirebaseAuth.instance.currentUser!.uid.toString(), 1);

        break;
      case AppLifecycleState.inactive:
        FireStoreDatabase()
            .changeState(FirebaseAuth.instance.currentUser!.uid.toString(), 2);

        break;
      case AppLifecycleState.paused:
        FireStoreDatabase()
            .changeState(FirebaseAuth.instance.currentUser!.uid.toString(), 3);

        break;
      case AppLifecycleState.detached:
        FireStoreDatabase()
            .changeState(FirebaseAuth.instance.currentUser!.uid.toString(), 0);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 1,
        shadowColor: Colors.black,
        title: Text(
          '${widget.receiverName.toString()[0].toUpperCase()}${widget.receiverName.toString().substring(1)}',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
            fontSize: size.width * 0.06,
          ),
        ),
        backgroundColor: Colors.white,
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Row(
                  children: [
                    Icon(
                      Icons.delete,
                      color: Colors.black,
                    ),
                    const Text(
                      'Delete chat',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (fileIsUploading)
              LinearProgressIndicator(
                color: Colors.black,
              ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                  .collection(widget.receiverId.toString())
                  .orderBy('date', descending: false)
                  .snapshots(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final messages = snapshot.data.docs.reversed;
                final List<MessageBubble> messageBubbles = [];

                for (final message in messages) {
                  String messageText = '';
                  String link = '';
                  final String type = message.get('type') as String;
                  if (type == 'text') {
                    messageText = message.get('text') as String;
                  } else {
                    link = message.get('link') as String;
                  }

                  final Timestamp _timeStamp = message.get('date') as Timestamp;
                  final messageSender = message.get('sender');

                  final currentUser = FirebaseAuth.instance.currentUser!.uid;
                  if (currentUser == messageSender) {}
                  final hours = _timeStamp.toDate().hour > 12
                      ? _timeStamp.toDate().hour - 12
                      : _timeStamp.toDate().hour;
                  final minutes =
                      _timeStamp.toDate().minute.toString().length == 1
                          ? '0${_timeStamp.toDate().minute}'
                          : _timeStamp.toDate().minute;
                  final time = _timeStamp.toDate().hour > 12 ? 'PM' : 'AM';
                  final messageBubble = MessageBubble(
                    type: type,
                    text: messageText,
                    link: link,
                    isMe: messageSender ==
                        FirebaseAuth.instance.currentUser!.uid.toString(),
                    time: '$hours:$minutes $time',
                    timestamp: _timeStamp,
                  );
                  //print("currentUser $currentUser messageSender $messageSender");
                  messageBubbles.add(messageBubble);
                }
                return Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    reverse: true,
                    children: messageBubbles,
                  ),
                );
              },
            ),

            /// sender text box
            Container(
              margin: EdgeInsets.only(
                left: size.width * 0.04,
                bottom: 6,
                right: size.width * 0.04,
              ),
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.14),
                    offset: const Offset(2, 2),
                    blurRadius: 2,
                    spreadRadius: 2,
                  )
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (voiceIsRecorded == false)
                    InkWell(
                      onTap: () {
                        selectImage(context, size);
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                            left: 15, right: 10, top: 13, bottom: 10),
                        child: Transform.rotate(
                          angle: 49.4,
                          child: Icon(
                            Icons.attachment_rounded,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  if (imageIsSelected == false && voiceIsRecorded == false)
                    Expanded(
                      child: TextField(
                        maxLines: 20,
                        autofocus: false,
                        minLines: 1,
                        controller: messageTextController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Type a Message",
                          hintStyle: TextStyle(
                            color: const Color(0xffcbcaca),
                            fontSize: size.width * 0.045,
                          ),
                        ),
                      ),
                    ),
                  if (imageIsSelected == true && voiceIsRecorded == false)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Image.file(
                          File(image!.path),
                        ),
                      ),
                    ),
                  if (voiceIsRecorded == true)
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.mic,
                              color: Colors.black,
                            ),
                            SizedBox(
                              width: size.width * 0.03,
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(bottom: size.height * 0.003),
                              child: Text(
                                '${minutes < 10 ? '0$minutes' : '$minutes'}:${localSeconds < 10 ? '0$localSeconds' : '$localSeconds'}',
                                style: TextStyle(fontSize: size.width * 0.04),
                              ),
                            ),
                            SizedBox(
                              width: size.width * 0.05,
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  _timer?.cancel();
                                  voiceIsRecorded = false;
                                  localSeconds = minutes = 0;
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.only(
                                  bottom: size.height * 0.003,
                                ),
                                child: Text(
                                  'click to cancel',
                                  style: TextStyle(
                                    fontSize: size.width * 0.04,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if (voiceIsRecorded == false)
                    InkWell(
                      onTap: () {
                        setState(() {
                          startRecording();
                          Future.delayed(const Duration(milliseconds: 1010),
                              () {
                            voiceIsRecorded = true;
                          });
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(top: 12, bottom: 10),
                        child: const Icon(
                          Icons.mic_none,
                          color: Color(0xffBCD0E2),
                        ),
                      ),
                    ),
                  if (voiceIsRecorded == true)
                    InkWell(
                      onTap: () {
                        stopRecorder(context);
                        setState(() {
                          _timer!.cancel();
                          minutes = 0;
                          localSeconds = 0;
                          voiceIsRecorded = false;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.only(
                          right: 18,
                          bottom: 13,
                        ),
                        child: const Text(
                          'Send',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  if (voiceIsRecorded == false)
                    InkWell(
                      onTap: () {
                        if (messageTextController.text.toString().isNotEmpty &&
                            image == null) {
                          FirebaseFirestore.instance
                              .collection('messages')
                              //sender
                              .doc(FirebaseAuth.instance.currentUser!.uid
                                  .toString())
                              // receiver
                              .collection(widget.receiverId.toString())
                              .add(
                            {
                              'type': 'text',
                              'text': messageTextController.text.toString(),
                              'sender': FirebaseAuth.instance.currentUser!.uid
                                  .toString(),
                              'receiver': widget.receiverId.toString(),
                              'date': DateTime.now(),
                            },
                          );

                          /// it will create chats screen element
                          /// it will create chats history for current user
                          FirebaseFirestore.instance
                              .collection('messages')
                              //sender
                              .doc(FirebaseAuth.instance.currentUser!.uid
                                  .toString())
                              // receiver
                              .collection('contacts')
                              .doc(widget.receiverId.toString())
                              .set(
                            {
                              'type': 'text',
                              'text': messageTextController.text,
                              'name': widget.receiverName,
                              'receiverId': widget.receiverId,
                              'date': DateTime.now(),
                            },
                          );

                          FirebaseFirestore.instance
                              .collection('messages')
                              //sender
                              .doc(widget.receiverId.toString())
                              // receiver
                              .collection('contacts')
                              .doc(FirebaseAuth.instance.currentUser!.uid
                                  .toString())
                              .set(
                            {
                              'type': 'text',
                              'text': messageTextController.text,
                              'name': 'sender',
                              'receiverId':
                                  FirebaseAuth.instance.currentUser!.uid,
                              'date': DateTime.now(),
                            },
                          );

                          FirebaseFirestore.instance
                              .collection('messages')
                              //sender
                              .doc(widget.receiverId.toString())
                              // receiver
                              .collection(FirebaseAuth.instance.currentUser!.uid
                                  .toString())
                              .add(
                            {
                              'type': 'text',
                              'text': messageTextController.text.toString(),
                              'sender': FirebaseAuth.instance.currentUser!.uid
                                  .toString(),
                              'receiver': widget.receiverId.toString(),
                              'date': DateTime.now(),
                            },
                          );

                          messageTextController.text = '';
                        } else {
                          setState(() {
                            fileIsUploading = true;
                            imageIsSelected = false;
                          });
                          firebase_storage.Reference obj = firebase_storage
                              .FirebaseStorage.instance
                              .ref()
                              .child(basename(image!.path));

                          obj.putFile(File(image!.path)).whenComplete(() {
                            obj.getDownloadURL().then((value) {
                              FirebaseFirestore.instance
                                  .collection('messages')
                                  //sender
                                  .doc(FirebaseAuth.instance.currentUser!.uid
                                      .toString())
                                  // receiver
                                  .collection(widget.receiverId.toString())
                                  .add(
                                {
                                  'type': 'image',
                                  'link': value,
                                  'sender': FirebaseAuth
                                      .instance.currentUser!.uid
                                      .toString(),
                                  'receiver': widget.receiverId.toString(),
                                  'date': DateTime.now(),
                                },
                              );

                              FirebaseFirestore.instance
                                  .collection('messages')
                                  //sender
                                  .doc(widget.receiverId.toString())
                                  // receiver
                                  .collection(FirebaseAuth
                                      .instance.currentUser!.uid
                                      .toString())
                                  .add(
                                {
                                  'type': 'image',
                                  'link': value,
                                  'sender': FirebaseAuth
                                      .instance.currentUser!.uid
                                      .toString(),
                                  'receiver': widget.receiverId.toString(),
                                  'date': DateTime.now(),
                                },
                              );

                              /// it will create chats screen element
                              FirebaseFirestore.instance
                                  .collection('messages')
                                  //sender
                                  .doc(FirebaseAuth.instance.currentUser!.uid
                                      .toString())
                                  // receiver
                                  .collection('contacts')
                                  .doc(widget.receiverId.toString())
                                  .set(
                                {
                                  'type': 'image',
                                  'name': widget.receiverName,
                                  'receiverId': widget.receiverId,
                                  'date': DateTime.now(),
                                },
                              );

                              FirebaseFirestore.instance
                                  .collection('messages')
                                  //sender
                                  .doc(widget.receiverId.toString())
                                  // receiver
                                  .collection('contacts')
                                  .doc(FirebaseAuth.instance.currentUser!.uid
                                      .toString())
                                  .set(
                                {
                                  'type': 'image',
                                  'name': 'sender',
                                  'receiverId':
                                      FirebaseAuth.instance.currentUser!.uid,
                                  'date': DateTime.now(),
                                },
                              );
                            });

                            setState(() {
                              image = null;
                              fileIsUploading = false;
                            });
                          });
                        }
                      },
                      child: Container(
                          margin: const EdgeInsets.only(
                              right: 10, top: 5, left: 5, bottom: 5),
                          width: size.width * 0.1,
                          height: size.width * 0.1,
                          child: Icon(
                            Icons.send,
                            color: Colors.black,
                          )),
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void selectImage(BuildContext context, Size size) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            width: size.width,
            height: size.height * 0.15,
            child: Container(
              width: size.width,
              padding: const EdgeInsets.only(top: 10, left: 15, bottom: 5),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);
                      final ImagePicker _picker = ImagePicker();

                      image = await _picker.pickImage(
                          source: ImageSource.camera, imageQuality: 60);
                      if (image != null) {
                        imageIsSelected = true;
                      }
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.camera_alt,
                          color: Colors.black,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Text('Camera'),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InkWell(
                    onTap: () async {
                      Navigator.pop(context);

                      final ImagePicker _picker = ImagePicker();

                      image = await _picker.pickImage(
                          source: ImageSource.gallery, imageQuality: 60);
                      if (image != null) {
                        imageIsSelected = true;
                      }
                      setState(() {});
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.image,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text('Gallery'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  int minutes = 0;
  int localSeconds = 0;

  startRecording() {
    _audioRecorder.startRecorder(
      toFile: '${DateTime.now()}.aac',
    );
    startTimer();
  }

  Future<void> stopRecorder(BuildContext context) async {
    _timer!.cancel();
    final path = await _audioRecorder.stopRecorder();
    print('path =>  $path');
    firebase_storage.Reference obj =
        firebase_storage.FirebaseStorage.instance.ref().child(basename(path!));
    setState(() {
      fileIsUploading = true;
    });
    obj.putFile(File(path)).whenComplete(() {
      obj.getDownloadURL().then((value) {
        FirebaseFirestore.instance
            .collection('messages')
            //sender
            .doc(FirebaseAuth.instance.currentUser!.uid.toString())
            // receiver
            .collection(widget.receiverId.toString())
            .add(
          {
            'type': 'voice',
            'link': value,
            'sender': FirebaseAuth.instance.currentUser!.uid.toString(),
            'receiver': widget.receiverId.toString(),
            'date': DateTime.now(),
          },
        );

        FirebaseFirestore.instance
            .collection('messages')
            //sender
            .doc(widget.receiverId.toString())
            // receiver
            .collection(FirebaseAuth.instance.currentUser!.uid)
            .add(
          {
            'type': 'voice',
            'link': value,
            'sender': FirebaseAuth.instance.currentUser!.uid,
            'receiver': widget.receiverId.toString(),
            'date': DateTime.now(),
          },
        );

        /// it will create chats screen element
        FirebaseFirestore.instance
            .collection('messages')
            //sender
            .doc(FirebaseAuth.instance.currentUser!.uid.toString())
            // receiver
            .collection('contacts')
            .doc(widget.receiverId.toString())
            .set(
          {
            'type': 'voice',
            'name': widget.receiverName,
            'receiverId': widget.receiverId,
            'date': DateTime.now(),
          },
        );

        FirebaseFirestore.instance
            .collection('messages')
            //sender
            .doc(widget.receiverId.toString())
            // receiver
            .collection('contacts')
            .doc(FirebaseAuth.instance.currentUser!.uid.toString())
            .set(
          {
            'type': 'voice',
            'name': 'sender',
            'receiverId': FirebaseAuth.instance.currentUser!.uid,
            'date': DateTime.now(),
          },
        );
      }).whenComplete(() {
        setState(() {
          fileIsUploading = false;
        });
      });
    });
  }

  void startTimer() {
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      print(localSeconds);

      if (localSeconds == 60) {
        localSeconds = 0;
        minutes = minutes + 1;
      }

      setState(() {
        duration = Duration(minutes: minutes, seconds: localSeconds);
      });
      setState(() {
        if (localSeconds == 60) {
          localSeconds = 0;
        } else if (localSeconds >= 0 && localSeconds < 61) {
          localSeconds++;
        }
      });
    });
  }
}
