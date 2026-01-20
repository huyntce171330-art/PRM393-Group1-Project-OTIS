// Use case to listen for real-time messages.
//
// Steps:
// 1. Create `ReceiveMessageStreamUsecase`.
// 2. Inject `ChatRepository`.
// 3. `call` method accepts `receiverId`.
// 4. Return `Stream<List<Message>>` from `repository.getMessageStream(...)`.
