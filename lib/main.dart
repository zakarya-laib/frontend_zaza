import 'package:zaza/screens/OffersPage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
void main() {
  final Map <int,Color> _yellow = {

    50:Color(0xffFFC100),
100:Color(0xffFFC100),
    200:Color(0xffFFC100),
  300:Color(0xffFFC100),
  400:Color(0xffFFC100),
  500:Color(0xffFFC100),
  600:Color(0xffFFC100),
  700:Color(0xffFFC100),
  800:Color(0xffFFC100),
  900:Color(0xffFFC100),


  };

  runApp(MaterialApp(theme:ThemeData(colorScheme:ColorScheme.fromSwatch(primarySwatch: MaterialColor(0xffFFC100,_yellow))),debugShowCheckedModeBanner: false,home:LoginScreen()));
}

