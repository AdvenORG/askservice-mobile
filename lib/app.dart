import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'di.dart';
import 'notification_mixin.dart';
import 'presentation/common/providers/loading_manager_provider.dart';
import 'presentation/pages/login/authenticate_provider.dart';
import 'presentation/router/app_router.dart';
import 'presentation/router/di.dart';

class App extends HookConsumerWidget with NotificationMixin {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    late ThemeMode themeMode;
    final userReferences = ref.watch(userReferencesNotifierProvider);
    if (userReferences.isDarkMode == true) {
      themeMode = ThemeMode.dark;
    }
    if (userReferences.isDarkMode == false) {
      themeMode = ThemeMode.light;
    }
    if (userReferences.isDarkMode == null) {
      themeMode = ThemeMode.system;
    }

    return MaterialApp.router(
      routerConfig:
          ref.watch(appRouterProvider).config(deepLinkBuilder: (deepLink) {
        return DeepLink.defaultPath;
      }),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: themeMode,
      locale: userReferences.locale,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return KeyedSubtree(
          child: Consumer(
              child: child,
              builder: (context, ref, child) {
                FlutterNativeSplash.remove();
                ref.listen(authenticateNotifierProvider, (_, authStatus) {
                  if (authStatus == AuthStatus.unAuthenticate) {
                    ref
                        .read(appKeysProvider)
                        .navKey
                        .currentContext!
                        .router
                        .replaceAll([const LoginRoute()]);
                  } else {
                    ref
                        .read(appKeysProvider)
                        .navKey
                        .currentContext!
                        .router
                        .replaceAll([const HomeRoute()]);
                  }
                });
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    child ?? const SizedBox.shrink(),
                    Consumer(builder: (context, ref, child) {
                      LoadingStatus status =
                          ref.watch(loadingStatusNotifierProvider);
                      if (status == LoadingStatus.stable) {
                        return const SizedBox.shrink();
                      }
                      return DecoratedBox(
                        decoration:
                            BoxDecoration(color: Colors.grey.withOpacity(0.2)),
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    })
                  ],
                );
              }),
        );
      },
    );
  }
}
