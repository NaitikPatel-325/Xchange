import connectdb from "./db/index.js";
import dotenv from "dotenv";
import { app, server } from "./app.js";

// const app = require("./src/app");

dotenv.config({
  path: "./.env",
});
connectdb()
  .then(() => {
    server.listen(3000, () => {
      console.log(
        `Server is running on port `
      );
    });
  })
  .catch((error) => {
    app.on("error", (error) => {
      console.error("Error starting server");
      console.error(error);
    });
    console.error("Error connecting to MongoDB");
    console.error(error);
  });
