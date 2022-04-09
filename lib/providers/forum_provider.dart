
import 'dart:convert';

import 'package:historyar_app/helpers/constant_helpers.dart';
import 'package:historyar_app/model/forum_holder.dart';
import 'package:historyar_app/utils/alert.dart';

import 'package:http/http.dart' as http;

class ForumProvider {
  Alert _alert = Alert();

  Future<List<ForumHolder>> getAll(int type, ) async {
    var response = await http.get(
        Uri.parse("${Constants.URL}/api/publicaciones"));

    var jsonData = json.decode(response.body);

    List<ForumHolder> foros = [];

    for(var aux in jsonData) {
      ForumHolder foro = ForumHolder(id: aux["id"],
          imagUrl: "https://historyar-bucket.s3.amazonaws.com/foros/cropped-851-315-459566.jpg",
          title: aux["tema"],
          description: aux["descripcion"]);

      foros.add(foro);
    }

    return foros;
  }


}