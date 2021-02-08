import 'package:flutter/material.dart';

class PortfoliosPage extends StatefulWidget {
  // PortfoliosPage({Key key}) : super(key: key);

  @override
  PortfoliosPageState createState() => PortfoliosPageState();
}

class PortfoliosPageState extends State<PortfoliosPage> {
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
                leading: Center(child: Icon(Icons.account_balance_wallet), widthFactor: 1),
                title: Text('Main'),
                subtitle: Text("Binance"),
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.push(context, MaterialPageRoute(builder: (context) => PortfoliosPage()));
                },
                // trailing: Icon(Icons.keyboard_arrow_right),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(onPressed: () => null, child: Text("Add Account")),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
