FROM mcr.microsoft.com/dotnet/sdk:7.0
RUN mkdir /app
COPY . /app
WORKDIR /app
RUN mkdir /app/release
RUN dotnet publish -c release -o /app/release/out
WORKDIR /app/release/out
ENTRYPOINT ["dotnet","MyWebApp.dll"]