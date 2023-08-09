import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:mercury_aichat_sdk/src/core/dio_exception_extension.dart';

import '../../resource.dart';
import '../data_source/chat_local_data_source.dart';
import '../models/chat_message_response.dart';
import '../models/chatbot_model.dart';

class ChatbotRepo {
  final DioForNative _dioClient;
  final String _chatBotId;
  final ChatLocalDataSource dataSource;

  ChatbotRepo({
    required DioForNative dioClient,
    required String chatBotId,
    required this.dataSource,
  })  : _chatBotId = chatBotId,
        _dioClient = dioClient;

  final String sendChatUrl = '/api/v1/public-chat/chat/';
  final String messagesUrl = '/api/v1/public-chat/';

  final String noConversation = 'Conversation is not initiated yet';

  /// Returned response is chat from AI to reply your sent message
  /// The [sendMessage] method can only be executed after the [createConversation] method is successfully performed, ensuring that the [conversationId] is not null.
  Future<Resource<ChatMessage>> sendMessage(String prompt) async {
    String? conversationId = await getSavedConversationId();

    if (conversationId == null) {
      return noConversation.toResourceFailure();
    }

    try {
      final response = await _dioClient.post(
        sendChatUrl,
        data: jsonEncode({
          'chatbot': _chatBotId,
          'conversation': conversationId,
          'prompt': prompt.trim(),
        }),
      );
      ChatMessage data = ChatMessage.fromJson(response.data);
      return data.toResourceSuccess();
    } on DioException catch (e) {
      /// API Error
      return e.errorMessage.toResourceFailure();
    } catch (e) {
      /// Model parsing error because API changed without notice.
      return e.toString().toResourceFailure();
    }
  }

  /// Get message history in single [conversationId]
  /// The [getMessages] method can only be executed after the [createConversation] method is successfully performed, ensuring that the [conversationId] is not null.
  Future<Resource<ChatMessageResponse>> getMessages() async {
    String? conversationId = await getSavedConversationId();

    if (conversationId == null) {
      return noConversation.toResourceFailure();
    }
    try {
      final response = await _dioClient.get(
        messagesUrl,
        queryParameters: {
          'chatbot': _chatBotId,
          'conversation': conversationId,
        },
      );
      ChatMessageResponse data = ChatMessageResponse.fromJson(response.data);
      return data.toResourceSuccess();
    } on DioException catch (e) {
      return e.errorMessage.toResourceFailure();
    } catch (e) {
      return e.toString().toResourceFailure();
    }
  }

  /// initialize new conversation with chatbot
  Future<Resource<ChatbotModel>> createConversation() async {
    try {
      final response = await _dioClient.post(
        messagesUrl,
        data: jsonEncode({
          'chatbot': _chatBotId,
        }),
      );
      ChatbotModel data = ChatbotModel.fromJson(response.data);
      saveConversationId(data.id!);
      return data.toResourceSuccess();
    } on DioException catch (e) {
      return e.errorMessage.toResourceFailure();
    } catch (e) {
      return e.toString().toResourceFailure();
    }
  }

  Future<String?> getSavedConversationId() async {
    return await dataSource.getConversationId();
  }

  Future<void> saveConversationId(String id) async {
    return await dataSource.setConversationId(id);
  }
}
