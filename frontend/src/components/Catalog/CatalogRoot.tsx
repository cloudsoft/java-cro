import React, { useState, useEffect } from 'react';
import { Container, Col, Row } from 'react-bootstrap';

import './CatalogRoot.scss';
import ItemEntryLink from './ItemEntryLink';
import { CatalogItem } from '../../model/Catalog';
import { getCatalogItems } from '../../utils/Api';


export default function CatalogRoot() {
  const [items, setItems] = useState<Array<CatalogItem>>([]);

  useEffect(() => {
    getCatalogItems().then(catalogItems => {
      setItems(catalogItems || []);
    })
  }, [])

  return (
    <Container>
      <Row className="mb-5">
        <Col>Below you can see the entire stock.</Col>
      </Row>
      <Row>
        {
          items.map(item => (
            <Col key={item.id} md={3} className="mb-3">
              <ItemEntryLink item={item} circle />
            </Col>
          ))
        }
      </Row>
    </Container>
  );
}
