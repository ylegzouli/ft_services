FROM nginx:stable-alpine

COPY start.sh /start.sh
COPY sshd_config /sshd_config

RUN apk add openssh openrc

RUN openrc \
 && touch /run/openrc/softlevel

RUN rm /etc/ssh/sshd_config \
 && mv sshd_config /etc/ssh/ 

EXPOSE 4000

CMD sh start.sh

