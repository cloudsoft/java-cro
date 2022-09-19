import React from 'react';
import { Routes, Route } from "react-router-dom";

import CartRoot from './CartRoot';


export default function Header() {
  return (
    <Routes>
      <Route index element={<CartRoot />} />
    </Routes>
  );
}
