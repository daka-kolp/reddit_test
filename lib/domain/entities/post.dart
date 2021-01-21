import 'package:meta/meta.dart';
import 'package:intl/intl.dart';

class Post {
  final String author;
  final String title;
  final String text;
  final DateTime created;
  final int commentsAmount;
  final String url;

  Post({
    @required this.author,
    @required this.title,
    @required this.text,
    @required this.created,
    @required this.commentsAmount,
    @required this.url,
  });

  String get dateAndTimeCreated => DateFormat.yMd().add_jm().format(created);
}
