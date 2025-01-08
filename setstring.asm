;Affichage d'une chaine de charactere que nous avons introduites 
  
  .model small
  .stack 256
  .data  
    mess1 db "Introduction d'un texte (max 10): ",0
    mess2 db "Le texte introduit est: ",0
    intro db ? 11  
    
  .code
    call dsdata
    lea si,mess1
    mov di,160
    mov ah,0F0h
    call printf   
  
    mov cx,10
    call dsdata
    lea si,intro
 introcar:   
    mov ah,0
    int 16h
    cmp al,13
    je sortie
    mov ah,0Eh
    call dsecr
    mov [di],ax
    add di,2
    call dsdata
    mov [si],al
    inc si
    loop introcar 
  sortie:
    call dsdata
    mov [si],0
     
    call dsdata
    lea si,mess2
    mov di,320
    mov ah,0Fh
    call printf
    
    call dsdata
    lea si,intro
    mov ah,0E0h
    call printf
       
    mov ah,4Ch  ; arrêt... 
    int 21h     ;   ...système 
    
    dsdata:
        push bx
        mov bx,@data   ;mov ds,@data impossible
        mov ds,bx
        pop bx 
        ret
        
    dsecr:
        push bx
        mov bx,0B800h   ;mov ds,0B800h impossible
        mov ds,bx 
        pop bx
        ret
    
    printf:
        call dsdata
        mov al,[si] 
        cmp al,0
        je fin
        call dsecr
        mov [di],ax
        inc si
        add di,2
        jmp printf 
     fin: 
        ret
    
    
    end         ; arrêt de la phase d'assemblage