
import 'package:ai_flutter_project/ChatService.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  List<Map<String , Object>> chatHistory = [
    {"content": "You are a helpful assistant", "role": "system"},
  ];
  ChatService chatService = ChatService();
  askDeepSeek() async {
    var inputText = textEditingController.text;
    chatHistory.add({"role": "user", "content": inputText});
    messages.insert(0 , ChatMessage(user: user, createdAt: DateTime.now() , text: inputText));
    setState(() {
      messages;
    });
    textEditingController.clear();
    results = await chatService.askDeepSeek(chatHistory);
    chatHistory.add({"role": "assistant", "content": results});
    messages.insert(0 , ChatMessage(user: userDS, createdAt: DateTime.now() , text: results));
    setState(() {
      messages;
    });
    flutterTts.speak(results);
  }

  TextEditingController textEditingController = TextEditingController();
  var results = 'results will shown here...';

  ChatUser user = ChatUser(id: '1' , firstName: 'mar');
  ChatUser userDS = ChatUser(id: '2' , firstName: 'DeepSeek');
  List<ChatMessage> messages = <ChatMessage>[];

  FlutterTts flutterTts = FlutterTts();
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
