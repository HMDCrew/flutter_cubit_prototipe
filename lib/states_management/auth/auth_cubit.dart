import 'package:auth/auth.dart';
import 'package:bloc/bloc.dart';
import 'package:async/async.dart';

import '../../cache/local_store.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  LocalStore localStore;
  AuthApi authApi;

  AuthCubit(this.authApi, this.localStore) : super(InitialState());

  signin({required String username, required String password}) async {
    _startLoading();
    final result = await authApi.signIn(username: username, password: password);
    _setResultOfAuthState(result);
  }

  signout() async {
    _startLoading();
    String token = await localStore.fetch();

    if (token.isNotEmpty) {
      localStore.delete(token);
      emit(SignOutSuccessState());
    } else {
      emit(ErrorState('You ar not logged'));
    }
  }

  signup({
    required String name,
    required String username,
    required String email,
    required String password,
    required String repeatPassword,
    String pluginToken = 'MySuperSecretToken',
  }) async {
    _startLoading();
    final result = await authApi.signUp(
      name: name,
      username: username,
      email: email,
      password: password,
      repeatPassword: repeatPassword,
      pluginToken: pluginToken,
    );

    _setResultOfAuthState(result);
  }

  void _setResultOfAuthState(Result<String> result) {
    if (result.asError != null) {
      emit(ErrorState(result.asError!.error.toString()));
    } else {
      localStore.save(result.asValue!.value.toString());
      emit(AuthSuccessState(result.asValue!.value.toString()));
    }
  }

  void _startLoading() {
    emit(LoadingState());
  }
}
