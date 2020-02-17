import 'package:flutter/material.dart';
import 'home/BannerBgCustomPath.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import '../localization/localizations.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'notconnected.dart';
import 'package:flutter/services.dart';
class Aboutus extends StatefulWidget {

  @override
  AboutusState createState() {
    return new AboutusState();
  }
}

class AboutusState extends State<Aboutus> {
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
          AppLocalizations.of(context).about, style: TextStyle( color: Colors.white),
        ),
        elevation: 0.0,
        centerTitle: false,
        //backgroundColor: appTheme.primaryColor,
        leading: InkWell(
          child: Icon(Icons.chevron_left , color: Colors.white,),
          onTap: () {
            Navigator.pop(context);
          },
        ),
       
      ),
      body: /*OfflineBuilder(
        connectivityBuilder: (
          BuildContext context,
          ConnectivityResult connectivity,
          Widget child,
        ) {
          final bool connected = connectivity != ConnectivityResult.none;
          if(!connected) return Offline();
          return */SingleChildScrollView(
        child : Container(
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
                              "assets/about.jpg",
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
                        AppLocalizations.of(context).about,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        AppLocalizations.of(context).aboutusdesc,
                        style: TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: Text(
                        AppLocalizations.of(context).ourteam,
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          ChallengeInfo(EvaIcons.personOutline, AppLocalizations.of(context).nadia, AppLocalizations.of(context).doctor),
                          SizedBox(height:10),
                          ChallengeInfo(EvaIcons.personOutline, AppLocalizations.of(context).meriem, AppLocalizations.of(context).doctor),
                          SizedBox(height:10),
                          ChallengeInfo(EvaIcons.personOutline, AppLocalizations.of(context).mohamed, AppLocalizations.of(context).dev),
                          SizedBox(height:15),
                        ],
                      ),
                    ),
                     
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ))
       /*},
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Text(
              'There are no bottons to push :)',
            ),
            new Text(
              'Just turn off your internet.',
            ),
          ],
        ),
      )*/,
    );     
        
      
   
    
     
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
        Icon(iconInfo,color: Colors.grey),
        SizedBox(
          width: 10,
        ),
        Row(
          children: <Widget>[
            Text(
              countInfo,
              style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 10,),
            Text(labelName,
                style: TextStyle(fontSize: 12.0, color: Colors.grey)),
          ],
        ), 
      ],
    );
  }
}
