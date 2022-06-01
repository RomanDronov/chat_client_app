import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design/widgets/text_field.dart';
import 'bloc/sign_in_bloc.dart';

class SignInForm extends StatelessWidget {
  const SignInForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.emailErrorController,
    required this.passwordErrorController,
  }) : super(key: key);

  final TextEditingController emailController;
  final TextEditingController passwordController;
  final ValueNotifier<String?> emailErrorController;
  final ValueNotifier<String?> passwordErrorController;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          DesignTextField(
              label: 'Email',
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              controller: emailController,
              isEnabled: !isLoading,
              errorController: emailErrorController,
              onChanged: (_) {
                emailErrorController.value = null;
              },
              key: Key('email_key')),
          const SizedBox(height: 8),
          DesignTextField(
            label: 'Password',
            keyboardType: TextInputType.visiblePassword,
            textInputAction: TextInputAction.done,
            obscureText: true,
            enableSuggestions: false,
            controller: passwordController,
            isEnabled: !isLoading,
            errorController: passwordErrorController,
            onChanged: (_) {
              passwordErrorController.value = null;
            },
            key: Key('password_key'),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: MaterialButton(
                  key: Key('sign_in_button'),
                  child: const Text('Sign in'),
                  onPressed: isLoading
                      ? null
                      : () {
                          context.read<SignInBloc>().add(
                                SignInEvent.signInPressed(
                                  email: emailController.text,
                                  password: passwordController.text,
                                ),
                              );
                        },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
