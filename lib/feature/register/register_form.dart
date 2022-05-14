import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design/widgets/text_field.dart';
import 'bloc/register_bloc.dart';

class RegisterForm extends StatelessWidget {
  const RegisterForm({
    Key? key,
    required this.usernameController,
    required this.isLoading,
    required this.usernameErrorController,
  }) : super(key: key);

  final TextEditingController usernameController;
  final ValueNotifier<String?> usernameErrorController;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          DesignTextField(
            label: 'Username',
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            controller: usernameController,
            isEnabled: !isLoading,
            errorController: usernameErrorController,
            onChanged: (_) {
              usernameErrorController.value = null;
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
                  child: const Text('Meet your neighbors'),
                  onPressed: isLoading
                      ? null
                      : () {
                          context.read<RegisterBloc>().add(
                                RegisterEvent.submitPressed(
                                  username: usernameController.text,
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
