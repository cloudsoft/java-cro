import { BaseItem, CatalogSize } from './Catalog';

export type CartItem = BaseItem & {
  size: CatalogSize;
}