class EventModel {
  final String id;
  final String title;
  final String category;
  final String? description;
  final String? location;
  final DateTime? date;
  final String? imageUrl;
  final double? price;

  EventModel({
    required this.id,
    required this.title,
    required this.category,
    this.description,
    this.location,
    this.date,
    this.imageUrl,
    this.price,
  });

  factory EventModel.placeholder(String id, {String title = '', String category = 'Tech'}) {
    final eventTitles = [
      'Tech Meetup Islamabad',
      'Music Festival 2026',
      'Gaming Tournament',
      'Art Exhibition',
      'Food Carnival',
      'Business Networking',
      'Sports Championship',
      'Education Workshop',
      'Social Gathering',
      'Tech Conference 2026',
      'Live Concert',
      'Game Dev Meetup',
    ];

    final categories = [
      'Tech', 'Music', 'Gaming', 'Art',
      'Food', 'Business', 'Sports', 'Education',
      'Social', 'Tech', 'Music', 'Gaming'
    ];

    final index = int.tryParse(id) ?? 0;
    return EventModel(
      id: id,
      title: title.isNotEmpty ? title : eventTitles[index % eventTitles.length],
      category: categories[index % categories.length],
      description: 'Join us for an amazing event experience!',
      location: 'Islamabad, Pakistan',
      date: DateTime.now().add(Duration(days: index + 1)),
      price: 19.99 + (index % 5) * 5,
    );
  }
}