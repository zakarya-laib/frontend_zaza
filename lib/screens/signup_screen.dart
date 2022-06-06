import 'package:zaza/models/user.dart';
import 'package:flutter/material.dart';
import 'package:zaza/models/api_response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zaza/services/user_service.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'login_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class SignUpScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => InitState();
}

class InitState extends State<SignUpScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String dropdownvalue = 'Client';
  var items = ['Client', 'Agency'];
  bool isVisible2 = false;
  bool isVisible = false;
  bool loading = false;
  TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController(),
      passwordConfirmController = TextEditingController();

  void _registerUser() async {
    ApiResponse response = await register(
        dropdownvalue, emailController.text, passwordController.text);

    if (response.error == null) {
      _saveAndRedirectToNext(response.data as User);
    } else {
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text('${response.error}')));
    }
  }

  // Save and redirect to next
  void _saveAndRedirectToNext(User user) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('token', user.token ?? '');

    if (dropdownvalue == 'Agency') {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  RegisterAgency(email: emailController.text)),
          (route) => false);
    } else {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
              builder: (context) =>
                  RegisterClient(email: emailController.text)),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
            child: Form(
                key: formKey,
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
                                image: AssetImage('photos/register.png'))),
                      ),
                      Text(
                        "Register",
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
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton(
                            isExpanded: true,
                            iconEnabledColor: Color(0xffFFC100),
                            value: dropdownvalue,
                            items: items.map((String items) {
                              return DropdownMenuItem(
                                  value: items,
                                  child: Text(
                                    items,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 10,
                                        letterSpacing: 1.5,
                                        color: Color(0xff6222ec)),
                                  ));
                            }).toList(),
                            onChanged: (String? newValue) {
                              setState(() {
                                dropdownvalue = newValue!;
                              });
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_down_rounded,
                            ),
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
                          color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 10),
                                blurRadius: 50,
                                color: Color(0xffEEEEEE)),
                          ],
                        ),
                        child: TextFormField(
                          style:
                              TextStyle(fontSize: 12, color: Color(0xff6222ec)),
                          controller: emailController,
                          keyboardType: TextInputType.emailAddress,
                          cursorColor: Color(0xff6222ec),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Color(0xff6222ec),
                              fontSize: 10,
                              letterSpacing: 1.5,
                            ),
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
                          style:
                              TextStyle(fontSize: 12, color: Color(0xff6222ec)),
                          controller: passwordController,
                          obscureText: !isVisible,
                          validator: (val) => val!.length < 6
                              ? 'Required at least 6 chars'
                              : null,
                          cursorColor: Color(0xff6222ec),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Color(0xff6222ec),
                              fontSize: 10,
                              letterSpacing: 1.5,
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                },
                                icon: isVisible
                                    ? Icon(
                                        Icons.visibility,
                                        color: Color(0xffFFC100),
                                        size: 15,
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
                          style:
                              TextStyle(fontSize: 12, color: Color(0xff6222ec)),
                          controller: passwordConfirmController,
                          obscureText: !isVisible2,
                          validator: (val) => val != passwordController.text
                              ? 'Confirm password does not match'
                              : null,
                          cursorColor: Color(0xff6222ec),
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              color: Color(0xff6222ec),
                              fontSize: 10,
                              letterSpacing: 1.5,
                            ),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isVisible2 = !isVisible2;
                                  });
                                },
                                icon: isVisible2
                                    ? Icon(
                                        Icons.visibility,
                                        color: Color(0xffFFC100),
                                        size: 15,
                                      )
                                    : Icon(
                                        Icons.visibility_off,
                                        color: Color(0xffFFC100),
                                        size: 15,
                                      )),
                            focusColor: Color(0xffFFC100),
                            icon: Icon(
                              Icons.vpn_key,
                              color: Color(0xffFFC100),
                              size: 15,
                            ),
                            hintText: "Confirm Password",
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      SizedBox(height: 8),
                      loading
                          ? Center(
                              child: CircularProgressIndicator(
                                  color: Color(0xffFFC100)))
                          : GestureDetector(
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  setState(() {
                                    loading = !loading;
                                    _registerUser();

                                    ;
                                  });
                                }
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
                                padding: EdgeInsets.only(left: 20, right: 20),
                                height: 54,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                      colors: [
                                        (new Color(0xffFFC100)),
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
                                  "Create Account",
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
                        child: Text(
                          "Already Member? ",
                          style: TextStyle(
                              fontSize: 10,
                              letterSpacing: 1,
                              color: Color(0xff6222ec),
                              fontWeight: FontWeight.w300),
                        ),
                      ),
                      GestureDetector(
                        child: Text(
                          "Login Now",
                          style: TextStyle(
                              letterSpacing: 1,
                              fontSize: 10,
                              color: Color(0xffFFC100),
                              fontWeight: FontWeight.w500),
                        ),
                        onTap: () {
                          // Write Tap Code Here.
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()));
                          ;
                        },
                      ),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ))),
      ),
    );
  }
}

class RegisterAgency extends StatefulWidget {
  final String email;

  const RegisterAgency({Key? key, required this.email}) : super(key: key);

  @override
  State<RegisterAgency> createState() => _RegisterAgency();
}

class _RegisterAgency extends State<RegisterAgency> {
  GlobalKey<FormState> formKey2 = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController agencyNumberController = TextEditingController(),
      agencyNameController = TextEditingController();
  File? _logoFile;
  File? _crFile;
  final _pickerLogo = ImagePicker();
  final _pickerCr = ImagePicker();

  Future getLogo() async {
    final pickedFile = await _pickerLogo.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _logoFile = File(pickedFile.path);
      });
    }
  }

  Future getCr() async {
    final pickedFile2 = await _pickerCr.getImage(source: ImageSource.gallery);
    if (pickedFile2 != null) {
      setState(() {
        _crFile = File(pickedFile2.path);
      });
    }
  }

  void _addAgency() async {
    String? logo = _logoFile == null ? null : getStringImage(_logoFile);
    String? cr = _crFile == null ? null : getStringImage(_crFile);
    ApiResponse response = await addAgency(widget.email,
        agencyNameController.text, logo, cr,'+213'+agencyNumberController.text);
    if (response.error == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      setState(() {
        loading = !loading;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text('${response.error}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Center(
          child: Form(
            key: formKey2,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 500),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    Text(
                      'Register Agency',
                      style: TextStyle(
                          color: Color(0xff6222ec),
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                    SizedBox(height: 35,),
                    GestureDetector(
                        onTap: () {
                          getLogo();
                        },
                        child: Stack(
                          children: [
                            Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                      width: 4,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor),
                                  boxShadow: [
                                    BoxShadow(
                                        spreadRadius: 2,
                                        blurRadius: 10,
                                        color: Colors.black.withOpacity(0.1),
                                        offset: Offset(0, 10))
                                  ],
                                  shape: BoxShape.circle,
                                  image: _logoFile == null
                                      ? null
                                      : DecorationImage(
                                          image:
                                              FileImage(_logoFile ?? File('')),
                                          fit: BoxFit.cover),
                                )),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    color: Color(0xff6222ec),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                )),
                          ],
                        )),
                    SizedBox(height: 10),
                    Text(
                      "Agency Logo",
                      style: TextStyle(
                          color: Color(0xff6222ec),
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w300,
                          fontSize: 10),
                    ),
                    Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(left: 20, right: 20, top: 40),
                      padding: EdgeInsets.only(
                        left: 20,
                        right: 20,
                      ),
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
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff6222ec)),
                        controller: agencyNumberController,
                        keyboardType: TextInputType.phone,
                        cursorColor: Color(0xff6222ec),
                        decoration: InputDecoration(
                          prefixText: '+213',
                            suffixIcon: Icon(
                              Icons.phone_outlined,
                              color: Color(0xffFFC100),
                              size: 15,
                            ),
                            hintText: "Agency Phone Number",
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintStyle: TextStyle(
                                fontWeight: FontWeight.w300,
                                fontSize: 10,
                                letterSpacing: 1.5,
                                color: Color(0xff6222ec))),
                      ),
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
                        style:
                            TextStyle(fontSize: 12, color: Color(0xff6222ec)),
                        controller: agencyNameController,
                        keyboardType: TextInputType.text,
                        cursorColor: Color(0xff6222ec),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 10,
                              letterSpacing: 1.5,
                              color: Color(0xff6222ec)),
                          icon: Icon(
                            Icons.real_estate_agent,
                            color: Color(0xffFFC100),
                            size: 15,
                          ),
                          hintText: "Agency Name",
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
                          color: Colors.grey[200],
                          boxShadow: [
                            BoxShadow(
                                offset: Offset(0, 10),
                                blurRadius: 50,
                                color: Color(0xffEEEEEE)),
                          ],
                        ),
                        child: InkWell(
                            onTap: () {
                              getCr();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Commercial Register',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w300,
                                      letterSpacing: 1.5,
                                      color: Color(0xff6222ec)),
                                ),
                                SizedBox(
                                  width: 24,
                                ),
                                Icon(
                                  Icons.add_a_photo_outlined,
                                  color: Color(0xffFFC100),
                                  size: 15,
                                )
                              ],
                            ))),
                    SizedBox(height: 20),
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                          image: _crFile == null
                              ? null
                              : DecorationImage(
                                  image: FileImage(_crFile ?? File('')),
                                  fit: BoxFit.cover)),
                    ),
                    loading
                        ? Center(
                            child: CircularProgressIndicator(
                            color: Color(0xffFFC100),
                          ))
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                loading = !loading;
                                _addAgency();
                                ;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin:
                                  EdgeInsets.only(left: 20, right: 20, top: 26),
                              padding: EdgeInsets.only(left: 20, right: 20),
                              height: 54,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      (new Color(0xffFFC100)),
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
                                "Continue",
                                style: TextStyle(
                                  letterSpacing: 2,
                                  fontSize: 10,
                                  color: Color(0xff6222ec),
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class RegisterClient extends StatefulWidget {
  final String email;

  const RegisterClient({Key? key, required this.email}) : super(key: key);

  @override
  State<RegisterClient> createState() => _RegisterClientState();
}

class _RegisterClientState extends State<RegisterClient> {
  @override
  GlobalKey<FormState> formKey3 = GlobalKey<FormState>();
  bool loading = false;
  TextEditingController userNameController = TextEditingController();
  File? _imageFile;
  final _picker = ImagePicker();
  Future getPic() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  void _addClient() async {
    String? profilePic = _imageFile == null ? null : getStringImage(_imageFile);
    ApiResponse response =
        await addClient(widget.email, userNameController.text, profilePic);
    if (response.error == null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: Colors.red, content: Text('${response.error}')));
      setState(() {
        loading = !loading;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        backgroundColor: Colors.white,
        body: Center(
          child: Form(
            key: formKey3,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: AnimationConfiguration.toStaggeredList(
                  duration: const Duration(milliseconds: 500),
                  childAnimationBuilder: (widget) => SlideAnimation(
                    horizontalOffset: 50.0,
                    child: FadeInAnimation(
                      child: widget,
                    ),
                  ),
                  children: [
                    Text(
                      'Register Client',
                      style: TextStyle(
                          color: Color(0xff6222ec),
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                    SizedBox(height: 35,),
                    GestureDetector(
                        onTap: () {
                          getPic();
                        },
                        child: Stack(
                          children: [
                            Container(
                              width: 130,
                              height: 130,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1),
                                      offset: Offset(0, 10))
                                ],
                                shape: BoxShape.circle,
                                image: _imageFile == null
                                    ? null
                                    : DecorationImage(
                                        image:
                                            FileImage(_imageFile ?? File('')),
                                      ),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Theme.of(context)
                                          .scaffoldBackgroundColor,
                                    ),
                                    color: Color(0xff6222ec),
                                  ),
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                )),
                          ],
                        )),
                    SizedBox(height: 10),
                    Text(
                      "Profile Picture",
                      style: TextStyle(
                          color: Color(0xff6222ec),
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.w300,
                          fontSize: 10),
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
                        style:
                        TextStyle(fontSize: 12, color: Color(0xff6222ec)),
                        controller: userNameController,
                        keyboardType: TextInputType.text,
                        cursorColor: Color(0xffFFC100),
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                              fontWeight: FontWeight.w300,
                              fontSize: 10,
                              letterSpacing: 1.5,
                              color: Color(0xff6222ec)),
                          icon: Icon(
                            Icons.perm_identity,
                            color: Color(0xffFFC100),
                            size: 15,
                          ),
                          hintText: "User Name",
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(height: 40),
                    loading
                        ? Center(
                            child: CircularProgressIndicator(
                            color: Color(0xffFFC100),
                          ))
                        : GestureDetector(
                            onTap: () {
                              setState(() {
                                loading = !loading;
                                _addClient();
                                ;
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              margin:
                                  EdgeInsets.only(left: 20, right: 20, top: 26),
                              padding: EdgeInsets.only(left: 20, right: 20),
                              height: 54,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                      (new Color(0xffFFC100)),
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
                                "Continue",
                                style: TextStyle(
                                    letterSpacing: 2,
                                    color: Color(0xff6222ec),
                                    fontWeight: FontWeight.w300,
                                    fontSize: 10),
                              ),
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
