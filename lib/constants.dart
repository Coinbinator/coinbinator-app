import 'package:flutter/material.dart';

const String TEST_BINANCE_API_KEY = 'TEST_BINANCE_API_KEY';
const String TEST_BINANCE_API_SECRET = 'TEST_BINANCE_API_SECRET';

const String TEST_MERCADO_BITCOIN_TAPI_ID = 'TEST_MERCADO_BITCOIN_TAPI_ID';
const String TEST_MERCADO_BITCOIN_TAPI_SECRET = 'TEST_MERCADO_BITCOIN_TAPI_SECRET';

/// INITIAL APP ROUTE
const String ROUTE_ROOT = '/';

/// WATCHING PAGE ROUTE
const String ROUTE_WATCHING = '/';

///
const String ROUTE_PORTFOLIO = '/portfolio';

///
const String ROUTE_PORTFOLIO_DETAILS = '/portfolio/details';

///
const String ROUTE_ALERTS = '/alerts';

///
const String ROUTE_ALERTS_CREATE = '/alerts/new';

///
const String ROUTE_ALERTS_EDIT = '/root/alerts/edit';

///
const String ROUTE_SETTINGS = '/settings';

///
const String ROUTE_SETTINGS_MANAGE_ACCOUNTS = '/settings/accounts';

const int ALARM_ID_DEFAULT = 0;
const int ALARM_ID_ALERT_ACTIVE = 1;
const int ALARM_MIN_USER_ALARMS = 1000;

// ignore: non_constant_identifier_names
final MAIN_APP_WIDGET = GlobalKey<State<MaterialApp>>();

// ignore: non_constant_identifier_names
final MAIN_NAVIGATOR_KEY = GlobalKey<NavigatorState>();

/// The market direction (bullish) rising, (bearish) dipping
///
/// References:
/// https://www.investopedia.com/insights/digging-deeper-bull-and-bear-markets/
enum MarketDirection {
  bullish,
  bearish,
}
