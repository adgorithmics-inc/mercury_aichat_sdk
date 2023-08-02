import '../../resource.dart';
import '../models/chat_message_response.dart';
import '../repo/chatbot_repo.dart';

class CreateConversationUsecase {
  final ChatbotRepo _chatbotRepo;

  CreateConversationUsecase(this._chatbotRepo);

  /// It returns a list of messages and also sets the [conversationId] if it doesn't exist yet.
  Future<Resource<ChatMessageResponse>> invoke() async {
    String? conversationId = await _chatbotRepo.getSavedConversationId();
    if (conversationId == null) {
      final result = await _chatbotRepo.createConversation();
      String? error = result.getErrorOrNull();
      if (error != null) return error.toResourceFailure();
    }

    return _chatbotRepo.getMessages();
  }
}
