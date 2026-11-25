import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/sekai_event.dart';

class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

/// Parsing dijalankan di isolate (compute) karena events.json cukup besar (~3 MB).
List<SekaiEvent> parseEvents(String body) {
  final list = jsonDecode(body) as List;
  final events = list.map((e) => SekaiEvent.fromJson(e as Map<String, dynamic>)).toList();
  events.sort((a, b) => b.id.compareTo(a.id)); // terbaru di atas
  return events;
}

class EventService {
  static const eventsUrl =
      'https://raw.githubusercontent.com/Sekai-World/sekai-master-db-diff/main/events.json';

  static const _assets = 'https://storage.sekai.best/sekai-jp-assets';

  /// Kandidat URL gambar, dicoba berurutan sampai ada yang berhasil.
  /// [hd] true (halaman Detail): coba gambar layar event (lebih besar) dulu.
  static List<String> bannerUrls(String name, {bool hd = false}) {
    final banner = '$_assets/home/banner/$name/$name.webp';
    final screen = '$_assets/event/$name/screen/bg.webp';
    return hd ? [screen, banner] : [banner, screen];
  }

  final http.Client _client;
  EventService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<SekaiEvent>> fetchEvents() async {
    final http.Response res;
    try {
      res = await _client.get(Uri.parse(eventsUrl)).timeout(const Duration(seconds: 30));
    } on SocketException {
      throw ApiException('Tidak ada koneksi internet.');
    } on TimeoutException {
      throw ApiException('Koneksi terlalu lama (timeout). Coba lagi.');
    } on http.ClientException catch (e) {
      throw ApiException('Gagal terhubung ke server.\n${e.message}');
    }
    if (res.statusCode != 200) {
      throw ApiException('Server bermasalah (kode ${res.statusCode}).');
    }
    try {
      return await compute(parseEvents, utf8.decode(res.bodyBytes));
    } catch (_) {
      throw ApiException('Format data dari server tidak valid.');
    }
  }
}
