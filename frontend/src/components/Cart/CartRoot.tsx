import React from 'react';
import { Button, Container, Col, Row, Table } from 'react-bootstrap';
import { Link } from 'react-router-dom';
import Big from 'big.js';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faCircleMinus } from '@fortawesome/free-solid-svg-icons';

import './CartRoot.scss';
import useCart from './Cart.context';
import { CatalogSize } from '../../model/Catalog';
import { CartItem } from '../../model/Cart';
import { checkoutItems, imageSourceFor } from '../../utils/Api';
import short from "short-uuid";


type LineItem = {
  item: CartItem,
  quantity: number,
  price: string,
}

const toLineItems = (sum: LineItem[], item: CartItem) => {
  const existingLineItem = sum.find(lineItem=> (lineItem.item.id === item.id) && (lineItem.item.size === item.size));

  if (existingLineItem) {
    existingLineItem.quantity = existingLineItem.quantity + 1;
    existingLineItem.price = Big(existingLineItem.price).plus(item.price).toFixed(2);
  } else {
    sum.push({
      item,
      quantity: 1,
      price: Big(item.price).toFixed(2),
    });
  }

  return sum;
}

export default function CartRoot() {
  const { items, removeItem, checkout} = useCart();

  const onDelete = (id: string, size: CatalogSize) => () => {
    removeItem(id, size);
  }

  const onCheckout = () => {
   checkout();
  }

  return (
    <Container className="cart-wrapper">
      <Row className="mb-5">
        <Col>
          {items.length
            ? "Your cart contains the following items."
            : <span>Your cart contains no items. Why not <Link to="/catalog">check our catalog?</Link></span>
          }
        </Col>
      </Row>
      <Row className={!!items.length ? '' : 'd-none'}>
        <Col>
          <Table striped hover className="cart-table">
            <thead>
              <tr>
                <th>Item</th>
                <th>Size</th>
                <th>Quantity</th>
                <th>Price</th>
              </tr>
            </thead>
            <tbody>
              {
                items.reduce(toLineItems, []).map(({ item, quantity, price }) => (
                  <tr key={item.id+item.size.id}>
                    <td>
                      <img src={imageSourceFor(item.imageUrl1)} className="img-thumbnail me-3" />
                      {item.name}
                      <Button className="ms-2" variant="outline-danger" onClick={onDelete(item.id, item.size)}>
                        <FontAwesomeIcon icon={faCircleMinus} size="1x" />
                      </Button>
                    </td>
                    <td>{item.size.name}</td>
                    <td>{quantity}</td>
                    <td>{price}</td>
                  </tr>
                ))
              }
              <tr>
                <th colSpan={3} className="">Total:</th>
                <th>{items.reduce((sum, {price}) => Big(sum).plus(price).toFixed(2), '0')}</th>
              </tr>
            </tbody>
          </Table>
        </Col>
      </Row>
      <Row className={`justify-content-end ${!!items.length ? '' : 'd-none'}`}>
        <Col xs="auto">
          <Button variant="cloudsoft-junglegreen text-white"onClick={onCheckout}>Checkout</Button>
        </Col>
      </Row>
    </Container>
  );
}
