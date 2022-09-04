
const express = require('express');
const mongoose = require("mongoose");
const app = express();
const bodyParser = require("body-parser");
const path = require('path');
app.use(express.json());

app.use(bodyParser.urlencoded({ extended: false }));

app.listen(4000,(err)=>
{
    console.log("running");
});


mongoose.connect("mongodb+srv://sakhi:sakhi2022@cluster0.hxv9z.mongodb.net/?retryWrites=true&w=majority")


const registeredShop = mongoose.Schema(
    {
        _name:{
            type:String,
            required:[true,"Why not name?"]
        },
        _latitude:{
            type:String,
            required:[true,"Why not phone?"]
        },
        _longitude:{
            type:String,
            required:[true,"Why not email?"]
        }
    }
);

const shops = new mongoose.model("Shop",registeredShop);




app.post("/regshop",(req,res)=>
{
    var lon = req.body.lon;
    var lat = req.body.lat;
    var nameOfShop = req.body.nameOfShop; 

    console.log(nameOfShop);
    // const newShop = new shops({
    //     _name:nameOfShop,
    //     _latitude:lat,
    //     _longitude:lon

    // });

    // newShop.save((err,result)=>
    // {
    //     if(err)
    //     console.log(err);
    //     else
    //     res.send(result);
    // })
    //STORE IN THE DATABASE




})

app.get("/getLatLongShops",function(req,res) //getting  list of stores
{
    var latLong = [{
            "lat" : "18.516726",
            "long" : "73.856255"
        },
        {
            "lat" : "18.52867666",
            "long" : "73.84348869"
        },
        {
            "lat" : "18.52248743",
            "long" : "73.84932518"
        },
        {
            "lat" : "18.51124852",
            "long" : "73.87018204"
        },
        {
            "lat" : "18.54300875",
            "long" : "73.87181282"
        }

    ]

    res.send (latLong);

})

app.get("/getLatLongToilets",function(req,res) //getting  list of stores
{
    var latLong = [{
            "lat" : "18.51760418",
            "long" : "73.83876801"
        },
        {
            "lat" : "18.50457312",
            "long" : "73.84048462"
        }
    ]

    res.send (latLong);

})
