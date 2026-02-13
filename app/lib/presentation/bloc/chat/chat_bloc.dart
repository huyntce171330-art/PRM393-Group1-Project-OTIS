// BLoC for Chat.
//
// Steps:
// 1. Inject use cases.
// 2. `on<LoadMessagesEvent>`: Fetch history.
// 3. `on<SendMessageEvent>`: Call send use case, then optimistically add to list or wait for server ack.
// 4. Subscribe to `ReceiveMessageStreamUsecase` in constructor (or `on<ConnectChatEvent>`).
// 5. `on<ReceiveNewMessageEvent>`: Add new message to current list and emit `ChatLoaded`.
