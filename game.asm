[org 0x0100]
jmp main_start

ball_length:    dw 5
count_var:      dd 0
game_title:     db 'Ping Pong Game!!! WELCOME'
separator:      db '-------------------------'
creator_label:  db 'Creator:'
developer_name: db 'SAMAN AND NIMRAH  23F-0656-0734'
menu_label:     db 'Game Menu:'
player_controls: db 'Player 1 -> Left   Player 2 -> Right'
menu_opt1:      db '1. Pressing u will move the player upward.'
menu_opt2:      db '2. Pressing d will move the player downward.'
menu_opt3:      db '3. Whenever a player hits the ball, control transfers to the opponent.'
menu_opt4:      db '4. If the ball touches the left side of the screen, Player 2 Wins.'
menu_opt5:      db '5. If the ball touches the right side of the screen, Player 1 Wins.'
player1_wins:   db 'Player 1 Wins.'
player2_wins:   db 'Player 2 Wins.'
game_over_text: db 'GAME OVER!!!!'
score_label:    db 'Score: '
start_prompt:   db 'Press Enter to start...'
p1_score_label: db 'Player 1 Score: '
p2_score_label: db 'Player 2 Score: '
p1_score:       dw 0
p2_score:       dw 0
winning_player: dw 0

; Subroutine: Clear Screen
clear_screen:
    push es
    push ax
    push cx
    push di
    mov ax, 0xb800
    mov es, ax
    xor di, di
    mov cx, 2000
    mov ax, 0x0700
    cld
    rep stosw
    pop di
    pop cx
    pop ax
    pop es
    ret

; Subroutine: Print Center Line
draw_center_line:
    push bp
    mov bp, sp
    push ax
    push cx
    push di
    push es
    mov ax, 0xb800
    mov es, ax
    mov di, word [bp+4]
    mov ax, 0x0700
    mov cx, 25

center_line_loop:
    mov [es:di], ax
    add di, 160
    loop center_line_loop
    pop es
    pop di
    pop cx
    pop ax
    pop bp
    ret 2

; Subroutine: Draw Screen Borders
draw_borders:
    push bp
    mov bp, sp
    sub sp, 4
    mov word [bp-2], 0
    mov word [bp-4], 158
    push ax
    push di
    push es
    mov ax, 0xb800
    mov es, ax
    mov ax, 0x1700

vertical_border_loop:
    mov di, word [bp-2]
    mov [es:di], ax
    add word [bp-2], 160
    mov di, word [bp-4]
    mov [es:di], ax
    add word [bp-4], 160
    cmp word [bp-2], 4000
    jne vertical_border_loop

    pop es
    pop di
    pop cx
    pop ax
    mov sp, bp
    pop bp
    ret

; Check Collision: Right Side
check_right_collision:
    cmp dx, si
    je right_collision
    add dx, 160
    cmp dx, 4000
    jl check_right_collision
    ret

right_collision:
    mov word [winning_player], 1
    call end_game

; Check Collision: Left Side
check_left_collision:
    cmp dx, si
    je left_collision
    add dx, 160
    cmp dx, 4000
    jl check_left_collision
    ret

left_collision:
    mov word [winning_player], 2
    call end_game

; Subroutine: Move Ball Straight for Player 1
move_ball_straight_p1:
    push ax
    push si
    push dx
    mov ax, 0x0FDB
    mov si, word [bp-10]
    mov [es:si], ax
    add word [bp-10], 2
    mov si, word [bp-10]
    call check_p2_hits
    mov dx, 158
    call check_right_collision
    mov ax, 0x2700
    mov [es:si], ax
    pop dx
    pop si
    pop ax
    ret

; Subroutine: Move Ball Straight for Player 2
move_ball_straight_p2:
    push ax
    push si
    push dx
    mov ax, 0x0FDB
    mov si, word [bp-10]
    mov [es:si], ax
    sub word [bp-10], 2
    mov si, word [bp-10]
    call check_p1_hits
    mov dx, 0
    call check_left_collision
    mov ax, 0x2700
    mov [es:si], ax
    pop dx
    pop si
    pop ax
    ret

; Subroutine: Move Ball Diagonally Up for Player 1
move_ball_diag_up_p1:
    push ax
    push si
    push dx
    mov ax, 0x0FDB
    mov si, word [bp-10]
    mov [es:si], ax
    sub word [bp-10], 158
    mov si, word [bp-10]
    call check_p2_hits
    mov dx, 158
    call check_right_collision
    mov ax, 0x2700
    mov [es:si], ax
    pop dx
    pop si
    pop ax
    ret

; Subroutine: Move Ball Diagonally Up for Player 2
move_ball_diag_up_p2:
    push ax
    push si
    push dx
    mov ax, 0x0FDB
    mov si, word [bp-10]
    mov [es:si], ax
    sub word [bp-10], 162
    mov si, word [bp-10]
    call check_p1_hits
    mov dx, 0
    call check_left_collision
    mov ax, 0x2700
    mov [es:si], ax
    pop dx
    pop si
    pop ax
    ret

; Subroutine: Move Ball Diagonally Down for Player 1
move_ball_diag_down_p1:
    push ax
    push si
    push dx
    mov ax, 0x0FDB
    mov si, word [bp-10]
    mov [es:si], ax
    add word [bp-10], 162
    mov si, word [bp-10]
    call check_p2_hits
    mov dx, 158
    call check_right_collision
    mov ax, 0x2700
    mov [es:si], ax
    pop dx
    pop si
    pop ax
    ret

; Subroutine: Move Ball Diagonally Down for Player 2
move_ball_diag_down_p2:
    push ax
    push si
    push dx
    mov ax, 0x0FDB
    mov si, word [bp-10]
    mov [es:si], ax
    add word [bp-10], 158
    mov si, word [bp-10]
    call check_p1_hits
    mov dx, 0
    call check_left_collision
    mov ax, 0x2700
    mov [es:si], ax
    pop dx
    pop si
    pop ax
    ret

; Subroutine: Print Game Over Screen
end_game:
    call clear_screen
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 7

    mov dx, 0x0101
    mov cx, 16
    push cs
    pop es
    mov bp, p1_score_label
    int 0x10

    mov dx, 0x0201
    mov cx, 16
    push cs
    pop es
    mov bp, p2_score_label
    int 0x10

    mov dx, 0x0123
    push cs
    pop es
    mov cx, 14

    cmp word [winning_player], 1
    je p1_win
    jmp p2_win

p1_win:
    mov bp, player1_wins
    jmp print_winner

p2_win:
    mov bp, player2_wins

print_winner:
    int 0x10
    jmp print_scores

print_scores:
    mov dx, 196
    push dx
    mov dx, [p1_score]
    push dx
    call print_num

    mov dx, 356
    push dx
    mov dx, [p2_score]
    push dx
    call print_num

    mov dx, 0x0C23
    mov cx, 13
    push cs
    pop es
    mov bp, game_over_text
    int 0x10

    mov ax, 0x4c00
    int 0x21

; Subroutine: Print Numbers
print_num:
    push bp
    mov bp, sp
    push es
    push ax
    push bx
    push cx
    push dx
    push di

    mov ax, [bp+4]
    mov bx, 10
    mov cx, 0

next_digit:
    mov dx, 0
    div bx
    add dl, 0x30
    push dx
    inc cx
    cmp ax, 0
    jnz next_digit

    mov ax, 0xb800
    mov es, ax
    mov di, [bp+6]

next_pos:
    pop dx
    mov dh, 0x03
    mov [es:di], dx
    add di, 2
    loop next_pos

    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    pop bp
    ret 8

; Subroutine: Delay Movement
delay_movement:
    mov dword [count_var], 100000

inc_counter:
    dec dword [count_var]
    cmp dword [count_var], 0
    jne inc_counter
    ret

; Subroutine: Ping Pong Game
ping_pong_game:
    push bp
    mov bp, sp
    sub sp, 10
    mov word [bp-2], 2 ; First player
    mov word [bp-4], 156 ; Second Player
    mov word [bp-6], 0 ; Last Position of player 1
    mov word [bp-8], 0 ; Last Position of player 2
    mov word [bp-10], 644 ; Ball position
    push es
    push ax
    push bx
    push cx
    push dx
    push si
    push di
    mov ax, 0xb800
    mov es, ax

    mov si, word [bp-2] ; Load player 1 starting position
    mov di, word [bp-4] ; Load player 2 starting position
    mov cx, word [bp+4] ; Load player length
    mov ax, 0x2700

; Printing both players
print_players:
    mov [es:si], ax ; Player 1
    mov [es:di], ax ; Player 2
    mov word [bp-6], si
    mov word [bp-8], di
    add si, 160
    add di, 160
    loop print_players

    ; Printing ball
    mov si, word [bp-10]
    mov ax, 0x2700
    mov [es:si], ax

    ; Call ball movements here
    call ball_move_diag_down_1

; End Program
end_program:
    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    mov sp, bp
    pop bp
    ret 2

; Ball movement Diagonally Down when player 1 hits the ball
ball_move_diag_down_1:
    call move_ball_diag_down_p1
    call delay_movement
    add si, 162
    push ax
    mov ax, 80 ; Starting position of printing line between two players
    push ax
    call draw_center_line
    pop ax
    call input_p2
    cmp si, 4000
    jl ball_move_diag_down_1

ball_move_diag_up_1:
    call move_ball_diag_up_p1
    call delay_movement
    sub si, 158
    push ax
    mov ax, 80 ; Starting position of printing line between two players
    push ax
    call draw_center_line
    pop ax
    call input_p2
    cmp si, 0
    jg ball_move_diag_up_1
    jmp ball_move_diag_down_1

; Ball movement Diagonally Up when player 1 hits the ball
ball_move_diag_up_p1:
    call move_ball_diag_up_p1
    call delay_movement
    sub si, 158
    push ax
    mov ax, 80 ; Starting position of printing line between two players
    push ax
    call draw_center_line
    pop ax
    call input_p2
    cmp si, 0
    jg ball_move_diag_up_p1

ball_move_diag_down_p1:
    call move_ball_diag_down_p1
    call delay_movement
    add si, 162
    push ax
    mov ax, 80 ; Starting position of printing line between two players
    push ax
    call draw_center_line
    pop ax
    call input_p2
    cmp si, 4000
    jl ball_move_diag_down_p1
    jmp ball_move_diag_up_p1

; Ball movement Diagonally Up when player 2 hits the ball
ball_move_diag_up_p2:
    call move_ball_diag_up_p2
    call delay_movement
    sub si, 162
    push ax
    mov ax, 80 ; Starting position of printing line between two players
    push ax
    call draw_center_line
    pop ax
    call input_p1
    cmp si, 0
    jg ball_move_diag_up_p2

ball_move_diag_down_p2:
    call move_ball_diag_down_p2
    call delay_movement
    add si, 158
    push ax
    mov ax, 80 ; Starting position of printing line between two players
    push ax
    call draw_center_line
    pop ax
    call input_p1
    cmp si, 4000
    jl ball_move_diag_down_p2
    jmp ball_move_diag_up_p2

; Ball movement Straight when player 1 hits the ball
ball_move_straight_1:
    call move_ball_straight_p1
    call delay_movement
    add si, 2
    push ax
    mov ax, 80 ; Starting position of printing line between two players
    push ax
    call draw_center_line
    pop ax
    call input_p2
    jmp ball_move_straight_1

; Ball movement Straight when player 2 hits the ball
ball_move_straight_2:
    call move_ball_straight_p2
    call delay_movement
    sub si, 2
    push ax
    mov ax, 80 ; Starting position of printing line between two players
    push ax
    call draw_center_line
    pop ax
    call input_p1
    jmp ball_move_straight_2

; Ball movement Diagonally Down when player 2 hits the ball
ball_move_diag_down_2:
    call move_ball_diag_down_p2
    call delay_movement
    add si, 158
    push ax
    mov ax, 80 ; Starting position of printing line between two players
    push ax
    call draw_center_line
    pop ax
    call input_p1
    cmp si, 4000
    jl ball_move_diag_down_2

ball_move_diag_up_2:
    call move_ball_diag_up_p2
    call delay_movement
    sub si, 162
    push ax
    mov ax, 80 ; Starting position of printing line between two players
    push ax
    call draw_center_line
    pop ax
    call input_p1
    cmp si, 0
    jg ball_move_diag_up_2
    jmp ball_move_diag_down_2

; Checking if player 2 hits the ball
check_p2_hits:
    push bx
    push si

    mov bx, word [bp-4]
    cmp si, bx
    jne second_p2
    inc word [p2_score]
    push ax
    mov ax, 0x2700
    mov [es:si], ax
    pop ax
    sub word [bp-10], 2
    jmp ball_move_diag_up_p2

second_p2:
    add bx, 160
    cmp si, bx
    jne third_p2
    inc word [p2_score]
    push ax
    mov ax, 0x2700
    mov [es:si], ax
    pop ax
    sub word [bp-10], 2
    jmp ball_move_diag_up_p2

third_p2:
    add bx, 160
    cmp si, bx
    jne forth_p2
    inc word [p2_score]
    push ax
    mov ax, 0x2700
    mov [es:si], ax
    pop ax
    sub word [bp-10], 2
    jmp ball_move_straight_2

forth_p2:
    add bx, 160
    cmp si, bx
    jne fifth_p2
    inc word [p2_score]
    push ax
    mov ax, 0x2700
    mov [es:si], ax
    pop ax
    sub word [bp-10], 2
    jmp ball_move_diag_down_2

fifth_p2:
    add bx, 160
    cmp si, bx
    jne hit_p2_exit
    inc word [p2_score]
    push ax
    mov ax, 0x2700
    mov [es:si], ax
    pop ax
    sub word [bp-10], 2
    jmp ball_move_diag_down_2

hit_p2_exit:
    pop si
    pop bx
    ret

; Checking if player 1 hits the ball
check_p1_hits:
    push bx
    push si

    mov bx, word [bp-2]
    cmp si, bx
    jne second_p1
    inc word [p1_score]
    push ax
    mov ax, 0x2700
    mov [es:si], ax
    pop ax
    add word [bp-10], 2
    jmp ball_move_diag_up_p1

second_p1:
    add bx, 160
    cmp si, bx
    jne third_p1
    inc word [p1_score]
    push ax
    mov ax, 0x2700
    mov [es:si], ax
    pop ax
    add word [bp-10], 2
    jmp ball_move_diag_up_p1

third_p1:
    add bx, 160
    cmp si, bx
    jne forth_p1
    inc word [p1_score]
    push ax
    mov ax, 0x2700
    mov [es:si], ax
    pop ax
    add word [bp-10], 2
    jmp ball_move_straight_1

forth_p1:
    add bx, 160
    cmp si, bx
    jne fifth_p1
    inc word [p1_score]
    push ax
    mov ax, 0x2700
    mov [es:si], ax
    pop ax
    add word [bp-10], 2
    jmp ball_move_diag_down_1

fifth_p1:
    add bx, 160
    cmp si, bx
    jne hit_p1_exit
    inc word [p1_score]
    push ax
    mov ax, 0x2700
    mov [es:si], ax
    pop ax
    add word [bp-10], 2
    jmp ball_move_diag_down_1

hit_p1_exit:
    pop si
    pop bx
    ret

; Movement of player 1 Downward
move_p1_down:
    push ax
    push si

    mov si, word [bp-6]
    add si, 160
    cmp si, 4000
    jg exit_p1_down
    add word [bp-6], 160
    mov ax, 0x2700
    mov [es:si], ax
    mov si, word [bp-2]
    mov ax, 0x0FDB
    mov [es:si], ax
    add word [bp-2], 160

exit_p1_down:
    pop si
    pop ax
    ret

; Movement of player 1 Upward
move_p1_up:
    push ax
    push si

    mov si, word [bp-2]
    sub si, 160
    cmp si, 0
    jl exit_p1_up
    sub word [bp-2], 160
    mov ax, 0x2700
    mov [es:si], ax
    mov si, word [bp-6]
    mov ax, 0x0FDB
    mov [es:si], ax
    sub word [bp-6], 160

exit_p1_up:
    pop si
    pop ax
    ret

; Movement of player 2 Downward
move_p2_down:
    push es
    push ax
    push si

    mov ax, 0xb800
    mov es, ax

    mov si, word [bp-8]
    add si, 160
    cmp si, 4000
    jg exit_p2_down
    add word [bp-8], 160
    mov ax, 0x2700
    mov [es:si], ax
    mov si, word [bp-4]
    mov ax, 0x0FDB
    mov [es:si], ax
    add word [bp-4], 160

exit_p2_down:
    pop si
    pop ax
    pop es
    ret

; Movement of player 2 Upward
move_p2_up:
    push ax
    push si

    mov si, word [bp-4]
    sub si, 160
    cmp si, 0
    jl exit_p2_up
    sub word [bp-4], 160
    mov ax, 0x2700
    mov [es:si], ax
    mov si, word [bp-8]
    mov ax, 0x0FDB
    mov [es:si], ax
    sub word [bp-8], 160

exit_p2_up:
    pop si
    pop ax
    ret

; Taking input from player 1 controls
input_p1:
    mov ah, 1
    int 0x16
    jz exit_input_p1

    mov ah, 0
    int 0x16

    cmp al, 'u'
    je move_p1_up
    cmp al, 'd'
    je move_p1_down

    cmp ah, 01
    je end_game

exit_input_p1:
    ret

; Taking input from player 2 controls
input_p2:
    mov ah, 1
    int 0x16
    jz exit_input_p2

    mov ah, 0
    int 0x16

    cmp al, 'u'
    je move_p2_up
    cmp al, 'd'
    je move_p2_down

    cmp ah, 01
    je end_game

exit_input_p2:
    ret

; Welcome screen
intro_screen:
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 7
    mov dx, 0x0A19
    mov cx, 25
    push cs
    pop es
    mov bp, game_title
    int 0x10

    mov dx, 0x0B19
    mov cx, 25
    push cs
    pop es
    mov bp, separator
    int 0x10

    mov dx, 0x1801
    mov cx, 8
    push cs
    pop es
    mov bp, creator_label
    int 0x10

    mov dx, 0x180A
    mov cx, 31
    push cs
    pop es
    mov bp, developer_name
    int 0x10

    mov ah, 01
    int 0x21
    ret

; Displaying Game Menu/Instructions
display_game_menu:
    mov ah, 0x13
    mov al, 1
    mov bh, 0
    mov bl, 7
    mov dx, 0x0101
    mov cx, 10
    push cs
    pop es
    mov bp, menu_label
    int 0x10

    mov dx, 0x0301
    mov cx, 36
    push cs
    pop es
    mov bp, player_controls
    int 0x10

    mov dx, 0x0501
    mov cx, 41
    push cs
    pop es
    mov bp, menu_opt1
    int 0x10

    mov dx, 0x0601
    mov cx, 43
    push cs
    pop es
    mov bp, menu_opt2
    int 0x10

    mov dx, 0x0701
    mov cx, 70
    push cs
    pop es
    mov bp, menu_opt3
    int 0x10

    mov dx, 0x0801
    mov cx, 61
    push cs
    pop es
    mov bp, menu_opt4
    int 0x10

    mov dx, 0x0901
    mov cx, 62
    push cs
    pop es
    mov bp, menu_opt5
    int 0x10

    mov dx, 0x1801
    mov cx, 23
    push cs
    pop es
    mov bp, start_prompt
    int 0x10

    mov ah, 01
    int 0x21
    ret

main_start:
    call clear_screen
    call intro_screen
    call clear_screen

    call display_game_menu
    call clear_screen

    call draw_borders

    mov ax, 80 ; Starting position of printing line between two players
    push ax
    call draw_center_line

    push word [ball_length]
    call ping_pong_game

    mov ax, 0x4c00 ; terminate program
    int 0x21