import smtplib
from email.message import EmailMessage
from utils.config import EMAIL_USER, EMAIL_PASSWORD, EMAIL_PROVIDER

def send_email_with_pdf(to_email, pdf_path):
    msg = EmailMessage()
    msg["Subject"] = "Your Personalized Newsletter"
    msg["From"] = EMAIL_USER
    msg["To"] = to_email
    msg.set_content("Here's your personalized newsletter!")

    with open(pdf_path, "rb") as f:
        msg.add_attachment(f.read(), maintype="application", subtype="pdf", filename="newsletter.pdf")

    smtp_server = "smtp.office365.com" if EMAIL_PROVIDER == "outlook" else "smtp.gmail.com"
    smtp_port = 587 if EMAIL_PROVIDER == "outlook" else 465

    with smtplib.SMTP(smtp_server, smtp_port) as server:
        server.starttls()
        server.login(EMAIL_USER, EMAIL_PASSWORD)
        server.send_message(msg)
