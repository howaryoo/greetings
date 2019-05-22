# Greeting server

## Simple Web that listens to port 3000 (API_PORT env. variable)

## it exposes an endpoint called greeting :

GET /greeting => displays "Hello World"
GET /greeting/arye => displays "Hello Arye !"

## display the IP address that the server runs on. 

This way when this code runs on several pod instances you can see its diffrent IP.


# Usage

## Build docker image

    make build
    
## Run

    make run
