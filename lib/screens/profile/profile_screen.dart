import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../design/widgets/section_header.dart';
import '../../main.dart';
import '../startup/start_up_screen.dart';
import 'bloc/profile_bloc.dart';

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
              automaticallyImplyLeading: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
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
                      const CircleAvatar(
                        radius: 64,
                      ),
                      const SizedBox(height: 24),
                      Text(
                        state.user.name,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      Text(
                        state.user.phoneNumber,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 24),
                      const SectionHeader(title: 'Settings'),
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
