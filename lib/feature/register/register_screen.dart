import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../main.dart';
import '../all_chats/all_chats_screen.dart';
import 'bloc/register_bloc.dart';
import 'register_form.dart';

class RegisterScreen extends HookWidget {
  const RegisterScreen({Key? key, required this.email, required this.password}) : super(key: key);
  final String email;
  final String password;
  //Place A
  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = useTextEditingController();
    final ValueNotifier<String?> usernameErrorController = useValueNotifier(null);
    return BlocProvider(
      create: (context) => RegisterBloc(userRepository, email, password),
      child: BlocConsumer<RegisterBloc, RegisterState>(
        listener: (context, state) {
          state.mapOrNull(
            openAllChats: (state) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AllChatsPage(),
                ),
              );
            },
            showUsernameFailure: (state) {
              usernameErrorController.value = state.failure;
            },
          );
        },
        builder: (BuildContext context, RegisterState state) {
          final bool isLoading = state.maybeMap(
            content: (state) => state.isLoading,
            orElse: () => false,
          );
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              automaticallyImplyLeading: true,
            ),
            extendBodyBehindAppBar: true,
            body: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/gradient.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned.fill(
                  child: SafeArea(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'One more step...',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            const SizedBox(height: 32),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: RegisterForm(
                                usernameController: usernameController,
                                usernameErrorController: usernameErrorController,
                                isLoading: isLoading,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
