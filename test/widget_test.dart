import 'package:flutter_test/flutter_test.dart';
import 'package:sekai_radar/models/sekai_event.dart';
import 'package:sekai_radar/utils/time_utils.dart';

void main() {
  const event = SekaiEvent(
    id: 1,
    name: 'Test',
    eventType: 'marathon',
    assetbundleName: 'event_test',
    startAt: 1000,
    aggregateAt: 2000,
  );

  test('status otomatis UPCOMING / ONGOING / ENDED', () {
    expect(event.statusAt(DateTime.fromMillisecondsSinceEpoch(500)), EventStatus.upcoming);
    expect(event.statusAt(DateTime.fromMillisecondsSinceEpoch(1000)), EventStatus.ongoing);
    expect(event.statusAt(DateTime.fromMillisecondsSinceEpoch(1999)), EventStatus.ongoing);
    expect(event.statusAt(DateTime.fromMillisecondsSinceEpoch(2000)), EventStatus.ended);
  });

  test('SekaiEvent.fromJson membaca field API', () {
    final e = SekaiEvent.fromJson({
      'id': 227,
      'name': 'Leo/need Memories',
      'eventType': 'cheerful_carnival',
      'assetbundleName': 'event_memories_lon_2026',
      'startAt': 1795586400000,
      'aggregateAt': 1795953599000,
    });
    expect(e.id, 227);
    expect(e.typeLabel, 'Cheerful Carnival');
    expect(e.aggregateAt, 1795953599000);
  });

  test('toWib menambah 7 jam dari UTC', () {
    final t = toWib(0); // 1970-01-01 00:00 UTC
    expect(t.hour, 7);
    expect(t.day, 1);
  });

  test('formatDuration', () {
    expect(formatDuration(90061000), '1 hari 01:01:01');
    expect(formatDuration(3661000), '01:01:01');
    expect(formatDuration(-5), '00:00:00');
  });
}
