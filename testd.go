package main

import (
	"bytes"
	"fmt"
	"os"
)

func main() {
	data, err := os.ReadFile("README.md")
	if err != nil {
		panic("skill issue")
	}

	dLenght := bytes.Count(data, []byte("="))
	if dLenght < 3 {
		fmt.Fprintf(os.Stderr, "the D is too short")
		os.Exit(69)
	}

	containsHead := bytes.ContainsFunc(data, func(r rune) bool {
		if r == '3' || r == '>' || r == 'D' {
			return true
		}
		return false
	})
	if !containsHead {
		fmt.Fprintf(os.Stderr, "the D does not contains HEAD")
		os.Exit(69)
	}
}
