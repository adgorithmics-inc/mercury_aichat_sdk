import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mercury_aichat_sdk_example/routest.dart';

import 'chatbot/chatbot_binding.dart';
import 'chatbot/chatbot_view.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mercury AI-Chat SDK Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      getPages: [
        GetPage(
          name: Routes.chatbot,
          page: () => const ChatbotView(),
          binding: ChatbotBinding(),
        ),
      ],
    );
  }
}
