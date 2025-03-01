import mongoose from "mongoose";
import bcrypt from "bcrypt";

const userSchema = new mongoose.Schema(
  {
    displayName: {
      type: String,
      required: [true, "Username is required"],
      // unique: true,
      trim: true,
      // index: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
      lowercase: true,
      trim: true,
    },
    password: {
      type: String,
      required: [true, "Password is required"],
    },
    address: {
      type: String,
      lowercase: true,
      maxlength: 255,
      default: "abc,nadiad",
    },
    avatar: {
      type: String,
      default: "/avatar.png",
    },
    experience: {
      type: Number,
      default: 0,
    },
    accesstoken: {
      type: String,
      default: "",
    },
    preferences: {
      type: [String], // Example: ["Electronics", "Furniture", "Books"]
      default: [],
    },
    tradeCount: {
      type: Number,
      default: 0, // Tracks how many trades a user has completed
    },
    rating: {
      type: Number,
      default: 0, // User rating based on successful trades
    },
    role: {
      type: String,
      enum: ["user", "admin"],
      default: "user", // Future feature for admin/moderators
    },
  },
  {
    timestamps: true,
  }
);

userSchema.pre("save", async function (next) {
  if (!this.isModified("password")) return next();
  this.password = await bcrypt.hash(this.password, 10);
  next();
});

userSchema.methods.passwordCheck = async function (password) {
  return await bcrypt.compare(password, this.password);
};

userSchema.methods.incrementTradeCount = async function () {
  this.tradeCount += 1;
  await this.save();
};

export const User = mongoose.model("User", userSchema);
