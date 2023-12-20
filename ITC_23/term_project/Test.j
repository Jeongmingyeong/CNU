.class public Test
.super java/lang/Object
.method public <init>()V
aload_0
invokenonvirtual java/lang/Object/<init>()V
return
.end method

.method public static main([Ljava/lang/String;)V
.limit stack 32
.limit locals 32
ldc 0
istore 0
ldc 0
istore 1

Label0: 
ldc 1
ldc 1
if_icmpne Label1
iload 0
ldc 1
iadd
istore 0
    iload 0
ldc 10
if_icmple Label3
goto Label1
    iload 0
ldc 5
if_icmpne Label2
goto Label0
        
Label2: 

Label3: 
goto Label0
Label1: 

    iload 1
ldc 1
iadd
istore 1

getstatic java/lang/System/out Ljava/io/PrintStream;
iload 0
invokevirtual java/io/PrintStream/println(I)V
getstatic java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/println(I)V
return
.end method
