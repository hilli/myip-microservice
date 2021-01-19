package main

import (
	"fmt"
	"net"
	"net/http"
	"strings"
)

func main() {

	mux := http.NewServeMux()

	mux.HandleFunc("/", func(res http.ResponseWriter, req *http.Request) {
		headers := res.Header()
		var ip string

		proxyHeader := req.Header.Get("X-Forwarded-For")
		if proxyHeader != "" {
			ip = proxyHeader
		} else {
			host, _, _ := net.SplitHostPort(req.RemoteAddr)
			ip = host
		}

		if strings.Contains(req.Header.Get("Accept"), "text/html") ||
			strings.Contains(req.Header.Get("Accept"), "*/*") ||
			strings.Contains(req.Header.Get("Accept"), "text/plain") {
			headers.Set("Content-Type", "text/plain")
			fmt.Fprint(res, ip)
		} else {
			headers.Set("Content-Type", "application/json")
			fmt.Fprint(res, fmt.Sprintf("{\n\t\"ip_address\": \"%s\"\n}\n", ip))
		}
	})
	http.ListenAndServe(":8080", mux)
}
