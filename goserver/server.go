package main

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"strconv"

	"github.com/gorilla/mux"
)

// Port number
const Port = ":5500"

func main() {
	router := mux.NewRouter()
	router.HandleFunc("/", rootPage)
	router.HandleFunc("/products/{fetchCountPercentage}", products).Methods("GET")
	fmt.Println("Serving @ http://127.0.0.1" + Port)
	log.Fatal(http.ListenAndServe(Port, router))
}

func rootPage(w http.ResponseWriter, r *http.Request) {
	w.Write([]byte("This is root page"))
}

func products(w http.ResponseWriter, r *http.Request) {
	fetchCountPercentage, errInput := strconv.ParseFloat(mux.Vars(r)["fetchCountPercentage"], 64)
	fetchCount := 0
	if errInput != nil {
		fmt.Println(errInput.Error())
	} else {
		productListLen := len(productList)
		fetchCount = int(float64(productListLen) * fetchCountPercentage / 100)
		if fetchCount > productListLen {
			fetchCount = productListLen
		}
	}
	jsonList, err := json.Marshal(productList[0:fetchCount])
	if err != nil {
		http.Error(w, err.Error(), http.StatusInternalServerError)
	} else {
		w.Header().Set("content-type", "application/json")
		w.Write(jsonList)

	}
}

type product struct {
	Name  string
	Price float64
	Count int
}

var productList = []product{
	{"p1", 25.0, 30},
	{"p2", 20.0, 10},
	{"p3", 250.0, 20},
	{"p4", 256.0, 15},
	{"p5", 10.0, 250},
	{"p6", 175.0, 130},
}
