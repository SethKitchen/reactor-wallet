import 'package:flutter/material.dart';
import 'package:sethkitchen/wallet/components/size_wrapper.dart';

/*
 * Account Selection Page
 */
class AccountSelectionPage extends StatelessWidget {
  final String name;
  final String path;

  const AccountSelectionPage(
      {required key, required this.name, required this.path})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Account selection"),
      ),
      body: ResponsiveSizer(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Flex(
              direction: Axis.vertical,
              children: [
                Expanded(
                  flex: 1,
                  child: Card(
                    child: InkWell(
                      splashColor: Theme.of(context).hoverColor,
                      onTap: () async {
                        Navigator.pushNamed(context, "/wallet/watch/address");
                      },
                      child: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Icon(
                              Icons.person_pin_outlined,
                              size: 30.0,
                            ),
                          ),
                          Text("Watch address"),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Card(
                    child: InkWell(
                      splashColor: Theme.of(context).hoverColor,
                      onTap: () async {
                        Navigator.pushNamed(context, "/wallet/import");
                      },
                      child: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Icon(
                              Icons.import_export_outlined,
                              size: 30.0,
                            ),
                          ),
                          Text("Import wallet"),
                        ],
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Card(
                    child: InkWell(
                      splashColor: Theme.of(context).hoverColor,
                      onTap: () async {
                        Navigator.pushNamed(context, "/wallet/create");
                      },
                      child: Flex(
                        direction: Axis.horizontal,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: const [
                          Padding(
                            padding: EdgeInsets.all(15),
                            child: Icon(
                              Icons.create_outlined,
                              size: 30.0,
                            ),
                          ),
                          Text("Create wallet"),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
