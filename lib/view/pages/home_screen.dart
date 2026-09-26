import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import '../../core/theme/app_colors.dart';
import '../../core/utils/launcher.dart';
import '../../core/utils/smooth_scroll.dart';
import '../../core/widgets/journey_motion.dart';
import '../../data/content.dart';
import '../../data/data.dart';
import '../../data/item_model.dart';
import '../widget/custom_image.dart';
import '../widget/project_details_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
    this.initialSection,
    required this.themeMode,
    required this.onThemeToggle,
  });

  final String? initialSection;
  final ThemeMode themeMode;
  final VoidCallback onThemeToggle;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  late final JourneyScrollState _journey;
  final _keyboardFocus = FocusNode(debugLabel: 'portfolio-shortcuts');
  final _aboutKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _coursesKey = GlobalKey();
  final _experienceKey = GlobalKey();
  final _skillsKey = GlobalKey();
  final _contactKey = GlobalKey();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _showAllProjects = false;
  String _lastRoutedSection = 'about';

  @override
  void initState() {
    super.initState();
    _journey = JourneyScrollState(_scrollController)
      ..register('about', _aboutKey)
      ..register('projects', _projectsKey)
      ..register('courses', _coursesKey)
      ..register('experience', _experienceKey)
      ..register('skills', _skillsKey)
      ..register('contact', _contactKey)
      ..addListener(_onJourneyChanged)
      ..attach();
    _scheduleInitialSectionScroll();
    WidgetsBinding.instance.addPostFrameCallback((_) => _journey.update());
  }

  @override
  void didUpdateWidget(covariant HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSection != widget.initialSection) {
      _scheduleInitialSectionScroll();
    }
  }

  @override
  void dispose() {
    _journey
      ..removeListener(_onJourneyChanged)
      ..detach()
      ..dispose();
    _keyboardFocus.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onJourneyChanged() {
    if (!mounted) return;
    final section = _journey.activeSection;
    if (section != _lastRoutedSection) {
      _lastRoutedSection = section;
      final uri = section == 'about' ? Uri.parse('/') : Uri.parse('/$section');
      SystemNavigator.routeInformationUpdated(uri: uri, replace: true);
    }
  }

  Future<void> _scrollTo(GlobalKey key) async {
    final context = key.currentContext;
    if (context == null) return;

    final renderObject = context.findRenderObject();
    if (renderObject is! RenderBox) return;

    final viewport = RenderAbstractViewport.of(renderObject);

    // Get the offset to reveal the section at the top of the viewport
    final revealedOffset = viewport.getOffsetToReveal(renderObject, 0.0);

    // Subtract a bit of space for the pinned header (approx 80px)
    final targetOffset = (revealedOffset.offset - 86).clamp(
      0.0,
      _scrollController.position.maxScrollExtent,
    );

    await _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOutQuart,
    );
  }

  void _scheduleInitialSectionScroll() {
    final section = widget.initialSection;
    if (section == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      await _scrollTo(_keyForSection(section));
    });
  }

  void _goHome() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOutQuart,
    );
    SystemNavigator.routeInformationUpdated(uri: Uri.parse('/'), replace: true);
    _lastRoutedSection = 'about';
  }

  void _goToSection(String section) {
    _scrollTo(_keyForSection(section));
    SystemNavigator.routeInformationUpdated(
      uri: Uri.parse('/$section'),
      replace: true,
    );
    _lastRoutedSection = section;
  }

  void _handleKey(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.keyK &&
        (HardwareKeyboard.instance.isMetaPressed ||
            HardwareKeyboard.instance.isControlPressed)) {
      _showCommandPalette();
    }
  }

  void _showCommandPalette() {
    showDialog<void>(
      context: context,
      barrierColor: Colors.black.withValues(alpha: .62),
      builder: (context) => _CommandPalette(
        colors: _PortfolioColors.from(context),
        onNavigate: (section) {
          Navigator.of(context).pop();
          _goToSection(section);
        },
        onThemeToggle: () {
          Navigator.of(context).pop();
          widget.onThemeToggle();
        },
      ),
    );
  }

  GlobalKey _keyForSection(String section) {
    switch (section) {
      case 'about':
        return _aboutKey;
      case 'projects':
        return _projectsKey;
      case 'courses':
        return _coursesKey;
      case 'experience':
        return _experienceKey;
      case 'skills':
        return _skillsKey;
      case 'contact':
        return _contactKey;
      default:
        return _aboutKey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = _PortfolioColors.from(context);

    return KeyboardListener(
      focusNode: _keyboardFocus,
      autofocus: true,
      onKeyEvent: _handleKey,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: colors.background,
        endDrawer: _MobileDrawer(
          colors: colors,
          onAboutTap: () => _goToSection('about'),
          onProjectsTap: () => _goToSection('projects'),
          onCoursesTap: () => _goToSection('courses'),
          onExperienceTap: () => _goToSection('experience'),
          onSkillsTap: () => _goToSection('skills'),
          onContactTap: () => _goToSection('contact'),
        ),
        body: Stack(
          children: [
            Positioned.fill(
              child: CustomPaint(
                painter: _GridBackgroundPainter(colors: colors),
              ),
            ),
            AnimatedBuilder(
              animation: _journey,
              builder: (context, _) => SmoothScroll(
                controller: _scrollController,
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  slivers: [
                    SliverPersistentHeader(
                      pinned: true,
                      delegate: _NavHeaderDelegate(
                        colors: colors,
                        isDark: widget.themeMode == ThemeMode.dark,
                        onThemeToggle: widget.onThemeToggle,
                        onLogoTap: _goHome,
                        onAboutTap: () => _goToSection('about'),
                        onProjectsTap: () => _goToSection('projects'),
                        onCoursesTap: () => _goToSection('courses'),
                        onExperienceTap: () => _goToSection('experience'),
                        onSkillsTap: () => _goToSection('skills'),
                        onContactTap: () => _goToSection('contact'),
                        onCommandTap: _showCommandPalette,
                        onMenuTap: () =>
                            _scaffoldKey.currentState?.openEndDrawer(),
                        activeSection: _journey.activeSection,
                        pageProgress: _journey.pageProgress,
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1240),
                          child: Padding(
                            padding: _pagePadding(context),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _HeroSection(
                                  key: _aboutKey,
                                  colors: colors,
                                  scrollController: _scrollController,
                                ),
                                _SectionGap.large(),
                                JourneyReveal(
                                  controller: _scrollController,
                                  child: _MetricsSection(
                                    colors: colors,
                                    animate:
                                        _journey.sectionProgress['about']! > .2,
                                  ),
                                ),
                                _SectionGap.large(),
                                JourneyReveal(
                                  controller: _scrollController,
                                  child: _ProjectsSection(
                                    key: _projectsKey,
                                    colors: colors,
                                    showAllProjects: _showAllProjects,
                                    onToggleProjects: () {
                                      setState(() {
                                        _showAllProjects = !_showAllProjects;
                                      });
                                    },
                                  ),
                                ),
                                if (courses.isNotEmpty) ...[
                                  _SectionGap.large(),
                                  JourneyReveal(
                                    controller: _scrollController,
                                    child: _CoursesSection(
                                        key: _coursesKey, colors: colors),
                                  ),
                                ],
                                if (packages.isNotEmpty) ...[
                                  _SectionGap.large(),
                                  JourneyReveal(
                                    controller: _scrollController,
                                    child: _PackageSection(colors: colors),
                                  ),
                                ],
                                _SectionGap.large(),
                                JourneyReveal(
                                  controller: _scrollController,
                                  child: _ExperienceSection(
                                    key: _experienceKey,
                                    colors: colors,
                                    progress:
                                        _journey.sectionProgress['experience']!,
                                  ),
                                ),
                                _SectionGap.large(),
                                JourneyReveal(
                                  controller: _scrollController,
                                  child: _SkillsSection(
                                      key: _skillsKey, colors: colors),
                                ),
                                _SectionGap.large(),
                                JourneyReveal(
                                  controller: _scrollController,
                                  child: _ContactSection(
                                      key: _contactKey, colors: colors),
                                ),
                                const SizedBox(height: 32),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  EdgeInsets _pagePadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1100) {
      return const EdgeInsets.fromLTRB(28, 34, 28, 0);
    }
    if (width >= 720) {
      return const EdgeInsets.fromLTRB(22, 26, 22, 0);
    }
    return const EdgeInsets.fromLTRB(16, 20, 16, 0);
  }
}

class _HeroSection extends StatefulWidget {
  const _HeroSection({
    super.key,
    required this.colors,
    required this.scrollController,
  });

  final _PortfolioColors colors;
  final ScrollController scrollController;

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection>
    with SingleTickerProviderStateMixin {
  late final AnimationController _bootController;

  _PortfolioColors get colors => widget.colors;

  @override
  void initState() {
    super.initState();
    _bootController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1250),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _bootController.forward();
    });
  }

  @override
  void dispose() {
    _bootController.dispose();
    super.dispose();
  }

  Widget _boot(Widget child, int index) {
    if (MediaQuery.maybeOf(context)?.disableAnimations ?? false) return child;
    final start = (index * .11).clamp(0.0, .75);
    final animation = CurvedAnimation(
      parent: _bootController,
      curve: Interval(start, (start + .35).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic),
    );
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween(begin: const Offset(0, .16), end: Offset.zero)
            .animate(animation),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isWide = width >= 980;
    final titleSize = width >= 980 ? 62.0 : (width >= 620 ? 48.0 : 38.0);
    final horizontalPadding = width >= 1100 ? 18.0 : 0.0;

    final intro = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _boot(
            _Eyebrow(
              colors: colors,
              label: 'Available for high-impact backend roles',
              icon: Icons.terminal_rounded,
            ),
            0),
        SizedBox(height: width >= 620 ? 26 : 20),
        _boot(
            Text(
              "Hello, I'm",
              style: TextStyle(
                color: colors.accent,
                fontFamily: 'Barlow',
                fontSize: width >= 620 ? 24 : 19,
                fontWeight: FontWeight.w700,
              ),
            ),
            1),
        const SizedBox(height: 8),
        _boot(
            Text(
              'Eslam Mohamed Ragab',
              style: TextStyle(
                color: colors.text,
                fontFamily: 'Nunito-ExtraBold',
                fontSize: titleSize,
                height: 0.98,
                letterSpacing: 0,
              ),
            ),
            2),
        const SizedBox(height: 18),
        _boot(_RoleLine(colors: colors), 3),
        const SizedBox(height: 20),
        _boot(
            Text(
              'I build scalable web applications and high-performance APIs '
              'with PHP, Laravel, MySQL, and RESTful architecture. From system '
              'design to delivery, I help teams ship maintainable backend products.',
              style: TextStyle(
                color: colors.muted,
                fontSize: width >= 620 ? 17 : 15,
                height: 1.65,
                fontWeight: FontWeight.w500,
              ),
            ),
            4),
        const SizedBox(height: 20),
        _boot(
          Wrap(
            spacing: 9,
            runSpacing: 9,
            children: [
              _HeroProofChip(
                colors: colors,
                icon: Icons.rocket_launch_outlined,
                label: '30+ delivered projects',
              ),
              _HeroProofChip(
                colors: colors,
                icon: Icons.groups_2_outlined,
                label: '5.5+ years experience',
              ),
              _HeroProofChip(
                colors: colors,
                icon: Icons.hub_outlined,
                label: 'Team leadership',
              ),
            ],
          ),
          5,
        ),
        const SizedBox(height: 24),
        _boot(
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _ActionButton(
                  colors: colors,
                  label: 'View LinkedIn',
                  icon: Icons.badge_rounded,
                  filled: true,
                  onTap: () => Launcher.open(
                    'https://www.linkedin.com/in/eslam-mohamed-ragab-81332528b/',
                  ),
                ),
                _ActionButton(
                  colors: colors,
                  label: 'View GitHub',
                  icon: Icons.open_in_new_rounded,
                  onTap: () =>
                      Launcher.open('https://github.com/eslamandroid12345'),
                ),
              ],
            ),
            6),
        const SizedBox(height: 18),
        _boot(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.location_on_outlined, color: colors.accent, size: 17),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Egypt · Available for remote and hybrid opportunities',
                  style: TextStyle(
                    color: colors.muted,
                    fontFamily: 'Barlow',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          7,
        ),
      ],
    );

    final visual = _boot(
      PointerTilt(
        maxTilt: .012,
        child: _HeroVisualStage(
          colors: colors,
          child: _DeveloperConsole(colors: colors),
        ),
      ),
      4,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        width >= 980 ? 24 : 10,
        horizontalPadding,
        0,
      ),
      child: isWide
          ? IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(flex: 12, child: intro),
                  const SizedBox(width: 54),
                  Expanded(flex: 9, child: visual),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                intro,
                const SizedBox(height: 28),
                visual,
              ],
            ),
    );
  }
}

class _HeroVisualStage extends StatelessWidget {
  const _HeroVisualStage({
    required this.colors,
    required this.child,
  });

  final _PortfolioColors colors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          left: -32,
          top: 42,
          child: IgnorePointer(
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    colors.accent.withValues(alpha: .2),
                    colors.accent.withValues(alpha: 0),
                  ],
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}

class _HeroProofChip extends StatelessWidget {
  const _HeroProofChip({
    required this.colors,
    required this.icon,
    required this.label,
  });

  final _PortfolioColors colors;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: .64),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colors.accent, size: 16),
          const SizedBox(width: 7),
          Text(
            label,
            style: TextStyle(
              color: colors.text,
              fontFamily: 'Barlow',
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _DeveloperConsole extends StatelessWidget {
  const _DeveloperConsole({required this.colors});

  final _PortfolioColors colors;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 620;
    return Container(
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.86),
        border: Border.all(color: colors.border),
        boxShadow: [
          BoxShadow(
            color: colors.shadow,
            blurRadius: 34,
            offset: const Offset(0, 22),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            height: 46,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: colors.border)),
            ),
            child: Row(
              children: [
                _WindowDot(color: const Color(0xffff5f57)),
                _WindowDot(color: const Color(0xffffbd2e)),
                _WindowDot(color: const Color(0xff28c840)),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'eslam@portfolio:~',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.muted,
                      fontFamily: 'Barlow',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Icon(Icons.lock_rounded, size: 16, color: colors.accent),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(compact ? 12 : 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _ProfileVisual(colors: colors),
                SizedBox(height: compact ? 12 : 16),
                _TerminalBlock(
                  colors: colors,
                  title: 'cat ./profile/summary.txt',
                  lines: const [
                    'Senior Back-End Developer',
                    'PHP, Laravel, MySQL, RESTful APIs',
                    'Building scalable web systems and backend products',
                  ],
                ),
                SizedBox(height: compact ? 12 : 16),
                Row(
                  children: [
                    Expanded(
                      child: _MiniMetric(
                        colors: colors,
                        label: 'Experience',
                        value: '5.5+',
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _MiniMetric(
                        colors: colors,
                        label: 'Projects',
                        value: '30+',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileVisual extends StatelessWidget {
  const _ProfileVisual({required this.colors});

  final _PortfolioColors colors;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final compact = width < 620;
    return AspectRatio(
      aspectRatio: compact ? 1.08 : 1.3,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
              painter: _GridBackgroundPainter(colors: colors, tight: true)),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.accent.withValues(alpha: 0.24),
                    colors.surfaceSoft.withValues(alpha: 0.72),
                    colors.surface,
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              width: compact ? 152 : 190,
              height: compact ? 200 : 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: colors.accent.withValues(alpha: .52),
                ),
                boxShadow: [
                  BoxShadow(
                    color: colors.shadow,
                    blurRadius: 24,
                    offset: const Offset(0, 16),
                  ),
                  BoxShadow(
                    color: colors.accent.withValues(alpha: .14),
                    blurRadius: 32,
                  ),
                ],
              ),
              child: ClipRRect(
                child: CustomImage(
                  image: 'assets/images/my.jpeg',
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
          ),
          Positioned(
            left: compact ? 10 : 16,
            bottom: compact ? 10 : 16,
            child: _StatusBadge(colors: colors, label: 'Open to work'),
          ),
          Positioned(
            right: compact ? 10 : 16,
            top: compact ? 10 : 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
              decoration: BoxDecoration(
                color: colors.surface.withValues(alpha: .88),
                border: Border.all(color: colors.border),
              ),
              child: Text(
                'PHP · LARAVEL',
                style: TextStyle(
                  color: colors.accent,
                  fontFamily: 'Barlow',
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetricsSection extends StatelessWidget {
  const _MetricsSection({required this.colors, required this.animate});

  final _PortfolioColors colors;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    final metrics = [
      const _MetricData(
        value: '5.5+',
        label: 'Years in backend',
        hint: 'Scalable systems, APIs, architecture, and delivery.',
        icon: Icons.work_outline_rounded,
      ),
      const _MetricData(
        value: '30+',
        label: 'Projects delivered',
        hint: 'Complex projects shipped on time and within budget.',
        icon: Icons.account_tree_rounded,
      ),
      const _MetricData(
        value: 'API',
        label: 'Backend focus',
        hint: 'PHP, Laravel, MySQL, and RESTful API development.',
        icon: Icons.api_rounded,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 980
            ? 3
            : constraints.maxWidth >= 620
                ? 2
                : 1;

        return _ResponsiveGrid(
          columns: columns,
          spacing: 12,
          children: [
            for (final metric in metrics)
              _MetricTile(colors: colors, metric: metric, animate: animate),
          ],
        );
      },
    );
  }
}

class _ProjectsSection extends StatelessWidget {
  const _ProjectsSection({
    super.key,
    required this.colors,
    required this.showAllProjects,
    required this.onToggleProjects,
  });

  final _PortfolioColors colors;
  final bool showAllProjects;
  final VoidCallback onToggleProjects;

  @override
  Widget build(BuildContext context) {
    final visibleProjects =
        showAllProjects ? projects : projects.take(8).toList(growable: false);

    return _SectionShell(
      colors: colors,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            colors: colors,
            eyebrow: 'Selected builds',
            title: 'Backend and product portfolio',
            body:
                'Projects from Eslam\'s live portfolio, including dashboards, APIs, marketplaces, education systems, ERP tools, and mobile-backed platforms.',
          ),
          const SizedBox(height: 26),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 1120
                  ? 3
                  : constraints.maxWidth >= 700
                      ? 2
                      : 1;

              return _ResponsiveGrid(
                columns: columns,
                spacing: 14,
                children: [
                  for (final entry in visibleProjects)
                    _ProjectCaseCard(colors: colors, item: entry),
                ],
              );
            },
          ),
          const SizedBox(height: 22),
          Align(
            alignment: Alignment.centerLeft,
            child: _ActionButton(
              colors: colors,
              label: showAllProjects ? 'Show less' : 'Show all projects',
              icon: showAllProjects
                  ? Icons.keyboard_arrow_up_rounded
                  : Icons.keyboard_arrow_down_rounded,
              onTap: onToggleProjects,
            ),
          ),
        ],
      ),
    );
  }
}

class _CoursesSection extends StatelessWidget {
  const _CoursesSection({
    super.key,
    required this.colors,
  });

  final _PortfolioColors colors;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      colors: colors,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            colors: colors,
            eyebrow: 'Teaching log',
            title: 'Courses and technical content',
            body:
                'Your Arabic course material and Flutter instruction are treated as portfolio assets, not side notes.',
          ),
          const SizedBox(height: 26),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 980
                  ? 4
                  : constraints.maxWidth >= 680
                      ? 2
                      : 1;

              return _ResponsiveGrid(
                columns: columns,
                spacing: 14,
                children: [
                  for (final course in courses)
                    _LearningCard(colors: colors, item: course),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PackageSection extends StatelessWidget {
  const _PackageSection({required this.colors});

  final _PortfolioColors colors;

  @override
  Widget build(BuildContext context) {
    if (packages.isEmpty) return const SizedBox.shrink();

    final package = packages.first;

    return _SectionShell(
      colors: colors,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            colors: colors,
            eyebrow: 'Open source',
            title: 'Flutter package work',
            body:
                'A product-minded package section for your reusable Flutter work and documentation links.',
          ),
          const SizedBox(height: 26),
          _PackageFeature(colors: colors, item: package),
        ],
      ),
    );
  }
}

class _ExperienceSection extends StatelessWidget {
  const _ExperienceSection({
    super.key,
    required this.colors,
    required this.progress,
  });

  final _PortfolioColors colors;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      colors: colors,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _ExperienceLogTitle(
            colors: colors,
            title: 'EXECUTION_LOGS',
            body:
                'Roles, leadership, product delivery, and education from your existing content file.',
          ),
          const SizedBox(height: 24),
          _TerminalLogPanel(
            colors: colors,
            command: 'cat /var/log/career_history.log',
            items: Content.experience,
            progress: progress,
          ),
          const SizedBox(height: 18),
          _ExperienceMiniTitle(colors: colors, title: 'EDUCATION_LOG'),
          const SizedBox(height: 12),
          _TerminalLogPanel(
            colors: colors,
            command: 'cat /var/log/education.log',
            items: Content.education,
            compact: true,
          ),
        ],
      ),
    );
  }
}

class _SkillsSection extends StatelessWidget {
  const _SkillsSection({
    super.key,
    required this.colors,
  });

  final _PortfolioColors colors;

  @override
  Widget build(BuildContext context) {
    final entries = Content.skills.entries.toList(growable: false);

    return _SectionShell(
      colors: colors,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            colors: colors,
            eyebrow: 'Stack map',
            title: 'Tools you ship with',
            body:
                'Grouped by backend architecture, APIs, database work, leadership, deployment, and collaboration.',
          ),
          const SizedBox(height: 24),
          for (var i = 0; i < entries.length; i++)
            _SkillRow(
              colors: colors,
              index: i,
              title: entries[i].key,
              skills: entries[i].value,
            ),
        ],
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({
    super.key,
    required this.colors,
  });

  final _PortfolioColors colors;

  @override
  Widget build(BuildContext context) {
    return _SectionShell(
      colors: colors,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionHeader(
            colors: colors,
            eyebrow: 'Open channels',
            title: "Let's build something solid",
            body: 'Confirmed public channels from Eslam\'s portfolio metadata.',
          ),
          const SizedBox(height: 26),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _ActionButton(
                colors: colors,
                label: 'LinkedIn',
                icon: Icons.badge_rounded,
                filled: true,
                onTap: () => Launcher.open(
                  'https://www.linkedin.com/in/eslam-mohamed-ragab-81332528b/',
                ),
              ),
              _ActionButton(
                colors: colors,
                label: 'GitHub',
                icon: Icons.terminal_rounded,
                onTap: () =>
                    Launcher.open('https://github.com/eslamandroid12345'),
              ),
              _ActionButton(
                colors: colors,
                label: 'Portfolio',
                icon: Icons.language_rounded,
                onTap: () => Launcher.open(
                  'https://eslam-mohamed-ragab.techno-saas.com/',
                ),
              ),
            ],
          ),
          const SizedBox(height: 34),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: colors.border)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                '© ${DateTime.now().year} Eslam Mohamed Ragab. All rights reserved.',
                style: TextStyle(
                  color: colors.muted,
                  fontSize: 13,
                  fontFamily: 'Barlow',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProjectCaseCard extends StatefulWidget {
  const _ProjectCaseCard({
    required this.colors,
    required this.item,
  });

  final _PortfolioColors colors;
  final ItemModel item;

  @override
  State<_ProjectCaseCard> createState() => _ProjectCaseCardState();
}

class _ProjectCaseCardState extends State<_ProjectCaseCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return PointerTilt(
      cursor: SystemMouseCursors.click,
      onHoverChanged: (hovered) => setState(() => _hovered = hovered),
      child: GestureDetector(
        onTap: () => _showItemDetails(context, widget.item),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: widget.colors.surface.withValues(alpha: 0.78),
            border: Border.all(
              color: _hovered ? widget.colors.accent : widget.colors.border,
            ),
            boxShadow: [
              if (_hovered)
                BoxShadow(
                  color: widget.colors.accent.withValues(alpha: 0.14),
                  blurRadius: 26,
                  offset: const Offset(0, 16),
                ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 16 / 10,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: widget.colors.surfaceSoft,
                    border: Border(
                      bottom: BorderSide(color: widget.colors.border),
                    ),
                  ),
                  child: ClipRect(
                    child: AnimatedScale(
                      scale: _hovered ? 1.045 : 1,
                      duration: const Duration(milliseconds: 420),
                      curve: Curves.easeOutCubic,
                      child: CustomImage(
                        image: widget.item.image,
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            widget.item.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: widget.colors.text,
                              fontFamily: 'Nunito-ExtraBold',
                              fontSize: 20,
                              height: 1.1,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          _hovered
                              ? Icons.arrow_forward_rounded
                              : Icons.north_east_rounded,
                          color: widget.colors.accent,
                          size: 18,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _summary(widget.item.description, maxLength: 128),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textDirection: _textDirection(widget.item.description),
                      style: TextStyle(
                        color: widget.colors.muted,
                        fontSize: 14,
                        height: 1.55,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        if (widget.item.googlePlay != null)
                          _TinyChip(
                              colors: widget.colors, label: 'Google Play'),
                        if (widget.item.appleStore != null)
                          _TinyChip(colors: widget.colors, label: 'App Store'),
                        if (widget.item.huaweiStore != null)
                          _TinyChip(colors: widget.colors, label: 'AppGallery'),
                        if (widget.item.youtubeLink != null)
                          _TinyChip(colors: widget.colors, label: 'YouTube'),
                        if (widget.item.url.isNotEmpty)
                          _TinyChip(colors: widget.colors, label: 'Live'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LearningCard extends StatefulWidget {
  const _LearningCard({
    required this.colors,
    required this.item,
  });

  final _PortfolioColors colors;
  final ItemModel item;

  @override
  State<_LearningCard> createState() => _LearningCardState();
}

class _LearningCardState extends State<_LearningCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: () => _showItemDetails(context, widget.item),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(
            color: widget.colors.surface.withValues(alpha: 0.78),
            border: Border.all(
              color: _hovered ? widget.colors.accent : widget.colors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AspectRatio(
                aspectRatio: 16 / 11,
                child: CustomImage(
                  image: widget.item.image,
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TinyChip(colors: widget.colors, label: 'Course'),
                    const SizedBox(height: 10),
                    Text(
                      widget.item.name.trim(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: widget.colors.text,
                        fontFamily: 'Nunito-ExtraBold',
                        fontSize: 17,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      _summary(widget.item.description, maxLength: 110),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      textDirection: _textDirection(widget.item.description),
                      style: TextStyle(
                        color: widget.colors.muted,
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PackageFeature extends StatelessWidget {
  const _PackageFeature({
    required this.colors,
    required this.item,
  });

  final _PortfolioColors colors;
  final ItemModel item;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 840;
    final image = Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceSoft,
        border: Border.all(color: colors.border),
      ),
      child: AspectRatio(
        aspectRatio: 4 / 3,
        child: CustomImage(
          image: item.image,
          fit: BoxFit.contain,
        ),
      ),
    );

    final details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _TinyChip(colors: colors, label: 'Laravel'),
            _TinyChip(colors: colors, label: 'REST API'),
            _TinyChip(colors: colors, label: 'MySQL'),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          item.name,
          style: TextStyle(
            color: colors.text,
            fontFamily: 'Nunito-ExtraBold',
            fontSize: isWide ? 36 : 28,
            height: 1,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          _summary(item.description, maxLength: 260),
          textDirection: _textDirection(item.description),
          style: TextStyle(
            color: colors.muted,
            fontSize: 15,
            height: 1.65,
          ),
        ),
        if (item.highlights != null) ...[
          const SizedBox(height: 18),
          for (final highlight in item.highlights!.take(4))
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: colors.accent, size: 18),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Text(
                      highlight,
                      style: TextStyle(color: colors.text, height: 1.45),
                    ),
                  ),
                ],
              ),
            ),
        ],
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            if (item.url.isNotEmpty)
              _ActionButton(
                colors: colors,
                label: 'pub.dev',
                icon: Icons.open_in_new_rounded,
                filled: true,
                onTap: () => Launcher.open(item.url),
              ),
            if (item.docsLink != null)
              _ActionButton(
                colors: colors,
                label: 'Docs',
                icon: Icons.menu_book_rounded,
                onTap: () => Launcher.open(item.docsLink!),
              ),
          ],
        ),
      ],
    );

    return isWide
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 270, child: image),
              const SizedBox(width: 26),
              Expanded(child: details),
            ],
          )
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              image,
              const SizedBox(height: 20),
              details,
            ],
          );
  }
}

class _ExperienceLogTitle extends StatelessWidget {
  const _ExperienceLogTitle({
    required this.colors,
    required this.title,
    required this.body,
  });

  final _PortfolioColors colors;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 720;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 980),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.graphic_eq_rounded, size: 22, color: colors.accent),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: colors.text,
                  fontFamily: 'Barlow',
                  fontSize: isWide ? 24 : 20,
                  fontWeight: FontWeight.w900,
                  letterSpacing: isWide ? 2.8 : 2.0,
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Container(
                  height: 1,
                  color: colors.border,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: colors.accent, width: 2)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                body,
                style: TextStyle(
                  color: colors.muted,
                  fontFamily: 'Barlow',
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TerminalLogPanel extends StatelessWidget {
  const _TerminalLogPanel({
    required this.colors,
    required this.command,
    required this.items,
    this.compact = false,
    this.progress = 1,
  });

  final _PortfolioColors colors;
  final String command;
  final List<Map<String, String>> items;
  final bool compact;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.9),
        border: Border.all(color: colors.border),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: colors.shadow.withValues(alpha: 0.16),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          _TerminalWindowBar(colors: colors, command: command),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: compact ? 18 : 22,
              vertical: compact ? 10 : 14,
            ),
            child: Column(
              children: [
                for (var index = 0; index < items.length; index++)
                  AnimatedOpacity(
                    opacity:
                        compact || progress > (index + 1) / (items.length + 2)
                            ? 1
                            : .28,
                    duration: const Duration(milliseconds: 420),
                    child: _TerminalLogItem(
                      colors: colors,
                      index: index,
                      data: items[index],
                      compact: compact,
                      isLast: index == items.length - 1,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TerminalWindowBar extends StatelessWidget {
  const _TerminalWindowBar({
    required this.colors,
    required this.command,
  });

  final _PortfolioColors colors;
  final String command;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colors.surfaceSoft.withValues(alpha: 0.68),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Row(
        children: [
          for (final color in const [
            Color(0xffFF5F57),
            Color(0xffFEBC2E),
            Color(0xff28C840),
          ]) ...[
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            if (color != Color(0xff28C840)) const SizedBox(width: 8),
          ],
          const SizedBox(width: 18),
          Expanded(
            child: Text(
              'eslam@portfolio:~ \$ $command',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: colors.muted,
                fontFamily: 'Barlow',
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 46),
        ],
      ),
    );
  }
}

class _TerminalLogItem extends StatelessWidget {
  const _TerminalLogItem({
    required this.colors,
    required this.index,
    required this.data,
    required this.compact,
    required this.isLast,
  });

  final _PortfolioColors colors;
  final int index;
  final Map<String, String> data;
  final bool compact;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final role = data['role'] ?? data['degree'] ?? '';
    final company = data['company'] ?? '';
    final date = data['date'] ?? '';
    final location = data['location'] ?? '';
    final description = data['description'] ?? '';

    return Container(
      padding: EdgeInsets.symmetric(vertical: compact ? 18 : 24),
      decoration: BoxDecoration(
        border: Border(
          bottom: isLast
              ? BorderSide.none
              : BorderSide(color: colors.border.withValues(alpha: 0.72)),
        ),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 760;
          final logId = '0x${(0x28FC + index).toRadixString(16).toUpperCase()}';

          final meta = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '[$date]',
                style: TextStyle(
                  color: colors.accent,
                  fontFamily: 'Barlow',
                  fontSize: compact ? 14 : 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.6,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'PROC_ID: $logId',
                style: TextStyle(
                  color: colors.muted.withValues(alpha: 0.62),
                  fontFamily: 'Barlow',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          );

          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: TextStyle(
                    fontFamily: 'Barlow',
                    fontSize: compact ? 17 : 19,
                    fontWeight: FontWeight.w800,
                    height: 1.35,
                  ),
                  children: [
                    TextSpan(text: role, style: TextStyle(color: colors.text)),
                    if (company.isNotEmpty)
                      TextSpan(
                        text: ' @ $company',
                        style: TextStyle(color: colors.accent),
                      ),
                    if (location.isNotEmpty && isWide)
                      TextSpan(
                        text: '  ·  $location',
                        style: TextStyle(
                          color: colors.muted,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                  ],
                ),
              ),
              if (location.isNotEmpty && !isWide) ...[
                const SizedBox(height: 6),
                Text(
                  location,
                  style: TextStyle(
                    color: colors.muted,
                    fontFamily: 'Barlow',
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
              const SizedBox(height: 10),
              Text(
                '> $description',
                style: TextStyle(
                  color: colors.muted,
                  fontFamily: 'Barlow',
                  fontSize: compact ? 14 : 15,
                  height: 1.7,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          );

          if (!isWide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                meta,
                const SizedBox(height: 14),
                details,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: compact ? 180 : 220, child: meta),
              Container(
                width: 1,
                height: compact ? 88 : 102,
                margin: const EdgeInsets.symmetric(horizontal: 24),
                color: colors.border,
              ),
              Expanded(child: details),
            ],
          );
        },
      ),
    );
  }
}

class _SkillRow extends StatelessWidget {
  const _SkillRow({
    required this.colors,
    required this.index,
    required this.title,
    required this.skills,
  });

  final _PortfolioColors colors;
  final int index;
  final String title;
  final List<String> skills;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 820;
          final header = Row(
            children: [
              Text(
                (index + 1).toString().padLeft(2, '0'),
                style: TextStyle(
                  color: colors.muted,
                  fontFamily: 'Barlow',
                  letterSpacing: 2,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 14),
              Icon(_skillIcon(title), color: colors.accent, size: 22),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: colors.text,
                    fontFamily: 'Nunito-ExtraBold',
                    fontSize: 19,
                  ),
                ),
              ),
            ],
          );

          final chips = Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final skill in skills)
                _TinyChip(colors: colors, label: skill),
            ],
          );

          if (!isWide) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                header,
                const SizedBox(height: 14),
                chips,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 300, child: header),
              Expanded(child: chips),
            ],
          );
        },
      ),
    );
  }

  IconData _skillIcon(String category) {
    switch (category) {
      case 'Architecture & Design':
        return Icons.architecture_rounded;
      case 'Backend Development':
        return Icons.dns_rounded;
      case 'Database':
        return Icons.storage_rounded;
      case 'Leadership':
        return Icons.groups_rounded;
      case 'Web & APIs':
        return Icons.api_rounded;
      case 'Deployment':
        return Icons.rocket_launch_rounded;
      case 'Tools & Others':
        return Icons.construction_rounded;
      default:
        return Icons.code_rounded;
    }
  }
}

class _SectionShell extends StatelessWidget {
  const _SectionShell({
    required this.colors,
    required this.child,
  });

  final _PortfolioColors colors;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 34),
        child: child,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.colors,
    required this.eyebrow,
    required this.title,
    required this.body,
  });

  final _PortfolioColors colors;
  final String eyebrow;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 760),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                eyebrow.toUpperCase(),
                style: TextStyle(
                  color: colors.muted,
                  fontFamily: 'Barlow',
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 1,
                  color: colors.border,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: TextStyle(
              color: colors.text,
              fontFamily: 'Nunito-ExtraBold',
              fontSize: MediaQuery.of(context).size.width >= 720 ? 38 : 29,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 12),
          DecoratedBox(
            decoration: BoxDecoration(
              border: Border(left: BorderSide(color: colors.accent, width: 2)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 12),
              child: Text(
                body,
                style: TextStyle(
                  color: colors.muted,
                  fontFamily: 'Barlow',
                  fontSize: 14,
                  height: 1.6,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResponsiveGrid extends StatelessWidget {
  const _ResponsiveGrid({
    required this.columns,
    required this.spacing,
    required this.children,
  });

  final int columns;
  final double spacing;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final itemWidth = (width - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final child in children)
              SizedBox(
                width: itemWidth,
                child: child,
              ),
          ],
        );
      },
    );
  }
}

class _ActionButton extends StatefulWidget {
  const _ActionButton({
    required this.colors,
    required this.label,
    required this.icon,
    required this.onTap,
    this.filled = false,
  });

  final _PortfolioColors colors;
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final background = widget.filled
        ? widget.colors.accent
        : (_hovered ? widget.colors.accentSoft : Colors.transparent);
    final foreground =
        widget.filled ? widget.colors.onAccent : widget.colors.text;

    return MouseRegion(
      cursor: SystemMouseCursors.none,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 11),
          decoration: BoxDecoration(
            color: background,
            border: Border.all(
              color:
                  widget.filled ? widget.colors.accent : widget.colors.border,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, size: 19, color: foreground),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: TextStyle(
                  color: foreground,
                  fontFamily: 'Barlow',
                  fontWeight: FontWeight.w900,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TinyChip extends StatelessWidget {
  const _TinyChip({
    required this.colors,
    required this.label,
  });

  final _PortfolioColors colors;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: colors.surfaceSoft.withValues(alpha: 0.74),
        border: Border.all(color: colors.border),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: colors.muted,
          fontFamily: 'Barlow',
          fontSize: 12,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.colors,
    required this.metric,
    required this.animate,
  });

  final _PortfolioColors colors;
  final _MetricData metric;
  final bool animate;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 168),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.76),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _StatusBadge(colors: colors, label: 'Signal'),
              const Spacer(),
              Icon(metric.icon, color: colors.accent, size: 28),
            ],
          ),
          const SizedBox(height: 22),
          AnimatedCountText(
            value: metric.value,
            enabled: animate,
            style: TextStyle(
              color: colors.text,
              fontFamily: 'Nunito-ExtraBold',
              fontSize: 44,
              height: 0.9,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            metric.label,
            style: TextStyle(
              color: colors.text,
              fontWeight: FontWeight.w800,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            metric.hint,
            style: TextStyle(
              color: colors.muted,
              height: 1.45,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMetric extends StatelessWidget {
  const _MiniMetric({
    required this.colors,
    required this.label,
    required this.value,
  });

  final _PortfolioColors colors;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colors.surfaceSoft,
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: TextStyle(
              color: colors.text,
              fontFamily: 'Nunito-ExtraBold',
              fontSize: 28,
              height: 1,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            style: TextStyle(
              color: colors.muted,
              fontFamily: 'Barlow',
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _TerminalBlock extends StatelessWidget {
  const _TerminalBlock({
    required this.colors,
    required this.title,
    required this.lines,
  });

  final _PortfolioColors colors;
  final String title;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: colors.surfaceSoft,
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: r'$ ',
                  style: TextStyle(color: colors.accent),
                ),
                TextSpan(text: title),
              ],
            ),
            style: TextStyle(
              color: colors.text,
              fontFamily: 'Barlow',
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          for (final line in lines)
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Text(
                '  $line',
                style: TextStyle(
                  color: colors.muted,
                  fontFamily: 'Barlow',
                  height: 1.35,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _RoleLine extends StatelessWidget {
  const _RoleLine({required this.colors});

  final _PortfolioColors colors;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 8,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Text(
          'const role =',
          style: TextStyle(
            color: colors.accent,
            fontFamily: 'Barlow',
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        Text(
          '"Senior Back-End Developer"',
          style: TextStyle(
            color: colors.text,
            fontFamily: 'Barlow',
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}

class _Eyebrow extends StatelessWidget {
  const _Eyebrow({
    required this.colors,
    required this.label,
    required this.icon,
  });

  final _PortfolioColors colors;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.72),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colors.accent, size: 17),
          const SizedBox(width: 9),
          Text(
            label,
            style: TextStyle(
              color: colors.muted,
              fontFamily: 'Barlow',
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.colors,
    required this.label,
  });

  final _PortfolioColors colors;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: colors.accentSoft,
        border: Border.all(color: colors.accent.withValues(alpha: 0.42)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            color: colors.accent,
          ),
          const SizedBox(width: 7),
          Text(
            label.toUpperCase(),
            style: TextStyle(
              color: colors.accent,
              fontFamily: 'Barlow',
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExperienceMiniTitle extends StatelessWidget {
  const _ExperienceMiniTitle({
    required this.colors,
    required this.title,
  });

  final _PortfolioColors colors;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: colors.accent,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: TextStyle(
            color: colors.text,
            fontFamily: 'Barlow',
            fontSize: 18,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.8,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Container(
            height: 1,
            color: colors.border,
          ),
        ),
      ],
    );
  }
}

class _SectionGap extends StatelessWidget {
  const _SectionGap._(this.height);

  factory _SectionGap.large() => const _SectionGap._(72);

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class _WindowDot extends StatelessWidget {
  const _WindowDot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.only(right: 7),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _NavHeaderDelegate extends SliverPersistentHeaderDelegate {
  _NavHeaderDelegate({
    required this.colors,
    required this.isDark,
    required this.onThemeToggle,
    required this.onLogoTap,
    required this.onAboutTap,
    required this.onProjectsTap,
    required this.onCoursesTap,
    required this.onExperienceTap,
    required this.onSkillsTap,
    required this.onContactTap,
    required this.onCommandTap,
    required this.onMenuTap,
    required this.activeSection,
    required this.pageProgress,
  });

  final _PortfolioColors colors;
  final bool isDark;
  final VoidCallback onThemeToggle;
  final VoidCallback onLogoTap;
  final VoidCallback onAboutTap;
  final VoidCallback onProjectsTap;
  final VoidCallback onCoursesTap;
  final VoidCallback onExperienceTap;
  final VoidCallback onSkillsTap;
  final VoidCallback onContactTap;
  final VoidCallback onCommandTap;
  final VoidCallback onMenuTap;
  final String activeSection;
  final double pageProgress;

  @override
  double get minExtent => 76;

  @override
  double get maxExtent => 76;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return ColoredBox(
      color: colors.background.withValues(alpha: 0.92),
      child: Stack(
        children: [
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1240),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: colors.surface.withValues(alpha: 0.92),
                    border: Border.all(color: colors.border),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isWide = constraints.maxWidth >= 780;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: onLogoTap,
                              child: Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: '~/',
                                      style: TextStyle(color: colors.accent),
                                    ),
                                    const TextSpan(text: 'eslam'),
                                  ],
                                ),
                                style: TextStyle(
                                  color: colors.text,
                                  fontFamily: 'Barlow',
                                  fontSize: 15,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isWide)
                                  Wrap(
                                    spacing: 16,
                                    children: [
                                      _NavLink(
                                          colors: colors,
                                          label: '~/About',
                                          active: activeSection == 'about',
                                          onTap: onAboutTap),
                                      _NavLink(
                                          colors: colors,
                                          label: '~/Projects',
                                          active: activeSection == 'projects',
                                          onTap: onProjectsTap),
                                      if (courses.isNotEmpty)
                                        _NavLink(
                                            colors: colors,
                                            label: '~/Courses',
                                            active: activeSection == 'courses',
                                            onTap: onCoursesTap),
                                      _NavLink(
                                          colors: colors,
                                          label: '~/Experience',
                                          active: activeSection == 'experience',
                                          onTap: onExperienceTap),
                                      _NavLink(
                                          colors: colors,
                                          label: '~/Skills',
                                          active: activeSection == 'skills',
                                          onTap: onSkillsTap),
                                      _NavLink(
                                          colors: colors,
                                          label: '~/Contact',
                                          active: activeSection == 'contact',
                                          onTap: onContactTap),
                                    ],
                                  ),
                                Tooltip(
                                  message: 'Command palette (Ctrl/⌘ K)',
                                  child: GestureDetector(
                                    onTap: onCommandTap,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                      child: Icon(
                                        Icons.keyboard_command_key_rounded,
                                        color: colors.muted,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                                Tooltip(
                                  message:
                                      isDark ? 'Light theme' : 'Dark theme',
                                  child: GestureDetector(
                                    onTap: onThemeToggle,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                      child: Icon(
                                        isDark
                                            ? Icons.light_mode_rounded
                                            : Icons.dark_mode_rounded,
                                        color: colors.accent,
                                      ),
                                    ),
                                  ),
                                ),
                                if (!isWide) ...[
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: onMenuTap,
                                    child: Container(
                                      width: 40,
                                      height: 40,
                                      alignment: Alignment.center,
                                      color: Colors.transparent,
                                      child: Icon(
                                        Icons.menu_rounded,
                                        color: colors.accent,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: pageProgress.clamp(0.0, 1.0),
                child: Container(height: 2, color: colors.accent),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(covariant _NavHeaderDelegate oldDelegate) {
    return oldDelegate.colors != colors ||
        oldDelegate.isDark != isDark ||
        oldDelegate.activeSection != activeSection ||
        (oldDelegate.pageProgress - pageProgress).abs() > .001;
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.colors,
    required this.label,
    required this.onTap,
    this.active = false,
  });

  final _PortfolioColors colors;
  final String label;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: active,
      child: InkWell(
        onTap: onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 180),
          style: TextStyle(
            color: active ? colors.accent : colors.muted,
            fontFamily: 'Barlow',
            fontSize: 12,
            fontWeight: active ? FontWeight.w900 : FontWeight.w800,
          ),
          child: Text(label),
        ),
      ),
    );
  }
}

class _GridBackgroundPainter extends CustomPainter {
  _GridBackgroundPainter({
    required this.colors,
    this.tight = false,
  });

  final _PortfolioColors colors;
  final bool tight;

  @override
  void paint(Canvas canvas, Size size) {
    final spacing = tight ? 36.0 : 72.0;
    final paint = Paint()
      ..color = colors.border.withValues(alpha: tight ? 0.42 : 0.28)
      ..strokeWidth = 1;

    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridBackgroundPainter oldDelegate) {
    return oldDelegate.colors != colors || oldDelegate.tight != tight;
  }
}

class _PortfolioColors {
  const _PortfolioColors({
    required this.background,
    required this.surface,
    required this.surfaceSoft,
    required this.text,
    required this.muted,
    required this.border,
    required this.accent,
    required this.accentSoft,
    required this.onAccent,
    required this.shadow,
  });

  final Color background;
  final Color surface;
  final Color surfaceSoft;
  final Color text;
  final Color muted;
  final Color border;
  final Color accent;
  final Color accentSoft;
  final Color onAccent;
  final Color shadow;

  factory _PortfolioColors.from(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (isDark) {
      return const _PortfolioColors(
        background: AppColors.background,
        surface: AppColors.surface,
        surfaceSoft: AppColors.surfaceElevated,
        text: AppColors.primary,
        muted: AppColors.secondary,
        border: AppColors.border,
        accent: AppColors.accent,
        accentSoft: AppColors.accentSoft,
        onAccent: Color(0xff061B2C),
        shadow: Color(0xaa000000),
      );
    }

    return const _PortfolioColors(
      background: AppColors.lightBackground,
      surface: AppColors.lightSurface,
      surfaceSoft: Color(0xffF3EDE5),
      text: AppColors.lightText,
      muted: AppColors.lightMuted,
      border: AppColors.lightBorder,
      accent: AppColors.lightAccent,
      accentSoft: AppColors.lightAccentSoft,
      onAccent: Color(0xffFFFFFF),
      shadow: Color(0x22000000),
    );
  }
}

class _MetricData {
  const _MetricData({
    required this.value,
    required this.label,
    required this.hint,
    required this.icon,
  });

  final String value;
  final String label;
  final String hint;
  final IconData icon;
}

void _showItemDetails(BuildContext context, ItemModel item) {
  showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Project Details',
    barrierColor: Colors.black.withValues(alpha: 0.56),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (context, animation, secondaryAnimation) =>
        ProjectDetailsDialog(model: item),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
        child: ScaleTransition(
          scale: Tween<double>(begin: 0.97, end: 1).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: child,
        ),
      );
    },
  );
}

String _summary(String? description, {int maxLength = 160}) {
  if (description == null || description.trim().isEmpty) {
    return 'Details available inside the project case view.';
  }

  final normalized = description
      .trim()
      .replaceAll('`', '')
      .replaceAll('\n', ' ')
      .replaceAll(RegExp(r'\s+'), ' ');

  if (normalized.length <= maxLength) {
    return normalized;
  }

  return '${normalized.substring(0, maxLength).trim()}...';
}

class _CommandPalette extends StatefulWidget {
  const _CommandPalette({
    required this.colors,
    required this.onNavigate,
    required this.onThemeToggle,
  });

  final _PortfolioColors colors;
  final ValueChanged<String> onNavigate;
  final VoidCallback onThemeToggle;

  @override
  State<_CommandPalette> createState() => _CommandPaletteState();
}

class _CommandPaletteState extends State<_CommandPalette> {
  final _search = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final commands = <({String label, IconData icon, VoidCallback action})>[
      for (final section in const [
        'about',
        'projects',
        'experience',
        'skills',
        'contact'
      ])
        (
          label: 'Go to ${section[0].toUpperCase()}${section.substring(1)}',
          icon: Icons.arrow_downward_rounded,
          action: () => widget.onNavigate(section),
        ),
      (
        label: 'Switch color theme',
        icon: Icons.contrast_rounded,
        action: widget.onThemeToggle,
      ),
      (
        label: 'Open GitHub',
        icon: Icons.code_rounded,
        action: () {
          Navigator.of(context).pop();
          Launcher.open('https://github.com/eslamandroid12345');
        },
      ),
      (
        label: 'Open LinkedIn',
        icon: Icons.badge_rounded,
        action: () {
          Navigator.of(context).pop();
          Launcher.open(
            'https://www.linkedin.com/in/eslam-mohamed-ragab-81332528b/',
          );
        },
      ),
      (
        label: 'Open portfolio',
        icon: Icons.language_rounded,
        action: () {
          Navigator.of(context).pop();
          Launcher.open('https://eslam-mohamed-ragab.techno-saas.com/');
        },
      ),
    ];
    final visible = commands
        .where((command) => command.label.toLowerCase().contains(_query))
        .toList(growable: false);

    return Dialog(
      alignment: const Alignment(0, -.55),
      backgroundColor: widget.colors.surface,
      shape: const RoundedRectangleBorder(),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 580, maxHeight: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              key: const ValueKey('command-search'),
              controller: _search,
              autofocus: true,
              onChanged: (value) =>
                  setState(() => _query = value.toLowerCase()),
              onSubmitted: (_) {
                if (visible.isNotEmpty) visible.first.action();
              },
              style: TextStyle(color: widget.colors.text),
              decoration: InputDecoration(
                hintText: 'Type a command…',
                hintStyle: TextStyle(color: widget.colors.muted),
                prefixIcon:
                    Icon(Icons.terminal_rounded, color: widget.colors.accent),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(14),
                  child:
                      Text('ESC', style: TextStyle(color: widget.colors.muted)),
                ),
                border: InputBorder.none,
              ),
            ),
            Divider(height: 1, color: widget.colors.border),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: visible.length,
                itemBuilder: (context, index) {
                  final command = visible[index];
                  return ListTile(
                    leading: Icon(command.icon, color: widget.colors.accent),
                    title: Text(command.label,
                        style: TextStyle(color: widget.colors.text)),
                    trailing: Icon(Icons.keyboard_return_rounded,
                        color: widget.colors.muted, size: 18),
                    onTap: command.action,
                    hoverColor: widget.colors.accentSoft,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

TextDirection _textDirection(String? text) {
  if (text == null) return TextDirection.ltr;
  return RegExp(r'[\u0600-\u06FF]').hasMatch(text)
      ? TextDirection.rtl
      : TextDirection.ltr;
}

class _MobileDrawer extends StatelessWidget {
  const _MobileDrawer({
    required this.colors,
    required this.onAboutTap,
    required this.onProjectsTap,
    required this.onCoursesTap,
    required this.onExperienceTap,
    required this.onSkillsTap,
    required this.onContactTap,
  });

  final _PortfolioColors colors;
  final VoidCallback onAboutTap;
  final VoidCallback onProjectsTap;
  final VoidCallback onCoursesTap;
  final VoidCallback onExperienceTap;
  final VoidCallback onSkillsTap;
  final VoidCallback onContactTap;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: colors.background,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 32),
            _DrawerLink(label: '~/About', onTap: onAboutTap, colors: colors),
            _DrawerLink(
                label: '~/Projects', onTap: onProjectsTap, colors: colors),
            if (courses.isNotEmpty)
              _DrawerLink(
                  label: '~/Courses', onTap: onCoursesTap, colors: colors),
            _DrawerLink(
                label: '~/Experience', onTap: onExperienceTap, colors: colors),
            _DrawerLink(label: '~/Skills', onTap: onSkillsTap, colors: colors),
            _DrawerLink(
                label: '~/Contact', onTap: onContactTap, colors: colors),
          ],
        ),
      ),
    );
  }
}

class _DrawerLink extends StatelessWidget {
  const _DrawerLink({
    required this.label,
    required this.onTap,
    required this.colors,
  });

  final String label;
  final VoidCallback onTap;
  final _PortfolioColors colors;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      title: Text(
        label,
        style: TextStyle(
          color: colors.text,
          fontFamily: 'Barlow',
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
      ),
    );
  }
}
