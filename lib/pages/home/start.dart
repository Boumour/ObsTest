import 'package:flutter/material.dart';
import 'BannerBgCustomPath.dart';
import '../obs_test/quiz.dart';
import '../../localization/localizations.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import '../notconnected.dart';
class StartTest extends StatefulWidget {
  final String idmol, idsmol, idmed, namemed, typeus, iduser;
  StartTest(
      {Key key, this.iduser,this.idmol, this.idsmol, this.idmed, this.namemed, this.typeus})
      : super(key: key);

  @override
  StartTestState createState() {
    return new StartTestState();
  }
}

class StartTestState extends State<StartTest> {
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
    return Scaffold(
      appBar: AppBar(
      
        title: Text(
          AppLocalizations.of(context).start, style: TextStyle( color: Colors.white),
        ),
        elevation: 0.0,
        centerTitle: false,
        leading: InkWell(
          child: Icon(Icons.chevron_left , color: Colors.white,),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        
      ),
      body:SingleChildScrollView(
         child: 
      Container(
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: BannerBgCustomPath(),
            child: Container(
              color: Colors.lightGreen,
              height: 300,
            ),
          ),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10)),
                      child: Stack(
                        children: <Widget>[
                          Container(
                            height: 200,
                            width: MediaQuery.of(context).size.width,
                            child: Image.asset(
                              "assets/nurse.jpg",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Text(
                        widget.namemed + ' ' + AppLocalizations.of(context).test,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        AppLocalizations.of(context).testdesc,
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 20.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ChallengeInfo(Icons.group, '6', AppLocalizations.of(context).qst),
                          ChallengeInfo(Icons.card_giftcard, AppLocalizations.of(context).normal, AppLocalizations.of(context).level),
                          ChallengeInfo(Icons.group, '1', AppLocalizations.of(context).minute)
                        ],
                      ),
                    ),
                     Container(
            width: double.infinity,
            padding: EdgeInsets.all(30.0),
            child: RaisedButton(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Quiz1( idmed :widget.idmed , idmol: widget.idmol , idsmol:widget.idsmol, idtype: widget.typeus, idusr: widget.iduser,)),
                );
              },
              elevation: 11,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(40.0))),
              child: Text(AppLocalizations.of(context).start, style: TextStyle(color: Colors.green)),
            ),
          ),
                  ],
                ),
              ),
            ),
          ),
         
        ],
      ),
    ),
          ));   
  }
}

class ChallengeInfo extends StatelessWidget {
  final IconData iconInfo;
  final String countInfo, labelName;
  ChallengeInfo(this.iconInfo, this.countInfo, this.labelName);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        //Icon(iconInfo,color: Colors.green),
        SizedBox(
          width: 10,
        ),
        Column(
          children: <Widget>[
            Text(
              countInfo,
              style: TextStyle(
                  fontSize: 20.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            Text(labelName,
                style: TextStyle(fontSize: 12.0, color: Colors.grey)),
          ],
        )
      ],
    );
  }
}
