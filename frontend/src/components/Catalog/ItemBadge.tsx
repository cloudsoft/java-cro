import React, { HTMLAttributes } from 'react';
import { Badge } from 'react-bootstrap';

import { CatalogTag } from '../../model/Catalog';


type ItemBadgeProps = HTMLAttributes<any> & {
  tag: CatalogTag,
};

export default function ItemCard({ tag, className }: ItemBadgeProps) {
  return (
    <Badge pill bg="cloudsoft-goldmustard" className={`text-dark ${className || ''}`} style={{
      cursor: 'pointer',
    }}>{tag.name}</Badge>
  );
}
