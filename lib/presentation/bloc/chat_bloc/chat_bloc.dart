import 'dart:async';

import 'package:chatbot/data/data.dart';
import 'package:chatbot/data/message.dart';
import 'package:chatbot/data/text_to_image.dart';
import 'package:chatbot/presentation/bloc/chat_bloc/chat_event.dart';
import 'package:chatbot/presentation/bloc/chat_bloc/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitialState()) {
    on<ChatMessageSendEvent>(chatMessageSendEvent);
  }

  FutureOr<void> chatMessageSendEvent(
      ChatMessageSendEvent event, Emitter<ChatState> emit) async {
    emit(ChatLoadingState());
    messages.add(Message(text: event.messageController.text, isYour: true));
    final text = event.messageController.text;
    event.messageController.clear();
    final receivedMessage = await TextToImage().fetchImage(text: text);
    messages.add(receivedMessage);
    emit(ChatLoadedState());
  }
}
