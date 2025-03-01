import { BarterListing } from "../models/BarterListing.js";
import asyncHandler from "../utils/asyncHandler.js";

// Create a new barter listing
const createListing = asyncHandler(async (req, res) => {
  const { userId, title, category, description, offer, request, location } =
    req.body;

  if (!userId || !title || !category || !offer || !request) {
    return res.status(400).json({
      success: false,
      message: "All required fields must be provided",
    });
  }

  // Create new listing
  const listing = await BarterListing.create({
    userId,
    title,
    category,
    description,
    offer,
    request,
    location,
  });

  return res.status(201).json({
    success: true,
    message: "Listing created successfully",
    data: listing,
  });
});

// Read - Get all barter listings
const getAllListings = asyncHandler(async (req, res) => {
  const listings = await BarterListing.find().populate(
    "userId",
    "displayName email"
  );
  res.status(200).json({
    success: true,
    data: listings,
  });
});

// Read - Get single barter listing by ID
const getListingById = asyncHandler(async (req, res) => {
  const listing = await BarterListing.findById(req.params.id).populate(
    "userId",
    "displayName email"
  );

  if (!listing) {
    return res
      .status(404)
      .json({ success: false, message: "Listing not found" });
  }

  res.status(200).json({ success: true, data: listing });
});

// Update - Update barter listing details
const updateListing = asyncHandler(async (req, res) => {
  // Fetch the existing listing
  const existingListing = await BarterListing.findById(req.params.id);

  if (!existingListing) {
    return res
      .status(404)
      .json({ success: false, message: "Listing not found" });
  }

  // Identify fields not provided in req.body and keep their existing values
  const updatedData = { ...existingListing.toObject(), ...req.body };

  // Update the listing with merged data
  const updatedListing = await BarterListing.findByIdAndUpdate(
    req.params.id,
    updatedData,
    {
      new: true,
      runValidators: true,
    }
  );

  res.status(200).json({
    success: true,
    message: "Listing updated successfully",
    data: updatedListing,
  });
});

// Delete - Remove barter listing
const deleteListing = asyncHandler(async (req, res) => {
  const deletedListing = await BarterListing.findByIdAndDelete(req.params.id);

  if (!deletedListing) {
    return res
      .status(404)
      .json({ success: false, message: "Listing not found" });
  }

  res
    .status(200)
    .json({ success: true, message: "Listing deleted successfully" });
});

export {
  createListing,
  getAllListings,
  getListingById,
  updateListing,
  deleteListing,
};
