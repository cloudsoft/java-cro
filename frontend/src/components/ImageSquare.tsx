import React from 'react';

import './ImageSquare.scss';

type ImageSquareProps = {
  src: string,
  circle?: boolean,
}

export default function ItemEntryLink({ src, circle=false }: ImageSquareProps) {
  return (
    <div className={`image-square-box ${circle ? 'circle' : ''}`} style={{
      backgroundImage: `url("${src}")`,
      backgroundSize: "cover",
    }}> 
    </div>

  );
}
