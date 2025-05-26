.class public Main
.super java/lang/Object

; standard initializer
.method public <init>()V
  aload_0
  invokenonvirtual java/lang/Object/<init>()V
  return
.end method

.method public static sum(I)I
  .limit stack 32
  .limit locals 32

  ; int result = 0
  iconst_0
  istore_1  ; result

  ; int i = 1
  iconst_1
  istore_2  ; i 

  ; start loop (while)
  Loop:
    iload_2  ; load i
    iload_0  ; load arg
    if_icmpgt End  ; if i > n then goto End lable
    iload_1  ; load result
    iload_2  ; load i
    iadd  ; tmp = result + i
    istore_1  ; result = tmp
    iload_2  ; load i
    bipush 1  ; push 1 
    iadd  ; tmp = i + 1
    istore_2  ; i = tmp
    ldc 0  ; load 0
    ifeq Loop  ; if 0 == 0 then goto Loop
  End: 
    iload_1  ; load result
    ireturn  ; return result
.end method

.method public static main([Ljava/lang/String;)V
  .limit stack 32
  .limit locals 32
  bipush 100
  istore_2  ; int n = 100
  getstatic java/lang/System/out Ljava/io/PrintStream;
  iload_2
  invokestatic Main/sum(I)I
  invokevirtual java/io/PrintStream/println(I)V
  return
.end method

