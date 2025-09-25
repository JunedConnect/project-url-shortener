# image being used is python:3.12-alpine
FROM python@sha256:2e92c699abecf757ebebc21ffa57b52293f862981073a2243a866cba22174ce9

# TABLE_NAME ENV variable will be provided by ECS
ENV PYTHONPATH=/app

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY ./src/. .

COPY ./tests/. .

RUN useradd dockeruser

RUN chown -R dockeruser .

USER dockeruser

CMD ["python", "-m", "uvicorn", "main:app", "--host=0.0.0.0", "--port=8080"]
