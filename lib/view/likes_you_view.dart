import 'package:flutter/material.dart';

class LikesYouView extends StatefulWidget {
  const LikesYouView({super.key});

  @override
  State<LikesYouView> createState() => _LikesYouViewState();
}

class _LikesYouViewState extends State<LikesYouView> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Likes you page"));
  }
}
