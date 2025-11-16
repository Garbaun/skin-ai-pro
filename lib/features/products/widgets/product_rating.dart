import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';

class ProductRating extends StatelessWidget {
  final double rating;
  final double size;
  final bool showNumber;

  const ProductRating({
    super.key,
    required this.rating,
    this.size = 16,
    this.showNumber = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Stars
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(5, (index) {
            final starValue = index + 1;
            IconData iconData;
            Color color;

            if (rating >= starValue) {
              iconData = Icons.star;
              color = AppColors.warning;
            } else if (rating >= starValue - 0.5) {
              iconData = Icons.star_half;
              color = AppColors.warning;
            } else {
              iconData = Icons.star_border;
              color = Theme.of(context).colorScheme.onSurface.withOpacity(0.3);
            }

            return Icon(
              iconData,
              size: size,
              color: color,
            );
          }),
        ),

        // Rating Number
        if (showNumber) ...[
          const SizedBox(width: 4),
          Text(
            rating.toStringAsFixed(1),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.medium,
                ),
          ),
        ],
      ],
    );
  }
}
