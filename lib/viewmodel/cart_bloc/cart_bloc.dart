import 'package:avodha_interview_test/view/customWidget/toast.dart';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc() : super(CartInitial()) {
    on<AddToCart>(_onAddToCart);
    on<RemoveFromCart>(_onRemoveFromCart);
    on<GetAllCartItems>(_onGetAllCartItems);
  }

  Future<void> _onAddToCart(AddToCart event, Emitter<CartState> emit) async {
    emit(CartLoading());
    try {
      final box = await Hive.openBox('cart');

      Map<String, dynamic> userCart = Map<String, dynamic>.from(
        box.get(event.email, defaultValue: {}),
      );

      final productId = event.product['id'].toString();
      userCart[productId] = event.product;

      await box.put(event.email, userCart);

      Utils().showToast("Added To Cart");

      emit(
        CartLoaded(
          userCart.values.map((e) => Map<String, dynamic>.from(e)).toList(),
        ),
      );
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onRemoveFromCart(
    RemoveFromCart event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      final box = await Hive.openBox('cart');

      Map<String, dynamic> userCart = Map<String, dynamic>.from(
        box.get(event.email, defaultValue: {}),
      );

      userCart.remove(event.productId);

      await box.put(event.email, userCart);

      emit(
        CartLoaded(
          userCart.values.map((e) => Map<String, dynamic>.from(e)).toList(),
        ),
      );
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }

  Future<void> _onGetAllCartItems(
    GetAllCartItems event,
    Emitter<CartState> emit,
  ) async {
    emit(CartLoading());
    try {
      final box = await Hive.openBox('cart');

      Map<String, dynamic> userCart = Map<String, dynamic>.from(
        box.get(event.email, defaultValue: {}),
      );

      emit(
        CartLoaded(
          userCart.values.map((e) => Map<String, dynamic>.from(e)).toList(),
        ),
      );
    } catch (e) {
      emit(CartError(e.toString()));
    }
  }
}
