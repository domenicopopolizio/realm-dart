////////////////////////////////////////////////////////////////////////////////
//
// Copyright 2021 Realm Inc.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////

// ignore_for_file: unused_local_variable

import 'dart:io';
import 'package:test/test.dart' hide test, throws;
import 'test_base.dart';
import '../lib/realm.dart';
import 'test_model.dart';

Future<void> main([List<String>? args]) async {
  parseTestNameFromArguments(args);

  print("Current PID $pid");

  setupTests(Configuration.filesPath, (path) => {Configuration.defaultPath = path});

  test('Configuration can be created', () {
    Configuration([Car.schema]);
  });

  test('Configuration exception if no schema', () {
    expect(() => Configuration([]), throws<RealmException>());
  });

  test('Configuration default path', () {
    if (Platform.isAndroid || Platform.isIOS) {
      expect(Configuration.defaultPath, endsWith(".realm"));
      expect(Configuration.defaultPath, startsWith("/"), reason: "on Android and iOS the default path should contain the path to the user data directory");
    } else {
      expect(Configuration.defaultPath, endsWith(".realm"));
    }
  });

  test('Configuration files path', () {
    if (Platform.isAndroid || Platform.isIOS) {
      expect(Configuration.filesPath, isNot(endsWith(".realm")), reason: "on Android and iOS the files path should be a directory");
      expect(Configuration.filesPath, startsWith("/"), reason: "on Android and iOS the files path should be a directory");
    } else {
      expect(Configuration.filesPath, equals(""), reason: "on Dart standalone the files path should be an empty string");
    }
  });

  test('Configuration get/set path', () {
    Configuration config = Configuration([Car.schema]);
    expect(config.path, endsWith('.realm'));

    const path = "my/path/default.realm";
    config.path = path;
    expect(config.path, equals(path));
  });

  test('Configuration get/set schema version', () {
    Configuration config = Configuration([Car.schema]);
    expect(config.schemaVersion, equals(0));

    config.schemaVersion = 3;
    expect(config.schemaVersion, equals(3));
  });
}
