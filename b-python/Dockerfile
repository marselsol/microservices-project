FROM python:3.9
WORKDIR /app
COPY . /app
RUN pip install -r requirements.txt
EXPOSE 8081
CMD ["flask", "run", "--host=0.0.0.0", "--port=8081"]