import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:le_crypto_alerts/consts.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    app().routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  void dispose() {
    app().routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPush() {
    print("IM IN");
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushNamed(ROUTE_WATCHING);
    });
  }

  @override
  void didPopNext() {
    print('Im ALSO IN');
    SchedulerBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushNamed(ROUTE_WATCHING);
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //
  //   // SchedulerBinding.instance.addPostFrameCallback((_) {
  //   //   Navigator.of(context).pushNamed(ROUTE_WATCHING);
  //   // });
  //
  //   // Timer.run(() {
  //   //   Navigator.of(context).pushNamed(ROUTE_WATCHING);
  //   // });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Home"),
    );
  }
}
