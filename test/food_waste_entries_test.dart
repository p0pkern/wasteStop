import 'package:flutter_test/flutter_test.dart';
import '../lib/models/food_waste_entries.dart';

void main() {
  test('Test that the map i created have appropriate property values', () {

    final date = DateTime.parse('2020-01-01');
    const imageUrl = 'FAKE';
    const quantity = 2;
    const latitude = 1.0;
    const longitude = 2.0;

    final FoodWasteEntries entries = FoodWasteEntries(
      date : date,
      imageUrl : imageUrl,
      quantity : quantity,
      latitude : latitude,
      longitude :longitude,
    );

    expect(entries.date, entries.getDate);
    expect(entries.imageUrl, entries.getImage);
    expect(entries.quantity, entries.getQuantity);
    expect(entries.latitude, entries.getLatitude);
    expect(entries.longitude, entries.getLongitude);

  });

  test('Test for empty model and addition of values', () {

    final FoodWasteEntries entries = FoodWasteEntries();

    expect(entries.date, isNull);
    expect(entries.imageUrl, isNull);
    expect(entries.quantity, isNull);
    expect(entries.latitude, isNull);
    expect(entries.longitude, isNull);

    entries.date = DateTime.parse('2022-01-01');
    entries.imageUrl = 'Fake';
    entries.quantity = 3;
    entries.latitude = 21.2;
    entries.longitude = 1.223;

    expect(entries.getDate, DateTime.parse('2022-01-01'));
    expect(entries.getImage, 'Fake');
    expect(entries.getQuantity, 3);
    expect(entries.getLatitude, 21.2);
    expect(entries.getLongitude, 1.223);

  });
}
