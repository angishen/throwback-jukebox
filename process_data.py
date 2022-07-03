import pandas as pd
from datetime import date, timedelta

def generate_week_start_date(end_date_str):
    end_date = date.fromisoformat(end_date_str)
    return end_date - timedelta(days=7)

hot_100 = pd.read_csv("./hot_stuff_2.csv")

weekid = hot_100["weekid"]
hot_100["week_start_date"] = weekid.apply(generate_week_start_date)

hot_100 = hot_100[[
    "weekid",
    "week_start_date",
    "song",
    "performer",
    "week_position",
    "previous_week_position",
    "peak_position",
    "weeks_on_chart",
    "instance"
]]

hot_100.to_csv("./hot_100_processed.csv", index=False)
