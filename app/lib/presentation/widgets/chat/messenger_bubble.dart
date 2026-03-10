import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessengerBubble extends StatelessWidget {
  final bool isMe;
  final String text;
  final DateTime? time;
  final bool optimistic;

  const MessengerBubble({
    super.key,
    required this.isMe,
    required this.text,
    this.time,
    this.optimistic = false,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isMe ? const Color(0xFF1877F2) : const Color(0xFFF1F1F1);
    final fg = isMe ? Colors.white : const Color(0xFF111111);
    final align = isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start;

    final timeText = time == null ? '' : DateFormat('HH:mm').format(time!);

    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          constraints: const BoxConstraints(maxWidth: 320),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(18),
              topRight: const Radius.circular(18),
              bottomLeft: Radius.circular(isMe ? 18 : 6),
              bottomRight: Radius.circular(isMe ? 6 : 18),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            text,
            style: TextStyle(
              color: fg,
              fontSize: 15,
              height: 1.25,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (timeText.isNotEmpty)
              Text(
                timeText,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                  fontWeight: FontWeight.w500,
                ),
              ),
            if (optimistic) ...[
              const SizedBox(width: 6),
              Icon(
                Icons.schedule,
                size: 12,
                color: Colors.grey[500],
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}