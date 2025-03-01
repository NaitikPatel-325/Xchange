import { User } from "../models/User.js";
import asyncHandler from "../utils/asyncHandler.js";

const registerUser = asyncHandler(async (req, res) => {
  const { displayName, email, password } = req.body;
  console.log(displayName, email, password, req.body);
  if (!displayName || !email || !password) {
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
    displayName,
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

// Read - Get user by ID
const getUserById = async (req, res) => {
  try {
    const user = await User.findById(req.params.id);
    if (!user) return res.status(404).json({ message: "User not found" });
    res.status(200).json(user);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

const updateUser = async (req, res) => {
  try {
    // Remove undefined fields to ensure only provided fields are updated
    const updateData = Object.fromEntries(
      Object.entries(req.body).filter(([_, v]) => v !== undefined)
    );

    const updatedUser = await User.findByIdAndUpdate(
      req.params.id,
      updateData,
      {
        new: true, // Return the updated document
        runValidators: true, // Ensure validations are applied
      }
    );

    if (!updatedUser)
      return res.status(404).json({ message: "User not found" });

    res.status(200).json(updatedUser);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

// Delete - Remove user
const deleteUser = async (req, res) => {
  try {
    const deletedUser = await User.findByIdAndDelete(req.params.id);
    if (!deletedUser)
      return res.status(404).json({ message: "User not found" });
    res.status(200).json({ message: "User deleted successfully" });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
};

export { registerUser, deleteUser, updateUser, getUserById };
