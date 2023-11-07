import 'package:flutter/material.dart';
import 'package:untitled/services/auth/auth_service.dart';
import 'package:untitled/views/LoginView.dart';
import 'package:untitled/views/NotesView.dart';
import 'package:untitled/views/RegisterView.dart';
import 'package:untitled/views/Verify_Email.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MaterialApp(
  title: 'Flutter Demo',
  theme: ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
  useMaterial3: true,
  ),
  home: const HomePage(),
    routes: {
      '/login/':(context)=> const LoginView(),
      '/register/':(context)=> const RegisterView(),
      '/notes/':(context)=> const NotesView(),
      '/email-verify/':(context)=> const VerifyEmail(),
    },
  ),);
}
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: AuthService.firebase().initialize(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState){
          case ConnectionState.done:
          final user= AuthService.firebase().currentUser;
          if(user !=null)
            {
              if(user.isEmailVerified)
                {
                  return const NotesView();
                }
              else {
                return const VerifyEmail();
              }
            }
          else {
            return const LoginView();
          }
          return const Text('Done');
          // final emailVerified = user?.emailVerified ?? false;
          // if (emailVerified){
          //   print('Email is verified');}
          //   else {
          //   return const VerifyEmail();
          // }
          // return const Text('DONE');
            return const LoginView();
          default:
            return const CircularProgressIndicator();
        }
        },
    );
  }
}






