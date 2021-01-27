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
  int _indexOfWidget = 0;

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
        body: IndexedStack(
          index: _indexOfWidget,
          children: [
            _buildPlaceholder(),
            WebView(
              javascriptMode: JavascriptMode.unrestricted,
              initialUrl: widget.post.url,
              onPageStarted: (value) => setState(() => _indexOfWidget = 0),
              onPageFinished: (value) => setState(() => _indexOfWidget = 1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const LinearProgressIndicator(),
            Text('Loading the page. Please wait...'),
          ],
        ),
      ),
    );
  }
}
