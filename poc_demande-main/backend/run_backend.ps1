# تفعيل البيئة الافتراضية
cd $PSScriptRoot
if (-Not (Test-Path venv)) {
    python -m venv venv
}

. .\venv\Scripts\Activate.ps1

# تحديث pip
python -m pip install --upgrade pip

# تثبيت المكتبات المطلوبة
pip install fastapi uvicorn sqlalchemy asyncpg aiosqlite pydantic-settings python-jose[cryptography] bcrypt python-dotenv

# تشغيل السيرفر على 0.0.0.0:9000 مع عرض كل الأخطاء
Start-Process "python" -ArgumentList "-m uvicorn app.main:app --reload --host 0.0.0.0 --port 9000 --log-level debug" 

# فتح المتصفح تلقائيًا
Start-Sleep -Seconds 2
Start-Process "http://localhost:9000"