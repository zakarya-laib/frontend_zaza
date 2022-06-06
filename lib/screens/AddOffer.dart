import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zaza/screens/Agencyoffers.dart';
import 'package:zaza/screens/header_widget.dart';
import 'package:zaza/models/api_response.dart';
import 'package:zaza/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoder/geocoder.dart';
class AddOffer extends StatefulWidget {
  final double x;
  final double y;
  const AddOffer({Key? key, required this.x, required this.y})
      : super(key: key);
  @override
  State<AddOffer> createState() => _AddOfferState();
}
class _AddOfferState extends State<AddOffer> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = false;
  var agencyName;
  String dropdownvalue = 'Villa';
  var items = ['Villa', 'Appartement', 'Garage', 'Lot'];
  String dropdownvalue2 = 'For Sale';
  var items2 = ['For Sale', 'For Rent'];
  TextEditingController priceController = TextEditingController(),
      descriptionController = TextEditingController(),
      surfaceController = TextEditingController(),
      roomsController = TextEditingController();
  void _addOffer() async {
    var coordinates = new Coordinates(widget.x,widget.y);
    var address = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    ApiResponse response = await addOffer(
        agencyName,
        dropdownvalue2,
        priceController.text+"\$",
        dropdownvalue,
        widget.x.toString(),
        widget.y.toString(),
        address.first.subAdminArea+','+address.first.adminArea+','+address.first.countryName,
        descriptionController.text ,
        roomsController.text ,
        surfaceController.text ,
        'img1',
        'img2',
        'img3',
        'img4');
    if (response.error == null) {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => Step2(x:widget.x.toString())),
              (route) => false);;
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
        child: Scaffold(appBar: AppBar( title: Text(
          'Offer Form',
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w500,
              fontSize: 14),
        ),
          centerTitle: true,leading:IconButton(
    icon: Icon(
      Icons.arrow_back,
      color: Colors.white,
    ),
    onPressed: () {
    Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => AgencyOffers()),
    (route) => false);}),),
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
                              Container(
                                  height: 200,
                                  child: HeaderWidget(
                                      200, true, Icons.add_home_work_outlined)),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SetLocation()));
                                },
                                child: Container(
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Location',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            color: Color(0xff6222ec),
                                            fontSize: 10,
                                            letterSpacing: 1.5,
                                          )),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Icon(
                                        Icons.location_on_outlined,
                                        color: Color(0xff6222ec),
                                        size: 15,
                                      ),
                                    ],
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
                                    isExpanded: true,
                                    iconEnabledColor: Color(0xffFFC100),
                                    value: dropdownvalue2,
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
                                  controller: priceController,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Color(0xff6222ec),
                                  decoration: InputDecoration(
                                    suffixText: "\$",
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
                                    hintText: "Price",
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
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
                                  controller: descriptionController,
                                  keyboardType: TextInputType.text,
                                  cursorColor: Color(0xff6222ec),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff6222ec),
                                      fontSize: 10,
                                      letterSpacing: 1.5,
                                    ),
                                    icon: Icon(
                                      Icons.description_outlined,
                                      color: Color(0xffFFC100),
                                      size: 15,
                                    ),
                                    hintText: "Description",
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
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
                                  controller: roomsController,
                                  keyboardType: TextInputType.number,
                                  cursorColor: Color(0xff6222ec),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff6222ec),
                                      fontSize: 10,
                                      letterSpacing: 1.5,
                                    ),
                                    icon: Icon(
                                      Icons.bed_rounded,
                                      color: Color(0xffFFC100),
                                      size: 15,
                                    ),
                                    hintText: "Rooms",
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
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
                                  controller: surfaceController,
                                  keyboardType: TextInputType.text,
                                  cursorColor: Color(0xff6222ec),
                                  decoration: InputDecoration(
                                    hintStyle: TextStyle(
                                      fontWeight: FontWeight.w300,
                                      color: Color(0xff6222ec),
                                      fontSize: 10,
                                      letterSpacing: 1.5,
                                    ),
                                    icon: Icon(
                                      Icons.energy_savings_leaf_outlined,
                                      color: Color(0xffFFC100),
                                      size: 15,
                                    ),
                                    hintText: "Surface",
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              SizedBox(height: 15),
                              loading
                                  ? Center(
                                      child: CircularProgressIndicator(
                                          color: Color(0xffFFC100)))
                                  : GestureDetector(
                                      onTap: () async {
                                        var userEmail = await getEmail();
                                        ApiResponse response2 =
                                            await getAgencyName(userEmail);
                                        var jsonRespo = response2.data
                                            as Map<String, dynamic>;
                                        agencyName = jsonRespo['agency'][0]
                                            ['agency_name'];
                                        if (formKey.currentState!.validate()) {
                                          setState(() {
                                            loading = true;
                                          });
                                            _addOffer();
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.only(
                                            left: 20, right: 20, top: 20),
                                        padding: EdgeInsets.only(
                                            left: 20, right: 20),
                                        height: 54,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              colors: [
                                                (new Color(0xffFFC100)),
                                                new Color(0xffFFC100)
                                              ],
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight),
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          color: Colors.grey[200],
                                          boxShadow: [
                                            BoxShadow(
                                                offset: Offset(0, 10),
                                                blurRadius: 50,
                                                color: Color(0xffEEEEEE)),
                                          ],
                                        ),
                                        child: Text(
                                          "Next",
                                          style: TextStyle(
                                            letterSpacing: 2,
                                            fontSize: 10,
                                            color: Color(0xff6222ec),
                                            fontWeight: FontWeight.w300,
                                          ),
                                        ),
                                      ),
                                    ),
                              SizedBox(
                                height: 8,
                              )
                            ]))))));
  }
}

class Step2 extends StatefulWidget {
  final String x;
  const Step2({Key? key, required this.x}) : super(key: key);
  @override
  State<Step2> createState() => _Step2State();
}
class _Step2State extends State<Step2> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool loading = true;
  var id;
  void getId() async {
    ApiResponse response = await getOfferInfos(widget.x);
    var jsonRespo = response.data as Map<String, dynamic>;
    id = jsonRespo['offer'][0]['id'];
    if (response.error == null) {
      setState(() {
        loading = false;
      });
    }
  }
  void upPics() async {
 await upImg1(getStringImage(_img1File), id);
   await upImg2(getStringImage(_img2File), id);
   await upImg3(getStringImage(_img3File), id);
     await upImg4(getStringImage(_img4File), id);
    setState(()async {
      await upImg1(getStringImage(_img1File), id);
      await upImg2(getStringImage(_img2File), id);
      await upImg3(getStringImage(_img3File), id);
      await upImg4(getStringImage(_img4File), id);
      loading = false;
    });
  }
  String img1 = '';
  String img2 = '';
  String img3 = '';
  String img4 = '';
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
    if (pickedFile != null) {
      setState(() {
        _img1File = File(pickedFile.path);
      });
    }
  }
  Future getImg2() async {
    final pickedFile = await _picker2.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _img2File = File(pickedFile.path);
      });
    }
  }
  Future getImg3() async {
    final pickedFile = await _picker3.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _img3File = File(pickedFile.path);
      });
    }
  }
  Future getImg4() async {
    final pickedFile = await _picker4.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _img4File = File(pickedFile.path);
      });
    }
  }
  @override
  void initState() {
    getId();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
          title: Text(
            'Add Pictures',
            style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => AgencyOffers()),
                  (route) => false);
            },
          ),
          backgroundColor: Color(0xffFFC100)),
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
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
                        SizedBox(
                          height: 25,
                        ),
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
                                          image: _img1File == null
                                              ? img1 != null
                                                  ? DecorationImage(
                                                      image: NetworkImage(img1),
                                                      fit: BoxFit.cover)
                                                  : null
                                              : DecorationImage(
                                                  image: FileImage(
                                                      _img1File ?? File('')),
                                                  fit: BoxFit.cover),
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
                                            Icons.add_a_photo_outlined,
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
                                          image: _img2File == null
                                              ? img2 != null
                                                  ? DecorationImage(
                                                      image: NetworkImage(img2),
                                                      fit: BoxFit.cover)
                                                  : null
                                              : DecorationImage(
                                                  image: FileImage(
                                                      _img2File ?? File('')),
                                                  fit: BoxFit.cover),
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
                                            Icons.add_a_photo_outlined,
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
                                          image: _img3File == null
                                              ? img3 != null
                                                  ? DecorationImage(
                                                      image: NetworkImage(img3),
                                                      fit: BoxFit.cover)
                                                  : null
                                              : DecorationImage(
                                                  image: FileImage(
                                                      _img3File ?? File('')),
                                                  fit: BoxFit.cover),
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
                                            Icons.add_a_photo_outlined,
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
                                          image: _img4File == null
                                              ? img4 != null
                                                  ? DecorationImage(
                                                      image: NetworkImage(img4),
                                                      fit: BoxFit.cover)
                                                  : null
                                              : DecorationImage(
                                                  image: FileImage(
                                                      _img4File ?? File('')),
                                                  fit: BoxFit.cover),
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
                                            Icons.add_a_photo_outlined,
                                            color: Colors.white,
                                          ),
                                        )),
                                  ],
                                )),
                          ],
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        loading
                            ? Center(
                                child: CircularProgressIndicator(
                                color: Color(0xffFFC100),
                              ))
                            : GestureDetector(
                                onTap: () {
                                  if (formKey.currentState!.validate()) {
                                    setState(() {
                                      loading = true;
                                    });
                                    upPics();
                                    Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AgencyOffers()),
                                        (route) => false);
                                  }
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 26),
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
                        SizedBox(
                          height: 8,
                        )
                      ]))),
        ),
      ),
    ));
  }
}

class SetLocation extends StatefulWidget {
  const SetLocation({Key? key}) : super(key: key);

  @override
  State<SetLocation> createState() => _SetLocationState();
}

class _SetLocationState extends State<SetLocation> {
  late GoogleMapController mapController;
  late double x;
  late double y;
  final Set<Marker> markers = new Set();
  final LatLng _center = const LatLng(36, 6);
  late LatLng lastPosition;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _setPosition(LatLng pos) {
    lastPosition = pos;
    setState(() {
      markers.clear();
      markers.add(Marker(
        markerId: MarkerId(pos.toString()),
        position: pos, //position of marker
        infoWindow: InfoWindow(
          title: 'Offer Location',
        ),
        icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet), //Icon for Marker
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Choose Location',
            style: TextStyle(
                color: Colors.white,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w500,
                fontSize: 14),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddOffer(x: x, y: y)));
            },
          ),
        ),
        body: GoogleMap(
          mapType: MapType.normal,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          markers: markers,
          onTap: (LatLng pos) {
            _setPosition(pos);

            x = pos.latitude;
            y = pos.longitude;
          },
        ),
      ),
    );
  }
}
