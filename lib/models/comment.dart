
class Comment {
  int? id;
  String? comment;
  String?  user_email;
  Comment({
    this.id,
    this.comment,
    this.user_email,
  });
  // map json to comment model
  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      comment: json['comment'],
      user_email: json['user_email']

    );
  }
}