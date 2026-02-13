// Events for ChatBloc.
//
// Steps:
// 1. `LoadMessagesEvent(String receiverId)`
// 2. `SendMessageEvent(String content, String receiverId)`
// 3. `ReceiveNewMessageEvent(Message message)` (Internal event from Stream)
// 4. `ConnectChatEvent` / `DisconnectChatEvent`
