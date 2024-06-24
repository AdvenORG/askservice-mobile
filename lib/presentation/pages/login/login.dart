import 'package:app_chat_proxy/dev/logger.dart';
import 'package:app_chat_proxy/presentation/router/app_router.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_web_view.dart';

@RoutePage()
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.3, 0.6, 0.9],
                colors: [
                  Colors.black,
                  Colors.purple,
                  Colors.black,
                ],
              ),
            ),
          ),
          Column(
            children: [
              const Spacer(),
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
                child: ElevatedButton(
                  onPressed: () async {
                    final navState = Navigator.of(context);
                    final routeStack = context.router;
                    final token = await navState.push(
                      MaterialPageRoute(
                        builder: (context) => const AuthWebView(),
                      ),
                    );
                    if (token != null) {
                      logger.i("Login Success: ${token.toString()}");
                      routeStack.push(const HomeRoute());
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: SizedBox(
                      width: double.infinity,
                      child: Text(
                        'Login',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
