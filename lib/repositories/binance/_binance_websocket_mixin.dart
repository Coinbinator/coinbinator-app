part of 'binance_repository.dart';

const BINANCE_WEBSOCKET_ENDPOINT = 'wss://stream.binance.com:9443';

typedef NormalTickerListener = void Function(List<Ticker>);

mixin _BinanceWebSocket {
  Map<Pair, BinanceWsNormalTicker> _normalTickers = {};

  List<NormalTickerListener> _normalTickerListeners = [];

  IOWebSocketChannel _normalTickerChannel;

  StreamSubscription _normalTickerStreamSubscription;

  Timer _normalTickerFlushTimer;

  void listenToNormalTickers(NormalTickerListener onTickers) {
    _normalTickerListeners.add(onTickers);

    if (_normalTickerChannel == null) {
      _normalTickerChannel = IOWebSocketChannel.connect(Uri.parse('$BINANCE_WEBSOCKET_ENDPOINT/ws/!ticker@arr'));
      _normalTickerStreamSubscription = _normalTickerChannel.stream.listen(_normalTickerChannelOnData);

      _normalTickerFlushTimer = new Timer.periodic(Duration(seconds: 5), _normalTickerFlushData);
    }
  }

  void _normalTickerChannelOnData(event) {
    final tickersJson = json.decode(event);

    if (!(tickersJson is Iterable)) {
      event.toString();
      return;
    }

    for (final tickerJson in tickersJson as Iterable) {
      ///NOTE: tentando igno
      final pair = _tryConvertStringToPair(tickerJson['s'] as String);
      if (!(pair?.quote?.isUSD ?? false)) continue;

      final ticker = BinanceWsNormalTicker.fromJson(tickerJson);

      if (_normalTickers[pair] == null) {
        _normalTickers[pair] = ticker;
        continue;
      }

      _normalTickers[pair].closePrice = ticker.closePrice;
    }
  }

  void _normalTickerFlushData(Timer timer) {
    if (_normalTickers.isEmpty) return;

    for (final listener in _normalTickerListeners) listener(_normalTickers.values.toList());

    _normalTickers.clear();
  }
}
