import 'package:instagram/models/user_model.dart';

enum MediaType {
  image,
  video,
}

class Story {
  final int id;
  final String url;
  final String ago;
  final MediaType media;
  final Duration duration;

  const Story(
    this.id,
    this.url,
    this.ago,
    this.media,
    this.duration,
  );

  factory Story.fromJson(dynamic json){
    return Story(
      json['id'] as int,
      json['url'] as String,
      json['ago'] as String,
      MediaType.image,
      const Duration(seconds: 10)
    );
  }

}
class StoryModel {
  final List<Story> stories;
  final User user;

  const StoryModel(this.stories,this.user);

  factory StoryModel.fromJson(dynamic json){
    var stories = json['stories'] as List;
    List<Story> _stories = stories.map((e) => Story.fromJson(e)).toList();

    return StoryModel(_stories, User.fromJson(json['user']));
  }
}