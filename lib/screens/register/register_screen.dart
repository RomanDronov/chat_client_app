import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../main.dart';
import '../all_chats/all_chats_screen.dart';
import 'bloc/register_bloc.dart';

class RegisterScreen extends HookWidget {
  const RegisterScreen({Key? key}) : super(key: key);
  //Place A
  @override
  Widget build(BuildContext context) {
    final nameController = useTextEditingController();
    final passwordController = useTextEditingController();
    final emailController = useTextEditingController();
    return BlocProvider<RegisterBloc>(
      create: (_) => RegisterBloc(userRepository),
      child: BlocConsumer<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return Scaffold(
            body: Container(
              padding: const EdgeInsets.all(32),
              child: Form(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                      'Register',
                      style: TextStyle(
                        color: Colors.lightBlue,
                        fontSize: 36,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      obscureText: true,
                      enableSuggestions: false,
                      autocorrect: false,
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: 'Password',
                      ),
                      controller: passwordController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: 'User Name',
                      ),
                      controller: nameController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey.shade200),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(Radius.circular(8)),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        hintText: 'Email',
                      ),
                      controller: emailController,
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: MaterialButton(
                        child: const Text('Register'),
                        textColor: Colors.white,
                        padding: const EdgeInsets.all(16),
                        onPressed: () {
                          final String email = emailController.text.trim();
                          final String name = nameController.text.trim();
                          final String password = passwordController.text.trim();
                          context.read<RegisterBloc>().add(
                                RegisterEvent.submitPressed(
                                  name: name,
                                  email: email,
                                  password: password,
                                ),
                              );
                        },
                        color: Colors.blue,
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        },
        listener: (BuildContext context, RegisterState state) {
          state.mapOrNull(
            openAllChats: (_) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (_) => const AllChatsPage(),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
