import 'package:flutter/material.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/models/product_models.dart';

class ProductActions extends StatelessWidget {
  final Product product;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;

  const ProductActions({
    super.key,
    required this.product,
    required this.onAddToCart,
    required this.onBuyNow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        // Add to Cart Button
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onAddToCart,
            icon: const Icon(Icons.add_shopping_cart),
            label: const Text('Add to Cart'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: BorderSide(color: theme.colorScheme.primary),
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
            ),
          ),
        ),

        const SizedBox(width: AppConstants.spacingMedium),

        // Buy Now Button
        Expanded(
          child: ElevatedButton.icon(
            onPressed: onBuyNow,
            icon: const Icon(Icons.shopping_bag),
            label: const Text('Buy Now'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusMedium),
              ),
              elevation: 2,
            ),
          ),
        ),
      ],
    );
  }
}
