import React, { HTMLAttributes } from 'react';
import { Badge } from 'react-bootstrap';


type ItemCountProps = HTMLAttributes<any> & {
  count: number,
};

export default function ItemCount({ count }: ItemCountProps) {
  return (
    <Badge bg={count ? "cloudsoft-junglegreen" : "cloudsoft-greygreen"} className={count ? "" : "text-dark"}>
      <span>{`${count ? 'Available:' : 'Unavailable'}`}</span>
      {!!count &&
        <Badge bg="cloudsoft-greygreen" className="ms-2 text-dark">{count}</Badge>
      }
    </Badge>
  );
}
