const functions = require('firebase-functions');
const Stripe = require('stripe');
const admin = require('firebase-admin');
const { firestore } = require('firebase-admin');
const { user } = require('firebase-functions/lib/providers/auth');
admin.initializeApp();

const firestoreInstance = admin.firestore();
// const settings = { timestampsInSnapshots: true };
// firestore.settings(settings);

// export const stripeSecret = functions.config().stripe.secret;

// export const stripe = new Stripe(stripeSecret);

// export const testFunction = functions.https.onCall(async(data, context) => {

//   const uid = context.auth  && context.auth.uid;
//   const message = data.message;

//   return '${uid} sent a message of: ${message}'
// });




exports.onFileUpload = functions.storage.object().onFinalize(async (fileObject) => {
  // const firestore = admin.firestore();
  if (!fileObject.name.endsWith('/')) {
    var fileName = fileObject.name.split("/")[1]
    var projectName = fileObject.name.split("/")[0]

    await firestore.collection('files').where('name', '==', fileName).where('project', '==', projectName).get().then(snapshot => {
      if (snapshot.empty) {
        console.log('Adding file ' + fileName + ' to the project ' + projectName)
        addFileToDB(fileName, projectName);
      } else {
        console.log('Document has been updated: ' + fileName)
        snapshot.forEach(doc => {
          doc.ref.update({ updated: admin.firestore.Timestamp.now() })
        })
      }
    }).catch(err => {
      console.log('Error while finding document: ', err);
    });
  } else {
    var projectName = fileObject.name.split("/")[0]
    await firestore.collection('projects').where('project', '==', projectName).get().then(snapshot => {
      if (snapshot.empty) {
        console.log('Creating project ' + projectName + ' folder')
        addProjectToDB(projectName);
      }
    }).catch(err => {
      console.log('Error while finding document: ', err);
    });
  }
})


exports.onFileDeletion = functions.storage.object().onDelete(async (fileObject) => {
  var fileName = fileObject.name.split("/")[1]
  var projectName = fileObject.name.split("/")[0]

  if (!fileObject.name.endsWith('/')) {
    await firestore.collection('files').where('name', '==', fileName).where('project', '==', projectName).get().then(snapshot => {
      if (snapshot.empty) {
        console.log('No document found');
        return;
      }
      snapshot.forEach(doc => {
        const bucket = admin.storage().bucket();
        const storageFile = bucket.file(projectName + '/' + fileName);
        storageFile
          .exists()
          .then((exist) => {
            if (exist[0]) {
              console.log("File was updated, should not delete DB reference");
            } else {
              console.log('Deleting file: ' + fileName)
              doc.ref.delete();
            }
          })
          .catch(() => {
            console.error('Error while fetching data to  be delete')
          });
      });
    })
      .catch(err => {
        console.log('Error while deleting document: ', err);
      });
  } else {
    await firestore.collection('projects').where('project', '==', projectName).get().then(snapshot => {
      if (snapshot.empty) {
        console.log('No document found');
        return;
      }
      snapshot.forEach(doc => {
        console.log('Deleting project: ' + projectName)
        doc.ref.delete();
      });
    })
      .catch(err => {
        console.log('Error while deleting document: ', err);
      });
  }

})


async function addFileToDB(fileName, projectName) {
  const file = {
    name: String(fileName),
    project: String(projectName),
    updated: admin.firestore.Timestamp.now()
  };

  await firestore.collection('files').add(file).then(() => {
    console.log('File added');
  }, (error) => {
    console.error('Error while adding file');
    console.error(error);
  });
}


async function addProjectToDB(projectName) {
  const folder = {
    project: String(projectName),
  };

  await firestore.collection('projects').add(folder).then(() => {
    console.log('Folder added');
  }, (error) => {
    console.error('Error while adding project');
    console.error(error);
  });
}

// Creates the user data on the database when a new user is created
exports.onUserCreation = functions.auth.user().onCreate(async (user) => {
  const userData = {
    UID: String(user.uid),
    email: String(user.email),
    projects: [],
    userType: String('reader'),
    creation: admin.firestore.Timestamp.now(),
    planExpires: null,
    stripe: {
      stripeUID: null,
      stripeClient: null,
      stripeData: null,
    }
  };

  // Creates the user data
  await firestoreInstance.doc(`users/${user.uid}`).set(userData).then(() => {
    console.log('User data added');
  }, (error) => {
    console.error('Error while adding user data');
    console.error(error);
    return false;
  });

  const initialStripeTrasaction = {
    transactionID: null,
    transactionDate: admin.firestore.Timestamp.now(),
    transactionType: null,
    transactionAmount: null,
  };

  // Creates the user Stripe log collection
  await firestoreInstance.doc(`users/${user.uid}`).collection('stripe-trasactions').doc().set(initialStripeTrasaction).then(() => {
    console.log('Stripe transactions added');
  }, (error) => {
    console.error('Error while adding stripe transactions');
    console.error(error);
    return false
  });

  return true;
});

//TODO make a listener on flutter to listen to the users collection, when a user with the same uid is added, add phone number
exports.addUserPhoneNumber = functions.https.onCall(async (data, context) => {
  const phoneNumber = data.phone;
  const userID = data.uid;
  
  await firestoreInstance.doc(`users/${userID}`).get().then((doc) => {
    if (doc.exists) {
      console.log(doc.data);
      doc.ref.update({'phone': phoneNumber})
      console.log(`Adding the phone number (${phoneNumber}) to the userID (${userID})`)
    } else {
      console.error(`Couldnt find the document with the userID (${userID})`)
    }
  }).catch((error) => {
    console.error('An unexpected error ocurred')
    console.error(error);
  })
  return true;
});