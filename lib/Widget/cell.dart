
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ielts_essay/Utills/UIUtills.dart';

class Cell extends StatelessWidget{
  String title;
  String subTitle;
  Cell({this.title,this.subTitle});
  @override
  Widget build(BuildContext context) {
    UIUtills().updateScreenDimension(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height);

    return Card(
      elevation: 15,
      child: Padding(
        padding: EdgeInsets.fromLTRB(cW(15), cH(10), cW(15), cH(10)),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, cH(3)),
              child: Text(title,style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.w700),),),
            Text(subTitle,style: TextStyle(fontSize: 12,color: Colors.black54),),
          ],
        ),
      )
    );
  }

}