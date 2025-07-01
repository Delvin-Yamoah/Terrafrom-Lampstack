#!/bin/bash
apt-get update
apt-get install -y apache2

# Enable Apache modules
a2enmod proxy
a2enmod proxy_http
a2enmod rewrite

# Start and enable Apache
systemctl start apache2
systemctl enable apache2

# Create visit counter web page
cat > /var/www/html/index.html << 'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Visit Counter</title>
    <style>
        body { font-family: Arial, sans-serif; text-align: center; margin-top: 50px; }
        .counter { font-size: 2em; color: #333; margin: 20px; }
        button { padding: 10px 20px; font-size: 1em; cursor: pointer; }
    </style>
</head>
<body>
    <h1>Welcome to LAMP Stack Visit Counter</h1>
    <div class="counter">
        <p>Total Visits: <span id="visitCount">Loading...</span></p>
    </div>
    <button onclick="incrementVisit()">Count My Visit</button>
    
    <script>
        function loadVisitCount() {
            fetch('/api.php')
                .then(response => response.json())
                .then(data => {
                    document.getElementById('visitCount').textContent = data.visits || 'Error';
                })
                .catch(error => {
                    document.getElementById('visitCount').textContent = 'Error loading count';
                });
        }
        
        function incrementVisit() {
            fetch('/api.php', { method: 'POST' })
                .then(response => response.json())
                .then(data => {
                    document.getElementById('visitCount').textContent = data.visits || 'Error';
                })
                .catch(error => {
                    document.getElementById('visitCount').textContent = 'Error updating count';
                });
        }
        
        // Load initial count
        loadVisitCount();
        
        // Refresh count every 5 seconds
        setInterval(loadVisitCount, 5000);
    </script>
</body>
</html>
EOF

# Create Apache proxy configuration
cat > /etc/apache2/sites-available/000-default.conf << 'CONF'
<VirtualHost *:80>
    DocumentRoot /var/www/html
    
    ProxyPreserveHost On
    ProxyPass /api.php http://${app_server_ip}/api.php
    ProxyPassReverse /api.php http://${app_server_ip}/api.php
    
    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined
</VirtualHost>
CONF

# Set proper permissions
chown www-data:www-data /var/www/html/index.html
chmod 644 /var/www/html/index.html

# Restart Apache
systemctl restart apache2