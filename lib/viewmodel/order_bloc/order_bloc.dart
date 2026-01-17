import 'dart:developer';
import 'package:avodha_interview_test/model/orderModel.dart';
import 'package:bloc/bloc.dart';
import 'package:hive/hive.dart';
import 'package:meta/meta.dart';

part 'order_event.dart';
part 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final String boxName = "orders";
  final String sessionBoxName = "sessionBox"; 

  OrderBloc() : super(OrderInitial()) {
    on<AddOrderEvent>((event, emit) async {
      emit(OrderLoading());
      try {
        log("Called");

        var box = await Hive.openBox(boxName);
        var sessionBox = await Hive.openBox(sessionBoxName);

        final email = sessionBox.get("email");
        log("Email: $email");
        if (email == null) throw Exception("User not logged in");

        List<Map<String, dynamic>> userOrders = [];
        if (box.containsKey(email)) {
          final existing = await box.get(email);
          if (existing is List) {
            userOrders = existing
                .map((e) => Map<String, dynamic>.from(e as Map))
                .toList();
          }
        }

 
        userOrders.add(event.order.toMap());
        log("Total Orders: ${userOrders.length}");

        await box.put(email, userOrders);

        final orders = userOrders
            .map((e) => OrderModel.fromMap(Map<String, dynamic>.from(e)))
            .toList();

        emit(OrderSuccess(orders));
      } catch (e, st) {
        log(st.toString());
        emit(OrderFailure(e.toString()));
      }
    });

    on<ViewAllOrdersEvent>((event, emit) async {
      emit(OrderLoading());
      try {
        var box = Hive.box(boxName);
        var sessionBox = Hive.box(sessionBoxName);

        final email = sessionBox.get("email");
        if (email == null) throw Exception("User not logged in");

        List<Map<String, dynamic>> userOrders = [];
        if (box.containsKey(email)) {
          userOrders = List<Map<String, dynamic>>.from(await box.get(email));
        }

        final orders = userOrders
            .map((e) => OrderModel.fromMap(Map<String, dynamic>.from(e)))
            .toList();

        emit(OrderSuccess(orders));
      } catch (e) {
        emit(OrderFailure(e.toString()));
      }
    });
  }
}
