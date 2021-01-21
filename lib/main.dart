import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import 'package:reddit_app/app/home/bloc/home_bloc.dart';
import 'package:reddit_app/app/home/home_page.dart';
import 'package:reddit_app/data/repositories/reddit_user_%20repository.dart';
import 'package:reddit_app/domain/repositories_contracts/user_repository.dart';

void main() {
  GetIt.I
    ..registerSingleton<HttpClient>(HttpClient())
    ..registerSingleton<UserRepository>(RedditUserRepository());

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<HomeBloc>(create: (context) => HomeBloc()),
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
