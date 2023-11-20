FROM gcr.io/google.com/cloudsdktool/cloud-sdk:alpine

WORKDIR /app
COPY . .

RUN gcloud components install beta -q
RUN gcloud builds submit --tag gcr.io/starling-405617/toucan
