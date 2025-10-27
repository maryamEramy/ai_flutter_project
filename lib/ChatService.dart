import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:http/http.dart';

class ChatService{
  askDeepSeek(List<Map<String , Object>> chatHistory) async {
    // var inputText = textEditingController.text;
    // chatHistory.add({"role": "user", "content": inputText});
    // messages.insert(0 , ChatMessage(user: user, createdAt: DateTime.now() , text: inputText));
    // setState(() {
    //   messages;
    // });
    // textEditingController.clear();
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
      return jsonData['choices'][0]['message']['content'];
      // chatHistory.add({"role": "assistant", "content": results});
      // messages.insert(0 , ChatMessage(user: userDS, createdAt: DateTime.now() , text: results));
      // setState(() {
      //   messages;
      // });
    }else{
      return "empty";
    }
    // messages.insert(0 , ChatMessage(user: userDS, createdAt: DateTime.now() , text: response.body));
    // setState(() {
    //   messages;
    // });
    // print(response.body);
  }
}