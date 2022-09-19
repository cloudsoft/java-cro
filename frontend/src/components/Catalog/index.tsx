import React from 'react';
import { Routes, Route } from "react-router-dom";

import CatalogRoot from './CatalogRoot';
import ItemDetails from './ItemDetails';


export default function Header() {
  return (
    <Routes>
      <Route index element={<CatalogRoot />} />
      <Route path=":itemId" element={<ItemDetails />} />
    </Routes>
  );
}
