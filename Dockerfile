FROM python:3.7.6-stretch

COPY . /app
WORKDIR /app

RUN pip install pip --upgrade
RUN pip install pyjwt && pip install flask && pip install gunicorn && pip install pytest

EXPOSE 8080
ENTRYPOINT ["gunicorn", "-b", ":8080", "main:APP"]
