class BotResponse {
  final String message;
  final DateTime timestamp;
  final bool isUser;

  const BotResponse({
    required this.message,
    required this.timestamp,
    required this.isUser,
  });

  factory BotResponse.user(String message) {
    return BotResponse(
      message: message,
      timestamp: DateTime.now(),
      isUser: true,
    );
  }

  factory BotResponse.bot(String message) {
    return BotResponse(
      message: message,
      timestamp: DateTime.now(),
      isUser: false,
    );
  }

  @override
  String toString() {
    return 'BotResponse(message: $message, isUser: $isUser, timestamp: $timestamp)';
  }
} 