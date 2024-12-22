 import 'dart:convert';

import 'package:frontend_/core/constants/constants.dart';
import 'package:frontend_/core/services/sp_service.dart';
import 'package:frontend_/features/auth/repository/auth_local_repository.dart';
import 'package:frontend_/models/user_model.dart';
import 'package:http/http.dart' as http;

class AuthRemoteRepository {

  final spService = SpService();
  final authLocalRepository = AuthLocalRepository();
  


  Future<UserModel> signUp({
    required String name, 
    required String email,
    required String password, 
  })async {
    try{
    final res = await http.post(Uri.parse('${Constants.backendUri}/auth/signup',
      ),
      headers: {
        'Content-Type': 'application/json'
      }, 
      body: jsonEncode(
        {
        'name': name, 
        'email': email,
        'password': password
      }
      )
      );
      if(res.statusCode!=201){
        throw jsonDecode(res.body)['error'];
      }

      return UserModel.fromJson(res.body);

    }catch(e){
      throw e.toString();
    }
  }

   Future<UserModel> login({
    required String email,
    required String password, 
  })async {
    try{
    final res = await http.post(Uri.parse('${Constants.backendUri}/auth/login',
      ),
      headers: {
        'Content-Type': 'application/json'
      }, 
      body: jsonEncode(
        {
        'email': email,
        'password': password
      }
      )
      );
      if(res.statusCode!=200){
        throw jsonDecode(res.body)['error'];
      }

      return UserModel.fromJson(res.body);

    }catch(e){
      throw e.toString();
    }
  }

 Future<UserModel?> getUserData()async {
    try{
     final token = await spService.getToken();

      if(token == null){
        return null;
      }
         print("PART 1 CLEARED");
    final res = await http.post(Uri.parse('${Constants.backendUri}/auth/tokenIsValid',
      ),
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      }, 
      ).timeout(const Duration(seconds: 2));
      print("post");
      if(res.statusCode!=200 || jsonDecode(res.body)== false){
        return null;
      }
       final userResponse = await http.get(Uri.parse('${Constants.backendUri}/auth',
      ),
      headers: {
        'Content-Type': 'application/json',
        'x-auth-token': token,
      }, 
     
      ).timeout(const Duration(seconds: 2));
      print(userResponse.body);

      if(userResponse.statusCode !=200){
        throw jsonDecode(userResponse.body)['error'];
      }

      return UserModel.fromJson(userResponse.body);

    }catch(e){
      print("local");
      final user = await authLocalRepository.getUser();
      print(user);

      return user;
    }
  }



}