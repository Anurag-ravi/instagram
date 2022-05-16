class PostURL {
  int id;
  String url;

  PostURL(this.id, this.url);
  factory PostURL.fromJson(dynamic json){
    return PostURL(json['id'] as int, json['url'] as String);
  }
}