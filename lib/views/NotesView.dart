import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:untitled/services/auth/auth_service.dart';
import '../constants/routes.dart';
import '../enums/menu_action.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main UI',),
        actions: [
          PopupMenuButton<MenuAction>(onSelected: (value) async {
            switch(value){
              case MenuAction.logout:
                final shouldLogout = await showLogoutDialog(context);
                if(shouldLogout){
                  await AuthService.firebase().logOut();
                  Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (_) => false);
                }
                break;
            }
          }, itemBuilder: (context) {
            return const [ PopupMenuItem<MenuAction>(
              value:MenuAction.logout ,
              child:Text('Logout'),
            )
            ];
          },
          ),
        ],
      ),


      body: const Text('Hello World !'),
    );
  }
}
Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog(context: context, builder: (context) {
    return AlertDialog(
      title: const Text('Sign out'),
      content: const Text('Are you sure you want to logout ?'),
      actions: [
        TextButton(onPressed: () {
          Navigator.of(context).pop(false);
        }, child: const Text('Cancel', style: TextStyle(color: Colors.red),)
        ),
        TextButton(onPressed: () {
          Navigator.of(context).pop(true);
        }, child: const Text('Log out',)
        ),
      ],
    );
  },
  ).then((value) => value ?? false);
}

