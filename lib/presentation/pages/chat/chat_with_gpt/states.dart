import 'package:app_chat_proxy/domain/entities/conversation_message.dart';

abstract class AskScreenState {
  const AskScreenState();
}

class InitState extends AskScreenState {
  const InitState();
}

class InConversationState extends AskScreenState {
  final List<ConversationMessage> messages;
  const InConversationState({required this.messages});
}

class ErrorState extends AskScreenState {
  final Exception? error;
  ErrorState([this.error]);
}
