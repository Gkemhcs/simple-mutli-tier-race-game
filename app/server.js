const express=require("express")
const app=express()
const mysql=require("mysql")

const bodyParser=require("body-parser")
app.use(bodyParser.json())

const connection=mysql.createConnection({host:"DATABASE_IP_ADDRESS",user:"root",password:"gkem1234",database:"race_game"})
app.get("/",(req,res)=>{
    res.send("ok")
})

 //   res.json({message:"welcome to gkemhcs",status:200})


app.post("/score/add",(req,res)=>{
    console.log(req.body.user+" scored "+req.body.score+" points")
    const currentDatetime = new Date();


const formattedDatetime = currentDatetime.toISOString().slice(0, 19).replace('T', ' ');
    connection.query("INSERT INTO race(username,points_scored,timestamp) VALUES(?,?,?) ",[req.body.user,req.body.score,formattedDatetime],(err,data)=>{
        if(err) throw err 
        else{
        console.log(data)
        res.send({status:"ok"})
        }
    })
   
})
app.get("/getLeaderboard",(req,res)=>{
    connection.query("SELECT * FROM race ORDER BY points_scored DESC LIMIT 10",(err,data)=>{
        if(err) throw err 
        else{
           res.json({list:data})
        }
    })

})
app.listen(8080,()=>{
    console.log("server started")
})