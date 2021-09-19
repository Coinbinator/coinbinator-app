import 'package:flutter/material.dart';
import 'package:le_crypto_alerts/support/utils.dart';

class PortfolioModel extends ChangeNotifier {
  Set<dynamic> workingWorkers = {};

  bool get isWorking => workingWorkers.isNotEmpty;

  addWorkingWorker(dynamic worker) async {
    workingWorkers.add(worker);
    try {
      notifyListeners();
    } catch (e) {}
  }

  void removeWorkingWorker(dynamic worker) {
    workingWorkers.remove(worker);
    notifyListeners();
  }

  Future<void> busyAwait(Future<dynamic> Function() task) async {
    addWorkingWorker(task);
    await value(task);
    removeWorkingWorker(task);
  }

  BudyToken busyToken({
    final String messagee = null,
  }) {
    final token = BudyToken(this, message: messagee);
    addWorkingWorker(token);
    return token;
  }
}
