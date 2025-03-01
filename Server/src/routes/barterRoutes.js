import express from "express";
import { getRecommendations } from "../services/recommendationService.js";

const router = express.Router();


router.post("/", async (req, res) => {
  try {
    const barter = new BarterListing(req.body);
    await barter.save();
    const recommendations = await getRecommendations(req.body.userId);
    res.status(201).json({ message: "Barter listing created", recommendations });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// Get Recommendations for a User
router.get("/recommend/:userId", async (req, res) => {
  try {
    const userId = req.params.userId;

    const recommendations = await getRecommendations(userId);

    if (!recommendations.length) {
      return res.status(404).json({ message: "No recommendations found" });
    }

    res.json({ recommendations });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});


export default router;
