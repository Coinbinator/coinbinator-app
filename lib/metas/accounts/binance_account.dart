import 'package:le_crypto_alerts/metas/account_types.dart';
import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/metas/exchange.dart';

class BinanceAccount extends AbstractExchangeAccount {
  String apiKey;

  String apiSecret;

  BinanceAccount() : super(type: AccountTypes.BINANCE);

  @override
  Exchange getExchange() => Exchanges.Binance;
}
