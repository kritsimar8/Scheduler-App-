import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend_/features/auth/cubit/auth_cubit.dart';
import 'package:frontend_/features/auth/pages/login_page.dart';
import 'package:frontend_/features/auth/pages/signup_page.dart';
import 'package:frontend_/features/home/cubit/tasks_cubit.dart';
import 'package:frontend_/features/home/pages/add_new_task_page.dart';
import 'package:frontend_/features/home/pages/home_page.dart';

void main() {
  runApp( MultiBlocProvider(
    providers: [
      BlocProvider(create: (_)=> AuthCubit()),
      BlocProvider(create: (_)=> TasksCubit())
      ],
     child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  @override
  void initState() {
    
    super.initState();
    context.read<AuthCubit>().getUserData();
    
  }
  
  
  
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          fontFamily: "Cera Pro",
          inputDecorationTheme: InputDecorationTheme(
              contentPadding: const EdgeInsets.all(27),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade300, width: 3),
                  borderRadius: BorderRadius.circular(10)),
              focusedBorder:
                  const OutlineInputBorder(borderSide: BorderSide(width: 3)),
              border:
                  const OutlineInputBorder(borderSide: BorderSide(width: 3)),
              errorBorder: OutlineInputBorder(
                borderSide: const BorderSide(width: 3, color: Colors.red),
              )),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            minimumSize: const Size(double.infinity, 60),
          )),
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            if(state is AuthLoggedIn){
              return const HomePage();
            }
            return const SignupPage();
          },
        ),
      );
    
  }
}
