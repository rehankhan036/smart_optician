import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'custom_image_view.dart';

class MessageBubble extends StatefulWidget {
  final String text;
  final bool isMe;
  final String time;
  final Timestamp timestamp;
  final String type;
  final String link;
  const MessageBubble(
      {required this.timestamp,
      required this.text,
      required this.isMe,
      required this.time,
      required this.type,
      required this.link});

  @override
  State<MessageBubble> createState() => _MessageBubbleState();
}

class _MessageBubbleState extends State<MessageBubble> {
  late AudioPlayer audioPlayer;

  Duration position = Duration(
    seconds: 0,
    minutes: 0,
  );

  Duration totalDuration = Duration(
    seconds: 160,
    minutes: 1,
  );

  @override
  void initState() {
    super.initState();
    audioPlayer = AudioPlayer();

    audioPlayer.onDurationChanged.listen((updatedDuration) {
      setState(() {
        totalDuration = updatedDuration;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((updatedPosition) {
      setState(() {
        position = updatedPosition;
      });
    });

    audioPlayer.onPlayerStateChanged.listen((event) {
      if (event == PlayerState.STOPPED) {
        setState(() {
          icon = Icons.play_arrow;
        });
      }
      if (event == PlayerState.PLAYING) {
        icon = Icons.pause_outlined;
      }
      if (event == PlayerState.PAUSED) {
        audioPlayer.resume();
      }
      if (event == PlayerState.COMPLETED) {
        setState(() {
          icon = Icons.play_arrow;
        });
        audioPlayer.stop();
      }
    });
  }

  late IconData icon = Icons.play_arrow;

  @override
  void dispose() {
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    if (!widget.isMe) {
      /// Receiver Bubble
      if (widget.type == 'text') {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                width: size.width * 0.12,
                height: size.width * 0.12,
                margin: const EdgeInsets.only(
                    left: 5, bottom: 20, right: 7, top: 3),
                decoration:
                    BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                child: Text(
                  'S',
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 15, right: 10, left: 10),
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.67,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.2),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(18),
                    bottomRight: Radius.circular(18),
                    topRight: Radius.circular(18),
                  ),
                ),
                child: Text(
                  widget.text,
                  style: const TextStyle(color: Colors.black, height: 1.5),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  widget.time,
                  style: TextStyle(
                      color: Colors.grey.withOpacity(0.9),
                      fontSize: size.width * 0.03),
                ),
              )
            ],
          ),
        );
      } else if (widget.type == 'image') {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                width: size.width * 0.12,
                height: size.width * 0.12,
                margin: const EdgeInsets.only(
                    left: 5, bottom: 20, right: 7, top: 3),
                decoration:
                    BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                child: Text(
                  'R'.toUpperCase(),
                  style: TextStyle(
                      fontSize: size.width * 0.05, color: Colors.white),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomImageView(
                                link: widget.link,
                              )));
                },
                child: Hero(
                  tag: 'image',
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, right: 10, left: 10),
                    width: size.width * 0.67,
                    height: size.height * 0.3,
                    decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.2),
                        borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(18),
                            bottomRight: Radius.circular(18),
                            topRight: Radius.circular(18))),
                    child: CachedNetworkImage(
                      imageUrl: widget.link,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  widget.time,
                  style: TextStyle(
                      color: Colors.grey.withOpacity(0.9),
                      fontSize: size.width * 0.03),
                ),
              )
            ],
          ),
        );
      } else {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 2),
          child: Row(
            children: [
              Container(
                alignment: Alignment.center,
                width: size.width * 0.12,
                height: size.width * 0.12,
                margin: const EdgeInsets.only(
                    left: 5, bottom: 20, right: 7, top: 3),
                decoration:
                    BoxDecoration(color: Colors.black, shape: BoxShape.circle),
                child: Text(
                  'S'.toString()[0].toUpperCase(),
                  style: TextStyle(
                      fontSize: size.width * 0.05, color: Colors.white),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 15, right: 10, left: 10),
                width: size.width * 0.67,
                height: size.height * 0.08,
                decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.2),
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(18),
                        bottomRight: Radius.circular(18),
                        topRight: Radius.circular(18))),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        playAudio(widget.link);
                      },
                      child: Container(
                        width: size.width * 0.12,
                        height: size.width * 0.12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: size.width * 0.054,
                        ),
                      ),
                    ),
                    Text(
                      (position.toString().split(".").first).length < 6
                          ? "00:00"
                          : position.toString().split(".").first,
                      style: TextStyle(
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: size.width * 0.15,
                      width: size.width * 0.38,
                      child: Slider(
                        value: position.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          if (position.inMilliseconds.toDouble().toString() ==
                              totalDuration.inMilliseconds
                                  .toDouble()
                                  .toString()) {
                            print('kashif....');
                            setState(() {
                              icon = Icons.play_arrow;
                            });
                          }
                        },
                        max: totalDuration.inMilliseconds.toDouble() + 1.0,
                        activeColor: Colors.black,
                        inactiveColor: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 5),
                child: Text(
                  widget.time,
                  style: TextStyle(
                      color: Colors.grey.withOpacity(0.9),
                      fontSize: size.width * 0.03),
                ),
              )
            ],
          ),
        );
      }
    } else {
      /// Sender Bubble
      if (widget.type == 'text') {
        return Container(
          margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 7),
                child: Text(
                  widget.time,
                  style: TextStyle(
                      color: Colors.grey.withOpacity(0.8),
                      fontSize: size.width * 0.03),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 15, right: 10, left: 10),
                constraints: BoxConstraints(
                  maxWidth: size.width * 0.78,
                ),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      topLeft: Radius.circular(18)),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff33CC66),
                      Color(0xff41CD63),
                      Color(0xff4ECF5F),
                      Color(0xff5CD05C),
                      Color(0xff69D259),
                      Color(0xff77D356),
                      Color(0xff85D452),
                      Color(0xff92D64F),
                      Color(0xffA0D74C),
                      Color(0xffADD948),
                      Color(0xffBBDA45)
                    ],

                    // transform:
                  ),
                ),
                child: Text(
                  widget.text,
                  style: const TextStyle(color: Colors.white, height: 1.5),
                ),
              ),
            ],
          ),
        );
      } else if (widget.type == 'image') {
        return Container(
          width: size.width,
          margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 7),
                child: Text(
                  widget.time,
                  style: TextStyle(
                      color: Colors.grey.withOpacity(0.8),
                      fontSize: size.width * 0.03),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CustomImageView(
                                link: widget.link,
                              )));
                },
                child: Hero(
                  tag: 'image',
                  child: Container(
                    padding: const EdgeInsets.only(
                        top: 15, bottom: 15, right: 10, left: 10),
                    width: size.width * 0.78,
                    height: size.height * 0.3,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(18),
                          topRight: Radius.circular(18),
                          topLeft: Radius.circular(18)),
                      gradient: LinearGradient(
                        colors: [
                          Color(0xff33CC66),
                          Color(0xff41CD63),
                          Color(0xff4ECF5F),
                          Color(0xff5CD05C),
                          Color(0xff69D259),
                          Color(0xff77D356),
                          Color(0xff85D452),
                          Color(0xff92D64F),
                          Color(0xffA0D74C),
                          Color(0xffADD948),
                          Color(0xffBBDA45)
                        ],
                        // transform:
                      ),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: widget.link,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        return Container(
          width: size.width,
          margin: const EdgeInsets.only(right: 10, top: 5, bottom: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.only(right: 7),
                child: Text(
                  widget.time,
                  style: TextStyle(
                      color: Colors.grey.withOpacity(0.8),
                      fontSize: size.width * 0.03),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 15, bottom: 15, right: 10, left: 10),
                width: size.width * 0.78,
                height: size.height * 0.08,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(18),
                      topRight: Radius.circular(18),
                      topLeft: Radius.circular(18)),
                  gradient: LinearGradient(
                    colors: [
                      Color(0xff33CC66),
                      Color(0xff41CD63),
                      Color(0xff4ECF5F),
                      Color(0xff5CD05C),
                      Color(0xff69D259),
                      Color(0xff77D356),
                      Color(0xff85D452),
                      Color(0xff92D64F),
                      Color(0xffA0D74C),
                      Color(0xffADD948),
                      Color(0xffBBDA45)
                    ],
                    // transform:
                  ),
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        playAudio(widget.link);
                      },
                      child: Container(
                        width: size.width * 0.12,
                        height: size.width * 0.12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black,
                        ),
                        child: Icon(
                          icon,
                          color: Colors.white,
                          size: size.width * 0.054,
                        ),
                      ),
                    ),
                    Text(
                      (position.toString().split(".").first).length < 6
                          ? "00:00"
                          : position.toString().split(".").first,
                      style: TextStyle(
                          fontSize: size.width * 0.03,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: size.width * 0.15,
                      width: size.width * 0.47,
                      child: Slider(
                        value: position.inMilliseconds.toDouble(),
                        onChanged: (value) {
                          if (position.inMilliseconds.toDouble().toString() ==
                              totalDuration.inMilliseconds
                                  .toDouble()
                                  .toString()) {
                            print('kashif....');
                            setState(() {
                              icon = Icons.play_arrow;
                            });
                          }
                        },
                        max: totalDuration.inMilliseconds.toDouble() + 1.0,
                        activeColor: Colors.black,
                        inactiveColor: Colors.grey,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  playAudio(String url) async {
    if (icon == Icons.play_arrow) {
      audioPlayer.play(url);
    } else {
      audioPlayer.stop();
    }
    setState(() {
      icon = icon == Icons.play_arrow ? Icons.pause_outlined : Icons.play_arrow;
    });
  }
}
