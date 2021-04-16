
import 'dart:io';

import 'package:auto_animated/auto_animated.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ielts_essay/Database/Database.dart';
import 'package:ielts_essay/Model/EssayModel.dart';
import 'package:ielts_essay/Model/EssayTypeModel.dart';
import 'package:ielts_essay/Screen/EssayScreen.dart';
import 'package:ielts_essay/Utills/Constants.dart';
import 'package:ielts_essay/Utills/UIUtills.dart';
import 'package:ielts_essay/Widget/cell.dart';
import 'package:page_transition/page_transition.dart';

class EssayTypeScreen extends StatefulWidget{
  EssayTypeScreen({Key key, this.data}) : super(key: key);
  final EssayModel data;
  _EssayTypeScreen createState() =>_EssayTypeScreen();
}

class _EssayTypeScreen extends State<EssayTypeScreen>{
  // List<EssayTypeModel> essayTypeList = List();
  List<String> list = List();
  List<String> subList = List();
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
    list = List.generate(widget.data.essayType.length, (index) => '');
    for(int i=0;i<widget.data.essayType.length;i++){
      list[i] = (widget.data.question.where((j) => j.typeId == widget.data.essayType[i].id).toList().length.toString());
    }

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
                    Text('Essay Type',softWrap: true,style: TextStyle(fontSize: 40,color: Colors.white,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),

                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(cW(30),0, cW(30), 0),
                  child: LiveGrid.options(
                    options: options,
                    itemCount: widget.data.essayType.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 15,mainAxisSpacing: 15,childAspectRatio: 16/11),
                    itemBuilder: buildAnimatedItem,
                  ),
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
              borderRadius: BorderRadius.circular(17.0),
            ),
            elevation: 5,
            child: InkWell(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, cH(7)),
                    child: Text(widget.data.essayType[index].type,maxLines: 2,textAlign:TextAlign.center,style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.w700,fontFamily: 'Poppins'),),
                  ),
                  Text(list[index]+' Essays',style: TextStyle(fontSize: 15,color: Colors.black45,fontWeight: FontWeight.w500,fontFamily: 'Poppins'),),
                ],
              ),
              onTap: (){
                Navigator.push(context,
                    PageTransition(type: PageTransitionType.rightToLeft,
                        child: new EssayScreen(data: widget.data, essayType: widget.data.essayType[index])));
              },
            ),

          ),

        ),
      );
}