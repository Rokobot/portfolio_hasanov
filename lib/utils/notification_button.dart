import 'dart:async';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:html' as html;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import 'app_theme.dart';



class NotificationDemo extends StatefulWidget {
  const NotificationDemo({super.key});

  @override
  State<NotificationDemo> createState() => _NotificationDemoState();
}

class _NotificationDemoState extends State<NotificationDemo>
    with SingleTickerProviderStateMixin {



  late AnimationController _controller;
  List<NotificationItem> _notifications = [];
  bool _dialogOpen = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  late List<NotificationItem> allNotifications;





  @override
  void initState() {
    super.initState();


    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);



    Timer(const Duration(seconds: 8), () => _addNotification(allNotifications, 0));


    Timer(const Duration(seconds: 16), () => _addNotification(allNotifications, 1));
    Timer(const Duration(seconds: 24), () => _addNotification(allNotifications, 2));
  }

  void _playSoundWeb() {
    final audio = html.AudioElement('assets/sounds/notification_sound.wav');
    audio.play();
  }

  void _addNotification(List<NotificationItem> allNotifications, int index) {
    if (index < allNotifications.length) {
      setState(() {
        var newNotification = allNotifications[index];
        newNotification.read = _dialogOpen;
        newNotification.showRedDot = !_dialogOpen;
        _notifications.add(newNotification);

        _playSoundWeb();
      });
    }
  }

  void _showNotificationDialog() {
    setState(() {
      _dialogOpen = true;
      // mark all messages as read when dialog opens
      for (var n in _notifications) {
        n.read = true;
        n.showRedDot = false;
      }
    });

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => Consumer<AppProvider>(
        builder: (BuildContext context,  appProvider, Widget? child) {


              return AlertDialog(
                title: Text(AppLocalizations.of(context).notifications, style: GoogleFonts.poppins()),
                content: SizedBox(
                  width: double.maxFinite,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _notifications.length,
                    itemBuilder: (context, index) {
                      final item = _notifications[index];
                      return Card(

                        color: item.read ? appProvider.isDarkMode ? Colors.black : AppTheme.backgroundColorLight: Colors.red.withOpacity(0.1),
                        child: ListTile(
                          title: Text(
                            AppLocalizations.of(context)!.getString(item.titleKey),
                            style: TextStyle(
                              color: appProvider.isDarkMode ? AppTheme.textPrimaryColorDark : AppTheme.cardColorDark,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)!.getString(item.messageKey),
                            style: TextStyle(
                              color: appProvider.isDarkMode ? AppTheme.textPrimaryColorDark : AppTheme.cardColorDark,
                            ),
                          ),
                          trailing: item.showDownloadButton
                              ? TextButton(
                            onPressed: () {

                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(
                                  AppLocalizations.of(context).buttonDownloading,
                                  style: AppTheme.getBodySmall(appProvider.isDarkMode).copyWith(
                                    color: AppTheme.primaryColor,
                                  ),
                                ) ),
                              );
                            },
                            child:  Text(
                              AppLocalizations.of(context).buttonDownload,
                              style: AppTheme.getBodySmall(appProvider.isDarkMode).copyWith(
                                color: AppTheme.primaryColor,
                              ),
                            ),
                          )
                              : null,
                        ),
                      );
                    },
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      setState(() {
                        _dialogOpen = false;
                      });
                    },
                    child:  Text(AppLocalizations.of(context).buttonClose),
                  ),
                ],
              );
        },
      ),
    );
  }

  bool get _hasUnread => _notifications.any((n) => n.showRedDot);

  @override
  Widget build(BuildContext context) {


    final localizations = AppLocalizations.of(context)!;

    allNotifications = [
      NotificationItem(
        titleKey: "titleNotificationFirst",
        messageKey: "messageNotificationFirst",
        showDownloadButton: true,
      ),
      NotificationItem(
        titleKey: "titleNotificationSecond",
        messageKey: "messageNotificationSecond",
      ),
      NotificationItem(
        titleKey: "titleNotificationThird",
        messageKey: "messageNotificationThird",
      ),
    ];
    return Stack(
      children: [
        Positioned(
          child: GestureDetector(
            onTap: _notifications.isEmpty ? () {} : _showNotificationDialog,
            child: SizedBox(
              width: 50,
              height: 50,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Icon(Icons.notifications_none,
                      size: 30, color: Colors.white),
                  if (_hasUnread)
                    Positioned(
                      top: 10,
                      right: 15,
                      child: _NotificationIcon(show: _hasUnread),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class NotificationItem {
  final String titleKey;
  final String messageKey;
  final bool showDownloadButton;
  bool read;
  bool showRedDot;

  NotificationItem({
    required this.titleKey,
    required this.messageKey,
    this.showDownloadButton = false,
    this.read = false,
    this.showRedDot = false,
  });
}
class _NotificationIcon extends StatefulWidget {
  final bool show;
  const _NotificationIcon({super.key, required this.show});

  @override
  State<_NotificationIcon> createState() => _NotificationIconState();
}

class _NotificationIconState extends State<_NotificationIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _shakeAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _shakeAnim = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0, end: -3), weight: 1),
      TweenSequenceItem(tween: Tween(begin: -3, end: 3), weight: 2),
      TweenSequenceItem(tween: Tween(begin: 3, end: 0), weight: 1),
    ]).animate(_animController);

    if (widget.show) {
      _animController.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant _NotificationIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && !_animController.isAnimating) {
      _animController.reset();
      _animController.repeat();
    } else if (!widget.show && _animController.isAnimating) {
      _animController.stop();
    }
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_shakeAnim.value, 0),
          child: Container(
            width: 14,
            height: 14,
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
          ),
        );
      },
    );
  }
}

extension LocalizationHelper on AppLocalizations {
  String getString(String key) {
    switch (key) {
      case "titleNotificationFirst":
        return titleNotificationFirst;
      case "messageNotificationFirst":
        return messageNotificationFirst;
      case "titleNotificationSecond":
        return titleNotificationSecond;
      case "messageNotificationSecond":
        return messageNotificationSecond;
      case "titleNotificationThird":
        return titleNotificationThird;
      case "messageNotificationThird":
        return messageNotificationThird;
      default:
        return key; // fallback əgər tapılmadısa
    }
  }
}

