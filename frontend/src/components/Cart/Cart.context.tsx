import React, {
  createContext, useContext, useMemo, useState, useEffect, ReactNode,
} from 'react';

import { CatalogItem, CatalogSize } from '../../model/Catalog';
import { CartItem } from '../../model/Cart';

import short from 'short-uuid';
import {checkoutItems, getCartItems, getCatalogItem, saveCartItems} from "../../utils/Api";


type CartContextType = {
  items: Array<CartItem>,
  addItem: (item: CatalogItem, selectedSize: CatalogSize) => void,
  removeItem: (catalogItemId: string, selectedSize: CatalogSize) => void,
  checkout: () => void,
}

export const CartContext = createContext<CartContextType>({
  items: [], // maybe init here??
  addItem: () => {},
  removeItem: () => {},
  checkout: () => {},
});

type CartContextProps = {
  children: ReactNode,
}

// currently not used, might be useful in the future
const getCartItemsFromStorage = async(orderId: string):Promise<Array<CartItem>> => {
  console.log("Trying to retrieve items from local storage" , orderId);
  return Promise.resolve(JSON.parse(localStorage.getItem("cart") || '{items: []}').items as Array<CartItem>);
}

// currently not used, might be useful in the future
const setItemsToStorage = (orderId: string, items: Array<CartItem>):void => {
  console.log("Trying to retrieve items to local storage");
  localStorage.setItem("cart", JSON.stringify( {items}));
}

export const CartProvider = ({ children }: CartContextProps) => {
  const [items, setItems] = useState<Array<CartItem>>([]);

  useEffect(() => {
    const orderId = localStorage.getItem('orderId');
    if (orderId === null) {
      localStorage.setItem('orderId', short().new());
    } else {
      getCartItems(orderId)
          .then(data => {
            setItems(data);
          })
          .catch(err => {
            console.error(err);
            // todo do sth with err
          });
    }
  }, []); // run only on init

  useEffect(() => {
    const orderId = localStorage.getItem('orderId');
    if (orderId === null)  return;
    if (items.length > 0) {
      saveCartItems(orderId, items);
    }
  }, [items]); // run only on init

  const itemsValue = useMemo(() => ({
    items,
    checkout: () => {
      const orderId = localStorage.getItem('orderId');
      if (orderId === null) {
        console.log("Nothing to do, probably nothing in the cart!")
      } else {
        checkoutItems(orderId)
            .then(data => {
              localStorage.setItem('orderId', short().new());
              setItems([]);
            })
            .catch(err => {
              console.error(err);
              // todo do sth with err
            });
      }
    },
    addItem: (item: CatalogItem, selectedSize: CatalogSize) => {
      setItems([...items, {...(item as CatalogItem), size: selectedSize }]);
    },
    removeItem: (catalogItemId: string, selectedSize: CatalogSize) => {
      let found = false;
      setItems(items.filter(({ id, size }) => {
        if (id !== catalogItemId || size !== selectedSize || found) return true;
        found = true;
        return false;
      }));
    },
  }), [items]);

  return (
      <CartContext.Provider value={itemsValue}>
        {children}
      </CartContext.Provider>
  );
}

export default function useContextCart() {
  return useContext(CartContext);
}