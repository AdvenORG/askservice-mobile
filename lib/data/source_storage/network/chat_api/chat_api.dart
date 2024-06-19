import 'dart:convert';

import 'package:app_chat_proxy/dev/logger.dart';
import 'package:app_chat_proxy/domain/entities/conversation_message.dart';
import 'package:dio/dio.dart';

import '../../../../core/common/result.dart';
import '../../../../core/network/http_method.dart';
import '../../../../core/network/sender.dart';
import '../../../../domain/entities/conversation.dart';
import '../../../../domain/entities/conversation_role.dart';

abstract class ChatApi {
  Future<Result<Object, List<Conversation>>> getUserConversations();

  Future<Result<Object, List<ConversationMessage>>> getConversationMessages(
      {required int conversationId});

  Future<Result<Object, Stream<String>>> getMessageResponse(
      {required int conversationId, required String content});

  Future<Result<Object, Conversation>> createNewConversation();
}

Conversation conversationParser(dynamic json) {
  return Conversation(id: json['id'], title: json['title']);
}

ConversationRole conversationRoleParse(int json) {
  if (json == 0) {
    return ConversationRole.hu;
  }
  return ConversationRole.ai;
}

List<ConversationMessage> conversationMessagesParser(List json) {
  try {
    return json.map((e) {
      logger.w(e);
      return ConversationMessage(
        sender: conversationRoleParse(e["sender"] as int),
        id: e["id"],
        conversationId: e["conversation_id"],
        createdAt: DateTime.parse(e["created_at"]),
        content: StringBuffer(
          e["content"],
        ),
      );
    }).toList();
  } catch (e) {
    logger.e(e);
    return [];
  }
}

Stream<String> botMessageStreamParser(ResponseBody responseBody) {
  return utf8.decoder.bind(responseBody.stream);
}

class ChatApiImp implements ChatApi {
  final Sender _sender;

  ChatApiImp({required Sender sender}) : _sender = sender;

  @override
  Future<Result<Object, List<Conversation>>> getUserConversations() async {
    final rs =
        await _sender.sendApiRequest<Object, List<Conversation>, dynamic>(
      method: HttpMethod.get,
      dataParser: (json) =>
          commonListParser(items: json, parser: conversationParser),
      pathParameter: "/conversation",
    );
    return rs;
  }

  @override
  Future<Result<Object, List<ConversationMessage>>> getConversationMessages(
      {required int conversationId}) async {
    final rs = await _sender
        .sendApiRequest<Object, List<ConversationMessage>, dynamic>(
      method: HttpMethod.get,
      dataParser: (json) => conversationMessagesParser(json),
      pathParameter: "/conversation/$conversationId",
    );
    return rs;
  }

  @override
  Future<Result<Object, Stream<String>>> getMessageResponse(
      {required int conversationId, required String content}) async {
    final rs =
        await _sender.sendApiRequest<Object, Stream<String>, ResponseBody>(
            method: HttpMethod.get,
            dataParser: (responseBody) => botMessageStreamParser(responseBody),
            headers: {"accept": "text/event-stream"},
            responseType: ResponseType.stream,
            queryParameters: {
              "conversation_id": conversationId,
              "message": content
            });
    return rs;
  }

  @override
  Future<Result<Object, Conversation>> createNewConversation() async {
    final rs = await _sender.sendApiRequest(
      method: HttpMethod.post,
      pathParameter: "/conversation",
      dataParser: conversationParser,
    );
    return rs;
  }
}
