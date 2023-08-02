import '../../resource.dart';
import '../models/chat_message_response.dart';
import '../repo/chatbot_repo.dart';

class SendMessageUsecase {
  final ChatbotRepo _chatbotRepo;

  SendMessageUsecase(this._chatbotRepo);

  Future<Resource<ChatMessage>> invoke(String message) {
    return _chatbotRepo.sendMessage(message);
  }
}
