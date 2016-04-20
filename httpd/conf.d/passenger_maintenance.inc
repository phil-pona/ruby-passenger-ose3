ErrorDocument 503 /503.html

RewriteEngine on

RewriteCond %{DOCUMENT_ROOT}/../tmp/stop.txt -f
RewriteCond %{DOCUMENT_ROOT}/%{REQUEST_FILENAME} !-f
RewriteRule ^(.*)$ /$1 [R=503,L]
