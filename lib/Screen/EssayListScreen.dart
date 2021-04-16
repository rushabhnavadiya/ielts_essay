import 'dart:io';

import 'package:auto_animated/auto_animated.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:ielts_essay/Database/Database.dart';
import 'package:ielts_essay/Model/EssayModel.dart';
import 'package:ielts_essay/Model/EssayTypeModel.dart';
import 'package:ielts_essay/Model/QuestionModel.dart';
import 'package:ielts_essay/Screen/QuestionScreen.dart';
import 'package:ielts_essay/Utills/Constants.dart';
import 'package:ielts_essay/Utills/UIUtills.dart';
import 'package:page_transition/page_transition.dart';
class EssayListScreen extends StatefulWidget{
  EssayListScreen({Key key, this.essayModel, this.flag}) : super(key: key);
  final EssayModel essayModel;
  final int flag;
  _EssayListScreen createState() =>_EssayListScreen();
}

class _EssayListScreen extends State<EssayListScreen>{
  List<QuestionModel> questionList = List();
  List<String> countList = List();
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
    setQuestionList();
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
                    Text(widget.flag==1?'Essay List':widget.flag==2?'Saved Essay':'Favourite Essay',softWrap: true,style: TextStyle(fontSize: 40,color: Colors.white,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),

                  ],
                ),
              ),
              Expanded(
                child: questionList.length != 0?Container(
                  padding: EdgeInsets.fromLTRB(cW(30), cH(5), cW(30), 0),
                  child:ListView.builder(
                      itemCount: questionList.length,
                      itemBuilder: (BuildContext context,int index){
                        return Card(
                          margin: EdgeInsets.fromLTRB(cW(20), 0, cW(20), (index == questionList.length-1)?cH(10):cH(5)),
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
                                          child: Text(questionList[index].question,style: TextStyle(fontSize: 13,color: Colors.black,fontWeight: FontWeight.w500,fontFamily: 'Poppins'),),
                                        ),
                                        Row(
                                          children: [
                                            Text('Type: '+getEssayType(index),softWrap: true,overflow: TextOverflow.fade,textAlign:TextAlign.center,style: TextStyle(fontSize: 12,color: Colors.black45,fontWeight: FontWeight.w400,fontFamily: 'Poppins'),),

                                            Padding(
                                              padding: EdgeInsets.fromLTRB(cW(15), 0, 0, 0),
                                              child: Text('Answer Count: '+(widget.essayModel.answer.where((j) => j.questionId == questionList[index].id).toList()).length.toString(),style: TextStyle(fontSize: 12,color: Colors.black45,fontWeight: FontWeight.w400,fontFamily: 'Poppins'),),

                                            ),



                                          ],
                                        ),
                                        Padding(
                                          padding: EdgeInsets.fromLTRB(0, cH(2), 0, cH(0)),
                                          child: Row(
                                            children: [
                                              IconButton(
                                                icon: ImageIcon(AssetImage(questionList[index].isFavourite=='1'?'assets/star_fill.png':'assets/star.png')),
                                                iconSize: 25,
                                                color: Colors.black,
                                                onPressed: () {
                                                  setState(() {
                                                    if(questionList[index].isFavourite=='1'){
                                                      questionList[index].isFavourite='0';
                                                      dbHelper.updateFavouriteQuestions(questionList[index].id);
                                                    }else{
                                                      questionList[index].isFavourite='1';
                                                      dbHelper.insertQuestion(questionList[index]);
                                                    }
                                                  });

                                                },
                                              ),
                                              Padding(
                                                padding: EdgeInsets.fromLTRB(cW(15), cH(1), 0, 0),
                                                child:
                                                IconButton(
                                                  icon: ImageIcon(AssetImage(questionList[index].isSaved=='1'?'assets/saved.png':'assets/unsaved.png')),
                                                  iconSize: 20,
                                                  color: Colors.black,
                                                  onPressed: () {
                                                    setState(() {
                                                      if(questionList[index].isSaved=='1'){
                                                        questionList[index].isSaved='0';
                                                        dbHelper.updateSavedQuestions(questionList[index].id);
                                                      }else{
                                                        questionList[index].isSaved='1';
                                                        dbHelper.insertQuestion(questionList[index]);
                                                      }
                                                    });

                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

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
                                      color: Colors.black,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          PageTransition(
                                              type: PageTransitionType.rightToLeft,
                                              child: QuestionScreen(data: widget.essayModel, questionModel: questionList[index], position: index,essayType:getEssayType(index))),
                                        ).then((value) => {
                                          setQuestionList()
                                        });

                                        // Navigator.push(
                                        //     context,
                                        //     new MaterialPageRoute(
                                        //         builder: (BuildContext context) =>
                                        //         new QuestionScreen(essayModel: widget.essayModel, questionModel: list[index], position: index,essayType:widget.essayType.type.toString())));
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
                              //         new EssayTypeScreen(data: (widget.essayModel.question.where((j) => j.typeId == widget.essayModel.essayType[index].id).toList()))));
                            },
                          ),
                        );
                      }
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
  getEssayType(int index){
    var list = questionList[index].typeId.split(',').map((String text) => text).toList();
    String type = (widget.essayModel.essayType.where((j) => j.id == (list[0])).toList())[0].type.toString();
    if(type.length > 18){
      type = type.substring(0,18);
    }
    return type;
  }
  setQuestionList(){
    switch(widget.flag){
      case 1:
        questionList = widget.essayModel.question;
        if(questionList.length != 0){
          dbHelper.getQuestions().then((value){
            print(" dbHelper123  "+value.length.toString());
            for(int i = 0;i<value.length;i++){
              for(int j=0;j<questionList.length;j++){
                if(questionList[j].id == value[i].id){
                  setState(() {
                    questionList[j] = value[i];
                  });
                  break;
                }
              }
            }
          });
        }
        break;
      case 2:
        if(widget.essayModel.question.length != 0){
          dbHelper.getSavedQuestions().then((value){
            print(" dbHelper123  "+value.length.toString());
            setState(() {
              questionList = value;
            });
          });
        }
        break;
      case 3:
        if(widget.essayModel.question.length != 0){
          dbHelper.getFavouriteQuestions().then((value){
            print(" dbHelper123  "+value.length.toString());
            setState(() {
              questionList = value;
            });

          });
        }
        break;

    }
  }
}