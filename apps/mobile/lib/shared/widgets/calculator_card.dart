import 'package:financehub/features/favorites/data/favorites_repository.dart';
import 'package:flutter/material.dart';

class CalculatorCard extends StatefulWidget {
  final IconData icon;
  final String id;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;

  const CalculatorCard({
    super.key,
    required this.id,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  State<CalculatorCard> createState() => _CalculatorCardState();
}

class _CalculatorCardState extends State<CalculatorCard> {
  late bool favorite;

  @override
  void initState() {
    super.initState();
    favorite = FavoritesRepository.isFavorite(widget.id);
  }

  Future<void> toggleFavorite() async {
    await FavoritesRepository.toggle(widget.id);

    setState(() {
      favorite = FavoritesRepository.isFavorite(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: Icon(
                    favorite ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                  ),
                  onPressed: toggleFavorite,
                ),
              ),

              CircleAvatar(
                radius: 20,
                child: Icon(widget.icon),
              ),

              const SizedBox(height: 8),

              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (widget.subtitle != null) ...[
                const SizedBox(height: 6),
                Text(
                  widget.subtitle!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}