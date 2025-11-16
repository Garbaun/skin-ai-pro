part of 'products_bloc.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

class ProductsError extends ProductsState {
  final String message;

  const ProductsError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final String? cartMessage;
  final String? buyMessage;

  const ProductsLoaded({
    required this.products,
    this.cartMessage,
    this.buyMessage,
  });

  ProductsLoaded copyWith({
    List<Product>? products,
    String? cartMessage,
    String? buyMessage,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      cartMessage: cartMessage,
      buyMessage: buyMessage,
    );
  }

  @override
  List<Object> get props => [products, cartMessage ?? '', buyMessage ?? ''];
}
