from flask import Flask, request, jsonify
from flask_cors import CORS
import feedparser
import os
from dotenv import load_dotenv

from services.firestore_service import get_users_and_preferences
from services.news_service import get_latest_news
from services.gemini_service import rewrite_articles_with_preferences
from services.pdf_service import create_pdf
from services.email_service import send_email_with_pdf

# Load env variables
load_dotenv()

app = Flask(__name__)
CORS(app)

# --- Existing route for frontend ---
RSS_FEEDS = {
    "Technology": "https://feeds.bbci.co.uk/news/technology/rss.xml",
    "Health": "https://feeds.bbci.co.uk/news/health/rss.xml",
    "Finance": "https://feeds.bbci.co.uk/news/business/rss.xml",
    "Politics": "https://feeds.bbci.co.uk/news/politics/rss.xml",
    "Entertainment": "https://feeds.bbci.co.uk/news/entertainment_and_arts/rss.xml",
    "Sports": "https://feeds.bbci.co.uk/sport/rss.xml",
    "Science": "https://feeds.bbci.co.uk/news/science_and_environment/rss.xml",
    "Travel": "https://www.travelandleisure.com/rss",
    "Education": "https://www.edutopia.org/rss.xml",
}

@app.route('/get-news', methods=['POST'])
def get_news():
    data = request.json
    topics = data.get('topics', [])

    news_result = []
    for topic in topics:
        feed_url = RSS_FEEDS.get(topic)
        if feed_url:
            feed = feedparser.parse(feed_url)
            for entry in feed.entries[:5]:  # Limit to 5 articles per topic
                news_result.append({
                    "title": entry.title,
                    "link": entry.link,
                    "summary": entry.summary,
                    "topic": topic
                })

    return jsonify(news_result)

# --- New route to generate and email personalized news ---
@app.route('/generate-and-send', methods=['POST'])
def generate_and_send():
    users = get_users_and_preferences()

    for user in users:
        news = get_latest_news(user["topics"])
        rewritten_articles = rewrite_articles_with_preferences(news, user["preferences"])
        pdf_path = create_pdf(user["email"], rewritten_articles)
        send_email_with_pdf(user["email"], pdf_path)

    return jsonify({"status": "Emails sent successfully"})


if __name__ == '__main__':
    app.run(debug=True)
