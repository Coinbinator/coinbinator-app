import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/accounts/accounts.dart';

class ManageAccountsPage extends StatefulWidget {
  // PortfoliosPage({Key key}) : super(key: key);

  @override
  ManageAccountsPageState createState() => ManageAccountsPageState();
}

class ManageAccountsPageState extends State<ManageAccountsPage> {
  List<Account> accounts;

  Future<void> loadAccounts() async {
    final _accounts = await app().getAccounts();

    setState(() {
      accounts = _accounts;
    });
  }

  @override
  void initState() {
    super.initState();
    loadAccounts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Accounts"),
      ),
      body: ListView(
        children: [
          if (accounts != null)
            for (final account in accounts)
              ListTile(
                leading: Center(child: Icon(Icons.account_balance_wallet), widthFactor: 1),
                title: Text(account.name),
                subtitle: Text(account.type),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ManageAccountsPage()));
                },
                // trailing: Icon(Icons.keyboard_arrow_right),
              ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: RaisedButton(onPressed: () => null, child: Text("Add Account")),
          ),
        ],
      ),
    );
  }
}
