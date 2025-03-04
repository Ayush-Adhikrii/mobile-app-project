// lib/features/message/presentation/pages/matches_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:softwarica_student_management_bloc/app/di/di.dart';

import '../../../../app/constants/api_endpoints.dart';
import '../view_model/bloc/message_bloc.dart';
import '../view_model/bloc/message_event.dart';
import '../view_model/bloc/message_state.dart';
import 'chat_page.dart';

class MatchesPage extends StatelessWidget {
  const MatchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MessageBloc>()..add(FetchMatches()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Matches'),
          backgroundColor: Colors.pink[200],
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
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
          padding: const EdgeInsets.all(16),
          child: BlocBuilder<MessageBloc, MessageState>(
            builder: (context, state) {
              if (state is MessageLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is MessageLoaded) {
                final matches = state.matches;
                if (matches.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.favorite_border,
                            size: 48, color: Colors.pink),
                        SizedBox(height: 16),
                        Text(
                          'No Matches Yet',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                        Text(
                          'Keep swiping to find your match!',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: matches.length,
                  itemBuilder: (context, index) {
                    final match = matches[index];
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatPage(matchId: match.id),
                          ),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                        color: Colors.pink[300],
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 24,
                            backgroundImage: NetworkImage(
                              match.profilePhoto != null
                                  ? '${ApiEndpoints.profilePhotoUrl}${match.profilePhoto}'
                                  : '${ApiEndpoints.profilePhotoUrl}/default_profile.png',
                            ),
                          ),
                          title: Text(
                            match.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  },
                );
              } else if (state is MessageError) {
                return Center(child: Text('Error: ${state.message}'));
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
