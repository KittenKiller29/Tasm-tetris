.model small
.386
.data
    specstr db '0000000$',10,13
    tetris db 'tetris 94$',10,13
    nextstr db 'next$',10,13
    linestr db 'lines:$',10,13
    scorectr db 'score:$',10,13
    newgamestr db 'q-new game$',10,13
    exitstr db 'e-exit$',10,13
    menustr db 'menu$',10,13
    gamepaused db 'game paused$',10,13
    special_ind dw 0
    contstr db 'q-continue$',10,13
    linenum db 0
    counter db 0
    bucket dd 400 DUP(0)
    figure dd 8 dup(0)
    line dd 20 dup(0)
    figurecords db 0,0,0,0,0,0,0,0
    block1 dd 6*320+115+36
    block2 dd -3*320+115+36
    block3 dd -3*320+115+45
    block4 dd -12*320+115+36
    block5 dd 6*320+115+45
    block6 dd -12*320+115+45
    block7 dd -21*320+115+45
    godown dw ?
    create db 0
    activenow db 0
    gamemode db 0
    sost db 0
    tmp dw 0
    skip db 0
    linecount dw 0
    scorecount dw 0
    seetmp db 0
    createnext db 0
    lvlup dw 2
    speed db 25
    figuretmp dd 4 dup(0)
    figurecordstmp db 8 dup(0)
.stack 100h
.code
org 100h   
drawbucket proc near
    xor eax,eax
    xor edx,edx
    xor ebx,ebx
    xor esi,esi
    xor edi,edi
   ; mov bh,0
    ;mov ax,13h; устанавливаем режим 640х350х16 цветов
    ;int 10h
    push 0A000h; ES=0A000h начало видеопамяти в графических режимах
    pop es
    mov di,5*320+114; начало линий в точке Х=5 Y=5
    mov ax,0Fh; цвет линий
    mov cx,92
    rep stosb; выводим горизонтальную линию
    mov di,5*320+114
    mov cx,181
a1: stosb; рисуем вертикальную линию
    add di,319
    loop a1
    mov cx,92
a2: ;stosb линия горизонтальная 2 189-190
    stosb
    loop a2
    mov di,5*320+113
    mov cx,181
    add di,92
a3: stosb; линия вертикальная 2
    add di,319
    loop a3
ret
drawbucket endp

drawblock proc near
    mov si,0
    point:
        xor edi,edi
        xor edx,edx
        mov edx,bucket[si]
        cmp edx,0
        jz short itterationcheck
        mov edi,edx
        mov ebx,9     
    drawline:
        mov eax,bucket[si+4]
        mov cx,9
        rep stosb
        add edi,311
        dec ebx
        cmp ebx,0
        jnz drawline
    itterationcheck:
        add si,8
        cmp si,1600
        jnz point
        xor si,si
        xor edi,edi
        xor eax,eax
        xor edx,edx
        xor ebx,ebx
        ret
drawblock endp

createfigure proc near
    xor eax,eax
    xor ebx,ebx
    xor si,si
    xor di,di
    xor edx,edx
    mov si,0
    mov al,0
    cmp al,activenow
    jz short randnum
    ret
    randnum:
        mov sost,0
        add al,1
        mov activenow,al
        xor eax,eax
        in eax,40h
        mov bx,7
        div bx
        mov create,dl
        mov bl,createnext
        mov createnext,dl
        mov dl,bl
        mov create,dl
        inc dx
        mov figure[si+4],edx
        mov figure[si+12],edx
        mov figure[si+20],edx
        mov figure[si+28],edx
        dec dx
        mov bl,0
        mov figurecords[si],bl
        mov figurecords[si+1],bl
        mov figurecords[si+2],bl
        mov figurecords[si+3],bl
        mov figurecords[si+4],bl
        mov figurecords[si+5],bl
        mov figurecords[si+6],bl
        mov figurecords[si+7],bl
        call drawnext
        cmp dx,0
        jz short create_a1
        cmp dx,1
        jz short create_a2
        cmp dx,2
        jz create_a3
        cmp dx,3
        jz create_a4
        cmp dx,4
        jz create_a5
        cmp dx,5
        jz create_a6
        cmp dx,6
        jz create_a7
    create_a1:
        mov edx,block5
        mov figure[si],edx
        mov edx,block1
        mov figure[si+8],edx
        mov edx,block2
        mov figure[si+16],edx
        mov edx,block4
        mov figure[si+24],edx
        mov dl,5
        mov figurecords[si],dl
        dec dl
        mov figurecords[si+2],dl
        mov figurecords[si+4],dl
        mov figurecords[si+6],dl
        mov dl,-1
        mov figurecords[si+5],dl
        mov dl,-2
        mov figurecords[si+7],dl
        ret
    create_a2:
        mov edx,block5
        mov figure[si],edx
        mov edx,block1
        mov figure[si+8],edx
        mov edx,block2
        mov figure[si+16],edx
        mov edx,block3
        mov figure[si+24],edx
        mov dl,5
        mov figurecords[si],dl
        mov figurecords[si+6],dl
        mov dl,4
        mov figurecords[si+2],dl
        mov figurecords[si+4],dl
        mov dl,-1
        mov figurecords[si+5],dl
        mov figurecords[si+7],dl
        ret
    create_a3:
        mov edx,block5
        mov figure[si],edx
        mov edx,block3
        mov figure[si+8],edx
        mov edx,block2
        mov figure[si+16],edx
        mov edx,block4
        mov figure[si+24],edx
        mov dl,5
        mov figurecords[si],dl
        mov figurecords[si+2],dl
        dec dl
        mov figurecords[si+4],dl
        mov figurecords[si+6],dl
        mov dl,-1
        mov figurecords[si+3],dl
        mov figurecords[si+5],dl
        mov dl,-2
        mov figurecords[si+7],dl
        ret
    create_a4:
        mov edx,block1
        mov figure[si],edx
        mov edx,block2
        mov figure[si+8],edx
        mov edx,block3
        mov figure[si+16],edx
        mov edx,block6
        mov figure[si+24],edx
        mov dl,4
        mov figurecords[si],dl
        mov figurecords[si+2],dl
        inc dl
        mov figurecords[si+4],dl
        mov figurecords[si+6],dl
        mov dl,-1
        mov figurecords[si+3],dl
        mov figurecords[si+5],dl
        mov dl,-2
        mov figurecords[si+7],dl
        ret
    create_a5:
        mov edx,block5
        mov figure[si],edx
        mov edx,block1
        mov figure[si+8],edx
        mov edx,block3
        mov figure[si+16],edx
        mov edx,block6
        mov figure[si+24],edx
        mov dl,4
        mov figurecords[si+2],dl
        inc dl
        mov figurecords[si],dl
        mov figurecords[si+4],dl
        mov figurecords[si+6],dl
        mov dl,-1
        mov figurecords[si+5],dl
        mov dl,-2
        mov figurecords[si+7],dl
        ret
    create_a6:
        mov edx,block5
        mov figure[si],edx
        mov edx,block3
        mov figure[si+8],edx
        mov edx,block2
        mov figure[si+16],edx
        mov edx,block6
        mov figure[si+24],edx
        mov dl,5
        mov figurecords[si],dl
        mov figurecords[si+2],dl
        mov figurecords[si+6],dl
        dec dl
        mov figurecords[si+4],dl
        mov dl,-1
        mov figurecords[si+3],dl
        mov figurecords[si+5],dl
        dec dl
        mov figurecords[si+7],dl
        mov edx,14
        mov figure[si+4],edx
        mov figure[si+12],edx
        mov figure[si+20],edx
        mov figure[si+28],edx
        ret
    create_a7:
        mov edx,block5
        mov figure[si],edx
        mov edx,block3
        mov figure[si+8],edx
        mov edx,block6
        mov figure[si+16],edx
        mov edx,block7
        mov figure[si+24],edx
        mov dl,5
        mov figurecords[si],dl
        mov figurecords[si+2],dl
        mov figurecords[si+4],dl
        mov figurecords[si+6],dl
        mov dl,0
        mov figurecords[si+1],dl
        dec dl
        mov figurecords[si+3],dl
        dec dl
        mov figurecords[si+5],dl
        dec dl
        mov figurecords[si+7],dl
        mov edx,12
        mov figure[si+4],edx
        mov figure[si+12],edx
        mov figure[si+20],edx
        mov figure[si+28],edx
        ret
    
createfigure endp

updateactive proc near
    mov si,0
    xor ax,ax
    mov ah,01h
    int 16h
    jz down
    mov ah,0h
    int 16h
    cmp ah,01h
    jnz short dgo
    call gamepause
    dgo:
    cmp ah,39h
    jnz short aaw
    call swap_check
    aaw:
    cmp ah,1Eh
    je move_l
    cmp ah,20h
    je short move_r
    jmp down
    move_r: 
       cmp figurecords[si],9
       jz down
       cmp figurecords[si+2],9
       jz down
       cmp figurecords[si+4],9
       jz down
       cmp figurecords[si+6],9
       jz down
       mov bx,4
       mov eax,figure[si]
       add eax,9
       mov cx,200
       mov di,0
        blockcheck2_:
          cmp eax,bucket[si]
          je down
          add si,8
          loop blockcheck2_
       itnum2_:
           add di,8
           mov si,di
           mov cx,200
           mov eax,figure[si]
           add eax,9
           mov si,0
           dec bx
           cmp bx,0
           jne blockcheck2_
       call redraw_active
       mov si,0
       mov edx,9
       add figure[si],edx
       add figure[si+8],edx
       add figure[si+16],edx
       add figure[si+24],edx
       mov dl,1
       add figurecords[si],dl
       add figurecords[si+2],dl
       add figurecords[si+4],dl
       add figurecords[si+6],dl
       jmp down
    move_l:
        cmp figurecords[si],0
        jz down
        cmp figurecords[si+2],0
        jz short down
        cmp figurecords[si+4],0
        jz short down
        cmp figurecords[si+6],0
        jz short down
        mov bx,4
        mov eax,figure[si]
        sub eax,9
        mov cx,200
        mov di,0
         blockcheck1_:
           cmp eax,bucket[si]
           je short down
           add si,8
           loop blockcheck1_
        itnum1_:
            add di,8
            mov si,di
            mov cx,200
            mov eax,figure[si]
            mov si,0
            sub eax,9
            dec bx
            cmp bx,0
            jne blockcheck1_
        call redraw_active
        mov si,0
        mov edx,9
        sub figure[si],edx
        sub figure[si+8],edx
        sub figure[si+16],edx
        sub figure[si+24],edx
        mov dl,1
        sub figurecords[si],dl
        sub figurecords[si+2],dl
        sub figurecords[si+4],dl
        sub figurecords[si+6],dl
        jmp short down
    down:
       cmp ah,1Fh
       je short a
       xor bx,bx
       mov bl,speed
       cmp godown,bx
       jl  goout_
       a:
       mov godown,0
       xor ah,ah
       mov activenow,0
       mov gamemode,1
       cmp figurecords[si+1],19
       jz goout_
       cmp figurecords[si+3],19
       jz goout_
        cmp figurecords[si+5],19
       jz goout_
        cmp figurecords[si+7],19
       jz goout_
       mov bx,4
       mov eax,figure[si]
       add eax,2880
       mov cx,200
       mov di,0
       blockcheck_:
           cmp eax,bucket[si]
           je short goout_
           add si,8
           loop blockcheck_
        itnum_:
            add di,8
            mov si,di
            mov cx,200
            mov eax,figure[si]
            mov si,0
            add eax,2880
            dec bx
            cmp bx,0
            jne blockcheck_
       mov si,0
       mov di,0
       call redraw_active
       mov si,0
       add figure[si],2880
       add figure[si+8],2880
       add figure[si+16],2880
       add figure[si+24],2880
       mov dl,1
       add figurecords[si+1],dl
       add figurecords[si+3],dl
       add figurecords[si+5],dl
       add figurecords[si+7],dl
       mov activenow,1
       mov gamemode,0
    goout_:
        mov si,0
        ret

updateactive endp

swapos proc near
    mov si,0
    mov al,sost
    cmp create,0
    jz short swapos_1
     cmp create,1
    jz swapos_2
     cmp create,2
    jz swapos_3
     cmp create,3
    jz swapos_4
     cmp create,4
    jz swapos_5
     cmp create,5
    jz swapos_6
     cmp create,6
    jz swapos_7
 swapos_1:
    cmp al,0
    jz f1s4
    cmp al,1
    jz f1s3
    cmp al,2
    jz short f1s2
    cmp al,3
    jz short f1s1
    f1s1:
    add figurecords[si+1],1
    add figurecords[si+6],1
    sub figurecords[si+2],1
    sub figurecords[si+5],1
    sub figurecords[si+7],1
    sub figurecords[si+7],1
    add figure[si],2880
    sub figure[si+8],9
    sub figure[si+16],2880
    add figure[si+24],9
    sub figure[si+24],2880
    sub figure[si+24],2880
    jmp addsost
    f1s2:
    add figurecords[si],1
    add figurecords[si+1],1
    add figurecords[si+3],1
    add figurecords[si+3],1
    sub figurecords[si+4],1
    add figurecords[si+5],1
    sub figurecords[si+6],2
    add figure[si],2889
    add figure[si+8],5760
    sub figure[si+16],9
    add figure[si+16],2880
    sub figure[si+24],18
    jmp addsost
    f1s3:
    add figurecords[si],1
    sub figurecords[si+1],2
    add figurecords[si+2],2
    sub figurecords[si+3],1
    add figurecords[si+4],1
    add figurecords[si+7],1
    add figure[si],9
    sub figure[si],5760
    sub figure[si+8],2880
    add figure[si+8],18
    add figure[si+16],9
    add figure[si+24],2880
    jmp addsost
    f1s4:
    sub figurecords[si],2
    sub figurecords[si+2],1
    sub figurecords[si+3],1
    add figurecords[si+6],1
    add figurecords[si+7],1
    sub figure[si],18
    sub figure[si+8],2889
    add figure[si+24],2889
    jmp addsost
    swapos_2:
        jmp addsost
    swapos_3:
    cmp al,0
    jz short f3s1
    cmp al,1
    jz short f3s2
    cmp al,2
    jz short f3s1
    cmp al,3
    jz short f3s2
    f3s1:
    sub figurecords[si],2
    sub figurecords[si+2],1
    add figurecords[si+3],1
    add figurecords[si+6],1
    add figurecords[si+7],1
    sub figure[si],18
    add figure[si+8],2871
    add figure[si+24],2889
    jmp addsost
    f3s2:
    add figurecords[si],2
    add figurecords[si+2],1
    sub figurecords[si+3],1
    sub figurecords[si+6],1
    sub figurecords[si+7],1
    add figure[si],18
    sub figure[si+8],2871
    sub figure[si+24],2889
    jmp addsost
    swapos_4:
    cmp al,0
    jz short f4s1
    cmp al,1
    jz short f4s2
    cmp al,2
    jz short f4s1
    cmp al,3
    jz short f4s2
    f4s1:
    add figurecords[si],2
    add figurecords[si+2],1
    add figurecords[si+3],1
    sub figurecords[si+6],1
    add figurecords[si+7],1
    add figure[si],18
    add figure[si+8],2889
    add figure[si+24],2871
    jmp addsost
    f4s2:
    sub figurecords[si],2
    sub figurecords[si+2],1
    sub figurecords[si+3],1
    add figurecords[si+6],1
    sub figurecords[si+7],1
    sub figure[si],18
    sub figure[si+8],2889
    sub figure[si+24],2871
    jmp addsost
    swapos_5:
    cmp al,0
    jz short f5s1
    cmp al,1
    jz short f5s2
    cmp al,2
    jz f5s3
    cmp al,3
    jz f5s4
    f5s1:
    sub figurecords[si+3],1
    sub figurecords[si],1
    add figurecords[si+5],1
    add figurecords[si+6],1
    add figurecords[si+7],2
    sub figure[si+8],2880
    sub figure[si],9
    add figure[si+16],2880
    add figure[si+24],5769
    jmp addsost
    f5s2:
    sub figurecords[si+1],2
    add figurecords[si+2],1
    sub figurecords[si+3],1
    sub figurecords[si+4],1
    sub figurecords[si+5],1
    sub figurecords[si+6],2
    sub figure[si],5760
    sub figure[si+8],2871
    sub figure[si+16],2889
    sub figure[si+24],18
    jmp addsost
    f5s3:
    add figurecords[si],2
    add figurecords[si+1],1
    add figurecords[si+2],1
    add figurecords[si+3],2
    add figurecords[si+4],1
    sub figurecords[si+7],1
    add figure[si],2898
    add figure[si+8],5769
    add figure[si+16],9
    sub figure[si+24],2880
    jmp addsost
    f5s4:
    sub figurecords[si],1
    add figurecords[si+1],1
    sub figurecords[si+2],2
    add figurecords[si+6],1
    sub figurecords[si+7],1
    add figure[si],2871
    sub figure[si+8],18
    sub figure[si+24],2871
    jmp addsost
    swapos_6:
    cmp al,0
    jz short f6s1
    cmp al,1
    jz short f6s2
    cmp al,2
    jz short f6s3
    cmp al,3
    jz short f6s4
    f6s1:
    add figurecords[si+5],1
    add figurecords[si+6],1
    add figurecords[si+7],2
    add figure[si+16],2880
    add figure[si+24],5769
    jmp addsost
    f6s2:
    add figurecords[si+4],1
    sub figurecords[si+5],2
    sub figurecords[si+7],1
    sub figure[si+16],5751
    sub figure[si+24],2880
    jmp addsost
    f6s3:
    sub figurecords[si+4],1
    add figurecords[si+5],1
    add figure[si+16],2871
    jmp addsost
    f6s4:
    sub figurecords[si+6],1
    sub figurecords[si+7],1
    sub figure[si+24],2889
    jmp addsost
    swapos_7:
    cmp al,0
    jz short f7s1
    cmp al,1
    jz short f7s2
    cmp al,2
    jz short f7s1
    cmp al,3
    jz short f7s2
    f7s1:
    sub figurecords[si+2],1
    add figurecords[si+3],1
    sub figurecords[si+4],2
    add figurecords[si+5],2
    add figurecords[si+6],1
    add figurecords[si+7],3
    add figure[si+8],2871
    add figure[si+16],5742
    add figure[si+24],8649
    jmp short addsost
    f7s2:
    add figurecords[si+2],1
    sub figurecords[si+3],1
    add figurecords[si+4],2
    sub figurecords[si+5],2
    sub figurecords[si+6],1
    sub figurecords[si+7],3
    sub figure[si+8],2871
    sub figure[si+16],5742
    sub figure[si+24],8649
    jmp short addsost
     addsost:
        inc al
        cmp al,4
        jnz short updatesost
        mov al,0
     updatesost:   
            xor edx,edx
            xor ebx,ebx
            mov sost,al
            xor si,si
            mov al,2
            mov ah,0Ch
            int 21h
            xor al,al
            ret
swapos endp

drawactive proc near
    mov si,0
    checkdraw:
        mov bx,9
        mov eax,figure[si+4]
        mov edi,figure[si]
        cmp edi,6*320+115
        jl short nextitteration
    drawblockactive:
        mov cx,9
        rep stosb
        add edi,311
        dec ebx
        cmp ebx,0
        jnz short drawblockactive
    nextitteration:
        add si,8
        cmp si,32
        jnz short checkdraw
    clean:
        xor eax,eax
     ret
     
drawactive endp

update_bucket proc near
     mov ax,0
     mov bx,180
     mov di,6*320+115
     make_black:
        mov cx,90
        rep stosb
        sub di,90
        add di,320
        dec bx
        cmp bx,0
        jnz make_black

update_bucket endp

timer_up proc near
    mov ah,00h
    int 1Ah
    cmp skip,1
    jz short gg
    cmp dx,tmp
    jl short correct
    jmp short cont
    correct:
      mov tmp,dx
    cont:
     sub dx,tmp
     add godown,dx
     add dx,tmp
     mov tmp,dx
    gg:
     mov tmp,dx
     mov skip,0
     ret
timer_up endp

redraw_active proc near
     mov si,0
    drawcheck:
        mov bx,9
        mov eax,0
        mov edi,figure[si]
        cmp edi,6*320+115
        jl short itterationnext
    blockactivedraw:
        mov cx,9
        rep stosb
        add edi,311
        dec ebx
        cmp ebx,0
        jnz short blockactivedraw
    itterationnext:
        add si,8
        cmp si,32
        jnz short drawcheck
    clean_:
        xor eax,eax
     ret
redraw_active endp

window_update proc near
    xor si,si
    xor cx,cx
    mov dx,20000
    mov ah,86h
    int 15h
    xor dx,dx
    xor dx,dx
    ret
window_update endp

check_save proc near
    mov al,1
    xor si,si
    cmp gamemode,al
    jnz dontsave
    mov gamemode,0
    xor ax,ax
    mov skip,1
    saveprep:
       call redraw_active
       call window_update
       call window_update
       call window_update
    gameover_check:
       mov dl,0
       cmp figurecords[si+1],dl
       jle exit_
       cmp figurecords[si+3],dl
       jle exit_
       cmp figurecords[si+5],dl
       jle exit_
       cmp figurecords[si+7],dl
       jle exit_
       xor si,si
       mov ebx,figure[si]
       mov ecx,figure[si+4]
       mov dl,10
       mov al,figurecords[si+1]
       mul dl
       add al,figurecords[si]
       mov dl,8
       mul dl
       mov si,ax
       mov bucket[si],ebx
       mov bucket[si+4],ecx
       xor si,si
       mov ebx,figure[si+8]
        mov ecx,figure[si+12]
       mov dl,10
       mov al,figurecords[si+3]
       mul dl
       add al,figurecords[si+2]
       mov dl,8
       mul dl
       mov si,ax
       mov bucket[si],ebx
       mov bucket[si+4],ecx
       xor si,si
       mov ebx,figure[si+16]
        mov ecx,figure[si+20]
       mov dl,10
       mov al,figurecords[si+5]
       mul dl
       add al,figurecords[si+4]
       mov dl,8
       mul dl
       mov si,ax
       mov bucket[si],ebx
       mov bucket[si+4],ecx
       xor si,si
       mov ebx,figure[si+24]
        mov ecx,figure[si+28]
       mov dl,10
       mov al,figurecords[si+7]
       mul dl
       add al,figurecords[si+6]
       mov dl,8
       mul dl
       mov si,ax
       mov bucket[si],ebx
       mov bucket[si+4],ecx
       call drawactive
       add scorecount,4
       call drawscorecount
        mov al,2
        mov ah,0Ch
        int 21h
    dontsave:
        xor ebx,ebx
        xor ecx,ecx
        xor eax,eax
        xor esi,esi
        xor edi,edi
        xor edx,edx
        ret
    exit_:
        call drawactive
        call window_update
        call window_update
        call window_update
        call window_update
        call window_update
        call window_update
        call window_update
        call window_update
        call window_update
        call window_update
        call window_update
        call window_update
        call window_update
        call window_update
        call window_update
        call window_update
        call gameover_bucket
        mov al,2
        mov ah,0Ch
        int 21h
        mov gamemode,2
        ret
check_save endp

draw_line proc near
     mov si,0
    checkdrawline:
        mov bx,9
        mov eax,0
        mov edi,line[si]
        cmp edi,6*320+115
        jl short nextitteration__
    drawline_:
        mov cx,9
        rep stosb
        add edi,311
        dec ebx
        cmp ebx,0
        jnz short drawline_
    nextitteration__:
        add si,8
        cmp si,80
        jnz short checkdrawline
    clean__:
        xor eax,eax
        xor si,si
     ret
draw_line endp

delete_line proc near
    mov si,0
    mov di,0
    mov linenum,0
    mov line[si],6*320+115
    mov line[si+8],6*320+124
    mov line[si+16],6*320+133
    mov line[si+24],6*320+142
    mov line[si+32],6*320+151
    mov line[si+40],6*320+160
    mov line[si+48],6*320+169
    mov line[si+56],6*320+178
    mov line[si+64],6*320+187
    mov line[si+72],6*320+196
    mov special_ind,0
    mov dx,20
    mov cx,10
    linechecker:
        mov eax,line[si]
        add si,special_ind
        cmp eax,bucket[si]
        jnz short nextline
        sub si,special_ind
        add si,8
        loop linechecker
        call draw_line
        mov linenum,1
    nextline:
         mov si,0
         add line[si],2880
         add line[si+8],2880
         add line[si+16],2880
         add line[si+24],2880
         add line[si+32],2880
         add line[si+40],2880
         add line[si+48],2880
         add line[si+56],2880
         add line[si+64],2880
         add line[si+72],2880
         xor eax,eax
         mov ax,80
         add special_ind,ax
         mov cx,10
         dec dx
         jnz linechecker
    checkend:
        xor ebx,ebx
        xor di,di
        xor si,si
        xor edx,edx
        xor ecx,ecx
        xor eax,eax
        ret
delete_line endp

lvl_up proc near
    mov ax,lvlup
    cmp ax,linecount
    jnz short dlu
    add lvlup,2
    cmp speed,3
    jz short dlu
    sub speed,2

    dlu:
        ret
lvl_up endp

delete_lines_in_bucket proc near
    mov si,0
    mov di,0
    mov linenum,0
    mov line[si],6*320+115
    mov line[si+8],6*320+124
    mov line[si+16],6*320+133
    mov line[si+24],6*320+142
    mov line[si+32],6*320+151
    mov line[si+40],6*320+160
    mov line[si+48],6*320+169
    mov line[si+56],6*320+178
    mov line[si+64],6*320+187
    mov line[si+72],6*320+196
    mov special_ind,0
    mov dx,20
    mov cx,10
    linechecker_:
        mov eax,line[si]
        add si,special_ind
        cmp eax,bucket[si]
        jnz nextline_
        sub si,special_ind
        add si,8
        loop linechecker_
        mov si,0
        add si,special_ind
        mov bucket[si],0
        mov bucket[si+4],0
        mov bucket[si+8],0
        mov bucket[si+12],0
        mov bucket[si+16],0
        mov bucket[si+20],0
        mov bucket[si+24],0
        mov bucket[si+28],0
        mov bucket[si+32],0
        mov bucket[si+36],0
        mov bucket[si+40],0
        mov bucket[si+44],0
        mov bucket[si+48],0
        mov bucket[si+52],0
        mov bucket[si+56],0
        mov bucket[si+60],0
        mov bucket[si+64],0
        mov bucket[si+68],0
        mov bucket[si+72],0
        mov bucket[si+76],0
        add linecount,1
        push ax
        call lvl_up
        pop ax
    nextline_:
         mov si,0
         add line[si],2880
         add line[si+8],2880
         add line[si+16],2880
         add line[si+24],2880
         add line[si+32],2880
         add line[si+40],2880
         add line[si+48],2880
         add line[si+56],2880
         add line[si+64],2880
         add line[si+72],2880
         xor eax,eax
         mov ax,80
         add special_ind,ax
         mov cx,10
         dec dx
         jnz linechecker_
    checkend_:
        xor ebx,ebx
        xor di,di
        xor si,si
        xor edx,edx
        xor ecx,ecx
        xor eax,eax
        ret

delete_lines_in_bucket endp

rotate_lines_in_bucket proc near
      mov bh,19
    cycle:
      mov si,1592
      mov bl,19
      mov dx,80
      mov ax,si
      mov cx,10
    linechecke_r:
        mov edi,bucket[si]
        cmp edi,0
        jnz short nextlin_e
        sub si,8
        loop linechecke_r
    mov si,ax
    sub si,dx
    mov cx,10
    linedown:
  
        mov edi,bucket[si]
        cmp edi,0
        jz short dsub
        add edi,2880
        dsub:
            mov bucket[si+80],edi
            mov edi,bucket[si+4]
            mov bucket[si+84],edi
            mov edi,0
            mov bucket[si],edi
            mov bucket[si+4],edi
            sub si,8

        loop linedown
    nextlin_e:
        mov cx,10
        mov si,ax
        sub si,dx
        mov ax,si
        dec bl
        jnz linechecke_r
        dec bh
        jnz cycle
        call update_bucket
       ; call drawblock
        ret
rotate_lines_in_bucket endp

check_line proc near
    mov si,0
    mov dx,0
    mov linenum,0

    firstit:
    call drawblock
    call delete_line
    cmp linenum,0
    jz dnsline

    call window_update
    call window_update
    call window_update
    call window_update
    call window_update

    call drawblock

    call window_update
    call window_update
    call window_update
    call window_update
    call window_update

    call delete_line
   
    call window_update
    call window_update
    call window_update
    call window_update
    call window_update

    call drawblock

    call window_update
    call window_update
    call window_update
    call window_update
    call window_update

    call delete_line

    call window_update
    call window_update
    call window_update
    call window_update
    call window_update

    call drawblock

    call window_update
    call window_update
    call window_update
    call window_update
    call window_update

    call delete_line

    call window_update
    call window_update
    call window_update
    call window_update
    call window_update


    call delete_lines_in_bucket
    call rotate_lines_in_bucket
    mov al,2
    mov ah,0Ch
    int 21h
   

    mov godown,0
    mov skip,1
    
    call drawlinecount
    dnsline:
        mov linenum,0
        xor ax,ax
        xor cx,cx
        ret
check_line endp

gameover_bucket proc near
mov si,1592
mov edi,56836
mov ax,10
mov linenum,20
godraw:
     mov bucket[si],edi
     mov bucket[si+4],7
     sub edi,9
     sub si,8
     dec ax
     cmp ax,0
     jnz godraw
gdnl:
    push edi
    push esi
    call drawblock
    call window_update
    mov ax,10
    pop esi
    pop edi
    add edi,90
    sub edi,2880
    sub linenum,1
    cmp linenum,0
    jnz godraw
    call window_update
    call window_update
    call window_update
    call window_update
    mov si,0
    mov edi,6*320+115
    mov ax,10
godraw_down:    
    mov bucket[si],edi
    mov bucket[si+4],0
    add edi,9
    add si,8
    dec ax
    cmp ax,0
    jnz godraw_down
gddl:
    push edi
    push esi
    call drawblock
    call window_update
    mov ax,10
    pop esi
    pop edi
    add edi,2880
    sub edi,90
    add linenum,1
    cmp linenum,20
    jnz godraw_down
    mov linecount,0
    mov scorecount,0
    ret
gameover_bucket endp



menuchains proc near
    mov di,135*320+217; 
    mov ax,0Fh;
    mov cx,95
    rep stosb
    mov cx,45
    d1:
        stosb
        add di,319
        loop d1
    mov di,135*320+217
    mov cx,45
    d2:
        stosb
        add di,319
        loop d2
    mov cx,96
    rep stosb
    ret
menuchains endp

clearmenu proc near
     mov di,134*320+216
     mov cx,97
     mov bx,47
     mov ax,0
     s1:
        rep stosb
        mov cx,97
        add di,320
        sub di,97
        dec bx
        cmp bx,0
        jnz s1
        ret
clearmenu endp

gamepause proc near
    mov skip,1
    call menuchains
    mov ah,2
    mov dl,28
    mov dh,17
    int 10h
    lea dx,gamepaused
    mov ah,09h
    int 21h
    mov ah,2
    mov dl,28
    mov dh,19
    int 10h
    lea dx,contstr
    mov ah,09h
    int 21h
    mov ah,2
    mov dl,28
    mov dh,21
    int 10h
    lea dx,exitstr
    mov ah,09h
    int 21h
   

    paused:
        mov ah,01h
        int 16h
        mov ah,0h
        int 16h
        cmp ah,10h
        jz short gc
        cmp ah,12h
        jz short gtt
        jmp paused
    gtt:
        mov al,3
        mov ah,0
        int 10h
        mov ah,4ch
        int 21h
    gc:
        call clearmenu
        xor dx,dx
        xor ax,ax
        ret
gamepause endp

nextchains proc near
    mov di,20*320+217; 
    mov ax,0Fh;
    mov cx,95
    rep stosb
    mov cx,95
    q1:
        stosb
        add di,319
        loop q1
    mov di,20*320+217
    mov cx,95
    q2:
        stosb
        add di,319
        loop q2
    mov cx,96
    rep stosb
    ret
nextchains endp

swap_check proc near
    mov si,0
    mov cx,8
    o:
        mov dl,figurecords[si]
        mov figurecordstmp[si],dl
        inc si
        loop o
    mov si,0
    mov edi,figure[si]
    mov figuretmp[si],edi
    mov edi,figure[si+8]
    mov figuretmp[si+4],edi
    mov edi,figure[si+16]
    mov figuretmp[si+8],edi
    mov edi,figure[si+24]
    mov figuretmp[si+12],edi
    call swapos
    mov di,0
    mov cx,4
    chk:
       mov dh,0
       cmp figurecords[di],0
       jl short repl
       cmp figurecords[di],9
       ja short repl
       add di,2
       mov dh,1
    loop chk
    mov di,0
    mov si,0
    chke:
        mov al,0
        mov ebx,bucket[si]
        cmp ebx,figure[di]
        jz short repl
        mov al,1
        add si,8
        cmp si,1600
        jnz chke
    chk2:
        add di,8
        mov si,0
        cmp di,32
        jnz chke
    repl:
    sub sost,1
    cmp sost,-1
    jnz short r
    mov sost,3
    r:
    mov si,0
    mov cx,8
    ow:
        mov dl,figurecordstmp[si]
        mov figurecords[si],dl
        inc si
        loop ow
        mov si,0
        mov edi,figuretmp[si]
        mov figure[si],edi
        mov edi,figuretmp[si+4]
        mov figure[si+8],edi
        mov edi,figuretmp[si+8]
        mov figure[si+16],edi
        mov edi,figuretmp[si+12]
        mov figure[si+24],edi
    cmp dh,0
    jz short dswp
    cmp al,0
    jz short dswp
        xor dx,dx
        xor esi,esi
        xor edi,edi
        call redraw_active
        call swapos
    dswp:
        ret

swap_check endp

drawlinecount proc near
    mov ah,2
    mov dl,2
    mov dh,6
    int 10h
    mov ax,linecount
    mov si,6
    mov bx,10
    xor dx,dx
    f:
        mov bx,10
        div bx
        add dl,30h
        mov specstr[si],dl
        xor dx,dx
        sub si,1
        cmp si,-1
        jnz f
    mov dx,offset specstr
    mov ah,09h
    int 21h
    xor bx,bx
    ret
drawlinecount endp

drawscorecount proc near
    mov ah,2
    mov dl,2
    mov dh,12
    int 10h
    mov ax,scorecount
    mov si,6
    mov bx,10
    xor dx,dx
    ff:
        mov bx,10
        div bx
        add dl,30h
        mov specstr[si],dl
        xor dx,dx
        sub si,1
        cmp si,-1
        jnz ff
    mov dx,offset specstr
    mov ah,09h
    int 21h
    xor bx,bx
    ret
drawscorecount endp

drawblocknext proc near
    mov bx,9
    l:
        mov cx,9
        rep stosb
        add di,311
        dec bx
        jnz l
    ret
drawblocknext endp

redrawnext proc near
    mov di,21*320+218
    mov ax,0
    mov bx,93
    h:
        mov cx,93
        rep stosb
        sub di,93
        add di,320
        dec bx
        cmp bx,0
        jnz h
    ret

redrawnext endp


drawnext proc near
    call redrawnext
    mov di,48*320+261
    cmp createnext,0
    jz short w1
     cmp createnext,1
    jz short w2
     cmp createnext,2
    jz short w3
     cmp createnext,3
    jz short w4
     cmp createnext,4
    jz short w5
     cmp createnext,5
    jz short w6
     cmp createnext,6
    jz w7
    ret
    w1:
        mov ax,1
        call drawblocknext
        call drawblocknext
        call drawblocknext
        sub di,320*9
        add di,9
        call drawblocknext
        ret
    w2:
        sub di, 5
        mov ax,2
        call drawblocknext
        call drawblocknext
        sub di,18*320
        add di,9
        call drawblocknext
        call drawblocknext
        ret
    w3:
        mov ax,3
       ; sub di,9
        call drawblocknext
        call drawblocknext
        sub di,9*320
        add di, 9
        call drawblocknext
        call drawblocknext
        ret
    w4:
        mov ax,4
        call drawblocknext
        call drawblocknext
        sub di,9*320
        sub di,9
        call drawblocknext
        call drawblocknext
        ret
    w5:
        mov ax,5
        call drawblocknext
        call drawblocknext
        call drawblocknext
        sub di,9*320+9
        call drawblocknext
        ret
    w6:
        mov ax,14
        call drawblocknext
        call drawblocknext
        call drawblocknext
        sub di,18*320+9
        call drawblocknext
        ret
    w7:
        mov ax,12
        call drawblocknext
        call drawblocknext
        call drawblocknext
        call drawblocknext
        ret



drawnext endp

start: 
    mov dx,@data
    mov ds,dx
    mov bh,0
    mov ax,13h; устанавливаем режим 640х350х16 цветов
    int 10h
    mov ah,2
    mov dl,2
    mov dh,1
    int 10h
    lea dx,tetris
    mov ah,09h
    int 21h
    call drawbucket
menu:
    call redrawnext
    call menuchains
    call nextchains
    call drawlinecount
    call drawscorecount
    mov ah,2
    mov dl,2
    mov dh,4
    int 10h
    lea dx,linestr
    mov ah,09h
    int 21h
    mov ah,2
    mov dl,2
    mov dh,10
    int 10h
    lea dx,scorectr
    mov ah,09h
    int 21h
    mov dh,1
    mov dl,31
    mov ah,2
    int 10h
    mov ah,09h
    lea dx,nextstr
    int 21h
    mov ah,2
    mov dl,28
    mov dh,19
    int 10h
    lea dx,newgamestr
    mov ah,09h
    int 21h
    mov ah,2
    mov dl,28
    mov dh,21
    int 10h
    lea dx,exitstr
    mov ah,09h
    int 21h
    mov ah,2
    mov dl,31
    mov dh,17
    int 10h
    lea dx,menustr
    mov ah,09h
    int 21h
    menuloop:
         mov ah,0h
         int 16h
         cmp ah,10h
         jz short initilaze
         cmp ah,12h
         jz endgame
    jmp menuloop

initilaze:
    call clearmenu
    mov lvlup,2
    mov speed,25
    mov linecount,0
    mov scorecount,0
    xor esi,esi
    xor edi,edi
    xor edx,edx
    xor eax,eax
    xor ecx,ecx
    xor ebx,ebx
    mov createnext,0
    mov tmp,0
    mov skip,0
    mov create,0
    mov sost,0
    mov gamemode,0
    mov godown,0
    mov activenow,0
    mov counter,0
    mov linenum,0
    mov ecx,400
    mov esi,0
    initbucket:
        mov bucket[si],0
        add si,4
        loop initbucket
    mov ecx,8
    mov esi,0
    initfigure:
        mov figure[si],0
        add si,4
        loop initfigure
    mov ecx,8
    mov esi,0
    initfigurecords:
        mov figurecords[si],0
        add si,1
        loop initfigurecords
    xor esi,esi
    xor ecx,ecx
    mov ah,00h
    int 1Ah
    mov tmp,dx
    work:
       call drawblock
       call createfigure
       call updateactive
       call drawactive
       call check_save
       cmp gamemode,2
       jz menu
       call check_line
       call timer_up
       ;call window_update
       xor dx,dx
    jmp work
endgame:
    mov al,3
    mov ah,0; устанавливаем текстовый режим
    int 10h
    mov ah,4ch
    int 21h
end start