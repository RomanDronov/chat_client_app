import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'alert_description.dart';

class DesignAlert extends StatelessWidget {
  const DesignAlert({Key? key, required this.description}) : super(key: key);
  final AlertDescription description;

  @override
  Widget build(BuildContext context) {
    final AlertButton? secondButton = description.secondButton;
    return WillPopScope(
      onWillPop: () async => description.isDismissible,
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
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
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      description.description,
                      style: Theme.of(context).textTheme.bodyText1,
                      textAlign: TextAlign.center,
                    ),
                    description.firstButton.toAlertButton(context),
                    if (secondButton != null) ...[
                      const SizedBox(height: 8),
                      secondButton.toAlertButton(context),
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getIllustration() {
    switch (description.type) {
      case AlertType.warning:
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

Future<dynamic> showDesignAlert(BuildContext context, AlertDescription description) {
  return showDialog(
    context: context,
    barrierDismissible: description.isDismissible,
    builder: (_) => DesignAlert(
      description: description,
    ),
  );
}

extension _AlertButtonExtension on AlertButton {
  Widget toAlertButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed.call();
        Navigator.of(context).pop();
      },
      child: Text(label),
    );
  }
}
