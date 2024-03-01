# BlazorWebAssemblyStandaloneApp hosted in Docker - uses nginx on alpine base image.

- **Dockerfile** - builds, publishes, and uses nginx to host it.
- **/nginx.conf** - the nginx.conf file needed to serve the site.

### How to run

Run `docker-compose up --build` from Hosted folder. Open browser and go to http://localhost:5002/

OR

Run `docker build -t blazorindockerdemo .`
Run `docker run --name blazorindockerdemo -d -p 5002:8080 --rm blazorindockerdemo`

### nginx config

nginx config is pretty simple :) we need to define root path / filename / location
<sub>
events { }
http {
include mime.types;
server {
listen 8080;
server_name localhost;
root /usr/share/nginx/html;
index index.html;
location / {
try_files $uri $uri/ /index.html =404;
}
}
}
</sub>

### Dockerfile

Define SDK version

<sub>FROM mcr.microsoft.com/dotnet/sdk:8.0 as build</sub>

Define application folder

<sub>WORKDIR /app</sub>

Copy solution and project file (we need this for restore dependencies)

<sub>
COPY BlazorWebAssemblyStandaloneApp.sln ./
COPY BlazorWebAssemblyStandaloneApp.csproj ./
</sub>

Basically restore dependencies

<sub>
RUN dotnet restore
COPY . ./
</sub>

Let's publish in directory 'out'

<sub>
RUN dotnet publish -c Release -o out
</sub>

Define nginx

<sub>
FROM nginx:alpine
WORKDIR /app
</sub>

Expose internal port
<sub>
EXPOSE 8080
</sub>
Apply application nginx config
<sub>
COPY nginx.conf /etc/nginx/nginx.conf
</sub>

And copy 'out' to 'nginx.conf->root (/usr/share/nginx/html;)'

<sub>
COPY --from=build /app/out/wwwroot /usr/share/nginx/html
</sub>
