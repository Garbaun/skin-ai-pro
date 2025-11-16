import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/l10n/app_localizations.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/models/product_models.dart';
import '../bloc/products_bloc.dart';
import '../widgets/product_image_gallery.dart';
import '../widgets/product_rating.dart';
import '../widgets/product_actions.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  
  const ProductDetailScreen({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    
    return Scaffold(
      body: BlocBuilder<ProductsBloc, ProductsState>(
        builder: (context, state) {
          if (state is ProductsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is ProductsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: Theme.of(context).textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => context.read<ProductsBloc>().add(LoadProducts()),
                    icon: const Icon(Icons.refresh),
                    label: Text(l10n.retry),
                  ),
                ],
              ),
            );
          }
          
          if (state is ProductsLoaded) {
            final product = state.products.firstWhere(
              (p) => p.id == productId,
              orElse: () => Product.empty(),
            );
            
            if (product.id.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: 64,
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.productNotFound,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: () => context.go('/products'),
                      icon: const Icon(Icons.arrow_back),
                      label: Text(l10n.backToProducts),
                    ),
                  ],
                ),
              );
            }
            
            return _buildProductDetail(context, product);
          }
          
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildProductDetail(BuildContext context, Product product) {
    return CustomScrollView(
      slivers: [
        // App Bar with Product Image
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            background: ProductImageGallery(images: product.images),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined),
              onPressed: () => _shareProduct(context, product),
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () => _toggleFavorite(context, product),
            ),
          ],
        ),
        
        // Product Information
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.spacingMedium),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Name and Brand
                Text(
                  product.name,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSmall),
                Text(
                  product.brand,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                
                const SizedBox(height: AppConstants.spacingMedium),
                
                // Rating and Reviews
                Row(
                  children: [
                    ProductRating(rating: product.rating),
                    const SizedBox(width: AppConstants.spacingSmall),
                    Text(
                      '(${product.reviewCount} reviews)',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: AppConstants.spacingMedium),
                
                // Price
                Row(
                  children: [
                    Text(
                      '\$${product.price.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    if (product.originalPrice > product.price) ...[
                      const SizedBox(width: AppConstants.spacingSmall),
                      Text(
                        '\$${product.originalPrice.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingSmall),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${((1 - product.price / product.originalPrice) * 100).toStringAsFixed(0)}% OFF',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.success,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                
                const SizedBox(height: AppConstants.spacingLarge),
                
                // Description
                Text(
                  'Description',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingSmall),
                Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                
                const SizedBox(height: AppConstants.spacingLarge),
                
                // Key Benefits
                if (product.benefits.isNotEmpty) ...[
                  Text(
                    'Key Benefits',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSmall),
                  ...product.benefits.map((benefit) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 16,
                        ),
                        const SizedBox(width: AppConstants.spacingSmall),
                        Expanded(
                          child: Text(
                            benefit,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: AppConstants.spacingLarge),
                ],
                
                // Ingredients
                if (product.ingredients.isNotEmpty) ...[
                  Text(
                    'Key Ingredients',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSmall),
                  Wrap(
                    spacing: AppConstants.spacingSmall,
                    runSpacing: AppConstants.spacingSmall,
                    children: product.ingredients.map((ingredient) => Chip(
                      label: Text(ingredient),
                      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                      labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: AppConstants.spacingLarge),
                ],
                
                // How to Use
                if (product.howToUse.isNotEmpty) ...[
                  Text(
                    'How to Use',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSmall),
                  Text(
                    product.howToUse,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppConstants.spacingLarge),
                ],
                
                // Skin Types
                if (product.suitableSkinTypes.isNotEmpty) ...[
                  Text(
                    'Suitable for',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingSmall),
                  Wrap(
                    spacing: AppConstants.spacingSmall,
                    runSpacing: AppConstants.spacingSmall,
                    children: product.suitableSkinTypes.map((skinType) => Chip(
                      avatar: Icon(
                        Icons.spa,
                        size: 16,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      label: Text(skinType),
                      backgroundColor: AppColors.skinTone1.withOpacity(0.1),
                      labelStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.skinTone1,
                      ),
                    )).toList(),
                  ),
                  const SizedBox(height: AppConstants.spacingLarge),
                ],
                
                // Reviews Preview
                if (product.reviews.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Customer Reviews',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.go('/products/${product.id}/reviews'),
                        child: Text('View All'),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingSmall),
                  ...product.reviews.take(3).map((review) => Card(
                    margin: const EdgeInsets.only(bottom: AppConstants.spacingSmall),
                    child: Padding(
                      padding: const EdgeInsets.all(AppConstants.spacingMedium),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                child: Text(
                                  review.userName.substring(0, 1).toUpperCase(),
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: AppConstants.spacingSmall),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      review.userName,
                                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.medium,
                                      ),
                                    ),
                                    ProductRating(rating: review.rating, size: 16),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppConstants.spacingSmall),
                          Text(review.comment),
                        ],
                      ),
                    ),
                  )),
                  const SizedBox(height: AppConstants.spacingLarge),
                ],
              ],
            ),
          ),
        ),
        
        // Related Products
        if (state is ProductsLoaded && state.products.any((p) => p.id != product.id)) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'You Might Also Like',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingMedium),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMedium),
                itemCount: state.products.where((p) => p.id != product.id).take(5).length,
                itemBuilder: (context, index) {
                  final relatedProduct = state.products.where((p) => p.id != product.id).toList()[index];
                  return Container(
                    width: 160,
                    margin: const EdgeInsets.only(right: AppConstants.spacingMedium),
                    child: ProductCard(
                      product: relatedProduct,
                      onTap: () => context.go('/products/${relatedProduct.id}'),
                      compact: true,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
        
        // Bottom Actions
        SliverFillRemaining(
          hasScrollBody: false,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.spacingMedium),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: ProductActions(
                  product: product,
                  onAddToCart: () => context.read<ProductsBloc>().add(AddToCart(product)),
                  onBuyNow: () => _buyNow(context, product),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _shareProduct(BuildContext context, Product product) {
    // Implement product sharing
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Share functionality coming soon')),
    );
  }

  void _toggleFavorite(BuildContext context, Product product) {
    context.read<ProductsBloc>().add(ToggleFavorite(product));
  }

  void _buyNow(BuildContext context, Product product) {
    context.read<ProductsBloc>().add(BuyNow(product));
  }
}