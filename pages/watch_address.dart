import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sethkitchen/wallet/components/network_selector.dart';
import 'package:sethkitchen/wallet/components/size_wrapper.dart';
import 'package:sethkitchen/wallet/utils/states.dart';

/*
 * Getting Started Page
 */
class WatchAddress extends ConsumerStatefulWidget {
  final String name;
  final String path;

  const WatchAddress({required key, required this.name, required this.path})
      : super(key: key);

  @override
  WatchAddressState createState() => WatchAddressState();
}

class WatchAddressState extends ConsumerState<WatchAddress> {
  late String address;
  late String accountName;
  late NetworkUrl networkURL;

  WatchAddressState();

  @override
  Widget build(BuildContext context) {
    final accountsManager = ref.read(accountsProvider.notifier);

    accountName = accountsManager.generateAccountName();

    return Scaffold(
      appBar: AppBar(title: const Text('Watch an address')),
      body: ResponsiveSizer(
        child: Column(
          children: [
            Form(
              autovalidateMode: AutovalidateMode.always,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Text(
                          "Think of an easy name to associate this address with, don't worry, you can change it later."),
                    ),
                    TextFormField(
                      initialValue: accountName,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        hintText: "Account name",
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 6, right: 5),
                          child: Icon(Icons.account_box_rounded),
                        ),
                      ),
                      autofocus: true,
                      validator: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Empty account name';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (String value) async {
                        accountName = value;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 10),
                          hintText: "Wallet address",
                          prefixIcon: Padding(
                            padding: EdgeInsets.only(bottom: 6, right: 5),
                            child: Icon(Icons.account_balance_wallet_outlined),
                          ),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Empty address';
                          } else if (value.length < 43 || value.length > 50) {
                            return 'Address length is not correct';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (String value) async {
                          address = value;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10, bottom: 30),
                      child: NetworkSelector(
                        onSelected: (NetworkUrl? url) {
                          if (url != null) {
                            networkURL = url;
                          }
                        },
                      ),
                    ),
                    ElevatedButton(
                      child: const Padding(
                        padding: EdgeInsets.all(10),
                        child: Text("Continue"),
                      ),
                      onPressed: addAccount,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addAccount() async {
    final accountsProv = ref.read(accountsProvider.notifier);

    // Create the account
    accountsProv
        .createWatcher(address, networkURL, accountName)
        .then((account) {
      ref.read(selectedAccountProvider.notifier).state = account;
      Navigator.pushNamedAndRemoveUntil(context, "/wallet", (_) => false);
    });
  }
}
