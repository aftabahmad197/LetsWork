const app = require('./app');
const db = require('./config/db');
const userModel = require('./model/user.model');
const categoryModel = require('./model/category.model');
categoryModel.initializeData();
const port = 3000;

app.get('/', (req, res) => {
    res.send('Hello World!');
    });

app.listen(port, () => {
  console.log(`App running on port http://localhost:${port}`);
});
