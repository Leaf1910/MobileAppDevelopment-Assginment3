class Order {
  final int? id;
  final String foodItem;
  final double cost;
  final String date;
  final double targetCost;

  Order({
    this.id,
    required this.foodItem,
    required this.cost,
    required this.date,
    required this.targetCost,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'foodItem': foodItem,
      'cost': cost,
      'date': date,
      'targetCost': targetCost,
    };
  }

  factory Order.fromMap(Map<String, dynamic> map) {
    return Order(
      id: map['id'],
      foodItem: map['foodItem'],
      cost: map['cost'],
      date: map['date'],
      targetCost: map['targetCost'],
    );
  }
}
