import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sethkitchen/wallet/components/clickable_card.dart';
import 'package:sethkitchen/wallet/components/size_wrapper.dart';
import 'package:sethkitchen/wallet/utils/states.dart';
import 'package:sethkitchen/wallet/utils/theme.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsSubPage extends ConsumerStatefulWidget {
  const SettingsSubPage({Key? key}) : super(key: key);

  @override
  SettingsSubPageState createState() => SettingsSubPageState();
}

/*
 * Settings sub page
 */
class SettingsSubPageState extends ConsumerState<SettingsSubPage> {
  SettingsSubPageState();

  void enableDarkTheme(bool value) {
    if (value) {
      ref.read(settingsProvider.notifier).setTheme(ThemeType.dark);
    } else {
      ref.read(settingsProvider.notifier).setTheme(ThemeType.light);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      child: Padding(
        padding: const EdgeInsets.only(top: 40, left: 20, right: 20),
        child: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            ClickableCard(
              onTap: () async {
                Navigator.pushNamed(context, "/wallet/manage/account");
              },
              child: ListTile(
                title: const Text('Manage Accounts'),
                trailing: Icon(
                  Icons.manage_accounts_outlined,
                  color: Theme.of(context).iconColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void openURL(url) async {
    bool canOpen = await canLaunch(url);

    if (canOpen) {
      await launch(url);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Could not open browser."),
        ),
      );
    }
  }
}
