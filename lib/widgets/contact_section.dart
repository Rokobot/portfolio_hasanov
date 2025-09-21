import 'package:email_sender/email_sender.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_helper.dart';
import '../constants/app_constants.dart';
import '../services/contact_service.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:flutter/material.dart';
class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final messageController = TextEditingController();
  
  bool _isFormValid = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Form alanlarını dinle
    nameController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    messageController.addListener(_validateForm);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final message = messageController.text.trim();
    
    final isValid = name.isNotEmpty && 
                   email.isNotEmpty && 
                   message.isNotEmpty &&
                   ContactService().isValidEmail(email);
    
    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }





  Future<void> sendEmail({
    required TextEditingController nameController,
    required TextEditingController emailController,
    required TextEditingController messageController,
    required BuildContext context,
  }) async {
    Email emailsender = Email( );



    String username = 'nextnexttime451@gmail.com';
    String password = 'hasanovpassword@'; // Gmail App Password istifadə edin

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, nameController.text)
      ..recipients.add('alihasanov2023@gmail.com') // öz inboxunuz
      ..subject = '${emailController.text} - dan sənə bir email var'
      ..text = messageController.text;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email uğurla göndərildi!'),
            backgroundColor: Colors.green,
          ),
        );

        nameController.clear();
        emailController.clear();
        messageController.clear();
      }
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString());
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Hata: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Container(
          padding: ResponsiveHelper.getScreenPadding(context).copyWith(
            top: 80,
            bottom: 80,
          ),
          color: AppTheme.getSurfaceColor(appProvider.isDarkMode),
          child: Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: ResponsiveHelper.getMaxContentWidth(context),
              ),
              child: Column(
                children: [
                  Text(
                    l10n.contactTitle,
                    style: AppTheme.getHeadingMedium(appProvider.isDarkMode),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.contactDescription,
                    style: AppTheme.getBodyLarge(appProvider.isDarkMode),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),
                  ResponsiveHelper.isMobile(context)
                      ? _buildMobileLayout(context, appProvider)
                      : _buildDesktopLayout(context, appProvider),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context, AppProvider appProvider) {
    return Column(
      children: [
        _buildContactForm(context, appProvider),
        const SizedBox(height: 40),
        _buildContactInfo(context, appProvider),
      ],
    );
  }

  Widget _buildDesktopLayout(BuildContext context, AppProvider appProvider) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildContactForm(context, appProvider),
        ),
        const SizedBox(width: 60),
        Expanded(
          flex: 1,
          child: _buildContactInfo(context, appProvider),
        ),
      ],
    );
  }

  Widget _buildContactForm(BuildContext context, AppProvider appProvider) {
    final l10n = AppLocalizations.of(context)!;
    
    return Card(
      color: AppTheme.getCardColor(appProvider.isDarkMode),
      elevation: 8,
      shadowColor: AppTheme.primaryColor.withOpacity(0.2),
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.sendMessage,
                style: AppTheme.getHeadingSmall(appProvider.isDarkMode),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: l10n.yourName,
                  labelStyle: AppTheme.getBodyMedium(appProvider.isDarkMode),
                  filled: true,
                  fillColor: AppTheme.getSurfaceColor(appProvider.isDarkMode),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.getTextSecondaryColor(appProvider.isDarkMode).withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                  ),
                ),
                style: AppTheme.getBodyMedium(appProvider.isDarkMode),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'İsim gereklidir';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: l10n.yourEmail,
                  labelStyle: AppTheme.getBodyMedium(appProvider.isDarkMode),
                  filled: true,
                  fillColor: AppTheme.getSurfaceColor(appProvider.isDarkMode),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.getTextSecondaryColor(appProvider.isDarkMode).withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                  ),
                ),
                style: AppTheme.getBodyMedium(appProvider.isDarkMode),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'E-posta adresi gereklidir';
                  }
                  if (!ContactService().isValidEmail(value.trim())) {
                    return 'Geçerli bir e-posta adresi girin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: messageController,
                maxLines: 5,
                decoration: InputDecoration(
                  labelText: l10n.yourMessage,
                  labelStyle: AppTheme.getBodyMedium(appProvider.isDarkMode),
                  filled: true,
                  fillColor: AppTheme.getSurfaceColor(appProvider.isDarkMode),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppTheme.getTextSecondaryColor(appProvider.isDarkMode).withOpacity(0.3),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppTheme.primaryColor, width: 2),
                  ),
                ),
                style: AppTheme.getBodyMedium(appProvider.isDarkMode),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Mesaj gereklidir';
                  }
                  if (value.trim().length < 10) {
                    return 'Mesaj en az 10 karakter olmalıdır';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _isFormValid && !_isLoading
                    ? () {
                  sendEmail(
                    context: context,
                    nameController: nameController,
                    emailController: emailController,
                    messageController: messageController,
                  );
                }
                    : null,                style: ElevatedButton.styleFrom(
                  backgroundColor: _isFormValid 
                      ? AppTheme.primaryColor 
                      : AppTheme.getTextSecondaryColor(appProvider.isDarkMode).withOpacity(0.3),
                  foregroundColor: _isFormValid 
                      ? Colors.white 
                      : AppTheme.getTextSecondaryColor(appProvider.isDarkMode).withOpacity(0.6),
                  disabledBackgroundColor: AppTheme.getTextSecondaryColor(appProvider.isDarkMode).withOpacity(0.2),
                  disabledForegroundColor: AppTheme.getTextSecondaryColor(appProvider.isDarkMode).withOpacity(0.4),
                  elevation: _isFormValid ? 4 : 0,
                  shadowColor: _isFormValid ? AppTheme.primaryColor.withOpacity(0.3) : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: _isLoading 
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Text(
                          l10n.sendMessage,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: _isFormValid 
                                ? Colors.white 
                                : AppTheme.getTextSecondaryColor(appProvider.isDarkMode).withOpacity(0.6),
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactInfo(BuildContext context, AppProvider appProvider) {
    final l10n = AppLocalizations.of(context)!;
    
    return Column(
      children: [
        Card(
          color: AppTheme.getCardColor(appProvider.isDarkMode),
          elevation: 8,
          shadowColor: AppTheme.primaryColor.withOpacity(0.2),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context).contactTitle,
                  style: AppTheme.getHeadingSmall(appProvider.isDarkMode),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _buildContactItem(
                  context,
                  Icons.email,
                  'Email',
                  AppConstants.email,
                  appProvider.isDarkMode,
                ),
                const SizedBox(height: 16),
                _buildContactItem(
                  context,
                  Icons.telegram,
                  'Telegram',
                  '@alihasanov',
                  appProvider.isDarkMode,
                ),
                const SizedBox(height: 16),
                _buildContactItem(
                  context,
                  Icons.phone,
                  'WhatsApp',
                  AppConstants.whatsappNumber,
                  appProvider.isDarkMode,
                ),
              ],
            ),
          ),
        ),

/*  const SizedBox(height: 24),      Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildSocialButton(context, Icons.telegram, appProvider.isDarkMode, () async {
              await ContactService().openTelegram();
            }),
            _buildSocialButton(context, Icons.email, appProvider.isDarkMode, () async {
              await ContactService().sendEmail(
                name: 'Portfolio Visitor',
                email: AppConstants.email,
                message: 'Hello Ali, I visited your portfolio and would like to connect!',
              );
            }),
            _buildSocialButton(context, Icons.phone, appProvider.isDarkMode, () async {
              await ContactService().openWhatsApp();
            }),
            _buildSocialButton(context, Icons.link, appProvider.isDarkMode, () async {
              await ContactService().openLinkedIn();
            }),
          ],
        ),*/
      ],
    );
  }




/*
  void sendEmail() async {
    String username = 'nextnexttime451@gmail.com';
    String password = 'hasanovpassword@';

    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, nameController.text)
      ..recipients.add('alihasanov2023@gmail.com')
      ..subject = '${emailController.text} - dan sənə bir email var'
      ..text = messageController.text.toString();

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
    } on MailerException catch (e) {
      print('Message not sent. \n' + e.toString());
    }
  }
*/


  Widget _buildContactItem(BuildContext context, IconData icon, String label, String value, bool isDarkMode) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: AppTheme.primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTheme.getLabelMedium(isDarkMode),
              ),
              Text(
                value,
                style: AppTheme.getBodySmall(isDarkMode),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton(BuildContext context, IconData icon, bool isDarkMode, VoidCallback? onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppTheme.primaryColor.withOpacity(0.3),
        ),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: AppTheme.primaryColor,
        ),
      ),
    );
  }
} 