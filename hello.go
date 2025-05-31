package main

import (
	"fmt"
	"log"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintln(w, "Hello, World!")
}

func main() {
	http.HandleFunc("/", handler) //handle requests
	fmt.Println("Running on port 80")
	log.Fatal(http.ListenAndServe(":80", nil))
}
