import 'package:flutter/material.dart';
import 'home/BannerBgCustomPath.dart';
import '../localization/localizations.dart';

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/services.dart';
import 'package:connectivity/connectivity.dart';
import 'dart:async';
import 'notconnected.dart';
import 'home_page.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Settings extends StatefulWidget {
  final String uniqud, fname, lname, typestr, email;
  Settings(
      {Key key, this.uniqud, this.fname, this.lname, this.typestr, this.email})
      : super(key: key);

  @override
  SettingsState createState() {
    return new SettingsState();
  }
}

class SettingsState extends State<Settings> {
  bool _isEnabled = false;
  TimeOfDay _time = TimeOfDay.now();
  FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  String _connectionStatus = 'Unknown';
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      setState(() {
        _isEnabled = prefs.getBool('_isEnabled') ?? false;
        final int hour = prefs.getInt('hour');
        final int minute = prefs.getInt('minute');
        if (hour != null && minute != null) {
          _time = TimeOfDay(hour: hour, minute: minute);
        }
      });
    });

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings();
    const InitializationSettings initializationSettings =
        InitializationSettings(
            initializationSettingsAndroid, initializationSettingsIOS);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _updateNotification() async {
    await _flutterLocalNotificationsPlugin.cancelAll();

    if (!_isEnabled) {
      return;
    }

    final Time time = Time(_time.hour, _time.minute, 0);
    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('reminder', 'Reminder', 'Daily reminder',importance: Importance.Max, priority: Priority.High, ticker: 'ticker');
    final IOSNotificationDetails iOSPlatformChannelSpecifics =
        IOSNotificationDetails();
    final NotificationDetails platformChannelSpecifics = NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    _flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      AppLocalizations.of(context).reminder,
      AppLocalizations.of(context).notification,
      time,
      platformChannelSpecifics,
    );
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
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
            AppLocalizations.of(context).settings,
            style: TextStyle(color: Colors.white),
          ),
          elevation: 0.0,
          centerTitle: false,
          //backgroundColor: appTheme.primaryColor,
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
        body: SingleChildScrollView(
          child: Container(
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
                          borderRadius:
                              BorderRadius.all(Radius.circular(10.0))),
                      color: Colors.white,
                      elevation: 2,
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
                                    "assets/alarm.jpg",
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
                              AppLocalizations.of(context).settings,
                              style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0),
                            ),
                          ),
                          
                          ListTile(
                            leading: Icon(
                              EvaIcons.toggleLeftOutline,
                              color: Colors.green,
                            ),
                            title: Text(
                              AppLocalizations.of(context).notificationTitle,
                              style: TextStyle(color: Colors.black45),
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Container(
                                margin: const EdgeInsets.only(bottom: 8.0),
                                child: Switch.adaptive(
                                      value: _isEnabled,
                                      onChanged: (bool value) {
                                        setState(() {
                                          _isEnabled = !_isEnabled;
                                        });
                                        SharedPreferences.getInstance()
                                            .then((SharedPreferences prefs) {
                                          prefs.setBool(
                                              '_isEnabled', _isEnabled);
                                        });
                                        _updateNotification();
                                      },
                                   
                                ),
                              )),
                          
                          ),
                          ListTile(
                            leading: Icon(
                              EvaIcons.clockOutline,
                              color: Colors.green,
                            ),
                            title: Text(
                              AppLocalizations.of(context).time,
                              style: TextStyle(color: Colors.black45),
                            ),
                            trailing: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Container(
                                //margin: const EdgeInsets.only(bottom: 8.0),
                                child: Text('${_time.format(context)}'),)),
                            onTap: (){ showTimePicker(
                                            context: context,
                                            initialTime: _time,
                                          ).then<void>((TimeOfDay value) {
                                            if (value == null) {
                                              return;
                                            }
                                            setState(() {
                                              _time = value;
                                            });
                                            SharedPreferences.getInstance()
                                                .then(
                                                    (SharedPreferences prefs) {
                                              prefs.setInt('hour', value.hour);
                                              prefs.setInt(
                                                  'minute', value.minute);
                                            });
                                            _updateNotification();
                                          });},
                          ),
                          Divider(
                            height: 1,
                          ),
                          Divider(
                            height: 1,
                          ),
                          ListTile(
                            leading: Icon(
                              EvaIcons.infoOutline,
                              color: Colors.green,
                            ),
                            title: Text(
                              this.widget.uniqud,
                              style: TextStyle(color: Colors.black45),
                            ),
                          ),
                          Divider(
                            height: 1,
                          ),
                          ListTile(
                            leading: Icon(
                              EvaIcons.personOutline,
                              color: Colors.green,
                            ),
                            title: Text(
                                this.widget.fname + ' ' + this.widget.lname,
                                style: TextStyle(color: Colors.black45)),
                          ),
                          Divider(
                            height: 1,
                          ),
                          ListTile(
                            leading: Icon(
                              EvaIcons.emailOutline,
                              color: Colors.green,
                            ),
                            title: Text(this.widget.email,
                                style: TextStyle(color: Colors.black45)),
                          ),
                          Divider(
                            height: 1,
                          ),
                          ListTile(
                            leading: Icon(
                              EvaIcons.activityOutline,
                              color: Colors.green,
                            ),
                            title: Text(this.widget.typestr,
                                style: TextStyle(color: Colors.black45)),
                          ),
                          Divider(
                            height: 1,
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
        Icon(
          iconInfo,
          color: Colors.green,
        ),
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
