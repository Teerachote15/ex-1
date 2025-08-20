"use client";
import { useState } from "react";
import axios from "axios";
import { motion } from "framer-motion";
export default function Home() {
  const [oilDate, setOilDate] = useState<string>("");
  const [price, setPrice] = useState<number | null>(null);
  const [currency, setCurrency] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const calculatePrice = async () => {
    if (!oilDate) {
      setError("กรุณาเลือกวันเดือนปี");
      return;
    }
    setLoading(true);
    setError(null);
    setPrice(null);
    setCurrency(null);

    try {
      const response = await axios.post("http://127.0.0.1:8000/api/oil", {
        oil_date: oilDate,
      });
      setPrice(response.data.price);
      setCurrency(response.data.currency);
    } catch (err: any) {
      if (err.response?.data?.detail) {
        setError("ข้อมูลไม่ถูกต้อง: " + JSON.stringify(err.response.data.detail));
      } else {
        setError("ไม่สามารถเชื่อมต่อกับ API หรือเกิดข้อผิดพลาด");
      }
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="min-h-screen flex items-center justify-center bg-gradient-to-br from-blue-100 via-white to-blue-50 p-4">
      <motion.div
        initial={{ opacity: 0, y: 30 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6, ease: "easeOut" }}
        className="bg-white/80 backdrop-blur-md p-8 rounded-2xl shadow-xl max-w-md w-full"
      >
        <h1 className="text-3xl font-bold text-center text-gray-800 mb-6">
          ประเมินราคาน้ำมันดิบ
        </h1>

        <div className="space-y-4">
          <div>
            <label
              htmlFor="oilDate"
              className="block text-gray-700 font-medium mb-2"
            >
              วันเดือนปี (YYYY-MM-DD)
            </label>
            <input
              id="oilDate"
              type="date"
              value={oilDate}
              onChange={(e) => setOilDate(e.target.value)}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-400 transition-all"
            />
          </div>
        </div>

        <button
          onClick={calculatePrice}
          disabled={loading || !oilDate}
          className="mt-6 w-full bg-gradient-to-r from-blue-500 to-blue-700 text-white font-bold py-3 px-4 rounded-lg shadow-md hover:from-blue-600 hover:to-blue-800 transition-all duration-300 disabled:opacity-50 disabled:cursor-not-allowed focus:outline-none focus:ring-2 focus:ring-blue-400 focus:ring-offset-2"
        >
          {loading ? "กำลังคำนวณ..." : "คำนวณราคา"}
        </button>

        {error && (
          <motion.div
            initial={{ opacity: 0, x: -20 }}
            animate={{ opacity: 1, x: 0 }}
            className="mt-4 p-3 bg-red-100 text-red-700 border border-red-300 rounded-lg"
          >
            {error}
          </motion.div>
        )}

        {price !== null && (
          <motion.div
            initial={{ opacity: 0, scale: 0.9 }}
            animate={{ opacity: 1, scale: 1 }}
            transition={{ duration: 0.4 }}
            className="mt-6 p-6 bg-green-50 text-green-800 border-l-4 border-green-500 rounded-xl shadow-inner"
          >
            <h2 className="text-xl font-semibold mb-2">
              ราคาประเมินน้ำมันดิบ
            </h2>
            <p className="text-3xl font-bold">
              {price.toLocaleString()} {currency}
            </p>
          </motion.div>
        )}
      </motion.div>
    </div>
  );
}
