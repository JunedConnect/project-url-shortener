# ## Example Dockerfile - i don't want to see copy and paste of this pls. Make your own and make sure it works. Make sure it's light, secure and instructions to run are there. 

# FROM python:3.12-slim AS build
# WORKDIR /w
# COPY requirements.txt .
# RUN pip install --prefix=/out -r requirements.txt
# COPY src/ ./src

# FROM gcr.io/distroless/python3-debian12
# ENV PYTHONPATH=/app \
#     TABLE_NAME=changeme
# WORKDIR /app
# COPY --from=build /out /usr/local
# COPY --from=build /w/src /app
# USER 65532:65532
# EXPOSE 8080
# CMD ["-m", "uvicorn", "main:app", "--host=0.0.0.0", "--port=8080"]


FROM python:3.12-alpine AS builder

# For the TABLE_NAME, change this value to the DynamoDB table name
ENV PYTHONPATH=/app \
    TABLE_NAME=changeme

WORKDIR /app

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY ./src/. .

# COPY ./tests/. .

# CMD ["which", "uvicorn"]

# CMD ["python", "main.py", "--host=0.0.0.0", "--port=8080"] #try this aswell and see if it works

CMD ["python", "-m", "uvicorn", "main:app", "--host=0.0.0.0", "--port=8080"]