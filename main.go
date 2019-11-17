package main

import (
	"github.com/robertkrimen/otto"
)

func main() {
	vm := otto.New()
	vm.Run(`
		let abc = 2 + 2
		console.log(abc)
	`)
}
