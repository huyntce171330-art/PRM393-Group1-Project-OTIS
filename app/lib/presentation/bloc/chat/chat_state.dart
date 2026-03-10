class ChatState {
  final bool connected;
  final List<Map<String, dynamic>> messages;
  final String input;

  const ChatState({
    required this.connected,
    required this.messages,
    required this.input,
  });

  factory ChatState.initial() => const ChatState(
    connected: false,
    messages: [],
    input: '',
  );

  ChatState copyWith({
    bool? connected,
    List<Map<String, dynamic>>? messages,
    String? input,
  }) {
    return ChatState(
      connected: connected ?? this.connected,
      messages: messages ?? this.messages,
      input: input ?? this.input,
    );
  }
}