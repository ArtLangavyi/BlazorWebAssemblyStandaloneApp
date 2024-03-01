# BlazorWebAssemblyStandaloneApp hosted in Docker - uses nginx on alpine base image.

- **Dockerfile** - builds, publishes, and uses nginx to host it.
- **/nginx.conf** - the nginx.conf file needed to serve the site.

### How to run

Run `docker-compose up --build` from Hosted folder. Open browser and go to http://localhost:5002/

OR

Run `docker build -t blazorindockerdemo .`

Run `docker run --name blazorindockerdemo -d -p 5002:8080 --rm blazorindockerdemo`

Open browser and go to http://localhost:5002/

### nginx config

nginx config is pretty simple :) we need to define root path / filename / location

```
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
```

### Dockerfile

Define SDK version

`FROM mcr.microsoft.com/dotnet/sdk:8.0 as build`

Define application folder

`WORKDIR /app`

Copy solution and project file (we need this for restore dependencies)

```
COPY BlazorWebAssemblyStandaloneApp.sln ./
COPY BlazorWebAssemblyStandaloneApp.csproj ./
```

Basically restore dependencies

```
RUN dotnet restore
COPY . ./
```

Let's publish in directory 'out'

```
RUN dotnet publish -c Release -o out
```

Define nginx

```
FROM nginx:alpine
WORKDIR /app
```

Expose internal port

```
EXPOSE 8080
```

Apply application nginx config

```
COPY nginx.conf /etc/nginx/nginx.conf
```

And copy 'out' to 'nginx.conf->root (/usr/share/nginx/html;)'

```
COPY --from=build /app/out/wwwroot /usr/share/nginx/html
```
