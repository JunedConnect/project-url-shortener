# image being used is python:3.12-alpine
FROM python@sha256:02a73ead8397e904cea6d17e18516f1df3590e05dc8823bd5b1c7f849227d272

# TABLE_NAME ENV variable will be provided by ECS
ENV PYTHONPATH=/app

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY ./src/. .

COPY ./tests/. .

RUN adduser -D dockeruser

RUN chown -R dockeruser .

USER dockeruser

CMD ["python", "-m", "uvicorn", "main:app", "--host=0.0.0.0", "--port=8080"]
