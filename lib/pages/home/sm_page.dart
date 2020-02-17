import 'package:flutter/material.dart';
import 'BannerBgCustomPath.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'cards.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show get;
import '../../customviews/pulse.dart';
import '../../localization/localizations.dart';
import 'med_page.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import '../notconnected.dart';
class SousMolicule {
  final String idsm;
  final String namesm, idmol;

  SousMolicule({this.idsm, this.namesm, this.idmol});

  factory SousMolicule.fromJson(Map<String, dynamic> jsonData) {
    return SousMolicule(
      idsm: jsonData['idsm'],
      namesm: jsonData['namesm'],
      idmol: jsonData['idmol'],
    );
  }
}

class SMList extends StatelessWidget {
  final List<SousMolicule> sousmolicules;
  final String typeUser;
  final String idmol, iduser;

  SMList(this.sousmolicules, this.idmol, this.typeUser, this.iduser);

  Widget build(context) {
    return Container(
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: BannerBgCustomPath(),
            child: Container(
              color: Colors.lightGreen,
              height: 200,
            ),
          ),
          ListView.builder(
              addAutomaticKeepAlives: true,
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemCount: sousmolicules.length,
              itemBuilder: (context, int currentIndex) {
                return createViewItem(sousmolicules[currentIndex], context);
              })
        ],
      ),
    );
  }

  Widget createViewItem(SousMolicule sm, BuildContext context) {
    return new EasyCard(
      prefixBadge: Colors.green,
      title: sm.namesm,
      icon: EvaIcons.folderOutline,
      suffixIcon: Icons.chevron_right,
      suffixIconColor: Colors.green,
      iconColor: Colors.lightGreen,
      titleColor: Colors.black87,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ListMed(
                    iduser: this.iduser,
                    idsmol: sm.idsm,
                    typeus: this.typeUser,
                    idmol: sm.idmol,
                    namesmol: sm.namesm,
                  )),
        );
      },
    );
  }
}

Future<List<SousMolicule>> downloadJSON(String c) async {
  final jsonEndpoint =
      "http://observance-therapeutique.com/app_api/get/getsm.php?sm=" +
          c.toString();

  final response = await get(jsonEndpoint);

  if (response.statusCode == 200) {
    List sousmolicules = json.decode(response.body);
    return sousmolicules
        .map((sousmolicule) => new SousMolicule.fromJson(sousmolicule))
        .toList();
  } else
    throw Exception('We were not able to successfully download the json data.');
}

class ListChallenge extends StatefulWidget {
  final String typeUser;
  final String nammol, idmol, iduser;
  ListChallenge({Key key, this.nammol, this.idmol, this.typeUser, this.iduser})
      : super(key: key);

  @override
  ListChallengeState createState() {
    return new ListChallengeState();
  }
}

class ListChallengeState extends State<ListChallenge> {
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
            widget.nammol,
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0.0,
          centerTitle: false,
          leading: InkWell(
            child: Icon(
              Icons.chevron_left,
              color: Colors.white,
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          
        ),
        body: new FutureBuilder<List<SousMolicule>>(
          future: downloadJSON(this.widget.idmol),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<SousMolicule> soum = snapshot.data;

              return new SMList(soum, this.widget.idmol, this.widget.typeUser, this.widget.iduser);
            } else if (snapshot.hasError) {
              return Center(
                child: Text(AppLocalizations.of(context).nointernet),
              );
            }
            return new SpinKitPulse(
              color: Colors.green,
            );
          },
        ));
  }
}
