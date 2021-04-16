
import 'dart:io';

import 'package:auto_animated/auto_animated.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/ad/ad_interstitial.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ielts_essay/Database/Database.dart';
import 'package:ielts_essay/Model/EssayModel.dart';
import 'package:ielts_essay/Model/EssayTypeModel.dart';
import 'package:ielts_essay/Screen/EssayListScreen.dart';
import 'package:ielts_essay/Screen/EssayScreen.dart';
import 'package:ielts_essay/Screen/EssayTypeScreen.dart';
import 'package:ielts_essay/Screen/SuggestionScreen.dart';
import 'package:ielts_essay/Utills/Constants.dart';
import 'package:ielts_essay/Utills/UIUtills.dart';
import 'package:ielts_essay/Widget/cell.dart';
import 'package:mailto/mailto.dart';
import 'package:page_transition/page_transition.dart';
import 'package:share/share.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingScreen extends StatefulWidget{
  SettingScreen({Key key}) : super(key: key);
  _SettingScreen createState() =>_SettingScreen();
}

class _SettingScreen extends State<SettingScreen>{
  List<String> list = List();
  final options = LiveOptions(
    delay: Duration(seconds: 0),
    showItemInterval: Duration(milliseconds: 0),
    showItemDuration: Duration(milliseconds: 200),
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
    list.add("Rate Us");
    list.add("Feed back");
    list.add("Suggestion");
    list.add("Share");
    // list.add("Suggestion\nAnswer");
    // list.add("Settings");
    // list.add("More");
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
                    Text('Settings',softWrap: true,style: TextStyle(fontSize: 40,color: Colors.white,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),

                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(cW(30), 0, cW(30), 0),
                  child: LiveGrid.options(
                    options: options,
                    itemCount: list.length,
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
                child:Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: Text(list[index],textAlign:TextAlign.center,style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.w700,fontFamily: 'Poppins'),),
                    ),
                  ],
                ),
                onTap: (){
                  switch(index){
                    case 0:
                      appReview();
                      break;
                    case 1:
                      launchMailto();
                      break;
                    case 2:
                      appReview();
                      break;
                    case 3:
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
                      Share.share('check out app\nhttps://play.google.com/store/apps/details?id=com.manthanvanani.ieltsessaywriting"');
                      break;
                    case 4:

                      break;
                  }
                },
              ),)
        ),
      );

  appReview(){
    StoreRedirect.redirect(androidAppId: "com.manthanvanani.ieltsessaywriting",
        iOSAppId: "1550612823");
  }
  launchMailto() async {
    final mailtoLink = Mailto(
      to: ['manthanvannai9442@gmail.com'],
      // cc: ['cc1@example.com', 'cc2@example.com'],
      subject: 'suggestion',
      body: '',
    );
    await launch('$mailtoLink');
  }
}