import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:observanceapp/l10n/messages_all.dart';


class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static Future<AppLocalizations> load(Locale locale) {
    final String name =
        locale.countryCode == null ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);

    return initializeMessages(localeName).then((bool _) {
      Intl.defaultLocale = localeName;
      return new AppLocalizations();
    });
  }
 

  String get title {
    return Intl.message('Contact Us', name: 'title');
  }

  String get btnsubmit {
    return Intl.message('Submit', name: 'btnsubmit');
  }

  String get locale {
    return Intl.message('en', name: 'locale');
  }

  String get lblname {
    return Intl.message('Name', name: 'lblname');
  }

  String get lblphone {
    return Intl.message('Phone', name: 'lblphone');
  }

  String get lblemail {
    return Intl.message('Email', name: 'lblemail');
  }

//  String get lblback {
//    return Intl.message('back', name: 'lblback');
//  }


  String get inprogress {
    return Intl.message('En cours...', name: 'in_progress');
  }
  String get changing {
    return Intl.message('changing', name: 'changing');
  }
  String get loginin {
    return Intl.message('login_in', name: 'login_in');
  }
  String get registering {
    return Intl.message('registering', name: 'registering');
  }
  String get nointernet {
    return Intl.message('no_internet', name: 'no_internet');
  }
  String get loginsuccessful {
    return Intl.message('login_successful', name: 'login_successful');
  }
  String get loginunsuccessful {
    return Intl.message('login_unsuccessful', name: 'login_unsuccessful');
  }
  String get passwordchangesuccessful {
    return Intl.message('password_change_successful', name: 'password_change_successful');
  }
  String get passwordchangeunsuccessful {
    return Intl.message('password_change_unsuccessful', name: 'password_change_unsuccessful');
  }
  String get registersuccessful {
    return Intl.message('register_successful', name: 'register_successful');
  }
   get registerunsuccessful {
    return Intl.message('register_unsuccessful', name: 'register_unsuccessful');
  }
  String get useralready {
    return Intl.message('user_already', name: 'user_already');
  }
  String get enterpassword {
    return Intl.message('enter_password', name: 'enter_password');
  }
  String get enternewpassword {
    return Intl.message('enter_new_password', name: 'enter_new_password');
  }
  String get enteroldpassword {
    return Intl.message('enter_old_password', name: 'enter_old_password');
  }
  String get enteremail {
    return Intl.message('enter_email', name: 'enter_email');
  }
  String get entervalidemail {
    return Intl.message('enter_valid_email', name: 'enter_valid_email');
  }
  String get entername {
    return Intl.message('enter_name', name: 'enter_name');
  }
  String get invalideoldpassword {
    return Intl.message('invalide_old_password', name: 'invalide_old_password');
  }
  String get notregistred {
    return Intl.message('not_registred', name: 'not_registred');
  }
  String get alreadyregistred {
    return Intl.message('already_registred', name: 'already_registred');
  }
  String get login {
    return Intl.message("login", name: 'login');
  }
  String get register {
    return Intl.message('register', name: 'register');
  }
  String get password {
    return Intl.message('Mot de passe', name: 'password');
  }
  String get oldpassword {
    return Intl.message('old_password', name: 'old_password');
  }
  String get newpassword {
    return Intl.message('new_password', name: 'new_password');
  }
  String get changepassword {
    return Intl.message('change_password', name: 'change_password');
  }
  String get logout {
    return Intl.message('logout', name: 'logout');
  }
  String get lName {
    return Intl.message('l_Name', name: 'l_Name');
  }
  String get type {
    return Intl.message('choose_type', name: 'choose_type');
  }
  String get q1{
    return Intl.message(
      'Q1',
      name: 'Q1',
    );
  }
  String get q2{
    return Intl.message(
      'Q2',
      name: 'Q2',
    );
  }
  String get q3{
    return Intl.message(
      'Q3',
      name: 'Q3',
    );
  }
  String get q4{
    return Intl.message(
      'Q4',
      name: 'Q4',
    );
  }
  String get q5{
    return Intl.message(
      'Q5',
      name: 'Q5',
    );
  }
  String get q6{
    return Intl.message(
      'Q6',
      name: 'Q6',
    );
  }
  String get oui{
    return Intl.message(
      'oui',
      name: 'oui',
    );
  }
  String get non{
    return Intl.message(
      'non',
      name: 'non',
    );
  }

  String get question{
    return Intl.message(
      'question',
      name: 'question',
    );
  }
  String get sur{
    return Intl.message(
      'of',
      name: 'of',
    );
  }
  String get start{
    return Intl.message(
      'start',
      name: 'start',
    );
  }
  String get bon{
    return Intl.message(
      'bon',
      name: 'bon',
    );
  }
  String get moy{
    return Intl.message(
      'moy',
      name: 'moy',
    );
  }
  String get mal{
    return Intl.message(
      'mal',
      name: 'mal',
    );
  }
  String get reset{
    return Intl.message(
      'reset',
      name: 'reset',
    );
  }



  String get minute{
    return Intl.message(
      'minute',
      name: 'minute',
    );
  }
  String get qst{
    return Intl.message(
      'qst',
      name: 'qst',
    );
  }
  String get level{
    return Intl.message(
      'level',
      name: 'level',
    );
  }
  String get normal{
    return Intl.message(
      'normal',
      name: 'normal',
    );
  }
  String get test{
    return Intl.message(
      'test',
      name: 'test',
    );
  }
  String get result{
    return Intl.message(
      'result',
      name: 'result',
    );
  }
  String get medecament{
    return Intl.message(
      'medecament',
      name: 'medecament',
    );
  }
  String get slt{
    return Intl.message(
      'slt',
      name: 'slt',
    );
  }
  String get home{
    return Intl.message(
      'home',
      name: 'home',
    );
  }
  String get about{
    return Intl.message(
      'about',
      name: 'about',
    );
  }
  String get settings{
    return Intl.message(
      'settings',
      name: 'settings',
    );
  }
  String get testdesc{
    return Intl.message(
      'testdesc',
      name: 'testdesc',
    );
  }
  String get aboutusdesc{
    return Intl.message(
      'aboutusdesc',
      name: 'aboutusdesc',
    );
  }

  String get nadia{
    return Intl.message(
      'nadia',
      name: 'nadia',
    );
  }
  String get meriem{
    return Intl.message(
      'meriem',
      name: 'meriem',
    );
  }
  String get mohamed{
    return Intl.message(
      'mohamed',
      name: 'mohamed',
    );
  }

  String get ourteam{
    return Intl.message(
      'ourteam',
      name: 'ourteam',
    );
  }
  String get doctor{
    return Intl.message(
      'doctor',
      name: 'doctor',
    );
  }
  String get dev{
    return Intl.message(
      'dev',
      name: 'dev',
    );
  }
  String get resultsdesc{
    return Intl.message(
      'resultsdesc',
      name: 'resultsdesc',
    );
  }
  String get goodword{
    return Intl.message(
      'goodword',
      name: 'goodword',
    );
  }
  String get badword{
    return Intl.message(
      'badword',
      name: 'badword',
    );
  }
  String get normalword{
    return Intl.message(
      'normalword',
      name: 'normalword',
    );
  }

  String get sexe{
    return Intl.message(
      'sexe',
      name: 'sexe',
    );
  }
  String get born{
    return Intl.message(
      'born',
      name: 'born',
    );
  }
  String get ok{
    return Intl.message(
      'ok',
      name: 'ok',
    );
  }
  String get cancel{
    return Intl.message(
      'cancel',
      name: 'cancel',
    );
  }
  String get reminder{
    return Intl.message(
      'reminder',
      name: 'reminder',
    );
  }
  String get notification{
    return Intl.message(
      'notification',
      name: 'notification',
    );
  }
  String get notificationTitle{
    return Intl.message(
      'notificationTitle',
      name: 'notificationTitle',
    );
  }
  String get time{
    return Intl.message(
      'Time',
      name: 'Time',
    );
  }

}



class SpecificLocalizationDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  final Locale overriddenLocale;

  SpecificLocalizationDelegate(this.overriddenLocale);

  @override
  bool isSupported(Locale locale) => overriddenLocale != null;

  @override
  Future<AppLocalizations> load(Locale locale) =>
      AppLocalizations.load(overriddenLocale);

  @override
  bool shouldReload(LocalizationsDelegate<AppLocalizations> old) => true;
}
