
import 'dart:io';

import 'package:auto_animated/auto_animated.dart';
import 'package:device_info/device_info.dart';
import 'package:facebook_audience_network/ad/ad_banner.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:flutter_advertising_id/flutter_advertising_id.dart';
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
import 'package:page_transition/page_transition.dart';

import 'SettingScreen.dart';

class HomeScreen extends StatefulWidget{
  HomeScreen({Key key, this.title}) : super(key: key);
  final String title;
  _HomeScreen createState() =>_HomeScreen();
}

class _HomeScreen extends State<HomeScreen>{
  List<EssayTypeModel> essayTypeList = List();
  EssayModel essayModel= EssayModel();
  List<String> list = List();
  List<String> subList = List();
  DatabaseHelper dbHelper = DatabaseHelper.instance;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

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
    _firebaseMessaging.configure(
      onMessage: (message) async{
        print(message);

        setState(() {
          // messageTitle = message["notification"]["title"];
          // notificationAlert = "New Notification Alert";
        });

      },
      onResume: (message) async{
        print(message);
        setState(() {
          // messageTitle = message["data"]["title"];
          // notificationAlert = "Application opened from Notification";
        });

      },
      onLaunch: (message) async{
        print(message);

      },

    );
    FacebookAudienceNetwork.init(
      testingId: '858e366c-bcf6-4c02-a92c-15808a253c20', //optional
    );
    list.add("Essay Type");
    list.add("Essay List");
    list.add("Save Essay");
    list.add("Favourite Essay");
    list.add("Suggestion\nAnswer");
    list.add("Settings");
    // list.add("More");

    subList.add("   Type");
    subList.add("   Essays");
    subList.add("   Essays");
    subList.add("   Essays");
    subList.add("");
    subList.add("");
    // subList.add("");
    loadEssayData().then((value){
      setState(() {
        essayModel = value;
        essayTypeList = value.essayType;
      });
      subList[0] = (value.essayType.length.toString()+" Type");
      subList[1] = (value.question.length.toString()+" Essays");
    });
    updateSavedAndFavList();

    // print(loadEssayData());
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
                      Expanded(
                        child: Container(),
                      ),
                      Text('IELTS ESSAY',softWrap: true,style: TextStyle(fontSize: 40,color: Colors.white,fontWeight: FontWeight.w600,fontFamily: 'Poppins'),),

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
                    padding: EdgeInsets.fromLTRB(0, 0, 0, subList[index] == ''?0:cH(7)),
                    child: Text(list[index],textAlign:TextAlign.center,style: TextStyle(fontSize: 17,color: Colors.black,fontWeight: FontWeight.w700,fontFamily: 'Poppins'),),
                  ),
                  subList[index] == ''?Container():
                  Text(subList[index],style: TextStyle(fontSize: 15,color: Colors.black45,fontWeight: FontWeight.w500,fontFamily: 'Poppins'),),
                ],
              ),
              onTap: () async {
                switch(index){
                  case 0:

                  // Navigator.push(
                  //     context,
                  //     new MaterialPageRoute(
                  //         builder: (BuildContext context) =>
                  //         new EssayTypeScreen(data: essayModel)));
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: EssayTypeScreen(data: essayModel))).then((value) => {
                              updateSavedAndFavList()
                    });

                    break;
                  case 1:
                    // String deviceId = await _getId();
                    // print('deviceId : ' +deviceId);
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: EssayListScreen(essayModel: essayModel, flag: 1,))).then((value) => {
                      updateSavedAndFavList()
                    });

                    break;
                  case 2:
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: EssayListScreen(essayModel: essayModel, flag: 2,))).then((value) => {
                      updateSavedAndFavList()
                    });

                    break;
                  case 3:
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: EssayListScreen(essayModel: essayModel, flag: 3,))).then((value) => {
                      updateSavedAndFavList()
                    });

                    break;
                  case 4:
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: SuggestionScreen(essayModel: essayModel))).then((value) => {
                      updateSavedAndFavList()
                    });
                    break;
                  case 5:
                    Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: SettingScreen()));
                    break;

                }
              },
            ),)
    ),
  );

  updateSavedAndFavList(){
    dbHelper.getSavedQuestions().then((value){
      setState(() {
        subList[2] = (value.length.toString()+" Essays");
      });

    });
    dbHelper.getFavouriteQuestions().then((value){
      setState(() {
        subList[3] = (value.length.toString()+" Essays");
      });

    });
  }
  Future<String> _getId() async {
    String advertisingId;
    // bool isLimitAdTrackingEnabled;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // try {
    //   advertisingId = await FlutterAdvertisingId.advertisingId;
    // } on PlatformException {
    //   advertisingId = 'Failed to get platform version.';
    // }
    if (!mounted) return '';
    print('advertisingId : '+advertisingId);
    // print('isLimitAdTrackingEnabled : '+isLimitAdTrackingEnabled.toString());

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Theme
        .of(context)
        .platform == TargetPlatform.iOS) {
      IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
      return iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else {
      AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;

      return androidDeviceInfo.androidId; // unique ID on Android
    }
  }


}