FROM tklx/base:0.1.0

WORKDIR /learning_map_api

RUN apt-get update -y \
    && apt-get install sudo -y \
    && apt-get install build-essential checkinstall -y \ 
    && apt-get install libreadline-gplv2-dev libncursesw5-dev libssl-dev libsqlite3-dev tk-dev libgdbm-dev libc6-dev libbz2-dev -y \
    && sudo apt-get install wget ca-certificates -y \
    && wget https://www.python.org/ftp/python/3.6.1/Python-3.6.1.tar.xz \
    && tar xvf Python-3.6.1.tar.xz \
    && cd Python-3.6.1 \
    && ./configure \
    && sudo make altinstall

RUN apt-get install python3-pip -y \
    && pip3 install virtualenv \
    && virtualenv -p python3.6 my_env 

RUN . my_env/bin/activate \
    && apt-get install build-essential -y \
    && apt-get install tcl8.5 -y \
    && apt-get install wget -y \
    && wget http://download.redis.io/releases/redis-stable.tar.gz \
    && tar xzf redis-stable.tar.gz \
    && cd redis-stable \
    && make install

COPY main.py ./
COPY /api ./api
COPY requirements.txt ./
COPY config.py ./
COPY .env ./

RUN . my_env/bin/activate \ 
    && pip install -r requirements.txt

ENTRYPOINT . my_env/bin/activate \ 
           && redis-server --daemonize yes \
           && python -m celery worker -B -l info -A api.core.services.send_notification_service.push_notification

CMD ["python3.6", "--version"]