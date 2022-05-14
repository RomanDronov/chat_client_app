import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../bloc/chat_bloc.dart';

class NewMessage extends HookWidget {
  const NewMessage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController controller = useTextEditingController();
    final FocusNode focusNode = useFocusNode();

    VoidCallback? initialize() {
      focusNode.requestFocus();
      return null;
    }

    useEffect(initialize, []);

    return Material(
      elevation: 16,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: FocusScope(
                    child: TextField(
                      decoration: const InputDecoration(
                        label: Text('Message'),
                      ),
                      autofocus: true,
                      controller: controller,
                      focusNode: focusNode,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (text) {
                        BlocProvider.of<ChatBloc>(context).add(ChatEvent.sendMessage(text: text));
                        controller.clear();
                        focusNode.requestFocus();
                      },
                    ),
                  ),
                ),
              ),
              FloatingActionButton(
                mini: true,
                onPressed: () {
                  BlocProvider.of<ChatBloc>(context)
                      .add(ChatEvent.sendMessage(text: controller.text));
                  controller.clear();
                },
                elevation: 0,
                child: const Icon(Icons.send),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
