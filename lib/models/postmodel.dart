class PostModel {
  int id;
  String authorDp;
  String authorUsername;
  String location;
  String imageurl;
  bool liked;
  bool saved;
  String caption;
  String firstLike;
  String firstLikeDp;
  int commentCount;
  int likeCount;
  String ago;

  PostModel(this.id, this.authorDp,this.authorUsername,this.location,this.imageurl,this.liked,this.saved,this.caption,this.firstLike,this.firstLikeDp,this.commentCount,this.ago,this.likeCount);

  factory PostModel.fromJson(dynamic json){
    return PostModel(
      json['id'] as int, 
      json['author_dp'] as String,
      json['author_username'] as String,
      json['location'] as String,
      json['image'] as String,
      json['liked'] as bool,
      json['saved'] as bool,
      json['caption'] as String,
      json['first_like'] as String,
      json['first_like_dp'] as String,
      json['comment_count'] as int,
      json['ago'] as String,
      json['like_count'] as int
      );
  }
}