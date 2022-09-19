import React, { useState, useEffect } from 'react';
import { Link } from "react-router-dom";

import './ItemEntryLink.scss';
import ItemBadge from './ItemBadge';
import ImageSquare from '../ImageSquare';
import { imageSourceFor } from '../../utils/Api';
import { CatalogItem } from '../../model/Catalog';


type ItemEntryLinkProps = {
  item: CatalogItem,
  circle?: boolean,
}

export default function ItemEntryLink({ item, circle=false }: ItemEntryLinkProps) {
  const [isHovered, setIsHovered] = useState<boolean>(false);
  const [imageSource, setImageSource] = useState<string>(imageSourceFor(isHovered ? item.imageUrl2 : item.imageUrl1))

  useEffect(() => {
    setImageSource(imageSourceFor(isHovered ? item.imageUrl2 : item.imageUrl1));
  }, [isHovered, item.imageUrl1, item.imageUrl2])

  return (
    <>
      <div className="link-wrapper"
        onMouseEnter={() => setIsHovered(true)}
        onMouseLeave={() => setIsHovered(false)}
      >
        <Link to={`/catalog/${item.id}`}>
          <ImageSquare src={imageSource} circle={circle}/>
        </Link>
      </div>
      <div>{item.name}</div>
      <div>{
        item.tags.map(tag =><ItemBadge key={tag.id} tag={tag} className="me-1" /> )
      }</div>
    </>
  );
}
