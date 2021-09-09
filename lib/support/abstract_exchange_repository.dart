import 'package:le_crypto_alerts/metas/accounts/abstract_exchange_account.dart';
import 'package:le_crypto_alerts/metas/portfolio_account_resume.dart';

abstract class AbstractExchangeRepository<A extends AbstractExchangeAccount> {
  Future<PortfolioAccountResume> getAccountPortfolioResume({A account});
}
