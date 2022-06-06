class Client {
  String? client_email;
  String? user_name;
  String? profile_pic;

  Client({
    this.client_email,
    this.user_name,
    this.profile_pic,
  });
  // function to convert json data to client model
  factory Client.fromJson(Map<String, dynamic> json){
    return Client(
      client_email: json['client_email'],
      user_name: json['user_name'],
      profile_pic: json['profile_pic'],
    );
  }
}