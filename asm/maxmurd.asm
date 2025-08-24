org 0x7C00
use16

%define vga_buffer 0xb8000
%define vga_width  80
%define vga_height 25

entry:
    push vga_buffer / 16
    pop es

    mov cx, vga_width * vga_height * 2
    xor di, di
    xor al, al
    rep stosb

    xor di, di
    mov si, maxmurd
    call print
done:
    cli
    hlt
    jmp done

vga_line_sz: dw vga_width * 2

utf8_decode:
    mov al, byte [si]
    test al, 0x80
    jnz .do_utf8_decode
    inc si
    ret
    .do_utf8_decode:
        push di
        push es
        push ds
        pop es
        mov di, utf8_lut
        .lut_loop:
            push si
            mov cx, 3
            repe cmpsb
            pop si
            je .lut_loop_done
            inc di
            jmp .lut_loop
        .lut_loop_done:
        mov al, byte [di]
        pop es
        pop di
        add si, 3
        ret

print:
    .loop:
        call utf8_decode
        cmp al, 0x0A
        je .newline

        mov ah, 0xf
        stosw
        cmp al, 0
        jne .loop
    ret
    .newline:
        mov ax, di
        xor dx, dx
        div word [vga_line_sz]
        mov ax, word [vga_line_sz]
        sub ax, dx
        add di, ax
        jmp .loop

utf8_lut:
    db 0xE2, 0x95, 0x97,  0xBB
    db 0xE2, 0x95, 0x9D,  0xBC
    db 0xE2, 0x95, 0x9A,  0xC8
    db 0xE2, 0x95, 0x94,  0xC9

maxmurd:
    incbin "../README.md"
    db 0

times 510-($-$$) db 0

dw 0xAA55
