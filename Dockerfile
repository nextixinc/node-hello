FROM node:lts

# Copy source to container
RUN mkdir -p /usr/app/src

# Copy source code
#COPY src /usr/app/src
COPY index.js /usr/app
COPY package.json /usr/app
COPY package-lock.json /usr/app

WORKDIR /usr/app

# Running npm install for production purpose will not run dev dependencies.
RUN npm install -only=production    
RUN npm install -g pm2

RUN groupadd --gid 1001 gemcircle \
    && useradd --uid 1001 --gid gemcircle --shell /bin/bash --create-home gemcircle

# Chown all the files to the app user.
RUN chown -R gemcircle:gemcircle /usr/app

# Switch to 'appuser'
USER gemcircle

EXPOSE 3000
CMD [ "pm2-runtime", "index.js" ]