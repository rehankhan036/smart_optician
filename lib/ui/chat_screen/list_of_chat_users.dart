import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';

import 'chat_screen.dart';

class ListOfChatUsers extends StatefulWidget {
  final color;
  const ListOfChatUsers({Key? key, this.color}) : super(key: key);

  @override
  _ListOfChatUsersState createState() => _ListOfChatUsersState();
}

class _ListOfChatUsersState extends State<ListOfChatUsers> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: widget.color,
          centerTitle: true,
          title: const Text(
            'CHATS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          elevation: 1,
        ),
        body: Column(
          children: [
            Expanded(
                child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('messages')
                  //sender
                  .doc(FirebaseAuth.instance.currentUser!.uid.toString())
                  // receiver
                  .collection('contacts')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  return const Center(
                    child: Text("Network error"),
                  );
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.size,
                    itemBuilder: (context, index) {
                      final String type =
                          snapshot.data!.docs[index]['type'] as String;
                      final Timestamp _timeStamp =
                          snapshot.data!.docs[index]['date'] as Timestamp;
                      final hours = _timeStamp.toDate().hour > 12
                          ? _timeStamp.toDate().hour - 12
                          : _timeStamp.toDate().hour;
                      final minutes =
                          _timeStamp.toDate().minute.toString().length == 1
                              ? '0${_timeStamp.toDate().minute}'
                              : _timeStamp.toDate().minute;
                      final time = _timeStamp.toDate().hour > 12 ? 'PM' : 'AM';

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatScreenWithUser(
                                receiverId: snapshot.data!.docs[index]
                                    ['receiverId'],
                                receiverName: snapshot.data!.docs[index]['name']
                                    as String,
                              ),
                            ),
                          );
                        },
                        child: StreamBuilder(
                          stream: users
                              .doc(
                                  '${snapshot.data!.docs[index]['receiverId']}')
                              .snapshots(),
                          builder: (context, AsyncSnapshot snapshot2) {
                            int onlineState = 0;
                            if (snapshot2.hasData) {
                              // onlineState = snapshot2.data['userState'] as int;
                            }
                            return Container(
                              height: size.height * 0.1,
                              margin: const EdgeInsets.only(bottom: 4),
                              padding: EdgeInsets.symmetric(
                                  vertical: size.height * 0.01,
                                  horizontal: size.width * 0.02),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 1,
                                    offset: Offset(0, 1),
                                  )
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            right: size.width * 0.01),
                                        width: size.width * 0.14,
                                        height: size.width * 0.14,
                                        decoration: const BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle),
                                        child: Text(
                                          snapshot.data!.docs[index]['name']
                                              .toString()
                                              .toUpperCase()
                                              .substring(0, 1),
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: size.width * 0.06,
                                          ),
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            snapshot.data!.docs[index]['name']
                                                    .toString()
                                                    .toUpperCase()
                                                    .substring(0, 1) +
                                                snapshot
                                                    .data!.docs[index]['name']
                                                    .toString()
                                                    .substring(1),
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontSize: size.width * 0.04,
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          if (type == 'text')
                                            Expanded(
                                              child: Text(
                                                snapshot
                                                    .data!.docs[index]['text']
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.035,
                                                ),
                                                maxLines: 2,
                                              ),
                                            ),
                                          if (type == 'image')
                                            SizedBox(
                                              width: size.width * 0.62,
                                              child: Text(
                                                'Image',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.035,
                                                ),
                                                maxLines: 2,
                                              ),
                                            ),
                                          if (type == 'voice')
                                            SizedBox(
                                              width: size.width * 0.62,
                                              child: Text(
                                                'Voice message',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: size.width * 0.035,
                                                ),
                                                maxLines: 2,
                                              ),
                                            )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        "$hours:$minutes $time",
                                        style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w500,
                                          fontSize: size.width * 0.037,
                                        ),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.02,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ))
          ],
        ),
      ),
    );
  }
}
