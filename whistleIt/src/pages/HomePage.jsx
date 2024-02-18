import React, { useEffect, useState } from "react";
import { auth, db } from "../database/firebase_config";
import { useNavigate } from "react-router-dom";
import login from "/Login/login.png";
import logout from "/Login/logout.png";
import Navbar from "../components/Navbar";
import PieChart from "../components/pieChart";
import { Card, Space, Statistic } from "antd";
import {
  CheckCircleOutlined,
  DollarCircleOutlined,
  FormOutlined,
  HourglassOutlined,
  ShoppingCartOutlined,
  ShoppingOutlined,
  UserOutlined,
} from "@ant-design/icons";
import HoverCard from "@darenft/react-3d-hover-card";
import AOS from "aos";
import "aos/dist/aos.css";
import "@darenft/react-3d-hover-card/dist/style.css";
import { collection, getDocs } from "firebase/firestore";

const HomePage = () => {
  const [user, setUser] = useState(null);
  const [assigned, setassigned] = useState(0);
  const [pending, setpending] = useState(0);
  const [completed, setcompleted] = useState(0);
  const [onGoing, setonGoing] = useState(0);
  const [revenue, setRevenue] = useState(0);

  useEffect(() => {
    AOS.init({
      // Initialize AOS
      duration: 1000, // Animation duration
      once: true, // Whether animation should only happen once
    });
  }, []);
  useEffect(() => {
    const fetchData = async () => {
      try {
        const casesCollection = collection(db, "cases");
        const casesSnapshot = await getDocs(casesCollection);
        let assignedCount = 0;
        let pendingCount = 0;
        let completedCount = 0;
        let onGoingCount = 0;

        casesSnapshot.forEach((doc) => {
          const status = doc.data().current_status;
          if (status === "assigned") {
            assignedCount++;
          } else if (status === "pending") {
            pendingCount++;
          } else if (status === "completed") {
            completedCount++;
          } else if (status === "onGoing") {
            onGoingCount++;
          }
        });

        setassigned(assignedCount);
        setpending(pendingCount);
        setcompleted(completedCount);
        setonGoing(onGoingCount);
      } catch (error) {
        console.error("Error fetching data:", error);
      }
    };

    fetchData();
  }, []);

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
  function DashboardCard({ title, value, icon }) {
    return (
      <HoverCard scaleFactor={1.1}>
        <Card data-aos="fade-left" className=" shadow-md text-[#000] px-3">
          <Space direction="horizontal">
            {icon}
            <Statistic title={title} value={value} />
          </Space>
        </Card>
      </HoverCard>
    );
  }

  return (
    <>
      <section className=" flex w-[100%] gap-x-10">
        <Navbar />
        <div className=" w-[100%] flex flex-col justify-center items-center gap-y-10 ">
          <p className=" w-[100%] text-4xl flex mb-[3rem]">DashBoard</p>
          <div className=" flex w-[100%] flex-col justify-center items-center bg-slate-200 p-5 mr-9 rounded-xl">
            <Space direction="horizontal" className=" gap-x-12">
              <DashboardCard
                icon={
                  <HourglassOutlined
                    style={{
                      color: "blue",
                      backgroundColor: "rgba(0,0,255,0.25)",
                      borderRadius: 20,
                      fontSize: 24,
                      padding: 8,
                    }}
                  />
                }
                title={"Pending"}
                value={pending}
              />
              <DashboardCard
                icon={
                  <FormOutlined
                    style={{
                      color: "white",
                      backgroundColor: "rgba(0, 128, 202)",
                      borderRadius: 20,
                      fontSize: 24,
                      padding: 8,
                    }}
                  />
                }
                title={"Assigned"}
                value={assigned}
              />
              <DashboardCard
                icon={
                  <CheckCircleOutlined
                    style={{
                      color: "red",
                      backgroundColor: "rgba(255,0,0,0.25)",
                      borderRadius: 20,
                      fontSize: 24,
                      padding: 8,
                    }}
                  />
                }
                title={"OnGoing"}
                value={onGoing}
              />
              <DashboardCard
                icon={
                  <UserOutlined
                    style={{
                      color: "purple",
                      backgroundColor: "rgba(0,255,255,0.25)",
                      borderRadius: 20,
                      fontSize: 24,
                      padding: 8,
                    }}
                  />
                }
                title={"Completed"}
                value={completed}
              />
            </Space>

            <PieChart
              assigned={assigned}
              pending={pending}
              completed={completed}
              onGoing={onGoing}
            />
          </div>
        </div>
      </section>
    </>
  );
};

export default HomePage;
