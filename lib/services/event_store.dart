import 'package:flutter/foundation.dart';

import '../models/sekai_event.dart';
import 'event_service.dart';

enum DataState { loading, success, error }

/// Menyimpan data event agar hanya diunduh sekali dan dipakai bersama
/// oleh halaman Radar dan Arsip.
class EventStore extends ChangeNotifier {
  final EventService _service = EventService();

  DataState state = DataState.loading;
  List<SekaiEvent> events = const [];
  String? error;
  DateTime? updatedAt;

  Future<void> load() async {
    state = DataState.loading;
    error = null;
    notifyListeners();
    try {
      events = await _service.fetchEvents();
      updatedAt = DateTime.now();
      state = DataState.success;
    } on ApiException catch (e) {
      error = e.message;
      state = DataState.error;
    } catch (_) {
      error = 'Terjadi kesalahan tak terduga.';
      state = DataState.error;
    }
    notifyListeners();
  }
}
