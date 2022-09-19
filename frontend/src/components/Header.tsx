import React from 'react';
import { Link } from "react-router-dom";
import { Container, Navbar, Nav } from 'react-bootstrap';

import './Header.scss';
import logo from '../logo.png';
import CartWidget from './Cart/CartWidget';

export default function Header() {
  return (
    <header>
      <Navbar expand="lg" className="navbar-main shadow-lg bg-cloudsoft-slateblue" fixed="top">
        <Container>
          <Navbar.Brand>
            <Link to="/"><img src={logo} alt="Cloudsoft logo" height="35px" /></Link>
          </Navbar.Brand>
          <Navbar.Toggle aria-controls="basic-navbar-nav" />
          <Navbar.Collapse id="basic-navbar-nav">
            <Nav className="me-auto">
              <Link to="/catalog" className="nav-link">Catalog</Link>
              <Link to="/cart" className="nav-link">Cart</Link>
              <Link to="/about" className="nav-link">About</Link>
            </Nav>
            <CartWidget />
          </Navbar.Collapse>
        </Container>
      </Navbar>
    </header>
  );
}
