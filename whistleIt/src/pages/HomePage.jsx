import React, { useEffect, useState } from "react";
import { auth } from "../database/firebase_config";
import { useNavigate } from "react-router-dom";
import login from "/Login/login.png";
import logout from "/Login/logout.png";
import Navbar from "../components/Navbar";
import PieChart from "../components/pieChart";
import { Card, Space, Statistic } from "antd";
import {
  DollarCircleOutlined,
  ShoppingCartOutlined,
  ShoppingOutlined,
  UserOutlined,
} from "@ant-design/icons";
import HoverCard from "@darenft/react-3d-hover-card";

import "@darenft/react-3d-hover-card/dist/style.css";

const HomePage = () => {
  const [user, setUser] = useState(null);
  const [orders, setOrders] = useState(0);
  const [inventory, setInventory] = useState(0);
  const [customers, setCustomers] = useState(0);
  const [revenue, setRevenue] = useState(0);
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
        <Card className=" shadow-md text-[#000] px-3">
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
                  <ShoppingCartOutlined
                    style={{
                      color: "green",
                      backgroundColor: "rgba(0,255,0,0.25)",
                      borderRadius: 20,
                      fontSize: 24,
                      padding: 8,
                    }}
                  />
                }
                title={"Orders"}
                value={orders}
              />
              <DashboardCard
                icon={
                  <ShoppingOutlined
                    style={{
                      color: "blue",
                      backgroundColor: "rgba(0,0,255,0.25)",
                      borderRadius: 20,
                      fontSize: 24,
                      padding: 8,
                    }}
                  />
                }
                title={"Inventory"}
                value={inventory}
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
                title={"Customer"}
                value={customers}
              />
              <DashboardCard
                icon={
                  <DollarCircleOutlined
                    style={{
                      color: "red",
                      backgroundColor: "rgba(255,0,0,0.25)",
                      borderRadius: 20,
                      fontSize: 24,
                      padding: 8,
                    }}
                  />
                }
                title={"Revenue"}
                value={revenue}
              />
            </Space>

            <PieChart />
          </div>
        </div>
      </section>
    </>
  );
};

export default HomePage;
