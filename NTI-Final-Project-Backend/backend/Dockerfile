# -------- Build Stage --------
FROM python:3.10-alpine AS builder

WORKDIR /app

RUN apk add --no-cache gcc musl-dev libffi-dev postgresql-dev

COPY requirements.txt .

RUN pip install --upgrade pip
RUN pip install --no-cache-dir --prefix=/install -r requirements.txt


# -------- Runtime Stage --------
FROM python:3.10-alpine

WORKDIR /app

RUN apk add --no-cache curl

COPY --from=builder /install /usr/local
COPY . .

# Remove build tools & setuptools leftovers
RUN pip uninstall -y setuptools wheel

EXPOSE 5000

CMD ["python", "app.py"]
