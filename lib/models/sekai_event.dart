enum EventStatus { upcoming, ongoing, ended }

class SekaiEvent {
  final int id;
  final String name;
  final String eventType; // marathon | cheerful_carnival | world_bloom
  final String assetbundleName;
  final int startAt; // epoch ms
  final int aggregateAt; // epoch ms (event berakhir)

  const SekaiEvent({
    required this.id,
    required this.name,
    required this.eventType,
    required this.assetbundleName,
    required this.startAt,
    required this.aggregateAt,
  });

  factory SekaiEvent.fromJson(Map<String, dynamic> j) => SekaiEvent(
        id: (j['id'] as num).toInt(),
        name: (j['name'] as String?) ?? '-',
        eventType: (j['eventType'] as String?) ?? '',
        assetbundleName: (j['assetbundleName'] as String?) ?? '',
        startAt: (j['startAt'] as num).toInt(),
        aggregateAt: (j['aggregateAt'] as num).toInt(),
      );

  /// Status otomatis berdasarkan waktu sekarang.
  EventStatus statusAt(DateTime now) {
    final ms = now.millisecondsSinceEpoch;
    if (ms < startAt) return EventStatus.upcoming;
    if (ms < aggregateAt) return EventStatus.ongoing;
    return EventStatus.ended;
  }

  String get typeLabel {
    switch (eventType) {
      case 'marathon':
        return 'Marathon';
      case 'cheerful_carnival':
        return 'Cheerful Carnival';
      case 'world_bloom':
        return 'World Bloom';
      default:
        return eventType.isEmpty ? '-' : eventType;
    }
  }
}
