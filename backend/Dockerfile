# Stage 1 - Install dependencies
FROM python:3.11-slim as builder

WORKDIR /app

COPY requirements.txt .
RUN pip install --upgrade pip && pip install --user -r requirements.txt

# Stage 2 - Build image
FROM python:3.11-slim

WORKDIR /app

ENV PATH=/root/.local/bin:$PATH

COPY --from=builder /root/.local /root/.local
COPY ./app ./app

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
