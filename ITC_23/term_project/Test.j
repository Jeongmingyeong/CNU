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
ldc 1
istore 2

Label6: 
ldc 1
ldc 1
if_icmpne Label7
iload 2
ldc 1
if_icmpne Label1
iload 0
iload 2
iadd
istore 0
        iload 2
ldc 1
iadd
istore 2
    Label1: 
iload 2
ldc 2
if_icmpne Label2
iload 1
iload 2
iadd
istore 1
        iload 2
ldc 1
iadd
istore 2
    Label2: 
iload 2
ldc 3
if_icmpne Label3
iload 0
iload 2
iadd
istore 0
        iload 2
ldc 1
iadd
istore 2
    Label3: 
iload 2
ldc 4
if_icmpne Label4
iload 1
iload 2
iadd
istore 1
        iload 2
ldc 1
iadd
istore 2
    Label4: 
iload 2
ldc 5
if_icmpne Label5
iload 0
iload 2
iadd
istore 0
        iload 2
ldc 1
iadd
istore 2
    Label5: 
iload 1
iload 2
iadd
istore 1
        iload 2
ldc 1
iadd
istore 2
    
goto Label6
Label7: 

getstatic java/lang/System/out Ljava/io/PrintStream;
iload 0
invokevirtual java/io/PrintStream/println(I)V
getstatic java/lang/System/out Ljava/io/PrintStream;
iload 1
invokevirtual java/io/PrintStream/println(I)V
return
.end method
