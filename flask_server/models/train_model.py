import pandas as pd
import pickle
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity

# ✅ Expanded barter dataset for better testing
barter_data = pd.DataFrame([
    {"id": 1, "title": "Laptop for Camera", "category": "Electronics"},
    {"id": 2, "title": "Web Design for Guitar", "category": "Services"},
    {"id": 3, "title": "Trading Books for Digital Credits", "category": "Books"},
    {"id": 4, "title": "iPad for Drone", "category": "Electronics"},
    {"id": 5, "title": "Bicycle for a Pair of Headphones", "category": "Transportation"},
    {"id": 6, "title": "Painting Classes for Cooking Lessons", "category": "Education"},
    {"id": 7, "title": "Smartwatch for Wireless Earbuds", "category": "Electronics"},
    {"id": 8, "title": "Home Gym Equipment for Office Chair", "category": "Furniture"},
    {"id": 9, "title": "Photography Services for Event Tickets", "category": "Services"},
    {"id": 10, "title": "Mountain Bike for Camping Gear", "category": "Outdoor"},
    {"id": 11, "title": "Music Production Lessons for Video Editing Software", "category": "Education"},
    {"id": 12, "title": "Dog Training Sessions for Cat Grooming", "category": "Pets"},
    {"id": 13, "title": "3D Printer for Gaming Console", "category": "Electronics"},
    {"id": 14, "title": "Handmade Jewelry for Art Supplies", "category": "Crafts"},
    {"id": 15, "title": "Motorcycle Helmet for Hiking Backpack", "category": "Outdoor"},
    {"id": 16, "title": "Graphic Design Services for Custom Clothing", "category": "Services"},
    {"id": 17, "title": "Antique Clock for Modern Smart Speaker", "category": "Antiques"},
    {"id": 18, "title": "Coding Bootcamp Course for AI Training Subscription", "category": "Education"},
    {"id": 19, "title": "Yoga Mat and Blocks for Meditation Chair", "category": "Wellness"},
    {"id": 20, "title": "Gaming PC for Professional Camera", "category": "Electronics"}
])

# TF-IDF Model 
vectorizer = TfidfVectorizer(stop_words="english")
tfidf_matrix = vectorizer.fit_transform(barter_data["title"])

# Compute similarity between barter listings
cosine_sim = cosine_similarity(tfidf_matrix, tfidf_matrix)

# AI model as a DICTIONARY with vocabulary
model_data = {
    "vectorizer": vectorizer,
    "cosine_sim": cosine_sim,
    "tfidf_matrix": tfidf_matrix,  # Save the trained TF-IDF matrix
    "barter_data": barter_data
}

with open("models/barter_match_model.pkl", "wb") as f:
    pickle.dump(model_data, f)

print("AI Model Trained on Expanded Dataset & Saved with Vocabulary!")
