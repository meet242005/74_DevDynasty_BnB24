import React from "react";
import { BrowserRouter as Router, Route, Routes } from "react-router-dom";
import HomePage from "./pages/HomePage";
import SignUp from "./components/SignUp";
import Login from "./components/Login";

const MainRouter = () => {
  return (
    <>
      <Router>
        {/* <NewNavbar /> */}
        <Routes>
          <Route path="/" element={<Login />} />
          <Route path="/signup" element={<SignUp />} />
          <Route path="/homepage" element={<HomePage />} />
        </Routes>
      </Router>
    </>
  );
};

export default MainRouter;
