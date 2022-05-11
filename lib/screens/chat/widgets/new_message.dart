import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../bloc/chat_bloc.dart';

class NewMessage extends HookWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = useTextEditingController();
    return Row(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(8),
          width: MediaQuery.of(context).size.width * 0.8,
          child: TextField(
            controller: controller,
          ),
        ),
        const SizedBox(width: 10.0),
        FloatingActionButton(
          onPressed: () {
            BlocProvider.of<ChatBloc>(context).add(ChatEvent.sendMessage(text: controller.text));
            controller.text = '';
          },
          elevation: 0,
          child: const Icon(Icons.send),
        ),
      ],
    );
  }
}
