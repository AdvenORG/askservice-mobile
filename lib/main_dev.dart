import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'create_app.dart';
import 'core/common/environment.dart';

void main() async {
  currentEnvironment = Environment.dev;
  await dotenv.load(fileName: ".env.local");
  final app = await createApp();
  runApp(app);
}
