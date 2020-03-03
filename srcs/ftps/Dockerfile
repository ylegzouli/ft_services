FROM alpine:latest


RUN apk update && apk upgrade && \
	apk --update --no-cache add vsftpd && \
	apk --no-cache add openssl
RUN apk add vim

RUN openssl req -x509 -nodes -days 365 -newkey rsa:4096 -subj "/C=DE/ST=BW/L=Karlsruhe/O=IT/CN=www.itas-gmbh.de" -keyout /etc/vsftpd/vsftpd.key -out /etc/vsftpd/vsftpd.crt
COPY vsftpd.conf /etc/vsftpd/

RUN adduser -h /home/./ftpsuser -s /bin/false -D ftpsuser ftpsuser
RUN echo 'ftpsuser:test' | chpasswd
RUN chown ftpsuser:ftpsuser /home/ftpsuser/ -R

EXPOSE 20 21 30020 30021

COPY start.sh /usr/local/bin/
RUN chmod 700 /usr/local/bin/start.sh  

ENTRYPOINT ["/usr/local/bin/start.sh"]
