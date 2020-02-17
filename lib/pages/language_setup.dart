import "package:flutter/material.dart";
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:observanceapp/pages/splash_page.dart';
import '../localization/LocaleHelper.dart';

class Languagesetup extends StatefulWidget {
  @override
  LanguagesetupState createState() {
    return new LanguagesetupState();
  }
}

class LanguagesetupState extends State<Languagesetup> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: 650,
            child: RotatedBox(
              quarterTurns: 2,
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [Colors.lightGreen, Colors.lightGreen.shade200],
                    [Colors.green.shade200, Colors.green.shade200],
                  ],
                  durations: [19440, 10800],
                  heightPercentages: [0.20, 0.25],
                  blur: MaskFilter.blur(BlurStyle.solid, 10),
                  gradientBegin: Alignment.bottomLeft,
                  gradientEnd: Alignment.topRight,
                ),
                waveAmplitude: 0,
                size: Size(
                  double.infinity,
                  double.infinity,
                ),
              ),
            ),
          ),
          ListView(
            children: <Widget>[
              Container(
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon( EvaIcons.bookOpenOutline, color: Colors.white70, size: 70,),
                    SizedBox( height: 20,),
                    Text("S'il vous plaît Choisissez votre langue",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0)),
                        SizedBox( height: 20,),
                        Text("من فضلك اختر لغتك",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0)),
                        SizedBox( height: 20,),
                    // This goes to the build method
                    Row(
                       mainAxisAlignment: MainAxisAlignment.center,
                       children: <Widget>[
                         Container(
                      //width: 50,
                      padding: EdgeInsets.all(10.0),
                      child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          color: Colors.white,
                          onPressed: () {
                            helper.onLocaleChanged(new Locale("ar"));
                            setLocale(lang: 'ar');
                            Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new SplashPage()),
                            );
                          },
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                          child: Text('العربية')),
                    ),
                    Container(
                      //width: 50,
                      padding: EdgeInsets.all(10.0),
                      child: RaisedButton(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          color: Colors.white,
                          onPressed: () {
                            helper.onLocaleChanged(new Locale("en"));
                            setLocale(lang: 'en');
                            Navigator.pushReplacement(
                              context,
                              new MaterialPageRoute(
                                  builder: (context) => new SplashPage()),
                            );
                          },
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40.0))),
                          child: Text('Français')),
                    ),

                       ],
                    ),
                    
                  ],
                ),
              ),
              
              
            ],
          ),
        ],
      ),
    );
  }

  void setLocale({String lang}) async {
    print("longage is: $lang");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("lang", lang);
  }
}
