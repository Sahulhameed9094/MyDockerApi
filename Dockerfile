# ARG BUILD_CONFIGURATION=Release
# ARG DOTNET_VERSION=10.0

# FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:${DOTNET_VERSION} AS build
# WORKDIR /src
# COPY *.csproj ./
# RUN --mount=type=cache,id=nuget-MyDockerApi, target=/root/.nuget/packages dotnet restore 


# COPY . ./
# RUN dotnet publish -c Release -o --no-restore /app/publish /p:UseAppHost=false /p:PublishReadyToRun=true

# FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
# WORKDIR /app
# COPY --from=build /app/publish ./

# EXPOSE 8080
# ENV ASPNETCORE_URLS=http://+:8080

# ENTRYPOINT ["dotnet", "MyDockerApi.dll"]



# FROM --platform=$BUILDPLATFORM  mcr.microsoft.com/dotnet/sdk:10.0 AS build
# WORKDIR /src

# COPY ["MyDockerApi.csproj", "MyDockerApi"]
# # RUN --mount=type=cache,id=nuget-MyDockerApi,target=/root/.nuget/packages dotnet restore "MyDockerApi.csproj"
# RUN --mount=type=cache,id=nuget-auth,target=/root/.nuget/packages dotnet restore

# COPY . .

# RUN dotnet publish "MyDockerApi.csproj" -c Release --no-restore -o /app/publish /p:UseAppHost=false /p:PublishReadyToRun=true

# FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
# WORKDIR /app
# COPY --from=build /app/publish ./

# EXPOSE 8080
# ENV ASPNETCORE_HTTP_PORTS=8080 \
#     DOTNET_ENVIRONMENT=Production \
#     DOTNET_RUNNING_IN_CONTAINER=TRUE \
#     DOTNET_NOLOGO=TRUE \
#     DOTNET_EnableDiagnostics=0 \
#     DOTNET_gcServer=1 \
#     DOTNET_TieredPGO=1

# ENTRYPOINT ["dotnet", "MyDockerApi.dll"]


FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

COPY *.csproj ./
RUN dotnet restore

COPY . ./
RUN dotnet publish -c Release -o /app/publish

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish ./

EXPOSE 8080
ENV ASPNETCORE_URLS=http://+:8080

ENTRYPOINT ["dotnet", "MyDockerApi.dll"]






