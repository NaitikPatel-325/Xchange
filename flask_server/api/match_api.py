from flask import Flask, request, jsonify
from flask_cors import CORS
import pickle
import pandas as pd
from sklearn.metrics.pairwise import cosine_similarity

app = Flask(__name__)
CORS(app)

# ✅ Load AI Model with Correct Dictionary Structure
with open("models/barter_match_model.pkl", "rb") as f:
    model_data = pickle.load(f)

vectorizer = model_data["vectorizer"]
cosine_sim = model_data["cosine_sim"]
tfidf_matrix = model_data["tfidf_matrix"]  # Load the trained TF-IDF matrix
barter_data = model_data["barter_data"]

@app.route('/recommend', methods=['POST'])
def recommend_barters():
    user_request = request.json
    query = user_request.get("query", "Electronics")

    # ✅ Step 1: Use the SAME vectorizer and vocabulary from training
    query_vector = vectorizer.transform([query])

    # ✅ Step 2: Ensure query_vector has the same dimensions as the trained matrix
    if query_vector.shape[1] != tfidf_matrix.shape[1]:
        return jsonify({"error": "Dimension mismatch. Re-train model with updated dataset."}), 400

    # ✅ Step 3: Compute similarity scores
    similarity_scores = cosine_similarity(query_vector, tfidf_matrix).flatten()

    # ✅ Step 4: Get top 3 barter matches
    top_indices = similarity_scores.argsort()[-3:][::-1]
    recommended_barters = barter_data.iloc[top_indices].to_dict(orient="records")

    return jsonify({"recommendations": recommended_barters})

if __name__ == '__main__':
    app.run(debug=True, port=5000)
