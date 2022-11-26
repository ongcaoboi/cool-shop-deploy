FROM ubuntu:22.04 AS builder
RUN apt-get update && apt-get install -y dotnet6 ca-certificates

WORKDIR /source
COPY ./back-end/ .

RUN dotnet publish -c Release -o /app

FROM ubuntu/dotnet-runtime:6.0-22.04_beta

WORKDIR /app
COPY --from=builder /app ./

ENV PORT 5191
EXPOSE 5191

ENTRYPOINT ["dotnet", "/app/API_ShopingClose.dll"]
