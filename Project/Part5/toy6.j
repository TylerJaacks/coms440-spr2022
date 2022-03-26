.class public toy6
.super java/lang/Object

.field public static a I

.method public static func : (II)I
    .code stack 3 locals 2
        ;; parameter 0 b toy6.c 4
        ;; parameter 1 c toy6.c 4
        ;; expression toy6.c 6
        getstatic Field toy6 a I
        iload_0 ; load from b
        iload_1 ; load from c
        imul
        iadd
        dup
        putstatic Field toy6 a I
        pop
    .end code
.end method

.method public static main : ()I
    .code stack 4 locals 0
        ;; expression toy6.c 12
        iconst_3
        dup
        putstatic Field toy6 a I
        pop
        ;; expression toy6.c 13
        iconst_3
        iconst_1
        iadd
        bipush 20
        iconst_4
        idiv
        invokestatic Method toy6 func (II)I
        pop
        ;; return toy6.c 14
        getstatic Field toy6 a I
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
        invokestatic Method toy6 main ()I
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
