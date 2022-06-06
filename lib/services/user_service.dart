import 'dart:convert';
import 'dart:io';
import 'package:zaza/screens/constant.dart';
import 'package:zaza/models/api_response.dart';
import 'package:zaza/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/agency.dart';
import '../models/client.dart';
import '../models/offer.dart';
import '../models/comment.dart';

// login
Future<ApiResponse> login (String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try{
    final response = await http.post(
      Uri.parse(loginURL),
      headers: {'Accept': 'application/json'},
      body: {'email': email, 'password': password}
    );

    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch(e){
    apiResponse.error = serverError;
         print(e);
  }

  return apiResponse;
}


// Register
Future<ApiResponse> register(String userType, String email, String password) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
      Uri.parse(registerURL),
      headers: {'Accept': 'application/json'}, 
      body: {
        'userType': userType,
        'email': email,
        'password': password,
        'password_confirmation': password
      });

    switch(response.statusCode) {
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
//addAgency
Future<ApiResponse> addAgency(String email,String name,String? logo,String? cr,String number) async {
  String token = await getToken();
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
        Uri.parse('http://192.168.43.228:8000/api/addAgency'),
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
        body:{
          'agency_email': email,
          'agency_name':name,
          'agency_logo': logo,
          'commercial_register':cr,
          'agency_phone_number':number
        });
    switch(response.statusCode) {
      case 200:
        if(response.body.isNotEmpty){
        apiResponse.data = Agency.fromJson(jsonDecode(response.body));}
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e) {
    apiResponse.error = serverError;
    print(e);
  }
  return apiResponse;
}
//add client
Future<ApiResponse> addClient(String email,String name,String? pic) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
        Uri.parse('http://192.168.43.228:8000/api/addClient'),
        headers: {'Accept': 'application/json'},
        body:{
          'client_email': email,
          'user_name':name,
          'profile_pic': pic
        });
    switch(response.statusCode) {
      case 200:
        if(response.body.isNotEmpty){
        apiResponse.data = Client.fromJson(jsonDecode(response.body));}
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e) {
    apiResponse.error = serverError;
    print(e);
  }
  return apiResponse;
}
//add offer
Future<ApiResponse> addOffer(String offer_agency_name,String offer_type,String offer_price,String property_type,String x,String y,String address,String offer_description,String number_of_rooms,String surface,String? image1,String? image2,String? image3,String? image4) async {
  String token = await getToken();
  ApiResponse apiResponse = ApiResponse();
  try {
    final response = await http.post(
        Uri.parse('http://192.168.43.228:8000/api/addOffer'),
        headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
        body:{
          'offer_agency_name':offer_agency_name,
          'offer_type':offer_type,
          'offer_price':offer_price,
          'property_type':property_type,
          'x':x,
          'y':y,
          'address':address,
          'offer_description':offer_description,
          'number_of_rooms':number_of_rooms,
          'surface':surface,
          'image1':image1,
          'image2':image2,
          'image3':image3,
          'image4':image4,
        });
    switch(response.statusCode) {
      case 200:
        if(response.body.isNotEmpty){
          apiResponse.data = Offer.fromJson(jsonDecode(response.body));}
        break;
      case 422:
        final errors = jsonDecode(response.body)['errors'];
        apiResponse.error = errors[errors.keys.elementAt(0)][0];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.statusCode);
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e) {
    apiResponse.error = serverError;
    print(e);
  }
  return apiResponse;
}
//get agency name
Future<ApiResponse> getAgencyName(String agency_email) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
        Uri.parse('http://192.168.43.228:8000/api/agencyName/$agency_email'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch(e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
//get agency infos
Future<ApiResponse> getOfferInfos(String x) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
        Uri.parse('http://192.168.43.228:8000/api/offerInfos/$x'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch(e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
//get agency infos
Future<ApiResponse> getAgencyInfos(String agency_name) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
        Uri.parse('http://192.168.43.228:8000/api/agencyInfos/$agency_name'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch(e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
//get client infos
Future<ApiResponse> getClientInfos(String client_email) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
        Uri.parse('http://192.168.43.228:8000/api/clientInfos/$client_email'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch(e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
//get agency offers
Future<ApiResponse> agencyOffers(String agency_name) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
        Uri.parse('http://192.168.43.228:8000/api/agencyOffers/$agency_name'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['offers'].map((p) => Offer.fromJson(p)).toList();
        // we get list of posts, so we need to map each item to offer model
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch(e) {
    apiResponse.error = serverError;
    print(e);
  }
  return apiResponse;
}
// User
Future<ApiResponse> getUserDetail() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
      Uri.parse(userURL),
      headers: {
        'Accept': 'application/json',
        'Authorization': 'Bearer $token'
      });

    switch(response.statusCode){
      case 200:
        apiResponse.data = User.fromJson(jsonDecode(response.body));
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  } 
  catch(e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
// get all offers
Future<ApiResponse> getOffers() async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('http://192.168.43.228:8000/api/offers'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['offers'].map((p) => Offer.fromJson(p)).toList();
        // we get list of posts, so we need to map each item to offer model
        apiResponse.data as List<dynamic>;
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e){
    apiResponse.error = serverError;
    print(e);
  }
  return apiResponse;
}
//Update agency
Future<ApiResponse> upAgencyName(String name,String email) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
        Uri.parse('http://192.168.43.228:8000/api/upAgencyName/$email'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'agency_name': name,
        });
    switch(response.statusCode) {
      case 200:
        apiResponse.data =jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
//
Future<ApiResponse> upAgencyLogo(String? logo,String email) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
        Uri.parse('http://192.168.43.228:8000/api/upAgencyLogo/$email'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'agency_logo': logo,
        });
    switch(response.statusCode) {
      case 200:
        apiResponse.data =jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
//
Future<ApiResponse> upAgencyNum(String num,String email) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
        Uri.parse('http://192.168.43.228:8000/api/upAgencyNum/$email'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'agency_phone_number': num,
        });
    switch(response.statusCode) {
      case 200:
        apiResponse.data =jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}

//Update client
Future<ApiResponse> upClientName(String name,String email) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
        Uri.parse('http://192.168.43.228:8000/api/upClientName/$email'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'user_name': name,
        });
    switch(response.statusCode) {
      case 200:
        apiResponse.data =jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
//
Future<ApiResponse> upProfilePic(String? pic,String email) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
        Uri.parse('http://192.168.43.228:8000/api/upProfilePic/$email'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'profile_pic': pic,
        });
    switch(response.statusCode) {
      case 200:
        apiResponse.data =jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
// Delete offer
Future<ApiResponse> deleteOffer(int offerId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(Uri.parse('http://192.168.43.228:8000/api/destroyOffer/$offerId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong; print(response.statusCode);
        break;
    }
  }
  catch (e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}
//update offer
Future<ApiResponse> upOfferType(String offerType,int id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
        Uri.parse('http://192.168.43.228:8000/api/upOfferType/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'offer_type': offerType,
        });
    switch(response.statusCode) {
      case 200:
        apiResponse.data =jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
Future<ApiResponse> upOfferPrice(String offerPrice,int id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
        Uri.parse('http://192.168.43.228:8000/api/upOfferPrice/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'offer_price': offerPrice,
        });
    switch(response.statusCode) {
      case 200:
        apiResponse.data =jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
Future<ApiResponse> upOfferLocation(String offerLocation,int id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
        Uri.parse('http://192.168.43.228:8000/api/upOfferLocation/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'offer_location': offerLocation,
        });
    switch(response.statusCode) {
      case 200:
        apiResponse.data =jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
Future<ApiResponse> upPropertyType(String propertyType,int id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
        Uri.parse('http://192.168.43.228:8000/api/upPropertyType/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'property_type': propertyType,
        });
    switch(response.statusCode) {
      case 200:
        apiResponse.data =jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
Future<ApiResponse> upImg1(String? img1,int id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
        Uri.parse('http://192.168.43.228:8000/api/upImg1/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'image1': img1,
        });
    switch(response.statusCode) {
      case 200:
        apiResponse.data =jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
Future<ApiResponse> upImg2(String? img2,int id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
        Uri.parse('http://192.168.43.228:8000/api/upImg2/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'image2': img2,
        });
    switch(response.statusCode) {
      case 200:
        apiResponse.data =jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
Future<ApiResponse> upImg3(String? img3,int id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
        Uri.parse('http://192.168.43.228:8000/api/upImg3/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'image3': img3,
        });
    switch(response.statusCode) {
      case 200:
        apiResponse.data =jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
Future<ApiResponse> upImg4(String? img4,int id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.put(
        Uri.parse('http://192.168.43.228:8000/api/upImg4/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: {
          'image4': img4,
        });
    switch(response.statusCode) {
      case 200:
        apiResponse.data =jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        print(response.body);
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
Future<ApiResponse> getOfferDetails(int id) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(
        Uri.parse('http://192.168.43.228:8000/api/offerDetails/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });
    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch(e) {
    apiResponse.error = serverError;
  }
  return apiResponse;
}
// get token
Future<String> getToken() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('token') ?? '';
}

// get email
Future<String> getEmail() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('email') ?? '';
}
// get email
Future<String> getUserType() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return pref.getString('userType') ?? '';
}
// logout
Future<bool> logout() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  return await pref.remove('token');
}

// Get base64 encoded image
String? getStringImage(File? file) {
  if (file == null) return null ;
  return base64Encode(file.readAsBytesSync());
}

// Get offer comments
Future<ApiResponse> getComments(int offerId) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.get(Uri.parse('http://192.168.43.228:8000/api/offers/$offerId/comments'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch(response.statusCode){
      case 200:
      // map each comments to comment model
        apiResponse.data = jsonDecode(response.body)['comments'].map((p) => Comment.fromJson(p)).toList();
        apiResponse.data as List<dynamic>;
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        print(response.statusCode);
        break;
    }
  }
  catch (e){
    apiResponse.error = serverError;
    print(e);
  }
  return apiResponse;
}
// Create comment
Future<ApiResponse> createComment(int offerId, String? comment ,String userEmail) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.post(Uri.parse('http://192.168.43.228:8000/api/offers/$offerId/comments'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        }, body: {
          'comment': comment,
          'user_email': userEmail
        });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body);
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}
// Delete comment
Future<ApiResponse> deleteComment(int commentId,String userEmail) async {
  ApiResponse apiResponse = ApiResponse();
  try {
    String token = await getToken();
    final response = await http.delete(Uri.parse('$commentsURL/$commentId/$userEmail'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token'
        });

    switch(response.statusCode){
      case 200:
        apiResponse.data = jsonDecode(response.body)['message'];
        break;
      case 403:
        apiResponse.error = jsonDecode(response.body)['message'];
        break;
      case 401:
        apiResponse.error = unauthorized;
        break;
      default:
        apiResponse.error = somethingWentWrong;
        break;
    }
  }
  catch (e){
    apiResponse.error = serverError;
  }
  return apiResponse;
}


