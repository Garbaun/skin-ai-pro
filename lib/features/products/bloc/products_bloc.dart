import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../core/models/product_models.dart';
import '../../../core/services/products_service.dart';

part 'products_event.dart';
part 'products_state.dart';

class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final ProductsService _productsService;
  
  ProductsBloc({required ProductsService productsService})
      : _productsService = productsService,
        super(ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<SearchProducts>(_onSearchProducts);
    on<FilterByCategory>(_onFilterByCategory);
    on<AddToCart>(_onAddToCart);
    on<BuyNow>(_onBuyNow);
    on<ToggleFavorite>(_onToggleFavorite);
    on<LoadProductDetail>(_onLoadProductDetail);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());
    
    try {
      final products = await _productsService.getRecommendedProducts();
      emit(ProductsLoaded(products: products));
    } catch (e) {
      emit(ProductsError(message: 'Failed to load products: ${e.toString()}'));
    }
  }

  Future<void> _onSearchProducts(
    SearchProducts event,
    Emitter<ProductsState> emit,
  ) async {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      
      try {
        if (event.query.isEmpty) {
          final products = await _productsService.getRecommendedProducts();
          emit(currentState.copyWith(products: products));
        } else {
          final filteredProducts = currentState.products
              .where((product) =>
                  product.name.toLowerCase().contains(event.query.toLowerCase()) ||
                  product.brand.toLowerCase().contains(event.query.toLowerCase()) ||
                  product.description.toLowerCase().contains(event.query.toLowerCase()))
              .toList();
          
          if (filteredProducts.isEmpty) {
            final searchResults = await _productsService.searchProducts(event.query);
            emit(currentState.copyWith(products: searchResults));
          } else {
            emit(currentState.copyWith(products: filteredProducts));
          }
        }
      } catch (e) {
        emit(ProductsError(message: 'Search failed: ${e.toString()}'));
      }
    }
  }

  Future<void> _onFilterByCategory(
    FilterByCategory event,
    Emitter<ProductsState> emit,
  ) async {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      
      try {
        if (event.category == 'All') {
          final products = await _productsService.getRecommendedProducts();
          emit(currentState.copyWith(products: products));
        } else {
          final filteredProducts = await _productsService.getProductsByCategory(event.category);
          emit(currentState.copyWith(products: filteredProducts));
        }
      } catch (e) {
        emit(ProductsError(message: 'Filter failed: ${e.toString()}'));
      }
    }
  }

  Future<void> _onAddToCart(
    AddToCart event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      await _productsService.addToCart(event.product);
      
      if (state is ProductsLoaded) {
        final currentState = state as ProductsLoaded;
        emit(ProductsLoaded(
          products: currentState.products,
          cartMessage: '${event.product.name} added to cart',
        ));
      }
    } catch (e) {
      emit(ProductsError(message: 'Failed to add to cart: ${e.toString()}'));
    }
  }

  Future<void> _onBuyNow(
    BuyNow event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      await _productsService.buyNow(event.product);
      
      if (state is ProductsLoaded) {
        final currentState = state as ProductsLoaded;
        emit(ProductsLoaded(
          products: currentState.products,
          buyMessage: 'Redirecting to checkout...',
        ));
      }
    } catch (e) {
      emit(ProductsError(message: 'Purchase failed: ${e.toString()}'));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavorite event,
    Emitter<ProductsState> emit,
  ) async {
    try {
      await _productsService.toggleFavorite(event.product);
      
      if (state is ProductsLoaded) {
        final currentState = state as ProductsLoaded;
        final updatedProducts = currentState.products.map((product) {
          if (product.id == event.product.id) {
            return product.copyWith(isFavorite: !product.isFavorite);
          }
          return product;
        }).toList();
        
        emit(currentState.copyWith(products: updatedProducts));
      }
    } catch (e) {
      emit(ProductsError(message: 'Failed to update favorite: ${e.toString()}'));
    }
  }

  Future<void> _onLoadProductDetail(
    LoadProductDetail event,
    Emitter<ProductsState> emit,
  ) async {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;
      
      try {
        final productDetail = await _productsService.getProductDetail(event.productId);
        
        final updatedProducts = currentState.products.map((product) {
          if (product.id == event.productId) {
            return productDetail;
          }
          return product;
        }).toList();
        
        emit(currentState.copyWith(products: updatedProducts));
      } catch (e) {
        emit(ProductsError(message: 'Failed to load product detail: ${e.toString()}'));
      }
    }
  }
}