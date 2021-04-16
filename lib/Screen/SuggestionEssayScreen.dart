import 'dart:io';

import 'package:action_broadcast/action_broadcast.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:ielts_essay/Database/Database.dart';
import 'package:ielts_essay/Model/AnswerModel.dart';
import 'package:ielts_essay/Model/EssayModel.dart';
import 'package:ielts_essay/Model/QuestionModel.dart';
import 'package:ielts_essay/Model/SuggestionModel.dart';
import 'package:ielts_essay/Screen/ModelAnswerScreen.dart';
import 'package:ielts_essay/Utills/Constants.dart';
import 'package:ielts_essay/Utills/UIUtills.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';

class SuggestionEssayScreen extends StatefulWidget{
  SuggestionEssayScreen({Key key,this.suggestionModel, this.answerModel, this.position, this.essayType, this.answer}) : super(key: key);
  final SuggestionModel suggestionModel;
  final int position;
  final String essayType;
  final String answer;
  final AnswerModel answerModel;
  _SuggestionEssayScreen createState() =>_SuggestionEssayScreen();
}

class _SuggestionEssayScreen extends State<SuggestionEssayScreen>{
  List<AnswerModel> answerList = List();
  List<String> countList = List();
  DatabaseHelper dbHelper = DatabaseHelper.instance;

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
    // answerList = (widget.data.answer.where((j) => j.questionId == widget.questionModel.id).toList());

    // updateSavedAndFavList();
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // sendBroadcast('actionChange',extras:{'question':widget.questionModel});
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
                    Text('Suggestion Answer',softWrap: true,style: TextStyle(fontSize: 30,color: Colors.white,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),

                  ],
                ),
              ),
              Expanded(
                child:ListView(
                  padding: EdgeInsets.fromLTRB(cW(30), cH(10), cW(30), cH(10)),
                  scrollDirection: Axis.vertical,
                  physics: AlwaysScrollableScrollPhysics(),
                  children: [

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      elevation: 5,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(cW(20), cH(7), cW(20), cH(7)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text('Question : '+(widget.position+1).toString(),style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w700,fontFamily: 'Poppins')),

                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, cH(7), 0, cH(2)),
                      child:Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(cW(20), cH(5), cW(20), cH(5)),
                          child: Text('Question: \n'+widget.suggestionModel.question,style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500,fontFamily: 'Poppins'),),
                        ),
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.fromLTRB(cW(5), cH(5), cW(5), 0),
                        child:Row(
                          children: [
                            Expanded(
                              child:Card(
                                margin: EdgeInsets.fromLTRB(0, 0, cW(15), 0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.fromLTRB(cW(10), cH(7), cW(10), cH(7)),
                                  child: Text(widget.essayType.toString().toUpperCase(),maxLines: 1,textAlign: TextAlign.center,style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w700,fontFamily: 'Poppins'),),
                                ),
                              ),
                            ),
                            Expanded(
                              child:InkWell(
                                child: Card(
                                  margin: EdgeInsets.fromLTRB(cW(15), 0, 0, 0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 5,
                                  child: Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.fromLTRB(cW(10), cH(7), cW(10), cH(7)),
                                    child: Text('SHARE',textAlign: TextAlign.center,style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w700,fontFamily: 'Poppins'),),
                                  ),
                                ),
                                onTap: (){
                                  Share.share('Question: \n'+widget.suggestionModel.question+'\n\n\nAnswer: \n'+widget.answer+'\n\n\nSuggestion Answer: \n'+widget.suggestionModel.suggestion, subject: 'IELTS Essay');
                                },
                              ),

                            ),
                          ],
                        )
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, cH(7), 0, cH(2)),
                      child:Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(cW(20), cH(5), cW(20), cH(5)),
                          child: Text('Answer: \n'+widget.answer,style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500,fontFamily: 'Poppins'),),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, cH(7), 0, cH(2)),
                      child:Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        elevation: 5,
                        child: Container(
                          padding: EdgeInsets.fromLTRB(cW(20), cH(5), cW(20), cH(5)),
                          child: Text('Suggestion Answer: \n'+widget.suggestionModel.suggestion,style: TextStyle(fontSize: 15,color: Colors.black,fontWeight: FontWeight.w500,fontFamily: 'Poppins'),),
                        ),
                      ),
                    ),


                  ],
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


}