import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/bot_response.dart';
import '../services/chatbot_rules.dart';
import '../providers/app_provider.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_helper.dart';
import 'package:intl/intl.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatBotWidget extends StatefulWidget {
  const ChatBotWidget({super.key});

  @override
  State<ChatBotWidget> createState() => _ChatBotWidgetState();
}

class _ChatBotWidgetState extends State<ChatBotWidget>
    with TickerProviderStateMixin {
  bool _isExpanded = false;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<BotResponse> _messages = [];
  bool _isTyping = false;

  late AnimationController _expandController;
  late AnimationController _fabController;
  late Animation<double> _expandAnimation;
  late Animation<double> _fabAnimation;

  @override
  void initState() {
    super.initState();
    
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOutCubic,
    );

    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.elasticOut,
    ));

    _fabController.forward();
    
    // Welcome message
    _addWelcomeMessage();
    
    // Auto-open chat after 2 seconds
    _autoOpenChat();
  }

  @override
  void dispose() {
    _expandController.dispose();
    _fabController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        final l10n = AppLocalizations.of(context);
        setState(() {
          _messages.add(BotResponse.bot(
            l10n?.chatbotWelcome ?? 'Hello! I\'m Ali Hasanov\'s portfolio ChatBot. How can I help you? 😊'
          ));
        });
      }
    });
  }

  void _autoOpenChat() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted && !_isExpanded) {
        _toggleChat();
      }
    });
  }

  void _toggleChat() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
    
    if (_isExpanded) {
      _expandController.forward();
    } else {
      _expandController.reverse();
    }
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isEmpty) return;

    setState(() {
      _messages.add(BotResponse.user(message));
      _isTyping = true;
    });

    _messageController.clear();
    _scrollToBottom();

    // Simulate bot typing delay
    Future.delayed(const Duration(milliseconds: 800), () {
      final l10n = AppLocalizations.of(context);
      final botResponse = ChatBotRules.getResponse(message, l10n!);
      
      if (mounted) {
        setState(() {
          _messages.add(BotResponse.bot(botResponse));
          _isTyping = false;
        });
        _scrollToBottom();
      }
    });
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Stack(
          children: [
            // Chat Window
            AnimatedBuilder(
              animation: _expandAnimation,
              builder: (context, child) {
                return Positioned(
                  bottom: 100,
                  right: 20,
                  child: Transform.scale(
                    scale: _expandAnimation.value,
                    alignment: Alignment.bottomRight,
                    child: _isExpanded
                        ? _buildChatWindow(appProvider.isDarkMode)
                        : const SizedBox.shrink(),
                  ),
                );
              },
            ),
            
            // Floating Action Button
            Positioned(
              bottom: 20,
              right: 20,
              child: AnimatedBuilder(
                animation: _fabAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _fabAnimation.value,
                    child: _buildFloatingActionButton(appProvider.isDarkMode),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFloatingActionButton(bool isDarkMode) {
    return FloatingActionButton(
      onPressed: _toggleChat,
      backgroundColor: AppTheme.primaryColor,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Icon(
          _isExpanded ? Icons.close : Icons.chat_bubble_outline,
          key: ValueKey(_isExpanded),
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }

  Widget _buildChatWindow(bool isDarkMode) {
    final isDesktop = !ResponsiveHelper.isMobile(context);
    
    return Container(
      width: isDesktop ? 400 : MediaQuery.of(context).size.width - 40,
      height: isDesktop ? 600 : MediaQuery.of(context).size.height * 0.7,
      decoration: BoxDecoration(
        color: AppTheme.getCardColor(isDarkMode),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildChatHeader(isDarkMode),
          Expanded(
            child: _buildMessagesList(isDarkMode),
          ),
          _buildMessageInput(isDarkMode),
        ],
      ),
    );
  }

  Widget _buildChatHeader(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.primaryColor,
            AppTheme.primaryColor.withOpacity(0.8),
          ],
        ),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.smart_toy,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ali\'s Assistant',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Portfolio ChatBot',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: const Text(
              'Online',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessagesList(bool isDarkMode) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length + (_isTyping ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == _messages.length && _isTyping) {
          return _buildTypingIndicator(isDarkMode);
        }
        
        final message = _messages[index];
        return _buildMessageBubble(message, isDarkMode);
      },
    );
  }

  Widget _buildMessageBubble(BotResponse message, bool isDarkMode) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: Align(
            alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(bottom: 12),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.7,
              ),
              child: Column(
                crossAxisAlignment: message.isUser 
                    ? CrossAxisAlignment.end 
                    : CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: message.isUser
                          ? AppTheme.primaryColor
                          : AppTheme.getSurfaceColor(isDarkMode),
                      borderRadius: BorderRadius.circular(18).copyWith(
                        bottomRight: message.isUser 
                            ? const Radius.circular(4) 
                            : const Radius.circular(18),
                        bottomLeft: message.isUser 
                            ? const Radius.circular(18) 
                            : const Radius.circular(4),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      message.message,
                      style: TextStyle(
                        color: message.isUser
                            ? Colors.white
                            : AppTheme.getTextPrimaryColor(isDarkMode),
                        fontSize: 14,
                        height: 1.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('HH:mm').format(message.timestamp),
                    style: TextStyle(
                      color: AppTheme.getTextSecondaryColor(isDarkMode),
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTypingIndicator(bool isDarkMode) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.getSurfaceColor(isDarkMode),
          borderRadius: BorderRadius.circular(18).copyWith(
            bottomLeft: const Radius.circular(4),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDot(isDarkMode, 0),
            const SizedBox(width: 4),
            _buildDot(isDarkMode, 1),
            const SizedBox(width: 4),
            _buildDot(isDarkMode, 2),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(bool isDarkMode, int index) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 600),
      tween: Tween<double>(begin: 0.4, end: 1.0),
      builder: (context, value, child) {
        return AnimatedContainer(
          duration: Duration(milliseconds: 300 + (index * 100)),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(value),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }

  Widget _buildMessageInput(bool isDarkMode) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.getSurfaceColor(isDarkMode),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Column(
        children: [
          // Sample Questions
          if (_messages.length <= 1) _buildSampleQuestions(isDarkMode),
          
          // Input Field
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)?.chatbotPlaceholder ?? 'Type your message...',
                    hintStyle: TextStyle(
                      color: AppTheme.getTextSecondaryColor(isDarkMode),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide(
                        color: AppTheme.primaryColor,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: AppTheme.getCardColor(isDarkMode),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  style: TextStyle(
                    color: AppTheme.getTextPrimaryColor(isDarkMode),
                  ),
                  maxLines: null,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.primaryColor,
                      AppTheme.primaryColor.withOpacity(0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: IconButton(
                  onPressed: _sendMessage,
                  icon: const Icon(
                    Icons.send,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSampleQuestions(bool isDarkMode) {
    final l10n = AppLocalizations.of(context)!;
    final sampleQuestions = ChatBotRules.getSampleQuestions(l10n).take(3).toList();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.chatbotSampleQuestions,
          style: TextStyle(
            color: AppTheme.getTextSecondaryColor(isDarkMode),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: sampleQuestions.map((question) {
            return GestureDetector(
              onTap: () {
                _messageController.text = question;
                _sendMessage();
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  question,
                  style: TextStyle(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
} 