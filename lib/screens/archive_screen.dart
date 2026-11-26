import 'package:material_ui/material_ui.dart';

import '../models/sekai_event.dart';
import '../services/event_store.dart';
import '../widgets/event_card.dart';
import '../widgets/state_views.dart';
import 'detail_screen.dart';

/// Arsip: seluruh event + pencarian judul (juga bisa ID) + filter tipe.
class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({super.key, required this.store});
  final EventStore store;

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  final _controller = TextEditingController();
  String _query = '';
  String? _type; // null = semua tipe

  static const _types = {
    'marathon': 'Marathon',
    'cheerful_carnival': 'Cheerful Carnival',
    'world_bloom': 'World Bloom',
  };

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<SekaiEvent> _filter(List<SekaiEvent> all) {
    final q = _query.trim().toLowerCase();
    return all.where((e) {
      if (_type != null && e.eventType != _type) return false;
      if (q.isEmpty) return true;
      return e.name.toLowerCase().contains(q) || e.id.toString() == q;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    return Scaffold(
      appBar: AppBar(title: const Text('Arsip Event')),
      body: ListenableBuilder(
        listenable: store,
        builder: (context, _) {
          if (store.state == DataState.loading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (store.state == DataState.error) {
            return ErrorView(message: store.error ?? 'Terjadi kesalahan.', onRetry: store.load);
          }
          final list = _filter(store.events);
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                child: TextField(
                  controller: _controller,
                  onChanged: (v) => setState(() => _query = v),
                  decoration: InputDecoration(
                    hintText: 'Cari judul atau ID event...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _controller.clear();
                              setState(() => _query = '');
                            },
                          ),
                    filled: true,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(28), borderSide: BorderSide.none),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    ChoiceChip(
                      label: const Text('Semua'),
                      selected: _type == null,
                      onSelected: (_) => setState(() => _type = null),
                    ),
                    for (final entry in _types.entries) ...[
                      const SizedBox(width: 8),
                      ChoiceChip(
                        label: Text(entry.value),
                        selected: _type == entry.key,
                        onSelected: (_) => setState(() => _type = entry.key),
                      ),
                    ],
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text('${list.length} event', style: Theme.of(context).textTheme.bodySmall),
                ),
              ),
              Expanded(
                child: list.isEmpty
                    ? const EmptyView(icon: Icons.search_off, title: 'Event tidak ditemukan', subtitle: 'Coba kata kunci lain.')
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
                        itemCount: list.length,
                        itemBuilder: (context, i) => EventCard(
                          event: list[i],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => DetailScreen(event: list[i])),
                          ),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
