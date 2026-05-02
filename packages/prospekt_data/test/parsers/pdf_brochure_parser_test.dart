import 'package:flutter_test/flutter_test.dart';
import 'package:prospekt_data/prospekt_data.dart';

void main() {
  late PdfBrochureParser parser;

  setUp(() {
    parser = PdfBrochureParser();
  });

  test('extracts prices and product names correctly from raw text', () {
    const mockText = '''
Markt Angebote
Frische Erdbeeren
500g
1,99
Bio Gurken
Stück
0.45
Rinderhackfleisch
500g
6,99
Schweinenackensteak
1kg
8,00
''';
    
    final offers = parser.extractOffersFromRawText(mockText, 1);

    expect(offers.length, 4);
    
    // Erdbeeren
    expect(offers[0].productName, 'Frische Erdbeeren');
    expect(offers[0].price, 1.99);
    expect(offers[0].unit, '500g');

    // Gurken
    expect(offers[1].productName, 'Bio Gurken');
    expect(offers[1].price, 0.45);
    expect(offers[1].unit, 'Stück');

    // Hackfleisch
    expect(offers[2].productName, 'Rinderhackfleisch');
    expect(offers[2].price, 6.99);
    expect(offers[2].unit, '500g');

    // Schweinenackensteak
    expect(offers[3].productName, 'Schweinenackensteak');
    expect(offers[3].price, 8.00);
    expect(offers[3].unit, '1kg');
  });

  test('handles various German price formats', () {
    const mockText = 'Milch\n1,00\nKäse\n0,99\nWurst\n2,50\nBrot\n1,50';
    final offers = parser.extractOffersFromRawText(mockText, 1);

    expect(offers[0].price, 1.00);
    expect(offers[1].price, 0.99);
    expect(offers[2].price, 2.50);
    expect(offers[3].price, 1.50);
  });
}
