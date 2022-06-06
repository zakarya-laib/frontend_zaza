import 'dart:ui';
import 'package:zaza/screens/OffersPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:email_auth/email_auth.dart';
import 'package:zaza/screens/header_widget.dart';
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();

  EmailAuth emailAuth =  new EmailAuth(sessionName: "zaza");
  void sendOtp() async {
    bool result = await emailAuth.sendOtp(
        recipientMail: emailController.value.text,
    );
    if (result){
      print('otp sent');
    }
  }
  void ValidateOtp() async {
    bool result = emailAuth.validateOtp(
        recipientMail: emailController.value.text,
        userOtp: otpController.value.text);

  if(result){
    Navigator.push(context,MaterialPageRoute(builder: (context)=>OffersPage()));
  }
  else{ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Wrong Code')));}
  }
  @override
  Widget build(BuildContext context) {
    double _headerHeight = 200;
    return SafeArea(
      child: Scaffold(resizeToAvoidBottomInset: true,
          backgroundColor: Colors.white,
          body: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: _headerHeight,
                    child: HeaderWidget(_headerHeight, true, Icons.vpn_key_outlined),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10,),
                              Text('Enter the email address associated with your account',
                                style: TextStyle(letterSpacing: 1,fontSize: 10,
                                   color:Color(0xff6222ec),fontWeight: FontWeight.w400
                                ),
                                // textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 10,),
                              Text('We will send you a verification code to check your authenticity.',
                                style: TextStyle(letterSpacing: 1,fontSize: 10,
                                    color:Color(0xff6222ec),fontWeight: FontWeight.w300
                                ),
                                // textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 40.0),
                        Column(
                          children: <Widget>[
                            Container(
                              alignment: Alignment.center,

                              padding: EdgeInsets.only(left: 20, right: 20),
                              height: 54,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Colors.grey[200],
                                boxShadow: [
                                  BoxShadow(
                                      offset: Offset(0, 10),
                                      blurRadius: 50,
                                      color: Color(0xffEEEEEE)
                                  ),
                                ],
                              ),
                              child: TextFormField(
                                style: TextStyle(fontSize: 12,color:Color(0xff6222ec)),
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration:InputDecoration(hintStyle:TextStyle(fontWeight: FontWeight.w300,
                                    fontSize: 10,
                                    letterSpacing: 1.5,
                                    color:Color(0xff6222ec)),
                                  suffixIcon: TextButton(child: Text('Send Code' ,style: TextStyle(letterSpacing: 1,fontSize: 10,
                                      color: Color(0xffFFC100),fontWeight: FontWeight.w500
                                  ),),onPressed: (){sendOtp();},),
                                  icon: Icon(
                                    Icons.email,
                                    color: Color(0xffFFC100),
                                  size:15),
                                  hintText: "Enter Email",
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                validator: (val){
                                  if(val!.isEmpty){
                                    return "Email can't be empty";
                                  }
                                  else if(!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$").hasMatch(val)){
                                    return "Enter a valid email address";
                                  }
                                  return null;
                                },
                              ),
                            ),
                            SizedBox(height: 30.0),
                                 Container(
                                     alignment: Alignment.center,

                                         padding: EdgeInsets.only(left: 20, right: 20),
                                    height: 54,
                                       decoration: BoxDecoration(
                                       borderRadius: BorderRadius.circular(50),
                                   color: Colors.grey[200],
                                   boxShadow: [
                                     BoxShadow(
                              offset: Offset(0, 10),
                              blurRadius: 50,
                              color: Color(0xffEEEEEE)
                          ),
                        ],
                      ),
                           child: TextFormField(
                             style: TextStyle(fontSize: 12,color:Color(0xff6222ec)),
                           controller: otpController,
                            keyboardType: TextInputType.number,
                             decoration:InputDecoration(hintStyle:TextStyle(fontWeight: FontWeight.w300,
                                 fontSize: 10,
                                 letterSpacing: 1.5,
                                 color:Color(0xff6222ec)),
                               icon: Icon(
                                 Icons.password_rounded,
                                 color: Color(0xffFFC100),
                               size:15),
                               hintText: "Enter Code",
                               enabledBorder: InputBorder.none,
                               focusedBorder: InputBorder.none,
                             ),
                           )
                        ),
                            SizedBox(height: 20.0),
                            GestureDetector( onTap:() {ValidateOtp();},
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 30, right: 30),
                                padding: EdgeInsets.only(left: 20, right: 20),
                                height: 54,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [new Color(0xffFFC100), new Color(0xffFFC100)],
                                      begin: Alignment.centerLeft,
                                      end: Alignment.centerRight
                                  ),
                                  borderRadius: BorderRadius.circular(50),
                                  color: Colors.grey[200],
                                  boxShadow: [
                                    BoxShadow(
                                        offset: Offset(0, 10),
                                        blurRadius: 50,
                                        color: Color(0xffEEEEEE)
                                    ),
                                  ],
                                ),
                                child: Text(
                                  "VERIFY",
                                  style: TextStyle(letterSpacing: 2,fontSize: 10,
                                    color:Color(0xff6222ec), fontWeight: FontWeight.w300,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(

                              child: Text("Didn't receive it !",style: TextStyle(letterSpacing: 1,fontSize: 10,
                                  color:Color(0xff6222ec), fontWeight: FontWeight.w300),),
                            ),
                            GestureDetector(
                              child: Text(
                                "Resend ",
                                style: TextStyle(letterSpacing: 1,fontSize: 10,
                                    color: Color(0xffFFC100),fontWeight: FontWeight.w500
                                ),
                              ),
                              onTap: () {
                                sendOtp();
                              },
                            )

                           ]
                        ),
                  ],),
                  ),
                ],
              ),
            ),
              ),
            ),
    );

  }

}
