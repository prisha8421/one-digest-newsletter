import feedparser

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

def get_latest_news(topics):
    articles = []
    for topic in topics:
        feed = feedparser.parse(RSS_FEEDS.get(topic, ""))
        for entry in feed.entries[:2]:
            articles.append({
                "title": entry.title,
                "summary": entry.summary,
                "link": entry.link,
                "topic": topic
            })
    return articles
