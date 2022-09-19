export type BaseItem = {
  id: string;
  name: string;
  description: string;
  price: number;
  imageUrl1: string;
  imageUrl2: string;
}

export type CatalogItem = BaseItem & {
  count: number;
  tags: Array<CatalogTag>;
  sizes: Array<CatalogSize>;
}

export type CatalogTag = {
  id: number;
  name: string;
}

export type CatalogSize = {
  id: number;
  name: string;
  label: string;
}