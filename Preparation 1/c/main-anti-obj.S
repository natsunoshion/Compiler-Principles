
main.o:     file format elf64-x86-64


Disassembly of section .text:

0000000000000000 <main>:
   0:	55                   	push   %rbp
   1:	48 89 e5             	mov    %rsp,%rbp
   4:	48 83 ec 20          	sub    $0x20,%rsp
   8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%rbp)
   f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  16:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%rbp)
  1d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%rbp)
  24:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%rbp)
  2b:	48 bf 00 00 00 00 00 	movabs $0x0,%rdi
  32:	00 00 00 
  35:	48 8d 75 f0          	lea    -0x10(%rbp),%rsi
  39:	b0 00                	mov    $0x0,%al
  3b:	e8 00 00 00 00       	call   40 <main+0x40>
  40:	8b 75 f8             	mov    -0x8(%rbp),%esi
  43:	8b 55 fc             	mov    -0x4(%rbp),%edx
  46:	48 bf 00 00 00 00 00 	movabs $0x0,%rdi
  4d:	00 00 00 
  50:	b0 00                	mov    $0x0,%al
  52:	e8 00 00 00 00       	call   57 <main+0x57>
  57:	8b 45 f4             	mov    -0xc(%rbp),%eax
  5a:	3b 45 f0             	cmp    -0x10(%rbp),%eax
  5d:	7d 34                	jge    93 <main+0x93>
  5f:	8b 45 fc             	mov    -0x4(%rbp),%eax
  62:	89 45 ec             	mov    %eax,-0x14(%rbp)
  65:	8b 45 f8             	mov    -0x8(%rbp),%eax
  68:	03 45 fc             	add    -0x4(%rbp),%eax
  6b:	89 45 fc             	mov    %eax,-0x4(%rbp)
  6e:	8b 75 fc             	mov    -0x4(%rbp),%esi
  71:	48 bf 00 00 00 00 00 	movabs $0x0,%rdi
  78:	00 00 00 
  7b:	b0 00                	mov    $0x0,%al
  7d:	e8 00 00 00 00       	call   82 <main+0x82>
  82:	8b 45 ec             	mov    -0x14(%rbp),%eax
  85:	89 45 f8             	mov    %eax,-0x8(%rbp)
  88:	8b 45 f4             	mov    -0xc(%rbp),%eax
  8b:	83 c0 01             	add    $0x1,%eax
  8e:	89 45 f4             	mov    %eax,-0xc(%rbp)
  91:	eb c4                	jmp    57 <main+0x57>
  93:	31 c0                	xor    %eax,%eax
  95:	48 83 c4 20          	add    $0x20,%rsp
  99:	5d                   	pop    %rbp
  9a:	c3                   	ret    
