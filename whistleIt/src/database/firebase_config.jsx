import { initializeApp } from "firebase/app";
import { getAuth } from "firebase/auth";
import { getFirestore } from "firebase/firestore";
import { getStorage } from "firebase/storage";

const firebaseConfig = {
  apiKey: "AIzaSyBwqmPyp43VR-pe9e68eq1XJNJoKcQtgkM",
  authDomain: "whistleit-85045.firebaseapp.com",
  projectId: "whistleit-85045",
  storageBucket: "whistleit-85045.appspot.com",
  messagingSenderId: "590807346130",
  appId: "1:590807346130:web:06073176fa503176f7760b",
  measurementId: "G-BFQ7J472PG",
};

const app = initializeApp(firebaseConfig);
const db = getFirestore(app);
const auth = getAuth(app);
const storage = getStorage(app);

export { app, db, auth, storage };
