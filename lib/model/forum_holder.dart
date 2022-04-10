import 'package:historyar_app/model/comment.dart';

class ForumHolder {
  final int id;
  final String imagUrl;
  final String title;
  final String description;

  ForumHolder({
    required this.id,
    required this.imagUrl,
    required this.title,
    required this.description
  });
}

//For rows and columns with card images
/*
final rowList = [
  ForumHolder(
    imagUrl:
        'https://i.picsum.photos/id/26/200/300.jpg?hmac=E9i_aIqa_ifLvxqI2b1QTLCnhGQYJ83IpvaDfFM54bU',
    title: 'HTML como curso',
    description: 'Respuestas: 1000',
  ),
  ForumHolder(
    imagUrl:
        'https://i.picsum.photos/id/490/200/300.jpg?hmac=8hYDsOwzzMCthBMYMN9bM6POtrJfVAmsvamM2oOEiF4',
    title: 'Fisica nuclear',
    description: 'Respuestas: 20',
  ),
  ForumHolder(
    imagUrl:
        'https://i.picsum.photos/id/611/200/300.jpg?hmac=g8018R8VfYX1xH5vjzmk368winrl1sOYBU5FghLJLyE',
    title: 'Codigos nucleares',
    description: 'Respuestas: 1',
  )
];
*/