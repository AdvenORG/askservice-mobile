import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app.dart';
import 'data/source_storage/local/share_preference_data_storage.dart';
import 'dev/logger.dart';
import 'di.dart';
import 'utils/env_keys.dart';

Future createApp() async {
  await EnvironmentLoader.load(dotenv);
  final shareRefs = await SharedPreferences.getInstance();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  return ProviderScope(
    overrides: [
      dataStorageProvider.overrideWith(
        (ref) => ShareReferenceDataStorage(prefs: shareRefs),
      ),
    ],
    observers: [
      CustomObserver(),
    ],
    child: const App(),
  );
}

class CustomObserver extends ProviderObserver {
  @override
  void didAddProvider(
      ProviderBase provider, Object? value, ProviderContainer container) {
    logger.d(
        'provider: ${provider.name ?? provider.runtimeType} was created.\nvalue: $value');
  }

  @override
  void didUpdateProvider(ProviderBase<Object?> provider, Object? previousValue,
      Object? newValue, ProviderContainer container) {
    logger.d(
        'provider: ${provider.name ?? provider.runtimeType} was updated.\nvalue: $newValue');
  }

  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
    logger
        .d('provider: ${provider.name ?? provider.runtimeType} was disposed.');
  }
}
