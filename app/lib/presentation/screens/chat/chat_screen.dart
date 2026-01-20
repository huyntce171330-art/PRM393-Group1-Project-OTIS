// Chat Screen UI.
//
// Steps:
// 1. `BlocBuilder<ChatBloc, ChatState>` (builds message list).
// 2. `ListView.builder` (reverse: true) to show messages from bottom.
// 3. `TextField` + Send Button at bottom.
//    - On Send: Dispatch `SendMessageEvent`.
//    - Clear text field.
// 4. `AppBar` with Receiver Name/Avatar.
