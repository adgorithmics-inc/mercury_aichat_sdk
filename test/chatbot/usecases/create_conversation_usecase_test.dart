import 'package:flutter_test/flutter_test.dart';
import 'package:mercury_aichat_sdk/src/chatbot/usecases/create_conversation_usecase.dart';
import 'package:mercury_aichat_sdk/src/resource.dart';
import 'package:mockito/mockito.dart';

import '../../helper/test_helper.mocks.dart';

void main() {
  group('Create conversation use case', () {
    late MockChatbotRepo chatbotRepo;
    late CreateConversationUsecase createConversationUsecase;

    String conversationId = 'testConversationId';

    setUp(() {
      chatbotRepo = MockChatbotRepo();
      createConversationUsecase = CreateConversationUsecase(chatbotRepo);
    });

    test('Empty conversation id, failed get messages', () async {
      when(chatbotRepo.getSavedConversationId()).thenAnswer(
        (realInvocation) async {
          return null;
        },
      );

      when(chatbotRepo.saveConversationId(conversationId)).thenAnswer(
        (realInvocation) async {
          return Future.value();
        },
      );

      String mockedErrorMessage = 'Error error';

      when(chatbotRepo.createConversation()).thenAnswer((realInvocation) =>
          Future.value(mockedErrorMessage.toResourceFailure()));

      final result = await createConversationUsecase.invoke();
      String? error = result.getErrorOrNull();
      expect(error, isA<String>());
      expect(error, mockedErrorMessage);
    });
  });
}
