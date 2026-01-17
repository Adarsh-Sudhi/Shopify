import 'dart:developer';

import 'package:avodha_interview_test/model/userModel/userModel.dart';
import 'package:avodha_interview_test/view/customWidget/toast.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SignUpUser>((event, emit) async {
      emit(AuthLoading());
      bool isSuccess = await _createUser(event.userModel);
      isSuccess
          ? Utils().showToast("Account Created Successfully")
          : Utils().showToast("Account Already exist");
      emit(AuthInitial());
    });

    on<LogInUser>((event, emit) async {
      emit(AuthLoading());
      int responseCode = await _loginUser(event.userModel);

      if (responseCode == 200) {
        emit(AuthGranted(event.userModel));
      } else if (responseCode == 500) {
        Utils().showToast("Invalid Credentials");
        emit(AuthInitial());
      } else {
        Utils().showToast("Account does not exist");
        emit(AuthInitial());
      }
    });
  }
}

Future<int> _loginUser(UserModel userModel) async {
  try {
    Box<dynamic> userHive = Hive.box("userBox");
    Box<dynamic> userSession = Hive.box("sessionBox");

    bool isUserExistOrNot = userHive.containsKey(userModel.email);

    if (!isUserExistOrNot) return 404;

    final user = await userHive.get(userModel.email);

    log(user.toString());

    if (user['password'] == userModel.password) {
      await userSession.put("isLoggedIn", true);
      await userSession.put("email", userModel.email);
      return 200;
    }

    return 500;
  } catch (e) {
    throw Exception(e.toString());
  }
}

Future<bool> _createUser(UserModel userModel) async {
  try {
    Box<dynamic> userHive = Hive.box("userBox");

    bool isUserAlreadyExist = userHive.containsKey(userModel.email);

    if (isUserAlreadyExist) return false;

    await userHive.put(userModel.email, userModel.toMap());

    final test = await userHive.get(userModel.email);
    log(test.toString());
    return true;
  } catch (e) {
    throw Exception(e.toString());
  }
}
