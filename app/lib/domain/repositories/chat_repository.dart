// Interface for Chat Repository.
//
// Steps:
// 1. Define abstract class `ChatRepository`.
// 2. Define methods:
//    - `Future<Either<Failure, void>> sendMessage(Message message);`
//    - `Future<Either<Failure, List<Message>>> getMessages(String receiverId, {int limit, int offset});`
//    - `Stream<List<Message>> getMessageStream(String receiverId);` (For real-time updates via Socket/Firebase)
