import 'package:zaza/screens/constant.dart';
import 'package:zaza/screens/OfferDetails.dart';
import 'package:zaza/screens/login_screen.dart';
import 'AgencyProfile.dart';
import 'AddOffer.dart';
import 'EditOffer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:animated_card/animated_card.dart';
import 'package:zaza/models/api_response.dart';
import 'package:zaza/models/offer.dart';
import 'package:zaza/services/user_service.dart';
class AgencyOffers extends StatefulWidget {

  const AgencyOffers({Key? key}) : super(key: key);

  @override
  State<AgencyOffers> createState() => _AgencyOffersState();
}
class _AgencyOffersState extends State<AgencyOffers> {
  late Widget p ;
  int currentIndex=1;
  @override
  void initState() {
    p=myOffers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        bottomNavigationBar:BottomNavigationBar(
            selectedItemColor:Color(0xffFFC100),
            currentIndex: currentIndex,
            unselectedItemColor:Color(0x976222ec),
            items:[
              BottomNavigationBarItem(label:'Profile',icon:Icon(Icons.person,size: 20,)),
              BottomNavigationBarItem(label:'My Offers',icon:Icon(FontAwesomeIcons.city,size: 16,)),
              BottomNavigationBarItem(label:'Add Offer',icon:Icon(Icons.add_home_work_rounded,size: 18,)),
              BottomNavigationBarItem(label:'Log Out',icon:Icon(Icons.logout,size: 18)),
            ],
            onTap:(index) {
              setState(() {
                if (index == 0) {
                  setState(() {
                    debugPrint('profile');
                    currentIndex=index;
                   p=AgencyProfile() ;

                  });
                }
                if (index == 1) {
                  setState(() {
                    debugPrint('home');
                    currentIndex=index;
                    p=myOffers() ;

                  });
                }
                if (index == 2) {
                  setState(() {
                    debugPrint('add offer');
                    currentIndex=index;
                    p=AddOffer(x:0.1,y:0.1);
                  });
                }
                if (index == 3) {
                  setState(() {
                    debugPrint('log out');
                    currentIndex=index;
                    logout().then((value)=>{Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) =>LoginScreen()), (
                    route) => false)});
                  });
                }

              }
              );}
        ),
        body: p,
      ),
    );
  }
}
class myOffers extends StatefulWidget{
  const myOffers({Key? key}) : super(key: key);
  @override
  _myOffers createState()=> _myOffers();
}
class _myOffers extends State<myOffers> {
  List<dynamic> _offersList =[];
  bool _loading = true;
  var agencyName ;
  // get agency offers
  Future<void> _agencyOffers() async {
    var userEmail= await getEmail();
    ApiResponse response2 = await getAgencyName(userEmail);
    var jsonRespo =response2.data as Map<String,dynamic>;
     agencyName = jsonRespo['agency'][0]['agency_name'];
    ApiResponse response = await agencyOffers(agencyName);
    if(response.error == null){
      setState(() {
        _offersList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }
  @override
  void initState() {
    _agencyOffers();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return _loading ? Center(child:CircularProgressIndicator()) :RefreshIndicator(
      onRefresh: () {
        return _agencyOffers();
      },
      child:DraggableHome(
          headerExpandedHeight: 0.1,
          headerWidget:  Padding(
            padding: const EdgeInsets.only(bottom:10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('zaza', style: TextStyle(letterSpacing: 2, fontSize: 15,color:Colors.white)),
                SizedBox(width: 5,),
                Container(height: 18,
                  width: 18,
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(9),
                      image: DecorationImage(
                          image: AssetImage('photos/zaza2.png'))),)
              ],
            ),
          ),
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('', style: TextStyle(letterSpacing: 2, fontSize: 15,color: Colors.white)),
            ],
          ),
          body: [
            AnimationLimiter(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 0),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount:  _offersList.length,
                itemBuilder: (BuildContext context, int index) {
                  Offer offer = _offersList[index];
                  return AnimationConfiguration.staggeredList(
                    position: index,
                    duration: const Duration(milliseconds: 375),
                    child: SlideAnimation(
                      verticalOffset: 50.0,
                      child: FadeInAnimation(child:
                      AnimatedCard(
                        direction: AnimatedCardDirection.left,
                        //Initial animation direction
                        initDelay: Duration(milliseconds: 0),
                        //Delay to initial animation
                        duration: Duration(seconds: 1),
                        //Initial animation duration
                        //onRemove: () => titre.removeAt(index),
                        //Implement this action to active dismiss
                        curve: Curves.ease,
                        //Animation curve
                        child: InkWell(onTap:() async{
                  ApiResponse response = await getAgencyInfos('${offer.offer_agency_name}');
                  var jsonRespo = response.data as Map<String, dynamic>;
                  var agencyLogo = jsonRespo['agency'][0]['agency_logo'];
                  var agencyNumber = jsonRespo['agency'][0]['agency_phone_number'];
                  var agencyEmail = jsonRespo['agency'][0]['agency_email'];
                  Navigator.push(context,MaterialPageRoute(builder: (context)=>DetailsPage(offer_id:offer.id!,offer_agency_name:'${offer.offer_agency_name}',agency_logo:agencyLogo,agency_phone:agencyNumber,agency_email:agencyEmail,description:'${offer.offer_description}',rooms:'${offer.number_of_rooms}',address:'${offer.address}',surface:'${offer.surface}',image1:'${offer.image1}',image2:'${offer.image2}',image3:'${offer.image3}',image4:'${offer.image4}', property_type: '${offer.property_type}', offer_type: '${offer.offer_type}', offer_price: '${offer.offer_price}')));},
                          child: Stack( alignment: Alignment.topRight,
                            children: [Card(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius
                                  .circular(23)),
                              color: Colors.white,
                              shadowColor: Color(0xffFFC100),
                              elevation: 5,
                              margin: EdgeInsets.fromLTRB(10, 15, 10, 15),
                              child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 8,bottom:8,left:8),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(23),
                                        child: Container(height: 150,
                                          width: 150,

                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      '${offer.image1}'),
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                    ),
                                    Container(width: 160,margin: EdgeInsets.only(left:8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(Icons.home_work_outlined, size: 15,
                                                color: Color(0xffFFC100),),
                                              SizedBox(width: 8,),
                                              Text('${offer.property_type}',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 10,
                                                    letterSpacing: 1.5,
                                                    color: Color(0xff6222ec),)),

                                            ],
                                          ),
                                          SizedBox(height: 12,),
                                          Row(
                                              children: [

                                                SizedBox(width: 23,),
                                                Text('${offer.offer_type}',
                                                    style: TextStyle( fontWeight: FontWeight.w300,
                                                      fontSize: 10,
                                                      letterSpacing: 1.5,
                                                      color:Color(0xff6222ec),)),
                                              ] ),
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

                                          SizedBox(height: 12,),
                                          SingleChildScrollView(scrollDirection: Axis.horizontal,
                                            child: Row(
                                              children: [
                                                Icon(Icons.price_change, size: 15,
                                                  color: Color(0xffFFC100),),
                                                SizedBox(width: 8,),
                                                Text('${offer.offer_price}',
                                                    style: TextStyle(
                                                        fontWeight: FontWeight.w300,
                                                        fontSize: 10,
                                                        letterSpacing: 1.5,
                                                        color:Color(0xff6222ec))),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 8,),
                                        ],
                                      ),
                                    ),
                                  ]
                              ),
                            ),


                              Padding(
                                padding: const EdgeInsets.only(top:20.0,right:10),
                                child: PopupMenuButton(
                                  itemBuilder: (BuildContext context)=>[
                                    PopupMenuItem(
                                        child: Text('Edit',style: TextStyle(fontWeight: FontWeight.w200,
                                            fontSize: 10,
                                            letterSpacing: 1.5,
                                            color:Color(0xff6222ec)),),
                                        value: 'edit'
                                    ),
                                    PopupMenuItem(
                                        child: Text('Delete',style: TextStyle(fontWeight: FontWeight.w200,
                                            fontSize: 10,
                                            letterSpacing: 1.5,
                                            color:Color(0xff6222ec))),
                                        value: 'delete'
                                    )
                                  ],
                                  onSelected: (val) async {
                                    if(val == 'edit'){
                  Navigator.push(context,MaterialPageRoute(builder:(context)=>EditOffer(id:offer.id ?? 0)));
                                    } else {
                                      ApiResponse response = await deleteOffer(offer.id ?? 0);
                                      if (response.error == null){
                                        _agencyOffers();
                                      }
                                      else if(response.error == unauthorized){
                                        logout().then((value) => {
                                          Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false)
                                        });
                                      }
                                      else {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text('${response.error}')
                                        ));
                                      }
                                    }
                                  },
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

          ]
      ),
    );

  }
}



