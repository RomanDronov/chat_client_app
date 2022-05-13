import 'package:flutter/material.dart';

import '../../core/design/widgets/section_header.dart';
import '../../models/gender.dart';
import '../../utils/string.dart';

class GenderBottomSheet extends StatelessWidget {
  const GenderBottomSheet({Key? key, required this.onGenderSelected}) : super(key: key);
  final void Function(Gender) onGenderSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        const SizedBox(height: 8),
        const SectionHeader(title: 'Gender'),
        ...Gender.values.map(
          (Gender gender) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(gender.name.capitalize()),
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
