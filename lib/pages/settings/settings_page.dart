import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/pages/settings/portfolios_page.dart';

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
        // drawer: DefaultDrawer(),
        body: GestureDetector(
          child: ListView(
            children: [
              ListTile(
                leading: Icon(Icons.account_balance_wallet),
                title: Text('Portfolios'),
                subtitle: Text("Manage portfolio accounts"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PortfoliosPage()));
                },
                // trailing: Icon(Icons.keyboard_arrow_right),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
