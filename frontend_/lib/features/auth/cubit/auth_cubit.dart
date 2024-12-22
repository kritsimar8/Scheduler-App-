import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_/core/services/sp_service.dart';
import 'package:frontend_/features/auth/repository/auth_local_repository.dart';
import 'package:frontend_/features/auth/repository/auth_remote_repository.dart';
import 'package:frontend_/models/user_model.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());
  final authremoteRepository = AuthRemoteRepository();
  final authLocalRepository = AuthLocalRepository();
  final spService = SpService();

  void getUserData() async {
    try {
      emit(AuthLoading());
      final userModel = await authremoteRepository.getUserData();

      if(userModel != null){
        await authLocalRepository.insertUser(userModel);
        emit(AuthLoggedIn(userModel));
       
      }else{
        emit(AuthInitial());
      }
     
    }
    catch(e) {
      print(e);
      emit(AuthInitial());
    }
  }

  void signUp(
      {required String name,
       required String email,
        required String password}) async {
    try {
      emit(AuthLoading()); 
      final userModel = await authremoteRepository.signUp
      (name: name,
       email: email,
      password: password);

      emit(AuthLoggedIn(userModel));
    } catch (e) {
      emit (AuthError(e.toString()));
    }
  }

  void login({
    required String email , 
    required String password,
  }) async{
    try {
      emit(AuthLoading());
      final userModel = await authremoteRepository.login(
        email: email, 
        password: password
      );

      if(userModel.token.isNotEmpty){
       await spService.setToken(userModel.token);
      }

      await authLocalRepository.insertUser(userModel);


      emit(AuthLoggedIn(userModel));

    }catch (e){
      emit(AuthError(e.toString()));
    }
  }



}
