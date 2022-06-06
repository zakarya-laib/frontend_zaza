import 'package:zaza/screens/constant.dart';
import 'package:zaza/screens/login_screen.dart';
import 'package:zaza/models/api_response.dart';
import 'package:zaza/models/comment.dart';
import 'package:zaza/services/user_service.dart';
import 'package:flutter/material.dart';
class CommentScreen extends StatefulWidget {
  final int? postId;

  CommentScreen({
    this.postId
  });

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  List<dynamic> _commentsList = [];
  bool _loading = true;
 String  userEmail = '';
  String  pic = '';
  int _editCommentId = 0;
  TextEditingController _txtCommentController = TextEditingController();
  // Get comments
  Future<void> _getComments() async {
    userEmail= await getEmail();
    var ut = await getUserType();
    if('$ut'=='Agency'){
      ApiResponse response = await getAgencyName(userEmail);
      var jsonRespo =response.data as Map<String,dynamic>;
      var agencyName = jsonRespo['agency'][0]['agency_name'];
      ApiResponse response2 = await  getAgencyInfos(agencyName);
      var jsonRespo2 =response2.data as Map<String,dynamic>;
      var agencyLogo = jsonRespo2['agency'][0]['agency_logo'];
      pic = agencyLogo ;
    }
    if('$ut'=='Client'){
      ApiResponse response = await getClientInfos(userEmail);
      var jsonRespo =response.data as Map<String,dynamic>;
      var profilePic = jsonRespo['client'][0]['profile_pic'];
      pic = profilePic ;

    }
    ApiResponse response = await getComments(widget.postId ?? 0);
    if(response.error == null){
      setState(() {
        _commentsList = response.data as List<dynamic>;
        _loading = _loading ? !_loading : _loading;
      });
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
  // create comment
  void _createComment() async {
    userEmail= await getEmail();
    print (userEmail);
    ApiResponse response = await createComment(widget.postId ?? 0, _txtCommentController.text,userEmail);

    if(response.error == null){
      _txtCommentController.clear();
      _getComments();
    } 
    else if(response.error == unauthorized){
      logout().then((value) => {
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=>LoginScreen()), (route) => false)
      });
    }
    else {
      setState(() {
        _loading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${response.error}')
      ));
    }
  }
  // Delete comment
  void _deleteComment(int commentId) async {
    userEmail= await getEmail();
    ApiResponse response = await deleteComment(commentId,userEmail);

    if(response.error == null){
      _getComments();
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

  @override
  void initState() {
    _getComments();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(centerTitle:true,
          iconTheme: IconThemeData(color:Colors.white,),
          title: Text('Comments', style: TextStyle(color: Colors.white,letterSpacing: 2, fontSize: 15)),
        ),
        body: _loading ? Center(child: CircularProgressIndicator(),) :
        Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: (){
                  return _getComments();
                },
                child: ListView.builder(
                  itemCount: _commentsList.length,
                  itemBuilder: (BuildContext context, int index) {
                    Comment comment = _commentsList[index];
                    return Container(
                      padding: EdgeInsets.all(10),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xff6222ec), width: 0.5)
                        )
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:  comment.user_email == userEmail ? NetworkImage(pic) : NetworkImage('')  ,
                                        fit: BoxFit.cover
                                      ) ,
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.blueGrey
                                    ),
                                  ),
                                  SizedBox(width: 10,),
                                  Text(
                                   '${comment.user_email}',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                            fontSize: 10,
                                            letterSpacing: 1.5,
                                            color:Color(0xff6222ec)
                                    ),
                                  )
                                ],
                              ),
                              comment.user_email == userEmail ?
                               PopupMenuButton(
                                child: Padding(
                                  padding: EdgeInsets.only(right:10),
                                  child: Icon(Icons.delete_outline, color: Color(0xffFFC100),)
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem(
                                    child: Text('Delete',style:TextStyle(fontWeight: FontWeight.w200,
                                        fontSize: 10,
                                        letterSpacing: 1.5,
                                        color:Color(0xff6222ec))),
                                    value: 'delete'
                                  )
                                ],
                                onSelected: (val){
                                  if(val == 'delete') {
                                    _deleteComment(comment.id ?? 0);
                                  }
                                },
                              ) : SizedBox()
                            ],
                          ), SizedBox(height: 10,),
                          Text('${comment.comment}',style:TextStyle(fontWeight: FontWeight.w300,
                              fontSize: 10,
                              letterSpacing: 1.5,
                              color:Color(0xff6222ec)))
                        ],
                      ),
                    );
                  }
                )
              )
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Color(0xff6222ec), width: 0.5
                )
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    cursorColor: Color(0xff6222ec),
                    style:TextStyle(fontWeight: FontWeight.w300,
                        fontSize: 10,
                        letterSpacing: 1.5,
                        color:Color(0xff6222ec)),
                    decoration: kInputDecoration('Add Comment'),
                    controller: _txtCommentController,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Color(0xffFFC100)),
                  onPressed: (){
                    if(_txtCommentController.text.isNotEmpty){
                      setState(() {
                        _loading = true;
                      });
                    if (_editCommentId > 0){
                     //
                    } else {
                      _createComment();
                    }
                    }
                  },
                )
              ],
            ),
          )
          ]
        ),
      ),
    );
  }
}