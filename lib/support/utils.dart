// part "utils.g.dart.bkp";

import 'package:le_crypto_alerts/pages/portfolio/portfolio_model.dart';

T value<T>(Function() func) {
  return func() as T;
}

class BudyToken {
  //TODO: criar uma interface para o parent e release
  final PortfolioModel parent;

  final String message;

  BudyToken(final this.parent, {this.message});

  release() {
    parent.removeWorkingWorker(this);
  }
}
