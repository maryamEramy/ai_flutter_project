import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  List<Map<String , Object>> chatHistory = [
    {"content": "You are a helpful assistant", "role": "system"},
  ];
  askDeepSeek() async {
    var inputText = textEditingController.text;
    chatHistory.add({"role": "user", "content": inputText});
    messages.insert(0 , ChatMessage(user: user, createdAt: DateTime.now() , text: inputText));
    setState(() {
      messages;
    });
    
    textEditingController.clear();
    final response = await post(
      Uri.parse("https://api.deepseek.com/chat/completions"),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer sk-44a7da1ca5c649ba954d55e9ddce0ad6',
      },
      body: jsonEncode({
        "model": "deepseek-chat",
        "messages": chatHistory,
      }),
    );
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(utf8.decode(response.bodyBytes));
      results = jsonData['choices'][0]['message']['content'];
      chatHistory.add({"role": "assistant", "content": results});
      messages.insert(0 , ChatMessage(user: userDS, createdAt: DateTime.now() , text: results));
      setState(() {
        messages;
      });
    }
    messages.insert(0 , ChatMessage(user: userDS, createdAt: DateTime.now() , text: response.body));
    setState(() {
      messages;
    });
    print(response.body);
  }

  TextEditingController textEditingController = TextEditingController();
  var results = 'results will shown here...';

  ChatUser user = ChatUser(id: '1' , firstName: 'mar');
  ChatUser userDS = ChatUser(id: '2' , firstName: 'DeepSeek');
  List<ChatMessage> messages = <ChatMessage>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Expanded(child: DashChat(currentUser: user, onSend: (e){}, messages: messages , readOnly: true,)),
          Card(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(hintText: "write here..."),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    askDeepSeek();
                  },
                  icon: Icon(Icons.send),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
