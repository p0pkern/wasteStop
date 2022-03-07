class FoodWasteEntries{

  String? imageUrl;
  DateTime? date;
  int? quantity;
  double? latitude;
  double? longitude;

  FoodWasteEntries({
    this.imageUrl,
    this.date,
    this.quantity,
    this.latitude,
    this.longitude
  });

  String? get getImage {
    return imageUrl;
  }

  DateTime? get getDate {
    return date;
  }

  int? get getQuantity {
    return quantity;
  }

  double? get getLatitude {
    return latitude;
  }

  double? get getLongitude {
    return longitude;
  }

}