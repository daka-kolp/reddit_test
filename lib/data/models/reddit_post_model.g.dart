// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reddit_post_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RedditPostModel _$RedditPostModelFromJson(Map<String, dynamic> json) {
  return RedditPostModel(
    json['author_fullname'] as String,
    json['title'] as String,
    json['selftext_html'] as String,
    (json['created'] as num)?.toDouble(),
    json['permalink'] as String,
    json['num_comments'] as int,
  );
}
