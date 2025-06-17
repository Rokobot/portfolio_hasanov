import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChatBotRules {
  static String getResponse(String userMessage, AppLocalizations l10n) {
    final cleanMessage = userMessage.toLowerCase().trim();
    
    // Anahtar kelimeler ile eşleştirme
    final keywords = {
      // Selamlaşma - Azerbaycanca
      'salam': l10n.chatbotGreeting,
      'salaam': l10n.chatbotGreeting,
      'salamlar': l10n.chatbotGreeting,
      
      // Selamlaşma - Türkçe
      'merhaba': l10n.chatbotGreeting,
      'selam': l10n.chatbotGreeting,
      'selamlar': l10n.chatbotGreeting,
      'hey': l10n.chatbotGreeting,
      
      // Selamlaşma - İngilizce
      'hello': l10n.chatbotGreeting,
      'hi': l10n.chatbotGreeting,
      'greetings': l10n.chatbotGreeting,
      
      // Selamlaşma - Rusça
      'привет': l10n.chatbotGreeting,
      'здравствуй': l10n.chatbotGreeting,
      'приветствую': l10n.chatbotGreeting,
      
      // Kim/Tanıtım - Azerbaycanca
      'kim': l10n.chatbotIntroduction,
      'kimsen': l10n.chatbotIntroduction,
      'özün': l10n.chatbotIntroduction,
      'adın': l10n.chatbotIntroduction,
      
      // Kim/Tanıtım - Türkçe
      'kimsin': l10n.chatbotIntroduction,
      'adın ne': l10n.chatbotIntroduction,
      'kendini tanıt': l10n.chatbotIntroduction,
      'sen kimsin': l10n.chatbotIntroduction,
      
      // Kim/Tanıtım - İngilizce
      'who are you': l10n.chatbotIntroduction,
      'introduce yourself': l10n.chatbotIntroduction,
      'tell me about yourself': l10n.chatbotIntroduction,
      'your name': l10n.chatbotIntroduction,
      
      // Kim/Tanıtım - Rusça
      'кто ты': l10n.chatbotIntroduction,
      'представься': l10n.chatbotIntroduction,
      'расскажи о себе': l10n.chatbotIntroduction,
      'как тебя зовут': l10n.chatbotIntroduction,
      
      // Flutter - Azerbaycanca
      'flutter': l10n.chatbotFlutter,
      'flutter nədir': l10n.chatbotFlutter,
      'flutter haqqında': l10n.chatbotFlutter,
      
      // Flutter - Türkçe
      'flutter nedir': l10n.chatbotFlutter,
      'flutter hakkında': l10n.chatbotFlutter,
      'neden flutter': l10n.chatbotWhyFlutter,
      
      // Flutter - İngilizce
      'what is flutter': l10n.chatbotFlutter,
      'about flutter': l10n.chatbotFlutter,
      'why flutter': l10n.chatbotWhyFlutter,
      
      // Flutter - Rusça
      'что такое flutter': l10n.chatbotFlutter,
      'о flutter': l10n.chatbotFlutter,
      'почему flutter': l10n.chatbotWhyFlutter,
      
      // Təcrübə - Azerbaycanca
      'təcrübə': l10n.chatbotExperience,
      'təcrübən': l10n.chatbotExperience,
      'iş təcrübəsi': l10n.chatbotExperience,
      'neçə il': l10n.chatbotExperience,
      
      // Deneyim - Türkçe
      'deneyim': l10n.chatbotExperience,
      'tecrübe': l10n.chatbotExperience,
      'iş deneyimi': l10n.chatbotExperience,
      'kaç yıl': l10n.chatbotExperience,
      
      // Experience - İngilizce
      'experience': l10n.chatbotExperience,
      'work experience': l10n.chatbotExperience,
      'years of experience': l10n.chatbotExperience,
      'how long': l10n.chatbotExperience,
      
      // Опыт - Rusça
      'опыт': l10n.chatbotExperience,
      'опыт работы': l10n.chatbotExperience,
      'сколько лет': l10n.chatbotExperience,
      
      // Təhsil - Azerbaycanca
      'təhsil': l10n.chatbotEducation,
      'universitet': l10n.chatbotEducation,
      'oxumuş': l10n.chatbotEducation,
      
      // Eğitim - Türkçe
      'eğitim': l10n.chatbotEducation,
      'üniversite': l10n.chatbotEducation,
      'okul': l10n.chatbotEducation,
      
      // Education - İngilizce
      'education': l10n.chatbotEducation,
      'university': l10n.chatbotEducation,
      'school': l10n.chatbotEducation,
      'degree': l10n.chatbotEducation,
      
      // Образование - Rusça
      'образование': l10n.chatbotEducation,
      'университет': l10n.chatbotEducation,
      'учеба': l10n.chatbotEducation,
      
      // Bacarıqlar - Azerbaycanca
      'bacarıq': l10n.chatbotSkills,
      'bacarıqlar': l10n.chatbotSkills,
      'skill': l10n.chatbotSkills,
      'texnologiya': l10n.chatbotSkills,
      
      // Yetenekler - Türkçe
      'yetenek': l10n.chatbotSkills,
      'yetenekler': l10n.chatbotSkills,
      'beceri': l10n.chatbotSkills,
      'teknoloji': l10n.chatbotSkills,
      
      // Skills - İngilizce
      'skills': l10n.chatbotSkills,
      'abilities': l10n.chatbotSkills,
      'technology': l10n.chatbotSkills,
      'tech stack': l10n.chatbotSkills,
      
      // Навыки - Rusça
      'навыки': l10n.chatbotSkills,
      'умения': l10n.chatbotSkills,
      'технологии': l10n.chatbotSkills,
      
      // Layihələr - Azerbaycanca
      'layihə': l10n.chatbotProjects,
      'layihələr': l10n.chatbotProjects,
      'az_project': l10n.chatbotProjects,
      'az_portfolio': l10n.chatbotProjects,
      
      // Projeler - Türkçe
      'proje': l10n.chatbotProjects,
      'projeler': l10n.chatbotProjects,
      'portfolyo': l10n.chatbotProjects,
      
      // Projects - İngilizce
      'projects': l10n.chatbotProjects,
      'work': l10n.chatbotProjects,
      'en_portfolio': l10n.chatbotProjects,
      
      // Проекты - Rusça
      'проекты': l10n.chatbotProjects,
      'работы': l10n.chatbotProjects,
      'портфолио': l10n.chatbotProjects,
      
      // Əlaqə - Azerbaycanca
      'əlaqə': l10n.chatbotContact,
      'kontakt': l10n.chatbotContact,
      'email': l10n.chatbotContact,
      
      // İletişim - Türkçe
      'iletişim': l10n.chatbotContact,
      'kontak': l10n.chatbotContact,
      'mail': l10n.chatbotContact,
      
      // Contact - İngilizce
      'contact': l10n.chatbotContact,
      'reach': l10n.chatbotContact,
      'get in touch': l10n.chatbotContact,
      
      // Контакты - Rusça
      'контакт': l10n.chatbotContact,
      'связь': l10n.chatbotContact,
      'почта': l10n.chatbotContact,
      
      // Gələcək - Azerbaycanca
      'gələcək': l10n.chatbotFuture,
      'plan': l10n.chatbotFuture,
      'planlar': l10n.chatbotFuture,
      
      // Gelecek - Türkçe
      'gelecek': l10n.chatbotFuture,
      'planlar': l10n.chatbotFuture,
      'hedef': l10n.chatbotFuture,
      
      // Future - İngilizce
      'future': l10n.chatbotFuture,
      'plans': l10n.chatbotFuture,
      'goals': l10n.chatbotFuture,
      
      // Будущее - Rusça
      'будущее': l10n.chatbotFuture,
      'планы': l10n.chatbotFuture,
      'цели': l10n.chatbotFuture,
      
      // Teşekkür - Azerbaycanca
      'təşəkkür': l10n.chatbotThanks,
      'sağol': l10n.chatbotThanks,
      'çox sağol': l10n.chatbotThanks,
      
      // Teşekkür - Türkçe
      'teşekkür': l10n.chatbotThanks,
      'sağol': l10n.chatbotThanks,
      'teşekkürler': l10n.chatbotThanks,
      
      // Thanks - İngilizce
      'thanks': l10n.chatbotThanks,
      'thank you': l10n.chatbotThanks,
      'thx': l10n.chatbotThanks,
      
      // Спасибо - Rusça
      'спасибо': l10n.chatbotThanks,
      'благодарю': l10n.chatbotThanks,
      
      // Kömək - Azerbaycanca
      'kömək': l10n.chatbotHelp,
      'yardım': l10n.chatbotHelp,
      
      // Yardım - Türkçe
      'yardım': l10n.chatbotHelp,
      'destek': l10n.chatbotHelp,
      
      // Help - İngilizce
      'help': l10n.chatbotHelp,
      'support': l10n.chatbotHelp,
      'assist': l10n.chatbotHelp,
      
      // Помощь - Rusça
      'помощь': l10n.chatbotHelp,
      'поддержка': l10n.chatbotHelp,
    };
    
    // Anahtar kelime eşleştirmesi
    for (final entry in keywords.entries) {
      if (cleanMessage.contains(entry.key)) {
        return entry.value;
      }
    }
    
    // Varsayılan cevap
    return l10n.chatbotFallback;
  }
  
  static List<String> getSampleQuestions(AppLocalizations l10n) {
    // Dil koduna göre örnek sorular
    final locale = l10n.localeName;
    
    switch (locale) {
      case 'az':
        return [
          'Təcrübən necədir?',
          'Flutter haqqında danış',
          'Hansı layihələr üzərində işləmisən?',
          'Əlaqə məlumatların',
        ];
      case 'tr':
        return [
          'Deneyimin nasıl?',
          'Flutter hakkında anlat',
          'Hangi projeler üzerinde çalıştın?',
          'İletişim bilgilerin',
        ];
      case 'ru':
        return [
          'Какой у тебя опыт?',
          'Расскажи о Flutter',
          'Над какими проектами работал?',
          'Контактная информация',
        ];
      default: // 'en'
        return [
          'What\'s your experience?',
          'Tell me about Flutter',
          'What projects have you worked on?',
          'Contact information',
        ];
    }
  }
} 