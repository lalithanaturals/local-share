import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

final _logger = Logger('UpdateChecker');

/// GitHub repository that publishes Lalitha Local Share releases.
const _latestReleaseApi = 'https://api.github.com/repos/lalithanaturals/local-share/releases/latest';
const _releasesPageUrl = 'https://github.com/lalithanaturals/local-share/releases/latest';

/// A newer release than the running app.
class AppUpdate {
  final String version;

  /// Direct download of the file for this platform, or the release page.
  final String downloadUrl;

  const AppUpdate({required this.version, required this.downloadUrl});
}

/// Whether [candidate] (e.g. "1.18.3") is newer than [current] (e.g. "1.18.2").
bool isNewerVersion(String candidate, String current) {
  final a = _parseVersion(candidate);
  final b = _parseVersion(current);
  for (var i = 0; i < 3; i++) {
    if (a[i] != b[i]) {
      return a[i] > b[i];
    }
  }
  return false;
}

List<int> _parseVersion(String version) {
  final cleaned = version.trim().replaceFirst(RegExp(r'^[vV]'), '').split('+').first;
  final parts = cleaned.split('.').map((p) => int.tryParse(RegExp(r'^\d+').stringMatch(p) ?? '') ?? 0).toList();
  while (parts.length < 3) {
    parts.add(0);
  }
  return parts;
}

/// Picks the release file that fits this device.
String? pickDownloadAsset(List<Map<String, dynamic>> assets, TargetPlatform platform) {
  bool Function(String name)? matches = switch (platform) {
    TargetPlatform.windows => (name) => name.toLowerCase().endsWith('.exe'),
    TargetPlatform.macOS => (name) => name.toLowerCase().contains('mac') && name.toLowerCase().endsWith('.zip'),
    TargetPlatform.android => (name) => name == 'Lalitha-Local-Share-Android.apk',
    _ => null,
  };
  if (matches == null) {
    return null;
  }
  for (final asset in assets) {
    final name = asset['name'];
    final url = asset['browser_download_url'];
    if (name is String && url is String && matches(name)) {
      return url;
    }
  }
  return null;
}

/// Returns the latest release if it is newer than the running app, otherwise null.
/// Throws if GitHub cannot be reached.
Future<AppUpdate?> fetchAppUpdate() async {
  final currentVersion = (await PackageInfo.fromPlatform()).version;
  final client = HttpClient()..connectionTimeout = const Duration(seconds: 10);
  try {
    final request = await client.getUrl(Uri.parse(_latestReleaseApi));
    request.headers.set(HttpHeaders.acceptHeader, 'application/vnd.github+json');
    request.headers.set(HttpHeaders.userAgentHeader, 'LalithaLocalShare/$currentVersion');
    final response = await request.close().timeout(const Duration(seconds: 15));
    if (response.statusCode != 200) {
      throw HttpException('GitHub returned status ${response.statusCode}');
    }
    final json = jsonDecode(await response.transform(utf8.decoder).join()) as Map<String, dynamic>;
    final latestVersion = (json['tag_name'] as String? ?? '').replaceFirst(RegExp(r'^[vV]'), '');
    if (latestVersion.isEmpty || !isNewerVersion(latestVersion, currentVersion)) {
      return null;
    }
    final assets = (json['assets'] as List<dynamic>? ?? []).whereType<Map<String, dynamic>>().toList();
    final pageUrl = json['html_url'] as String? ?? _releasesPageUrl;
    return AppUpdate(
      version: latestVersion,
      downloadUrl: pickDownloadAsset(assets, defaultTargetPlatform) ?? pageUrl,
    );
  } finally {
    client.close();
  }
}

/// Checks for an update in the background and shows a dialog if one is available.
/// Errors (e.g. no internet) are only logged.
Future<void> checkForUpdateSilently(BuildContext context) async {
  try {
    final update = await fetchAppUpdate();
    if (update != null && context.mounted) {
      await showUpdateDialog(context, update);
    }
  } catch (e) {
    _logger.info('Update check failed: $e');
  }
}

Future<void> showUpdateDialog(BuildContext context, AppUpdate update) async {
  final currentVersion = (await PackageInfo.fromPlatform()).version;
  if (!context.mounted) {
    return;
  }
  await showDialog<void>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      title: const Text('Update available'),
      content: Text('Lalitha Local Share ${update.version} is available.\nYou have version $currentVersion.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(),
          child: const Text('Later'),
        ),
        FilledButton(
          onPressed: () async {
            Navigator.of(dialogContext).pop();
            await launchUrl(Uri.parse(update.downloadUrl), mode: LaunchMode.externalApplication);
          },
          child: const Text('Download'),
        ),
      ],
    ),
  );
}
