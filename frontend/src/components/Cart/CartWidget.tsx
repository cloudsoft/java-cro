import React, { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { Button } from 'react-bootstrap';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faBasketShopping } from '@fortawesome/free-solid-svg-icons';

import useCart from './Cart.context';

export default function CartWidget() {
  const { items } = useCart();
  const navigate = useNavigate();
  const [showPopup, setShowPopup] = useState<boolean>(false);

  const onBtnClick = () => {
    // setShowPopup(true); // TODO: show popup with mini cart items list on click
    navigate("/cart")
  }

  return (
    <Button variant="cloudsoft-mint" className="position-relative" onClick={onBtnClick}>
      <FontAwesomeIcon icon={faBasketShopping} size="1x" />
      {!!items.length &&
        <span className="position-absolute top-0 start-0 translate-middle badge rounded-pill bg-cloudsoft-goldmustard text-dark">
          {items.length}
          <span className="visually-hidden">items in the cart</span>
        </span>
      }
    </Button>
  );
}
