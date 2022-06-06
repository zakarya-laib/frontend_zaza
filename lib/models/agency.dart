class Agency {
  String? agency_email;
  String? agency_name;
  String? agency_logo;
  String? commercial_register;
  String? agency_phone_number;
  Agency({
    this.agency_email,
    this.agency_name,
    this.agency_logo,
    this.commercial_register,
    this.agency_phone_number,
  });
  // function to convert json data to agency model
  factory Agency.fromJson(Map<String, dynamic> json){
    return Agency(
        agency_email: json['agency_email'],
        agency_name: json['agency_name'],
        agency_logo: json['agency_logo'],
      commercial_register: json['commercial_register'],
      agency_phone_number:json['agency_phone_number'],
    );
  }
}