import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:untitled/constants/routes.dart';
import 'dart:developer'as devtools show log;
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
                  await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                  final user = FirebaseAuth.instance.currentUser;
                  await user?.sendEmailVerification();
                  Navigator.of(context).pushNamed(emailVerifyRoute);
                  }
                  on FirebaseAuthException catch (e) {
                    devtools.log(e.code.toString());

                    if (e.code == 'weak-password') {
                      await showErrorDialog( context,  'Weak password',);
                    }
                    else if(e.code == 'email-already-in-use')
                    {await showErrorDialog( context,  'Already Registered',);}
                  else if(e.code =='invalid-email')
                    {await showErrorDialog( context,  'Invalid email');}
                    else {
                      await showErrorDialog( context,  e.code);
                    }
                  } catch(e) {
                    await showErrorDialog( context,  e.toString());
                  }
                },child: const Text('Register'),),
                TextButton(onPressed: (){
                  Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                }, child: const Text('Already registered ? click here'))
              ],
            ),
        );
  }
}
