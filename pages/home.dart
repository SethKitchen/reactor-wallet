import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sethkitchen/wallet/components/size_wrapper.dart';
import 'package:sethkitchen/wallet/dialogs/insufficient_funds.dart';
import 'package:sethkitchen/wallet/dialogs/select_account.dart';
import 'package:sethkitchen/wallet/dialogs/make_transaction_manually.dart';
import 'package:sethkitchen/wallet/utils/base_account.dart';
import 'package:sethkitchen/wallet/utils/solana_pay.dart';
import 'package:sethkitchen/wallet/utils/wallet_account.dart';
import 'home/account.dart';
import 'home/settings.dart';
import 'package:uni_links/uni_links.dart';

/*
 * Home Page
 */
class WalletHomePage extends HookConsumerWidget {
  final String name;
  final String path;

  const WalletHomePage({required key, required this.name, required this.path})
      : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Widget page;

    final currentPage = useState(3);

    switch (currentPage.value) {
      case 3:
        page = const SettingsSubPage();
        break;

      case 2:
        page = const AccountSubPage("/collectibles");
        break;

      case 1:
        page = const AccountSubPage("/transactions");
        break;

      default:
        page = const AccountSubPage("/wallet");
    }

    useEffect(() {
      getInitialLink().catchError((_) {
        return null;
      }).then(
        (String? uri) {
          if (uri != null) {
            final transaction = TransactionSolanaPay.parseUri(uri);

            WidgetsBinding.instance?.addPostFrameCallback(
              (_) async {
                final account = await selectAccount(context);
                if (account is WalletAccount) {
                  String defaultTokenSymbol = "SOL";

                  if (transaction.splToken != null) {
                    try {
                      Token selectedToken =
                          account.getTokenByMint(transaction.splToken!);
                      defaultTokenSymbol = selectedToken.info.symbol;
                    } catch (_) {
                      insuficientFundsDialog(context);
                      return;
                    }
                  }

                  makePaymentManuallyDialog(
                    context,
                    account,
                    initialDestination: transaction.recipient,
                    initialSendAmount: transaction.amount ?? 0,
                    defaultTokenSymbol: defaultTokenSymbol,
                  );
                }
              },
            );
          }
        },
      );
    }, []);

    return Scaffold(
      body: page,
      bottomNavigationBar: ResponsiveSizer(
        child: BottomNavigationBar(
          onTap: (int page) {
            currentPage.value = page;
          },
          elevation: 0,
          /*showUnselectedLabels:
              Platform.isWindows | Platform.isMacOS | Platform.isLinux,*/
          currentIndex: currentPage.value,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.account_balance_wallet),
              icon: Icon(Icons.account_balance_wallet_outlined),
              label: 'Account',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.timeline),
              icon: Icon(Icons.timeline),
              label: 'Payments',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.art_track_outlined),
              icon: Icon(Icons.art_track_outlined),
              label: 'Collectibles',
            ),
            BottomNavigationBarItem(
              activeIcon: Icon(Icons.settings),
              icon: Icon(Icons.settings_outlined),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}
