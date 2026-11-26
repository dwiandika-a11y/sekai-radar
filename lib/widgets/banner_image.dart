import 'package:material_ui/material_ui.dart';

import '../services/event_service.dart';

/// Banner event dari server aset Sekai World.
/// Mencoba beberapa kandidat URL berurutan; jika semua gagal tampil placeholder
/// gradasi + ikon tipe event (ketuk untuk coba lagi).
class BannerImage extends StatefulWidget {
  const BannerImage({
    super.key,
    required this.assetbundleName,
    this.eventType = '',
    this.hd = false,
  });
  final String assetbundleName;
  final String eventType;
  final bool hd; // true: utamakan gambar yang lebih besar (halaman Detail)

  @override
  State<BannerImage> createState() => _BannerImageState();
}

class _BannerImageState extends State<BannerImage> {
  // Rasio hanya untuk kotak loading/placeholder; gambar asli memakai rasionya sendiri.
  static const _ratio = 2.4;
  int _index = 0; // kandidat URL yang sedang dicoba
  int _attempt = 0; // bertambah saat pengguna mengetuk "coba lagi"

  IconData get _icon {
    switch (widget.eventType) {
      case 'marathon':
        return Icons.directions_run;
      case 'cheerful_carnival':
        return Icons.celebration;
      case 'world_bloom':
        return Icons.local_florist;
      default:
        return Icons.event;
    }
  }

  Widget _loading(BuildContext context) => AspectRatio(
        aspectRatio: _ratio,
        child: Container(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          alignment: Alignment.center,
          child: const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
        ),
      );

  Widget _placeholder(BuildContext context, {required bool failed}) {
    final cs = Theme.of(context).colorScheme;
    return AspectRatio(
      aspectRatio: _ratio,
      child: InkWell(
      onTap: failed
          ? () => setState(() {
                _index = 0;
                _attempt++;
              })
          : null,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [cs.primaryContainer, cs.surfaceContainerHighest],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(_icon, size: 40, color: cs.onPrimaryContainer),
            if (failed) ...[
              const SizedBox(height: 6),
              const Text('Banner tidak tersedia • ketuk untuk coba lagi', style: TextStyle(fontSize: 11)),
            ],
          ],
        ),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.assetbundleName.isEmpty) return _placeholder(context, failed: false);
    final urls = EventService.bannerUrls(widget.assetbundleName, hd: widget.hd);
    final current = _index;
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: Image.network(
        urls[current],
        key: ValueKey('${urls[current]}#$_attempt'),
        fit: BoxFit.fitWidth, // lebar penuh, tinggi mengikuti rasio asli (tidak dipotong)
        width: double.infinity,
        filterQuality: FilterQuality.medium,
        webHtmlElementStrategy: WebHtmlElementStrategy.prefer,
        loadingBuilder: (context, child, progress) => progress == null ? child : _loading(context),
        errorBuilder: (context, error, stack) {
          debugPrint('Banner gagal (${urls[current]}): $error');
          if (current < urls.length - 1) {
            // coba kandidat URL berikutnya
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && _index == current) setState(() => _index = current + 1);
            });
            return _loading(context);
          }
          return _placeholder(context, failed: true);
        },
      ),
    );
  }
}
