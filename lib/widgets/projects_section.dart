import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../providers/app_provider.dart';
import '../utils/app_theme.dart';
import '../utils/responsive_helper.dart';
import '../constants/app_constants.dart';
import '../models/project.dart';
import '../pages/project_detail_page.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

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
                    l10n.projectsTitle,
                    style: AppTheme.getHeadingMedium(appProvider.isDarkMode),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    l10n.projectsDescription,
                    style: AppTheme.getBodyLarge(appProvider.isDarkMode),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: ResponsiveHelper.getCrossAxisCount(
                        context,
                        mobile: 1,
                        tablet: 2,
                        desktop: 3,
                      ),
                      mainAxisSpacing: 30,
                      crossAxisSpacing: 30,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: 9,
                    itemBuilder: (context, index) => _AnimatedProjectCard(
                      index: index,
                      isDarkMode: appProvider.isDarkMode,
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
}

class _AnimatedProjectCard extends StatefulWidget {
  final int index;
  final bool isDarkMode;

  const _AnimatedProjectCard({
    required this.index,
    required this.isDarkMode,
  });

  @override
  State<_AnimatedProjectCard> createState() => _AnimatedProjectCardState();
}

class _AnimatedProjectCardState extends State<_AnimatedProjectCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _elevationAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.08,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _elevationAnimation = Tween<double>(
      begin: 8.0,
      end: 24.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.02,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onHover(bool isHovered) {
    setState(() {
      _isHovered = isHovered;
    });
    
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  void _navigateToProjectDetail(BuildContext context, Map<String, dynamic> projectData) {
    // Convert project data to Project model
    final project = Project(
      id: widget.index + 1,
      title: projectData['title'] as String,
      description: projectData['description'] as String,
      image: projectData['image'] as String? ?? 'assets/images/default_project.png',
      technologies: List<String>.from(projectData['technologies'] as List),
      githubUrl: 'https://github.com/alihasanov/flutter-project-${widget.index + 1}',
      liveUrl: 'https://flutter-project-${widget.index + 1}.web.app',
      featured: widget.index == 0,
      year: 2024,
    );

    // Navigate with custom page route for smooth transition
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return ProjectDetailPage(project: project);
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          // Fade transition
          const begin = 0.0;
          const end = 1.0;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return FadeTransition(
            opacity: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: const Duration(milliseconds: 600),
        reverseTransitionDuration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final projects = [
      {
        'title': 'Minannonse',
        'description': 'Gelişmiş ilanlar ve duyurular platformu. Kullanıcıların kolayca ilan oluşturabileceği ve yönetebileceği modern bir uygulama.',
        'technologies': ['Flutter', 'Firebase', 'Bloc'],
        'icon': Icons.campaign,
        'image': 'assets/images/minannonse_app.png',
      },
      {
        'title': 'TezYu',
        'description': 'Akademik tez ve araştırma projelerini yönetmek için tasarlanmış kapsamlı platform. Öğrenci ve danışman etkileşimi.',
        'technologies': ['Flutter', 'REST API', 'Provider'],
        'icon': Icons.school,
        'image': 'assets/images/tezyu_app.png',
      },
      {
        'title': 'NextGeneration',
        'description': 'Yeni nesil teknoloji çözümleri sunan inovatif platform. Kullanıcı deneyimini önceleyen modern tasarım.',
        'technologies': ['Flutter Web', 'GraphQL', 'Riverpod'],
        'icon': Icons.rocket_launch,
        'image': 'assets/images/next_generation_app.png',
      },
      {
        'title': 'Zulamed',
        'description': 'Sağlık sektörüne yönelik dijital çözümler platformu. Hasta takibi ve randevu yönetimi sistemi.',
        'technologies': ['Flutter', 'Firebase', 'GetX'],
        'icon': Icons.medical_services,
        'image': 'assets/images/zulamed_app.png',
      },
      {
        'title': 'Emiland',
        'description': 'Emlak sektörü için kapsamlı yönetim sistemi. Gayrimenkul listeleme, takip ve analiz araçları.',
        'technologies': ['Flutter', 'PostgreSQL', 'Bloc'],
        'icon': Icons.home_work,
        'image': 'assets/images/emiland_app.png',
      },
      {
        'title': 'Superfon',
        'description': 'Gelişmiş telefon ve iletişim yönetimi uygulaması. Çoklu hat desteği ve akıllı çağrı yönlendirme.',
        'technologies': ['Flutter', 'WebRTC', 'Provider'],
        'icon': Icons.phone_in_talk,
        'image': 'assets/images/superfon_app.png',
      },
      {
        'title': 'Yurd',
        'description': 'Öğrenci yurt ve konaklama yönetim sistemi. Rezervasyon, ödeme ve olanaklar takibi.',
        'technologies': ['Flutter', 'MongoDB', 'Riverpod'],
        'icon': Icons.apartment,
        'image': 'assets/images/yurd_app.png',
      },
      {
        'title': 'Paytolia',
        'description': 'Güvenli ve hızlı dijital ödeme çözümleri platformu. Çoklu para birimi desteği ve güvenli işlemler.',
        'technologies': ['Flutter', 'Stripe', 'Bloc'],
        'icon': Icons.payment,
        'image': 'assets/images/paytolia_app.png',
      },
      {
        'title': 'Bonpini',
        'description': 'Akıllı taksi çağırma ve ulaşım yönetimi uygulaması. GPS takibi ve gerçek zamanlı konum paylaşımı.',
        'technologies': ['Flutter', 'Google Maps', 'Provider'],
        'icon': Icons.local_taxi,
        'image': 'assets/images/bonpini_app.png',
      },
    ];

    final project = projects[widget.index];

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Transform.rotate(
              angle: _rotationAnimation.value,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                transform: Matrix4.identity()
                  ..translate(0.0, _isHovered ? -12.0 : 0.0, 0.0),
                child: Card(
                  color: AppTheme.getCardColor(widget.isDarkMode),
                  elevation: _elevationAnimation.value,
                  shadowColor: AppTheme.primaryColor.withOpacity(_isHovered ? 0.4 : 0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(
                      color: _isHovered 
                          ? AppTheme.primaryColor.withOpacity(0.6)
                          : AppTheme.primaryColor.withOpacity(0.1),
                      width: _isHovered ? 2 : 1,
                    ),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: _isHovered 
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.primaryColor.withOpacity(0.08),
                                AppTheme.primaryColor.withOpacity(0.03),
                              ],
                            )
                          : null,
                    ),
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Project Icon/Image
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          height: 160,
                          decoration: BoxDecoration(
                            color: _isHovered 
                                ? AppTheme.primaryColor.withOpacity(0.15)
                                : AppTheme.primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: _isHovered 
                                  ? AppTheme.primaryColor.withOpacity(0.4)
                                  : AppTheme.primaryColor.withOpacity(0.3),
                              width: _isHovered ? 2 : 1,
                            ),
                            boxShadow: _isHovered ? [
                              BoxShadow(
                                color: AppTheme.primaryColor.withOpacity(0.2),
                                blurRadius: 16,
                                spreadRadius: 2,
                              ),
                            ] : null,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(14),
                            child: project['image'] != null
                                ? Image.asset(
                                    project['image'] as String,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Center(
                                        child: TweenAnimationBuilder<double>(
                                          duration: const Duration(milliseconds: 400),
                                          tween: Tween<double>(
                                            begin: 0.0,
                                            end: _isHovered ? 1.0 : 0.0,
                                          ),
                                          builder: (context, value, child) {
                                            return Transform.scale(
                                              scale: 1.0 + (value * 0.2),
                                              child: Icon(
                                                project['icon'] as IconData,
                                                size: 60 + (value * 12),
                                                color: AppTheme.primaryColor,
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  )
                                : Center(
                                    child: TweenAnimationBuilder<double>(
                                      duration: const Duration(milliseconds: 400),
                                      tween: Tween<double>(
                                        begin: 0.0,
                                        end: _isHovered ? 1.0 : 0.0,
                                      ),
                                      builder: (context, value, child) {
                                        return Transform.scale(
                                          scale: 1.0 + (value * 0.2),
                                          child: Icon(
                                            project['icon'] as IconData,
                                            size: 60 + (value * 12),
                                            color: AppTheme.primaryColor,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // Project Title
                        AnimatedDefaultTextStyle(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutCubic,
                          style: AppTheme.getHeadingSmall(widget.isDarkMode).copyWith(
                            color: _isHovered 
                                ? AppTheme.primaryColor
                                : AppTheme.getTextPrimaryColor(widget.isDarkMode),
                            fontSize: _isHovered ? 20 : 18,
                            fontWeight: _isHovered ? FontWeight.w700 : FontWeight.w600,
                          ),
                          child: Text(
                            project['title'] as String,
                          ),
                        ),
                        const SizedBox(height: 12),
                        
                        // Project Description
                        Text(
                          project['description'] as String,
                          style: AppTheme.getBodySmall(widget.isDarkMode).copyWith(
                            height: 1.5,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 20),
                        
                        // Technologies
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: (project['technologies'] as List<String>).map((tech) {
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: _isHovered 
                                    ? AppTheme.primaryColor.withOpacity(0.15)
                                    : AppTheme.primaryColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _isHovered 
                                      ? AppTheme.primaryColor.withOpacity(0.4)
                                      : AppTheme.primaryColor.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                tech,
                                style: AppTheme.getBodySmall(widget.isDarkMode).copyWith(
                                  color: AppTheme.primaryColor,
                                  fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        const Spacer(),
                        
                        // Action Buttons
                        Row(
                          children: [
                            Expanded(
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 400),
                                curve: Curves.easeOutCubic,
                                child: ElevatedButton.icon(
                                  onPressed: () => _navigateToProjectDetail(context, project),
                                  icon: Icon(
                                    Icons.visibility,
                                    size: _isHovered ? 18 : 16,
                                  ),
                                  label: Text(
                                    l10n.viewProject,
                                    style: TextStyle(
                                      fontSize: _isHovered ? 14 : 13,
                                      fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _isHovered 
                                        ? AppTheme.primaryColor
                                        : AppTheme.primaryColor.withOpacity(0.9),
                                    foregroundColor: Colors.white,
                                    elevation: _isHovered ? 8 : 4,
                                    shadowColor: AppTheme.primaryColor.withOpacity(0.4),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 400),
                              curve: Curves.easeOutCubic,
                              child: IconButton(
                                onPressed: () {},
                                icon: Icon(
                                  Icons.code,
                                  size: _isHovered ? 24 : 20,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor: _isHovered 
                                      ? AppTheme.primaryColor.withOpacity(0.15)
                                      : AppTheme.primaryColor.withOpacity(0.1),
                                  foregroundColor: AppTheme.primaryColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    side: BorderSide(
                                      color: AppTheme.primaryColor.withOpacity(_isHovered ? 0.4 : 0.3),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
} 