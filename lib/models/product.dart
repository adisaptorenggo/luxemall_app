
class Product{

  int id;
  String title;
  double price;
  String description;
  String category;
  String image;

  Product(
      {
        this.id = 0,
        this.title = '',
        this.price = 0.0,
        this.description = '',
        this.category = '',
        this.image = '',
      }
  );

  @override
  String toString() {
    return 'Product{_id: $id, _title: $title, _price: $price, _description: $description, _category: $category, _image: $image}';
  }
}