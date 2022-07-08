#!/bin/sh

# crawler
/home/adlerhu/.local/share/virtualenvs/crawler-77tb8LvM/bin/python /home/adlerhu/pycode/Bitcoin/crawler/latest_price.py >> /tmp/crawler.txt

# ETL
/home/adlerhu/.local/share/virtualenvs/ETL-Vd3Y1IyR/bin/python /home/adlerhu/pycode/Bitcoin/ETL/latest_data.py >> /tmp/ETL.txt

# predict
/home/adlerhu/.local/share/virtualenvs/predict-b07QQou1/bin/python /home/adlerhu/pycode/Bitcoin/predict/predict.py >> /tmp/predict.txt

# result
/home/adlerhu/.local/share/virtualenvs/result-GtIX0MYk/bin/python /home/adlerhu/pycode//Bitcoin/result/result.py >> /tmp/result.txt

# charts
/home/adlerhu/.local/share/virtualenvs/charts-Ggzzi3if/bin/python /home/adlerhu/pycode/Bitcoin/charts/charts.py >> /tmp/charts.txt

