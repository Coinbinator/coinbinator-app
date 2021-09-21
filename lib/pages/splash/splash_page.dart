
import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/pages/splash/splash_model.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Welcome..."),
              Text(context.watch<SplashModel>().initializetionMessage),
            ],
          ),
        ),
      ),
    );
  }
}
