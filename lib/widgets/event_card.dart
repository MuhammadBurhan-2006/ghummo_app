import 'package:flutter/material.dart';
import '../models/event.dart';

/// An event card that tilts in 3D following the touch/drag position
/// (like a physical card catching the light), and shares a Hero
/// transition into EventDetailScreen.
class EventCard extends StatefulWidget {
  final EventModel event;
  final VoidCallback? onTap;

  const EventCard({super.key, required this.event, this.onTap});

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> with SingleTickerProviderStateMixin {
  // Current tilt, expressed as -1..1 on each axis.
  Offset _tilt = Offset.zero;
  bool _pressed = false;

  void _updateTilt(Offset localPosition, Size size) {
    final dx = (localPosition.dx / size.width) * 2 - 1; // -1 (left) .. 1 (right)
    final dy = (localPosition.dy / size.height) * 2 - 1; // -1 (top) .. 1 (bottom)
    setState(() => _tilt = Offset(dx.clamp(-1, 1), dy.clamp(-1, 1)));
  }

  void _reset() {
    setState(() {
      _tilt = Offset.zero;
      _pressed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    const maxTiltRadians = 0.18; // ~10 degrees, keeps it subtle/tasteful

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = Size(constraints.maxWidth, constraints.maxHeight);
        return GestureDetector(
          onTap: widget.onTap,
          onPanDown: (details) {
            setState(() => _pressed = true);
            _updateTilt(details.localPosition, size);
          },
          onPanUpdate: (details) => _updateTilt(details.localPosition, size),
          onPanEnd: (_) => _reset(),
          onPanCancel: _reset,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            transformAlignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.0015) // perspective
              ..rotateX(-_tilt.dy * maxTiltRadians)
              ..rotateY(_tilt.dx * maxTiltRadians)
              ..scale(_pressed ? 1.03 : 1.0),
            child: Card(
              clipBehavior: Clip.antiAlias,
              elevation: _pressed ? 14 : 4,
              shadowColor: Colors.black.withValues(alpha: 0.35),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Placeholder gradient "photo" — swap for a real image later.
                  Hero(
                    tag: 'event-image-${widget.event.id}',
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
                            Theme.of(context).colorScheme.tertiary.withValues(alpha: 0.85),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Subtle sheen that shifts with tilt — sells the "glass card" feel.
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(-1 + _tilt.dx, -1 + _tilt.dy),
                          end: Alignment(1 + _tilt.dx, 1 + _tilt.dy),
                          colors: [
                            Colors.white.withValues(alpha: 0.18),
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.10),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 12,
                    right: 12,
                    bottom: 12,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          widget.event.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            shadows: [Shadow(blurRadius: 6, color: Colors.black38)],
                          ),
                        ),
                        Text(
                          widget.event.category,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
