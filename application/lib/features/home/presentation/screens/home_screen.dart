import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../zodiac/presentation/providers/zodiac_providers.dart';
import '../../../zodiac/domain/entities/zodiac_sign.dart';

// ═══════════════════════════════════════════════════════════════
//  COLORS
// ═══════════════════════════════════════════════════════════════
class _C {
  static const Color bg = Color(0xFF0F0B1E);
  static const Color card = Color(0xCC1A1530); // slightly transparent so bg shows
  static const Color cardBorder = Color(0xFF2A2545);
  static const Color accent = Color(0xFFFFC107); // amber/gold
  static const Color accentDark = Color(0xFFE5A800);
  static const Color purple = Color(0xFF6C5CE7);
  static const Color purpleDark = Color(0xFF4834D4);
  static const Color white = Colors.white;
  static const Color white70 = Colors.white70;
  static const Color white50 = Color(0x80FFFFFF);
  static const Color white30 = Color(0x4DFFFFFF);
  static const Color searchBg = Color(0xCC1E1A30); // slightly transparent
}

// ═══════════════════════════════════════════════════════════════
//  PLACEHOLDER IMAGES (replacing real images)
// ═══════════════════════════════════════════════════════════════
class _Img {
  // User avatar
  static const String avatar =
      'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=100&h=100&fit=crop&crop=face';

  // Explore banner
  static const String exploreBanner =
      'assets/images/home/hero/bg.jpg';
      static const String exploreBannerUpper =
      'assets/images/home/hero/upper.png';

  // Daily horoscope zodiac images
  static const List<String> zodiacImages = [
    'https://images.unsplash.com/photo-1615672968950-2aaf95647725?w=150&h=150&fit=crop', // aries
    'https://images.unsplash.com/photo-1518709766631-a6a7f45921c3?w=150&h=150&fit=crop', // taurus
    'https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3?w=150&h=150&fit=crop', // gemini
  ];

  // Astro services icons (placeholder images for each service)
  static const List<String> serviceIcons = [
    'https://images.unsplash.com/photo-1609710228159-0fa9bd7c0827?w=80&h=80&fit=crop', // book puja
    'https://images.unsplash.com/photo-1604608672516-f1b9b1d37076?w=80&h=80&fit=crop', // chadhaval
    'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=80&h=80&fit=crop', // daily horoscopes
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=80&h=80&fit=crop', // consultant
    'https://images.unsplash.com/photo-1564804955966-d5d82f197932?w=80&h=80&fit=crop', // temples
    'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=80&h=80&fit=crop', // panchang
  ];

  // AI Astrologer images
  static const List<String> astrologers = [
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=120&h=120&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=120&h=120&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=120&h=120&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=120&h=120&fit=crop&crop=face',
  ];

  // Upcoming schedule images
  static const List<String> scheduleAvatars = [
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100&h=100&fit=crop&crop=face',
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100&h=100&fit=crop&crop=face',
  ];

  // Travel packages
  static const List<String> travelImages = [
    'https://images.unsplash.com/photo-1564804955966-d5d82f197932?w=300&h=200&fit=crop',
    'https://images.unsplash.com/photo-1609710228159-0fa9bd7c0827?w=300&h=200&fit=crop',
  ];

  // Blog images
  static const List<String> blogImages = [
    'https://images.unsplash.com/photo-1604608672516-f1b9b1d37076?w=300&h=200&fit=crop',
    'https://images.unsplash.com/photo-1532968961962-8a0cb3a2d4f0?w=300&h=200&fit=crop',
  ];

  // Footer logos
  static const List<String> logos = [
    'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=60&h=30&fit=crop',
    'https://images.unsplash.com/photo-1462331940025-496dfbfc7564?w=60&h=30&fit=crop',
    'https://images.unsplash.com/photo-1444703686981-a3abbc4d4fe3?w=60&h=30&fit=crop',
    'https://images.unsplash.com/photo-1519681393784-d120267933ba?w=60&h=30&fit=crop',
  ];
}

// ═══════════════════════════════════════════════════════════════
//  HOME SCREEN
// ═══════════════════════════════════════════════════════════════
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        _scrollOffset = _scrollController.offset;
      });
    });
    Future.microtask(() {
      final state = ref.read(zodiacSignsProvider);
      if (state.signs.isEmpty && !state.isLoading) {
        ref.read(zodiacSignsProvider.notifier).loadZodiacSigns();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final zodiacState = ref.watch(zodiacSignsProvider);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: _C.bg,
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Height of one background tile (screen height)
          final tileH = size.height;
          // How many tiles we need to cover the scroll area
          // We paint extra tiles to cover the full content
          const totalTiles = 8;

          return Stack(
            children: [
              // ── Tiled background: normal → flipped → normal → ... ──
              Positioned(
                top: -(_scrollOffset % (tileH * 2)),
                left: 0,
                right: 0,
                child: Column(
                  children: List.generate(totalTiles, (i) {
                    final isFlipped = i.isOdd;
                    final img = Image.asset(
                      AppConstants.background,
                      fit: BoxFit.cover,
                      width: size.width,
                      height: tileH,
                    );
                    return isFlipped
                        ? Transform.flip(flipY: true, child: img)
                        : img;
                  }),
                ),
              ),

              // Dark overlay for readability
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.3),
                ),
              ),

              // ── Main scrollable content ──
              SafeArea(
                bottom: false,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      _buildHeader(),
                      const SizedBox(height: 16),
                      _buildSearchBar(),
                      const SizedBox(height: 20),
                      _buildExploreBanner(),
                      const SizedBox(height: 28),
                      _buildDailyHoroscope(zodiacState),
                      const SizedBox(height: 28),
                      _buildAstroServices(),
                      const SizedBox(height: 28),
                      _buildAIAstrologer(),
                      const SizedBox(height: 28),
                      _buildUpcomingSchedules(),
                      const SizedBox(height: 28),
                      _buildTravelPackages(),
                      const SizedBox(height: 28),
                      _buildLatestBlog(),
                      const SizedBox(height: 28),
                      _buildFooterLogos(),
                      const SizedBox(height: 20),
                      _buildAstroFooter(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  1 ─ HEADER
  // ═══════════════════════════════════════════════════════════════
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Avatar
          CircleAvatar(
            radius: 22,
            backgroundImage: CachedNetworkImageProvider(_Img.avatar),
          ),
          const SizedBox(width: 12),
          // Greeting
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: _C.white50,
                  ),
                ),
                Text(
                  'Hailey Nguyen',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: _C.white,
                  ),
                ),
              ],
            ),
          ),
          // Icons
          _circleIcon(Icons.notifications_outlined),
          const SizedBox(width: 10),
          _circleIcon(Icons.settings_outlined, onTap: () => context.go('/settings')),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  2 ─ SEARCH BAR
  // ═══════════════════════════════════════════════════════════════
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: _C.searchBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _C.cardBorder, width: 1),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            const Icon(Icons.search, color: _C.white30, size: 20),
            const SizedBox(width: 10),
            Text(
              'search',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: _C.white30,
              ),
            ),
            const Spacer(),
            const Icon(Icons.search, color: _C.white50, size: 18),
          ],
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  3 ─ EXPLORE THE WORLD BANNER
  // ═══════════════════════════════════════════════════════════════
  Widget _buildExploreBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: Container(
          height: 140,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Flipped background image with grayscale for a unique look
              Transform.flip(
                flipX: true,
                child: Image.asset(
                  _Img.exploreBanner,
                  fit: BoxFit.cover,
                  color: Colors.grey,
                  colorBlendMode: BlendMode.saturation,
                ),
              ),
              
              // Upper Image
              Positioned(
                right: 0,
                top: 0,
                bottom: 0,
                child: Center(
                  child: Image.asset(
                    _Img.exploreBannerUpper,
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Gradient Overlay (optional, if needed for text readability)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Colors.black.withOpacity(0.4),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),

              // Text Content
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Explore the world',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: _C.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "visit astro's and pleasant today",
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        color: _C.white70,
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

  // ═══════════════════════════════════════════════════════════════
  //  4 ─ DAILY HOROSCOPE
  // ═══════════════════════════════════════════════════════════════
  Widget _buildDailyHoroscope(ZodiacSignsState zodiacState) {
    final displaySigns = zodiacState.signs.isNotEmpty
        ? zodiacState.signs.take(6).toList()
        : <ZodiacSign>[];

    final signNames = ['Aries', 'Taurus', 'Gemini', 'Cancer', 'Leo', 'Virgo'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Daily Horoscope',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _C.white,
            ),
          ),
        ),
        const SizedBox(height: 8),
        // Subtitle
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "The stars are on your favor, you cant be horrific They want let you down!",
            style: GoogleFonts.poppins(
              fontSize: 11,
              color: _C.white50,
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 16),
        // Horizontal zodiac cards
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: displaySigns.isNotEmpty ? displaySigns.length : signNames.length,
            itemBuilder: (context, index) {
              final name = displaySigns.isNotEmpty
                  ? displaySigns[index].name
                  : signNames[index];
              final imgUrl = _Img.zodiacImages[index % _Img.zodiacImages.length];

              return GestureDetector(
                onTap: () {
                  if (displaySigns.isNotEmpty) {
                    context.go('/zodiac/${displaySigns[index].id}');
                  }
                },
                child: Container(
                  width: 110,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: _C.card,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: _C.cardBorder, width: 1),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Zodiac image
                      ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: CachedNetworkImage(
                          imageUrl: imgUrl,
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            width: 70,
                            height: 70,
                            color: _C.searchBg,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            width: 70,
                            height: 70,
                            color: _C.searchBg,
                            child: const Icon(Icons.image, color: _C.white30),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        name,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: _C.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  5 ─ ASTRO SERVICES
  // ═══════════════════════════════════════════════════════════════
  Widget _buildAstroServices() {
    final services = [
      {'title': 'Book Puja', 'desc': 'The stars are on your favor, you cant do this.'},
      {'title': 'Chadhaval', 'desc': 'The stars are on your favor, you cant do this.'},
      {'title': 'Daily Horoscopes', 'desc': 'The stars are on your favor, you cant do this.'},
      {'title': 'Consultant', 'desc': 'The stars are on your favor, you cant do this.'},
      {'title': 'Temples', 'desc': 'The stars are on your favor, you cant do this.'},
      {'title': 'Panchang', 'desc': 'The stars are on your favor, you cant do this.'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            'Astro Services',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _C.white,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: services.length,
            itemBuilder: (context, index) {
              final svc = services[index];
              final imgUrl = _Img.serviceIcons[index % _Img.serviceIcons.length];

              return Container(
                decoration: BoxDecoration(
                  color: _C.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: _C.cardBorder, width: 1),
                ),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    // Service icon/image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: imgUrl,
                        width: 40,
                        height: 40,
                        fit: BoxFit.cover,
                        placeholder: (_, __) => Container(
                          width: 40, height: 40, color: _C.searchBg,
                        ),
                        errorWidget: (_, __, ___) => Container(
                          width: 40, height: 40, color: _C.searchBg,
                          child: const Icon(Icons.image, color: _C.white30, size: 16),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      svc['title']!,
                      style: GoogleFonts.poppins(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: _C.white,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      svc['desc']!,
                      style: GoogleFonts.poppins(
                        fontSize: 8,
                        color: _C.white30,
                        height: 1.3,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      'See More',
                      style: GoogleFonts.poppins(
                        fontSize: 9,
                        fontWeight: FontWeight.w600,
                        color: _C.accent,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  6 ─ AI ASTROLOGER
  // ═══════════════════════════════════════════════════════════════
  Widget _buildAIAstrologer() {
    final astrologers = [
      'Acharya Ganesh',
      'Acharya Ganesh',
      'Acharya Ganesh',
      'Acharya Ganesh',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('AI Astrologer', showSeeAll: true),
        const SizedBox(height: 14),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: astrologers.length,
            itemBuilder: (context, index) {
              final name = astrologers[index];
              final imgUrl = _Img.astrologers[index % _Img.astrologers.length];
              final isFirst = index == 0;

              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: 12),
                child: Column(
                  children: [
                    // Badge on first
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: imgUrl,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            placeholder: (_, __) => Container(
                              width: 90, height: 90, color: _C.searchBg,
                            ),
                            errorWidget: (_, __, ___) => Container(
                              width: 90, height: 90, color: _C.searchBg,
                              child: const Icon(Icons.person, color: _C.white30),
                            ),
                          ),
                        ),
                        if (isFirst)
                          Positioned(
                            top: 6,
                            left: 6,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                'Online',
                                style: GoogleFonts.poppins(
                                  fontSize: 8,
                                  fontWeight: FontWeight.w600,
                                  color: _C.white,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: _C.white70,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  7 ─ UPCOMING SCHEDULES
  // ═══════════════════════════════════════════════════════════════
  Widget _buildUpcomingSchedules() {
    final schedules = [
      {
        'name': 'Anuj Kumar',
        'types': 'Hawan Puja  •  Birthday Puja',
        'time': '9:29 AM, 1st Day',
        'price': '',
      },
      {
        'name': 'Abhishek Si...',
        'types': 'Wedding Puja  •...',
        'time': '₹925.0',
        'price': '₹925.0',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Upcoming Schedules', showSeeAll: true),
        const SizedBox(height: 14),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final s = schedules[index];
              final imgUrl = _Img.scheduleAvatars[index % _Img.scheduleAvatars.length];

              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 14),
                decoration: BoxDecoration(
                  color: _C.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _C.cardBorder, width: 1),
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row with badges
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _C.accent.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            s['time']!.isNotEmpty ? s['time']! : '9:29 AM, 1st Day',
                            style: GoogleFonts.poppins(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              color: _C.accent,
                            ),
                          ),
                        ),
                        const Spacer(),
                        if (s['price']!.isNotEmpty)
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              s['price']!,
                              style: GoogleFonts.poppins(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: Colors.greenAccent,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Avatar
                    Center(
                      child: CircleAvatar(
                        radius: 30,
                        backgroundImage: CachedNetworkImageProvider(imgUrl),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Name
                    Center(
                      child: Text(
                        s['name']!,
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: _C.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Types
                    Center(
                      child: Text(
                        s['types']!,
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: _C.white50,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  8 ─ TRAVEL PACKAGES
  // ═══════════════════════════════════════════════════════════════
  Widget _buildTravelPackages() {
    final packages = [
      {
        'title': 'Nashik Tour Package From Shirdi',
        'price': 'Starts From  ₹ 7999.00',
        'badge': 'Pune',
      },
      {
        'title': 'Nashik Tour From Kolara...',
        'price': 'Starts From ₹...',
        'badge': 'Pune',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Travel Packages', showSeeAll: true),
        const SizedBox(height: 14),
        SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final pkg = packages[index];
              final imgUrl = _Img.travelImages[index % _Img.travelImages.length];

              return Container(
                width: 200,
                margin: const EdgeInsets.only(right: 14),
                decoration: BoxDecoration(
                  color: _C.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _C.cardBorder, width: 1),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image with badge
                    Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: imgUrl,
                          width: double.infinity,
                          height: 130,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => Container(
                            height: 130, color: _C.searchBg,
                          ),
                          errorWidget: (_, __, ___) => Container(
                            height: 130, color: _C.searchBg,
                            child: const Icon(Icons.image, color: _C.white30),
                          ),
                        ),
                        Positioned(
                          top: 10,
                          left: 10,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: _C.accent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              pkg['badge']!,
                              style: GoogleFonts.poppins(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Content
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pkg['title']!,
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _C.white,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            pkg['price']!,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: _C.white50,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'See Details',
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: _C.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  9 ─ LATEST BLOG
  // ═══════════════════════════════════════════════════════════════
  Widget _buildLatestBlog() {
    final blogs = [
      {
        'title': 'How Astrotalk Is Using AI to Become a Smart...',
        'desc': 'As our world moves faster, so...',
        'date': '24 Oct,2025',
        'comments': '135 COMMENTS',
      },
      {
        'title': 'How...',
        'desc': 'AI to...',
        'date': '24 Oct,2025',
        'comments': '135 COMMENTS',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionHeader('Latest Blog', showSeeAll: true),
        const SizedBox(height: 14),
        SizedBox(
          height: 310,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            physics: const BouncingScrollPhysics(),
            itemCount: blogs.length,
            itemBuilder: (context, index) {
              final blog = blogs[index];
              final imgUrl = _Img.blogImages[index % _Img.blogImages.length];

              return Container(
                width: 220,
                margin: const EdgeInsets.only(right: 14),
                decoration: BoxDecoration(
                  color: _C.card,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: _C.cardBorder, width: 1),
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Blog image
                    CachedNetworkImage(
                      imageUrl: imgUrl,
                      width: double.infinity,
                      height: 140,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        height: 140, color: _C.searchBg,
                      ),
                      errorWidget: (_, __, ___) => Container(
                        height: 140, color: _C.searchBg,
                        child: const Icon(Icons.image, color: _C.white30),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Date and comments row
                          Row(
                            children: [
                              Icon(Icons.calendar_today, color: _C.white30, size: 12),
                              const SizedBox(width: 4),
                              Text(
                                blog['date']!,
                                style: GoogleFonts.poppins(
                                  fontSize: 9,
                                  color: _C.white50,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(Icons.chat_bubble_outline, color: _C.white30, size: 12),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  blog['comments']!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 9,
                                    color: _C.white50,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Title
                          Text(
                            blog['title']!,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: _C.white,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          // Description
                          Text(
                            blog['desc']!,
                            style: GoogleFonts.poppins(
                              fontSize: 11,
                              color: _C.white50,
                              height: 1.3,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          // Read More
                          Text(
                            'Read More',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: _C.accent,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  10 ─ FOOTER LOGOS
  // ═══════════════════════════════════════════════════════════════
  Widget _buildFooterLogos() {
    final logoLabels = ['Logorpsum', 'Logo', 'Logorpsum\nUniversity', 'Logo'];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: _C.cardBorder, width: 0.5),
            bottom: BorderSide(color: _C.cardBorder, width: 0.5),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(logoLabels.length, (index) {
            return Column(
              children: [
                // Logo placeholder
                Container(
                  width: 40,
                  height: 30,
                  decoration: BoxDecoration(
                    color: _C.searchBg,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(Icons.business, color: _C.white30, size: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  logoLabels[index],
                  style: GoogleFonts.poppins(
                    fontSize: 8,
                    color: _C.white30,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  11 ─ ASTRO FOOTER
  // ═══════════════════════════════════════════════════════════════
  Widget _buildAstroFooter() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          // Zodiac vector
          Center(
            child: Image.asset(
              AppConstants.zodiacVector,
              width: 100,
              height: 100,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox(width: 100, height: 100),
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            'Astro',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: _C.white,
            ),
          ),
          const SizedBox(height: 10),
          // Description
          Text(
            'Astro – Where tech empowers, knowledge flows, and digital journeys begin with clarity, curiosity, and connection.',
            style: GoogleFonts.poppins(
              fontSize: 12,
              color: _C.white50,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          // Social media icons
          Row(
            children: [
              _socialIcon(Icons.link), // LinkedIn placeholder
              const SizedBox(width: 16),
              _socialIcon(Icons.close), // X placeholder
              const SizedBox(width: 16),
              _socialIcon(Icons.camera_alt_outlined), // Instagram
              const SizedBox(width: 16),
              _socialIcon(Icons.facebook_outlined), // Facebook
            ],
          ),
        ],
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════
  //  HELPERS
  // ═══════════════════════════════════════════════════════════════

  Widget _sectionHeader(String title, {bool showSeeAll = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: _C.white,
            ),
          ),
          if (showSeeAll) ...[
            const Spacer(),
            GestureDetector(
              onTap: () {},
              child: Text(
                'See all >',
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: _C.accent,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Icon(icon, color: _C.white, size: 18),
      ),
    );
  }

  Widget _socialIcon(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: _C.cardBorder, width: 1),
      ),
      child: Icon(icon, color: _C.white70, size: 16),
    );
  }
}
