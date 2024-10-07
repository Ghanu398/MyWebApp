FROM mcr.microsoft.com/dotnet/sdk:7.0
RUN workdir /app
COPY . /app
WORKDIR /app
RUN dotnet publish -c release -o /app/release/out
WORKDIR /app/release/out
ENTRYPOINT ["dotnet","MyWebApp.dll"]