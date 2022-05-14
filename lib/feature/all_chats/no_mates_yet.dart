import 'package:flutter/material.dart';

class NoMatesYet extends StatelessWidget {
  const NoMatesYet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'Start a private chat with someone from your neighborhood to see these chats here',
      ),
    );
  }
}
