import 'dart:convert';
import 'package:chatbot/data/data.dart';
import 'package:chatbot/presentation/bloc/chat_bloc/chat_bloc.dart';
import 'package:chatbot/presentation/bloc/chat_bloc/chat_event.dart';
import 'package:chatbot/presentation/bloc/chat_bloc/chat_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
 
 
import 'package:shimmer/shimmer.dart';

class Chat extends StatefulWidget {
  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text(
          'Photo AI',
          style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Colors.blue,
                fontWeight: FontWeight.bold,
              ),
        ),
        actions: [
          BlocConsumer<ChatBloc, ChatState>(
              bloc: context.read<ChatBloc>(),
              listener: (context, state) {},
              builder: (context, state) {
                return PopupMenuButton<String>(
                  onSelected: (value) {
                    messages.clear();
                    context.read<ChatBloc>().emit(ChatInitialState());
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'Delete',
                        child: Text('Delete'),
                      ),
                    ];
                  },
                );
              })
        ],
        automaticallyImplyLeading: true,
        surfaceTintColor: Colors.white,
        scrolledUnderElevation: 50,
        clipBehavior: Clip.hardEdge,
        forceMaterialTransparency: true,
      ),
      body: BlocConsumer<ChatBloc, ChatState>(
        bloc: context.read<ChatBloc>(),
        listener: (context, state) {
          if (state is ChatLoadingState) {
            // Scroll to the bottom when a new message is added
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            });
          }

          if (state is ChatLoadedState) {
            // Scroll to the bottom when a new message is added
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            });
            
          }
        },
        builder: (context, state) {
          return Container(
            child: messages.length != 0
                ? Column(
                    children: <Widget>[
                      Expanded(
                        child: ListView.builder(
                          itemCount: messages.length,
                          controller: _scrollController,
                          addRepaintBoundaries: true,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemBuilder: (context, index) {
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: index % 2 == 0
                                        ? Alignment.centerLeft
                                        : Alignment.centerRight,
                                    child: messages[index].isYour
                                        ? Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 10.0,
                                                horizontal: 16.0),
                                            decoration: BoxDecoration(
                                              color: messages[index].isYour
                                                  ? Colors.blue
                                                  : const Color(0xFFEEEEEE),
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                            child: Text(
                                              messages[index].text,
                                              style: const TextStyle(
                                                  fontSize: 16.0,
                                                  color: Colors.white),
                                            ))
                                        : Container(
                                            width: 200,
                                            height: 200,
                                            decoration: BoxDecoration(
                                              color: messages[index].isYour
                                                  ? Colors.blue
                                                  : const Color(0xFFEEEEEE),
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              image: DecorationImage(
                                                image: MemoryImage(base64Decode(
                                                    messages[index].text)),
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                  ),
                                ),
                                if (messages.length - 1 == index &&
                                    state is ChatLoadingState)
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Align(
                                        alignment: Alignment.centerRight,
                                        child: Shimmer(
                                            gradient: LinearGradient(colors: [
                                              const Color.fromARGB(
                                                  255, 202, 207, 210),
                                              const Color.fromARGB(
                                                  255, 191, 198, 202),
                                              Colors.green.withOpacity(0.2),
                                            ]),
                                            child: Container(
                                              width: 200,
                                              height: 200,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 10.0,
                                                      horizontal: 16.0),
                                              decoration: BoxDecoration(
                                                color: messages[index].isYour
                                                    ? Colors.blue[100]
                                                    : Colors.green[100],
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                              ),
                                            ))),
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          decoration: ShapeDecoration(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              shadows: [
                                BoxShadow(
                                    color: const Color.fromARGB(60, 34, 33, 33)
                                        .withOpacity(0.5),
                                    offset: const Offset(0, 5),
                                    blurRadius: 10)
                              ]),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: TextField(
                                    controller: _controller,
                                    onSubmitted: (value) {
                                      context.read<ChatBloc>().add(
                                          ChatMessageSendEvent(
                                              messageController: _controller));
                                    },
                                    decoration: const InputDecoration(
                                        hintText: 'Type your prompt...',
                                        border: InputBorder.none),
                                  ),
                                ),
                              ),
                               
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 200,
                          height: 200,
                          decoration: const ShapeDecoration(
                            shape: CircleBorder(),
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://imageio.forbes.com/specials-images/imageserve/648aaa9fac6d92c810b12f50/Why-Companies-Are-Vastly-Underprepared-For-The-Risks-Posed-By-AI/960x0.jpg?height=406&width=711&fit=bounds"),
                                fit: BoxFit.cover),
                          ),
                        ),
                        Text(
                          "Welcome",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "to",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Photo Ai",
                          style: Theme.of(context)
                              .textTheme
                              .headlineLarge!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        FilledButton(
                            onPressed: () {
                              _controller.text = 'Cat Happy Color Photo';
                              context.read<ChatBloc>().add(ChatMessageSendEvent(
                                  messageController: _controller));
                            },
                            child: const Text("Get Started"))
                      ],
                    ),
                  ),
          );
        },
      ),
    );
  }
}
