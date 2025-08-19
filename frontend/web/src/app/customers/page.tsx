// 1. Importing Dependencies
//    - Import libraries, components, styles, etc.
"use client"; // ต้องใช้เพราะใช้ useState และ window, localStorage
import React from 'react';

// 2. Creating and Exporting a Component
//    - Define the component function/class and export it
export default function Home() {

  // 2.1 Defining Variables, States, and Handlers
  //     - ตั้งค่า useState, useEffect, event handlers ฯลฯ
  const [name, setName] = React.useState('');
  const handleInputChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setName(e.target.value);
  };

  // 2.2 Returning UI Output
  //     - ทำการ return JSX เพื่อแสดงผล UI  
  return (
    <div className="flex flex-col items-center 
                    justify-center min-h-screen bg-gray-100">
      <h1 className="text-3xl font-bold mb-4">Hello, {name || "World"}!</h1>
      <input
        type="text"
        placeholder="Enter your name"
        className="border p-2 rounded"
        value={name}
        onChange={handleInputChange}
      />
    </div>
  );
}