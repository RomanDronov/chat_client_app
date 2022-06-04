import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/design/widgets/message_tail.dart';

class CurrentUserMessage extends StatelessWidget {
  const CurrentUserMessage({
    Key? key,
    required this.message,
    required this.sentDateTimeUtc,
  }) : super(key: key);
  final String message;
  final DateTime sentDateTimeUtc;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 48, top: 2, bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Flexible(
            child: IntrinsicWidth(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                          bottomRight: Radius.circular(8),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            message,
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary,
                                ),
                          ),
                          Text(
                            DateFormat.Hm(Localizations.localeOf(context).languageCode)
                                .format(sentDateTimeUtc.toLocal()),
                            textAlign: TextAlign.start,
                            style: Theme.of(context).textTheme.caption?.copyWith(
                                  color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CustomPaint(painter: MessageTailShape(Theme.of(context).colorScheme.primary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
