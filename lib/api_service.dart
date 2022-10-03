import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;
import './constants.dart';
import './DictionaryModel.dart';

//params: {text: 'INPUT', language: 'ar', analyzed: 'true', morph: 'true'}
class ApiService {
  Future<List<DictionaryModel>?> getWord(String word) async {
    try {
      // var url = Uri.parse(ApiConstants.baseUrl + ApiConstants.usersEndpoint);
      // var response = await http.get(url);

      var response = await http.get(Uri.https(ApiConstants.baseUrl, ApiConstants.searchEndpoint,
          {'text': word, 'language': 'ar', 'analyzed': 'true', 'morph': 'true'}),
          headers: ApiConstants.headers);
      var data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        // print('inside api service');
        print(data['results']);
        List<DictionaryModel> _model = dictionaryModelFromJson(response.body);
        print('id henaa');
        // print(_model.);
        return _model;
      }
      // print('outside ifff');
    } catch (e) {
      log(e.toString());
    }
  }
}
