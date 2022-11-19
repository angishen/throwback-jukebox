import pandas as pd
import re
from datetime import date, timedelta

def generate_week_start_date(end_date_str):
    end_date = date.fromisoformat(end_date_str)
    start_date = end_date - timedelta(days=6)
    return start_date.strftime("%Y-%m-%d")

def remove_secondary_artists(artist_str):
    artists = re.split(r'(\s|\s\(|\s\[)featuring\s', artist_str, flags=re.I)

    return artists[0]

try:
    data = pd.read_csv("./charts.csv")

    week_end_date = data["date"]
    data["week_start_date"] = week_end_date.apply(generate_week_start_date)

    artist  = data["artist"]
    data["primary_artist"] = artist.apply(remove_secondary_artists)

    data = data.rename(columns={
        "date": "week_end_date",
        "rank": "song_rank",
        "song": "song_name",
        "artist": "artist_display_name"
    })

    data = data[[
        "week_end_date",
        "week_start_date",
        "song_rank",
        "song_name",
        "primary_artist",
        "artist_display_name"
    ]]

    data.to_csv("./charts_processed.csv", index=False)
    print("Successfully parsed input file")
except Exception as e:
    print("Failed to process input file", e)