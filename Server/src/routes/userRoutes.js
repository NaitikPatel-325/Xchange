import { Router } from "express";
import {
  registerUser,
  getUserById,
  updateUser,
  updateaddUser,
  deleteUser,
  getUserbyEmail
} from "../controller/user.js";

const router = Router();

router.post("/register", registerUser);
// Read - Get user by ID
router.get("/:id", getUserById);
router.get("/email/:email", getUserbyEmail);

// Update - Update user details
router.put("/:id", updateUser);
router.put("/add/:id", updateaddUser);

// Delete - Remove user
router.delete("/:id", deleteUser);

export default router;
