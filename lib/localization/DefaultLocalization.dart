import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalization {
  String watches = "Watches";

  String alerts = "Alerts";

  String portifolio = "Portifolio";

  static AppLocalization of(BuildContext context) {
    // assert(debugCheckHasMaterialLocalizations(context));
    return Localizations.of<AppLocalization>(context, AppLocalization);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<AppLocalization> load(Locale locale) {
    return SynchronousFuture(AppLocalization());
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) =>
      false;
}
