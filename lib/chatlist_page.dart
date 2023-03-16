import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.text, required this.sender});

  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(right: 10),
          child: CircleAvatar(
            child: Text(sender[0]),
          ),
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Material(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                elevation: 5,
                color: Colors.blue[400],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    sender,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                )),
            const SizedBox(height: 5),
            Material(
              borderRadius: const BorderRadius.all(Radius.circular(25)),
              elevation: 8,
              color: Colors.blue[600],
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      text,
                      style: const TextStyle(fontSize: 17, color: Colors.white),
                    ),
                  ),
                ),
              ),
            )
          ],
        ))
      ],
    );
  }
}