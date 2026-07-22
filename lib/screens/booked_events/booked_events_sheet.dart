import 'package:flutter/material.dart';
import '../../models/event.dart';

/// The bottom sheet opened from the Home app bar's "booked events" icon.
/// Shows the events the user has already booked.
///
/// TODO: replace the placeholder list with real booked-events data once
/// the backend / local storage layer is wired up.
class BookedEventsSheet extends StatelessWidget {
  const BookedEventsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data — swap for the user's real bookings.
    final bookedEvents = List.generate(2, (i) => EventModel.placeholder('booked-$i'));

    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return SafeArea(
          top: false,
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.black12,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Text(
                      'Booked events',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 24),
              Expanded(
                child: bookedEvents.isEmpty
                    ? const Center(child: Text('No booked events yet.'))
                    : ListView.separated(
                  controller: scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  itemCount: bookedEvents.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final event = bookedEvents[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                        child: Icon(Icons.event, color: Theme.of(context).colorScheme.primary),
                      ),
                      title: Text(event.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                      subtitle: Text(event.category),
                      trailing: const Icon(Icons.chevron_right),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
