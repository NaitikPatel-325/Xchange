import { Router } from "express";
import {
  createListing,
  getAllListings,
  getListingById,
  updateListing,
  deleteListing,
} from "../controller/barterlisting.js";

const router = Router();

// Create a new barter listing
router.post("/", createListing);

// Read - Get all barter listings
router.get("/", getAllListings);

// Read - Get single barter listing by ID
router.get("/:id", getListingById);

// Update - Update barter listing details
router.put("/:id", updateListing);

// Delete - Remove barter listing
router.delete("/:id", deleteListing);

export default router;
