import 'package:get/get.dart';

class DetailFoodController extends GetxController {
  //TODO: Implement DetailFoodController
  // bool is favorite
  var isFavorite = false.obs;
  void toggleFavorite() {
    isFavorite.value = !isFavorite.value;
  }
  // Data untuk setiap langkah
  List<Map<String, dynamic>> steps = [
    {
      'title': 'Siapkan Adonan',
      'substeps': [
        'Campur tepung, ragi, gula, dan garam.',
        'Tambahkan air hangat dan minyak.',
        'Uleni hingga kalis (±10 menit).',
        'Diamkan 1 jam sampai mengembang 2×.'
      ]
    },
    {
      'title': 'Bentuk Kulit Pizza',
      'substeps': [
        'Pipihkan adonan di loyang (diameter ±25 cm).',
        'Tusuk-tusuk ringan permukaan dengan garpu.'
      ]
    },
    {
      'title': 'Oles Saus',
      'substeps': [
        'Ratakan saus tomat di atas adonan.',
        'Tambahkan sedikit oregano/basil.'
      ]
    },
    {
      'title': 'Tambahkan Keju',
      'substeps': [
        'Taburkan mozzarella (dan parmesan/cheddar bila ada).',
        'Pastikan merata hingga ke pinggir.'
      ]
    },
    {
      'title': 'Panggang',
      'substeps': [
        'Panggang di oven 200°C selama 12–15 menit hingga keju meleleh dan pinggir kecoklatan.'
      ]
    },
    {
      'title': 'Sajikan',
      'substeps': [
        'Keluarkan dari oven, beri sedikit oregano.',
        'Potong dan sajikan hangat.'
      ]
    },
  ];

//   List nutrisionFacts
  List<Map<String, dynamic>> nutritionFacts = [
    {'name': 'Kalori', 'value': '285 kkal'},
    {'name': 'Protein', 'value': '12 g'},
    {'name': 'Lemak', 'value': '10 g'},
    {'name': 'Karbohidrat', 'value': '36 g'},
    {'name': 'Serat', 'value': '2 g'},
    {'name': 'Gula', 'value': '4 g'},
  ];
//   List of ingredients
  List<Map<String, dynamic>> ingridients = [
    {'name': 'Tepung Terigu', 'quantity': '250 g'},
    {'name': 'Ragi Instan', 'quantity': '7 g'},
    {'name': 'Gula Pasir', 'quantity': '1 sdt'},
    {'name': 'Garam', 'quantity': '1/2 sdt'},
    {'name': 'Air Hangat', 'quantity': '150 ml'},
    {'name': 'Minyak Zaitun', 'quantity': '2 sdm'},
    {'name': 'Saus Tomat', 'quantity': '100 g'},
    {'name': 'Keju Mozzarella', 'quantity': '150 g'},
    {'name': 'Oregano/Basil Kering', 'quantity': 'secukupnya'},
  ];
}
