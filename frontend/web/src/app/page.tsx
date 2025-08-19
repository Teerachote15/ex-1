// 1. Importing Dependencies
'use client'
import { useState } from 'react';
import axios from 'axios';

// 2. Creating and Exporting a Component
export default function Home() {  
  // 2.1 Defining Variables, States, and Handlers
  // สร้างตัวแปร state สำหรับเก็บข้อมูลที่จะส่งไปยัง API (age, distance, minimart)
  const [age, setAge] = useState<number | null>(null);
  const [distance, setDistance] = useState<number | null>(null);
  const [minimart, setMinimart] = useState<number | null>(null);

  // สร้างตัวแปร state สำหรับเก็บข้อมูลที่จะรับมาจาก API (price, currency)
  const [price, setPrice] = useState<number | null>(null);
  const [currency, setCurrency] = useState<string | null>(null);

  const [loading, setLoading] = useState(false);//เก็บสถานะ loading
  const [error, setError] = useState<string | null>(null);//เก็บ error 

  // สร้างฟังก์ชันสำหรับจัดการการ submit form ไปยัง API
  const calculatePrice = async () => {
    if (age === null || distance === null || minimart === null) {
      setError('กรุณากรอกข้อมูลให้ครบถ้วน');
      return;
    }

    setLoading(true);
    setError(null);
    setPrice(null);
    setCurrency(null);

    try {
      const response = await axios.post('http://127.0.0.1:8000/api/house', {        
        age: age,
        distance: distance,
        minimart: minimart,
      });
      
      const calculatedPrice = response.data.price;
      const getCurrency = response.data.currency;
      setPrice(calculatedPrice);
      setCurrency(getCurrency);
    } catch (err) {
      setError('ไม่สามารถเชื่อมต่อกับ API หรือเกิดข้อผิดพลาดในการดึงข้อมูล');
      console.error(err);
    } finally {
      setLoading(false);
    }
  };

  // 2.2 Returning UI Output  
  return (
    <div className="min-h-screen bg-gray-100 flex items-center justify-center p-4">
      <div className="bg-white p-8 rounded-xl shadow-2xl max-w-md w-full">
        <h1 className="text-3xl font-bold text-center text-gray-800 mb-6">ประเมินราคาบ้าน</h1>
        
        <div className="space-y-4">         
          <div>
            <label htmlFor="age" className="block text-gray-700 font-medium mb-2">อายุบ้าน (ปี)</label>
            <input
              id="age"
              type="number"
              value={age ?? ''}
              onChange={(e) => setAge(Number(e.target.value))}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="0 - 120"
            />
          </div>

          <div>
            <label htmlFor="distance" className="block text-gray-700 font-medium mb-2">ระยะทางถึง MRT (เมตร)</label>
            <input
              id="distance"
              type="number"
              value={distance ?? ''}
              onChange={(e) => setDistance(Number(e.target.value))}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="0 - 10000"
            />
          </div>

          <div>
            <label htmlFor="minimart" className="block text-gray-700 font-medium mb-2">จำนวนร้านสะดวกซื้อใกล้เคียง</label>
            <input
              id="minimart"
              type="number"
              value={minimart ?? ''}
              onChange={(e) => setMinimart(Number(e.target.value))}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-2 focus:ring-blue-500"
              placeholder="0 - 20"
            />
          </div>
        </div>

        <button
          onClick={calculatePrice}
          disabled={loading || age === null || distance === null || minimart === null}
          className="mt-6 w-full bg-blue-600 text-white font-bold py-3 px-4 rounded-lg hover:bg-blue-700 transition-colors duration-300 disabled:bg-blue-400 focus:outline-none focus:ring-2 focus:ring-blue-500 focus:ring-offset-2"
        >
          {loading ? 'กำลังคำนวณ...' : 'คำนวณราคา'}
        </button>

        {error && (
          <div className="mt-4 p-3 bg-red-100 text-red-700 border border-red-300 rounded-lg">
            {error}
          </div>
        )}

        {price !== null && (
          <div className="mt-6 p-6 bg-green-50 text-green-800 border-l-4 border-green-500 rounded-lg shadow-inner">
            <h2 className="text-xl font-semibold mb-2">ราคาประเมินบ้าน</h2>
            <p className="text-3xl font-bold">{price.toLocaleString()} {currency}</p>            
          </div>
        )}
      </div>
    </div>
  )
};

