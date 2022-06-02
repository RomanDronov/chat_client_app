import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/design/widgets/message_tail.dart';
import '../../../main.dart';
import '../../all_chats/models/domain/all_chats_details.dart';
import '../../chat/chat_page.dart';

class OtherUserMessage extends StatelessWidget {
  const OtherUserMessage({
    Key? key,
    required this.message,
  }) : super(key: key);
  final Message message;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 8),
        GestureDetector(
          onTap: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ChatPage(recipient: message.author)));
          },
          child: CircleAvatar(
            backgroundImage: AssetImage(
              avatarProvider.getAssetNameByUsernameAndGender(
                message.author.name,
                message.author.gender,
              ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
            radius: 16,
          ),
        ),
        const SizedBox(width: 4),
        Flexible(
          fit: FlexFit.loose,
          child: OtherUserMessageBubble(message: message),
        ),
      ],
    );
  }
}

class OtherUserMessageBubble extends StatelessWidget {
  const OtherUserMessageBubble({
    Key? key,
    required this.message,
  }) : super(key: key);

  final Message message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 48, left: 8, top: 2, bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomPaint(painter: MessageTailShape(Theme.of(context).colorScheme.surface)),
                Flexible(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: IntrinsicWidth(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                message.author.name,
                                textAlign: TextAlign.start,
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              const SizedBox(width: 16),
                              Text(
                                DateFormat.Hm(Localizations.localeOf(context).languageCode)
                                    .format(message.sentDateTime.toLocal()),
                                textAlign: TextAlign.end,
                                style: Theme.of(context).textTheme.caption?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onBackground
                                          .withOpacity(0.25),
                                    ),
                              )
                            ],
                          ),
                          Text(
                            message.content.text,
                            style: Theme.of(context).textTheme.subtitle1?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
