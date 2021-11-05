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

// every 5 minutes job
exports.collectFiveMinutesData = functions.pubsub
    .schedule("*/5 * * * *")
    .timeZone("Europe/London")
    .onRun((context) => {
      admin.firestore().collection("Properties")
          .get()
          .then((query) => {
            query.forEach((doc) => {
              const metadata = doc.data();
              console.log("Properties => " + Object.keys(doc));
              console.log("Properties => " + Object.values(doc));
              const time = admin.firestore.Timestamp.fromDate(new Date());
              metadata.temperature_5.push(
                  {
                    date: time,
                    value: metadata.temperature,
                  }
              );
              metadata.weight_5.push(
                  {
                    date: time,
                    value: metadata.weight,
                  }
              );
              metadata.humidity_5.push(
                  {
                    date: time,
                    value: metadata.humidity,
                  }
              );
              metadata.population_5.push(
                  {
                    date: time,
                    value: metadata.population,
                  }
              );
              return doc.ref.update(metadata, {merge: true});
            });
          })
          .catch((error) => {
            console.log("Catching error => " + error);
          });
    });

// every day job
exports.collectDailyData = functions.pubsub
    .schedule("0 0 * * *")
    .timeZone("Europe/London")
    .onRun((context) => {
      admin.firestore().collection("Properties")
          .get()
          .then((query) => {
            query.forEach((doc) => {
              const metadata = doc.data();
              console.log("Properties => " + Object.keys(doc));
              console.log("Properties => " + Object.values(doc));
              const time = admin.firestore.Timestamp.fromDate(new Date());
              metadata.temperature_day.push(
                  {
                    date: time,
                    value: metadata.temperature,
                  }
              );
              metadata.weight_day.push(
                  {
                    date: time,
                    value: metadata.weight,
                  }
              );
              metadata.humidity_day.push(
                  {
                    date: time,
                    value: metadata.humidity,
                  }
              );
              metadata.population_day.push(
                  {
                    date: time,
                    value: metadata.population,
                  }
              );
              return doc.ref.update(metadata, {merge: true});
            });
          })
          .catch((error) => {
            console.log("Catching error => " + error);
          });
    });

exports.raiseSwarmingAlert = functions.firestore
    .document("Hives/{id}")
    .onUpdate((change, context) => {
      const hiveId = context.params.id;
      const hive = change.after.data();

      if (hive.swarming) {
        admin.firestore().collection("Beekeeper")
            .doc(hive.KeeperID)
            .get()
            .then((doc) => {
              console.log("doc exists");
              const metadata = doc.data();
              const token = metadata.deviceToken;
              const payload = {
                data: {
                  "title": "Swarm Warning",
                  "body": "The hive might be swarming" + pleaseClickHere,
                  "open_page": "Farm",
                  "hive_id": hiveId,
                  "analysis": "Swarming",
                },
                notification: {
                  "title": "Swarm Warning",
                  "body": "The hive might be swarming" + pleaseClickHere,
                },
                token: token,
              };

              return admin.messaging().send(payload).catch((error) => {
                console.log("Catching error => " + error);
              });
            })
            .catch((error) => {
              console.log("Error getting documents: ", error);
            });
      }
    });

exports.alertBeekeeper = functions.firestore
    .document("/Properties/{id}")
    .onUpdate((change, context) => {
    // check for alerts
      const propId = context.params.id;
      const payloads = [];
      const mProperties = change.after.data();
      console.log("mProperties => " + Object.values(mProperties));
      console.log("mProperties => " + Object.keys(mProperties));
      for (let i = 0; i < mProperties.alerts.length; i++) {
        const alert = mProperties.alerts[i];
        switch (alert.type) {
          case "Temperature":
            payloads
                .push(
                    getPayload(alert, mProperties.temperature,
                        propId
                    )
                );
            break;
          case "Humidity":
            payloads
                .push(
                    getPayload(alert, mProperties.humidity,
                        propId
                    )
                );
            break;
          case "Population":
            payloads
                .push(
                    getPayload(alert, mProperties.population,
                        propId
                    )
                );
            break;
          default:
            payloads
                .push(
                    getPayload(alert, mProperties.weight,
                        propId
                    )
                );
        }
      }
      if (payloads.length == 0) {
        return console.log("No alerts to be raised");
      }
      admin.firestore().collection("Beekeeper")
          .doc(mProperties.KeeperID)
          .get()
          .then((doc) => {
            // doc.data() is never undefined for query doc snapshots
            const metadata = doc.data();
            const token = metadata.deviceToken;
            for (let k = 0; k < payloads.length; k++) {
              payloads[k].token = token;
            }
            try {
              return admin.messaging().sendAll(payloads);
            } catch (error) {
              console.log("Catching error => " + error);
            }
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

