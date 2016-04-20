# ServerName *:80

RewriteEngine on
RewriteCond %{REQUEST_METHOD} ^(TRACE|TRACK)
RewriteRule .* - [F]

ServerSignature Off
BrowserMatch "^gvfs/*" redirect-carefully
