FROM php:8.3-apache

# Instalar dependencias
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    zip \
    unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install mysqli pdo pdo_mysql \
    && docker-php-ext-install intl \
    && a2enmod rewrite

# Copiar la aplicación al contenedor
COPY . /var/www/html
WORKDIR /var/www/html/public

# Configurar permisos
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Establecer ServerName para suprimir advertencias
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

# Copia la configuración de Apache
COPY apache-config.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite
# Exponer el puerto 80
EXPOSE 80