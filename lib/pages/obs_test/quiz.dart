import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'qcard.dart';
import 'package:observanceapp/localization/localizations.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import '../notconnected.dart';
var finalScore = 0;
var questionNumber = 0;

class Quiz1 extends StatefulWidget {
  final String idmol, idsmol, idmed,idtype, idusr;
  Quiz1({Key key, this.idmol, this.idsmol, this.idmed, this.idtype, this.idusr }) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    return new Quiz1State();
  }
}

class Quiz1State extends State<Quiz1> {

  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return;
    }

    _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
      case ConnectivityResult.none:
        setState(() {
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => new Offline()),
          );
        });
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }


  @override
  Widget build(BuildContext context) {
    var images = ["morning", "doc", "time", "forget", "pain", "pills"];

    var questions = [
      AppLocalizations.of(context).q1,
      AppLocalizations.of(context).q2,
      AppLocalizations.of(context).q3,
      AppLocalizations.of(context).q4,
      AppLocalizations.of(context).q5,
      AppLocalizations.of(context).q6
    ];

    var choices = [
      [AppLocalizations.of(context).oui, AppLocalizations.of(context).non],
      [AppLocalizations.of(context).oui, AppLocalizations.of(context).non],
      [AppLocalizations.of(context).oui, AppLocalizations.of(context).non],
      [AppLocalizations.of(context).oui, AppLocalizations.of(context).non],
      [AppLocalizations.of(context).oui, AppLocalizations.of(context).non],
      [AppLocalizations.of(context).oui, AppLocalizations.of(context).non],
    ];

    /*var correctAnswers = [
      AppLocalizations.of(context).oui,
    ];*/
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          
          body: SingleChildScrollView(
            child : new Container(
            margin: const EdgeInsets.all(10.0),
            alignment: Alignment.topCenter,
            child: new Column(
              children: <Widget>[
                new Padding(padding: EdgeInsets.all(20.0)),
                new Container(
                  alignment: Alignment.centerRight,
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      new Text(
                        "${AppLocalizations.of(context).question} ${questionNumber + 1} ${AppLocalizations.of(context).sur} ${questions.length}",
                        style: new TextStyle(fontSize: 14.0),
                      ),
                      new IconButton(
                        icon: new Icon(EvaIcons.closeSquareOutline),
                        color: Colors.redAccent[400],
                        onPressed: () {
                          resetQuiz();
                        },
                      ),
                    ],
                  ),
                ),
                new Padding(padding: EdgeInsets.all(20.0)),
                CardQuestions(
                  image: "assets/${images[questionNumber]}.jpg",
                  question: questions[questionNumber],
                ),

                new Padding(padding: EdgeInsets.all(10.0)),

                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                              width: 160,
                              padding: EdgeInsets.all(30.0),
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                color: Colors.white,
                                onPressed: () {
                                  finalScore++;
                        updateQuestion( );
                                },
                                elevation: 11,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(40.0))),
                                child: Text(choices[questionNumber][0],
                                    style: TextStyle(color: Colors.green)),
                              ),
                            ),

                    Container(
                              width: 160,
                              padding: EdgeInsets.all(30.0),
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                color: Colors.white,
                                onPressed: () {
                                  //finalScore++;
                                updateQuestion();
                                },
                                elevation: 11,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(40.0))),
                                child: Text(choices[questionNumber][1],
                                    style: TextStyle(color: Colors.green)),
                              ),
                            ),
               
                  ],
                ),

                new Padding(padding: EdgeInsets.all(10.0)),
              ],
            ),
          ),
          )     
    ));    
  }

  void resetQuiz() {
    setState(() {
      Navigator.pop(context);
      finalScore = 0;
      questionNumber = 0;
    });
  }

  void updateQuestion() {
    setState(() {
      if (questionNumber == 5) {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new Summary(
                      score: finalScore, idmed: this.widget.idmed, idmol: this.widget.idmol, idsmol: this.widget.idsmol, idtype: this.widget.idtype, iduser: this.widget.idusr,
                    )));
      } else {
        questionNumber++;
      }
    });
  }
}

class Summary extends StatefulWidget {
  final int score;
  final String idmol, idsmol, idmed, iduser, idtype;
  Summary({Key key,this.iduser,this.idtype, this.idmol, this.idsmol, this.idmed, @required this.score,  }) : super(key: key);

  @override
  SummaryState createState() {
    return new SummaryState();
  }
}

class SummaryState extends State<Summary> {

  String msg;

void post() async {
var result = await http.get( 
    "http://observance-therapeutique.com/app_api/set/index.php?iduser=${this.widget.iduser}&idtype=${this.widget.idtype}&idmol=${this.widget.idmol}&idsmol=${this.widget.idsmol}&idmed=${this.widget.idmed}&res=${this.widget.score.toString()}",   
);
}
String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;


  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  Future<void> initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      print(e.toString());
    }
    if (!mounted) {
      return;
    }

    _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    switch (result) {
     

      case ConnectivityResult.none:
        setState(() {
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => new Offline()),
          );
        });
        break;
      default:
        setState(() => _connectionStatus = 'Failed to get connectivity.');
        break;
    }
  }

@override
  void initState() {
        initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  post();
  
  super.initState();
  }
  @override
  Widget build(BuildContext context) {
    if (this.widget.score == 0) {
      msg = AppLocalizations.of(context).bon;
    }
    if (this.widget.score == 1 || this.widget.score == 2) {
      msg = AppLocalizations.of(context).moy;
    }
    if (this.widget.score >= 3) {
      msg = AppLocalizations.of(context).mal;
    }
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body:
            
             new Center(
                child: Container(
                    width: double.infinity,
                    color: Colors.green,
                    child: new Opacity(
                      opacity: .9,
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new Transform(
                              transform: new Matrix4.translationValues(
                                  0.0, 50.0 * (1.0 - .1), 0.0),
                              child: new Padding(
                                padding: new EdgeInsets.only(bottom: 25.0),
                                child: Icon(EvaIcons.heart,
                                        size: 80, color: Colors.white54)
                                    ,
                              ),
                            ),
                            new Transform(
                              transform: new Matrix4.translationValues(
                                  0.0, 30.0 * (1.0 - .1), 0.0),
                              child: new Padding(
                                padding: new EdgeInsets.only(
                                    top: 10.0, bottom: 10.0),
                                child: new Text(
                                  AppLocalizations.of(context).result,
                                  style: new TextStyle(
                                    color: Colors.white,
                                    //fontFamily: 'FlamanteRoma',
                                    fontSize: 34.0,
                                  ),
                                ),
                              ),
                            ),
                            new Transform(
                              transform: new Matrix4.translationValues(
                                  0.0, 30.0 * (1.0 - .1), 0.0),
                              child: new Padding(
                                padding: new EdgeInsets.only(bottom: 75.0),
                                child: new Text(
                                  msg,
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                    color: Colors.white,
                                    //fontFamily: 'FlamanteRomaItalic',
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(30.0),
                              child: RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 16.0),
                                color: Colors.white,
                                onPressed: () {
                                  questionNumber = 0;
                                  finalScore = 0;
                                  Navigator.pop(context);
                                },
                                elevation: 11,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(40.0))),
                                child: Text(AppLocalizations.of(context).reset,
                                    style: TextStyle(color: Colors.green)),
                              ),
                            ),
                          ]),
                    )))));
  }
}
