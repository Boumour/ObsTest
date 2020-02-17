import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../localization/localizations.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'home_page.dart';
class Offline extends StatefulWidget {
  @override
  OfflineState createState() {
    return new OfflineState();
  }
}

class OfflineState extends State<Offline> {

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
      case ConnectivityResult.wifi:
        setState(() {
          Navigator.pop(context);
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => new HomePage()),
          );
        });
        break;
      case ConnectivityResult.mobile:
        setState(() {
          Navigator.pushReplacement(
            context,
            new MaterialPageRoute(builder: (context) => new HomePage()),
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
    return new WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            body:
            
             new Center(
                child: Container(
                    width: double.infinity,
                    color: Colors.white,
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
                                child: Icon(EvaIcons.wifiOffOutline,
                                        size: 80, color: Colors.green.shade100)
                                    ,
                              ),
                            ),
                            
                            new Transform(
                              transform: new Matrix4.translationValues(
                                  0.0, 30.0 * (1.0 - .1), 0.0),
                              child: new Padding(
                                padding: new EdgeInsets.only(bottom: 75.0),
                                child: new Text(
                                  AppLocalizations.of(context).nointernet,
                                  textAlign: TextAlign.center,
                                  style: new TextStyle(
                                    color: Colors.green.shade300,
                                    //fontFamily: 'FlamanteRomaItalic',
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                            ),
                            
                          ]),
                    )))));
  }
}