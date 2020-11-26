FROM ubuntu:latest

WORKDIR /usr/local

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y chef git \
    && git clone https://github.com/bearddan2000/chef-lib-recipes.git \
    && chmod -R +x chef-lib-recipes \
    && mkdir -p cookbooks/op/recipes \
    && mv chef-lib-recipes/webservers/apache-default.rb cookbooks/op/recipes/default.rb \
    && chef-solo -c chef-lib-recipes/solo.rb -o 'recipe[op]' \
    && rm -f /var/www/html/index.html

COPY bin/ /var/www/html

RUN chown -R www-data:www-data /var/www/html \
    && chmod -R +x /var/www/html

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
