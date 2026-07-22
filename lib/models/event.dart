class EventModel {
  final String id;
  final String title;
  final String category; // e.g. Music, Tech, Painting, MUN
  final DateTime dateTime;
  final String? imageUrl;
  final String description;

  const EventModel({
    required this.id,
    required this.title,
    required this.category,
    required this.dateTime,
    required this.description,
    this.imageUrl,
  });

  // TODO: replace with real parsing once the backend API is connected.
  factory EventModel.placeholder(String id) {
    return EventModel(
      id: id,
      title: 'Event $id',
      category: 'Tech',
      dateTime: DateTime.now().add(const Duration(days: 3)),
      description: 'Event description goes here.',
    );
  }
}
