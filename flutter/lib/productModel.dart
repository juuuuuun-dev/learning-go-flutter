class Product {
  String name;
  double price;
  int count;

  Product(this.name, this.price, this.count);
  Product.fromJson(Map<String,dynamic> json)
   : name = json["Name"],
   price = json["Price"],
   count = json["Count"]
}
