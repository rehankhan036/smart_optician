import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_form.dart';
import 'package:flutter_credit_card/credit_card_model.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smart_optician/ui/checkout/stripe_service.dart';

class AddCard extends StatefulWidget {
  @override
  _AddCardState createState() => _AddCardState();
}

class _AddCardState extends State<AddCard> {
  String cardNumber = '';
  String expiryDate = '';
  String cardHolderName = '';
  String cvvCode = '';
  bool isCvvFocused = false;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  List<dynamic> cards = [];
  @override
  void initState() {

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Credit Card",
            style: GoogleFonts.rubik(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CreditCardWidget(
                cardBgColor: Colors.black,
                cardNumber: cardNumber,
                expiryDate: expiryDate,
                cardHolderName: cardHolderName,
                cvvCode: cvvCode,
                showBackView: isCvvFocused,
                textStyle: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w600),
                animationDuration: const Duration(milliseconds: 1000),
                onCreditCardWidgetChange: (CreditCardBrand) {},
                width: size.width * 0.8,
                height: size.height * 0.25,
                //true when you want to show cvv(back) view
              ),
              SizedBox(
                height: size.height * 0.03,
              ),
              CreditCardForm(
                formKey: formKey, // Required
                onCreditCardModelChange: (CreditCardModel data) {
                  setState(() {
                    cardNumber = data.cardNumber;
                    expiryDate = data.expiryDate;
                    cvvCode = data.cvvCode;
                    cardHolderName = data.cardHolderName;
                  });
                }, // Required
                themeColor: Colors.red,
                obscureCvv: true,
                obscureNumber: true,
                isHolderNameVisible: true,
                isCardNumberVisible: true,
                isExpiryDateVisible: true,
                cardNumberDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Number',
                  hintText: 'XXXX XXXX XXXX XXXX',
                ),
                expiryDateDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Expired Date',
                  hintText: 'XX/XX',
                ),
                cvvCodeDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'CVV',
                  hintText: 'XXX',
                ),
                cardHolderDecoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Card Holder',
                ),
                cardHolderName: '',
                cardNumber: cardNumber,
                cvvCode: '',
                expiryDate: '',
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  primary: Colors.black,
                ),
                child: Container(
                  height: size.height * 0.04,
                  alignment: Alignment.center,
                  width: size.width * 0.6,
                  margin: const EdgeInsets.all(8),
                  child: Text('Pay VIA CARD',
                      style: GoogleFonts.rubik(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1,
                          fontSize: size.width * 0.04)),
                ),
                onPressed: () {
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
