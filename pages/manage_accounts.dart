import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sethkitchen/wallet/components/size_wrapper.dart';
import 'package:sethkitchen/wallet/dialogs/editing_account.dart';
import 'package:sethkitchen/wallet/dialogs/account_info.dart';
import 'package:sethkitchen/wallet/dialogs/remove_account.dart';
import 'package:sethkitchen/wallet/utils/states.dart';

class ManageAccountsPage extends StatefulWidget {
  final String name;
  final String path;

  const ManageAccountsPage(
      {required key, required this.name, required this.path})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ManageAccountsPageState();
}

class ManageAccountsPageState extends State<ManageAccountsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Accounts"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.person_add_alt_1_outlined, color: Colors.white),
        onPressed: () {
          Navigator.pushNamed(context, "/wallet/account/select");
        },
      ),
      body: ResponsiveSizer(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Consumer(
            builder: (context, ref, child) {
              final accounts = ref.watch(accountsProvider).values.toList();

              return ListView(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                children: accounts.map((account) {
                  return Card(
                    child: ListTile(
                      subtitle: const Text("Press for more info"),
                      trailing: IconButton(
                        icon: const Icon(Icons.mode_edit_outline_outlined),
                        onPressed: () {
                          editAccountDialog(context, account);
                        },
                      ),
                      enableFeedback: true,
                      title: Text(
                        '${account.name} (${account.address.toString().substring(0, 5)}...)',
                      ),
                      leading: IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          removeAccountDialog(context, account);
                        },
                      ),
                      onTap: () {
                        accountInfoDialog(context, account);
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ),
    );
  }
}
