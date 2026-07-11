FROM python:3.11-slim

# تنظیمات محیط
ENV PYTHONUNBUFFERED=1 \
    PYTHONDONTWRITEBYTECODE=1 \
    DATA_DIR=/data

# نصب وابستگی‌های سیستم
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
    && rm -rf /var/lib/apt/lists/*

# ایجاد کاربر غیر root برای امنیت
RUN useradd -m -u 1000 appuser

WORKDIR /app

# نصب وابستگی‌های پایتون
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# کپی کد پروژه
COPY . .

# ایجاد دایرکتوری داده و دادن دسترسی
RUN mkdir -p /data && chown -R appuser:appuser /app /data

USER appuser

# پورت پیش‌فرض
EXPOSE 8000

# دستور اجرا
CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
