.class public foo
.super java/lang/Object


.method public static foo : (I)I
    .code stack 3 locals 2
        ;; parameter 0 a foo.c 1
        ;; local 1 b foo.c 3
        ;; expression foo.c 4
        iload_0 ; load from a
        iconst_3
        iadd
        dup
        istore_1 ; store to b
        pop
        ;; return foo.c 5
        iconst_2
        iload_1 ; load from b
        imul
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
        invokestatic Method foo main ()I
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
