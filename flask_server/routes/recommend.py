from flask import Blueprint, request, jsonify
import pandas as pd
import pickle
from pymongo import MongoClient
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.metrics.pairwise import cosine_similarity
import scipy.sparse

recommend_bp = Blueprint("recommend", __name__)

# Connect to MongoDB
try:
    client = MongoClient("mongodb+srv://kriscollege:Kris%40123@cluster0.3crjfvn.mongodb.net/")
    db = client["XChange"]
    collection = db["barterlistings"]
    print("Connected to MongoDB")
except Exception as e:
    print("Error connecting to MongoDB:", str(e))

# Load AI Model
try:
    with open("models/barter_match_model.pkl", "rb") as f:
        model_data = pickle.load(f)
        vectorizer = model_data.get("vectorizer")
        tfidf_matrix = model_data.get("tfidf_matrix")
        barter_data = pd.DataFrame(model_data.get("barter_data", []))

        if vectorizer is None or tfidf_matrix is None or barter_data.empty:
            print("Model is empty or corrupted. Retraining required.")
            vectorizer, tfidf_matrix, barter_data = None, None, pd.DataFrame()
        else:
            print("Model loaded successfully.")
except FileNotFoundError:
    print("No model found. Starting training from scratch.")
    vectorizer, tfidf_matrix, barter_data = None, None, pd.DataFrame()

def check_for_new_listings():
    all_listings = list(collection.find({}, {"_id": 0, "title": 1, "category": 1}))
    
    print(all_listings)

    if not all_listings:
        print("⚠️ No listings found in MongoDB.")
        return pd.DataFrame(columns=["title", "category"])

    all_listings_df = pd.DataFrame(all_listings)

    # If `barter_data` is empty, return all listings
    if barter_data.empty:
        print("Returning all listings as new data (first-time training).")
        return all_listings_df

    # Ensure `barter_data` has "title" column before checking duplicates
    if "title" not in barter_data.columns:
        print("⚠️ 'title' column missing in barter_data. Resetting AI model.")
        return all_listings_df  # Retrain the model with all listings

    # Find new listings (titles not in previous barter_data)
    new_listings = all_listings_df[~all_listings_df["title"].isin(barter_data["title"])]
    
    if new_listings.empty:
        print("✅ No new listings found.")
    else:
        print(f"✅ {len(new_listings)} new listings found!")

    return new_listings



# Update AI Model if new data exists
@recommend_bp.route("/update-model", methods=["GET"])
def update_model():
    global vectorizer, tfidf_matrix, barter_data

    new_listings = check_for_new_listings()

    if new_listings.empty:
        return jsonify({"message": "No new data found"}), 200

    print(f"Updating AI model with {len(new_listings)} new listings...")

    if vectorizer is None:
        vectorizer = TfidfVectorizer(stop_words="english")
        tfidf_matrix = vectorizer.fit_transform(new_listings["title"])
    else:
        new_tfidf_matrix = vectorizer.transform(new_listings["title"])
        tfidf_matrix = scipy.sparse.vstack([tfidf_matrix, new_tfidf_matrix])

    barter_data = pd.concat([barter_data, new_listings], ignore_index=True)

    # Save updated model
    with open("models/barter_match_model.pkl", "wb") as f:
        pickle.dump({
            "vectorizer": vectorizer,
            "tfidf_matrix": tfidf_matrix,
            "barter_data": barter_data.to_dict(orient="records")
        }, f)

    print("AI Model updated successfully.")
    return jsonify({"message": "AI Model Updated"}), 200

# Get AI-powered barter recommendations
@recommend_bp.route("/recommend", methods=["POST"])
def recommend():
    global vectorizer, tfidf_matrix, barter_data

    data = request.json
    query = data.get("query", "").strip()

    if not query:
        return jsonify({"error": "Query is required"}), 400

    if vectorizer is None or tfidf_matrix is None:
        update_model()

    if vectorizer is None or tfidf_matrix is None:
        return jsonify({"error": "AI Model is not trained yet."}), 500

    query_vector = vectorizer.transform([query])
    similarities = cosine_similarity(query_vector, tfidf_matrix).flatten()
    top_indices = similarities.argsort()[-5:][::-1]
    recommended_listings = barter_data.iloc[top_indices].to_dict(orient="records")

    return jsonify({"recommendations": recommended_listings}), 200
