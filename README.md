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

Import `package:mercury_aichat_sdk/mercury_aichat_sdk.dart`

You can see a full example for using `ChatbotController` in the process of creation/injection (`mercury-aichat-sdk/example/lib/chatbot/chatbot_binding.dart`) or in its usage for the View (`mercury-aichat-sdk/example/lib/chatbot/chatbot_view.dart`).

Example of injection (using GetX-Bindings)

```dart
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:mercury_aichat_sdk/mercury_aichat_sdk.dart';
import '../core/dio_client.dart';

class ChatbotBinding extends Bindings {
  @override
  void dependencies() {
    /// In the chatbot package, the DataSource, Repo, UseCase, and Controller are created separately with a dependency chain (Controller -> UseCase -> Repo -> DataSource).
    /// Dependency injection can be done here. And the Base URL and ChatBotId can also be set here
    Get.lazyPut<ChatbotRepo>(
      () => ChatbotRepo(
        dioClient: DioClient(
            options: BaseOptions(
          baseUrl: 'https://staging-mercury-api-bwjdcapn3a-as.a.run.app',
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 30),
        )),
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

Example of chatbot-view (using GetView)

```dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mercury_aichat_sdk/mercury_aichat_sdk.dart';

class ChatbotView extends GetView<ChatbotController> {
  const ChatbotView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
					/// Showing List of chats
					Expanded(
            child: GetBuilder(
              builder: (ChatbotController controller) {
               	if (controller.error.isNotEmpty) {
									/// Error Widget
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Text(
                        controller.error,
                      ),
                    ),
                  );
                }

                return NotificationListener(
                  child: ListView.separated(
                    /// Use reverse: true because the latest chat is the very first chat item in the list
                    reverse: true,

                    /// The methods in the ChatBotController are adapted for a reversed ListView.
                    padding: const EdgeInsets.all(24.0),
                    itemCount: controller.data.length,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    separatorBuilder: (context, i) =>
                        const SizedBox(height: 16.0),
                    itemBuilder: (context, i) => ChatItem(
                      controller.data[i],
                      i,
                    ),
                    controller: controller.scrollController,
                  ),
                  onNotification: (ScrollUpdateNotification scrollInfo) {
                    if (scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {}
                    return true;
                  },
                );
              },
            ),
          ),
					/// Indicator that bot is processing the user chat
          GetBuilder(
            builder: (ChatbotController controller) {
              return AnimatedSize(
                duration: const Duration(milliseconds: 300),
                child: controller.botThinking
                    ? const Padding(
                        padding: EdgeInsets.only(
                          left: 24.0,
                          top: 12.0,
                          bottom: 4.0,
                        ),
                        child: Text('. . .'),
                      )
                    : Container(),
              );
            },
          ),
          const SizedBox(height: 8.0),
					/// User input Text Box
          Padding(
            padding: const EdgeInsets.only(
              bottom: 24.0,
              left: 24.0,
              right: 24.0,
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controller.textController,
                    maxLines: null,
                  ),
                ),
                const SizedBox(width: 16.0),
                InkWell(
                  onTap: () => controller.sendChat(),
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.rotationZ(-0.5),
                    child: const CircleAvatar(
                      radius: 18.0,
                      child: Icon(
                        Icons.send,
                        size: 24,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
				],
			),
		);
	}
}

class ChatItem extends StatelessWidget {
  final ChatMessage data;
  final int index;
  const ChatItem(this.data, this.index, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
		/// Role name for user is "user" and role name for the bot is "assistant"
    bool me = data.role == Role.user;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomRight: Radius.circular(me ? 0 : 12),
            bottomLeft: Radius.circular(me ? 12 : 0)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      margin: EdgeInsets.only(
        left: me ? 54.0 : 0.0,
        right: me ? 0.0 : 54.0,
      ),
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          /// The ChatItemView should be wrapped with GetBuilder(id: chatMessage.id) to display it gradually.
          GetBuilder(
            id: data.id,
            builder: (ChatbotController controller) {
              return Text(
                controller.data[index].content,
              );
            },
          ),
        ],
      ),
    );
  }
}
```
