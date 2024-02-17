import React, { useState, useEffect } from "react";
import Navbar from "../components/Navbar"; // Assuming Navbar component is exported from './Navbar'
import { collection, getDocs } from "firebase/firestore";
import { db } from "../database/firebase_config";
import calendar from "/Cases/calendar.png";
import people from "/Cases/people.png";
import category from "/Cases/search.png";
import placeholder from "/Cases/placeholder.png";

const Completed = () => {
  const [cases, setCases] = useState([]);

  useEffect(() => {
    const fetchCases = async () => {
      const casesCollection = collection(db, "cases");
      const casesSnapshot = await getDocs(casesCollection);
      const casesData = casesSnapshot.docs.map((doc) => ({
        id: doc.id,
        ...doc.data(),
      }));
      setCases(
        casesData.filter((caseItem) => caseItem.case_status === "completed")
      );
    };

    fetchCases();
  }, []);
  console.log(cases);

  return (
    <>
      <section className="flex w-[100%] gap-x-10 ">
        <Navbar />
        <div className="w-[100%] mt-12 flex flex-col">
          <p className="w-[100%] text-4xl flex mb-[3rem]">Completed Cases</p>
          <div className=" overflow-y-scroll h-[40rem]">
            {cases.map((caseItem) => (
              <div
                key={caseItem.caseId}
                className="bg-white rounded-lg shadow-2xl ml-2 p-4 mb-4 mr-9 border-2 border-gray-200"
              >
                <div className="mb-1">
                  <p className=" mr-2 text-sm text-gray-400">
                    Case ID: #
                    <span className=" text-sm  text-gray-400">
                      {caseItem.caseId}
                    </span>
                  </p>
                </div>
                <div className="mb-2 pb-2 border-b-[1px] border-gray-300">
                  <p className=" mr-2  text-xl font-bold text-dark-purple">
                    Case Title:
                    <span className="text-xl font-bold text-dark-purple">
                      {" "}
                      {caseItem.case_title}
                    </span>
                  </p>
                </div>
                <div>
                  <div className="flex mt-2">
                    <p className="mr-2 text-gray-500">Description:</p>
                    <span className="text-gray-700">{caseItem.case_desc}</span>
                  </div>
                  <div className="grid grid-cols-2 gap-4 mt-4 text-gray-500">
                    <div className="flex mt-2 items-center gap-x-1">
                      <img src={placeholder} className=" w-7 " alt="" />
                      <p className="mr-2 text-gray-500">Location:</p>
                      <span className="text-gray-700">
                        {caseItem.case_location}
                      </span>
                    </div>
                    <div className="flex mt-2 items-center gap-x-1">
                      <img src={category} className=" w-7 " alt="" />
                      <p className="mr-2 text-gray-500">Category:</p>
                      <span className="text-gray-700">
                        {caseItem.case_category}
                      </span>
                    </div>
                    <div className="flex mt-2 items-center gap-x-1">
                      <img src={calendar} className=" w-7 " alt="" />
                      <p className="mr-2 text-gray-500">Reported On:</p>
                      <span className="text-gray-700">
                        <span className="text-gray-700">
                          {caseItem.case_reported &&
                          caseItem.case_reported.toDate &&
                          typeof caseItem.case_reported.toDate === "function"
                            ? new Date(
                                caseItem.case_reported.toDate()
                              ).toLocaleString("en-GB")
                            : "No reported date"}
                        </span>
                      </span>
                    </div>
                    <div className="flex mt-2 items-center gap-x-1">
                      <img src={people} className=" w-7 " alt="" />
                      <p className="mr-2 text-gray-500">Party Involved:</p>
                      <span className="text-gray-700">
                        {caseItem.case_partyInvolved}
                      </span>
                    </div>
                  </div>
                </div>
              </div>
            ))}
          </div>
        </div>
      </section>
    </>
  );
};

export default Completed;
