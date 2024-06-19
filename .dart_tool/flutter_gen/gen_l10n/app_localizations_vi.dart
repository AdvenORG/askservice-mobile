import 'app_localizations.dart';

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get helloWorld => 'Xin chào';

  @override
  String get welcomeOnBoard => 'Chào mừng bạn đến với chúng tôi!';

  @override
  String get signIn => 'Bắt đầu trải nghiệm ngay.';

  @override
  String get defaultLanguage => 'Ngôn ngữ mặc định';

  @override
  String get switchThemeMode => 'Đổi chế độ sáng';
}
