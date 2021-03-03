package main

import (
	"fmt"
	"html/template"
	"os"
	"strings"
)

func main() {
	fmt.Println("loading include files...")
	tpl, err := template.ParseGlob("include/*")
	if err != nil {
		panic(fmt.Sprintf("couldn't load include files: %v", err))
	}

	for _, tpl := range tpl.Templates() {
		fmt.Printf("loaded %q\n", tpl.Name())
	}

	for _, tplPath := range os.Args[1:] {
		dstPath := strings.TrimSuffix(tplPath, ".tpl")

		fmt.Printf("loading template file %q\n", tplPath)
		if tpl, err = tpl.ParseFiles(tplPath); err != nil {
			panic(fmt.Sprintf("couldn't load template file: %v", err))
		}

		fmt.Printf("writing output file %q\n", dstPath)
		o, err := os.Create(dstPath)
		if err != nil {
			panic(fmt.Sprintf("couldn't open output file: %v", err))
		}
		defer o.Close()

		if err := tpl.ExecuteTemplate(o, tplPath, nil); err != nil {
			panic(fmt.Sprintf("couldn't execute template: %v", err))
		}
	}
}
