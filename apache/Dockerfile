FROM httpd:2.4.41

EXPOSE 8443
EXPOSE 8080

RUN apt-get update && \
	apt-get -y install openssl dos2unix vim curl netcat.traditional net-tools

COPY ./conf/httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./conf/extra/httpd-example.conf /usr/local/apache2/conf/extra/httpd-example.conf
COPY certs certs 

RUN sed -i 's/DEFAULT@SECLEVEL=2/DEFAULT@SECLEVEL=1/g' /etc/ssl/openssl.cnf
