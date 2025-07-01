#!/bin/bash
apt-get update
apt-get install -y apache2 php php-mysql

# Start and enable Apache
systemctl start apache2
systemctl enable apache2

# Create visit counter API
cat > /var/www/html/api.php << 'EOF'
<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

$servername = "${db_server_ip}";
$username = "appuser";
$password = "apppass123";
$dbname = "visitcounter";

try {
    $pdo = new PDO("mysql:host=$servername;dbname=$dbname", $username, $password);
    $pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    
    if ($_SERVER['REQUEST_METHOD'] === 'POST') {
        // Increment visit count
        $stmt = $pdo->prepare("UPDATE visits SET count = count + 1 WHERE id = 1");
        $stmt->execute();
    }
    
    // Get current count
    $stmt = $pdo->prepare("SELECT count FROM visits WHERE id = 1");
    $stmt->execute();
    $result = $stmt->fetch(PDO::FETCH_ASSOC);
    
    echo json_encode(['visits' => $result['count']]);
    
} catch(PDOException $e) {
    echo json_encode(['error' => 'Database connection failed: ' . $e->getMessage()]);
}
?>
EOF

# Set proper permissions
chown www-data:www-data /var/www/html/api.php
chmod 644 /var/www/html/api.php

# Restart Apache
systemctl restart apache2