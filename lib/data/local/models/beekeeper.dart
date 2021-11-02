import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/utils/constants.dart';

class Beekeeper {
  String docId;
  String? username;
  String? password;
  String? profileImage;
  List<Beehive>? beehives;

  Beekeeper(this.docId);

  toMap(){
    return {
      fieldId:docId,
      fieldUsername:username,
      fieldPassword:password,
      fieldImage:profileImage,
      fieldHives: beehives?.map((e) => e.toMap()).toList()
    };
  }
}
