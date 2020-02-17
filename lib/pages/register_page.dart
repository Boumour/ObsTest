import 'package:flutter/material.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:observanceapp/customviews/progress_dialog.dart';
import 'package:observanceapp/futures/app_futures.dart';
import 'package:observanceapp/models/base/EventObject.dart';
import 'package:observanceapp/pages/login_page.dart';
import 'package:observanceapp/utils/constants.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';
import '../localization/localizations.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class RegisterPage extends StatefulWidget {
  @override
  createState() => new RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final globalKey = new GlobalKey<ScaffoldState>();

  ProgressDialog progressDialog =
      ProgressDialog.getProgressDialog('');

  TextEditingController nameController = new TextEditingController(text: "");
  TextEditingController lnameController = new TextEditingController(text: "");
  TextEditingController emailController = new TextEditingController(text: "");
  TextEditingController _formatCtrl = TextEditingController();
  TextEditingController passwordController =
      new TextEditingController(text: "");

  //List<DropdownMenuItem<String>> _dropDownMenuItems;
  String _format = 'yyyy-mm-dd';
  String _value;
  String _valuesexe;
  /// Display date picker.
  /// 
  
  void _showDatePicker() {
    final bool showTitleActions = false;
    DatePicker.showDatePicker(
      context,
      showTitleActions:  true,
      minYear: 1950,
      maxYear: 2020,
      initialYear: 2015,
      initialMonth: 1,
      initialDate: 1,
      confirm: Text(
        AppLocalizations.of(context).ok,
        style: TextStyle(color: Colors.green),
      ),
      cancel: Text(
        AppLocalizations.of(context).cancel,
        style: TextStyle(color: Colors.redAccent),
      ),
      locale: 'fr',
      dateFormat: 'yyyy-mm-dd',
      onChanged: (year, month, date) {
        debugPrint('onChanged date: $year-$month-$date');

        if (!showTitleActions) {
          _changeDatetime(year, month, date);
        }
      },
      onConfirm: (year, month, date) {
        _changeDatetime(year, month, date);
      },
    );
  }

  void _changeDatetime(int year, int month, int date) {
    setState(() {
      
      _datetime = '$year-$month-$date';
      _formatCtrl.text = _datetime;
    });
  }
  String _datetime = '';
//------------------------------------------------------------------------------

  bool isValidEmail(String em) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }

  @override
  void initState() {
    super.initState();
  }
DropdownButton _sexeMenu() => DropdownButton<String>(
        items: [
          DropdownMenuItem<String>(
            value: "1",
            child: Text(
              "Homme",
            ),
          ),
          DropdownMenuItem<String>(
            value: "2",
            child: Text(
              "Femme",
            ),
          ),
        ],
        onChanged: (value) {
          print("value: $value");
          setState(() {
            
            _valuesexe = value;
          });
        },
        value: _valuesexe,
        hint: Row( children: <Widget>[
          Icon(EvaIcons.eyeOff2Outline, color: Colors.black26,),
        
           Text(
          AppLocalizations.of(context).sexe,
          style: TextStyle(
            color: Colors.black26,
          ),
        ),],)
      );
  List<DropdownMenuItem<String>> getDropDownMenuItem() {
    List<DropdownMenuItem<String>> items = new List();
    return items;
  }
DropdownButton _hintDown() => DropdownButton<String>(
        items: [
          DropdownMenuItem<String>(
            value: "1",
            child: Text(
              "Hémodialysé Chronique",
            ),
          ),
          DropdownMenuItem<String>(
            value: "2",
            child: Text(
              "Greffé Rénale",
            ),
          ),
        ],
        onChanged: (value) {
          print("value: $value");
          setState(() {
            _value = value;
          });
        },
        value: _value,
        hint: Row( children: <Widget>[
          Icon(EvaIcons.archiveOutline, color: Colors.black26,),
        
           Text(
          AppLocalizations.of(context).type,
          style: TextStyle(
            color: Colors.black26,
          ),
        ),],)
      );
// here we are creating the list needed for the DropDownButton
  List<DropdownMenuItem<String>> getDropDownMenuItems() {
    List<DropdownMenuItem<String>> items = new List();
    
    /*for (String t in _type) {
      int i = 1;
      // here we are creating the drop down menu items, you can customize the item right here
      // but I'll just use a simple text for this
      items.add(new DropdownMenuItem(value: i.toString(), child: new Text(t, style: TextStyle(
              color: Colors.black26,
            ),)));
      i++;
    }*/
    return items;
  }

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
            _loginContainer(),
            progressDialog
          ],
        ));
  }

Widget _appIcon() {
    return new Center(
      //decoration: new BoxDecoration(color: Colors.blue[400]),
      child: new Image(
        image: new AssetImage("assets/ic_launcher.png"),
        height: 170.0,
        width: 170.0,
      ),
      //margin: EdgeInsets.only(top: 20.0),
    );
  }
//------------------------------------------------------------------------------
  Widget _loginContainer() {
    return new ListView(
      children: <Widget>[
        new Container(
          //height: 400,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
//------------------------------------------------------------------------------
_appIcon(),
              Text(
                AppLocalizations.of(context).register,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0)),
//------------------------------------------------------------------------------
             new Form(
              
          child: new Theme(
              data: new ThemeData(primarySwatch: Colors.pink),
              child: new Column(
                children: <Widget>[
                  
//------------------------------------------------------------------------------
                  _nameContainer(),
                  _prnameContainer(),
                  _dropContainer(),
                  _sexeContainer(),
                  
                  _dtnaissContainer(),
//------------------------------------------------------------------------------
                  _emailContainer(),
//------------------------------------------------------------------------------
                  _passwordContainer(),
//------------------------------------------------------------------------------
                  _registerButtonContainer(),
//------------------------------------------------------------------------------
                  _loginNowLabel(),
//------------------------------------------------------------------------------
                ],
              ))),
//------------------------------------------------------------------------------
            ],
          ),
        ),
      ],
    );
  }

//------------------------------------------------------------------------------
  Widget _dropContainer() {
    return Container(
       width: double.infinity,
       child : Card(
      
      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
      elevation: 11,
      
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40))),
      child: DropdownButtonHideUnderline(
        
        child: ButtonTheme(
        
        alignedDropdown: true,
         
          child: _hintDown(),/*DropdownButton(
            value: _currentType,
            items: _dropDownMenuItems,
            onChanged: changedDropDownItem,
            hint: Text('Choose Type'),
            style:Theme.of(context).inputDecorationTheme.hintStyle , 
            
             //isDense: true,*/
            
      ),
    )));//);
  }
//------------------------------------------------------------------------------
Widget _sexeContainer() {
    return Container(
       width: double.infinity,
       child : Card(
      
      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
      elevation: 11,
      
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40))),
      child: DropdownButtonHideUnderline(
        
        child: ButtonTheme(
        
        alignedDropdown: true,
         
          child: _sexeMenu(),
            
      ),
    )));//);
  }



  //-----------------------------------------------------------------------------
  Widget _dtnaissContainer() {
    return Card(
      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
      elevation: 11,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40))),
      child: TextField(
        keyboardType: TextInputType.datetime,
        
        controller: _formatCtrl,
        onTap: _showDatePicker,
        enabled: true,
        onChanged: (value) {
          _format = value;
          _formatCtrl.text = _format;
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              EvaIcons.calendarOutline,
              color: Colors.black26,
            ),
            hintText: AppLocalizations.of(context).born,
            hintStyle: TextStyle(
              color: Colors.black26,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
      ),
    );
  }
//------------------------------------------------------------------------------
  Widget _nameContainer() {
    return Card(
      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
      elevation: 11,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40))),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: nameController,
        decoration: InputDecoration(
            prefixIcon: Icon(
              EvaIcons.peopleOutline,
              color: Colors.black26,
            ),
            hintText: AppLocalizations.of(context).lblname,
            hintStyle: TextStyle(
              color: Colors.black26,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
      ),
    );
  }

//------------------------------------------------------------------------------
  Widget _prnameContainer() {
    return Card(
      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
      elevation: 11,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40))),
      child: TextField(
        keyboardType: TextInputType.text,
        controller: lnameController,
        decoration: InputDecoration(
            prefixIcon: Icon(
              EvaIcons.personOutline,
              color: Colors.black26,
            ),
            hintText: AppLocalizations.of(context).lName,
            hintStyle: TextStyle(
              color: Colors.black26,
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
      ),
    );
  }

//------------------------------------------------------------------------------
  Widget _emailContainer() {
    return Card(
      margin: EdgeInsets.only(left: 30, right: 30, top: 30),
      elevation: 11,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40))),
      child: TextField(
        keyboardType: TextInputType.emailAddress,
        controller: emailController,
        decoration: InputDecoration(
            prefixIcon: Icon(
              EvaIcons.emailOutline,
              color: Colors.black26,
            ),
            //suffixIcon: Icon(EvaIcons.checkmarkCircleOutline, color: Colors.black26,),
            hintText: AppLocalizations.of(context).lblemail,
            hintStyle: TextStyle(color: Colors.black26),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.all(Radius.circular(40.0)),
            ),
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
      ),
    );

  }

//------------------------------------------------------------------------------
  Widget _passwordContainer() {
    return Card(
      margin: EdgeInsets.only(left: 30, right: 30, top: 20),
      elevation: 11,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(40))),
      child: TextField(
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: passwordController,
        decoration: InputDecoration(
            prefixIcon: Icon(
              EvaIcons.lockOutline,
              color: Colors.black26,
            ),
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
            contentPadding:
                EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)),
      ),
    );
    /*
     new Container(
        child: new TextFormField(
          controller: passwordController,
          decoration: InputDecoration(
              suffixIcon: new Icon(
                Icons.vpn_key,
                color: Colors.pink,
              ),
              labelText: Texts.PASSWORD,
              labelStyle: TextStyle(fontSize: 18.0)),
          keyboardType: TextInputType.text,
          obscureText: true,
        ),
        margin: EdgeInsets.only(bottom: 35.0));*/
  }

//------------------------------------------------------------------------------
  Widget _registerButtonContainer() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(30.0),
      child: RaisedButton(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        color: Colors.green,
        onPressed: _registerButtonAction,
        elevation: 11,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40.0))),
        child: Text(AppLocalizations.of(context).register, style: TextStyle(color: Colors.white)),
      ),
    );
    /*
     new Container(
        width: double.infinity,
        decoration: new BoxDecoration(color: Colors.blue[400]),
        child: new MaterialButton(
          textColor: Colors.white,
          padding: EdgeInsets.all(15.0),
          onPressed: _registerButtonAction,
          child: new Text(
            Texts.REGISTER,
            style: new TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
        ),
        margin: EdgeInsets.only(bottom: 30.0));*/
  }

//------------------------------------------------------------------------------
  Widget _loginNowLabel() {
    return new GestureDetector(
      onTap: _goToLoginScreen,
      child: new Container(
          child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      
                      children: <Widget>[
                        Text(AppLocalizations.of(context).alreadyregistred, style: TextStyle(color: Colors.lightGreen)),
                        
                      ],
                    ),
          margin: EdgeInsets.only(bottom: 30.0)),
    );
  }

//------------------------------------------------------------------------------
  void _registerButtonAction() {
    if (nameController.text == "" && lnameController.text == "") {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text(AppLocalizations.of(context).entername),
      ));
      return;
    }

    if (emailController.text == "") {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text(AppLocalizations.of(context).enteremail),
      ));
      return;
    }

    if (!isValidEmail(emailController.text)) {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text(AppLocalizations.of(context).entervalidemail),
      ));
      return;
    }

    if (emailController.text == "") {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text(AppLocalizations.of(context).enteremail),
      ));
      return;
    }

    if (_formatCtrl.text == "") {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text('Date de naissace est vide'),
      ));
      return;
    }
    if (_value.isEmpty && _valuesexe.isEmpty) {
      globalKey.currentState.showSnackBar(new SnackBar(
        content: new Text('Svp selectionner les sexe et le type'),
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
    _registerUser(
        nameController.text, lnameController.text, emailController.text, passwordController.text, _value, _valuesexe, _formatCtrl.text);
  }

//------------------------------------------------------------------------------
  void _registerUser(String f_name, String l_name, String emailId, String password, String type, String sexe, String dt) async {
    EventObject eventObject = await registerUser(f_name, l_name, emailId, password, type, sexe, dt);
    switch (eventObject.id) {
      case EventConstants.USER_REGISTRATION_SUCCESSFUL:
        {
          setState(() {
            globalKey.currentState.showSnackBar(new SnackBar(
              content: new Text(AppLocalizations.of(context).registersuccessful),
            ));
            progressDialog.hideProgress();
            _goToLoginScreen();
          });
        }
        break;
      case EventConstants.USER_ALREADY_REGISTERED:
        {
          setState(() {
            globalKey.currentState.showSnackBar(new SnackBar(
              content: new Text(AppLocalizations.of(context).alreadyregistred),
            ));
            progressDialog.hideProgress();
          });
        }
        break;
      case EventConstants.USER_REGISTRATION_UN_SUCCESSFUL:
        {
          setState(() {
            globalKey.currentState.showSnackBar(new SnackBar(
              content: new Text(AppLocalizations.of(context).registerunsuccessful),
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

  void _goToLoginScreen() {
    Navigator.pushReplacement(
      context,
      new MaterialPageRoute(builder: (context) => new LoginPage()),
    );
  }
//------------------------------------------------------------------------------
}
