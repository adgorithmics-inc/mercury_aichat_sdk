import 'package:dio/io.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mercury_aichat_sdk/src/chatbot/data_source/chat_local_data_source.dart';
import 'package:mercury_aichat_sdk/src/chatbot/repo/chatbot_repo.dart';
import 'package:mercury_aichat_sdk/src/chatbot/usecases/create_conversation_usecase.dart';
import 'package:mercury_aichat_sdk/src/chatbot/usecases/get_messages_usecase.dart';
import 'package:mercury_aichat_sdk/src/chatbot/usecases/send_message_usecase.dart';
import 'package:mockito/annotations.dart';

// command
// dart run build_runner build

@GenerateMocks([
  DioForNative,
  ChatbotRepo,
  ChatLocalDataSource,
  CreateConversationUsecase,
  GetMessagesUsecase,
  SendMessageUsecase,
  FlutterSecureStorage,
])
void main() {}
