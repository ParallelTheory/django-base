FROM python:2.7
ENV PYTHONUNBUFFERED 1
EXPOSE 8000
RUN mkdir /code
WORKDIR /code
COPY requirements.txt /code/
RUN pip install -r requirements.txt
COPY ./start.sh /
COPY ./code/ /code/
CMD /start.sh
