FROM python:3.10-slim

VOLUME [ "/var/run/docker.sock:/var/run/docker.sock" ]
RUN apt update 
# RUN apt install python3-pip -y
RUN apt install docker.io -y

WORKDIR /app

COPY . /app

RUN pip install --no-cache-dir -r requirements.txt

# Expose port 5002 to the outside world
EXPOSE 5002

# Define environment variable
# ENV FLASK_APP=main.py

# Run the application when the container launches
CMD ["flask", "run", "--host=0.0.0.0", "--port=5002"]


# CMD [ "Python3", "main.py", "--host=0.0.0.0" ]