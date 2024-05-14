# Utilisez une image légère basée sur Nginx pour servir les fichiers HTML
FROM nginx:alpine
#Use ARG to define a build-time variable
ARG BUILD_NUMBER=1
ENV BUILD_NUMBER=${BUILD_NUMBER}
LABEL version="1.0.${BUILD_NUMBER}"
# Copiez le fichier index.html dans le répertoire de base de Nginx
COPY index.html /usr/share/nginx/html

# Exposez le port 80 pour que l'application soit accessible
EXPOSE 80

# Commande par défaut pour démarrer Nginx et servir l'application
CMD ["nginx", "-g", "daemon off;"]
