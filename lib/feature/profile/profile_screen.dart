import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../core/design/widgets/section_header.dart';
import '../../core/language/bloc/language_bloc.dart';
import '../../main.dart';
import '../../models/gender.dart';
import '../../utils/language_utils.dart';
import '../start_up/start_up_screen.dart';
import 'bloc/profile_bloc.dart';
import 'gender_bottom_sheet.dart';
import 'language_bottom_sheet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context);
    return BlocProvider(
      create: (_) => ProfileBloc(userRepository)..add(const ProfileEvent.initialized()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        builder: (BuildContext context, ProfileState state) {
          return Scaffold(
            appBar: AppBar(
              title: Text(localizations.profile),
              automaticallyImplyLeading: true,
            ),
            body: state.maybeMap(
              initial: (InitialProfileState state) {
                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
                      Center(
                        child: CircleAvatar(
                          radius: 64,
                          backgroundImage: AssetImage(
                            avatarProvider.getAssetNameByUsernameAndGender(
                              state.user.name,
                              state.user.gender,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        state.user.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        state.user.email,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 24),
                      SectionHeader(title: localizations.settings),
                      ListTile(
                        leading: const Icon(Icons.female),
                        title: Text(state.user.gender.localize(context)),
                        subtitle: Text(localizations.gender),
                        trailing: const Icon(Icons.navigate_next),
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (_) => GenderBottomSheet(
                              onGenderSelected: (Gender gender) {
                                context
                                    .read<ProfileBloc>()
                                    .add(ProfileEvent.genderChanged(gender: gender));
                              },
                            ),
                          );
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 72, right: 16),
                        child: Divider(height: 1, thickness: 1),
                      ),
                      BlocBuilder<LanguageBloc, LanguageState>(
                        builder: (context, state) {
                          return ListTile(
                            leading: const Icon(Icons.translate),
                            title: Text(getLanguageNameByLocale(context, state.locale)),
                            subtitle: Text(localizations.language),
                            trailing: const Icon(Icons.navigate_next),
                            onTap: () {
                              final List<Locale> locales =
                                  context.read<LanguageBloc>().state.locales;
                              showModalBottomSheet(
                                context: context,
                                builder: (_) => LanguageBottomSheet(
                                  locales: locales,
                                  onLocaleSelected: (Locale locale) {
                                    context
                                        .read<LanguageBloc>()
                                        .add(LanguageEvent.localeChanged(locale: locale));
                                  },
                                ),
                              );
                            },
                          );
                        },
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 72, right: 16),
                        child: Divider(height: 1, thickness: 1),
                      ),
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: Text(localizations.logOut),
                        onTap: () {
                          context.read<ProfileBloc>().add(const ProfileEvent.logOutPressed());
                        },
                      ),
                    ],
                  ),
                );
              },
              loading: (LoadingProfileState state) {
                return const Center(child: CircularProgressIndicator());
              },
              orElse: Container.new,
            ),
          );
        },
        listener: (BuildContext context, ProfileState state) {
          state.mapOrNull(
            logout: (_) {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const StartUpScreen(),
                ),
                (route) => false,
              );
            },
          );
        },
      ),
    );
  }
}
