import mongoose from "mongoose";
import dotenv from "dotenv";

dotenv.config(); // Load environment variables

const connectDB = async () => {
  try {
    

    if (!process.env.MONGO_URI) {
      throw new Error("❌ MONGO_URI is not defined in .env file");
    }

    await mongoose.connect(
      process.env.MONGO_URI,
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
