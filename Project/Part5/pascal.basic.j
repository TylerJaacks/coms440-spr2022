.class public pascal
.super java/lang/Object

.field public static row [I

.method public static show : (I)V
    .code stack 3 locals 1
        ;; parameter 0 x pascal.c 9
        ;; expression pascal.c 11
        iload_0 ; load from x
        bipush 10
        idiv
        bipush 48
        iadd
        invokestatic Method libc putchar (I)I
        pop
        ;; expression pascal.c 12
        iload_0 ; load from x
        bipush 10
        irem
        bipush 48
        iadd
        invokestatic Method libc putchar (I)I
        pop
        ;; expression pascal.c 13
        bipush 32
        invokestatic Method libc putchar (I)I
        pop
        return ; automatically added
    .end code
.end method

.method public static show2 : (II)V
    .code stack 1 locals 2
        ;; parameter 0 x pascal.c 16
        ;; parameter 1 y pascal.c 16
        ;; expression pascal.c 18
        iload_0 ; load from x
        invokestatic Method pascal show (I)V
        ;; expression pascal.c 19
        iload_1 ; load from y
        invokestatic Method pascal show (I)V
        return ; automatically added
    .end code
.end method

.method public static show5 : (IIIII)V
    .code stack 2 locals 5
        ;; parameter 0 a pascal.c 22
        ;; parameter 1 b pascal.c 22
        ;; parameter 2 c pascal.c 22
        ;; parameter 3 d pascal.c 22
        ;; parameter 4 e pascal.c 22
        ;; expression pascal.c 24
        iload_0 ; load from a
        iload_1 ; load from b
        invokestatic Method pascal show2 (II)V
        ;; expression pascal.c 25
        iload_2 ; load from c
        invokestatic Method pascal show (I)V
        ;; expression pascal.c 26
        iload_3 ; load from d
        iload 4 ; load from e
        invokestatic Method pascal show2 (II)V
        return ; automatically added
    .end code
.end method

.method public static show_row : ()V
    .code stack 20 locals 0
        ;; expression pascal.c 31
        getstatic Field pascal row [I
        iconst_0
        iaload
        getstatic Field pascal row [I
        iconst_1
        iaload
        invokestatic Method pascal show2 (II)V
        ;; expression pascal.c 32
        getstatic Field pascal row [I
        iconst_2
        iaload
        getstatic Field pascal row [I
        iconst_3
        iaload
        getstatic Field pascal row [I
        iconst_4
        iaload
        getstatic Field pascal row [I
        iconst_5
        iaload
        getstatic Field pascal row [I
        bipush 6
        iaload
        invokestatic Method pascal show5 (IIIII)V
        ;; expression pascal.c 33
        getstatic Field pascal row [I
        bipush 7
        iaload
        getstatic Field pascal row [I
        bipush 8
        iaload
        invokestatic Method pascal show2 (II)V
        ;; expression pascal.c 34
        bipush 10
        invokestatic Method libc putchar (I)I
        pop
        return ; automatically added
    .end code
.end method

.method public static update : (II)I
    .code stack 6 locals 3
        ;; parameter 0 add pascal.c 37
        ;; parameter 1 i pascal.c 37
        ;; local 2 old pascal.c 39
        ;; expression pascal.c 40
        getstatic Field pascal row [I
        iload_1 ; load from i
        iaload
        dup
        istore_2 ; store to old
        pop
        ;; expression pascal.c 41
        getstatic Field pascal row [I
        dup
        iload_1 ; load from i
        dup_x1
        iaload
        iload_0 ; load from add
        iadd
        dup_x2
        iastore
        pop
        ;; return pascal.c 42
        iload_2 ; load from old
        ireturn
    .end code
.end method

.method public static update_row : ()V
    .code stack 9 locals 0
        ;; expression pascal.c 47
        iconst_1
        iconst_1
        invokestatic Method pascal update (II)I
        iconst_2
        invokestatic Method pascal update (II)I
        iconst_3
        invokestatic Method pascal update (II)I
        iconst_4
        invokestatic Method pascal update (II)I
        iconst_5
        invokestatic Method pascal update (II)I
        bipush 6
        invokestatic Method pascal update (II)I
        bipush 7
        invokestatic Method pascal update (II)I
        bipush 8
        invokestatic Method pascal update (II)I
        pop
        return ; automatically added
    .end code
.end method

.method public static main : ()I
    .code stack 33 locals 0
        ;; expression pascal.c 52
        getstatic Field pascal row [I
        iconst_0
        iconst_1
        dup_x2
        iastore
        pop
        ;; expression pascal.c 53
        getstatic Field pascal row [I
        iconst_1
        getstatic Field pascal row [I
        iconst_2
        getstatic Field pascal row [I
        iconst_3
        getstatic Field pascal row [I
        iconst_4
        getstatic Field pascal row [I
        iconst_5
        getstatic Field pascal row [I
        bipush 6
        getstatic Field pascal row [I
        bipush 7
        getstatic Field pascal row [I
        bipush 8
        iconst_0
        dup_x2
        iastore
        dup_x2
        iastore
        dup_x2
        iastore
        dup_x2
        iastore
        dup_x2
        iastore
        dup_x2
        iastore
        dup_x2
        iastore
        dup_x2
        iastore
        pop
        ;; expression pascal.c 55
        invokestatic Method pascal show_row ()V
        ;; expression pascal.c 56
        invokestatic Method pascal update_row ()V
        ;; expression pascal.c 56
        invokestatic Method pascal show_row ()V
        ;; expression pascal.c 57
        invokestatic Method pascal update_row ()V
        ;; expression pascal.c 57
        invokestatic Method pascal show_row ()V
        ;; expression pascal.c 58
        invokestatic Method pascal update_row ()V
        ;; expression pascal.c 58
        invokestatic Method pascal show_row ()V
        ;; expression pascal.c 59
        invokestatic Method pascal update_row ()V
        ;; expression pascal.c 59
        invokestatic Method pascal show_row ()V
        ;; expression pascal.c 60
        invokestatic Method pascal update_row ()V
        ;; expression pascal.c 60
        invokestatic Method pascal show_row ()V
        ;; expression pascal.c 61
        invokestatic Method pascal update_row ()V
        ;; expression pascal.c 61
        invokestatic Method pascal show_row ()V
        ;; expression pascal.c 62
        invokestatic Method pascal update_row ()V
        ;; expression pascal.c 62
        invokestatic Method pascal show_row ()V
        ;; expression pascal.c 63
        invokestatic Method pascal update_row ()V
        ;; expression pascal.c 63
        invokestatic Method pascal show_row ()V
        ;; return pascal.c 64
        getstatic Field pascal row [I
        iconst_0
        iaload
        ireturn
    .end code
.end method

; Special methods

.method <clinit> : ()V
    .code stack 1 locals 0
        ; Building array row
        bipush 9
        newarray int
        putstatic Field pascal row [I
        return
    .end code
.end method

.method <init> : ()V
    .code stack 1 locals 1
        aload_0
        invokespecial Method java/lang/Object <init> ()V
        return
    .end code
.end method

.method public static main : ([Ljava/lang/String;)V
    .code stack 2 locals 2
        invokestatic Method pascal main ()I
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
