import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:reddit_app/device/connection/connectivity_bloc.dart';
import 'package:reddit_app/domain/entities/post.dart';

class PostPage extends StatefulWidget {
  final Post post;

  const PostPage(this.post, {Key key})
      : assert(post != null),
        super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ConnectivityBloc, ConnectivityState>(
      listener: (context, snapshot) {
        if (snapshot is ConnectivityFailure) {
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text(widget.post.title)),
        body: WebView(initialUrl: widget.post.url),
      ),
    );
  }
}
