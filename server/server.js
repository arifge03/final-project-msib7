const app = require('./src/app');
const sequelize = require('./src/config/database');

const PORT = process.env.PORT || 3000;

sequelize.authenticate().then(() => {
    console.log('Connection to database established successfully.');
    app.listen(PORT, '192.168.212.17', () => {
        console.log(`Server is running on http://192.168.212.17:${PORT}`);
    });
}).catch(err => {
    console.error('Unable to connect to the database:', err);
});
