const express = require('express');
const userRoute = require('./route/userRoute');
const produkRoute = require('./route/produkRoute');
const reviewRoute = require('./route/reviewRoute');
const perbandinganRoute = require('./route/perbandinganRoute');
const wishlistRoute = require('./route/wishlistRoute');
const functionRoute = require('./route/functionRoute');
const viewRoute = require('./route/viewRoute');

const app = express();

app.use(express.json()); // Parsing JSON
app.use('/user', userRoute);
app.use('/produk', produkRoute);
app.use('/review', reviewRoute);
app.use('/perbandingan', perbandinganRoute);
app.use('/wishlist', wishlistRoute);
app.use('/function', functionRoute);
app.use('/view', viewRoute)

app.listen(3000, () => {
    console.log('Server is running on port 3000');
});