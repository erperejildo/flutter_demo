import 'package:flutter_demo/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  // ignore: unused_local_variable
  late SharedPreferences prefs;

  testWidgets('detects the first time we open the app',
      (WidgetTester tester) async {
    // await prefs.reload();
    // SharedPreferences.setMockInitialValues({"music": true});

    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();

    final bool firstTime = await detectFirstTime();
    expect(firstTime, true);
  });
}
