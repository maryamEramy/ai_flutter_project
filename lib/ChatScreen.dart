
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
    if(isTtsEnabled){
      flutterTts.speak(results);
    }
  }

  TextEditingController textEditingController = TextEditingController();
  var results = 'results will shown here...';

  ChatUser user = ChatUser(id: '1' , firstName: 'mar');
  ChatUser userDS = ChatUser(id: '2' , firstName: 'DeepSeek');
  List<ChatMessage> messages = <ChatMessage>[];

  FlutterTts flutterTts = FlutterTts();
  bool isTtsEnabled = true;

  //customizing
  exploreTTs() async{
    List<dynamic> languages = await flutterTts.getLanguages;
    languages.forEach((language){
      print('language:' + language);
    });
    if(await flutterTts.isLanguageAvailable("ur-PK")){
      flutterTts.setLanguage("ur-PK");
    }
    List<dynamic> voices = await flutterTts.getVoices;
    voices.forEach((voice){
      print('voice:' + voice.toString());
    });
      flutterTts.setVoice({
        "name": "ur-pk-x-cfn-network" , "locale": "ur-PK"
      });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            if(isTtsEnabled){
              isTtsEnabled = false;
              flutterTts.stop();
            }else{
              isTtsEnabled = true;
            }
            setState(() {
              isTtsEnabled;
            });
          }, icon: Icon(isTtsEnabled? Icons.surround_sound : Icons.surround_sound_outlined))
        ],
      ),
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
