import 'package:app_chat_proxy/dev/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'dart:convert';

class Token {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  Token({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  // Factory method to create a Token object from JSON
  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['access_token'],
      refreshToken: json['refresh_token'],
      expiresAt: DateTime.parse(json['expires_at']),
    );
  }

  // Method to convert a Token object to JSON
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'expires_at': expiresAt.toIso8601String(),
    };
  }
}

class AuthWebView extends HookConsumerWidget {
  const AuthWebView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controlNotifier = useState<WebViewController>(WebViewController());

    useEffect(
      () {
        final controller = controlNotifier.value;
        final navState = Navigator.of(context);
        controller.setJavaScriptMode(JavaScriptMode.unrestricted);
        controller.setBackgroundColor(const Color(0x00000000));

        controller.setNavigationDelegate(
          NavigationDelegate(
            onProgress: (int progress) {},
            onPageStarted: (String url) {},
            onPageFinished: (String url) async {
              final json = await controller.runJavaScriptReturningResult(
                  "document.documentElement.innerText");
              try {
                final result = Token.fromJson(jsonDecode(json as String));
                controller.clearCache();
                controller.clearLocalStorage();
                navState.pop(result);
              } catch (e) {

              }
            },
            onHttpError: (HttpResponseError error) {},
            onWebResourceError: (WebResourceError error) {},
            onNavigationRequest: (NavigationRequest request) {
              logger.w(request.url);

              // if (request.url.startsWith('https://www.youtube.com/')) {
              //   return NavigationDecision.prevent;
              // }
              return NavigationDecision.navigate;
            },
          ),
        );

        controller.addJavaScriptChannel(("authChannel"),
            onMessageReceived: (jsMessage) {
          logger.w(" ===> ${jsMessage.message}");
        });
        controller.loadRequest(
          Uri.parse('http://localhost:9090/accounts/login'),
        );

        return () {
          controller.clearCache();
        };
      },
      const [],
    );
    return Scaffold(
      body: WebViewWidget(
        controller: controlNotifier.value,
      ),
    );
  }
}
