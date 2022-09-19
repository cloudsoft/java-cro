import React from 'react';
import { Routes, Route } from "react-router-dom";
import { Container, Col, Row } from 'react-bootstrap';

import './App.scss';
import Header from './components/Header';
import Sidebar from './components/Sidebar';
import Catalog from './components/Catalog';
import Cart from './components/Cart';
import { CartProvider } from './components/Cart/Cart.context';

function App() {
  return (
    <>
      <CartProvider>
        <Header />
        <Container fluid className="below-header">
          <Row>
            <div className="sidebar-wrapper"><Sidebar /></div>
            <Col className="main-wrapper">
              <main className="main">
                <Routes>
                  <Route index element={<Home />} />
                  <Route path="catalog/*" element={<Catalog />} />
                  <Route path="cart/*" element={<Cart />} />
                  <Route path="about" element={<About />} />
                </Routes>
              </main>
            </Col>
          </Row>
        </Container>
      </CartProvider>
    </>
  );
}

function Home() {
  return (
    <article>
      <h2>Home</h2>
      <h3>Welcome to the Cloudsoft Hoodie Shop!</h3>
    </article>
  );
}

function About() {
  return (
    <section>
      <h2>About</h2>
      <p>This is a demo application to demonstrate the capabilities of Cloudsoft AMP.</p>
    </section>
  );
}

export default App;
