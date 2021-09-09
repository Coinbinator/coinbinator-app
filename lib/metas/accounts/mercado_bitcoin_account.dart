import 'package:le_crypto_alerts/metas/account_types.dart';
import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/metas/exchange.dart';

class MercadoBitcoinAccount extends AbstractExchangeAccount {
  String tapiId;

  String tapiSecret;

  MercadoBitcoinAccount() : super(type: AccountTypes.MERCADO_BITCOIN);

  @override
  Exchange getExchange() => Exchanges.MercadoBitcoin;
}
