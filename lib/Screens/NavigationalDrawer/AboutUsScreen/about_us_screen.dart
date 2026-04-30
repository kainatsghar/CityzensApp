import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tcs_app/custom_widgets/CustomAppButton/back_button_for_dark_background.dart';
import 'package:tcs_app/custom_widgets/GlassmorphicCard/glassmorphic_card.dart';
import 'package:tcs_app/custom_widgets/ParticleBackground/particle_background.dart';
import 'package:tcs_app/gen/assets.gen.dart';
import 'package:tcs_app/utils/app_colors.dart';

/// A premium, modern redesign of the About Us page for The City School.
/// Optimized using professional, modular components for consistency.
class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return AboutUsScreenState();
  }
}

class AboutUsScreenState extends State<AboutUsScreen>
    with TickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _particleController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // Animation controller for the continuous falling particles
    _particleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 25), // Slower, more elegant flow
    )..repeat();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.primaryBlue,
        body: Stack(
          children: [
            // 1. Shared Modular Particle Background Layer
            ParticleBackground(
              animation: _particleController,
              particleColor: AppColors.goldenYellow,
            ),

            // 2. Main Content with Parallax
            CustomScrollView(
              controller: _scrollController,
              physics: const BouncingScrollPhysics(),
              slivers: [
                // Parallax Header
                SliverAppBar(
                  expandedHeight: 280,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: const BackButtonForDarkBackground(),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Logo Parallax Effect
                        AnimatedBuilder(
                          animation: _scrollController,
                          builder: (context, child) {
                            double offset = 0;
                            if (_scrollController.hasClients) {
                              offset = _scrollController.offset * 0.45;
                            }
                            return Transform.translate(
                              offset: Offset(0, offset),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Hero(
                                    tag: 'school_logo',
                                    child: Image.asset(
                                      Assets.images.tcsLogoWhite.path,
                                      height: 120,
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Text(
                                    'THE CITY SCHOOL',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 2.2,
                                    ),
                                  ),
                                  Text(
                                    'Since 1978',
                                    style: TextStyle(
                                      color: AppColors.goldenYellow.withOpacity(
                                        0.9,
                                      ),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1.4,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // Glassmorphic Content Section using shared GlassmorphicCard
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 40),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const FadeInScrollItem(
                        child: GlassmorphicCard(
                          title: 'Overview',
                          content:
                              'Established in Karachi in 1978, The City School is today one of the largest private school networks in Pakistan with branches in all the major cities across the country. It currently has 166 schools in 49 cities with over 126,000 students in 458 owned and franchised schools.\n\nThe City School continues to expand its reach to meet the demands for quality education. The knowledge and skills-based curriculum derived from the UK national curriculum guides students from Nursery to Cambridge International Examinations (for the 16 and 18 year age group), qualifying them for the IGCSE, and O and A Level examinations. The uniform implementation of the curriculum gives parents, students, and teachers the advantage of a smooth and efficient transfer from one school to another within the system.',
                        ),
                      ),
                      const SizedBox(height: 24),
                      const FadeInScrollItem(
                        delay: 200,
                        child: GlassmorphicCard(
                          title: "Group Chairperson's Message",
                          content:
                              'Millennia ago, Socrates claimed that, “To say ‘I know’ is to close one’s mind to knowledge”. Channelling that spirit at The City School, our motto is ‘I Am To Learn’, because we too believe that learning is limitless.\n\nWe aim to develop each one of our students into true learners, individuals who always seek to broaden their perspective and to face life’s challenges with courage and conviction.\n\nFor us, education is a pursuit that goes far beyond a qualification. While we aim to help our students excel in the course they are studying, we also hope to instil in them a thirst for learning throughout their lives. At The City School, our teachers, students, and parents work together to realise this goal.\n\nGroup Chairperson',
                        ),
                      ),
                      const SizedBox(height: 24),
                      const FadeInScrollItem(
                        delay: 200,
                        child: GlassmorphicCard(
                          title: "Mission Statement",
                          content:
                              '►  OUR PHILOSOPHY\n    Continuous Human Resource Development\n\n'
                              '►  OUR GOAL\n    Academic Excellence\n\n'
                              '►  OUR COMMITMENT\n    Total Satisfaction\n\n'
                              '►  OUR CULTURE\n    Professionalism',
                        ),
                      ),
                      const SizedBox(height: 24),
                      const FadeInScrollItem(
                        delay: 200,
                        child: GlassmorphicCard(
                          title: "Facilities",
                          content:
                              '►  Purpose-built Campuses\n'
                              '►  Modern Classrooms\n'
                              '►  Science & ICT Laboratories\n'
                              '►  Art & Music Studios\n'
                              '►  Digital Computer Labs\n'
                              '►  Resourceful Libraries\n'
                              '►  Sports Complexes',
                        ),
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Helper widget to handle smooth fade-in and scale-up animations on scroll.
class FadeInScrollItem extends StatefulWidget {
  final Widget child;
  final int delay;

  const FadeInScrollItem({super.key, required this.child, this.delay = 0});

  @override
  State<FadeInScrollItem> createState() => _FadeInScrollItemState();
}

class _FadeInScrollItemState extends State<FadeInScrollItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 1.0, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.92, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeOutQuart),
      ),
    );

    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
    );
  }
}
