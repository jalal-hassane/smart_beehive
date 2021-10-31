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

// admin.initializeApp();
// const serviceAccount = require("./service-account.json");
admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

exports.alertBeekeeper = functions.firestore
    .document("/Hives/{id}")
    .onUpdate((change, context) => {
    // check for alerts
      const payloads = [];
      const hive = change.after.data();

      if (hive.swarming) {
        payloads.push({
          data: {
            "title": "Swarm Warning",
            "body": "The hive might be swarming" + pleaseClickHere,
            "open_page": "Farm",
            "hive_id": hive.id,
            "analysis": "Swarming",
          },
          notification: {
            "title": "Swarm Warning",
            "body": "The hive might be swarming" + pleaseClickHere,
          // "open_page": "Farm",
          // "hive_id": hive.id,
          // "analysis": "Swarming",
          },
        });
      }
      const mProperties = hive.properties;
      for (let i = 0; i < mProperties.alerts.length; i++) {
        const alert = mProperties.alerts[i];
        switch (alert.type) {
          case "Temperature":
            payloads.push(getPayload(alert, mProperties.temperature, hive.id));
            break;
          case "Humidity":
            payloads.push(getPayload(alert, mProperties.humidity, hive.id));
            break;
          case "Population":
            payloads.push(getPayload(alert, mProperties.population, hive.id));
            break;
          default:
            payloads.push(getPayload(alert, mProperties.weight, hive.id));
        }
      }
      if (payloads.length == 0) {
        return console.log("No alerts to be raised");
      }
      admin.firestore().collection("Beekeeper")
          .where("id", "==", hive.keeperId)
          .get()
          .then((querySnapshot) => {
            querySnapshot.forEach((doc) => {
              // doc.data() is never undefined for query doc snapshots
              console.log(doc.id, " => ", doc.data());
              const metadata = doc.data();
              console.log("doc => " + metadata);
              const token = metadata.deviceToken;
              console.log("token => " + token);
              for (let k = 0; k < payloads.length; k++) {
                payloads[k].token = token;
                console.log("payload keys => " + Object.keys(payloads[k]));
                console.log("payload values => " + Object.values(payloads[k]));
              }
              console.log("for loop");
              // admin.messaging().send(payloads[0]);
              admin.messaging().sendAll(payloads).then((response) => {
                console.log("response keys => " + Object.keys(response));
                console.log("response values => " + Object.values(response));
              }).catch((error) => {
                console.log("Catching error => " + error);
              });
              // return console.log("finished Properly");
            });
          })
          .catch((error) => {
            console.log("Error getting documents: ", error);
          });
    });

/**
* @param {Object} alert The first number.
* @param {number} current The second number.
* @param {String} id The second number.
* @return {MessagingPayload|undefined} A promise fulfilled with the server's
* response after the message has been sent.
*/
function getPayload(alert, current, id) {
  if (current <= alert.lowerBound || current >= alert.upperBound) {
    const tooLow = current < alert.lowerBound;
    let message = "";
    if (tooLow) {
      message = " is too low";
    } else {
      message = " is too high";
    }
    return {
      data: {
        "title": alert.type + " Warning",
        "body": alert.type + message + pleaseClickHere,
        "open_page": "Farm",
        "hive_id": id,
        "analysis": alert.type,
      },
      notification: {
        "title": alert.type + " Warning",
        "body": alert.type + message + pleaseClickHere,
        // "open_page": "Farm",
        // "hive_id": id,
        // "analysis": alert.type,
      },
    };
  }
}

