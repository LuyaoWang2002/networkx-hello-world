FROM python:3.12-slim

WORKDIR /app
ENV MPLBACKEND=Agg
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY cmu_campus_network.py .

CMD ["python", "cmu_campus_network.py"]
