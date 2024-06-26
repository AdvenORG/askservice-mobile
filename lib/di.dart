import 'dart:ui';

import 'package:app_chat_proxy/data/repositories/user_repository/user_repository_imp.dart';
import 'package:app_chat_proxy/dev/logger.dart';
import 'package:app_chat_proxy/domain/entities/user_references.dart';
import 'package:app_chat_proxy/domain/repositories/user_repository/user_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/source_storage/local/data_storage.dart';


final userReferenceRepositoryProvider = Provider<UserRepository>((ref) {
  return UserRepositoryImp(
    userReferenceDataStorage: ref.watch(dataStorageProvider),
  );
});


final Provider<DataStorage> dataStorageProvider = Provider((ref) {
  throw UnimplementedError();
});

final userReferencesNotifierProvider =
    NotifierProvider<UserReferencesNotifier, UserReferences>(
        UserReferencesNotifier.new);

class UserReferencesNotifier extends Notifier<UserReferences> {
  @override
  UserReferences build() {
    final locale = ref.watch(userReferenceRepositoryProvider).getUserLocale() ??
        AppLocalizations.supportedLocales.first;
    final isDarkMode = ref.watch(userReferenceRepositoryProvider).isDarkMode();
    return UserReferences(isDarkMode: isDarkMode, locale: locale);
  }

  void setUserReferMode(bool value) async {
    bool rs =
        await ref.read(userReferenceRepositoryProvider).setUserReferMode(value);
    if (rs) {
      state = UserReferences(locale: state.locale, isDarkMode: value);
    }
  }

  void setLocale(Locale locale) async {
    bool rs = await ref
        .read(userReferenceRepositoryProvider)
        .setUserReferLocale(locale);
    logger.w("setLocale: $rs");
    if (rs) {
      state = UserReferences(locale: locale, isDarkMode: state.isDarkMode);
    }
  }
}
