var firebaseConfig = {
    apiKey: "AIzaSyDcsQ666_CZBapqloYGFgCxqClyICv8V-c",
    authDomain: "hostel-hub-42ccb.firebaseapp.com",
    databaseURL: "https://hostel-hub-42ccb.firebaseio.com",
    projectId: "hostel-hub-42ccb",
    storageBucket: "hostel-hub-42ccb.appspot.com",
    messagingSenderId: "794049151568",
    appId: "1:794049151568:web:0a80943829803b27df4755",
    measurementId: "G-4KZBWTVE15"
};


// Initialize Firebase
firebase.initializeApp(firebaseConfig);
firebase.analytics();
var database = firebase.database();







async function signUpUser(email, password) {
    try {
        let res = await firebase.auth().createUserWithEmailAndPassword(email, password);
        let payload =
        {
            "status": true,
            "uid": res.user.uid,
            "emailVerified":res.user.emailVerified
        };
        return payload;
    }
    catch (err) {
        let payload=
        {
            "status": false,
            "message": err.toString()
        };
        return payload;
    }
}

async function signInUser(email, password) {
    try {
        let res = await firebase.auth().signInWithEmailAndPassword(email, password);
        let payload =
        {
            "status": true,
            "uid": res.user.uid,
            "emailVerified": res.user.emailVerified
        };
        return payload;

    }
    catch (err) {
        let payload =
        {
            "status": false,
            "message": err.toString()
        };
        return payload;
    }
}
async function resetPassword(email) {
    try {
        let res = await firebase.auth().sendPasswordResetEmail(email);
        let payload =
        {
            "status": true,
        };
        return payload;

    }
    catch (err) {
        let payload =
        {
            "status": false,
            "message": err.toString()
        };
        return payload;
    }
}
async function verifyEmail() {
    try {
        let res = await firebase.auth().currentUser.sendEmailVerification();
        let payload =
        {
            "status": true,
        };
        return payload;

    }
    catch (err) {
        let payload =
        {
            "status": false,
            "message": err.toString()
        };
        return payload;
    }
}

async function logout() {
    try {
        let res = await firebase.auth().signOut();
        let payload =
        {
            "status": true,
        };
        return payload;

    }
    catch (err) {
        let payload =
        {
            "status": false,
            "message": err.toString()
        };
        return payload;
    }
}


function print(val) {
    console.log(val);
}

function WriteData(path, val)
{
    database.ref(path).set(val);
}

async function ReadData(path)
{
    return await database.ref(path).once('value');
}

async function GetHostelRating(city)
{
    if (city == null)
    {
        return null;
    }
    var city =city.replace(/\b[a-z]/g, (x) => x.toUpperCase());
    let snap = await database.ref("Cities").child(city).child("Hostels").orderByChild("Rating").once('value');
    var hostels = [];
    for (let key in snap.val()) {
        hostels.push(snap.val()[key]);

    }
    return hostels;
}