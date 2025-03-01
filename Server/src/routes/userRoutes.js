import { Router } from "express";
import {
  registerUser,
  getUserById,
  updateUser,
  deleteUser,
} from "../controller/user.js";

const router = Router();

router.post("/register", registerUser);
// Read - Get user by ID
router.get("/:id", getUserById);

// Update - Update user details
router.put("/:id", updateUser);

// Delete - Remove user
router.delete("/:id", deleteUser);

export default router;
