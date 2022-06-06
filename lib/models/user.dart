class User {
  String? userType;
  String? email;
  String? token;
  User({
    this.userType,
    this.email,
    this.token
  });
  // function to convert json data to user model
  factory User.fromJson(Map<String, dynamic> json){
    return User(
        userType: json['user']['userType'],
        email: json['user']['email'],
      token: json['token']
    );
  }
}