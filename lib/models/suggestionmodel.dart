class SuggestionModel {
  String username;
  String name;
  String dp;
  bool following;
  bool followsMe;
  String followedBy;

  SuggestionModel(this.dp,this.username,this.name,this.following,this.followsMe,this.followedBy);

  factory SuggestionModel.fromJson(dynamic json){
    return SuggestionModel(
      json['url'] as String , 
      json['username'] as String, 
      json['name'] as String,
      json['me_following'] as bool,
      json['follows_me'] as bool,
      json['followed_by'] as String,
    );
  }
}