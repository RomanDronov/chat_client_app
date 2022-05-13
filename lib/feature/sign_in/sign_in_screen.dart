import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../core/design/widgets/text_field.dart';
import '../../main.dart';
import '../all_chats/all_chats_screen.dart';
import '../register/register_screen.dart';
import 'bloc/sign_in_bloc.dart';

class SignInScreen extends HookWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();
    final ValueNotifier<String?> emailErrorController = useValueNotifier(null);
    final ValueNotifier<String?> passwordErrorController = useValueNotifier(null);
    return BlocProvider(
      create: (context) => SignInBloc(userRepository),
      child: BlocConsumer<SignInBloc, SignInState>(
        listener: (context, state) {
          state.mapOrNull(
            openAllChats: (state) {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => const AllChatsPage(),
                ),
              );
            },
            openSignUp: (state) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const RegisterScreen(),
                ),
              );
            },
            showEmailFailure: (state) {
              emailErrorController.value = state.failure;
            },
            showPasswordFailure: (state) {
              passwordErrorController.value = state.failure;
            },
          );
        },
        builder: (BuildContext context, SignInState state) {
          final bool isLoading = state.maybeMap(
            content: (state) => state.isLoading,
            orElse: () => false,
          );
          return Scaffold(
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
                              'Neighborhood',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            const SizedBox(height: 32),
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: SignInForm(
                                emailController: emailController,
                                passwordController: passwordController,
                                isLoading: isLoading,
                                emailErrorController: emailErrorController,
                                passwordErrorController: passwordErrorController,
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
          ),
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
              MaterialButton(
                child: const Text('Sign up'),
                onPressed: isLoading
                    ? null
                    : () {
                        context.read<SignInBloc>().add(const SignInEvent.signUpPressed());
                      },
              ),
            ],
          )
        ],
      ),
    );
  }
}
