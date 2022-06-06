import 'package:zaza/screens/Agencyoffers.dart';
import 'package:zaza/screens/OffersPage.dart';
import 'package:zaza/screens/comment_screen.dart';
import 'package:zaza/services/user_service.dart';
import 'package:draggable_home/draggable_home.dart';
import 'package:flutter/material.dart';
import 'package:clay_containers/clay_containers.dart';
import 'package:readmore/readmore.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';

class FeatureBlocItem extends StatelessWidget {
  final IconData iconData;
  final String title, description;

  const FeatureBlocItem({
    required this.iconData,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        ClayContainer(
          height: 50,
          color: Colors.white,
          width: 50,
          depth: 30,
          borderRadius: 12,
          curveType: CurveType.concave,
          child: Container(
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xff6222ec), width: 0.2),
            ),
            child: Container(
              margin: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Color(0xff6222ec), width: 0.2),
              ),
              child: Icon(
                iconData,
                color: Color(0xff6222ec),
                size: 16,
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 15,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              title,
              style: const TextStyle(
                  color: Color(0xff6222ec),
                  fontSize: 10,
                  fontWeight: FontWeight.w300),
            ),
            Text(
              description,
              style: const TextStyle(fontSize: 8, color: Color(0xff6222ec)),
            ),
          ],
        ),
      ],
    );
  }
}

class DetailsPage extends StatefulWidget {
  final int offer_id;
  final String offer_agency_name;
  final String agency_logo;
  final String agency_phone;
  final String agency_email;
  final String description;
  final String rooms;
  final String address;
  final String surface;
  final String image1;
  final String image2;
  final String image3;
  final String image4;
  final String property_type;
  final String offer_type;
  final String offer_price;

  const DetailsPage(
      {Key? key,
      required this.offer_id,
      required this.offer_agency_name,
      required this.agency_logo,
      required this.agency_phone,
      required this.agency_email,
      required this.description,
      required this.rooms,
      required this.address,
      required this.surface,
      required this.image1,
      required this.image2,
      required this.image3,
      required this.image4,
      required this.property_type,
      required this.offer_type,
      required this.offer_price})
      : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  Future<void> _sendmail(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _Call(String phone) async {
    String number = phone;
    await FlutterPhoneDirectCaller.callNumber(number);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SafeArea(
          child: DraggableHome(
            alwaysShowLeadingAndAction: false,
            centerTitle: true,
            fullyStretchable: false,
            backgroundColor: Colors.white,
            headerExpandedHeight: 0.45,
            title: Text(
              'Offer Details',
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
              onPressed: () async {
                String ut = await getUserType();
                if ('$ut' == 'Agency') {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => AgencyOffers()),
                      (route) => false);
                }
                if ('$ut' == 'Client') {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => OffersPage()),
                      (route) => false);
                }
              },
            ),
            headerWidget: headerWidget(context),
            body: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: Container(
                          margin: const EdgeInsets.only(top: 0),
                          width: 60,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Color(0x856222ec),
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 25, right: 14, left: 14),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.property_type,
                                  style: TextStyle( letterSpacing: 2,
                                      color: Color(0xff6222ec),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                                Text(
                                  widget.offer_type,
                                  style: TextStyle( letterSpacing: 2,
                                      color: Color(0xff6222ec),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.offer_price,
                                  style: TextStyle( letterSpacing: 2,
                                      color: Color(0xff6222ec),
                                      fontWeight: FontWeight.w400,
                                      fontSize: 10),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            ReadMoreText(
                              widget.description,
                              colorClickableText: Color(0xffFFC100),
                              trimLines: 2,
                              trimMode: TrimMode.Line,
                              trimCollapsedText: 'Read More',
                              trimExpandedText: 'Read Less',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Color(0xff6222ec),
                                  fontWeight: FontWeight.w300),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30))),
                                    side: MaterialStateProperty.all(
                                        BorderSide(color: Color(0xff6222ec))),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Comments',
                                        style: TextStyle(
                                            color: Color(0xff6222ec),
                                            fontSize: 10,
                                            fontWeight: FontWeight.w300),
                                      ),
                                      SizedBox(width: 8),
                                      Icon(
                                        Icons.insert_comment_rounded,
                                        color: Color(0xff6222ec),
                                        size: 15,
                                      ),
                                    ],
                                  ),
                                  onPressed: () {
                                    print(widget.offer_id);
                                    print(widget.agency_email);
                                    Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => CommentScreen(
                                                  postId: widget.offer_id,
                                                )));
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Table(
                                columnWidths: {1: FlexColumnWidth(0.6)},
                                children: [
                                  TableRow(
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: FeatureBlocItem(
                                          title: 'Surface',
                                          description: widget.surface,
                                          iconData: Icons
                                              .energy_savings_leaf_outlined,
                                        ),
                                      ),
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: FeatureBlocItem(
                                          title: 'Rooms',
                                          description: widget.rooms,
                                          iconData: Icons.bed_outlined,
                                        ),
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        child: FeatureBlocItem(
                                          title: 'Address',
                                          description: widget.address,
                                          iconData: Icons.location_on_outlined,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                      ),
                                    ],
                                  ),
                                  TableRow(
                                    children: [
                                      SizedBox(
                                        height: 20,
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'About Agency :',
                          style: TextStyle(
                              color: Color(0xff6222ec),
                              fontSize: 10,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.real_estate_agent_outlined,
                        color: Color(0xff6222ec),
                        size: 22,
                      ),
                      SizedBox(width: 8),
                      Text(
                        widget.offer_agency_name,
                        style: TextStyle( letterSpacing: 2,
                            color: Color(0xff6222ec),
                            fontWeight: FontWeight.w400,
                            fontSize: 12),
                      ),
                      SizedBox(width: 8),
                      CircleAvatar(
                          radius: 15,
                          backgroundImage: NetworkImage(widget.agency_logo)),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          _Call(widget.agency_phone);
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.green),
                          height: 50,
                          width: 210,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.phone_outlined,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                SizedBox(width: 8),
                                Text(widget.agency_phone,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          _sendmail('mailto:' +
                              widget.agency_email +
                              '?subject= &body= ');
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.red,
                          ),
                          height: 50,
                          width: 210,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.email_outlined,
                                  color: Colors.white,
                                  size: 22,
                                ),
                                SizedBox(width: 8),
                                Text(widget.agency_email,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  late String u = widget.image1;

  Container headerWidget(BuildContext context) => Container(
        color: Colors.grey[300],
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                  width: 250,
                  height: 280,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage('$u'),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  )),
              Positioned(
                child: Container(
                  height: 278,
                  width: 80,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            u = widget.image1;
                          });
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(widget.image1),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            u = widget.image2;
                          });
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(widget.image2),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            u = widget.image3;
                          });
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(widget.image3),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            u = widget.image4;
                          });
                        },
                        child: Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(widget.image4),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
