import 'package:flutter/material.dart';
import 'home/BannerBgCustomPath.dart';
import 'home/mol_name.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'dart:async';
import '../customviews/pulse.dart';
import 'dart:convert';
import 'package:http/http.dart' show get;
import 'dart:ui';
import 'package:observanceapp/customviews/progress_dialog.dart';
import 'package:observanceapp/models/User.dart';
import 'package:observanceapp/pages/splash_page.dart';
import 'package:observanceapp/utils/app_shared_preferences.dart';
import 'package:observanceapp/utils/constants.dart';
import 'about.dart';
import 'settings.dart';
import '../localization/localizations.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'notconnected.dart';
ThemeData appTheme = ThemeData(
  primaryColor: Colors.lightGreen,
  primaryColorDark: Colors.green,
);

const TextStyle goalCountStyle =
    TextStyle(fontSize: 40.0, fontWeight: FontWeight.bold, color: Colors.black);
const TextStyle goalUnitStyle = TextStyle(color: Colors.grey);

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  final globalKey = new GlobalKey<ScaffoldState>();
  User user;
  String typeString;
  String type = '';
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;
  //------------------------------------------------------------------------------

  @override
  Future<void> didChangeDependencies() async {
    super.didChangeDependencies();
    if (user == null) {
      await initUserProfile();
    }
  }

//------------------------------------------------------------------------------

  Future<void> initUserProfile() async {
    User up = await AppSharedPreferences.getUserProfile();
    setState(() {
      user = up;
    });
  }

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

  String getType(String t) {
    if ("1" == t) {
      typeString = "Hémodialysé Chronique";
    } else if ("2" == t) {
      typeString = "Greffé Rénale";
    }
    return typeString;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      appBar: AppBar(
        title: Text(
          'TestObs',
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
        backgroundColor: Colors.lightGreen,
        centerTitle: true,
        elevation: 0.0,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(
            EvaIcons.menuOutline,
            color: Colors.white,
          ),
          onPressed: () => globalKey.currentState.openDrawer(),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              EvaIcons.logOutOutline,
              color: Colors.white,
            ),
            onPressed: () {
              AppSharedPreferences.clear();
              Navigator.pushReplacement(
                globalKey.currentContext,
                new MaterialPageRoute(builder: (context) => new SplashPage()),
              );
            },
          )
        ],
      ),
      drawer: Drawer(

          //padding: EdgeInsets.zero,
          elevation: 10,
          child: Container(
            color: Colors.white,
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 50,
                    ),
                    Image.asset(
                      'assets/kidney_colored.png',
                      width: 100,
                      height: 100,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context).home),
                  dense: true,
                  leading: Icon(EvaIcons.homeOutline),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context).about),
                  dense: true,
                  leading: Icon(EvaIcons.peopleOutline),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Aboutus()),
                    );
                  },
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context).settings),
                  dense: true,
                  leading: Icon(EvaIcons.settings2Outline),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Settings( lname: user.lname, fname: user.fname, email: user.email, uniqud: user.uniqueid, typestr: this.typeString,)),
                    );
                  },
                ),
                ListTile(
                  title: Text(AppLocalizations.of(context).logout),
                  dense: true,
                  leading: Icon(EvaIcons.logInOutline),
                  onTap: () {
                    AppSharedPreferences.clear();
                    Navigator.pushReplacement(
                        globalKey.currentContext,
                        new MaterialPageRoute(
                            builder: (context) => new SplashPage()));
                  },
                ),
              ],
            ),
          )),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 50.0),
          child: Column(
            children: <Widget>[
              BannerSection(
                idusr: user.id,
                fname: user.fname,
                lname: user.lname,
                typestring: getType(user.type),
              ),
              SizedBox(height: 15.0),
              MolName(
                iduser: user.id.toString(),
                type: user.type.toString(),
                typeString: getType(user.type),
              )
            ],
          ),
        ),
          )
    );
  }
}

class BannerSection extends StatefulWidget {
  final String idusr, fname, lname, typestring, typevalue;
  BannerSection(
      {Key key,
      this.idusr,
      this.fname,
      this.lname,
      this.typestring,
      this.typevalue})
      : super(key: key);
  @override
  _BannerSectionState createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> {
//------------------------------------------------------------------------------
  User usr;
  static ProgressDialog progressDialog = ProgressDialog.getProgressDialog(
      ProgressDialogTitles.USER_CHANGE_PASSWORD);

//------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: BannerBgCustomPath(),
            child: Container(
              color: Colors.lightGreen,
              height: 280,
            ),
          ),
          Column(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                margin: EdgeInsets.symmetric(horizontal: 16.0),
                elevation: 10.0,
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 30.0, vertical: 22.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        AppLocalizations.of(context).slt + widget.fname,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.green,fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      new FutureBuilder<List<UserResults>>(
                        future: getUserTesults(this.widget.idusr),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<UserResults> soum = snapshot.data;
                            return new Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: <Widget>[
                                GoalCount(AppLocalizations.of(context).test,
                                    soum[0].good, AppLocalizations.of(context).goodword , Colors.lightGreen),
                                Spacer(),
                                GoalCount(AppLocalizations.of(context).test,
                                    soum[0].normal, AppLocalizations.of(context).normalword, Colors.blueGrey),
                                Spacer(),
                                GoalCount(AppLocalizations.of(context).test,
                                    soum[0].bad, AppLocalizations.of(context).badword, Colors.redAccent)
                              ],
                            );
                          } else if (snapshot.hasError || snapshot.hasData) {
                            return Center(child: Text('Error!'));
                          }
                          //return  a circular progress indicator.
                          return new SpinKitPulse(
                            color: Colors.green,
                          );
                        },
                      ),
                       SizedBox(height: 10.0),
                      Text(
                        AppLocalizations.of(context).resultsdesc,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.grey),
                      ),
                      SizedBox(height: 15.0),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class UserResults {
  final String bad;
  final String normal;
  final String good;

  UserResults({this.bad, this.normal, this.good});

  factory UserResults.fromJson(Map<String, dynamic> jsonData) {
    return UserResults(
        bad: jsonData['bad'],
        normal: jsonData['normal'],
        good: jsonData['good']);
  }
}

Future<List<UserResults>> getUserTesults(String c) async {
  final jsonEndpoint =
      "http://observance-therapeutique.com/app_api/get/getCount.php?u=" +
          c.toString();

  final response = await get(jsonEndpoint);

  if (response.statusCode == 200) {
    List sousmolicules = json.decode(response.body);

    return sousmolicules
        .map((sousmolicule) => new UserResults.fromJson(sousmolicule))
        .toList();
  } else
    throw Exception('We were not able to successfully the data.');
}

class GoalCount extends StatelessWidget {
  final String unit, total, unitName;
  Color txtclr;
  GoalCount(this.unit, this.total, this.unitName, this.txtclr);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              total,
              style: TextStyle(
                  fontSize: 40.0, fontWeight: FontWeight.bold, color: txtclr),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, top: 10),
              child: Text(unitName, style: TextStyle(color: txtclr)),
            )
          ],
        ),
        Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: Text(
                unit,
                style: goalUnitStyle,
                
              ),
            ),
          ],
        )
      ],
    );
  }
}
