import 'dart:io';

import 'package:auto_animated/auto_animated.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:ielts_essay/Database/Database.dart';
import 'package:ielts_essay/Model/AnswerModel.dart';
import 'package:ielts_essay/Model/EssayModel.dart';
import 'package:ielts_essay/Model/EssayTypeModel.dart';
import 'package:ielts_essay/Model/QuestionModel.dart';
import 'package:ielts_essay/Model/SuggestionModel.dart';
import 'package:ielts_essay/Screen/QuestionScreen.dart';
import 'package:ielts_essay/Utills/Constants.dart';
import 'package:ielts_essay/Utills/UIUtills.dart';
import 'package:page_transition/page_transition.dart';

import 'SuggestionEssayScreen.dart';

class SuggestionScreen extends StatefulWidget{
  SuggestionScreen({Key key, this.essayModel}) : super(key: key);
  final EssayModel essayModel;
  _SuggestionScreen createState() =>_SuggestionScreen();
}

class _SuggestionScreen extends State<SuggestionScreen>{
  List<AnswerModel> answerList = List();
  List<SuggestionModel> suggestionList = List();

  // List<String> countList = List();
  DatabaseHelper dbHelper = DatabaseHelper.instance;

  final options = LiveOptions(
    delay: Duration(seconds: 0),
    showItemInterval: Duration(milliseconds: 0),
    showItemDuration: Duration(milliseconds: 100),
    visibleFraction: 0.05,
    reAnimateOnVisibility: false,
  );
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FacebookInterstitialAd.loadInterstitialAd(
      placementId: (Platform.isAndroid ? Constants.android_interstitial_id: Constants.ios_interstitial_id),
      listener: (result, value) {
        switch (result) {
          case InterstitialAdResult.ERROR:
            print("Error: $value");
            break;
          case InterstitialAdResult.LOADED:
            FacebookInterstitialAd.showInterstitialAd();
            print("Loaded: $value");
            break;
        }
      },
    );
    suggestionList = widget.essayModel.suggestion;
    answerList = widget.essayModel.answer.where((element) => element.isSuggestion != '0').toList();
    // updateList();
  }
  @override
  Widget build(BuildContext context) {
    UIUtills().updateScreenDimension(width: MediaQuery.of(context).size.width, height: MediaQuery.of(context).size.height);
    // TODO: implement build
    return MaterialApp(
      title: 'Welcome to Flutter',
      home: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/background.png"), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(cW(20), cH(25), cW(40), cH(5)),
                child: Row(
                  children: [
                    IconButton(
                      icon: ImageIcon(AssetImage("assets/back.png")),
                      iconSize: 20,
                      color: Colors.white,
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    Expanded(
                      child: Container(),
                    ),
                    Text('Suggestion',softWrap: true,style: TextStyle(fontSize: 40,color: Colors.white,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),

                  ],
                ),
              ),
              Expanded(
                child: suggestionList.length != 0?Container(
                  padding: EdgeInsets.fromLTRB(cW(30), cH(5), cW(30), 0),
                  child: LiveList.options(
                    options: options,
                    itemCount: suggestionList.length,
                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 15,mainAxisSpacing: 15,childAspectRatio: 16/11),
                    itemBuilder: buildAnimatedItem,
                  ),
                ):Center(
                  child: Text('No Essay Found',softWrap: true,style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w400,fontFamily: 'Poppins'),),
                ),
              ),
              FacebookBannerAd(
                bannerSize: BannerSize.STANDARD,
                keepAlive: true,
                placementId: Platform.isAndroid ? Constants.android_banner_id: Constants.ios_banner_id,
                listener: (result, value) {
                  switch (result) {
                    case BannerAdResult.ERROR:
                      print("Error: $value");
                      break;
                    case BannerAdResult.LOADED:
                      print("Loaded: $value");
                      break;
                    case BannerAdResult.CLICKED:
                      print("Clicked: $value");
                      break;
                    case BannerAdResult.LOGGING_IMPRESSION:
                      print("Logging Impression: $value");
                      break;
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget buildAnimatedItem(BuildContext context, int index, Animation<double> animation,) =>
      FadeTransition(
        opacity: Tween<double>(
          begin: 0,
          end: 1,
        ).animate(animation),
        // And slide transition
        child: SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, -0.1),
            end: Offset.zero,
          ).animate(animation),
          // Paste you Widget
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            elevation: 5,
            child: InkWell(
              child:Container(
                padding: EdgeInsets.fromLTRB(cW(20), cH(5), cW(20), cH(5)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Question : '+(index+1).toString(),textAlign:TextAlign.center,style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.w700,fontFamily: 'Poppins'),),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, cH(4), 0, cH(4)),
                            child: Text(suggestionList[index].question,overflow: TextOverflow.ellipsis,maxLines:8,softWrap:true,style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.w500,fontFamily: 'Poppins'),),
                          ),
                          Row(
                            children: [
                              Text('Type: '+getEssayType(index),textAlign:TextAlign.center,style: TextStyle(fontSize: 12,color: Colors.black45,fontWeight: FontWeight.w400,fontFamily: 'Poppins'),),

                              // Padding(
                              //   padding: EdgeInsets.fromLTRB(cW(20), 0, 0, 0),
                              //   child: Text('Answer Count: '+countList[index],style: TextStyle(fontSize: 12,color: Colors.black45,fontWeight: FontWeight.w400,fontFamily: 'Poppins'),),
                              // ),

                            ],
                          ),
                          // Padding(
                          //   padding: EdgeInsets.fromLTRB(0, cH(2), 0, cH(0)),
                          //   child: Row(
                          //     children: [
                          //       IconButton(
                          //         icon: Icon(
                          //           list[index].isFavourite=='1'?Icons.favorite:Icons.favorite_border,
                          //         ),
                          //         iconSize: 30,
                          //         color: Colors.black,
                          //         onPressed: () {
                          //           setState(() {
                          //             if(list[index].isFavourite=='1'){
                          //               list[index].isFavourite='0';
                          //               dbHelper.updateFavouriteQuestions(list[index].id);
                          //             }else{
                          //               list[index].isFavourite='1';
                          //               dbHelper.insertQuestion(list[index]);
                          //             }
                          //           });
                          //
                          //         },
                          //       ),
                          //       Padding(
                          //         padding: EdgeInsets.fromLTRB(cW(15), 0, 0, 0),
                          //         child:
                          //         IconButton(
                          //           icon: Icon(
                          //             list[index].isSaved=='1'?Icons.add_circle:Icons.add_circle_outline,
                          //           ),
                          //           iconSize: 30,
                          //           color: Colors.black,
                          //           onPressed: () {
                          //             setState(() {
                          //               if(list[index].isSaved=='1'){
                          //                 list[index].isSaved='0';
                          //                 dbHelper.updateSavedQuestions(list[index].id);
                          //               }else{
                          //                 list[index].isSaved='1';
                          //                 dbHelper.insertQuestion(list[index]);
                          //               }
                          //             });
                          //
                          //           },
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),

                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: IconButton(
                        icon: Icon(
                          Icons.more_horiz,
                        ),
                        iconSize: 30,
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                        color: Colors.black,

                        onPressed: () {
                          Navigator.push(
                              context,
                              PageTransition(
                                  type: PageTransitionType.rightToLeft,
                                  child: SuggestionEssayScreen(suggestionModel: suggestionList[index], position: index,essayType:getEssayType(index),answer:getAnswer(index))));

                          // Navigator.push(
                          //     context,
                          //     new MaterialPageRoute(
                          //         builder: (BuildContext context) =>
                          //         new QuestionScreen(data: widget.data, questionModel: list[index], position: index,essayType:widget.essayType.type.toString())));
                        },
                      ),
                    ),
                    // Text('Quest',textAlign: TextAlign.start,)

                  ],
                ),
              ),
              onTap: (){
                // Navigator.push(
                //     context,
                //     new MaterialPageRoute(
                //         builder: (BuildContext context) =>
                //         new EssayTypeScreen(data: (widget.data.question.where((j) => j.typeId == widget.data.essayType[index].id).toList()))));
              },
            ),
          ),
        ),
      );
  
  getEssayType(int index){
    print('------------------------------');

    String questionId = widget.essayModel.answer.firstWhere((element) => element.id == suggestionList[index].answerId).questionId;
    print(questionId);
    String typeId = widget.essayModel.question.firstWhere((element) => element.id == questionId).typeId.split(',')[0];
    print(typeId);
    String type = widget.essayModel.essayType.firstWhere((element) => element.id == typeId).type;
    print(typeId);
    return type;
  }

  getAnswer(int index){
    return widget.essayModel.answer.firstWhere((element) => element.id == suggestionList[index].answerId).answer;
  }
  /*updateList(){
    // list = (widget.data.question.where((j) => j.typeId == widget.essayType.id).toList());
    countList = List.generate(list.length, (index) => '');
    print(list.length);
    for(int i=0;i<list.length;i++){
      countList[i] = (widget.essayModel.answer.where((j) => j.questionId == list[i].id).toList()).length.toString();
    }
    if(list.length != 0){
      dbHelper.getQuestions().then((value){
        print(" dbHelper  "+value.length.toString());
        for(int i = 0;i<value.length;i++){
          for(int j=0;j<list.length;j++){
            if(list[j].id == value[i].id){
              setState(() {
                list[j] = value[i];
              });

              break;
            }
          }
          // list[i] = (list.where((j) => j.id == value[i].id)).toList()[0];
        }
      });
    }
  }*/
}