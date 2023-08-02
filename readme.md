Sebuah flutter plugin untuk memudahkan implementasi chatbot pada aplikasi.

Aplikasi flutter yang menggunakan GetX dapat mengimplementasi `GetxController` sebagai StateManagement. Mercury AI Chat SDK telah menyediakan sebuah `GetxController` beserta UseCase-nya yang telah mengimplementasi state management sederhana untuk penggunaan chatbot. Package ini juga mengatur conversationId yang disimpan menggunakan `flutter_secure_storage`.

Kedepannya, aplikasi yang membutuhkan chatbot dapat mengimplementasi dengan mudah dengan menggunakan package ini.

## Features

1. ChatBot StateManagement (ChatbotController) dalam bentuk `GetxController`
2. ChatBot UseCase (CreateConversation, SendMessage, GetMessages)

## How to install

Add Get to your pubspec.yaml file:
```
dependencies:
	mercury_aichat_sdk:
```

Tidak ada konfigurasi spesifik untuk platform apapun.

## Usage

Import  `package:mercury_aichat_sdk/mercury_aichat_sdk.dart`

Kamu dapat melihat contoh selengkapnya untuk penggunaan `ChatbotController` dalam proses pembuatan/injection (`mercury-aichat-sdk/example/lib/chatbot/chatbot_binding.dart`) atau dalam penggunaan untuk View (`mercury-aichat-sdk/example/lib/chatbot/chatbot_view.dart`).

Contoh injection (menggunakan GetX-Bindings)

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