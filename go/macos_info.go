package main

import (
	"io/ioutil"
	"net/http"
	"fmt"
)


func main() {
	public_ip()

}



func public_ip() {
	resp, err := http.Get("https://ipapi.co/ip")
	if err != nil {
		fmt.Print("Page down")
	}
	defer resp.Body.Close()
	respData, err := ioutil.ReadAll(resp.Body)
	if err != nil {
		fmt.Print("Err")
	}
	fmt.Print(string(respData))

}