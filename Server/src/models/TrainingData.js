import { mongoose } from "mongoose";

const TrainingDataSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  title: { type: String, required: true },
  offer: { type: String, required: true },
  request: { type: String, required: true },
  status: { type: String, enum: ["successful", "failed"], required: true },
  tradePartners: [{ type: mongoose.Schema.Types.ObjectId, ref: "User" }], // Users involved
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model("TrainingData", TrainingDataSchema);
