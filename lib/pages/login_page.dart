
import 'package:flutter/material.dart';
import 'package:observanceapp/customviews/progress_dialog.dart';
import 'package:observanceapp/futures/app_futures.dart';
import 'package:observanceapp/models/base/EventObject.dart';
import 'package:observanceapp/pages/home_page.dart';
import 'package:observanceapp/pages/register_page.dart';
import 'package:observanceapp/utils/app_shared_preferences.dart';
import 'package:observanceapp/utils/constants.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import '../localization/localizations.dart';
class LoginPage extends StatefulWidget {
  @override
  createState() => new LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final globalKey = new GlobalKey<ScaffoldState>();

  ProgressDialog progressDialog =
      ProgressDialog.getProgressDialog("");

  TextEditingController emailController = new TextEditingController(text: "");

  TextEditingController passwordController =
      new TextEditingController(text: "");

//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        key: globalKey,
        backgroundColor: Colors.white,
        body: new Stack(
          children: <Widget>[
            Container(
            height: 650,
            child: RotatedBox(
              quarterTurns: 2,
              child: WaveWidget(
                config: CustomConfig(
                    gradients: [
                        [Colors.lightGreen, Colors.lightGreen.shade200],
                        [Colors.green.shade200, Colors.green.shade400],
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
                //height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _appIcon(),
                    Text(AppLocalizations.of(context).login, textAlign: TextAlign.center, style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0
                    )),
                    Card(
                      margin: EdgeInsets.only(left: 30, right:30, top:30),
                      elevation: 11,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                      child: TextField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(EvaIcons.personOutline, color: Colors.black26,),
                          suffixIcon: Icon(EvaIcons.checkmarkCircleOutline, color: Colors.black26,),
                          hintText: AppLocalizations.of(context).lblemail,
                          hintStyle: TextStyle(color: Colors.black26),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.only(left: 30, right:30, top:20),
                      elevation: 11,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                      child: TextField(
                        keyboardType: TextInputType.text,
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(EvaIcons.lockOutline, color: Colors.black26,),
                          suffixIcon: Icon(EvaIcons.checkmarkCircleOutline, color: Colors.black26,),
                          hintText: AppLocalizations.of(context).password,
                          hintStyle: TextStyle(
                            color: Colors.black26,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          ),
                          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(30.0),
                      child: RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        color: Colors.white,
                        onPressed: _loginButtonAction,
                        elevation: 11,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40.0))),
                        child: Text(AppLocalizations.of(context).login, style: TextStyle(
                          color: Colors.green
                        )),
                      ),
                    ),
                    /*Text('forget', style: TextStyle(
                      color: Colors.white
                    ))*/
                  ],
                ),
              ),
              SizedBox(height: 30,),
              Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    GestureDetector(
      onTap: _goToRegisterScreen,
      child: new Container(
          child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      
                      children: <Widget>[
                        Text(AppLocalizations.of(context).notregistred),
                        Text(' ' + AppLocalizations.of(context).register, style: TextStyle( color: Colors.lightGreen),)
                      ],
                    ),
          margin: EdgeInsets.only(bottom: 30.0)),
    ),
                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(AppLocalizations.of(context).notregistred),
                        FlatButton(child: Text(AppLocalizations.of(context).register), textColor: Colors.green, )
                      ],
                    )*/
                  ],
                ),
              )
            ],
          )
            , progressDialog],
        ));
  }



//------------------------------------------------------------------------------

  Widget _appIcon() {
    return new Container(
      //decoration: new BoxDecoration(color: Colors.blue[400]),
      child: new Image(
        image: new AssetImage("assets/ic_launcher.png"),
        height: 170.0,
        width: 170.0,
      ),
      margin: EdgeInsets.only(top: 20.0),
    );
  }



//------------------------------------------------------------------------------
  void _loginButtonAction() {
  String p = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regExp = new RegExp(p);
    if (emailController.text == "") {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text(AppLocalizations.of(context).enteremail),
      ));
      return;
    }

    if (regExp.hasMatch(emailController.text) == false) {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text(AppLocalizations.of(context).entervalidemail),
      ));
      return;
    }

    if (passwordController.text == "") {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text(AppLocalizations.of(context).enterpassword),
      ));
      return;
    }
    FocusScope.of(context).requestFocus(new FocusNode());
    progressDialog.showProgress();
    _loginUser(emailController.text, passwordController.text);
  }

//------------------------------------------------------------------------------
  void _loginUser(String id, String password) async {
    EventObject eventObject = await loginUser(id, password);
    switch (eventObject.id) {
      case EventConstants.LOGIN_USER_SUCCESSFUL:
        {
          setState(() {
            AppSharedPreferences.setUserLoggedIn(true);
            AppSharedPreferences.setUserProfile(eventObject.object);
            globalKey.currentState.showSnackBar(new SnackBar(
              content: new Text(AppLocalizations.of(context).loginsuccessful),
            ));
            progressDialog.hideProgress();
            _goToHomeScreen();
          });
        }
        break;
      case EventConstants.LOGIN_USER_UN_SUCCESSFUL:
        {
          setState(() {
            globalKey.currentState.showSnackBar(new SnackBar(
              content: new Text(AppLocalizations.of(context).loginunsuccessful),
            ));
            progressDialog.hideProgress();
          });
        }
        break;
      case EventConstants.NO_INTERNET_CONNECTION:
        {
          setState(() {
            globalKey.currentState.showSnackBar(new SnackBar(
              content: new Text(AppLocalizations.of(context).nointernet),
            ));
            progressDialog.hideProgress();
          });
        }
        break;
    }
  }

//------------------------------------------------------------------------------
  void _goToHomeScreen() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (context) => new HomePage()),
    );
  }

//------------------------------------------------------------------------------
  void _goToRegisterScreen() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (context) => new RegisterPage()),
    );
  }
//------------------------------------------------------------------------------
}
