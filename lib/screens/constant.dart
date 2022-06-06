// ----- STRINGS ------
import 'package:flutter/material.dart';

const baseURL = 'http://192.168.43.228:8000/api';
const loginURL = baseURL + '/login';
const registerURL = baseURL + '/register';
const logoutURL = baseURL + '/logout';
const userURL = baseURL + '/user';
const commentsURL = baseURL + '/comments';
const addAgencyURL = baseURL + '/addAgency';
// ----- Errors -----
const serverError = 'Server error';
const unauthorized = 'Unauthorized';
const somethingWentWrong = 'Something went wrong, try again!';


// --- input decoration
InputDecoration kInputDecoration(String label) {
  return InputDecoration(
      labelText: label,
      labelStyle:TextStyle(fontWeight: FontWeight.w300,
          fontSize: 10,
          letterSpacing: 1.5,
          color:Color(0xff6222ec)),
      contentPadding: EdgeInsets.all(10),
      border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Color(0xff6222ec)))
    );
}







