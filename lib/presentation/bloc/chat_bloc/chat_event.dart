import 'package:flutter/material.dart';

abstract class ChatEvent {}

class ChatMessageSendEvent extends ChatEvent {
  TextEditingController messageController;
  ChatMessageSendEvent({required this.messageController});
}

