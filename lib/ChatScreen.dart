import 'package:ai_flutter_project/ChatService.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:lottie/lottie.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<Map<String, Object>> chatHistory = [
    {
      "content":
          "You are a helpful financial assistant. Always include a gentle but firm reminder that your advice is not a medical diagnosis and that the user should **consult a qualified doctor in person for proper examination and treatment**",
      "role": "system",
    },
  ];
  ChatService chatService = ChatService();
  askDeepSeek() async {
    var inputText = textEditingController.text;
    chatHistory.add({"role": "user", "content": inputText});
    messages.insert(
      0,
      ChatMessage(user: user, createdAt: DateTime.now(), text: inputText ),
    );
    setState(() {
      messages;
      isLoading = true;
    });
    textEditingController.clear();
    results = await chatService.askDeepSeek(chatHistory);
    chatHistory.add({"role": "assistant", "content": results});
    messages.insert(
      0,
      ChatMessage(user: userDS, createdAt: DateTime.now(), text: results),
    );
    setState(() {
      messages;
      isLoading = false;
    });
    if (isTtsEnabled) {
      flutterTts.speak(results);
    }
  }

  TextEditingController textEditingController = TextEditingController();
  var results = 'results will shown here...';

  ChatUser user = ChatUser(id: '1', firstName: 'mar');
  ChatUser userDS = ChatUser(id: '2', firstName: 'DeepSeek');
  List<ChatMessage> messages = <ChatMessage>[];

  FlutterTts flutterTts = FlutterTts();
  bool isTtsEnabled = true;

  //customizing
  exploreTTs() async {
    List<dynamic> languages = await flutterTts.getLanguages;
    languages.forEach((language) {
      print('language:' + language);
    });
    if (await flutterTts.isLanguageAvailable("ur-PK")) {
      flutterTts.setLanguage("ur-PK");
    }
    List<dynamic> voices = await flutterTts.getVoices;
    voices.forEach((voice) {
      print('voice:' + voice.toString());
    });
    flutterTts.setVoice({"name": "ur-pk-x-cfn-network", "locale": "ur-PK"});
  }

  SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(onResult: _onSpeechResult);
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// This is the callback that the SpeechToText plugin calls when
  /// the platform returns recognized words.
  void _onSpeechResult(SpeechRecognitionResult result) {
    if (result.finalResult) {
      setState(() {
        _lastWords = result.recognizedWords;
        textEditingController.text = _lastWords;
        askDeepSeek();
        print(_lastWords);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Color? mainColor = Colors.blue[600];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: Text(
          "DeepSeek",
          style: TextStyle(fontSize: 22, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              if (isTtsEnabled) {
                isTtsEnabled = false;
                flutterTts.stop();
              } else {
                isTtsEnabled = true;
              }
              setState(() {
                isTtsEnabled;
              });
            },
            icon: Icon(
              isTtsEnabled
                  ? Icons.surround_sound
                  : Icons.surround_sound_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              messages.isNotEmpty
                  ? Expanded(
                      child: DashChat(
                        currentUser: user,
                        onSend: (e) {},
                        messages: messages,
                        readOnly: true,
                        messageOptions: MessageOptions(
                          currentUserContainerColor: mainColor,
                          textColor: Colors.black87,
                          currentUserTextColor: Colors.white,
                          borderRadius: 18.0,
                          showTime: false,
                          messagePadding: const EdgeInsets.all(12),
                        ),
                      ),

              )
                  : Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.2,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Lottie.asset("assets/Robotanim.json"),
                          ),
                          Text('Hello!\nWhat is the problem?', textAlign: TextAlign.center,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  textEditingController.text =
                                      "I have headache";
                                  askDeepSeek();
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      'Headache',
                                      style: TextStyle(color: Colors.amber),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  textEditingController.text =
                                      "I have stomach pain";
                                  askDeepSeek();
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      'Stomach pain',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () {
                                  textEditingController.text =
                                      "I need a checkup";
                                  askDeepSeek();
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40),
                                  ),
                                  color: Colors.white,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      'Need a checkup',
                                      style: TextStyle(color: Colors.purple),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Card(
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          cursorColor: mainColor,
                          controller: textEditingController,
                          decoration: InputDecoration(
                            hintText: "Write here...",
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            filled: true,
                            fillColor: Colors.transparent,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide: BorderSide.none,
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          _startListening();
                        },
                        icon: Icon(Icons.mic , color: Colors.green,),
                      ),
                      IconButton(
                        onPressed: () {
                          askDeepSeek();
                        },
                        icon: Icon(Icons.send , color: mainColor,),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          isLoading
              ? Center(child: Lottie.asset("assets/chatanim.json"))
              : Container(),
        ],
      ),
    );
  }
}
