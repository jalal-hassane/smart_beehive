import 'package:smart_beehive/data/local/models/beehive.dart';
import 'package:smart_beehive/utils/constants.dart';

class Beekeeper {
  String id;
  String? firebaseId;
  String? username;
  String? password;
  String? profileImage;
  List<Beehive>? beehives;

  Beekeeper(this.id);

  toMap(){
    return {
      fieldId:id,
      fieldUsername:username,
      fieldPassword:password,
      fieldImage:profileImage,
      fieldHives: beehives?.map((e) => e.toMap()).toList()
    };
  }
}
