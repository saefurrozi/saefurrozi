import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:restoran_app/data/api/api_service.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  test('test Api Service', () async {
    Future<http.Response> _mockRequest(http.Request request) async {
      if (request.url
          .toString()
          .startsWith('https://restaurant-api.dicoding.dev/list')) {
        return http.Response(
            File('test/source/restoran_list.json').readAsStringSync(), 200,
            headers: {
              HttpHeaders.contentTypeHeader: 'application/json',
            });
      }
      return http.Response('Error: Unknown endpoint', 404);
    }

    final apiService = ApiService(MockClient(_mockRequest));
    final resto = await apiService.getListRestaurant();
    expect(resto.restaurants.length, 20);
    expect(resto.error, false);
    expect(resto.restaurants.elementAt(0).id, "rqdv5juczeskfw1e867");
    expect(resto.restaurants.elementAt(0).name, "Melting Pot");
    expect(resto.restaurants.elementAt(0).description,
        "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.");
    expect(resto.restaurants.elementAt(0).pictureId, "14");
    expect(resto.restaurants.elementAt(0).city, "Medan");
    expect(resto.restaurants.elementAt(0).rating, 4.2);
  });
}
