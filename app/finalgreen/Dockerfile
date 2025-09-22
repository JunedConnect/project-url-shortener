FROM python:3.12-alpine

# For the TABLE_NAME, change this value to the DynamoDB table name
ENV PYTHONPATH=/app \
    TABLE_NAME=url

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY ./src/. .

COPY ./tests/. .

CMD ["python", "-m", "uvicorn", "main:app", "--host=0.0.0.0", "--port=8080"]
