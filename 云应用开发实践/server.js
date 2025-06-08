const express = require('express')
const mongoose = require('mongoose')
const Article = require('./model')
const routes = require('./routes')
const methodOverride = require('method-override')
const app = express()

mongoose.connect('mongodb://139.9.137.47:27017/yourdb', {
    auth: { username: 'zhuruoyu', password: 'password111' },
    authSource: 'admin',
    useNewUrlParser: true,
    useUnifiedTopology: true,
    useCreateIndex: true
})

app.set('view engine', 'ejs')
app.use(express.static('public'));
app.use(express.urlencoded({ extended: false }))
app.use(methodOverride('_method'))
app.use('/', routes)
app.listen(12308)