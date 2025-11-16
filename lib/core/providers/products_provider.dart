import 'package:flutter_riverpod/flutter_riverpod.dart';

// Ürün kategorileri
enum ProductCategory {
  cleanser,
  moisturizer,
  serum,
  sunscreen,
  toner,
  mask,
  eyeCare,
  lipCare,
  treatment,
}

// Ürün markaları
enum ProductBrand {
  laRochePosay,
  cerave,
  theOrdinary,
  paulasChoice,
  neutrogena,
  vichy,
  avene,
  bioderma,
  eucerin,
  sebamed,
}

// Ürün modeli
class Product {
  final String id;
  final String name;
  final String description;
  final ProductCategory category;
  final ProductBrand brand;
  final double price;
  final String currency;
  final String imageUrl;
  final List<String> ingredients;
  final List<String> skinTypes;
  final List<String> concerns;
  final double rating;
  final int reviewCount;
  final bool isRecommended;
  final String? purchaseUrl;
  final DateTime? lastUpdated;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.brand,
    required this.price,
    required this.currency,
    required this.imageUrl,
    required this.ingredients,
    required this.skinTypes,
    required this.concerns,
    required this.rating,
    required this.reviewCount,
    required this.isRecommended,
    this.purchaseUrl,
    this.lastUpdated,
  });

  // Türkçe kategori adı
  String get categoryName {
    switch (category) {
      case ProductCategory.cleanser:
        return 'Temizleyici';
      case ProductCategory.moisturizer:
        return 'Nemlendirici';
      case ProductCategory.serum:
        return 'Serum';
      case ProductCategory.sunscreen:
        return 'Güneş Koruması';
      case ProductCategory.toner:
        return 'Tonik';
      case ProductCategory.mask:
        return 'Maske';
      case ProductCategory.eyeCare:
        return 'Göz Bakımı';
      case ProductCategory.lipCare:
        return 'Dudak Bakımı';
      case ProductCategory.treatment:
        return 'Tedavi Ürünü';
    }
  }

  // Türkçe marka adı
  String get brandName {
    switch (brand) {
      case ProductBrand.laRochePosay:
        return 'La Roche-Posay';
      case ProductBrand.cerave:
        return 'CeraVe';
      case ProductBrand.theOrdinary:
        return 'The Ordinary';
      case ProductBrand.paulasChoice:
        return 'Paula\'s Choice';
      case ProductBrand.neutrogena:
        return 'Neutrogena';
      case ProductBrand.vichy:
        return 'Vichy';
      case ProductBrand.avene:
        return 'Avène';
      case ProductBrand.bioderma:
        return 'Bioderma';
      case ProductBrand.eucerin:
        return 'Eucerin';
      case ProductBrand.sebamed:
        return 'Sebamed';
    }
  }
}

// Ürün öneri sistemi
class ProductRecommendation {
  final Product product;
  final double relevanceScore;
  final String reason;
  final int priority;

  ProductRecommendation({
    required this.product,
    required this.relevanceScore,
    required this.reason,
    required this.priority,
  });
}

// Ürün state modeli
class ProductsState {
  final List<Product> allProducts;
  final List<ProductRecommendation> recommendations;
  final List<Product> favoriteProducts;
  final Map<ProductCategory, List<Product>> categorizedProducts;
  final bool isLoading;
  final String? errorMessage;
  final DateTime? lastUpdate;

  ProductsState({
    this.allProducts = const [],
    this.recommendations = const [],
    this.favoriteProducts = const [],
    this.categorizedProducts = const {},
    this.isLoading = false,
    this.errorMessage,
    this.lastUpdate,
  });

  ProductsState copyWith({
    List<Product>? allProducts,
    List<ProductRecommendation>? recommendations,
    List<Product>? favoriteProducts,
    Map<ProductCategory, List<Product>>? categorizedProducts,
    bool? isLoading,
    String? errorMessage,
    DateTime? lastUpdate,
  }) {
    return ProductsState(
      allProducts: allProducts ?? this.allProducts,
      recommendations: recommendations ?? this.recommendations,
      favoriteProducts: favoriteProducts ?? this.favoriteProducts,
      categorizedProducts: categorizedProducts ?? this.categorizedProducts,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      lastUpdate: lastUpdate ?? this.lastUpdate,
    );
  }
}

// Ürün provider'ı
class ProductsNotifier extends StateNotifier<ProductsState> {
  ProductsNotifier() : super(ProductsState()) {
    _initializeProducts();
  }

  // Ürünleri başlat
  Future<void> _initializeProducts() async {
    state = state.copyWith(isLoading: true);

    try {
      // Örnek ürünler - Gerçek uygulamada API'den yüklenecek
      final sampleProducts = _generateSampleProducts();
      
      // Kategorilere ayır
      final categorized = <ProductCategory, List<Product>>{};
      for (final product in sampleProducts) {
        categorized.putIfAbsent(product.category, () => []).add(product);
      }

      state = state.copyWith(
        allProducts: sampleProducts,
        categorizedProducts: categorized,
        isLoading: false,
        lastUpdate: DateTime.now(),
      );

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Ürünler yüklenirken hata oluştu: $e',
      );
    }
  }

  // Örnek ürünler oluştur
  List<Product> _generateSampleProducts() {
    return [
      Product(
        id: '1',
        name: 'Effaclar Duo+',
        description: 'Akne karşıtı bakım kremi, lekeleri azaltmaya yardımcı olur',
        category: ProductCategory.treatment,
        brand: ProductBrand.laRochePosay,
        price: 289.90,
        currency: 'TRY',
        imageUrl: 'https://example.com/effaclar-duo.jpg',
        ingredients: ['Niacinamide', 'Salicylic Acid', 'LHA', 'Glycerin'],
        skinTypes: ['oily', 'combination', 'acne-prone'],
        concerns: ['acne', 'blemishes', 'oiliness'],
        rating: 4.5,
        reviewCount: 1250,
        isRecommended: true,
        purchaseUrl: 'https://www.laroche-posay.com.tr',
      ),
      Product(
        id: '2',
        name: 'CeraVe Moisturizing Cream',
        description: 'Nemlendirici krem, cilt bariyerini destekler',
        category: ProductCategory.moisturizer,
        brand: ProductBrand.cerave,
        price: 199.90,
        currency: 'TRY',
        imageUrl: 'https://example.com/cerave-cream.jpg',
        ingredients: ['Ceramides', 'Hyaluronic Acid', 'MVE Technology'],
        skinTypes: ['dry', 'normal', 'sensitive'],
        concerns: ['dryness', 'sensitivity', 'barrier repair'],
        rating: 4.7,
        reviewCount: 2100,
        isRecommended: true,
        purchaseUrl: 'https://www.cerave.com.tr',
      ),
      Product(
        id: '3',
        name: 'Anthelios Age Correct SPF 50+',
        description: 'Yaşlanma karşıtı güneş koruması, kırışıklık görünümünü azaltır',
        category: ProductCategory.sunscreen,
        brand: ProductBrand.laRochePosay,
        price: 349.90,
        currency: 'TRY',
        imageUrl: 'https://example.com/anthelios-age-correct.jpg',
        ingredients: ['Niacinamide', 'Hyaluronic Acid', 'Mexoryl XL'],
        skinTypes: ['all', 'aging'],
        concerns: ['sun protection', 'aging', 'wrinkles'],
        rating: 4.6,
        reviewCount: 890,
        isRecommended: true,
        purchaseUrl: 'https://www.laroche-posay.com.tr',
      ),
      Product(
        id: '4',
        name: 'The Ordinary Niacinamide 10% + Zinc 1%',
        description: 'Cilt tonunu eşitleyen serum, gözenek görünümünü azaltır',
        category: ProductCategory.serum,
        brand: ProductBrand.theOrdinary,
        price: 89.90,
        currency: 'TRY',
        imageUrl: 'https://example.com/niacinamide-serum.jpg',
        ingredients: ['Niacinamide 10%', 'Zinc 1%'],
        skinTypes: ['oily', 'combination', 'acne-prone'],
        concerns: ['oiliness', 'pores', 'blemishes'],
        rating: 4.4,
        reviewCount: 3200,
        isRecommended: true,
      ),
      Product(
        id: '5',
        name: 'Sensibio H2O Micellar Water',
        description: 'Hassas ciltler için makyaj temizleme suyu',
        category: ProductCategory.cleanser,
        brand: ProductBrand.bioderma,
        price: 159.90,
        currency: 'TRY',
        imageUrl: 'https://example.com/bioderma-micellar.jpg',
        ingredients: ['Micelles', 'Cucumber Extract', 'Allantoin'],
        skinTypes: ['sensitive', 'all'],
        concerns: ['makeup removal', 'sensitivity', 'cleansing'],
        rating: 4.8,
        reviewCount: 1800,
        isRecommended: true,
      ),
      Product(
        id: '6',
        name: 'Toleriane Ultra Night',
        description: 'Hassas ciltler için gece kremi, rahatlatıcı etki',
        category: ProductCategory.moisturizer,
        brand: ProductBrand.laRochePosay,
        price: 279.90,
        currency: 'TRY',
        imageUrl: 'https://example.com/toleriane-night.jpg',
        ingredients: ['Neurosensine', 'Niacinamide', 'Thermal Water'],
        skinTypes: ['sensitive', 'reactive'],
        concerns: ['sensitivity', 'redness', 'comfort'],
        rating: 4.5,
        reviewCount: 650,
        isRecommended: true,
      ),
    ];
  }

  // Kişiye özel ürün önerileri oluştur
  Future<void> generatePersonalizedRecommendations({
    required String userId,
    required List<String> skinTypes,
    required List<String> concerns,
    required double sensitivityLevel,
  }) async {
    try {
      state = state.copyWith(isLoading: true);

      // Analiz sonuçlarına göre öneriler oluştur
      final recommendations = <ProductRecommendation>[];
      
      for (final product in state.allProducts) {
        double relevanceScore = 0.0;
        String reason = '';
        int priority = 0;

        // Cilt tipi uyumu
        for (final skinType in skinTypes) {
          if (product.skinTypes.contains(skinType)) {
            relevanceScore += 0.3;
            reason += '${product.categoryName} cilt tipinize uygun. ';
            priority += 1;
          }
        }

        // Cilt sorunları uyumu
        for (final concern in concerns) {
          if (product.concerns.contains(concern)) {
            relevanceScore += 0.4;
            reason += '$concern sorununuz için önerilir. ';
            priority += 2;
          }
        }

        // Hassasiyet düzeyi
        if (sensitivityLevel > 0.5 && product.skinTypes.contains('sensitive')) {
          relevanceScore += 0.2;
          reason += 'Hassas ciltler için uygundur. ';
          priority += 1;
        }

        // Ürün rating'i
        relevanceScore += (product.rating - 3.0) * 0.1;

        if (relevanceScore > 0.5) {
          recommendations.add(ProductRecommendation(
            product: product,
            relevanceScore: relevanceScore.clamp(0.0, 1.0),
            reason: reason.trim(),
            priority: priority,
          ));
        }
      }

      // Önceliğe göre sırala
      recommendations.sort((a, b) {
        if (b.priority != a.priority) {
          return b.priority.compareTo(a.priority);
        }
        return b.relevanceScore.compareTo(a.relevanceScore);
      });

      state = state.copyWith(
        recommendations: recommendations.take(10).toList(),
        isLoading: false,
      );

    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Öneriler oluşturulurken hata oluştu: $e',
      );
    }
  }

  // Favori ürün ekle/çıkar
  Future<void> toggleFavoriteProduct(String productId) async {
    try {
      final product = state.allProducts.firstWhere((p) => p.id == productId);
      final isFavorite = state.favoriteProducts.any((p) => p.id == productId);

      if (isFavorite) {
        state = state.copyWith(
          favoriteProducts: state.favoriteProducts
              .where((p) => p.id != productId)
              .toList(),
        );
      } else {
        state = state.copyWith(
          favoriteProducts: [...state.favoriteProducts, product],
        );
      }

      // Firestore'da favori durumunu güncelle
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Favori ürün güncellenirken hata oluştu: $e',
      );
    }
  }

  // Ürün ara
  List<Product> searchProducts(String query) {
    if (query.isEmpty) return state.allProducts;
    
    return state.allProducts.where((product) {
      return product.name.toLowerCase().contains(query.toLowerCase()) ||
             product.description.toLowerCase().contains(query.toLowerCase()) ||
             product.brandName.toLowerCase().contains(query.toLowerCase()) ||
             product.categoryName.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // Kategoriye göre ürünleri filtrele
  List<Product> getProductsByCategory(ProductCategory category) {
    return state.categorizedProducts[category] ?? [];
  }

  // Hata mesajını temizle
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}

// Provider tanımlamaları
final productsProvider = StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  return ProductsNotifier();
});

// Ürün önerileri provider'ı
final productRecommendationsProvider = Provider<List<ProductRecommendation>>((ref) {
  return ref.watch(productsProvider).recommendations;
});

// Favori ürünler provider'ı
final favoriteProductsProvider = Provider<List<Product>>((ref) {
  return ref.watch(productsProvider).favoriteProducts;
});

// Kategorilere göre ürünler provider'ı
final categorizedProductsProvider = Provider<Map<ProductCategory, List<Product>>>((ref) {
  return ref.watch(productsProvider).categorizedProducts;
});