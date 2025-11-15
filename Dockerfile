FROM dunglas/frankenphp:1.9-builder-php8.4

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    zip \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions required for Laravel
RUN install-php-extensions \
    pdo_mysql \
    mysqli \
    redis \
    zip \
    gd \
    intl \
    opcache \
    pcntl \
    bcmath \
    exif

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /app

# Copy application files
COPY ./codebase/backend /app

# Set permissions
RUN chown -R www-data:www-data /app/storage /app/bootstrap/cache

# Expose port
EXPOSE 8080
