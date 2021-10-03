import 'dart:async';

import 'package:le_crypto_alerts/metas/ticker.dart';

///TODO: remover essa estrutura e utililizar o stremController
abstract class AbstractAppTickerListener {
  FutureOr<void> onTickers(List<Ticker> tickers);
}
