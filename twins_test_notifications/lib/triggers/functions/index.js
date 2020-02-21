const functions = require('firebase-functions');
//firebase deploy --only functions

const admin = require('firebase-admin');
admin.initializeApp();

// Listen for updates to any `user` document.
exports.countNameChanges = functions.region('europe-west2').firestore
    .document('users/{userId}')
    .onUpdate((change, context) => {
      // Retrieve the current and previous value
      const data = change.after.data();
      const previousData = change.before.data();

      // We'll only update if the name has changed.
      // This is crucial to prevent infinite loops.
      if (data.name == previousData.name) return null;

      // Retrieve the current count of name changes
      let count = data.name_change_count;
      if (!count) {
        count = 0;
      }

      // Then return a promise of a set operation to update the count
      return change.after.ref.set({
        name_change_count: count + 1
      }, {merge: true});
    });

exports.sendNewUserNotification = functions.region('europe-west2').firestore
.document('users/{userId}')
.onCreate(async (change, context) => {
console.log('newUser')

const userName=change.data().name


  // Notification details.
  const payload = {
    notification: {
      title: 'New user!',
      body: `${userName} is a new user.`,
    },
    data:{
      comida:'pez',
    }
  };

  const token = 'eDE3uo2CgIk:APA91bHKyAdSvf9AT9FJceVww44LZEn4JwXm_xfMiR5-95lAMIzvUF5XYg_kla9_Zjm1jyVZYelk_RXoKvUK58cSEOnCU3xtUR5OqZHtdiLNtgeSXINzlN78xJ3MB5U4ipN-CmeAXgVa';

  const response = await admin.messaging().sendToDevice(token, payload);

  console.log(response)

});