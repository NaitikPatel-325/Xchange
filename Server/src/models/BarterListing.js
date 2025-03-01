import mongoose from "mongoose";

const BarterListingSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  title: { type: String, required: true },
  category: { type: String, required: true }, // e.g., Electronics, Furniture
  description: { type: String },
  offer: { type: String, required: true }, // What they are offering
  request: { type: String, required: true }, // What they want in return
  location: { type: String },
  status: { type: String, enum: ["active", "completed"], default: "active" },
  createdAt: { type: Date, default: Date.now },
});

// module.exports = mongoose.model("BarterListing", BarterListingSchema);
export const BarterListing = mongoose.model(
  "BarterListing",
  BarterListingSchema
);
