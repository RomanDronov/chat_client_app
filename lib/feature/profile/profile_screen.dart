import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../core/design/widgets/section_header.dart';
import '../../main.dart';
import '../../models/gender.dart';
import '../../utils/string.dart';
import '../startup/start_up_screen.dart';
import 'bloc/profile_bloc.dart';
import 'gender_bottom_sheet.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileBloc(userRepository)..add(const ProfileEvent.initialized()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        builder: (BuildContext context, ProfileState state) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Profile'),
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
                      const SectionHeader(title: 'Settings'),
                      ListTile(
                        leading: const Icon(Icons.female),
                        title: Text(state.user.gender.name.capitalize()),
                        subtitle: const Text('Gender'),
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
                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text('Log out'),
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
            logout: (_) => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => const StartUpScreen(),
              ),
            ),
          );
        },
      ),
    );
  }
}
