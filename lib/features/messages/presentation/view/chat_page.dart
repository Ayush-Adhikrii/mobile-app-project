import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/app/constants/api_endpoints.dart';
import 'package:softwarica_student_management_bloc/app/constants/theme_constant.dart';
import 'package:softwarica_student_management_bloc/core/theme/app_theme.dart';
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
    final theme = Theme.of(context);
    final customTheme = theme.customThemeExtension;
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
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
                    radius: isTablet ? 25 : 20,
                    backgroundImage: NetworkImage(
                      match.profilePhoto != null
                          ? '${ApiEndpoints.profilePhotoUrl}${match.profilePhoto}'
                          : '${ApiEndpoints.profilePhotoUrl}/default_profile.png',
                    ),
                  ),
                  SizedBox(width: ThemeConstant.mediumPadding),
                  Text(
                    match.name,
                    style: theme.textTheme.displayMedium?.copyWith(
                      fontSize: isTablet
                          ? ThemeConstant.subheadingFontSize
                          : ThemeConstant.bodyFontSize,
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
        elevation: 1,
        shadowColor: theme.colorScheme.onSurface.withOpacity(0.1),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: customTheme.scaffoldGradient,
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
                height: isTablet ? 300 : 250,
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    _controller.text += emoji.emoji;
                  },
                  config: Config(
                    emojiViewConfig: EmojiViewConfig(
                      backgroundColor: theme.colorScheme.surface,
                      columns: isTablet ? 10 : 8,
                      emojiSizeMax: isTablet ? 32 : 28,
                    ),
                    categoryViewConfig: CategoryViewConfig(
                      iconColor: theme.colorScheme.onSurface,
                      iconColorSelected: theme.colorScheme.primary,
                      indicatorColor: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: ThemeConstant.mediumPadding,
                vertical: ThemeConstant.smallPadding,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.onSurface.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.attach_file,
                      color: theme.colorScheme.primary,
                      size: isTablet
                          ? ThemeConstant.mediumIconSize
                          : ThemeConstant.smallIconSize,
                    ),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.emoji_emotions,
                      color: theme.colorScheme.primary,
                      size: isTablet
                          ? ThemeConstant.mediumIconSize
                          : ThemeConstant.smallIconSize,
                    ),
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
                        hintText: 'Message...',
                        hintStyle: TextStyle(
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.5)),
                        filled: true,
                        fillColor: theme.colorScheme.surface.withOpacity(0.8),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                              ThemeConstant.largeBorderRadius),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: ThemeConstant.mediumPadding,
                          vertical: ThemeConstant.smallPadding,
                        ),
                      ),
                      style: TextStyle(color: theme.colorScheme.onSurface),
                    ),
                  ),
                  SizedBox(width: ThemeConstant.smallPadding),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: _controller.text.trim().isNotEmpty
                          ? theme.colorScheme.primary
                          : theme.colorScheme.onSurface.withOpacity(0.5),
                      size: isTablet
                          ? ThemeConstant.mediumIconSize
                          : ThemeConstant.smallIconSize,
                    ),
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
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

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
          return Center(
              child:
                  CircularProgressIndicator(color: theme.colorScheme.primary));
        } else if (state is MessageLoaded && state.selectedMatchId == matchId) {
          final match = state.matches.firstWhere((m) => m.id == matchId);
          final messages = state.messages;
          final authUserId =
              context.read<LoginBloc>().state.authUser?.userId ?? '';

          return Container(
            padding: EdgeInsets.all(ThemeConstant.mediumPadding),
            child: messages.isEmpty
                ? Center(
                    child: Text(
                      'Start your conversation with ${match.name}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  )
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
                          margin: EdgeInsets.symmetric(
                              vertical: ThemeConstant.smallPadding),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width *
                                (isTablet ? 0.5 : 0.7),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: ThemeConstant.mediumPadding,
                            vertical: ThemeConstant.smallPadding,
                          ),
                          decoration: BoxDecoration(
                            color: isSentByUser
                                ? ThemeConstant.primaryColor
                                : theme.colorScheme.surface,
                            borderRadius: BorderRadius.circular(
                                    ThemeConstant.mediumBorderRadius)
                                .copyWith(
                              topLeft: isSentByUser
                                  ? const Radius.circular(
                                      ThemeConstant.mediumBorderRadius)
                                  : const Radius.circular(0),
                              topRight: isSentByUser
                                  ? const Radius.circular(0)
                                  : const Radius.circular(
                                      ThemeConstant.mediumBorderRadius),
                            ),
                          ),
                          child: Text(
                            message.content,
                            style: TextStyle(
                              color: isSentByUser
                                  ? theme.colorScheme.onPrimary
                                  : theme.colorScheme.onSurface,
                              fontSize: isTablet
                                  ? ThemeConstant.bodyFontSize
                                  : ThemeConstant.captionFontSize,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          );
        } else if (state is MessageError) {
          return Center(
              child: Text('Error: ${state.message}',
                  style: theme.textTheme.bodyLarge));
        }
        return Center(
            child: Text('Loading chat...', style: theme.textTheme.bodyLarge));
      },
    );
  }
}
