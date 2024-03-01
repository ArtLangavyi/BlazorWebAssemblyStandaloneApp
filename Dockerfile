FROM mcr.microsoft.com/dotnet/sdk:8.0 as build
WORKDIR /app

COPY BlazorWebAssemblyStandaloneApp.sln ./
COPY BlazorWebAssemblyStandaloneApp.csproj ./

RUN dotnet restore
COPY . ./

RUN dotnet publish -c Release -o out

FROM nginx:alpine
WORKDIR /app
EXPOSE 8080
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/out/wwwroot /usr/share/nginx/html

