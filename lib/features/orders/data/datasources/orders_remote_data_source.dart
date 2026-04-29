import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/supabase/supabase_config.dart';
import '../models/order_model.dart';

abstract class OrdersRemoteDataSource {
  Future<List<OrderModel>> getOrders();
  Future<void> updateOrderStatus(String orderId, String status);
}

class OrdersRemoteDataSourceImpl implements OrdersRemoteDataSource {
  OrdersRemoteDataSourceImpl({SupabaseClient? client})
      : _client = client ?? SupabaseConfig.client;

  final SupabaseClient _client;

  @override
  Future<List<OrderModel>> getOrders() async {
    try {
      final rows = await _client
          .from('orders')
          .select()
          .order('created_at', ascending: false);
      
      return (rows as List).map((row) => OrderModel.fromMap(row)).toList();
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }

  @override
  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      await _client.from('orders').update({'status': status}).eq('id', orderId);
    } on PostgrestException catch (e) {
      throw ServerException(e.message);
    }
  }
}
