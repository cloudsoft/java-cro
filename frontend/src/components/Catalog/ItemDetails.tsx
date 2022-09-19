import React, { useState, useEffect } from 'react';
import { useParams } from "react-router-dom";
import { Container, DropdownButton, Dropdown, Row, Col, Button, Card, ListGroup, ListGroupItem } from 'react-bootstrap';

import useCart from '../Cart//Cart.context';
import ItemCount from './ItemCount';
import ItemBadge from './ItemBadge';
import ImageSquare from '../ImageSquare';
import { imageSourceFor, getCatalogItem } from '../../utils/Api';
import { CatalogItem, CatalogSize } from '../../model/Catalog';


const rand = (MIN_NUMBER:number, MAX_NUMBER: number) =>
  Math.floor(Math.random() * (MAX_NUMBER - MIN_NUMBER + 1)) + MIN_NUMBER;

const SOURCES = [
  "Our virtual customer satisfaction team.",
  "Our official jokes department.",
  "Our engineer with little sense of humour.",
  "Our dummy-data-creating intern.",
]

export default function ItemEntry() {
  const { addItem:addCartItem } = useCart();
  const { itemId } = useParams();
  const [item, setItem] = useState<CatalogItem | null>(null);
  const [selectedSize, setSelectedSize] = useState<CatalogSize | null>(null);
  const [imageFront, setImageFront] = useState<boolean>(true);
  const [descriptionFooter] = useState<string>(SOURCES[rand(0, SOURCES.length-1)]);

  useEffect(() => {
    if (typeof itemId === 'string') {
      getCatalogItem(itemId).then(itemData => {
        setItem(itemData);
        setSelectedSize(itemData.sizes[0]);
      })
    }
  }, [itemId]);


  const onAddToCart = () => {
    if (item === null || selectedSize === null) return;
    addCartItem(item, selectedSize);
  }

  const onChangeSize = (id: number) => () => {
    if (item === null) return;

    const selection = item.sizes.find(size=>size.id === id);
    if (selection) setSelectedSize(selection);
  }

  const togglePhoto = () => {
    setImageFront(!imageFront);
  }

  if ((item === null) || (selectedSize === null)) return null;

  return (
    <Container>
      <Row>
        <Col xs="4">
          <Card>
            <button onClick={togglePhoto} className="border-0">
              <ImageSquare src={imageSourceFor(imageFront ? item.imageUrl1 : item.imageUrl2)} />
            </button>
            <ListGroup className="list-group-flush">
              <ListGroupItem>
                <Row className="justify-content-between">
                  <Col xs="auto">
                    <DropdownButton id="dropdown-basic-button" variant="cloudsoft-greygreen" title={selectedSize.label}>
                      {
                        item.sizes.map(({ id, name, label }) => (
                          <Dropdown.Item key={id} onClick={onChangeSize(id)}>{label}</Dropdown.Item>
                        ))
                      }
                    </DropdownButton>
                  </Col>
                  <Col xs="auto">
                    <Button disabled={item.count <= 0} onClick={onAddToCart}>Add to Cart</Button>
                  </Col>
                </Row>
              </ListGroupItem>
              <ListGroupItem>
                <Row className="justify-content-between">
                  <Col xs="auto">
                    <ItemCount count={item.count} />
                  </Col>
                  <Col xs="auto">
                    {`$${item.price}`}
                  </Col>
                </Row>
              </ListGroupItem>
            </ListGroup>
            {!!item.tags.length &&
              <Card.Body>
                {item.tags.map((tag)=> (<ItemBadge key={tag.id} tag={tag} className="me-1" />))}
              </Card.Body>
            }
          </Card>
        </Col>

        <Col>
          <h1>{item.name}</h1>
          <p>Below you will see a longer description.</p>
          <p>Nulla quis incididunt esse dolor excepteur ad non reprehenderit nostrud irure in labore irure occaecat ex elit ea cillum exercitation deserunt aliqua non tempor consequat proident labore magna ex excepteur officia labore officia consequat exercitation et labore amet minim nostrud ad amet aliqua ut in in laborum fugiat sed incididunt ut ut dolor consequat id proident eu aliqua dolor veniam dolor esse laborum consectetur et sed aliquip nisi et sed nulla consequat ea commodo in duis dolore ut qui officia adipisicing ad laborum dolor in et laboris velit pariatur dolore amet nisi elit ea tempor ad anim dolor aliqua id ut ea tempor qui ad exercitation sit elit excepteur ut adipisicing dolore amet aliquip in in labore ullamco dolore eiusmod sunt nulla pariatur consectetur laborum adipisicing irure dolor mollit in nisi sed non fugiat ex veniam officia ut dolor cupidatat qui id anim veniam velit culpa eu aliquip incididunt.</p>
          <blockquote className="blockquote">
            <h3 className="">{item.description}</h3>
            <footer className="blockquote-footer">{descriptionFooter}</footer>
          </blockquote>
        </Col>      </Row>
    </Container>
  );
}
