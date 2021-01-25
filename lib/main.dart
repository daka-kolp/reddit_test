import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:reddit_app/app/pages/home/posts_bloc/posts_bloc.dart';
import 'package:reddit_app/app/pages/home/home_page.dart';
import 'package:reddit_app/data/repositories/reddit_news_repository.dart';
import 'package:reddit_app/device/connection/connectivity_bloc.dart';
import 'package:reddit_app/domain/repositories_contracts/news_repository.dart';

void main() {
  GetIt.I
    ..registerSingleton<HttpClient>(HttpClient())
    ..registerSingleton<NewsRepository>(RedditNewsRepository());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ConnectivityBloc>(create: (context) => ConnectivityBloc()),
        BlocProvider<PostsBloc>(create: (context) => PostsBloc()),
      ],
      child: MaterialApp(
        title: 'Reddit',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: HomePage(),
      ),
    );
  }
}
