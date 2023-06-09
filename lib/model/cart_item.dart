import 'package:hive/hive.dart';
part 'cart_item.g.dart';

@HiveType(typeId: 1)
class CartItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String product_name;

  @HiveField(2)
  String image;

  @HiveField(3)
  int quantity;

  @HiveField(4)
  int price;

  CartItem(
      {required this.id,
      required this.image,
      required this.price,
      required this.product_name,
      required this.quantity});
}
