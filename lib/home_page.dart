import 'dart:convert';
import 'package:chat_gpt/chatlist_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ChatGPTPage extends StatefulWidget {
  const ChatGPTPage({super.key});

  @override
  State<ChatGPTPage> createState() => _ChatGPTPageState();
}

Future<String> generateResponse(String botMessage) async {
  try {
    const apiKey = "Your API Key";
    var url = Uri.https("api.openai.com", "/v1/chat/completions");
    final response = await http.post(url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey"
        },
        body: json.encode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "user",
              "content": botMessage,
            }
          ],
        }));
    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String botMessage = responseData["choices"][0]["message"]["content"];
      return botMessage;
    } else {
      throw Exception('Failed to generate response');
    }
  } catch (e) {
    rethrow;
  }
}

class _ChatGPTPageState extends State<ChatGPTPage> {
  final _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];

  _sendMessage() async {
    if (_messageController.text.isEmpty) return;
    ChatMessage usermessage =
        ChatMessage(text: _messageController.text, sender: "You");

    setState(() {
      _messages.insert(0, usermessage);
    });

    _messageController.clear();

    
    String botMessage = await generateResponse(usermessage.text);
    ChatMessage botmessage = ChatMessage(text: botMessage, sender: "Bot");
    setState(() {
      _messages.insert(0, botmessage);
    });


  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
            child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: TextField(
            maxLines: null,
            onSubmitted: (value) => _sendMessage(),
            controller: _messageController,
            decoration: const InputDecoration.collapsed(hintText: "Enter a message"),
          ),
        )),
        IconButton(
          color: Colors.lightBlue,
          onPressed: () => _sendMessage(),
          icon: const Icon(Icons.send_rounded),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        //resizeToAvoidBottomInset: false,
        appBar: AppBar(
          elevation: 5,
          backgroundColor: Colors.blue[600],
          title: const Text('ChatGPT', style: TextStyle(color: Colors.white),),
          centerTitle: false,
        ),
        body: Column(
          children: [
            Flexible(
              child: ListView.builder(
                  reverse: true,
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _messages[index],
                    );
                  }),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border.all(
                    color: Colors.lightBlue,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: _buildTextComposer(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}