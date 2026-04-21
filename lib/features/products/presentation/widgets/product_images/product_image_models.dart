import 'dart:typed_data';

enum PickSource { network, device }

class ProductImageItem {
  const ProductImageItem._({this.bytes, this.url});

  factory ProductImageItem.memory(Uint8List bytes) =>
      ProductImageItem._(bytes: bytes);
  factory ProductImageItem.network(String url) => ProductImageItem._(url: url);

  final Uint8List? bytes;
  final String? url;
}
