import mongoose from "mongoose";

// If your model doesn't already include these fields
const TransactionSchema = new mongoose.Schema({
    user1: { type: mongoose.Schema.Types.ObjectId, required: true },
    user2: { type: mongoose.Schema.Types.ObjectId, required: true },
    user1Email: { type: String },
    user2Email: { type: String },
    barterListing: { type: mongoose.Schema.Types.ObjectId, required: true },
    status: { type: String, default: 'pending' },
    timestamp: { type: Date, default: Date.now },
    offeredItem: {
      title: String,
      description: String,
      offer: String
    },
    requestedItem: {
      title: String
    }
  });

const Transaction = mongoose.model("Transaction", TransactionSchema);
export default Transaction;
