import mongoose from "mongoose";
import dotenv from "dotenv";

dotenv.config(); // Load environment variables

const connectDB = async () => {
  try {
    console.log(
      "🔍 MONGO_URI:" +
        "mongodb+srv://kriscollege:Kris%40123@cluster0.3crjfvn.mongodb.net/ParkEZ"
    ); // Debugging line

    // if (!process.env.MONGO_URI) {
    //   throw new Error("❌ MONGO_URI is not defined in .env file");
    // }

    await mongoose.connect(
      "mongodb+srv://kriscollege:Kris%40123@cluster0.3crjfvn.mongodb.net/ParkEZ",
      {
        dbName: "XChange",
      }
    );

    console.log("✅ MongoDB Connection Established");
  } catch (error) {
    console.error("❌ Error connecting to database:", error.message);
    process.exit(1); // Stop the server if DB connection fails
  }
};

export default connectDB;
