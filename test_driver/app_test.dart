import 'dart:io';

import 'package:flutter_driver/flutter_driver.dart';

import 'package:test/test.dart';

void main() {
  group('Flutter initial tests', () {

    final writeDataFinder = find.byValueKey("email_key");

    final addDataFinder = find.byValueKey("password_key");
    final signInButton = find.byValueKey("sign_in_button");
    final signUpButton = find.byValueKey("meet_neighbors_button");
    final userNameInput = find.byValueKey("username_input");
    final allChatsScreen = find.byValueKey("all_chats");

    var email_data = "roman.dronov@test.com";
    var password_data = "1234567-L";
    var user_name_data = "roman_dronov_test";
    var sign_up_button = 'meet_neighbors_button';

    late FlutterDriver driver;

// Connect to the Flutter driver before running any tests.

    setUpAll(() async {
      driver = await FlutterDriver.connect();
      await Future.delayed(Duration(seconds: 10));
    });

// Close the connection to the driver after the tests have completed.

    tearDownAll(() async {
      driver.close();
    });

    test("Healt of the driver", () async {
      Health health = await driver.checkHealth();
      print(health.status);
    });

    test("Test of the sign up process", () async {
      await driver.tap(writeDataFinder);

      await driver.enterText(email_data);
      await driver.tap(addDataFinder);
      await driver.enterText(password_data);
      await driver.tap(signInButton);
      await Future.delayed(Duration(seconds: 2));
      await driver.tap(userNameInput);
      await driver.enterText(user_name_data);
      await driver.tap(signUpButton);
      await driver.tap(allChatsScreen);
    });
  });
}
