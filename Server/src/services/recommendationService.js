import axios from "axios";
import { BarterListing } from "../models/BarterListing.js";
import mongoose from "mongoose";
export const getRecommendations = async (userId) => {
  try {
    // 🔹 Fetch the user's barter listings
    // const userId = req.params.userId;
    console.log(typeof userId);
    const userObjId = new mongoose.Types.ObjectId("67c2e0bf68d365263a0ba257");
    const userListings = await BarterListing.find({ userId: userObjId });

    console.log(userListings);

    if (!userListings.length) {
      console.log("No listings found for user.");
      return [];
    }

    // 🔹 Convert user's interests into a single query string
    const userQuery = userListings
      .flatMap((listing) => [
        listing.category,
        // ...listing.tags,
        listing.request,
      ])
      .filter(Boolean) // Remove empty values
      .join(" "); // Convert array to string

    if (!userQuery) {
      console.log("No valid query generated for user.");
      return [];
    }

    console.log(`🔍 Query sent to Flask: ${userQuery}`);

    // 🔹 Send the query to Flask API
    const flaskResponse = await axios.post("http://127.0.0.1:5000/recommend", {
      query: userQuery, // ✅ Sending query in the correct format
    });

    const flaskRecommendations = flaskResponse.data.recommendations;

    if (!flaskRecommendations.length) {
      console.log("No recommendations received from Flask.");
      return [];
    }

    console.log(`✅ Flask Recommendations:`, flaskRecommendations);

    // 🔹 Find barter listings in MongoDB based on recommendations
    const recommendedListings = await BarterListing.find({
      $or: flaskRecommendations.map((rec) => ({
        title: new RegExp(rec.title, "i"), // Match title using regex
        category: rec.category, // Match exact category
      })),
      userId: { $ne: userId }, // Exclude the user's own listings
    }).populate("userId", "name email");

    if (!recommendedListings.length) {
      console.log("No matching barter listings found in MongoDB.");
    }

    // 🔹 Format the response
    return recommendedListings.map((listing) => ({
      userId: listing.userId._id,
      name: listing.userId.name,
      email: listing.userId.email,
      listingTitle: listing.title,
      category: listing.category,
      description: listing.description,
    }));
  } catch (error) {
    console.error("Error fetching recommendations:", error.message);
    return [];
  }
};
