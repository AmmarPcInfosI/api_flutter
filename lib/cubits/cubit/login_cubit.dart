import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  static LoginCubit get(context) => BlocProvider.of(context);
  Dio dio = Dio();

  void loginUser(String mail, String pwd) {
    emit(LoginLoadingState());
    dio.post('https://fakestoreapi.com/auth/login', data: {
      "username": mail,
      "password": pwd
    }).then((value) {
      if (value.statusCode == 200) {
        // Set the isLoggedIn flag to true upon successful login
        SharedPreferences.getInstance().then((prefs) {
          prefs.setBool('isLoggedIn', true);
        });

        emit(LoginSuccessState());
        print('Success');
      } else {
        print(value.statusCode);
      }
    }).catchError((e) {
      emit(LoginErrorState());
      print(e.toString());
    });
  }
}
