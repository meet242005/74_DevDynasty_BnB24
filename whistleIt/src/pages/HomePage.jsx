import React, { useEffect, useState } from "react";
import { auth } from "../database/firebase_config";
import { useNavigate } from "react-router-dom";
import login from "/Login/login.png";
import logout from "/Login/logout.png";
import Navbar from "../components/Navbar";

const HomePage = () => {
  const [user, setUser] = useState(null);
  useEffect(() => {
    const unsubscribe = auth.onAuthStateChanged((user) => {
      if (user) {
        setUser(user);
      } else {
        setUser(null);
      }
    });

    return () => unsubscribe();
  }, []);
  const navigate = useNavigate();
  function GetUserID() {
    const [userID, setUID] = useState(null);
    useEffect(() => {
      auth.onAuthStateChanged((user) => {
        if (user) {
          setUID(user.uid);
        }
      });
    }, []);
    return userID;
  }
  const uid = GetUserID();

  if (!user) {
    return null;
  }

  return (
    <>
      <div className=" flex ">
        <Navbar />
        Homepage
      </div>
    </>
  );
};

export default HomePage;
