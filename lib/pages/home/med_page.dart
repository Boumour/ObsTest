import 'package:flutter/material.dart';
import 'BannerBgCustomPath.dart';
import '../home_page.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'cards.dart';
import 'dart:async';
import 'dart:convert';
import '../../localization/localizations.dart';
import 'package:http/http.dart' show get;
import '../../customviews/pulse.dart';
import 'start.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import '../notconnected.dart';

class Medicament {
  final String idmed;
  final String namemed;
  final String idsmol;

  Medicament({
    this.idmed,
    this.namemed,
    this.idsmol
  });

  factory Medicament.fromJson(Map<String, dynamic> jsonData) {
    return Medicament(
      idmed: jsonData['idmed'],
      namemed: jsonData['namemed'],
      idsmol: jsonData['idsmol'],
    );
  }
}

Future<List<Medicament>> downloadJSON(String c) async {
  final jsonEndpoint =
      "http://observance-therapeutique.com/app_api/get/get_med.php?med=" + c.toString();

  final response = await get(jsonEndpoint);

  if (response.statusCode == 200) {
    List sousmolicules = json.decode(response.body);
    
    return sousmolicules
        .map((sousmolicule) => new Medicament.fromJson(sousmolicule))
        .toList();
  } else
    throw Exception('We were not able to successfully download the json data.');
}


class ListMed extends StatefulWidget {
  final String idmol, idsmol, namesmol, typeus,iduser;
  ListMed({Key key, this.idmol,this.idsmol, this.namesmol, this.typeus, this.iduser}) : super(key: key);

  @override
  ListMedState createState() {
    return new ListMedState();
  }
}

class ListMedState extends State<ListMed> {
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
          widget.namesmol, style: TextStyle( color: Colors.white),
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
      body: new FutureBuilder<List<Medicament>>(
            future: downloadJSON(this.widget.idsmol),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
              List<Medicament> soum = snapshot.data;
              return new ContentList(soum, widget.typeus, widget.idmol, widget.idsmol, widget.iduser);
        } else if (snapshot.hasError || snapshot.hasData) {
                return Center(child: Text(AppLocalizations.of(context).nointernet));
              }
              return new SpinKitPulse(color: Colors.green,);
            },
          )
    );
  }
}

class ContentList extends StatelessWidget {
  final List<Medicament> sousmolicules;
  final String idmol, typeu, idsm, iduser;

  ContentList(this.sousmolicules,this.typeu, this.idmol, this.idsm, this.iduser);


  Widget createViewItem(Medicament m, BuildContext context) {
    return new EasyCard(
    prefixBadge: Colors.green,
    title: m.namemed,
    icon: EvaIcons.keypadOutline,
    //description: 'Start Your Test',
    suffixIcon: Icons.chevron_right,
    suffixIconColor: Colors.green,
    iconColor: Colors.lightGreen,
    titleColor: Colors.black87,
     onTap: (){
       Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StartTest( idmol: this.idmol, idsmol: m.idsmol, idmed:  m.idmed, typeus: typeu, namemed: m.namemed, iduser: this.iduser,)),
        );
     },
    );
    }


  @override
 Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          ClipPath(
            clipper: BannerBgCustomPath(),
            child: Container(
              color: appTheme.primaryColor,
              height: 200,
            ),
          ),
          Container(
            child: ListView.builder(
       addAutomaticKeepAlives: true,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: sousmolicules.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(sousmolicules[currentIndex], context);
      },
    )
          )
        ],
      ),
    );
  }
}

