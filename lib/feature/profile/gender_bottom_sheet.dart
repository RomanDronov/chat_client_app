import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/design/widgets/section_header.dart';
import '../../models/gender.dart';

class GenderBottomSheet extends StatelessWidget {
  const GenderBottomSheet({Key? key, required this.onGenderSelected}) : super(key: key);
  final void Function(Gender) onGenderSelected;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 8),
        SectionHeader(title: localizations.gender),
        ...Gender.values.map(
          (Gender gender) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(gender.localize(context)),
                onTap: () {
                  onGenderSelected.call(gender);
                  Navigator.of(context).pop();
                },
              ),
              if (Gender.values.last != gender)
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

extension GenderExtension on Gender {
  String localize(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    switch (this) {
      case Gender.cat:
        return localizations.genderCat;
      case Gender.female:
        return localizations.genderFemale;
      case Gender.male:
        return localizations.genderMale;
    }
  }
}
