import 'package:flutter/foundation.dart';
import 'package:localsend_app/util/update_checker.dart';
import 'package:test/test.dart';

void main() {
  group('isNewerVersion', () {
    test('detects a newer patch, minor and major version', () {
      expect(isNewerVersion('1.18.3', '1.18.2'), true);
      expect(isNewerVersion('1.19.0', '1.18.9'), true);
      expect(isNewerVersion('2.0.0', '1.99.99'), true);
    });

    test('same or older versions are not updates', () {
      expect(isNewerVersion('1.18.2', '1.18.2'), false);
      expect(isNewerVersion('1.18.1', '1.18.2'), false);
      expect(isNewerVersion('1.9.0', '1.18.0'), false);
    });

    test('ignores a leading v and build numbers', () {
      expect(isNewerVersion('v1.18.3', '1.18.2'), true);
      expect(isNewerVersion('1.18.2+70', '1.18.2'), false);
    });
  });

  group('pickDownloadAsset', () {
    final assets = [
      {'name': 'Lalitha-Local-Share-Android-older-phones.apk', 'browser_download_url': 'https://x/older.apk'},
      {'name': 'Lalitha-Local-Share-Android.apk', 'browser_download_url': 'https://x/android.apk'},
      {'name': 'Lalitha-Local-Share-Mac.zip', 'browser_download_url': 'https://x/mac.zip'},
      {'name': 'Lalitha-Local-Share-Windows-Setup.exe', 'browser_download_url': 'https://x/setup.exe'},
    ];

    test('picks the file for each platform', () {
      expect(pickDownloadAsset(assets, TargetPlatform.android), 'https://x/android.apk');
      expect(pickDownloadAsset(assets, TargetPlatform.macOS), 'https://x/mac.zip');
      expect(pickDownloadAsset(assets, TargetPlatform.windows), 'https://x/setup.exe');
      expect(pickDownloadAsset(assets, TargetPlatform.linux), null);
    });
  });
}
