import streamlit as st

# Define pages
pages = {
    "Günlük hesabat": "Gunluk.py",
    "ŞOK Kampaniya": "Cesit.py"
}

# Streamlit's new navigation API
selected_page = st.radio("Menyu", list(pages.keys()), horizontal=True)

# Run the selected page
if selected_page == "Günlük hesabat":
    import Hesabat
elif selected_page == "ŞOK Kampaniya":
    import Cesit
