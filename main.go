package main

import (
	"fmt"
	"log"
	"net/http"
	"os"
)

func main() {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	message := os.Getenv("WELCOME_MESSAGE")
	if message == "" {
		message = "Hello from default configuration!"
	}

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Message: %s\nRunning securely on Alpine as non-root user!\n", message)
	})

	log.Printf("Server is starting on port %s...", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatalf("Server failed to start: %v", err)
	}
}
