## Setting up the server

To start the server make sure you've set the following environment variables:

- *go_dbname* - whatever name your postgress db has
- *go_password* - the password for your postgress db
- *google_maps_api_key* - google maps api key

When using Visual Studio Code, you can run the following to open up the bashrc file:
`code /root/.bashrc`

For example, put the following line in .bashrc:

```export go_dbname='movement_db'``` 



## Starting a screen NEW

1. Kill all screens with: 
```
pkill screen
```
2. Start a new screen with: 
```
screen -L -Logfile backend.log -dmS backend bash -c 'cd /home/movement_backend/movement/backend; go run main.go';
```





## Starting a new screen OLD

To prevent the act of closing the ssh tunnel to also kill the server process, open up a virtiual terminal:

```screen -S backend```

To see whether there is already a screen running, use:

```screen -ls```

If there is already a screen running, continue it as such:

```screen -r backend```

To return to the regular terminal, without killing the screen, press:

```CTRL + A + D```


## Running the server

 To run the server, and simultaniously close a previous instance of the server that possibly locks port 8000, run the following:

```kill -9 $(lsof -t -i:8000); clear; go run main.go```
```kill -9 $(lsof -t -i:8001); clear; go run main.go```
