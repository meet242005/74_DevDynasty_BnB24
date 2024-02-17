import React from "react";
import { Pie } from "@ant-design/plots";

const PieChart = () => {
  // Sample data for the pie chart
  const data = [
    { type: "Assigned Cases", value: 1 },
    { type: "Completed Cases", value: 2 },
    { type: "OnGoing Cases", value: 3 },
    { type: "Pending Cases", value: 4 },
  ];

  // Configuration options for the pie chart
  const config = {
    appendPadding: 10,
    data,
    angleField: "value",
    colorField: "type",
    radius: 1,
    innerRadius: 0.6,

    label: {
      type: "inner",
      offset: "-50%",
      content: "{value}",
      style: {
        textAlign: "center",
        fontSize: 18,
        fill: "#fff",
      },
    },
    interactions: [{ type: "element-active" }],
  };

  return (
    <div style={{ width: "500px", height: "400px" }}>
      <Pie {...config} />
    </div>
  );
};

export default PieChart;
