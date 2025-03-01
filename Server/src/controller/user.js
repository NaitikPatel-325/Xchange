import { User } from "../models/User.js";
import asyncHandler from "../utils/asyncHandler.js";

const registerUser = asyncHandler(async (req, res) => {
  console.log(req.body);
  const { displayname, email, password } = req.body;

  if (!displayname || !email || !password) {
    return res.status(400).json({
      success: false,
      message: "All fields are required",
    });
  }

  // Check if user already exists
  const existingUser = await User.findOne({ email });
  if (existingUser) {
    return res.status(409).json({
      success: false,
      message: "User with this email already exists",
    });
  }

  // Create new user
  const user = await User.create({
    displayname,
    email,
    password,
  });

  // Remove password from response
  const createdUser = user.toObject();
  delete createdUser.password;

  return res.status(201).json({
    success: true,
    message: "User registered successfully",
    data: createdUser,
  });
});

export { registerUser };
