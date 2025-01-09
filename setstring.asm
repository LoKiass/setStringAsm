;Affichage d'une chaine de charactere que nous avons introduites 
  
  .model small
  .stack 256
  .data  
    mess1 db "Introduction d'un texte (max 10): ",0
    mess2 db "Le texte introduit est: ",0
    intro db ? 11  
    
  .code
    call dsdata     ; Appel du sous programme "dsdata"
    lea si,mess1    ; Chargement de l'adresse de mess1 (string) dans le SI (source index)
    mov di,160      ; Positionnement de DI (Position ecran) en 160 (Saut de ligne)
    mov ah,0F0h     ; Configuration de AH (Couleur de fond + couleu du charactere) en blanc sur noir (console de base)
    call printf     ; Appel du sous programme printf
  
    mov cx,10       ; Chargement de la valeur 10 dans le registre cx (Autrement dire, le nombre maximale de charactere) 
    call dsdata     ; Appel du sous programme "dsdata"
    lea si,intro    ; Chargement de l'adresse de intro dans SI (Au debut rien, mais sera le retour de notre frappe plus tard)
 
 introcar:          ; Outils permetant d'introduit des charactere dans un string (SI)  
    mov ah,0        ; Initialiser la valeur de AH a 0 (Pour l'attente d'interuption)
    int 16h         ; Attente d'interuption => (Frappe effectuer charger dans al)  
    cmp al,13       ; Comparer la valeur sortante avec 13 (Touche enter) 
    je sortie       ; Si comparaison correct : appel du sous programme sortie
    mov ah,0Eh      ; Sinon, Configuration du retour ecran (jaune sur noir)
    call dsecr      ; Appel du sous programme "dsecran" 
    mov [di],ax     ; Chargement de ax (ah et al) dans le contenue de l'adresse di (addrese DI au debut en 162-164 apres la premiere chaine de charactere)
    add di,2        ; Incrementation de DI de 2 (2 octect etant ah et al)
    call dsdata     ; Appel du sous programme "dsdata" 
    mov [si],al     ; Chargement de al (code ascii de notre frappe) dans le contenue de l'adresse de si 
    inc si          ; Incrementation de si (Passer pour le prochain charactere que nous allons frapper)
    loop introcar   ; Retourner vers l'outils introcar 
  sortie:           ; Arriveras si et seulement al = 13
    call dsdata     ; Apelle du sous programme "dsdata"
    mov [si],0      ; Chargement de la valeur 0 dans le contenue de l'adresse si (Fin de chaine pour notre sous-prog "printf") 
     
    call dsdata     ; Appel du sous-programme "dsdata"
    lea si,mess2    ; Charment du string msg2 dans le l'adresse de SI
    mov di,320      ; Configuration de l'emplacement ecran en 320 (Autre saut de ligne)
    mov ah,0Fh      ; Configuration de AH (blanc sur noir)
    call printf     ; Appel du sous-programme "printf"
    
    call dsdata     ; Appel du sous-programme "dsdata"
    lea si,intro    ; Chargement de string intro dans si
    mov ah,0E0h     ; Configuration ecran de intro (Noir sur blanc)
    call printf     ; Appel du sous-prog "Printf"
       
    mov ah,4Ch  
    int 21h    
    
    dsdata:             ; dsdata s'occupe de la gestion du segment data
        push bx         ; Sauvegarde du registre bx dans la pile        
        mov bx,@data    ; Chargment de l'adresse du segment data dans le registre bx (ds < data IMPOSSIBLE)
        mov ds,bx       ; Chargement de l'adresse de bx dans le registre ds (Afin d'acceder a l'adresse de @data)
        pop bx          ; Restauration de la valeur de bx en fonction de la pile          
        ret             ; Retour
        
    dsecr:              ; Gestion de l'affichage ecran
        push bx         ; Sauvegarde du registre bx dans la pile
        mov bx,0B800h   ; Chargment de l'adresse du segment ecran (0B800h) dans le registre bx (ds < 0B800h IMPOSSIBLE du au type d'adressage) 
        mov ds,bx       ; Chargement de l'adresse de bx dans le registre ds 
        pop bx          ; Restauration de la valeur de bx en fonction de la pile 
        ret             ; Retour
    
    printf:
        call dsdata     ; Appel du sous programme dsdata (Effet d'essuie glace)
        mov al,[si]     ; Chargment du contenue de SI (1 charactere) dans le registre al (Qui complete AH, resultant en AX)   
        cmp al,0        ; Comparaisons de AL (ou meme SI) � la valeur 0 (Fin de la chaine de charctere)
        je fin          ; Si vrai, appel du sous-programme fin (qui effectuer simplement un return vers le segment "code)
        call dsecr      ; Appel du sous programme "dsecran" (Gestion de l'affichage ecran et du segment ecran)
        mov [di],ax     ; Chargement du registre ax (ah + al) dans le contenue de l'adresse de di 
        inc si          ; Incrementation du registre SI (+1 pour passer au prochain charactere de la chaine) 
        add di,2        ; Double incrementation du registre DI (AH et AL considerer a ce moment comme 2 octect)
        jmp printf      ; Saut vers le sous programme printf (Permet d'afficher la chaine de charactere au complet)
     fin: 
        ret             ; Cela arrivera seulement quand notre string sera entierement arriver a 0 (Fin de la chaine de charactere)
    
    
    end         ; arr�t de la phase d'assemblage