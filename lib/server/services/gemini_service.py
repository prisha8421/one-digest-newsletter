import requests
from utils.config import GEMINI_API_KEY

def rewrite_articles_with_preferences(articles, preferences):
    rewritten = []
    for article in articles:
        prompt = f"Rewrite this article titled '{article['title']}' with summary: {article['summary']} " \
                 f"to match preferences: {preferences}"

        response = requests.post(
            "https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent",
            params={"key": GEMINI_API_KEY},
            headers={"Content-Type": "application/json"},
            json={"contents": [{"parts": [{"text": prompt}]}]}
        )

        ai_text = response.json()['candidates'][0]['content']['parts'][0]['text']
        rewritten.append({
            "title": article["title"],
            "content": ai_text
        })

    return rewritten
