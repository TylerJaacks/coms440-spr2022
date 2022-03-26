.class public sum
.super java/lang/Object


.method public static main : ()I
    .code stack 3 locals 3
        ;; local 0 d1 sum.c 10
        ;; local 1 d2 sum.c 10
        ;; local 2 sum sum.c 10
        ;; expression sum.c 11
        invokestatic Method libc getchar ()I
        bipush 48
        isub
        istore_0 ; store to d1
        ;; expression sum.c 12
        invokestatic Method libc getchar ()I
        bipush 48
        isub
        istore_1 ; store to d2
        ;; expression sum.c 13
        iload_0 ; load from d1
        iload_1 ; load from d2
        iadd
        istore_2 ; store to sum
        ;; expression sum.c 14
        iload_0 ; load from d1
        bipush 48
        iadd
        invokestatic Method libc putchar (I)I
        pop
        ;; expression sum.c 15
        bipush 43
        invokestatic Method libc putchar (I)I
        pop
        ;; expression sum.c 16
        iload_1 ; load from d2
        bipush 48
        iadd
        invokestatic Method libc putchar (I)I
        pop
        ;; expression sum.c 17
        bipush 61
        invokestatic Method libc putchar (I)I
        pop
        ;; expression sum.c 23
        iload_2 ; load from sum
        bipush 10
        idiv
        bipush 48
        iadd
        invokestatic Method libc putchar (I)I
        pop
        ;; expression sum.c 24
        iload_2 ; load from sum
        bipush 10
        irem
        bipush 48
        iadd
        invokestatic Method libc putchar (I)I
        pop
        ;; expression sum.c 25
        bipush 10
        invokestatic Method libc putchar (I)I
        pop
        ;; return sum.c 26
        iload_2 ; load from sum
        ireturn
    .end code
.end method

; Special methods

.method <init> : ()V
    .code stack 1 locals 1
        aload_0
        invokespecial Method java/lang/Object <init> ()V
        return
    .end code
.end method

.method public static main : ([Ljava/lang/String;)V
    .code stack 2 locals 2
        invokestatic Method sum main ()I
        istore_1
        getstatic Field java/lang/System out Ljava/io/PrintStream;
        ldc 'Return code: '
        invokevirtual Method java/io/PrintStream print (Ljava/lang/String;)V
        getstatic Field java/lang/System out Ljava/io/PrintStream;
        iload_1
        invokevirtual Method java/io/PrintStream println (I)V
        return
    .end code
.end method
