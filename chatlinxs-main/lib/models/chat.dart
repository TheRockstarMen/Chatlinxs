import 'package:chatlinxs/constants/enums.dart';
import 'package:chatlinxs/models/user.dart';

import 'message.dart';

class Chat {
  final User user;
  final ChatType chatType;
  final Message lastMessage;
  final int unreadMessages;
  final DateTime dateTime;
  final String chatId;
  final String uuid;

  Chat(this.user, this.chatType, this.lastMessage, this.unreadMessages,
      this.dateTime, this.chatId, this.uuid);

  CustomListTileType fromChatType() {
    switch (chatType) {
      case ChatType.message:
        return CustomListTileType.message;
      case ChatType.group:
        return CustomListTileType.group;
    }
  }

  factory Chat.fromJson(Map<String, dynamic> data) => Chat(
      User.fromJson(data['user']),
      data['chatType'] == 'message' ? ChatType.message : ChatType.group,
      Message.fromJson(data['lastMessage']),
      data['unreadMessages'],
      DateTime.parse(data['dateTime']),
      data['chatId'],
      data['uuid']);

  Map<String, dynamic> toJson() => {
        'user': user.toJson(),
        'chatType': 'message',
        'lastMessage': lastMessage.toJson(),
        'unreadMessages': unreadMessages,
        'dateTime': dateTime.toIso8601String(),
        'chatId': chatId,
        'uuid': uuid
      };
}
