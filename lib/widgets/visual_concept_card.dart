import 'dart:async';

import 'package:flutter/material.dart';

import '../models/visual_concept.dart';

class VisualConceptCard extends StatefulWidget {
  const VisualConceptCard({
    super.key,
    required this.concept,
    this.categoryLabel,
    this.autoPlaySignal = 0,
  });

  final VisualConcept concept;
  final String? categoryLabel;
  final int autoPlaySignal;

  @override
  State<VisualConceptCard> createState() => _VisualConceptCardState();
}

class _VisualConceptCardState extends State<VisualConceptCard> {
  int _visibleCount = 1;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant VisualConceptCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.autoPlaySignal != oldWidget.autoPlaySignal) {
      _playAnimation();
    }
  }

  @override
  Widget build(BuildContext context) {
    final visibleNodes = widget.concept.nodes.take(_visibleCount).toList();
    final total = widget.concept.nodes.length;
    final safeStep = total == 0 ? 0 : _visibleCount.clamp(1, total);
    final currentLabel = total == 0 ? '' : widget.concept.nodes[safeStep - 1];
    final canGoPrev = _visibleCount > 1;
    final canGoNext = _visibleCount < total;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (widget.categoryLabel != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Chip(label: Text(widget.categoryLabel!)),
                        ),
                      Text(
                        widget.concept.title,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: _reset,
                  tooltip: 'Reset',
                  icon: const Icon(Icons.restart_alt_rounded),
                ),
                TextButton.icon(
                  onPressed: _playAnimation,
                  icon: const Icon(Icons.play_circle_outline),
                  label: const Text('Animer'),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(widget.concept.description),
            const SizedBox(height: 8),
            if (currentLabel.isNotEmpty)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.07),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Focus actuel: $currentLabel\n${_stepHint(safeStep, total)}',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.9),
                    height: 1.35,
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Text(
              'Etape $safeStep / $total',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.72)),
            ),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: total == 0 ? 0 : _visibleCount / total,
              minHeight: 7,
              borderRadius: BorderRadius.circular(99),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton.icon(
                  onPressed: canGoPrev ? _stepBack : null,
                  icon: const Icon(Icons.arrow_back_rounded),
                  label: const Text('Precedent'),
                ),
                OutlinedButton.icon(
                  onPressed: canGoNext ? _stepForward : null,
                  icon: const Icon(Icons.arrow_forward_rounded),
                  label: const Text('Suivant'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Wrap(
                key: ValueKey(_visibleCount),
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (var i = 0; i < visibleNodes.length; i++)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TweenAnimationBuilder<double>(
                          key: ValueKey(
                            '${widget.concept.id}-$i-$_visibleCount',
                          ),
                          tween: Tween(begin: 0, end: 1),
                          duration: Duration(milliseconds: 250 + (i * 120)),
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, (1 - value) * 8),
                                child: child,
                              ),
                            );
                          },
                          child: _NodePill(
                            label: visibleNodes[i],
                            isKeyNode: i == widget.concept.nodes.length - 1,
                          ),
                        ),
                        if (i != visibleNodes.length - 1)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: Icon(
                              Icons.arrow_right_alt_rounded,
                              size: 18,
                              color: Colors.white.withValues(alpha: 0.7),
                            ),
                          ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _stepHint(int step, int total) {
    if (step <= 1) {
      return 'Debut du flux: identifie le contexte de depart.';
    }
    if (step >= total) {
      return 'Fin du flux: observe le resultat final attendu.';
    }
    return 'Transition: comprends ce qui change entre cette etape et la suivante.';
  }

  void _stepForward() {
    _timer?.cancel();
    if (_visibleCount >= widget.concept.nodes.length) {
      return;
    }
    setState(() => _visibleCount += 1);
  }

  void _stepBack() {
    _timer?.cancel();
    if (_visibleCount <= 1) {
      return;
    }
    setState(() => _visibleCount -= 1);
  }

  void _playAnimation() {
    _timer?.cancel();
    setState(() => _visibleCount = 1);

    _timer = Timer.periodic(const Duration(milliseconds: 550), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (_visibleCount >= widget.concept.nodes.length) {
        timer.cancel();
        return;
      }

      setState(() => _visibleCount += 1);
    });
  }

  void _reset() {
    _timer?.cancel();
    setState(() => _visibleCount = 1);
  }
}

class _NodePill extends StatelessWidget {
  const _NodePill({required this.label, required this.isKeyNode});

  final String label;
  final bool isKeyNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isKeyNode
            ? Theme.of(context).colorScheme.secondary.withValues(alpha: 0.20)
            : Colors.white.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(label),
    );
  }
}
