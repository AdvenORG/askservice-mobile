import 'app_localizations.dart';

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get helloWorld => 'Hello World!';

  @override
  String get welcomeOnBoard => 'Welcome to onboarding with us';

  @override
  String get signIn => 'Let\'s the journey start';

  @override
  String get defaultLanguage => 'Default Language';

  @override
  String get switchThemeMode => 'Switch theme mode';
}
