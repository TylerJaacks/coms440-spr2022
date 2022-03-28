.class public toy1
.super java/lang/Object


.method public static func : (III)I
    .code stack 3 locals 3
        ;; parameter 0 a toy1.c 2
        ;; parameter 1 b toy1.c 2
        ;; parameter 2 c toy1.c 2
        ;; return toy1.c 4
        iload_0 ; load from a
        iload_1 ; load from b
        iload_2 ; load from c
        imul
        iadd
        ireturn
    .end code
.end method

.method public static main : ()I
    .code stack 3 locals 0
        ;; return toy1.c 9
        iconst_3
        iconst_4
        iconst_5
        invokestatic Method toy1 func (III)I
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
        invokestatic Method toy1 main ()I
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
