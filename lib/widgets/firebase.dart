import 'package:flutter/material.dart';
import 'package:flutter_demo/providers/auth.dart';
import 'package:provider/provider.dart';

class Firebase extends StatefulWidget {
  const Firebase({super.key});

  @override
  State<Firebase> createState() => _FirebaseState();
}

class _FirebaseState extends State<Firebase> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: logIn(),
    );
  }

  Widget logIn() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Visibility(
          visible: Provider.of<Auth>(context).auth.currentUser == null,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
                'You first need to log in. After that, you will be able to make some changes to your account'),
          ),
        ),
        Visibility(
          visible: Provider.of<Auth>(context).auth.currentUser == null,
          child: ElevatedButton(
            onPressed: () {
              Provider.of<Auth>(context, listen: false).signIn(context);
            },
            child: Text('Sign in with Google'),
          ),
        ),
        Visibility(
          visible: Provider.of<Auth>(context).auth.currentUser != null,
          child: ElevatedButton(
            onPressed: () {
              Provider.of<Auth>(context, listen: false).signOut(context);
            },
            child: Text('Sign out'),
          ),
        ),
      ],
    );
  }
}
