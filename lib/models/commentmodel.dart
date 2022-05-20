class CommentModel {
  int id;
  String authorDp;
  String authorUsername;
  String comment;
  String ago;
  int likes;
  bool liked;

  CommentModel(this.id, this.authorDp,this.authorUsername,this.comment,this.ago,this.likes,this.liked);
  factory CommentModel.fromJson(dynamic json){
    return CommentModel(
      json['id'] as int, 
      json['author_dp'] as String,
      json['author_username'] as String,
      json['comment'] as String,
      json['ago'] as String,
      json['likes'] as int,
      json['liked'] as bool,
      );
  }
}