import { BarterListing } from "../models/BarterListing.js";
import asyncHandler from "../utils/asyncHandler.js";
import axios from "axios";
import { User } from "../models/User.js";


const createListing = asyncHandler(async (req, res) => {
  const { email, title, category, description, offer, request,barterPoints } = req.body;
  console.log(!barterPoints);

  if (!title || !category || !offer || !request || !description || !email || !barterPoints) {
    return res.status(400).json({
      success: false,
      message: "All required fields must be provided",
    });
  }

  // console.log("Creating listing:", req.body);

  try {
    // Fetch userId from email
    // console.log("Finding user with email:", email);
    const user = await User.findOne({ email : email });
    // console.log("User found:", user);
    if (!user) {  
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }
    const userId = user._id;

    // console.log("User found:", userId);
  
    // Create new listing
    const listing = await BarterListing.create({
      userId,
      title,
      category,
      description,
      offer,
      request,
      barterPoints
    });

    // Optional: Call AI model update in Flask
    // try {
    //   await axios.get("http://127.0.0.1:5000/update-model");
    //   console.log("AI Model updated successfully in Flask");
    // } catch (error) {
    //   console.error("Error updating AI model in Flask:", error.message);
    // }

    return res.status(200).json({
      success: true,
      message: "Listing created successfully",
      data: listing,
    });
  } catch (error) {
    console.error("Error creating listing:", error.message);
    res.status(500).json({
      success: false,
      message: "Internal Server Error",
    });
  }
});


// Read - Get all barter listings
const getAllListings = asyncHandler(async (req, res) => {
  const listings = await BarterListing.find().populate(
    "userId",
    "displayName email"
  );
  // console.log(listings);
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

const getBartersByCategory = asyncHandler(async (req, res) => {
    try {
      const category = req.query.category; 
      let barters;
      console.log("inside barters",category);
      if (category) {
          barters = await BarterListing.find({ category: category }); 
      } else {
          barters = await BarterListing.find(); 
      }

      console.log(barters);

      res.status(200).json(barters);
  } catch (error) {
      res.status(500).json({ message: "Server Error", error });
  }

});

export {
  createListing,
  getAllListings,
  getListingById,
  updateListing,
  deleteListing,
  getBartersByCategory
};
