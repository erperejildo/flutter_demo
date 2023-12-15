import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
admin.initializeApp();

// after sign in first time we create also
// create a document in 'users' collection
export const createProfileDocument = functions.auth.user()
  .onCreate(async (user) => {
    const uid = user.uid;

    try {
      await admin.firestore().collection("users").doc(uid).set({
        email: user.email,
        displayName: user.displayName,
      });
      return console.log("User document created successfully!");
    } catch (error) {
      return console.error("Error creating user document:", error);
    }
  });


// after doing some changes we can publish our
// functions with: firebase deploy --only functions

// NOTE: this implementation requires to have a pay-as-you-go plan in Firebase.
// I already have the maximum number of free projects and I'd have to pay to have this workin.
// Instead, I'm doing an "unnecesary" (but free) call to check if the 
// user already exist with checkNewUser() after the signIn()