import 'package:app_chat_proxy/presentation/router/di.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';



extension AppLocalizationsExt on BuildContext {
  AppLocalizations appLocalizations(WidgetRef ref) =>
      AppLocalizations.of(this) ??
      AppLocalizations.of(ref.read(appKeysProvider).appKey.currentContext!)!;
}
