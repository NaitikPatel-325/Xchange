import axios from "axios";
import { BarterListing } from "../models/BarterListing.js";
import mongoose from "mongoose";
import { User } from "../models/User.js";

export const getRecommendations = async (userId) => {
  try {
    console.log(`🔹 Received userId: ${userId} (Type: ${typeof userId})`);


    // 🔹 Fetch the user's barter listings
    const userListings = await BarterListing.find({ userId: new mongoose.Types.ObjectId(userId) });

    // 🔹 Fetch the user's preferences
    const user = await User.findById(userId);
    if (!user) {
      console.log("User not found.");
      return [];
    }

    console.log(`User Preferences:`, user.preferences);

    // ✅ If no listings, use only preferences for recommendations
    let userQuery;
    if (userListings.length > 0) {
      userQuery = [
        ...userListings.flatMap((listing) => [listing.category, listing.request]),
        ...user.preferences, // Include preferences
      ];
    } else {
      console.log("⚠️ No barter listings found for this user. Using preferences instead.");
      userQuery = [...user.preferences]; // Use preferences alone if no listings
    }

    // 🔹 Convert the array to a string
    userQuery = userQuery.filter(Boolean).join(" ");

    if (!userQuery) {
      console.log("❌ No valid query generated for user.");
      return [];
    }

    console.log(`🔍 Query sent to Flask: ${userQuery}`);

    // 🔹 Send the query to Flask API
    const flaskResponse = await axios.post("http://127.0.0.1:5000/recommend", {
      query: userQuery,
    });

    const flaskRecommendations = flaskResponse.data.recommendations;

    if (!flaskRecommendations.length) {
      console.log("❌ No recommendations received from Flask.");
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
      console.log("⚠️ No matching barter listings found in MongoDB.");
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
    console.error("❌ Error fetching recommendations:", error.message);
    return [];
  }
};
