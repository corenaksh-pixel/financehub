import 'package:financehub/features/favorites/data/favorites_repository.dart';
import 'package:flutter/material.dart';

class CalculatorCard extends StatefulWidget {
  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  const CalculatorCard({
    super.key,
    required this.id,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  @override
  State<CalculatorCard> createState() => _CalculatorCardState();
}

class _CalculatorCardState extends State<CalculatorCard> {
  @override
  void initState() {
    super.initState();
    FavoritesRepository.refresh.addListener(_refresh);
  }

  @override
  void dispose() {
    FavoritesRepository.refresh.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final favorite = FavoritesRepository.isFavorite(widget.id);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    favorite ? Icons.favorite : Icons.favorite_border,
                    color: favorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: () async {
                    await FavoritesRepository.toggle(widget.id);
                  },
                ),
              ),

              const Spacer(),

              CircleAvatar(
                radius: 24,
                child: Icon(widget.icon, size: 26),
              ),

              const SizedBox(height: 10),

              Text(
                widget.title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Text(
                widget.subtitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall,
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}