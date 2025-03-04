// lib/features/message/presentation/pages/chat_page.dart
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';
import 'package:softwarica_student_management_bloc/features/auth/presentation/view_model/login/login_bloc.dart';

import '../view_model/bloc/message_bloc.dart';
import '../view_model/bloc/message_event.dart';
import '../view_model/bloc/message_state.dart';

class ChatPage extends StatefulWidget {
  final String matchId;

  const ChatPage({super.key, required this.matchId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _showEmojiPicker = false;

  @override
  void initState() {
    super.initState();
    context.read<MessageBloc>().add(SelectMatch(widget.matchId));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink[200],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: BlocBuilder<MessageBloc, MessageState>(
          builder: (context, state) {
            if (state is MessageLoaded &&
                state.selectedMatchId == widget.matchId) {
              final match =
                  state.matches.firstWhere((m) => m.id == widget.matchId);
              return Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(
                      match.profilePhoto != null
                          ? '${ApiEndpoints.profilePhotoUrl}${match.profilePhoto}'
                          : '${ApiEndpoints.profilePhotoUrl}/default_profile.png',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    match.name,
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFCE4EC), Color(0xFFE1BEE7)],
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ChatArea(
                matchId: widget.matchId,
                controller: _controller,
                scrollController: _scrollController,
              ),
            ),
            if (_showEmojiPicker)
              SizedBox(
                height: 250,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    _controller.text += emoji.emoji;
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.emoji_emotions, color: Colors.pink),
                    onPressed: () {
                      setState(() {
                        _showEmojiPicker = !_showEmojiPicker;
                        if (!_showEmojiPicker) FocusScope.of(context).unfocus();
                      });
                    },
                  ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.pink),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(color: Colors.pink, width: 2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.pink),
                    onPressed: () {
                      if (_controller.text.trim().isNotEmpty) {
                        print('Sending message: ${_controller.text}');
                        context
                            .read<MessageBloc>()
                            .add(SendMessage(widget.matchId, _controller.text));
                        _controller.clear();
                        _scrollToBottom();
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatArea extends StatelessWidget {
  final String matchId;
  final TextEditingController controller;
  final ScrollController scrollController;

  const ChatArea({
    super.key,
    required this.matchId,
    required this.controller,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MessageBloc, MessageState>(
      listener: (context, state) {
        if (state is MessageLoaded && state.selectedMatchId == matchId) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            scrollController.jumpTo(scrollController.position.maxScrollExtent);
          });
        }
      },
      builder: (context, state) {
        print('ChatArea state: $state');
        if (state is MessageLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MessageLoaded && state.selectedMatchId == matchId) {
          final match = state.matches.firstWhere((m) => m.id == matchId);
          final messages = state.messages;
          final authUserId =
              context.read<LoginBloc>().state.authUser?.userId ?? '';

          return Container(
            color: Colors.white.withOpacity(0.5),
            padding: const EdgeInsets.all(16),
            child: messages.isEmpty
                ? Center(
                    child: Text('Start your conversation with ${match.name}',
                        style: const TextStyle(color: Colors.grey)))
                : ListView.builder(
                    controller: scrollController,
                    itemCount: messages.length,
                    itemBuilder: (context, index) {
                      final message = messages[index];
                      final isSentByUser = message.senderId == authUserId;
                      return Align(
                        alignment: isSentByUser
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSentByUser
                                ? Colors.pink[500]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            message.content,
                            style: TextStyle(
                                color:
                                    isSentByUser ? Colors.white : Colors.black),
                          ),
                        ),
                      );
                    },
                  ),
          );
        } else if (state is MessageError) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const Center(
          child: Text('Loading chat...', style: TextStyle(color: Colors.black)),
        );
      },
    );
  }
}
