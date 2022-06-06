class Offer {
  int? id;
  String? offer_agency_name;
  String? offer_type;
  String? offer_price;
  String? property_type;
  String? x;
  String? y;
  String? address;
  String? offer_description;
  String? number_of_rooms;
  String? surface;
  String? image1;
  String? image2;
  String? image3;
  String? image4;
  Offer({
    this.id,
    this.offer_agency_name,
    this.offer_type,
    this.offer_price,
    this.property_type,
    this.x,
    this.y,
    this.address,
    this.offer_description,
    this.number_of_rooms,
    this.surface,
    this.image1,
    this.image2,
    this.image3,
    this.image4,
  });
  // function to convert json data to offer model
  factory Offer.fromJson(Map<String, dynamic> json){
    return Offer(
      id: json['id'],
      offer_agency_name: json['offer_agency_name'],
      offer_type: json['offer_type'],
      offer_price: json['offer_price'],
      property_type: json['property_type'],
      x: json['x'],
      y: json['y'],
      address: json['address'],
      offer_description: json['offer_description'],
      number_of_rooms: json['number_of_rooms'],
      surface: json['surface'],
      image1: json['image1'],
      image2: json['image2'],
      image3: json['image3'],
      image4: json['image4'],
    );
  }
}