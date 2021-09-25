import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/constants.dart';
import 'package:le_crypto_alerts/pages/le_app_models.dart';
import 'package:le_crypto_alerts/pages/settings/settings_page.dart';
import 'package:provider/provider.dart';

class DefaultDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        child: Column(
          children: <Widget>[
            // DrawerHeader(
            //   child: Center(
            //     child: Text(
            //       'Side menu  FlutterCorner',
            //       textAlign: TextAlign.center,
            //       style: TextStyle(color: Colors.white, fontSize: 25),
            //     ),
            //   ),
            //   decoration: BoxDecoration(
            //     color: Colors.black,
            //   ),
            // ),
            // ListTile(
            //   leading: Icon(Icons.home),
            //   title: Text('Home'),
            //   onTap: () => {},
            // ),
            // ListTile(
            //   leading: Icon(Icons.shopping_cart),
            //   title: Text('Cart'),
            //   onTap: () => {Navigator.of(context).pop()},
            // ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                Navigator.of(context).pop();
                Provider.of<LeAppModel>(MAIN_NAVIGATOR_KEY.currentContext, listen: false).shufflerColors();
                //
                // Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsPage()));
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.exit_to_app),
            //   title: Text('Logout'),
            //   onTap: () => {Navigator.of(context).pop()},
            // ),
          ],
        ),
      ),
    );
  }
}
