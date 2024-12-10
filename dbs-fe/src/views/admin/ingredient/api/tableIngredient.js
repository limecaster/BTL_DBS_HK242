// Get CRUD API for Ingredient from backend at localhost:3001/ingredient/ : create. getAll, getOne:id, update:id, delete:id
import axios from 'axios';

const API_URL = 'http://localhost:3001/ingredient/';

export const createIngredient = async (data) => {
    try {
        // localhost:3001/ingredient/create

        // data format: {name: 'ingredient name', importPrice: 1000}
        if (data.importPrice <= 0) {
            alert('Giá nhập phải lớn hơn 0');
            throw new Error('Import price must be greater than zero');
        }
        console.log('Price:', data.importPrice);
        const response = await axios.post(API_URL + 'create', {
            name: data.name,
            importPrice: Number(data.importPrice)
        });

        if (response.status >= 400) {
            alert('Tạo nguyên liệu thất bại: ' + response.data.message);
            throw new Error('Create ingredient failed');
        }

        alert('Tạo nguyên liệu thành công');
        return response.data;
    } catch (error) {
        console.error('createIngredient -> error', error);
        return null;
    }
}
export const getAllIngredients = async () => {
    try {
        // localhost:3001/ingredient/getAll
        const response = await axios.get(API_URL + 'getAll');

        // Return Ingredient data if its status is 1
        return response.data.result;
    } catch (error) {
        console.error('getAllIngredients -> error', error);
        return null;
    }
}
export const getIngredient = async (id) => {
    try {
        // localhost:3001/ingredient/getOne/:id
        const response = await axios.get(API_URL + 'getOne/' + id);

        return response.data;
    } catch (error) {
        console.error('getIngredient -> error', error);
        return null;
    }
}
export const updateIngredient = async (id, data) => {
    try {
        // localhost:3001/ingredient/update/:id
        console.log(data);
        const response = await fetch(API_URL + 'update/' + id, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({
                name: data.name,
                importPrice: parseInt(data.importPrice)
            })
        })

        const responseData = await response.json();

        if (response.status >= 400) {
            alert('Cập nhật nguyên liệu thất bại: ' + responseData.message);
            throw new Error('Update ingredient failed');
        }

        alert('Cập nhật nguyên liệu thành công');
        return await response.json();
    } catch (error) {
        console.error('updateIngredient -> error', error);
        return null;
    }
}
export const deleteIngredient = async (id) => {
    try {
        // localhost:3001/ingredient/delete/:id
        const response = await axios.delete(API_URL + 'delete/' + id);

        if (response.status !== 200) {
            alert('Xóa nguyên liệu thất bại: ' + response.data.message);
            throw new Error('Delete ingredient failed');
        }

        alert('Xóa nguyên liệu thành công');

        return response.data;
    } catch (error) {
        console.error('deleteIngredient -> error', error);
        return null;
    }
}
