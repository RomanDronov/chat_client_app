import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'info_description.dart';

class DesignInfo extends StatelessWidget {
  const DesignInfo({Key? key, required this.description}) : super(key: key);
  final InfoDescription description;

  @override
  Widget build(BuildContext context) {
    final InfoButton? secondButton = description.secondButton;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _getIllustration(),
                  Text(
                    description.title,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Text(
                    description.description,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                  description.firstButton.toInfoButton(context),
                  if (secondButton != null) ...[
                    const SizedBox(height: 8),
                    secondButton.toInfoButton(context),
                  ]
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getIllustration() {
    switch (description.type) {
      case InfoType.warning:
        return Lottie.asset(
          'assets/lottie/warning.json',
          animate: true,
          repeat: true,
          height: 172,
          width: 172,
          fit: BoxFit.cover,
        );
    }
  }
}

extension _InfoButtonExtension on InfoButton {
  Widget toInfoButton(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(label),
    );
  }
}
