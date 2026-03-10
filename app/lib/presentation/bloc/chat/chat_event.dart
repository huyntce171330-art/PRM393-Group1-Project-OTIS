abstract class ChatEvent {}

class ChatStarted extends ChatEvent {
  final int roomId;
  final int userId;
  final String socketUrl;

  ChatStarted({
    required this.roomId,
    required this.userId,
    required this.socketUrl,
  });
}

class ChatTextChanged extends ChatEvent {
  final String text;
  ChatTextChanged(this.text);
}

class ChatSendPressed extends ChatEvent {}

class ChatMessageReceived extends ChatEvent {
  final Map<String, dynamic> message;
  ChatMessageReceived(this.message);
}

class ChatConnectionChanged extends ChatEvent {
  final bool connected;
  ChatConnectionChanged(this.connected);
}