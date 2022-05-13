import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../all_chats/all_chats_screen.dart';
import '../register/register_screen.dart';
import 'bloc/start_up_bloc.dart';

class StartUpScreen extends StatelessWidget {
  const StartUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => StartUpBloc()..add(const StartUpEvent.started()),
      child: BlocConsumer<StartUpBloc, StartUpState>(
        listener: (BuildContext context, StartUpState state) {
          state.mapOrNull(
            openRegister: (OpenRegisterStartUpState state) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const RegisterScreen()),
              );
            },
            openAllChats: (OpenAllChatsStartUpPage state) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const AllChatsPage()),
              );
            },
          );
        },
        buildWhen: (StartUpState previous, StartUpState current) => current is ContentStartUpState,
        builder: (BuildContext context, StartUpState state) {
          return state.maybeMap(
            content: (ContentStartUpState state) {
              return Scaffold(
                backgroundColor: Colors.blue,
                body: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.message,
                            size: 64,
                            color: Theme.of(context).colorScheme.secondary,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            orElse: Container.new,
          );
        },
      ),
    );
  }
}
