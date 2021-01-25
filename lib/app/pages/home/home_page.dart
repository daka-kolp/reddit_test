import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:reddit_app/app/pages/home/posts_bloc/posts_bloc.dart';
import 'package:reddit_app/app/pages/post/post_page.dart';
import 'package:reddit_app/app/utils/show_shack_bar.dart';
import 'package:reddit_app/device/connection/connectivity_bloc.dart';
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
            onPressed: () => context.read<PostsBloc>().add(PostsUpdated()),
          )
        ],
      ),
      body: BlocListener<ConnectivityBloc, ConnectivityState>(
        listener: (context, snapshot) {
          if (snapshot is ConnectivityFailure) {
            showSnackBar(context, 'No network access');
          } else if (snapshot is ConnectivitySuccess) {
            context.read<PostsBloc>().add(PostsUpdated());
          }
        },
        child: BlocConsumer<PostsBloc, PostsState>(
          listener: (context, snapshot) {
            if (snapshot is PostsLoadFailure) {
              showSnackBar(context, snapshot.error);
            }
          },
          builder: (context, snapshot) {
            if (snapshot is PostsLoadInProgress) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot is PostsFetched ||
                snapshot is PostsLoadFailure) {
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
      ),
    );
  }

  Widget _buildPostTile(BuildContext context, Post post) {
    return ListTile(
      title: Text(post.title),
      subtitle: Text('Publish time: ${post.dateAndTimeCreated}\nComments ${post.commentsAmount}'),
      onTap: () async {
        final connectivityState = context.read<ConnectivityBloc>().state;
        if (connectivityState is ConnectivitySuccess) {
          await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => PostPage(post)),
          );
        }
      },
    );
  }
}
