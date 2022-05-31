import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../core/design/alert/alert.dart';
import '../../core/design/alert/alert_description.dart';
import '../../main.dart';
import '../all_chats/all_chats_screen.dart';
import '../register/register_screen.dart';
import 'bloc/sign_in_bloc.dart';
import 'sign_in_form.dart';

class SignInScreen extends HookWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = useTextEditingController();
    final TextEditingController passwordController = useTextEditingController();
    final ValueNotifier<String?> emailErrorController = useValueNotifier(null);
    final ValueNotifier<String?> passwordErrorController = useValueNotifier(null);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: Theme.of(context).colorScheme.primary,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: BlocProvider(
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
                    builder: (context) => RegisterScreen(
                      email: state.email,
                      password: state.password,
                    ),
                  ),
                );
              },
              showEmailFailure: (state) {
                emailErrorController.value = state.failure;
              },
              showPasswordFailure: (state) {
                passwordErrorController.value = state.failure;
              },
              showWarning: (state) {
                final AlertDescription description = AlertDescription(
                  type: AlertType.warning,
                  title: state.title,
                  description: state.description,
                  firstButton: AlertButton(
                    label: 'Got it',
                    onPressed: () {},
                  ),
                );
                showDesignAlert(context, description);
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
      ),
    );
  }
}
