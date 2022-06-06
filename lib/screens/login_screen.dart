import 'dart:ui';
import 'package:draggable_home/draggable_home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:zaza/screens/signup_screen.dart';
import 'package:zaza/models/api_response.dart';
import 'package:zaza/models/user.dart';
import 'package:zaza/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/gestures.dart';
import 'package:zaza/screens/OffersPage.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:animated_card/animated_card.dart';
import 'package:zaza/screens/Agencyoffers.dart';
import '../models/offer.dart';
import 'forgot_password_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isVisible = false;

  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();
  bool loading = false;

  void _loginUser() async {
    ApiResponse response = await login(txtEmail.text, txtPassword.text);
    if (response.error == null) {
      _saveAndRedirectToHome(response.data as User);
    } else {
      setState(() {
        loading = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${response.error}')));
    }
  }

  void _saveAndRedirectToHome(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');
    await pref.setString('email', user.email ?? '');
    await pref.setString('userType', user.userType ?? '');
    var ut = await getUserType();
    print('$ut');
    if ('$ut' == 'Client') {
      ApiResponse response = await getClientInfos(txtEmail.text);
      var jsonRespo = response.data as Map<String, dynamic>;
      var clientName = jsonRespo['client'][0]['user_name'];
      var profilePic = jsonRespo['client'][0]['profile_pic'];
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => OffersPage()),
          (route) => false);
    }
    if ('$ut' == 'Agency') {
      ApiResponse response = await getAgencyName(txtEmail.text);
      var jsonRespo = response.data as Map<String, dynamic>;
      var agencyName = jsonRespo['agency'][0]['agency_name'];
      print('$agencyName');
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => AgencyOffers()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final TapGestureRecognizer gr = TapGestureRecognizer()
      ..onTap = () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ForgotPasswordPage()));
      };
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Form(
            key: formkey,
            child: Column(
              children: AnimationConfiguration.toStaggeredList(
                duration: const Duration(milliseconds: 500),
                childAnimationBuilder: (widget) => SlideAnimation(
                  horizontalOffset: 50.0,
                  child: FadeInAnimation(
                    child: widget,
                  ),
                ),
                children: [
                  Container(
                    height: 240,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage('photos/login.png'))),
                  ),
                  Text(
                    "Login",
                    style: TextStyle(
                        color: Color(0xffFFC100),
                        letterSpacing: 2,
                        fontWeight: FontWeight.w400,
                        fontSize: 18),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.grey[200],
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 50,
                            color: Color(0xffEEEEEE)),
                      ],
                    ),
                    child: TextFormField(
                      style: TextStyle(fontSize: 12, color: Color(0xff6222ec)),
                      keyboardType: TextInputType.emailAddress,
                      controller: txtEmail,
                      validator: (val) =>
                          val!.isEmpty ? 'Invalid email address' : null,
                      cursorColor: Color(0xff6222ec),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                            letterSpacing: 1.5,
                            color: Color(0xff6222ec)),
                        icon: Icon(
                          Icons.email,
                          color: Color(0xffFFC100),
                          size: 15,
                        ),
                        hintText: "Enter Email",
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                    padding: EdgeInsets.only(left: 20, right: 20),
                    height: 54,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color(0xffEEEEEE),
                      boxShadow: [
                        BoxShadow(
                            offset: Offset(0, 20),
                            blurRadius: 100,
                            color: Color(0xffEEEEEE)),
                      ],
                    ),
                    child: TextFormField(
                      controller: txtPassword,
                      style: TextStyle(fontSize: 12, color: Color(0xff6222ec)),
                      validator: (val) =>
                          val!.length < 6 ? 'Required at least 6 chars' : null,
                      cursorColor: Color(0xff6222ec),
                      decoration: InputDecoration(
                        hintStyle: TextStyle(
                            fontWeight: FontWeight.w300,
                            fontSize: 10,
                            letterSpacing: 1.5,
                            color: Color(0xff6222ec)),
                        suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                isVisible = !isVisible;
                              });
                            },
                            icon: isVisible
                                ? Icon(
                                    Icons.visibility,
                                    size: 15,
                                    color: Color(0xffFFC100),
                                  )
                                : Icon(
                                    Icons.visibility_off,
                                    size: 15,
                                    color: Color(0xffFFC100),
                                  )),
                        focusColor: Color(0xffFFC100),
                        icon: Icon(
                          Icons.vpn_key,
                          color: Color(0xffFFC100),
                          size: 15,
                        ),
                        hintText: "Enter Password",
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      obscureText: !isVisible,
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  Container(
                    margin: EdgeInsets.symmetric(
                      horizontal: 30,
                    ),
                    alignment: Alignment.centerRight,
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(
                              letterSpacing: 1,
                              color: Color(0xffFFC100),
                              fontWeight: FontWeight.w500),
                          text: 'Forgot My Password !',
                          recognizer: gr),
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  loading
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : GestureDetector(
                          onTap: () {
                            if (formkey.currentState!.validate()) {
                              setState(() {
                                loading = true;
                                _loginUser();
                              });
                            }
                          },
                          child: Container(
                            alignment: Alignment.center,
                            margin:
                                EdgeInsets.only(left: 20, right: 20, top: 20),
                            padding: EdgeInsets.only(left: 20, right: 20),
                            height: 54,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  colors: [
                                    new Color(0xffFFC100),
                                    new Color(0xffFFC100)
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight),
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey[200],
                              boxShadow: [
                                BoxShadow(
                                    offset: Offset(0, 10),
                                    blurRadius: 50,
                                    color: Color(0xffEEEEEE)),
                              ],
                            ),
                            child: Text(
                              "LOGIN",
                              style: TextStyle(
                                letterSpacing: 2,
                                fontSize: 10,
                                color: Color(0xff6222ec),
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ),
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 8),
                    child: Text("Don't Have Account ? ",
                        style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 10,
                            color: Color(0xff6222ec),
                            fontWeight: FontWeight.w300)),
                  ),
                  GestureDetector(
                    child: Text(
                      "Register Now",
                      style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 10,
                          color: Color(0xffFFC100),
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 15, bottom: 8),
                    child: Text("Or",
                        style: TextStyle(
                            letterSpacing: 1,
                            fontSize: 10,
                            color: Color(0xff6222ec),
                            fontWeight: FontWeight.w300)),
                  ),
                  GestureDetector(
                    child: Text(
                      "Continue As Guest",
                      style: TextStyle(
                          letterSpacing: 1,
                          fontSize: 10,
                          color: Color(0xffFFC100),
                          fontWeight: FontWeight.w500),
                    ),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GuestOffers()));
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
class GuestOffers extends StatefulWidget {
  const GuestOffers({Key? key}) : super(key: key);
  @override
  State<GuestOffers> createState() => _GuestOffersState();
}
class _GuestOffersState extends State<GuestOffers> {
  List<dynamic> _offersList = [];
  bool _loading = true;
  Future<void> retrieveOffers() async {
    ApiResponse response = await getOffers();
    if (response.error == null) {
      setState(() {
        _offersList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }
  @override
  void initState() {
    retrieveOffers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return _loading
        ? Center(child: CircularProgressIndicator())
        : SafeArea(
          child: DraggableHome(
              headerExpandedHeight: 0.1,
              leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                      (route) => false);
                },
                icon: Icon(Icons.logout),
                color: Colors.white,
              ),
              headerWidget: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text('zaza',
                            style: TextStyle(
                                letterSpacing: 2,
                                fontSize: 15,
                                color: Colors.white)),
                      ],
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      height: 18,
                      width: 18,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(9),
                          image: DecorationImage(
                              image: AssetImage('photos/zaza2.png'))),
                    )
                  ],
                ),
              ),
              centerTitle: true,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('',
                      style: TextStyle(
                          letterSpacing: 2,
                          fontSize: 15,
                          color: Colors.white)),
                ],
              ),
              body: [
                AnimationLimiter(
                  child: ListView.builder(
                    padding: EdgeInsets.only(top: 0),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _offersList.length,
                    itemBuilder: (BuildContext context, int index) {
                      Offer offer = _offersList[index];
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: AnimatedCard(
                              direction: AnimatedCardDirection.left,
                              //Initial animation direction
                              initDelay: Duration(milliseconds: 0),

                              duration: Duration(seconds: 1),
                              curve: Curves.ease,
                              //Animation curve
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(23)),
                                color: Colors.white,
                                shadowColor: Color(0xffFFC100),
                                elevation: 9,
                                margin: EdgeInsets.fromLTRB(10, 15, 10, 15),
                                child: Row(children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8, left: 8),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(23),
                                      child: Container(
                                        height: 150,
                                        width: 150,
                                        margin: EdgeInsets.zero,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage(
                                                    '${offer.image1}'),
                                                fit: BoxFit.cover)),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 160,
                                    margin: EdgeInsets.only(left: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              FontAwesomeIcons.house,
                                              size: 15,
                                              color: Color(0xffFFC100),
                                            ),
                                            SizedBox(
                                              width: 8,
                                            ),
                                            Text('${offer.property_type}',
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.w400,
                                                    fontSize: 10,
                                                    letterSpacing: 1.5,
                                                    color:
                                                        Color(0xff6222ec))),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        Row(children: [
                                          SizedBox(
                                            width: 23,
                                          ),
                                          Text('${offer.offer_type}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w300,
                                                fontSize: 10,
                                                letterSpacing: 1.5,
                                                color: Color(0xff6222ec),
                                              )),
                                        ]),
                                        SizedBox(height: 12,),
                                        SingleChildScrollView(scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Icon(Icons.location_on_outlined, size: 15,
                                                color: Color(0xffFFC100),),
                                              SizedBox(width: 8,),
                                              Text('${offer.address}',
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.w300,
                                                      fontSize: 10,
                                                      letterSpacing: 1.5,
                                                      color:Color(0xff6222ec))),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 12,
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.price_change,
                                                size: 15,
                                                color: Color(0xffFFC100),
                                              ),
                                              SizedBox(
                                                width: 8,
                                              ),
                                              Text('${offer.offer_price}',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w300,
                                                      fontSize: 10,
                                                      letterSpacing: 1.5,
                                                      color:
                                                          Color(0xff6222ec))),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ]),
        );
  }
}
