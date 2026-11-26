import 'package:material_ui/material_ui.dart';

import '../models/sekai_event.dart';
import '../utils/time_utils.dart';
import 'banner_image.dart';
import 'countdown.dart';

class StatusChip extends StatelessWidget {
  const StatusChip(this.status, {super.key});
  final EventStatus status;

  @override
  Widget build(BuildContext context) {
    final (label, color) = switch (status) {
      EventStatus.upcoming => ('UPCOMING', Colors.orangeAccent),
      EventStatus.ongoing => ('ONGOING', Colors.greenAccent),
      EventStatus.ended => ('ENDED', Colors.grey),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(border: Border.all(color: color), borderRadius: BorderRadius.circular(12)),
      child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold)),
    );
  }
}

/// Kartu event. [showCountdown] true untuk Radar, false untuk Arsip (menampilkan tanggal).
class EventCard extends StatelessWidget {
  const EventCard({super.key, required this.event, required this.onTap, this.showCountdown = false});
  final SekaiEvent event;
  final VoidCallback onTap;
  final bool showCountdown;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final status = event.statusAt(DateTime.now());
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BannerImage(assetbundleName: event.assetbundleName, eventType: event.eventType),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      StatusChip(status),
                      Text(event.typeLabel, style: theme.textTheme.labelMedium),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(event.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 6),
                  if (showCountdown && status != EventStatus.ended)
                    Countdown(event: event, style: theme.textTheme.bodyMedium)
                  else
                    Text(formatWib(event.startAt), style: theme.textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
