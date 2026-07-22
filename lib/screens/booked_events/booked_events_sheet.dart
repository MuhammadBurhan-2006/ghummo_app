import 'package:flutter/material.dart';
import '../../models/event.dart';

class BookedEventsSheet extends StatefulWidget {
  const BookedEventsSheet({super.key});

  @override
  State<BookedEventsSheet> createState() => _BookedEventsSheetState();
}

class _BookedEventsSheetState extends State<BookedEventsSheet> {
  String _searchQuery = '';

  List<BookedEvent> bookedEvents = [
    BookedEvent(
      event: EventModel.placeholder('1', title: 'Tech Summit 2026'),
      bookedTime: DateTime.now().add(const Duration(hours: 2)),
    ),
    BookedEvent(
      event: EventModel.placeholder('2', title: 'Music Night Live'),
      bookedTime: DateTime.now().add(const Duration(days: 1, hours: 3)),
    ),
    BookedEvent(
      event: EventModel.placeholder('3', title: 'Gaming Tournament'),
      bookedTime: DateTime.now().add(const Duration(days: 2, hours: 5)),
    ),
    BookedEvent(
      event: EventModel.placeholder('4', title: 'Art Exhibition'),
      bookedTime: DateTime.now().add(const Duration(days: 3, hours: 1)),
    ),
    BookedEvent(
      event: EventModel.placeholder('5', title: 'Food Carnival'),
      bookedTime: DateTime.now().add(const Duration(days: 4, hours: 2)),
    ),
  ];

  List<BookedEvent> get _filteredEvents {
    if (_searchQuery.isEmpty) return bookedEvents;
    return bookedEvents.where((b) =>
    b.event.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        b.event.category.toLowerCase().contains(_searchQuery.toLowerCase())
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Booked Events',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.black, size: 28),
                onPressed: () => Navigator.pop(context),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Search Bar for Booked Events
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: Colors.grey[300]!,
                width: 1.5,
              ),
            ),
            child: TextField(
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: 'Search booked events...',
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 20,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                  icon: const Icon(Icons.clear, color: Colors.grey, size: 18),
                  onPressed: () {
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                )
                    : null,
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Event List
          Expanded(
            child: _filteredEvents.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _searchQuery.isEmpty ? Icons.event_busy : Icons.search_off,
                    size: 48,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _searchQuery.isEmpty
                        ? 'No booked events yet'
                        : 'No events match your search',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: _filteredEvents.length,
              itemBuilder: (context, index) {
                final booked = _filteredEvents[index];
                final event = booked.event;

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      // Event icon
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.event,
                          color: Colors.black,
                          size: 28,
                        ),
                      ),
                      const SizedBox(width: 14),

                      // Event details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              event.title,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              event.category,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(
                                  Icons.access_time,
                                  color: Colors.grey[500],
                                  size: 14,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _formatTime(booked.bookedTime),
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Cancel button - NO SQUARE
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            bookedEvents.removeWhere((b) => b.event.id == event.id);
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Event cancelled', style: TextStyle(fontSize: 14)),
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.cancel_outlined,
                                color: Colors.red,
                                size: 28,
                              ),
                              Text(
                                'Cancel',
                                style: TextStyle(
                                  color: Colors.red[400],
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = time.difference(now);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ${difference.inHours % 24}h left';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ${difference.inMinutes % 60}m left';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m left';
    } else {
      return 'Starting soon';
    }
  }
}

class BookedEvent {
  final EventModel event;
  final DateTime bookedTime;

  BookedEvent({required this.event, required this.bookedTime});
}