// Interface for Chat Remote Data Source.
//
// Steps:
// 1. Define `ChatRemoteDatasource`.
// 2. Methods:
//    - `sendMessage(Map<String, dynamic> messageData)`
//    - `fetchMessages(String receiverId)`
//    - `initSocketConnection()` (if using WebSockets)
//    - `Stream<MessageModel> get onMessageReceived;`
