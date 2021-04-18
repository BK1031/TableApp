var admin = require("firebase-admin");

var serviceAccount = require("./serviceAccountKey.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: "https://table-app-calhacks-default-rtdb.firebaseio.com"
});


admin.database().ref("notifications").on("child_added", (snapshot) => {
    admin.database().ref("users").child(snapshot.val()["user"]).child("fcmToken").once("value", (token) => {
        if (token.val() != null) {
            admin.messaging().send({
                token: token.val(),
                notification: {
                    title: snapshot.val()["title"],
                    body: snapshot.val()["desc"]
                },
            });
        }
    })
});