import { CatalogItem } from '../model/Catalog';
import {CartItem} from "../model/Cart";

const API = {
	HOST: process.env.REACT_APP_BACKEND_URL || 'http://localhost:3000',
	PATH_CATALOGUE: 'catalogue',
}

export const getCatalogItems = async (): Promise<Array<CatalogItem>> => {
	let result: Array<CatalogItem> = [];
	try {
		const response = await fetch(`${API.HOST}/${API.PATH_CATALOGUE}/hoodie`);
		const data = await response.json();
		if (response.ok) {
			result = data;
		}
	} catch(e) {
		console.error('getCatalogItems() fail:', e);
	}

	return result;
}

export const getCartItems = async (orderId: string):Promise<Array<CartItem>> => {
	let result: Array<CartItem> = [];
	try {
		const response = await fetch(`${API.HOST}/${API.PATH_CATALOGUE}/cart/${orderId}`);
		const data = await response.json();
		if (response.ok) {
			result = data;
		}
	} catch(e) {
		console.error('getCartItems() fail:', e);
	}
	return result;
}

export const saveCartItems = async(orderId: string, items: Array<CartItem>): Promise<void> => {
	try {
		const response = await fetch(`${API.HOST}/${API.PATH_CATALOGUE}/cart/${orderId}`,
			{
				method: 'POST',
				body: JSON.stringify(items),
				headers: {'Content-Type': 'application/json'}
			}
		);
		if (response.status != 201) {
			throw new Error("Server could not save items!");
		}
	} catch(e) {
		console.error('saveCartItems() fail:', e);
	}
}

export const getCatalogItem = async (id: string): Promise<CatalogItem> => {
	let result;
	try {
		const response = await fetch(`${API.HOST}/${API.PATH_CATALOGUE}/${id}`);
		const data = await response.json();
		if (response.ok) {
			result = data;
		}
	} catch(e) {
		console.error('getCatalogItem() fail:', e);
	}

	return result;
}

export const checkoutItems = async(orderId: string): Promise<void> => {
	try {
		const response = await fetch(`${API.HOST}/${API.PATH_CATALOGUE}/checkout/${orderId}`,
			{
				method: 'POST',
				headers: {'Content-Type': 'application/json'}
			}
		);
		if (response.status != 201) {
			throw new Error("Server could not save items!");
		}
	} catch(e) {
		console.error('checkoutItems() fail:', e);
	}
}

export const imageSourceFor = (resourcePath: string): string =>
	`${API.HOST}/${API.PATH_CATALOGUE}${resourcePath}`;