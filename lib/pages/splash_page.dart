import 'dart:async';
import 'package:observanceapp/customviews/heart.dart';
import 'package:flutter/material.dart';
import 'package:observanceapp/pages/home_page.dart';
import 'package:observanceapp/pages/login_page.dart';
import 'package:observanceapp/pages/language_setup.dart';
import 'package:observanceapp/utils/app_shared_preferences.dart';
import 'package:observanceapp/models/User.dart';
class SplashPage extends StatefulWidget {
  @override
  createState() => new SplashPageState();
}

class SplashPageState extends State<SplashPage> {
  final globalKey = new GlobalKey<ScaffoldState>();
//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    new Future.delayed(const Duration(seconds: 3), _handleTapEvent);
    return new Scaffold(
      key: globalKey,
      body: _splashContainer(),
    );
  }
//------------------------------------------------------------------------------
  Widget _splashContainer() {
    return GestureDetector(
        onTap: _handleTapEvent,
        child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: new BoxDecoration(color: Colors.lightGreen),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SpinKitPumpingHeart( color: Colors.white,),
                
              ],
            )));
  }
//------------------------------------------------------------------------------
  void _handleTapEvent() async {
    bool isLoggedIn = await AppSharedPreferences.isUserLoggedIn();

    String lang = await AppSharedPreferences.getLang();
    if (this.mounted) {
      setState(() {
        if (lang != null) {
        if (isLoggedIn != null && isLoggedIn) {
          User user;
          Future<void> initUserProfile() async {
    User up = await AppSharedPreferences.getUserProfile();
    setState(() {
      user = up;
      
    });
  }
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => new HomePage()),
          );
        } else {
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => new LoginPage()),
          );
        }
        } else {
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => new Languagesetup()),
          );
        }
      });
    }
  }
//------------------------------------------------------------------------------
}
