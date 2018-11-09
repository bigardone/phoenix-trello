FROM ubuntu:18.04

RUN apt-get update && \
    apt-get install -y wget \
     build-essential \
    curl \
    sudo \
    mc \
    dialog \
    git

RUN wget https://packages.erlang-solutions.com/erlang-solutions_1.0_all.deb
RUN dpkg -i erlang-solutions_1.0_all.deb
RUN curl -sL https://deb.nodesource.com/setup_10.x | sudo -E bash -
RUN apt-get update
RUN apt-get -y install esl-erlang elixir nodejs

ENV LANG=C.UTF-8

WORKDIR /proj
RUN git clone https://github.com/trilogy-group/phoenix-trello.git
WORKDIR /proj/phoenix-trello
RUN yes | mix deps.get
RUN yes | mix deps.update --all
RUN npm install -g webpack
RUN npm install

CMD tail -f /dev/null
