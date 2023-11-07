import 'package:flutter/material.dart';
import 'package:untitled/constants/routes.dart';
import 'package:untitled/services/auth/auth_exceptions.dart';
import 'package:untitled/services/auth/auth_service.dart';
import '../utilities/show_error_dialog.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    _email = TextEditingController();
    _password =TextEditingController();
    super.initState();
  }
  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return
            Scaffold(
            appBar: AppBar(title: const Text('Register',),),
            body: Column(
              children: [
                Container(
                  height: 130,
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                  child: TextField( controller: _email,decoration: InputDecoration(border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                      hintText: 'Enter email',prefixIcon: const Icon(Icons.email)),
                    keyboardType: TextInputType.emailAddress,
                    enableSuggestions: false,
                    autocorrect: false,),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 0.0),
                  child: TextField(controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                      hintText: 'Enter password',prefixIcon: const Icon(Icons.key),),
                  ),
                ),
                TextButton(onPressed: ()async{
                  try{final email=_email.text;
                  final password=_password.text;
                  await AuthService.firebase().createUser(email: email,
                      password: password,
                  );
                  AuthService.firebase().sendEmailVerification();
                  Navigator.of(context).pushNamed(emailVerifyRoute);
                  } on WeakPasswordAuthException{
                    await showErrorDialog( context,
                      'Weak password',
                    );
                  }  on InvalidEmailAuthException{
                    await showErrorDialog( context,
                        'Invalid email'
                    );
                  } on EmailAlreadyInUseAuthException{
                    await showErrorDialog( context,
                        'Email already in use'
                    );
                  }
                  on GenericAuthException{
                    await showErrorDialog( context,
                      'Authentication Error',
                    );
                  }
                },child: const Text('Register'),
                ),
                TextButton(onPressed: (){
                  Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                }, child: const Text('Already registered ? click here'))
              ],
            ),
        );
  }
}
