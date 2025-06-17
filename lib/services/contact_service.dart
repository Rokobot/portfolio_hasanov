import 'dart:async';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';

class ContactService {
  static final ContactService _instance = ContactService._internal();
  factory ContactService() => _instance;
  ContactService._internal();

  /// Send email using default email client
  Future<bool> sendEmail({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000)); // Simulate processing
      
      final subject = Uri.encodeComponent('Portfolio Contact from $name');
      final body = Uri.encodeComponent(
        'Name: $name\n'
        'Email: $email\n\n'
        'Message:\n$message\n\n'
        '---\n'
        'Sent from Ali Hasanov\'s Portfolio Website',
      );
      
      final emailUri = Uri.parse('${AppConstants.emailUrl}?subject=$subject&body=$body');
      
      if (await canLaunchUrl(emailUri)) {
        return await launchUrl(emailUri);
      } else {
        throw ContactServiceException('Could not launch email client');
      }
    } catch (e) {
      if (e is ContactServiceException) rethrow;
      throw ContactServiceException('Failed to send email: $e');
    }
  }

  /// Open WhatsApp chat
  Future<bool> openWhatsApp([String? message]) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300)); // Brief delay
      
      final encodedMessage = message != null 
          ? Uri.encodeComponent(message)
          : Uri.encodeComponent('Hi Ali, I found your portfolio and would like to connect!');
      
      final whatsappUri = Uri.parse('${AppConstants.whatsappUrl}&text=$encodedMessage');
      
      if (await canLaunchUrl(whatsappUri)) {
        return await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        throw ContactServiceException('Could not launch WhatsApp');
      }
    } catch (e) {
      if (e is ContactServiceException) rethrow;
      throw ContactServiceException('Failed to open WhatsApp: $e');
    }
  }

  /// Open Telegram chat
  Future<bool> openTelegram([String? message]) async {
    try {
      await Future.delayed(const Duration(milliseconds: 300)); // Brief delay
      
      final telegramUri = Uri.parse(AppConstants.telegramContact);
      
      if (await canLaunchUrl(telegramUri)) {
        return await launchUrl(telegramUri, mode: LaunchMode.externalApplication);
      } else {
        throw ContactServiceException('Could not launch Telegram');
      }
    } catch (e) {
      if (e is ContactServiceException) rethrow;
      throw ContactServiceException('Failed to open Telegram: $e');
    }
  }

  /// Open LinkedIn profile
  Future<bool> openLinkedIn() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300)); // Brief delay
      
      final linkedinUri = Uri.parse(AppConstants.linkedinUrl);
      
      if (await canLaunchUrl(linkedinUri)) {
        return await launchUrl(linkedinUri, mode: LaunchMode.externalApplication);
      } else {
        throw ContactServiceException('Could not launch LinkedIn');
      }
    } catch (e) {
      if (e is ContactServiceException) rethrow;
      throw ContactServiceException('Failed to open LinkedIn: $e');
    }
  }

  /// Open GitHub profile
  Future<bool> openGitHub() async {
    try {
      await Future.delayed(const Duration(milliseconds: 300)); // Brief delay
      
      final githubUri = Uri.parse(AppConstants.githubUrl);
      
      if (await canLaunchUrl(githubUri)) {
        return await launchUrl(githubUri, mode: LaunchMode.externalApplication);
      } else {
        throw ContactServiceException('Could not launch GitHub');
      }
    } catch (e) {
      if (e is ContactServiceException) rethrow;
      throw ContactServiceException('Failed to open GitHub: $e');
    }
  }

  /// Open external URL
  Future<bool> openUrl(String url) async {
    try {
      await Future.delayed(const Duration(milliseconds: 200)); // Brief delay
      
      final uri = Uri.parse(url);
      
      if (await canLaunchUrl(uri)) {
        return await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw ContactServiceException('Could not launch URL: $url');
      }
    } catch (e) {
      if (e is ContactServiceException) rethrow;
      throw ContactServiceException('Failed to open URL: $e');
    }
  }

  /// Validate email format
  bool isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  /// Validate contact form
  ContactFormValidation validateContactForm({
    required String name,
    required String email,
    required String message,
  }) {
    final errors = <String>[];
    
    if (name.trim().isEmpty) {
      errors.add('Name is required');
    } else if (name.trim().length < 2) {
      errors.add('Name must be at least 2 characters');
    }
    
    if (email.trim().isEmpty) {
      errors.add('Email is required');
    } else if (!isValidEmail(email.trim())) {
      errors.add('Please enter a valid email address');
    }
    
    if (message.trim().isEmpty) {
      errors.add('Message is required');
    } else if (message.trim().length < 10) {
      errors.add('Message must be at least 10 characters');
    }
    
    return ContactFormValidation(
      isValid: errors.isEmpty,
      errors: errors,
    );
  }

  /// Submit contact form (combines validation and sending)
  Future<ContactFormResult> submitContactForm({
    required String name,
    required String email,
    required String message,
  }) async {
    try {
      // Validate form data
      final validation = validateContactForm(
        name: name,
        email: email,
        message: message,
      );
      
      if (!validation.isValid) {
        return ContactFormResult(
          success: false,
          message: validation.errors.first,
        );
      }
      
      // Send email
      final emailSent = await sendEmail(
        name: name.trim(),
        email: email.trim(),
        message: message.trim(),
      );
      
      return ContactFormResult(
        success: emailSent,
        message: emailSent 
            ? 'Message sent successfully!' 
            : 'Failed to send message. Please try again.',
      );
    } catch (e) {
      return ContactFormResult(
        success: false,
        message: 'An error occurred: ${e.toString()}',
      );
    }
  }
}

class ContactFormValidation {
  final bool isValid;
  final List<String> errors;

  const ContactFormValidation({
    required this.isValid,
    required this.errors,
  });
}

class ContactFormResult {
  final bool success;
  final String message;

  const ContactFormResult({
    required this.success,
    required this.message,
  });
}

class ContactServiceException implements Exception {
  final String message;
  const ContactServiceException(this.message);
  
  @override
  String toString() => 'ContactServiceException: $message';
} 