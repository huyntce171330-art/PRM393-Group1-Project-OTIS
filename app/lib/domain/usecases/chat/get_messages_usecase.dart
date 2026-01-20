// Use case to get message history.
//
// Steps:
// 1. Create `GetMessagesUsecase`.
// 2. Inject `ChatRepository`.
// 3. `call` method accepts `receiverId` (and optional pagination params).
// 4. Invoke `repository.getMessages(...)`.
