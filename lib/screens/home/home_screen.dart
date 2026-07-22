import 'package:flutter/material.dart';
import '../../models/event.dart';
import '../../widgets/animated_gradient_background.dart';
import '../../widgets/event_card.dart';
import '../../widgets/fade_slide_in.dart';
import '../event_detail/event_detail_screen.dart';
import '../booked_events/booked_events_sheet.dart';
import '../options/options_screen.dart';

/// Matches the "Home" wireframe (logo/search, booked-event-details,
/// event grid, Home/Options), rebuilt with a parallax header, an
/// animated search bar, and a staggered-entrance event grid.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  double _scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() => _scrollOffset = _scrollController.offset);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: replace with real data from event_service.dart
    final events = List.generate(6, (i) => EventModel.placeholder('$i'));
    const headerHeight = 220.0;
    final headerShrink = (_scrollOffset / headerHeight).clamp(0.0, 1.0);

    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          SliverAppBar(
            expandedHeight: headerHeight,
            pinned: true,
            elevation: 0,
            backgroundColor: Theme.of(context).colorScheme.primary,
            flexibleSpace: FlexibleSpaceBar(
              background: AnimatedGradientBackground(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Opacity(
                          // Fades out as you scroll, like a parallax layer.
                          opacity: 1 - headerShrink,
                          child: Row(
                            children: [
                              const CircleAvatar(
                                backgroundColor: Colors.white24,
                                child: Icon(Icons.explore, color: Colors.white),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'Ghummo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Spacer(),
                              IconButton(
                                icon: const Icon(Icons.event_available, color: Colors.white),
                                tooltip: 'Booked events',
                                onPressed: () => showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  builder: (_) => const BookedEventsSheet(),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Find something happening\nin Islamabad tonight',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 1 - headerShrink * 0.6),
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            height: 1.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(64),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                child: _AnimatedSearchBar(),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildBuilderDelegate(
                    (context, index) {
                  final event = events[index];
                  return FadeSlideIn(
                    delay: Duration(milliseconds: 80 * index),
                    child: EventCard(
                      event: event,
                      onTap: () => Navigator.push(
                        context,
                        PageRouteBuilder(
                          transitionDuration: const Duration(milliseconds: 400),
                          pageBuilder: (context, animation, secondaryAnimation) => FadeTransition(
                            opacity: animation,
                            child: EventDetailScreen(event: event),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                childCount: events.length,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const OptionsScreen()),
            );
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.settings), label: 'Options'),
        ],
      ),
    );
  }
}

/// A search bar that gently scales + shows a glow when focused.
class _AnimatedSearchBar extends StatefulWidget {
  @override
  State<_AnimatedSearchBar> createState() => _AnimatedSearchBarState();
}

class _AnimatedSearchBarState extends State<_AnimatedSearchBar> {
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() => setState(() => _focused = _focusNode.hasFocus));
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _focused ? 1.03 : 1.0,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: _focused ? 0.20 : 0.10),
              blurRadius: _focused ? 20 : 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: TextField(
          focusNode: _focusNode,
          decoration: const InputDecoration(
            hintText: 'Search events',
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ),
    );
  }
}
