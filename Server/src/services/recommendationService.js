import axios from "axios";
import { BarterListing } from "../models/BarterListing.js";

export const getRecommendations = async (userId) => {
  try {
    // 🔹 Fetch the user's barter listings
    const userListings = await BarterListing.find({ userId });

    if (!userListings.length) {
      return [];
    }

    // 🔹 Extract relevant details for AI model
    const userInterests = userListings.flatMap(listing => [
      listing.category,
      ...listing.tags,
      listing.request
    ]).filter(Boolean); // Remove empty values

    // 🔹 Send user interests to Flask API
    const flaskResponse = await axios.post("http://127.0.0.1:5000/recommend", {
      interests: userInterests
    });

    const flaskRecommendations = flaskResponse.data.recommendations;

    if (!flaskRecommendations.length) {
      return [];
    }

    // 🔹 Find matching barter listings in MongoDB
    const recommendedListings = await BarterListing.find({
      $or: [
        { title: { $in: flaskRecommendations.map((rec) => rec.title) } },
        { category: { $in: flaskRecommendations.map((rec) => rec.category) } }
      ],
      userId: { $ne: userId } // Exclude the user's own listings
    }).populate("userId", "name email");

    // 🔹 Format response
    return recommendedListings.map(listing => ({
      userId: listing.userId._id,
      name: listing.userId.name,
      email: listing.userId.email,
      listingTitle: listing.title,
      category: listing.category,
      description: listing.description
    }));

  } catch (error) {
    console.error("Error fetching recommendations:", error.message);
    return [];
  }
};
