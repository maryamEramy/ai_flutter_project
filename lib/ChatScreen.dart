import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  askDeepSeek() async {
    final response = await post(
      Uri.parse("https://api.deepseek.com/chat/completions"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer sk-44a7da1ca5c649ba954d55e9ddce0ad6',
      },
      body: jsonEncode({
        "model": "deepseek-chat",
        "messages": [
          {"content": "You are a helpful assistant", "role": "system"},
          {"content": textEditingController.text, "role": "user"},
        ],
      }),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      results = jsonData['choices'][0]['message']['content'];
      setState(() {
        results;
      });
    }
    print(response.body);
  }

  TextEditingController textEditingController = TextEditingController();
  var results = 'results will shown here...';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(child: Center(child: Text(results),)),
          Expanded(child: TextField(controller: textEditingController)),
          IconButton(
            onPressed: () {
              askDeepSeek();
            },
            icon: Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
