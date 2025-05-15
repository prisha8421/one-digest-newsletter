from fpdf import FPDF
import os

def create_pdf(user_email, articles):
    pdf = FPDF()
    pdf.add_page()
    pdf.set_font("Arial", size=12)

    for art in articles:
        pdf.multi_cell(0, 10, f"Title: {art['title']}\n\n{art['content']}\n\n---\n")

    path = f"generated_pdfs/{user_email.replace('@', '_')}.pdf"
    pdf.output(path)
    return path
