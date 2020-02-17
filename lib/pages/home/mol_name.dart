import 'package:flutter/material.dart';
import '../../customviews/pulse.dart';
import 'sm_page.dart';
import 'cards.dart';
import '../../localization/localizations.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' show get;
class Molicule {
  final String idmol;
  final String namemol;

  Molicule({
    this.idmol,
    this.namemol,
  });

  factory Molicule.fromJson(Map<String, dynamic> jsonData) {
    return Molicule(
      idmol: jsonData['id'],
      namemol: jsonData['name'],
    );
  }
}


class HomePage extends StatelessWidget {
  final List<Molicule> molicule;
  final String typeu, iduser;

  HomePage(this.molicule, this.typeu, this.iduser);

  Widget build(context) {
    return ListView.builder(
      addAutomaticKeepAlives: true,
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: molicule.length,
      itemBuilder: (context, int currentIndex) {
        return createViewItem(molicule[currentIndex], context);
      },
    );
  }

  Widget createViewItem(Molicule ml, BuildContext context) {
    return new EasyCard(
    prefixBadge: Colors.green,
    title: ml.namemol,
    icon: EvaIcons.cubeOutline,
    description: AppLocalizations.of(context).start,
    suffixIcon: Icons.chevron_right,
    suffixIconColor: Colors.green,
    iconColor: Colors.lightGreen,
    titleColor: Colors.black87,
     onTap: (){
       Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ListChallenge( nammol: ml.namemol , idmol:  ml.idmol,typeUser: typeu, iduser: iduser,)),
        );
     },
  );
    
    }
}


//Future is n object representing a delayed computation.
Future<List<Molicule>> downloadJSON(String c) async {
  final jsonEndpoint =
      "http://observance-therapeutique.com/app_api/get/index.php?tp="+c.toString();

  final response = await get(jsonEndpoint);

  if (response.statusCode == 200) {
    List spacecrafts = json.decode(response.body);
    return spacecrafts
        .map((spacecraft) => new Molicule.fromJson(spacecraft))
        .toList();
  } else
    throw Exception('We were not able to successfully download the json data.');
}

class MolName extends StatefulWidget {

  final String type, typeString, iduser;
  MolName({Key key, this.type, this.typeString,this.iduser}) : super(key: key);
  @override
  MolNameState createState() {
    return new MolNameState();
  }
}

class MolNameState extends State<MolName> {

  @override
  void initState() {
    super.initState();
    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            SizedBox(
              width: 16.0,
            ),
            Text(widget.typeString,
                style: TextStyle(
                    color: Color(0xFF30314A), fontWeight: FontWeight.bold)),
            Spacer(),
            Icon(EvaIcons.arrowCircleDownOutline)
          ],
        ),
      ),
      Container(
        child : new FutureBuilder<List<Molicule>>(
           
            future: downloadJSON(widget.type),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Molicule> spacecrafts = snapshot.data;
        
         return new HomePage(spacecrafts, widget.type, widget.iduser);
        } else if (snapshot.hasError) {
                return Center(child: Text(AppLocalizations.of(context).nointernet));
              }
              //return  a circular progress indicator.
              return new SpinKitPulse(color: Colors.green,);
            },
          ),
      )
    ]));

    
  }
  
}
