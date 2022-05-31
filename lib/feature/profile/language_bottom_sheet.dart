import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/design/widgets/section_header.dart';
import '../../utils/language_utils.dart';

class LanguageBottomSheet extends StatelessWidget {
  const LanguageBottomSheet({
    Key? key,
    required this.onLocaleSelected,
    required this.locales,
  }) : super(key: key);
  final void Function(Locale) onLocaleSelected;
  final List<Locale> locales;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 8),
        SectionHeader(title: localizations.language),
        ...locales.map(
          (Locale locale) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(getLanguageNameByLocale(context, locale)),
                onTap: () {
                  onLocaleSelected.call(locale);
                  Navigator.of(context).pop();
                },
              ),
              if (locales.last != locale)
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Divider(height: 1),
                )
            ],
          ),
        ),
      ],
    );
  }
}
