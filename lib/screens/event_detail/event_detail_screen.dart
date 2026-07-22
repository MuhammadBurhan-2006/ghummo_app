import 'package:flutter/material.dart';
import '../../models/event.dart';

/// Matches the "Event" wireframe: photo (now Hero-linked from the card),
/// description, Book button.
class EventDetailScreen extends StatelessWidget {
  final EventModel event;

  const EventDetailScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 260,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                // Must match the tag used in EventCard for the shared transition.
                tag: 'event-image-${event.id}',
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.tertiary,
                      ],
                    ),
                  ),
                  child: const Center(
                    child: Icon(Icons.photo, size: 56, color: Colors.white70),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title, style: Theme.of(context).textTheme.headlineSmall),
                  const SizedBox(height: 4),
                  Text(
                    event.category,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(event.description, style: Theme.of(context).textTheme.bodyLarge),
                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      onPressed: () {
                        // TODO: connect to booking flow / backend
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Booked! (placeholder)')),
                        );
                      },
                      child: const Text('Book'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}