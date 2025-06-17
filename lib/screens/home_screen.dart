import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/hero_section.dart';
import '../widgets/about_section.dart';
import '../widgets/skills_section.dart';
import '../widgets/projects_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/github_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/footer_section.dart';
import '../widgets/custom_cursor.dart';
import '../widgets/chatbot_widget.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return CustomCursor(
          child: Scaffold(
            body: Stack(
              children: [
                // Ana içerik
                CustomScrollView(
                  controller: appProvider.scrollController,
                  slivers: [
                    // Navigation bar için boş alan
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 80),
                    ),
                    
                    // Hero Section
                    SliverToBoxAdapter(
                      child: Container(
                        key: appProvider.homeKey,
                        child: const HeroSection(),
                      ),
                    ),
                    
                    // About Section
                    SliverToBoxAdapter(
                      child: Container(
                        key: appProvider.aboutKey,
                        child: const AboutSection(),
                      ),
                    ),
                    
                    // Skills Section
                    SliverToBoxAdapter(
                      child: Container(
                        key: appProvider.skillsKey,
                        child: const SkillsSection(),
                      ),
                    ),
                    
                    // Projects Section
                    SliverToBoxAdapter(
                      child: Container(
                        key: appProvider.projectsKey,
                        child: const ProjectsSection(),
                      ),
                    ),
                    
                    // Experience Section
                    SliverToBoxAdapter(
                      child: Container(
                        key: appProvider.experienceKey,
                        child: const ExperienceSection(),
                      ),
                    ),
                    
                    // GitHub Section
                    SliverToBoxAdapter(
                      child: Container(
                        key: appProvider.githubKey,
                        child: const GitHubSection(),
                      ),
                    ),
                    
                    // Contact Section
                    SliverToBoxAdapter(
                      child: Container(
                        key: appProvider.contactKey,
                        child: const ContactSection(),
                      ),
                    ),
                    
                    // Footer Section
                    const SliverToBoxAdapter(
                      child: FooterSection(),
                    ),
                  ],
                ),
                
                // Sabit Navigation Bar
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: CustomNavigationBar(
                    scrollController: appProvider.scrollController,
                  ),
                ),
                
                // ChatBot Widget
                const ChatBotWidget(),
              ],
            ),
          ),
        );
      },
    );
  }
} 