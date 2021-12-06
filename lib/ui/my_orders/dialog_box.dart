import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:smart_optician/common_function/snackbar.dart';

class CustomDialogBox extends StatefulWidget {
  final String? placeId;
  const CustomDialogBox({Key? key, required this.placeId}) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  String rating = '';
  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height * 0.35,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40), color: Colors.white),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text(
            "Rate this product",
            style: TextStyle(
              color: Colors.black,
              fontSize: size.width * 0.065,
              fontWeight: FontWeight.w500,
            ),
          ),
          Container(
              margin: EdgeInsets.only(
                  top: size.height * 0.03, left: size.width * 0.03),
              width: size.width,
              child: RatingBar.builder(
                initialRating: 3,
                itemSize: size.width * 0.09,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.black,
                ),
                onRatingUpdate: (rat) {
                  setState(() {
                    rating = rat.toString();
                  });
                },
              )),
          SizedBox(
            height: size.height * 0.03,
          ),
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: 'Write your review',
            ),
          ),
          InkWell(
            onTap: () {
              if (_controller.text.isNotEmpty && rating.length > 1) {
              } else {
                showSnackBarFailed(context, 'Rating or review is missing');
              }
            },
            child: Container(
              margin: EdgeInsets.only(top: size.height * 0.034),
              alignment: Alignment.center,
              width: size.width * 0.65,
              height: size.height * 0.06,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10), color: Colors.black),
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
