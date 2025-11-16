part of 'products_bloc.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductsEvent {
  const LoadProducts();
}

class SearchProducts extends ProductsEvent {
  final String query;

  const SearchProducts(this.query);

  @override
  List<Object> get props => [query];
}

class FilterByCategory extends ProductsEvent {
  final String category;

  const FilterByCategory(this.category);

  @override
  List<Object> get props => [category];
}

class AddToCart extends ProductsEvent {
  final Product product;

  const AddToCart(this.product);

  @override
  List<Object> get props => [product];
}

class BuyNow extends ProductsEvent {
  final Product product;

  const BuyNow(this.product);

  @override
  List<Object> get props => [product];
}

class ToggleFavorite extends ProductsEvent {
  final Product product;

  const ToggleFavorite(this.product);

  @override
  List<Object> get props => [product];
}

class LoadProductDetail extends ProductsEvent {
  final String productId;

  const LoadProductDetail(this.productId);

  @override
  List<Object> get props => [productId];
}
