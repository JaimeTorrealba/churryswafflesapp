class Order {
  int itemNumber;
  int order;
  DateTime time;
  int total;
  String payment;
  String direction;

  Order({required this.itemNumber, required this.order, required this.time, required this.total, required this.payment, required this.direction});
}