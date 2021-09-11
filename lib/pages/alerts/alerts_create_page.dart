import 'package:flutter/material.dart';

class AlertsCreatePage extends StatefulWidget {
  AlertsCreatePage({Key key}) : super(key: key);

  @override
  AlertsCreatePageState createState() => AlertsCreatePageState();
}

class AlertsCreatePageState extends State<AlertsCreatePage> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Column(children: [
          Text("When symbol:"),
          Row(children: [
            // OutlinedButton(child: Text("BTC", style: Theme.of(context).textTheme.headline1), onPressed: () => null),
            // OutlinedButton(child: Text("BTC", style: Theme.of(context).textTheme.headline2), onPressed: () => null),
            // OutlinedButton(child: Text("BTC", style: Theme.of(context).textTheme.headline3), onPressed: () => null),
            // OutlinedButton(child: Text("BTC", style: Theme.of(context).textTheme.headline4), onPressed: () => null),
            // OutlinedButton(child: Text("BTC", style: Theme.of(context).textTheme.headline5), onPressed: () => null),
            // OutlinedButton(child: Text("BTC", style: Theme.of(context).textTheme.headline6), onPressed: () => null),
            // OutlinedButton(child: Text("BTC", style: Theme.of(context).textTheme.subtitle1), onPressed: () => null),
            // OutlinedButton(child: Text("BTC", style: Theme.of(context).textTheme.subtitle2), onPressed: () => null),
            // OutlinedButton(child: Text("BTC", style: Theme.of(context).textTheme.bodyText1), onPressed: () => null),
            // OutlinedButton(child: Text("BTC", style: Theme.of(context).textTheme.bodyText2), onPressed: () => null),
            // OutlinedButton(child: Text("BTC", style: Theme.of(context).textTheme.caption), onPressed: () => null),
            // OutlinedButton(child: Text("BTC", style: Theme.of(context).textTheme.button), onPressed: () => null),
            // OutlinedButton(child: Text("BTC", style: Theme.of(context).textTheme.overline), onPressed: () => null),

            ///
            OutlinedButton(child: Text("BTC", style: Theme.of(context).textTheme.headline5), onPressed: () => null),
            OutlinedButton(child: Text("ETH", style: Theme.of(context).textTheme.headline5), onPressed: () => null),
            OutlinedButton(child: Text("XRP", style: Theme.of(context).textTheme.headline5), onPressed: () => null),
            OutlinedButton(
              child: Icon(Icons.search),
              style: ButtonStyle(
                textStyle: MaterialStateProperty.resolveWith<TextStyle>((states) => Theme.of(context).textTheme.headline1),
              ),
              onPressed: () => null,
            ),
          ]),
          Text("BTC"),
        ]),
        Column(children: [
          Text("Reaches:"),
          TextField(),
          Row(children: [
            Text("Current price:"),
            Text("\$ 40,000.00"),

            ///
            OutlinedButton(
              onPressed: () => null,
              child: Text("-10%"),
            ),
            OutlinedButton(
              onPressed: () => null,
              child: Text("-1%"),
            ),
            OutlinedButton(
              onPressed: () => null,
              child: Text("0%"),
            ),
            OutlinedButton(
              onPressed: () => null,
              child: Text("+1%"),
            ),
            OutlinedButton(
              onPressed: () => null,
              child: Text("+10%"),
            ),
          ]),
        ]),
        Row(
          children: [
            ElevatedButton(child: Text("CANCEL"), onPressed: () => null),
            ElevatedButton(child: Text("OK"), onPressed: () => null),
          ],
        )
      ],
    );
  }
}
