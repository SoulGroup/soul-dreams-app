// The founder's export, the phone's side (D107; D108; R8), read from the
// source, since `flutter test` runs no Swift: every line of it compiled
// only under SOULDREAMS_EXPORT, which dev.xcconfig and founder.xcconfig set
// and tester.xcconfig never does; the file given to AirDrop alone; every
// type Apple names excluded but AirDrop; the file deleted when the share
// closes and swept at launch. A floor: the owner's checks prove the rest
// (the tester app's binary holds none of it; each other target opens
// empty). `flutter test` runs in app/.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:souldreams/founder/export_text.dart';
import 'package:souldreams/founder/founder_export.dart';

import '../fixtures.dart';

const _swift = 'ios/Runner/AppDelegate.swift';
const _condition = 'SOULDREAMS_EXPORT';
const _marks = ['FounderExport', 'founder_export', 'OnlyAirDrop', 'exportChannel', 'UIActivity', 'airDrop'];
const _setting = 'SWIFT_ACTIVE_COMPILATION_CONDITIONS = \$(inherited) $_condition';

String _read(String path) => File(path).readAsStringSync();

// The text between [from] and the first [to] after it.
String _between(String text, String from, String to) {
  final start = text.indexOf(from);
  expect(start, isNot(-1), reason: from);
  final end = text.indexOf(to, start);
  expect(end, isNot(-1), reason: to);
  return text.substring(start, end);
}

void main() {
  final swift = _read(_swift);

  test('every line of the export is inside #if $_condition', () {
    var inside = false;
    var blocks = 0;
    final outside = <int>[];
    final lines = swift.split('\n');
    for (var i = 0; i < lines.length; i++) {
      final t = lines[i].trim();
      if (t.startsWith('#if')) {
        expect(t, '#if $_condition', reason: 'line ${i + 1}');
        expect(inside, isFalse, reason: 'line ${i + 1}');
        inside = true;
        blocks++;
      } else if (t == '#endif') {
        inside = false;
      } else if (!inside && _marks.any(lines[i].contains)) {
        outside.add(i + 1);
      }
    }
    expect(inside, isFalse);
    expect(outside, isEmpty);
    expect(blocks, 4);
  });

  // A branch of the condition other than the one that holds the export
  // would compile into the tester app (#else, #elseif).
  test('the export has no #else or #elseif branch', () {
    final branches = [
      for (final (i, l) in swift.split('\n').indexed)
        if (l.trim().startsWith('#else')) i + 1,
    ];
    expect(branches, isEmpty);
  });

  test('no other file under ios/Runner knows of the export', () {
    final others = [
      for (final f in Directory('ios/Runner').listSync(recursive: true))
        if (f is File &&
            RegExp(r'[.](swift|h|m|mm)$').hasMatch(f.path) &&
            !f.path.endsWith('AppDelegate.swift') &&
            _marks.any(f.readAsStringSync().contains))
          f.path,
    ];
    expect(others, isEmpty);
  });

  // The flavours' xcconfigs are the Runner target's base configurations, so
  // a value set in the project's own settings would add to or replace theirs.
  test('no Runner build configuration sets or drops the condition', () {
    final pbx = _read('ios/Runner.xcodeproj/project.pbxproj');
    expect(pbx, isNot(contains(_condition)));
    final sets = RegExp(r'SWIFT_ACTIVE_COMPILATION_CONDITIONS = ([^;]*);').allMatches(pbx).map((m) => m[1]).toList();
    // Only the unit-test target's four, DEBUG alone.
    expect(sets, ['DEBUG', 'DEBUG', 'DEBUG', 'DEBUG']);
  });

  test('the condition: dev and founder set it, tester never', () {
    for (final flavour in ['dev', 'founder']) {
      expect(_read('ios/Flutter/$flavour.xcconfig').split('\n'), contains(_setting), reason: flavour);
    }
    for (final other in ['tester', 'Debug', 'Release']) {
      expect(_read('ios/Flutter/$other.xcconfig'), isNot(contains(_condition)), reason: other);
    }
  });

  test("the channel's name is the same on both sides", () {
    expect(swift, contains('static let channelName = "${FounderExport.channelName}"'));
  });

  test("the method and its two keys are the Dart side's", () {
    expect(swift, contains('guard call.method == "share" else {'));
    final share = _between(swift, 'static func share(', 'let sheet');
    expect(share, contains('let name = a["name"] as? String'));
    expect(share, contains('let bytes = a["bytes"] as? FlutterStandardTypedData'));
  });

  test("the file's name passes the phone's own check", () {
    final check = _between(swift, 'static func valid(', 'static func presenter');
    final pattern = RegExp(r'range\(of: "([^"]+)"').firstMatch(check)![1]!;
    expect(RegExp(pattern).hasMatch(exportFileName(nightsFromFixtures().first)), isTrue);
    expect(RegExp(pattern).hasMatch('../2026-06-02.txt'), isFalse);
  });

  test('the share closing gives the phone back and answers once', () {
    final closed = _between(swift, 'sheet.completionWithItemsHandler', 'top.present');
    expect(closed, contains('guard sharing else { return }'));
    expect(closed, contains('sharing = false'));
    expect(closed, contains('result(nil)'));
  });

  test('a failure answers with a code only', () {
    expect(swift, contains('result(FlutterError(code: "export", message: nil, details: nil))'));
  });

  test('the file is given to AirDrop alone', () {
    expect(swift, contains('activityItems: [OnlyAirDrop(url)]'));
    final item = _between(swift, 'itemForActivityType activityType', '#endif');
    expect(item, contains('return activityType == .airDrop ? url : nil'));
    expect(RegExp(r'\breturn\b').allMatches(item), hasLength(1));
  });

  test('every type Apple names is excluded, but AirDrop', () {
    // UIActivity.h, iOS 26.5 SDK: every UIActivityType constant.
    const named = [
      'postToFacebook', 'postToTwitter', 'postToWeibo', 'message', 'mail', 'print', 'copyToPasteboard',
      'assignToContact', 'saveToCameraRoll', 'addToReadingList', 'postToFlickr', 'postToVimeo',
      'postToTencentWeibo', 'openInIBooks', 'markupAsPDF', 'sharePlay', 'collaborationInviteWithLink',
      'collaborationCopyLink', 'addToHomeScreen',
    ];
    final excluded = _between(swift, 'static var excluded', 'return types');
    final listed = RegExp(r'(?<=[\s\[,(])\.([a-zA-Z]+)').allMatches(excluded).map((m) => m[1]!).toSet();
    expect(listed, named.toSet());
    expect(swift, contains('sheet.excludedActivityTypes = excluded'));
    expect(swift, contains('sheet.excludedActivitySectionTypes = .peopleSuggestions'));
  });

  test('the file goes when the share closes, and at launch', () {
    final closed = _between(swift, 'sheet.completionWithItemsHandler', 'top.present');
    expect(closed, contains('sweep()'));
    final launch = _between(swift, 'didFinishLaunchingWithOptions launchOptions', 'return super.application');
    expect(launch, contains('FounderExport.sweep()'));
    expect(_between(swift, 'static func share(', 'let sheet'), contains('sweep()'));
  });

  test('the file is written with complete protection, in tmp', () {
    final share = _between(swift, 'static func share(', 'let sheet');
    expect(share, contains('bytes.data.write(to: url, options: [.completeFileProtection])'));
    expect(share, contains('attributes: complete'));
    expect(swift, contains('FileManager.default.temporaryDirectory.appendingPathComponent("Export"'));
  });
}
