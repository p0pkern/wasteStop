import 'package:flutter_test/flutter_test.dart';
import '../lib/models/entries.dart';

void main() {
  test('Test that the map i created have appropriate property values', () {

    final date = DateTime.parse('2020-01-01');
    const imageUrl = 'FAKE';
    const quantity = 2;
    const latitude = 1.0;
    const longitude = 2.0;

    final Entries entries = Entries(
      date : date,
      imageUrl : imageUrl,
      quantity : quantity,
      latitude : latitude,
      longitude :longitude,
    );

    expect(entries.date, date);
    expect(entries.imageUrl, imageUrl);
    expect(entries.quantity, quantity);
    expect(entries.latitude, latitude);
    expect(entries.longitude, longitude);

  });

  test('Test for empty model and addition of values', () {

    final Entries entries = Entries();

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

    expect(entries.date, DateTime.parse('2022-01-01'));
    expect(entries.imageUrl, 'Fake');
    expect(entries.quantity, 3);
    expect(entries.latitude, 21.2);
    expect(entries.longitude, 1.223);

  });
}
