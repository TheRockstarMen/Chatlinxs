import 'package:flutter/material.dart';
import 'package:chatlinxs/constants/colors.dart';
import 'package:chatlinxs/models/size_config.dart';

class TextMessage extends StatefulWidget {
  final String message;
  final bool isIncomingMessage;

  const TextMessage({super.key, required this.message, required this.isIncomingMessage});

  @override
  State<TextMessage> createState() => _TextMessageState();
}

class _TextMessageState extends State<TextMessage> {
  late bool fromFriend;
  late String message;

  @override
  void initState() {
    fromFriend = widget.isIncomingMessage;
    message = widget.message;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment:
            fromFriend ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          Container(
              constraints:
                  BoxConstraints(maxWidth: SizeConfig.screenWidth * 0.8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(fromFriend ? 0 : 40),
                    topLeft: const Radius.circular(40),
                    topRight: const Radius.circular(40),
                    bottomRight: Radius.circular(fromFriend ? 40 : 0)),
                color: fromFriend ? const Color(0xFF4C4C4C) : null,
                gradient: fromFriend
                    ? null
                    : LinearGradient(colors: [
                        greenGradient.lightShade,
                        greenGradient.darkShade,
                      ]),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16),
                child: Text(
                  message,
                  style: const TextStyle(color: Colors.white),
                ),
              )),
        ],
      ),
    );
  }
}
