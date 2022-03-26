.class public fact
.super java/lang/Object

.field public static F I

.method public static print : (II)V
    .code stack 3 locals 2
        ;; parameter 0 i fact.c 4
        ;; parameter 1 f fact.c 4
        ;; expression fact.c 6
        iload_0 ; load from i
        ; char constant
        bipush 48
        iadd
        invokestatic Method libc putchar (I)I
        pop
        ;; expression fact.c 7
        ; char constant
        bipush 33
        invokestatic Method libc putchar (I)I
        pop
        ;; expression fact.c 8
        ; char constant
        bipush 32
        invokestatic Method libc putchar (I)I
        pop
        ;; expression fact.c 9
        ; char constant
        bipush 61
        invokestatic Method libc putchar (I)I
        pop
        ;; expression fact.c 10
        ; char constant
        bipush 32
        invokestatic Method libc putchar (I)I
        pop
        ;; expression fact.c 12
        iload_1 ; load from f
        ldc 100000
        idiv
        bipush 48
        iadd
        invokestatic Method libc putchar (I)I
        pop
        ;; expression fact.c 13
        iload_1 ; load from f
        ldc 100000
        irem
        istore_1 ; store to f
        ;; expression fact.c 14
        iload_1 ; load from f
        sipush 10000
        idiv
        bipush 48
        iadd
        invokestatic Method libc putchar (I)I
        pop
        ;; expression fact.c 15
        iload_1 ; load from f
        sipush 10000
        irem
        istore_1 ; store to f
        ;; expression fact.c 16
        iload_1 ; load from f
        sipush 1000
        idiv
        bipush 48
        iadd
        invokestatic Method libc putchar (I)I
        pop
        ;; expression fact.c 17
        iload_1 ; load from f
        sipush 1000
        irem
        istore_1 ; store to f
        ;; expression fact.c 18
        ; char constant
        bipush 44
        invokestatic Method libc putchar (I)I
        pop
        ;; expression fact.c 19
        iload_1 ; load from f
        bipush 100
        idiv
        bipush 48
        iadd
        invokestatic Method libc putchar (I)I
        pop
        ;; expression fact.c 20
        iload_1 ; load from f
        bipush 100
        irem
        istore_1 ; store to f
        ;; expression fact.c 21
        iload_1 ; load from f
        bipush 10
        idiv
        bipush 48
        iadd
        invokestatic Method libc putchar (I)I
        pop
        ;; expression fact.c 22
        iload_1 ; load from f
        bipush 10
        irem
        istore_1 ; store to f
        ;; expression fact.c 23
        iload_1 ; load from f
        bipush 48
        iadd
        invokestatic Method libc putchar (I)I
        pop
        ;; expression fact.c 24
        bipush 10
        invokestatic Method libc putchar (I)I
        pop
        return ; automatically added
    .end code
.end method

.method public static main : ()I
    .code stack 3 locals 0
        ;; expression fact.c 29
        iconst_1
        putstatic Field fact F I
        ;; expression fact.c 30
        iconst_1
        getstatic Field fact F I
        invokestatic Method fact print (II)V
        ;; expression fact.c 31
        iconst_2
        getstatic Field fact F I
        iconst_2
        imul
        dup
        putstatic Field fact F I
        invokestatic Method fact print (II)V
        ;; expression fact.c 32
        iconst_3
        getstatic Field fact F I
        iconst_3
        imul
        dup
        putstatic Field fact F I
        invokestatic Method fact print (II)V
        ;; expression fact.c 33
        iconst_4
        getstatic Field fact F I
        iconst_4
        imul
        dup
        putstatic Field fact F I
        invokestatic Method fact print (II)V
        ;; expression fact.c 34
        iconst_5
        getstatic Field fact F I
        iconst_5
        imul
        dup
        putstatic Field fact F I
        invokestatic Method fact print (II)V
        ;; expression fact.c 35
        bipush 6
        getstatic Field fact F I
        bipush 6
        imul
        dup
        putstatic Field fact F I
        invokestatic Method fact print (II)V
        ;; expression fact.c 36
        bipush 7
        getstatic Field fact F I
        bipush 7
        imul
        dup
        putstatic Field fact F I
        invokestatic Method fact print (II)V
        ;; expression fact.c 37
        bipush 8
        getstatic Field fact F I
        bipush 8
        imul
        dup
        putstatic Field fact F I
        invokestatic Method fact print (II)V
        ;; expression fact.c 38
        bipush 9
        getstatic Field fact F I
        bipush 9
        imul
        dup
        putstatic Field fact F I
        invokestatic Method fact print (II)V
        ;; return fact.c 39
        getstatic Field fact F I
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
        invokestatic Method fact main ()I
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
