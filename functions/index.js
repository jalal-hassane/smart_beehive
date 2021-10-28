// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const functions = require("firebase-functions");
const admin = require("firebase-admin");
const pleaseClickHere = ", please click here for more details";

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

exports.alertBeekeeper = functions.firestore
    .document("/Beekeeper/{id}")
    .onUpdate((change, context) => {
      const newValue = change.after.data();

      console.log("newValue " + newValue);

      console.log("id " + context.params.id);

      const name = newValue.username;
      const hives = newValue.hives;
      const hiveFId = hives[0].id;
      const hiveLogs = hives[0].logs;
      const hiveOverview = hives[0].overview;
      console.log("hiveFId " + hiveFId);
      console.log("hiveLogs " + hiveLogs);
      console.log("hiveLogs2 " + hiveLogs.feeds);
      console.log("hiveOverview " + hiveOverview.date);
      const hivesValues = Object.values(newValue.hives);
      console.log("hivesValues " + hivesValues);
      const hive0 = Object.entries(hives[0]);
      const hive0Keys = Object.keys(hives[0]);
      const hive0Values = Object.values(hives[0]);
      const hiveId = hive0["id"];

      console.log("hive0Keys " + hive0Keys);
      console.log("hive0Values " + hive0Values);

      console.log("HiveId " + hiveId);
      console.log("name " + name);
      console.log("hives " + hives);
      console.log("hive0 " + hive0);
      console.log("name2 " + name);
      const token = newValue.deviceToken;
      console.log("token " + token);

      const payloadWarning = {

        data: {
          title: "Warning",
          body: "Your hive is in danger" + pleaseClickHere,
          open_page: "Farm",
          hive_id: hiveId,
          analysis: "temp",
        },
        notification: {
          title: "Warning",
          body: "Your hive is in danger" + pleaseClickHere,
          open_page: "Farm",
          hive_id: hiveId,
          analysis: "temp",
        },

      };

      // todo add registration token to firebase
      return admin.messaging().sendToDevice(token, payloadWarning);
    });
