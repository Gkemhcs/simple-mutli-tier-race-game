const express=require("express")
const app=express()
const axios=require("axios")
const session=require("express-session")

const bodyParser=require("body-parser")
app.use(bodyParser.urlencoded({extended:true}))
app.use(bodyParser.json());
app.set("view engine","ejs")
app.use(express.static("public"))
app.use(
    session({
      secret: 'your-secret-key',
      resave: false,
      saveUninitialized: true,
    })
  );
  const isAuthenticated = (req, res, next) => {
    if (req.session && req.session.loggedIn) {
      next(); // User is authenticated, proceed to the next middleware/route
    } else {
      res.redirect('/login'); // Redirect to the login page if not authenticated
    }
  };
app.get("/login",(req,res)=>{
    res.render("login")

}) 
app.post("/login",(req,res)=>{
  req.session.loggedIn=true
  req.session.username=req.body.username
  console.log(req.body+"logged in to the game")
  res.redirect("/play")
})
app.get("/leaderboard",async(req,res)=>{
 const response=await axios.get("http://BACKEND_IP_ADDRESS:80/getLeaderboard")
  console.log(response.data)
 
 res.render("leaderboard",{data:response.data.list})
})

app.get("/",(req,res)=>{
    res.render("home")
})
app.get("/play",isAuthenticated,(req,res)=>{
  res.render("race")
})

app.post("/score/add",async(req,res)=>{
   console.log(req.body)
    await axios({method:"POST",headers:{'Content-Type':"application/json"},url:"http://BACKEND_IP_ADDRESS:80/score/add",data:{score:req.body.score,user:req.session.username}})
 res.json({status:"ok",username:req.session.username})
})





app.listen(8080,()=>{
console.log("server started")
})
/*
 
*/ 