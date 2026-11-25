import 'package:intl/intl.dart';

/// Ubah epoch milliseconds menjadi waktu WIB (UTC+7), apa pun zona waktu perangkat.
/// intl hanya memformat; konversi zona dilakukan manual di sini.
DateTime toWib(int epochMs) =>
    DateTime.fromMillisecondsSinceEpoch(epochMs, isUtc: true).add(const Duration(hours: 7));

/// Contoh: "25 November 2026, 13:00 WIB". Butuh initializeDateFormatting('id_ID') di main().
String formatWib(int epochMs) =>
    '${DateFormat('d MMMM yyyy, HH:mm', 'id_ID').format(toWib(epochMs))} WIB';

/// Contoh: 90061000 ms -> "1 hari 01:01:01".
String formatDuration(int ms) {
  if (ms < 0) ms = 0;
  final totalSec = ms ~/ 1000;
  final d = totalSec ~/ 86400;
  final h = (totalSec % 86400) ~/ 3600;
  final m = (totalSec % 3600) ~/ 60;
  final s = totalSec % 60;
  String two(int n) => n.toString().padLeft(2, '0');
  return '${d > 0 ? '$d hari ' : ''}${two(h)}:${two(m)}:${two(s)}';
}
