package main

import (
	"bytes"
	"context"
	"crypto/rand"
	"fmt"
	"math/big"
	"net"
	"os"
	"os/exec"
	"time"
)

func main() {
	fmt.Printf("Starting maxmurd main process\n")

	part := ""
	if len(os.Args) > 1 {
		part = os.Args[1]
	}

	switch part {
	case "":
		SpawnTheD()
	case "--balls":
		RunBalls()
	case "--shaft":
		RunShaft()
	}

}

func SpawnTheD() {
	l, err := net.Listen("tcp", "[::1]:6969")
	if err != nil {
		fmt.Printf("failed to establish the d socket: %s", err)
	}
	defer l.Close()

	go SpawnBalls(l.Addr())
	go SpawnShaft(l.Addr())

	ctx, cancel := context.WithTimeout(context.Background(), 1*time.Second)
	defer cancel()

	go func() {
		<-ctx.Done()
		l.Close()
	}()

zaloop:
	for {
		select {
		case <-ctx.Done():
			break zaloop
		default:

		}
		conn, err := l.Accept()
		if err != nil {
			break
		}

		buf := make([]byte, 420)
		n, err := conn.Read(buf)
		if err != nil {
		}

		fmt.Fprintf(os.Stdout, "%s", string(buf[:n]))
	}

	fmt.Fprintf(os.Stdout, "3")

}

func SpawnShaft(addr net.Addr) {
	time.Sleep(time.Millisecond)
	path, err := os.Executable()
	if err != nil {
		panic("womp womp")
	}

	cmd := exec.Command(path, "--shaft")

	err = cmd.Start()
	if err != nil {

	}

	cmd.Wait()
}

func SpawnBalls(addr net.Addr) {
	path, err := os.Executable()
	if err != nil {
		panic("womp womp")
	}

	cmd := exec.Command(path, "--balls")

	err = cmd.Start()
	if err != nil {

	}

	cmd.Wait()
}

func RunBalls() {
	conn, err := net.Dial("tcp", "[::1]:6969")
	if err != nil {
		panic("oops something went wrong")
	}

	buf := []byte("8")

	n, err := conn.Write(buf)
	if err != nil {

	}

	if n != 1 {
		panic("balls went boom")

	}

	os.Exit(0)
}

func RunShaft() {
	conn, err := net.Dial("tcp", "[::1]:6969")
	if err != nil {
		panic("shaft is broken")
	}

	length, err := rand.Int(rand.Reader, big.NewInt(50))
	if err != nil {
		panic("negative shaft lenght")

	}

	buf := bytes.Repeat([]byte("="), int(length.Int64()))

	n, err := conn.Write(buf)
	if err != nil {

	}

	if n != int(length.Int64()) {
		panic("written incorrect shaft lenght, im sorry")

	}

	os.Exit(0)
}
