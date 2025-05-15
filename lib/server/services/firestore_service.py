from utils.firebase import db

def get_users_and_preferences():
    users_ref = db.collection('users')
    docs = users_ref.stream()

    users = []
    for doc in docs:
        data = doc.to_dict()
        users.append({
            "email": data.get("email"),
            "topics": data.get("topics", []),
            "preferences": data.get("preferences", {})
        })
    return users
