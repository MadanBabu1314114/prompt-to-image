import 'package:chatbot/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:chatbot/presentation/pages/chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; 

void main(List<String> args) {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BlocProvider(
      create: (context) => ChatBloc(),
      child:  Chat(),
    ),
  ));
}
