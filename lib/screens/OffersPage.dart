import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'login_screen.dart';
import 'package:zaza/screens/OfferDetails.dart';
import 'package:zaza/screens/ClientProfile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:animated_card/animated_card.dart';
import 'package:zaza/models/api_response.dart';
import 'package:zaza/models/offer.dart';
import 'package:zaza/services/user_service.dart';
import 'MapPage.dart';
class OffersPage extends StatefulWidget{
  const OffersPage({Key? key}) : super(key: key);
  @override
  _OffersPage createState()=> _OffersPage();
}
class _OffersPage extends State<OffersPage> {
  
  List<dynamic> my_offersList = [];
  Set<Marker> markers = new Set();
  late Widget p ;
 int currentIndex=1;
  Future<void> getMarkersData() async {
    ApiResponse response = await getOffers();
    if (response.error == null) {
      setState(() {
        my_offersList = response.data as List<dynamic>;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}'),
      ));
    }
  }
  Set<Marker> getmarkers() {
    var i;
    setState(() {
      for (i = 0; i < my_offersList.length; i++) {
        Offer offer = my_offersList[i];
        var x = offer.x;
        print(x);
        var y = offer.y;
        var oft = offer.offer_type;
        print(oft);
        var pt = offer.property_type;
        markers.add(Marker(
          markerId: MarkerId(offer.x.toString()),
          position: LatLng(double.parse(x!), double.parse(y!)), //position of marker
          infoWindow: InfoWindow(
            title: pt,
            snippet: oft,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueViolet), //Icon for Marker
        ));
      }
    });
    return markers;
  }
  @override
  void initState() {
    p=HomePage();
    getMarkersData();
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
           BottomNavigationBarItem(label:'Offers',icon:Icon(FontAwesomeIcons.city,size: 16,)),
           BottomNavigationBarItem(label:'Map',icon: Icon(FontAwesomeIcons.mapLocationDot,size: 16)),
           BottomNavigationBarItem(label:'Log Out',icon:Icon(Icons.logout,size: 16)),
          ],
          onTap:(index) {
             setState(() {
               if (index == 0) {
                 setState(() {
                   debugPrint('profile');
                   currentIndex=index;
                   p=ClientProfile() ;

                 });
               }
            if (index == 1) {
              setState(() {
                debugPrint('home');
                currentIndex=index;
                p=HomePage() ;

              });
            }
            if (index == 2) {
              
              setState(() {
                debugPrint('map');
                currentIndex=index;
                getmarkers();
                p=MapPage(markers: markers,);
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

class HomePage extends StatefulWidget{
  const HomePage({Key? key}) : super(key: key);
  @override
  _HomePage createState()=> _HomePage();
}
class _HomePage extends State<HomePage> {
  List<dynamic> _offersList =[];
  bool _loading = true;
  // get all offers
  Future<void> retrieveOffers() async {
    ApiResponse response = await getOffers();
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
    retrieveOffers();

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return _loading ? Center(child:CircularProgressIndicator()) :RefreshIndicator(
        onRefresh: () {
      return retrieveOffers();
    },
    child:DraggableHome(
        headerExpandedHeight: 0.1,

        headerWidget: Padding(
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
        title:Row(
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
                      child: InkWell(onTap:()async{
                          ApiResponse response = await getAgencyInfos('${offer.offer_agency_name}');
                          var jsonRespo = response.data as Map<String, dynamic>;
                           var agencyLogo = jsonRespo['agency'][0]['agency_logo'];
                          var agencyNumber = jsonRespo['agency'][0]['agency_phone_number'];
                         var agencyEmail = jsonRespo['agency'][0]['agency_email'];
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>DetailsPage(offer_id:offer.id!,offer_agency_name:'${offer.offer_agency_name}',agency_logo:agencyLogo,agency_phone:agencyNumber,agency_email:agencyEmail,description:'${offer.offer_description}',rooms:'${offer.number_of_rooms}',address:'${offer.address}',surface:'${offer.surface}',image1:'${offer.image1}',image2:'${offer.image2}',image3:'${offer.image3}',image4:'${offer.image4}', property_type:'${offer.property_type}', offer_type: '${offer.offer_type}', offer_price: '${offer.offer_price}')));},
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius
                              .circular(23)),
                          color: Colors.white,
                          shadowColor: Color(0xffFFC100),
                          elevation: 9,
                          margin: EdgeInsets.fromLTRB(10, 15, 10, 15),
                          child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:8,bottom:8,left:8),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(23),
                                    child: Container(height: 150,
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
                                Container(width: 160, margin: EdgeInsets.only(left:8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(FontAwesomeIcons.house, size: 15,
                                            color: Color(0xffFFC100),),
                                          SizedBox(width: 8,),
                                          Text('${offer.property_type}',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 10,
                                                letterSpacing: 1.5,
                                                color:Color(0xff6222ec))),

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
                                                    color: Color(0xff6222ec))),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              ]


                          ),
                        ),
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



