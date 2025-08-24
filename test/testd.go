package main_test

import (
	"bytes"
	"os"
	"testing"
)

func TestD(t *testing.T) {
	data, err := os.ReadFile("README.md")
	if err != nil {
		panic("skill issue")
	}

	dLenght := bytes.Count(data, []byte("="))
	if dLenght < 3 {
		t.Errorf("the D is too short, expected >= 3, got %d", dLenght)
		os.Exit(69)
	}

	containsHead := bytes.ContainsFunc(data, func(r rune) bool {
		if r == '3' || r == '>' || r == 'D' {
			return true
		}
		return false
	})
	if !containsHead {
		t.Errorf("the D does not contain HEAD")
		os.Exit(69)
	}
}
