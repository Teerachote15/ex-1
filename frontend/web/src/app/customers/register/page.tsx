"use client";
import { useState, FormEvent } from "react";
import axios from "axios";

export default function Register() {
  const [username, setUsername] = useState<string>("");
  const [password, setPassword] = useState<string>("");
  const [firstName, setFirstName] = useState<string>("");
  const [lastName, setLastName] = useState<string>("");

  const handleSubmit = async (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    try {
      const response = await axios.post("http://localhost:4000/api/register", {
        username,
        password,
        firstName,
        lastName,
      });
      const result = response.data;
      alert(result.message);
      if (result.status === true) {
        window.location.href = "/";
      }
    } catch (err) {
      console.error("Registration error:", err);
      alert("Registration failed.");
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-r from-indigo-600 via-purple-500 to-pink-500 p-6">
      <form
        onSubmit={handleSubmit}
        className="bg-white shadow-2xl rounded-lg p-8 w-full max-w-lg space-y-6 border-2 border-gray-300"
      >
        <h1 className="text-3xl font-bold text-center text-gray-800 mb-4">
          ระบบซื้อขายออนไลน์
        </h1>

        <div className="space-y-4">
          <input
            type="text"
            placeholder="Username"
            value={username}
            onChange={(e) => setUsername(e.target.value)}
            className="w-full px-5 py-3 border rounded-md text-gray-800 focus:outline-none focus:ring-2 focus:ring-indigo-600 transition duration-300"
          />

          <input
            type="password"
            placeholder="Password"
            value={password}
            onChange={(e) => setPassword(e.target.value)}
            className="w-full px-5 py-3 border rounded-md text-gray-800 focus:outline-none focus:ring-2 focus:ring-indigo-600 transition duration-300"
          />

          <input
            type="text"
            placeholder="First Name"
            value={firstName}
            onChange={(e) => setFirstName(e.target.value)}
            className="w-full px-5 py-3 border rounded-md text-gray-800 focus:outline-none focus:ring-2 focus:ring-indigo-600 transition duration-300"
          />

          <input
            type="text"
            placeholder="Last Name"
            value={lastName}
            onChange={(e) => setLastName(e.target.value)}
            className="w-full px-5 py-3 border rounded-md text-gray-800 focus:outline-none focus:ring-2 focus:ring-indigo-600 transition duration-300"
          />
        </div>

        <button
          type="submit"
          className="w-full bg-indigo-600 hover:bg-indigo-700 text-white py-3 px-4 rounded-md transition duration-300 transform hover:scale-105"
        >
          สมัครสมาชิก
        </button>
      </form>
    </div>
  );
}
