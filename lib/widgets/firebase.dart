import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_demo/classes/loading.dart';
import 'package:flutter_demo/classes/validators.dart';
import 'package:flutter_demo/providers/auth.dart';
import 'package:flutter_demo/services/firestore.dart';
import 'package:flutter_demo/types/firestore_user.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';

class Firebase extends StatefulWidget {
  const Firebase({super.key});

  @override
  State<Firebase> createState() => _FirebaseState();
}

class _FirebaseState extends State<Firebase> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _photoController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Visibility(
              visible: Provider.of<Auth>(context).auth.currentUser == null,
              child: loggedOutUI(),
            ),
            Visibility(
              visible: Provider.of<Auth>(context).auth.currentUser != null,
              child: loggedInUI(),
            ),
            Visibility(
              visible: Provider.of<Auth>(context).auth.currentUser != null,
              child: ElevatedButton(
                onPressed: () {
                  Provider.of<Auth>(context, listen: false).logOut(context);
                },
                child: Text(translate('firebase.log_out')),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget loggedOutUI() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(translate('firebase.need_log_in')),
        ),
        ElevatedButton(
          onPressed: () async {
            await Provider.of<Auth>(context, listen: false).logIn(context);
          },
          child: Text(translate('firebase.log_in_google')),
        ),
      ],
    );
  }

  Widget loggedInUI() {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(Provider.of<Auth>(context).auth.currentUser?.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        // If the document exists and there is no error, build the UI
        if (snapshot.hasData && snapshot.data!.exists) {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          _nameController.text = data['displayName'];
          _photoController.text = data['photoURL'];

          return Column(
            children: [
              Text(
                translate('firebase.welcome'),
                style: const TextStyle(fontSize: 20),
              ),
              Text(translate('firebase.welcome_desc')),
              form(),
            ],
          );
        } else {
          // If the document does not exist
          // NOTE: in our case, this is not possible
          // because we just created the user after a new signup,
          // but this is good to have anyway
          return Text(translate('firebase.user_error'));
        }
      },
    );
  }

  Widget form() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          nameTextField(),
          photoTextField(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // example of failing API and how to catch errors
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(translate('firebase.api_error')),
                          duration: const Duration(seconds: 3),
                        ));
                      }
                    },
                    child: Text(translate('firebase.submit_error')),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      submitForm();
                    }
                  },
                  child: Text(translate('firebase.submit')),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget nameTextField() {
    return TextFormField(
      controller: _nameController,
      validator: (value) {
        return Validators.checkInput(value!);
      },
      decoration: InputDecoration(
        labelText: translate('firebase.name'),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  Widget photoTextField() {
    return TextFormField(
      controller: _photoController,
      validator: (value) {
        return Validators.checkUrl(value!);
      },
      decoration: InputDecoration(
        labelText: translate('firebase.photo'),
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
    );
  }

  Future<void> submitForm() async {
    final loading = Loading();
    loading.load(
      context,
      translate('loads.updating_user'),
    );

    final FirestoreUser user = FirestoreUser(
      uid: Provider.of<Auth>(context, listen: false).auth.currentUser!.uid,
      displayName: _nameController.text,
      photoURL: _photoController.text,
    );

    await Firestore().updateUser(user).then((value) => loading.cancel(context));
  }
}
