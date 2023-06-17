const express = require("express");
const mongoose = require("mongoose");
const cors = require("cors")

const app = express();

app.use(express.json());
app.use(cors())

mongoose
  .connect("mongodb://localhost:27017/note", {
    useNewUrlParser: true,
    useUnifiedTopology: true,
  })
  .then(() => console.log("Mongodb Connected sucssesfully"))
  .catch((error) => console.log(`mongodb connected fail ${error}`));

const nameSchema = mongoose.Schema({
  name: String,
});

const Name = mongoose.model("Name", nameSchema);

app.post("/name", (req, res) => {
  const newName = new Name(req.body);


  newName
    .save()
    .then(() => {
      res.status(201).json({ message: "Data save succesfully" });
    })
    .catch((error) => {
      console.log(`Data not save : ${error}`);
      res.status(500).json({ error: "an error occurred" });
    });
});

app.get("/names", (req, res) => {
  Name.find()
    .then((names) => {
      res.status(200).json(names);
    })
    .catch((error) => {
      res.status(500).json({
        error: "Fail to get data in the server",
      });
    });
});

app.get("/name/:id", (req, res) => {
   const {id} =  req.params
   Name.findById(id).then((nameId) =>{
    if(nameId){
        res.status(200).json(nameId)
    } else {
        res.status(400).json({error: "Name not found by id"})
    }
   } ).catch((error) => {
    res.status(500).json({error : `Something was worng in the server ${error}`})
   })

})

app.put("/name/:id", (req, res) => {
  const { id } = req.params;
  const updateName = req.body;

  Name.findByIdAndUpdate(id, updateName, { new: true })
    .then((updateName) => {
        if(updateName){
           res.status(200).json(updateName)
        }else{
            res.status(400).json({error: "Name not found"})
        }
    })
    .catch((error) => {
        res.status(500).json({error: "Fail to update data"})
    });
});


app.delete("/name/:id", (req, res) => {
  const {id} =  req.params
    Name.findByIdAndRemove(id).then((deleteName) => {
        if(deleteName){
            res.status(200).json({message: "Successfully delete name"})
        }else{
            res.status(400).json({error: "Name not found"})
        }
    }).catch((error) => {

        res.status(500).json({error: "Name delete fail"})
    })
})


app.listen(3000, () => console.log("Server is running Port 3000"));
