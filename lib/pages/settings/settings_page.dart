import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/pages/settings/manage_accounts_page.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
        ),
        body: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.account_balance_wallet),
              title: Text('Accounts'),
              subtitle: Text("Manage your accounts"),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ManageAccountsPage()));
              },
              // trailing: Icon(Icons.keyboard_arrow_right),
            ),
          ],
        ),
      ),
    );
  }
}
