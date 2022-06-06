import 'dart:io';
import 'package:zaza/screens/Agencyoffers.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:zaza/models/api_response.dart';
import 'package:zaza/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
class EditOffer extends StatefulWidget {
  final int id ;
  const EditOffer({Key? key,required this.id}) : super(key: key);

  @override
  State<EditOffer> createState() => _EditOfferState();
}

class _EditOfferState extends State<EditOffer> {
  String img1='';
  String img2='';
  String img3='';
  String img4='';
  bool loading = true;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String dropdownvalue='Lot';
  var items = ['Villa', 'Appartement', 'Garage', 'Lot'];
   String dropdownvalue2='For Sale' ;
  var items2 = ['For Sale', 'For Rent'];
  File? _img1File;
  File? _img2File;
  File? _img3File;
  File? _img4File;
  final _picker = ImagePicker();
  final _picker2 = ImagePicker();
  final _picker3 = ImagePicker();
  final _picker4 = ImagePicker();
  TextEditingController offerPriceController = TextEditingController();
  Future getImg1() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null){
      setState(() {
        _img1File = File(pickedFile.path);
      });
    }
  }
  Future getImg2() async {
    final pickedFile = await _picker2.pickImage(source: ImageSource.gallery);
    if (pickedFile != null){
      setState(() {
        _img2File = File(pickedFile.path);
      });
    }
  }
  Future getImg3() async {
    final pickedFile = await _picker3.pickImage(source: ImageSource.gallery);
    if (pickedFile != null){
      setState(() {
        _img3File = File(pickedFile.path);
      });
    }
  }
  Future getImg4() async {
    final pickedFile = await _picker4.pickImage(source: ImageSource.gallery);
    if (pickedFile != null){
      setState(() {
        _img4File = File(pickedFile.path);
      });
    }
  }
  // get offer details
  void getUser() async {
    ApiResponse response = await getOfferDetails(widget.id);
    var jsonRespo =response.data as Map<String,dynamic>;
    var offerType = jsonRespo['offer'][0]['offer_type'];
    var offerPrice = jsonRespo['offer'][0]['offer_price'];
    var propertyType = jsonRespo['offer'][0]['property_type'];
    img1= jsonRespo['offer'][0]['image1'];
    img2= jsonRespo['offer'][0]['image2'];
    img3= jsonRespo['offer'][0]['image3'];
    img4= jsonRespo['offer'][0]['image4'];
    if(response.error == null ) {
      setState(() {
        loading = false;
        offerPriceController.text = offerPrice;
        dropdownvalue=propertyType;
        dropdownvalue2=offerType;
      });
    }
  }
  //update offer
  void upPics() async {
    ApiResponse response = await upOfferType(dropdownvalue2,widget.id);
    ApiResponse response2 = await upOfferPrice(offerPriceController.text+" \$",widget.id);
    ApiResponse response4 = await upPropertyType(dropdownvalue,widget.id);
    ApiResponse response5 = await upImg1(getStringImage(_img1File),widget.id);
    ApiResponse response6 = await upImg2(getStringImage(_img2File),widget.id);
    ApiResponse response7 = await upImg3(getStringImage(_img3File),widget.id);
    ApiResponse response8 = await upImg4(getStringImage(_img4File),widget.id);
    setState(() {
      loading = false;
    });
    if(response.error == null && response2.error == null && response4.error == null && response5.error == null && response6.error == null && response7.error == null && response8.error == null){
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
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(centerTitle:true,iconTheme: IconThemeData(color:Colors.white),title:Text('Edit Offer', style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w500,
                fontSize: 14),)),
            resizeToAvoidBottomInset: true,
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                child: Form(
                    key: formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: AnimationConfiguration.toStaggeredList(
                            duration: const Duration(milliseconds: 500),
                            childAnimationBuilder: (widget) => SlideAnimation(
                              horizontalOffset: 50.0,
                              child: FadeInAnimation(
                                child: widget,
                              ),
                            ),
                            children: [
                              SizedBox(height: 25,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        getImg1();
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
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      offset: Offset(0, 10))
                                                ],
                                                shape: BoxShape.rectangle,
                                                image:_img1File == null ? img1 != null ? DecorationImage(
                                                    image:NetworkImage(img1),
                                                    fit: BoxFit.cover): null : DecorationImage(
                                                    image: FileImage(_img1File ?? File('')),
                                                    fit: BoxFit.cover
                                                ),
                                              )),
                                          Positioned(
                                              bottom: 10,
                                              right: 10,
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    width: 4,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                  color: Color(0xff6222ec),
                                                ),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ],
                                      )),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        getImg2();
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
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      offset: Offset(0, 10))
                                                ],
                                                shape: BoxShape.rectangle,
                                                image: _img2File == null ? img2 != null ? DecorationImage(
                                                    image: NetworkImage(img2),
                                                    fit: BoxFit.cover): null : DecorationImage(
                                                    image: FileImage(_img2File ?? File('')),
                                                    fit: BoxFit.cover
                                                ),
                                              )),
                                          Positioned(
                                              bottom: 10,
                                              right: 10,
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    width: 4,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                  color: Color(0xff6222ec),
                                                ),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ],
                                      )),
                                ],
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        getImg3();
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
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      offset: Offset(0, 10))
                                                ],
                                                shape: BoxShape.rectangle,
                                                image: _img3File == null ? img3 != null ? DecorationImage(
                                                    image: NetworkImage(img3),
                                                    fit: BoxFit.cover): null : DecorationImage(
                                                    image: FileImage(_img3File ?? File('')),
                                                    fit: BoxFit.cover
                                                ),
                                              )),
                                          Positioned(
                                              bottom: 10,
                                              right: 10,
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    width: 4,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                  color: Color(0xff6222ec),
                                                ),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ],
                                      )),
                                  SizedBox(
                                    width: 15,
                                  ),
                                  GestureDetector(
                                      onTap: () {
                                        getImg4();
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
                                                      color: Colors.black
                                                          .withOpacity(0.1),
                                                      offset: Offset(0, 10))
                                                ],
                                                shape: BoxShape.rectangle,
                                                image: _img4File == null ? img4 != null ?  DecorationImage(
                                                    image: NetworkImage(img4),
                                                    fit: BoxFit.cover): null : DecorationImage(
                                                    image: FileImage(_img4File ?? File('')),
                                                    fit: BoxFit.cover
                                                ),
                                              )),
                                          Positioned(
                                              bottom: 10,
                                              right: 10,
                                              child: Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.rectangle,
                                                  border: Border.all(
                                                    width: 4,
                                                    color: Theme.of(context)
                                                        .scaffoldBackgroundColor,
                                                  ),
                                                  color: Color(0xff6222ec),
                                                ),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: Colors.white,
                                                ),
                                              )),
                                        ],
                                      )),
                                ],
                              ),
                              Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
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
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
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
                                    value: dropdownvalue2,
                                    isExpanded: true,
                                    iconEnabledColor: Color(0xffFFC100),
                                    items: items2.map((String items) {
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
                                        dropdownvalue2 = newValue!;
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
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 20),
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
                                  style: TextStyle(
                                      fontSize: 12, color: Color(0xff6222ec)),
                                  controller: offerPriceController,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Color(0xff6222ec),
                                  decoration: InputDecoration(
                                    suffixText:"\$",
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff6222ec),
                                      fontSize: 10,
                                      letterSpacing: 1.5,
                                    ),
                                    icon: Icon(
                                      Icons.price_change,
                                      color: Color(0xffFFC100),
                                      size: 15,
                                    ),
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 15,
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
                                    upPics();
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
                              ),
                              SizedBox(height: 8,)

                            ]))))));
  }
}