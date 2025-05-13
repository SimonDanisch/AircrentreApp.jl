docker build -t ndviewer-demo .
docker tag ndviewer-demo simondanisch/ndviewer-demo:latest
docker push simondanisch/ndviewer-demo:latest
docker run -p 8081:8081 -v $(pwd)/speedyweather.nc:/data/file.nc simondanisch/ndviewer-demo:latest
