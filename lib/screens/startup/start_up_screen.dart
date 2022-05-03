import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../all_chats_screen.dart';
import '../register_screen.dart';
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
                MaterialPageRoute(builder: (_) => RegisterScreen()),
              );
            },
            openAllChats: (OpenAllChatsStartUpPage state) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => AllChatsPage()),
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
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const <Widget>[
                      Text(
                        'Text Me',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Icon(
                        Icons.message,
                        size: 50,
                        color: Colors.white,
                      )
                    ],
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
