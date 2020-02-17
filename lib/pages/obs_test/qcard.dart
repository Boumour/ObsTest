import 'package:flutter/material.dart';

class CardQuestions extends StatelessWidget {
  String question, image;
  CardQuestions({Key key,@required this.question, @required this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: new Container(
        height: 250.0,
        child: new Container(
            child: new Center(
          child: new ListTile(
            contentPadding: new EdgeInsets.all(40.0),
            title: new Text(
              this.question,
              style: TextStyle(color: Colors.white, fontSize: 20.0),
              textAlign: TextAlign.center,
            ),
            
            
          ),
        )),
        decoration: new BoxDecoration(
          color: Colors.blueAccent,
          image: new DecorationImage(
              fit: BoxFit.cover,
              colorFilter: new ColorFilter.mode(
                  Colors.green.withOpacity(0.3), BlendMode.dstATop),
              image: ExactAssetImage(this.image),
              ),
        ),
      ),
    );
  }
}
