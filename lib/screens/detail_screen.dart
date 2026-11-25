import 'package:flutter/material.dart';

import '../models/sekai_event.dart';
import '../utils/time_utils.dart';
import '../widgets/banner_image.dart';
import '../widgets/countdown.dart';
import '../widgets/event_card.dart';

/// Detail Event: banner, judul, tipe, jadwal mulai/berakhir (WIB).
class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key, required this.event});
  final SekaiEvent event;

  Widget _row(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelMedium),
                Text(value, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = event.statusAt(DateTime.now());
    return Scaffold(
      appBar: AppBar(title: Text('Event #${event.id}')),
      body: ListView(
        children: [
          BannerImage(assetbundleName: event.assetbundleName, eventType: event.eventType, hd: true),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StatusChip(status),
                const SizedBox(height: 12),
                Text(event.name, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 12),
                if (status != EventStatus.ended) ...[
                  Countdown(event: event, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 8),
                ],
                const Divider(),
                _row(context, Icons.category_outlined, 'Tipe event', event.typeLabel),
                _row(context, Icons.play_circle_outline, 'Mulai', formatWib(event.startAt)),
                _row(context, Icons.flag_outlined, 'Berakhir', formatWib(event.aggregateAt)),
                const SizedBox(height: 8),
                Text(
                  'Data: Sekai World (komunitas, tidak resmi). Project SEKAI adalah milik SEGA / Colorful Palette.',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
