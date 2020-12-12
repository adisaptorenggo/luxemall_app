
class Product{

  int id;
  String title;
  double price;
  String description;
  String category;
  String image;
  int quantity;
  double total;

  Product(
      {
        this.id = 0,
        this.title = '',
        this.price = 0.0,
        this.description = '',
        this.category = '',
        this.image = '',
        this.quantity = 0,
        this.total = 0.0,
      }
  );

  @override
  String toString() {
    return 'Product{_id: $id, _title: $title, _price: $price, _description: $description, _category: $category, _image: $image, _quantity: $quantity, _total: $total}';
  }
}