
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'localization/localizations.dart';
import 'localization/LocaleHelper.dart';
import 'package:observanceapp/pages/splash_page.dart';

void main() {
  //SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp(MyApp());
  //});  
} 

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => new _MyAppState();
}
class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  Locale locale;
  SpecificLocalizationDelegate _specificLocalizationDelegate;

  @override
   void initState() {
//    helper.onLocaleChanged = onLocaleChange;
//    _specificLocalizationDelegate = SpecificLocalizationDelegate(new Locale('ar'));
    this._fetchLocale().then((locale) {
      setState(() {
        this.locale = locale;
        helper.onLocaleChanged = onLocaleChange;
        _specificLocalizationDelegate = SpecificLocalizationDelegate(locale);
      });
    });
    super.initState();
  }

  _fetchLocale() async {
    var prefs = await SharedPreferences.getInstance();
    return Locale(prefs.getString('lang') ?? "en");
  }

 onLocaleChange(Locale locale){
    setState((){
      _specificLocalizationDelegate = new SpecificLocalizationDelegate(locale);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (this.locale == null) {
      return Center(child: CircularProgressIndicator(),);
    } else {
      return MaterialApp(
        title: 'Observance App',
         
         debugShowCheckedModeBanner: false,
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          //app-specific localization
          _specificLocalizationDelegate
        ],
        supportedLocales: [Locale('en'), Locale('ar')],
        locale: _specificLocalizationDelegate.overriddenLocale,
        //_specificLocalizationDelegate.overriddenLocale ,
        theme: ThemeData(

          primarySwatch: Colors.lightGreen,
        ),
        home: new SplashPage(),
      );
    }
  }
}
