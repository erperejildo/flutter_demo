import 'package:flutter/material.dart';
import 'package:flutter_demo/classes/loading.dart';
import 'package:flutter_demo/locales.dart';
import 'package:flutter_demo/main.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:unicons/unicons.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({Key? key}) : super(key: key);
  @override
  OptionsPageState createState() => OptionsPageState();
}

class OptionsPageState extends State<OptionsPage> {
  late String _language;

  @override
  void initState() {
    super.initState();
    _language = prefs.getString('language')!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('options.title')),
      ),
      body: ListView(
        children: ListTile.divideTiles(
          context: context,
          tiles: [
            ListTile(
              leading: const Icon(UniconsLine.language),
              title: Text(translate('options.language')),
              trailing: DropdownButton<String>(
                value: _language,
                items: languagesDropdown
                    .map<DropdownMenuItem<String>>((Map value) {
                  return DropdownMenuItem<String>(
                    value: value["value"],
                    child: Text(value["name"]),
                  );
                }).toList(),
                onChanged: (newLang) async {
                  if (newLang is! String) return;

                  final loading = Loading();
                  loading.load(
                    context,
                    translate('loads.changing_language'),
                  );
                  changeLocale(context, newLang);
                  _language = newLang;
                  await prefs.setString('language', newLang).then((value) {
                    Locale(newLang, '');
                    loading.cancel(context);
                  });
                },
              ),
            ),
          ],
        ).toList(),
      ),
    );
  }
}
