import 'dart:async';

import 'package:material_ui/material_ui.dart';

import '../models/sekai_event.dart';
import '../services/event_store.dart';
import '../widgets/event_card.dart';
import '../widgets/state_views.dart';
import 'detail_screen.dart';

/// Event Radar: event ONGOING dan UPCOMING (dengan hitung mundur).
class RadarScreen extends StatefulWidget {
  const RadarScreen({super.key, required this.store});
  final EventStore store;

  @override
  State<RadarScreen> createState() => _RadarScreenState();
}

class _RadarScreenState extends State<RadarScreen> {
  Timer? _tick;

  @override
  void initState() {
    super.initState();
    // Hitung ulang status tiap 30 detik (UPCOMING -> ONGOING -> ENDED saat aplikasi terbuka).
    _tick = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tick?.cancel();
    super.dispose();
  }

  void _open(SekaiEvent e) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(event: e)));

  Widget _header(String text) => Padding(
        padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
        child: Text(text, style: Theme.of(context).textTheme.titleMedium),
      );

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    return Scaffold(
      appBar: AppBar(
        title: const Text('SekaiRadar JP'),
        actions: [
          ListenableBuilder(
            listenable: store,
            builder: (context, _) => IconButton(
              tooltip: 'Refresh',
              icon: const Icon(Icons.refresh),
              onPressed: store.state == DataState.loading ? null : store.load,
            ),
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          if (store.state == DataState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (store.state == DataState.error) {
            return ErrorView(message: store.error ?? 'Terjadi kesalahan.', onRetry: store.load);
          }
          final now = DateTime.now();
          final ongoing = store.events.where((e) => e.statusAt(now) == EventStatus.ongoing).toList()
            ..sort((a, b) => a.aggregateAt.compareTo(b.aggregateAt));
          final upcoming = store.events.where((e) => e.statusAt(now) == EventStatus.upcoming).toList()
            ..sort((a, b) => a.startAt.compareTo(b.startAt));

          if (ongoing.isEmpty && upcoming.isEmpty) {
            return const EmptyView(
              icon: Icons.event_busy,
              title: 'Belum ada event berjalan atau mendatang',
              subtitle: 'Cek tab Arsip Event atau tekan Refresh nanti.',
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (ongoing.isNotEmpty) ...[
                _header('Sedang Berlangsung'),
                for (final e in ongoing) EventCard(event: e, showCountdown: true, onTap: () => _open(e)),
              ],
              if (upcoming.isNotEmpty) ...[
                _header('Akan Datang'),
                for (final e in upcoming) EventCard(event: e, showCountdown: true, onTap: () => _open(e)),
              ],
            ],
          );
        },
      ),
    );
  }
}
