import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/order_entity.dart';
import '../../data/datasources/orders_remote_data_source.dart';

part 'orders_state.dart';

class OrdersCubit extends Cubit<OrdersState> {
  final OrdersRemoteDataSource _dataSource;

  OrdersCubit(this._dataSource) : super(const OrdersState());

  Future<void> loadOrders() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final orders = await _dataSource.getOrders();
      emit(state.copyWith(isLoading: false, orders: orders));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }

  Future<void> updateStatus(String orderId, String status) async {
    emit(state.copyWith(isActionInProgress: true, error: null));
    try {
      await _dataSource.updateOrderStatus(orderId, status);
      await loadOrders(); // Reload to get fresh data
      emit(state.copyWith(isActionInProgress: false));
    } catch (e) {
      emit(state.copyWith(isActionInProgress: false, error: e.toString()));
    }
  }
}
