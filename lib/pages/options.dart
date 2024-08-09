import 'package:flutter/material.dart';
import 'package:flutter_demo/audio/sounds.dart';
import 'package:flutter_demo/classes/loading.dart';
import 'package:flutter_demo/locales.dart';
import 'package:flutter_demo/main.dart';
import 'package:flutter_demo/providers/global.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:provider/provider.dart';
import 'package:unicons/unicons.dart';

class OptionsPage extends StatefulWidget {
  const OptionsPage({super.key});
  @override
  OptionsPageState createState() => OptionsPageState();
}

class OptionsPageState extends State<OptionsPage> {
  late String _language;
  late bool _music;

  @override
  void initState() {
    super.initState();
    _language = prefs.getString('language')!;
    _music = prefs.getBool('music')!;
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
            ListTile(
              leading: Icon(Provider.of<Global>(context).darkMode()
                  ? UniconsLine.sun
                  : UniconsLine.moon),
              title: Text(translate(Provider.of<Global>(context).darkMode()
                  ? 'options.light_mode'
                  : 'options.dark_mode')),
              subtitle: Text(translate('options.dark_mode_tip')),
              trailing: const Icon(UniconsLine.arrow_right),
              onTap: () async {
                Provider.of<Global>(context, listen: false).changeTheme();
              },
            ),
            ListTile(
              leading:
                  Icon(_music ? UniconsLine.volume : UniconsLine.volume_mute),
              title: Text(translate('options.music')),
              onTap: () async {
                setState(() {
                  _music = !_music;
                });

                if (_music) {
                  sounds.playBackground();
                } else {
                  sounds.stopBackground();
                }

                prefs.setBool('music', _music);
              },
            ),
            ListTile(
              leading: const Icon(UniconsLine.envelope_alt),
              title: Text(translate('options.contact_me')),
              // subtitle: Text(translate('options.contact_subtitle')),
              trailing: const Icon(UniconsLine.arrow_right),
              onTap: () async {
                contact();
              },
            ),
          ],
        ).toList(),
      ),
    );
  }

  Future<void> contact() async {
    final Email newEmail = Email(
      body: '',
      subject: "Hi Daniel!",
      recipients: ["d15_1_89@msn.com"],
      isHTML: false,
    );
    await FlutterEmailSender.send(newEmail);
  }
}
