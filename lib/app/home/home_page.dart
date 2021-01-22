import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity/connectivity.dart';

import 'package:reddit_app/app/home/bloc/home_bloc.dart';
import 'package:reddit_app/app/post/post_page.dart';
import 'package:reddit_app/domain/entities/post.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reddit FlutterDev'),
        actions: [
          IconButton(
            icon: Icon(Icons.update),
            onPressed: () => context.read<HomeBloc>().add(UpdatePostsEvent()),
          )
        ],
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, snapshot) {
          if (snapshot is ConnectionErrorState) {
            _showSnackBar(context, 'Please, check connection to update posts');
          } else if (snapshot is ErrorState) {
            _showSnackBar(context, 'Unknown error: ${snapshot.error}');
          }
        },
        builder: (context, snapshot) {
          if (snapshot is LoadingState) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot is FetchedPostsState || snapshot is ErrorState) {
            final posts = snapshot.posts;
            return ListView.separated(
              itemCount: posts.length,
              itemBuilder: (context, i) => _buildPostTile(context, posts[i]),
              separatorBuilder: (context, i) => Divider(),
            );
          }
          return Container();
        },
      ),
    );
  }

  Widget _buildPostTile(BuildContext context, Post post) {
    return ListTile(
      title: Text(post.title),
      subtitle: Text('Publish time: ${post.dateAndTimeCreated}\nComments ${post.commentsAmount}'),
      onTap: () async {
        var connectivityResult = await Connectivity().checkConnectivity();
        if (connectivityResult == ConnectivityResult.none) {
          _showSnackBar(context, 'Please, check connection to open the post');
        } else {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PostPage(post)),
          );
        }
      },
    );
  }

  void _showSnackBar(BuildContext context, String content) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(content),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
