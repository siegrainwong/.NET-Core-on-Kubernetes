FROM microsoft/dotnet:sdk AS build-env
WORKDIR /app
EXPOSE 80

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM microsoft/dotnet:aspnetcore-runtime
WORKDIR /app
COPY --from=build-env /app/out .
ENTRYPOINT ["dotnet", "k8s-demo.dll"]   # 注意这里改一下dll名称