import 'dart:async';

import 'package:flutter/material.dart';

import '../models/sekai_event.dart';
import '../utils/time_utils.dart';

/// Hitung mundur yang diperbarui tiap detik.
/// UPCOMING: menuju mulai. ONGOING: menuju berakhir.
class Countdown extends StatefulWidget {
  const Countdown({super.key, required this.event, this.style});
  final SekaiEvent event;
  final TextStyle? style;

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final nowMs = now.millisecondsSinceEpoch;
    final e = widget.event;
    final String text;
    switch (e.statusAt(now)) {
      case EventStatus.upcoming:
        text = 'Mulai dalam ${formatDuration(e.startAt - nowMs)}';
      case EventStatus.ongoing:
        text = 'Berakhir dalam ${formatDuration(e.aggregateAt - nowMs)}';
      case EventStatus.ended:
        text = 'Event sudah berakhir';
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.timer_outlined, size: 16),
        const SizedBox(width: 6),
        Flexible(child: Text(text, style: widget.style)),
      ],
    );
  }
}
