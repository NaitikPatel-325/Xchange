from pymongo import MongoClient

client = MongoClient("mongodb+srv://kriscollege:Kris%40123@cluster0.3crjfvn.mongodb.net/")
db = client["XChange"]
collection = db["barterlistings"]

# Fetch documents
listings = list(collection.find({}, {"_id": 0, "title": 1, "category": 1}))

print("MongoDB Listings:", listings)
