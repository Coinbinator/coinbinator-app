import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/repositories/app/app_repository.dart';
import 'package:le_crypto_alerts/support/colors.dart';
import 'package:le_crypto_alerts/support/pairs.dart';
import 'package:le_crypto_alerts/support/utils.dart';
import 'package:provider/provider.dart';

class _AddWatchDialogModel extends ChangeNotifier {
  bool initialized = false;

  final searchDebouncer = Debouncer();

  final searchController = TextEditingController();

  List<Exchange> exchanges = [];

  List<Pair> pairs = [];

  List<Pair> get filteredParis => pairs.where((element) {
        final query = searchController.text.toUpperCase().trim();

        if (query.length == 0) return true;
        if ("${element.base}".indexOf(query) > -1) return true;
        if ("${element.quote}".indexOf(query) > -1) return true;
        if ("${element.base}${element.quote}".indexOf(query) > -1) return true;
        if ("${element.base}/${element.quote}".indexOf(query) > -1) return true;
        if ("${element.base}:${element.quote}".indexOf(query) > -1) return true;

        return false;
      })
      .toList();

  Future<void> init() async {
    if (initialized) return;

    searchController.addListener(() => searchDebouncer(() => notifyListeners()));

    exchanges = (await app().getAccounts()).map((account) => account.getExchange()).toSet().toList();

    pairs = Pairs.getAll().toSet().toList();

    initialized = true;
  }

  @override
  void dispose() {
    searchDebouncer.dispose();
    searchController.dispose();
    super.dispose();
  }
}

class AddWatchModal extends PopupRoute {
  @override
  Color get barrierColor => LeColors.grey.shade100;

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => null;

  @override
  bool get maintainState => false;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<_AddWatchDialogModel>(create: (context) {
          return _AddWatchDialogModel()..init();
        }),
      ],
      builder: (context, child) {
        final model = Provider.of<_AddWatchDialogModel>(context);

        return SafeArea(
          child: Material(
            color: LeColors.primary,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                decoration: BoxDecoration(
                  color: LeColors.white.shade200,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                height: MediaQuery.of(context).size.height - 40,
                width: MediaQuery.of(context).size.width - 12,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),

                      /// TOP SEARCH
                      child: Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: model.searchController,
                              decoration: InputDecoration(
                                icon: Icon(Icons.search),
                                labelText: 'Search Pair',
                                contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              ),
                            ),
                          ),
                          OutlineButton(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.0),
                            ),
                            child: Text("cancel"),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ],
                      ),
                    ),

                    /// Result LIST
                    Expanded(
                      child: ListView(
                        children: [
                          for (final i in model.filteredParis)
                            ListTile(
                              title: Text("${i.base}/${i.quote}"),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
