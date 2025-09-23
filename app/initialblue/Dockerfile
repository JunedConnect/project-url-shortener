FROM python:3.12-alpine

# TABLE_NAME ENV variable will be provided by ECS
ENV PYTHONPATH=/app

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY ./src/. .

COPY ./tests/. .

CMD ["python", "-m", "uvicorn", "main:app", "--host=0.0.0.0", "--port=8080"]
