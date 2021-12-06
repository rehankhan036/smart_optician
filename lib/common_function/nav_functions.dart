import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_optician/model/search_model.dart';

screenPush(BuildContext context, Widget widget){
  Navigator.push(context, MaterialPageRoute(builder: (context)=> widget));
}

screenPushRep(BuildContext context, Widget widget){
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> widget));
}


goBackPreviousScreen(BuildContext context){
  Navigator.pop(context);
}


List<SearchModel> searchData = [];