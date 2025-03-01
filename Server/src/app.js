import express from "express";
import cookieparser from "cookie-parser";
import http from "http";
import dotenv from "dotenv";
import cors from "cors";
import userRoutes from "./routes/userRoutes.js";
import barterRoutes from "./routes/barterRoutes.js";

dotenv.config();
const app = express();

app.use(
  cors({
    origin: process.env.CORS_ORIGIN || "*",
    credentials: true,
  })
);

app.use(express.json({ limit: "20kb" }));
app.use(express.urlencoded({ extended: true, limit: "20kb" }));
app.use(express.static("public"));
app.use(cookieparser());

// API Routes
app.use("/api/users",userRoutes);
app.use("api/barter", barterRoutes);

// Health check route
app.get("/health", (req, res) => {
  res.status(200).json({
    status: "ok",
    message: "Server is running",
  });
});

const server = http.createServer(app);

export { server, app };
