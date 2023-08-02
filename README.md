A flutter plugin to facilitate the implementation of chatbot in applications.

A Flutter application that uses GetX can implement `GetXController` as State Management. The Mercury AI Chat SDK has provided a `GetXController` along with its UseCases, which has implemented simple state management for chatbot usage. This package also manages the conversationId, which is stored using `flutter_secure_storage`.

In the future, applications that require a chatbot can easily implement it using this package.

## Features

1. ChatBot StateManagement (ChatbotController) in the form of `GetxController`
2. ChatBot UseCase (CreateConversation, SendMessage, GetMessages)

## How to install

Add Get to your pubspec.yaml file:
```
dependencies:
	mercury_aichat_sdk:
```

There is no specific configuration for any platform.

## Usage

Import  `package:mercury_aichat_sdk/mercury_aichat_sdk.dart`

You can see a full example for using `ChatbotController` in the process of creation/injection (`mercury-aichat-sdk/example/lib/chatbot/chatbot_binding.dart`) or in its usage for the View (`mercury-aichat-sdk/example/lib/chatbot/chatbot_view.dart`).

Example of injection (using GetX-Bindings)

```dart
import 'package:get/get.dart';
import 'package:mercury_aichat_sdk/mercury_aichat_sdk.dart';
import 'package:http/http.dart';

class ChatbotBinding extends Bindings {
  @override
  void dependencies() {
    /// In the chatbot package, the DataSource, Repo, UseCase, and Controller are created separately with a dependency chain (Controller -> UseCase -> Repo -> DataSource).
    /// Dependency injection can be done here. And the Base URL and ChatBotId can also be set here
    Get.lazyPut<ChatbotRepo>(
      () => ChatbotRepo(
        client: Client(),
        baseUrl: 'staging-mercury-api-bwjdcapn3a-as.a.run.app',
        chatBotId: '9f1196141ce84950ad05ced4b6db4d9e',
        dataSource: ChatLocalDataSource(),
      ),
    );
    Get.lazyPut(() => CreateConversationUsecase(Get.find()));
    Get.lazyPut(() => GetMessagesUsecase(Get.find()));
    Get.lazyPut(() => SendMessageUsecase(Get.find()));

    Get.lazyPut<ChatbotController>(
      () => ChatbotController(
        conversationUsecase: Get.find(),
        getMessagesUsecase: Get.find(),
        sendMessageUsecase: Get.find(),
      ),
    );
  }
}
```