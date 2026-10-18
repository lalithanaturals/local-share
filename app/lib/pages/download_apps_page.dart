import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:localsend_app/util/ui/snackbar.dart';
import 'package:localsend_app/widget/responsive_list_view.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:url_launcher/url_launcher.dart';

/// Public download page for all platforms (GitHub Pages).
const downloadPageUrl = 'https://lalithanaturals.github.io/local-share/';

/// Always points to the files of the newest release.
const _latestDownload = 'https://github.com/lalithanaturals/local-share/releases/latest/download';

/// Lets the user get the app onto other devices: a QR code of the download page
/// plus direct download links for every platform.
class DownloadAppsPage extends StatelessWidget {
  const DownloadAppsPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Get the app'),
      ),
      body: ResponsiveListView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        children: [
          Card(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text(
                    'Scan to open the download page',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 15),
                  SizedBox(
                    width: 220,
                    height: 220,
                    child: PrettyQrView.data(
                      errorCorrectLevel: QrErrorCorrectLevel.Q,
                      data: downloadPageUrl,
                      decoration: const PrettyQrDecoration(
                        shape: PrettyQrSmoothSymbol(
                          roundFactor: 0,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  const SelectableText(
                    downloadPageUrl,
                    style: TextStyle(fontSize: 15, color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () async {
                          await Clipboard.setData(const ClipboardData(text: downloadPageUrl));
                          if (context.mounted) {
                            context.showSnackBar('Link copied');
                          }
                        },
                        icon: const Icon(Icons.content_copy),
                        label: const Text('Copy link'),
                      ),
                      OutlinedButton.icon(
                        onPressed: () async => _open(downloadPageUrl),
                        icon: const Icon(Icons.open_in_browser),
                        label: const Text('Open'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Download', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 10),
          const _DownloadTile(
            icon: Icons.android,
            title: 'Android',
            subtitle: 'APK for phones and tablets',
            url: '$_latestDownload/Lalitha-Local-Share-Android.apk',
          ),
          const _DownloadTile(
            icon: Icons.window,
            title: 'Windows',
            subtitle: 'Installer for Windows 10 and 11',
            url: '$_latestDownload/Lalitha-Local-Share-Windows-Setup.exe',
          ),
          const _DownloadTile(
            icon: Icons.laptop_mac,
            title: 'Mac',
            subtitle: 'For macOS 11 or newer',
            url: '$_latestDownload/Lalitha-Local-Share-Mac.zip',
          ),
          const _DownloadTile(
            icon: Icons.phone_iphone,
            title: 'iPhone & iPad',
            subtitle: 'No app needed. Tap "Show QR" or "Send via QR" on your computer and scan it with the iPhone camera.',
          ),
          const _DownloadTile(
            icon: Icons.language,
            title: 'Web page',
            subtitle: downloadPageUrl,
            url: downloadPageUrl,
            buttonLabel: 'Open',
          ),
        ],
      ),
    );
  }
}

Future<void> _open(String url) async {
  await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
}

class _DownloadTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? url;
  final String buttonLabel;

  const _DownloadTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.url,
    this.buttonLabel = 'Download',
  });

  @override
  Widget build(BuildContext context) {
    final url = this.url;
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        leading: Icon(icon, size: 32),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: url == null
            ? null
            : FilledButton(
                onPressed: () async => _open(url),
                child: Text(buttonLabel),
              ),
        onTap: url == null ? null : () async => _open(url),
      ),
    );
  }
}
