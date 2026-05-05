# Start with the base image
FROM golang:1.23 as base

# set the working directory inside the container
WORKDIR /app

# copy the go.mod and go.sum files to the working directory
COPY go.mod ./

# download all the dependencies
RUN go mod download

#copy the source code to the working directory
COPY . .

# build the application
RUN go build -o main .

######################

# reduce the image size using multi-stage builds

# we will use a distroless image to run the application

FROM gcr.io/distroless/base

# copy the binary from the previous stage
COPY --from=base /app/main .

# copy the static files from the preavious stage

COPY --from=base /app/static ./static

# expose the port on which the application will run

EXPOSE 8081

# command to run the application

CMD ["./main"]
