import 'dart:io';
import 'package:zaza/screens/Agencyoffers.dart';
import 'package:zaza/models/api_response.dart';
import 'package:zaza/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'header_widget.dart';
class AgencyProfile extends StatefulWidget {
  @override
  _AgencyProfileState createState() => _AgencyProfileState();
}
class _AgencyProfileState extends State<AgencyProfile> {
  String userEmail = '' ;
  String pic = '';
  bool loading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  File? _imageFile;
  final _picker = ImagePicker();
  TextEditingController txtNameController = TextEditingController();
  TextEditingController txtNumController = TextEditingController();
  Future getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null){
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
  // get user details
  void getUser() async {
    userEmail= await getEmail();
    ApiResponse response = await getAgencyName(userEmail);
    var jsonRespo =response.data as Map<String,dynamic>;
    var agencyName = jsonRespo['agency'][0]['agency_name'];
    ApiResponse response2 = await  getAgencyInfos(agencyName);
    var jsonRespo2 =response2.data as Map<String,dynamic>;
    var agencyLogo = jsonRespo2['agency'][0]['agency_logo'];
    var agencyNum = jsonRespo2['agency'][0]['agency_phone_number'];
    pic = agencyLogo ;
    if(response.error == null && response2.error == null && response2.error == null) {
      setState(() {
        loading = false;
        txtNameController.text = agencyName;
        txtNumController.text = agencyNum;
      });
    }

  }
  //update profile
  void updateProfile() async {
    ApiResponse response = await upAgencyLogo(getStringImage(_imageFile),userEmail);
    ApiResponse response2 = await upAgencyName(txtNameController.text,userEmail);
    ApiResponse response3 = await upAgencyNum(txtNumController.text,userEmail);
    setState(() {
      loading = false;
    });
    if(response.error == null && response2.error == null && response3.error == null){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('${response.data}')
      ));
    }

  }

  @override
  void initState() {
    getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return loading ? Center(child: CircularProgressIndicator(),) : Scaffold(resizeToAvoidBottomInset: true,
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: Form(  key: formKey,
          child: ListView(
            children: [
              SizedBox(
                height: 25,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  Text(
                    'My Profile',
                    style: TextStyle(
                        color: Color(0xff6222ec),
                        letterSpacing: 1.5,
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ],
              ),
              SizedBox(height: 35,),

              Center(
                child: GestureDetector(
                  child: Stack(
                    children: [

                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                            border: Border.all(
                                width: 4,
                                color: Theme.of(context).scaffoldBackgroundColor),
                            boxShadow: [
                              BoxShadow(
                                  spreadRadius: 2,
                                  blurRadius: 10,
                                  color: Colors.black.withOpacity(0.1),
                                  offset: Offset(0, 10))
                            ],
                            shape: BoxShape.circle,
                            image: _imageFile == null ? pic != null ? DecorationImage(
                                image: NetworkImage(pic),
                                fit: BoxFit.cover
                            ) : null : DecorationImage(
                                image: FileImage(_imageFile ?? File('')),
                                fit: BoxFit.cover
                            ),
                            color: Colors.amber
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
                                color: Theme.of(context).scaffoldBackgroundColor,
                              ),
                              color: Color(0xff6222ec),
                            ),
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          )),
                    ],
                  ),
                  onTap: (){
                    getImage();
                  },
                ),
              ),
              SizedBox(
                height: 35,
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
                        color: Color(0xffEEEEEE)
                    ),
                  ],
                ),
                child:
                TextFormField(
                  style: TextStyle(fontSize: 12,color:Color(0xff6222ec)),
                  controller: txtNameController,
                  keyboardType: TextInputType.name,
                  cursorColor: Color(0xff6222ec),
                  decoration: InputDecoration(hintStyle:TextStyle(fontWeight: FontWeight.w300,color: Color(0xff6222ec),
                    fontSize: 10,
                    letterSpacing: 1.5,),
                    icon: Icon(
                      Icons.real_estate_agent,
                      color: Color(0xffFFC100),size: 15,
                    ),

                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),


              ),

              Container(alignment: Alignment.center,
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
                        color: Color(0xffEEEEEE)
                    ),
                  ],
                ),
                child: TextFormField(
                  style: TextStyle(fontSize: 12,color:Color(0xff6222ec)),
                  controller: txtNumController,
                  keyboardType: TextInputType.phone,
                  cursorColor: Color(0xff6222ec),
                  decoration: InputDecoration(hintStyle:TextStyle(fontWeight: FontWeight.w300,color: Color(0xff6222ec),
                    fontSize: 10,
                    letterSpacing: 1.5,),

                   icon: Icon(
                      Icons.phone,
                      color: Color(0xffFFC100),size: 15,
                    ),

                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              loading
                  ? Center(
                  child: CircularProgressIndicator(
                    color: Color(0xffFFC100),
                  ))
                  :RaisedButton(
                onPressed: () {
                  if(formKey.currentState!.validate()){
                    setState(() {
                      loading = true;
                    });
                    updateProfile();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) =>
                                AgencyOffers()),
                            (route) => false);
                  }},
                color: Color(0xffFFC100),
                padding: EdgeInsets.symmetric(horizontal: 50),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                child: Text(
                  "Save",
                  style: TextStyle(
                      letterSpacing: 2,fontSize: 10,
                      color: Color(0xff6222ec),
                      fontWeight: FontWeight.w300),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
