import 'package:json_annotation/json_annotation.dart';

import 'package:reddit_app/domain/entities/post.dart';

part 'reddit_post_model.g.dart';

@JsonSerializable(createToJson: false)
class RedditPostModel {
  @JsonKey(name: 'author_fullname')
  final String author;
  final String title;
  @JsonKey(name: 'selftext_html')
  final String selftext;
  @JsonKey(name: 'created')
  final double created;
  @JsonKey(name: 'permalink')
  final String url;
  @JsonKey(name: 'num_comments')
  final int numComments;

  RedditPostModel(
    this.author,
    this.title,
    this.selftext,
    this.created,
    this.url,
    this.numComments,
  );

  Post get postFromModel {
    return Post(
      author: author,
      title: title,
      text: selftext,
      commentsAmount: numComments,
      created: DateTime.fromMillisecondsSinceEpoch(created.toInt() * 1000),
      url: 'https://www.reddit.com$url',
    );
  }

  factory RedditPostModel.fromJson(Map<String, dynamic> json) =>
      _$RedditPostModelFromJson(json);
}
