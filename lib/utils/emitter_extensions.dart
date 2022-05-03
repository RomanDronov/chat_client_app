import 'package:flutter_bloc/flutter_bloc.dart';

extension EmitterExtensions<S> on Emitter<S> {
  void sync(S state, S syncState) {
    call(syncState);
    call(state);
  }
}
