const mongoose = require("mongoose");

const TransactionSchema = new mongoose.Schema({
  user1: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  user2: { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
  barterListing: { type: mongoose.Schema.Types.ObjectId, ref: "BarterListing", required: true },
  status: { type: String, enum: ["pending", "completed", "cancelled"], default: "pending" },
  timestamp: { type: Date, default: Date.now }
});

module.exports = mongoose.model("Transaction", TransactionSchema);
