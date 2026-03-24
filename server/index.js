const http = require("http");
const { Server } = require("socket.io");

const server = http.createServer();

const io = new Server(server, {
  cors: { origin: "*" },
  transports: ["websocket"],
});

const ADMIN_IDS = [1]; // admin sample của bạn

io.on("connection", (socket) => {
  const userId = Number(socket.handshake.query.userId || 0);

  console.log("client connected:", socket.id, "userId:", userId);

  // Nếu là admin -> auto join inbox chung
  if (ADMIN_IDS.includes(userId)) {
    socket.join("admin_inbox");
    console.log(`admin ${userId} joined admin_inbox`);
  }

  socket.on("join_room", ({ roomId, userId }) => {
    socket.join(`room_${roomId}`);
    console.log(`user ${userId} joined room_${roomId}`);
  });

  socket.on("send_message", (payload) => {
    console.log("send_message payload:", payload);

    const { roomId, senderId, content, clientMsgId } = payload || {};
    if (!roomId || !senderId || !content) {
      console.log("invalid payload");
      return;
    }

    const message = {
      id: Date.now(),
      roomId,
      senderId,
      content: String(content),
      createdAt: new Date().toISOString(),
      clientMsgId: clientMsgId || null,
    };

    // 1) gửi cho đúng room chat
    io.to(`room_${roomId}`).emit("new_message", { message });

    // 2) nếu người gửi không phải admin -> gửi thêm cho admin inbox
    if (!ADMIN_IDS.includes(Number(senderId))) {
      io.to("admin_inbox").emit("admin_inbox_message", { message });
      console.log("broadcast to admin_inbox:", message);
    }

    console.log("broadcast new_message:", message);
  });

  socket.on("disconnect", () => {
    console.log("client disconnected:", socket.id);
  });
});

server.listen(3000, "0.0.0.0", () => {
  console.log("Socket.IO listening on :3000");
});