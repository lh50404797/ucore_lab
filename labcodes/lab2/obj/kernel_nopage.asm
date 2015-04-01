
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 b6 5d 00 00       	call   105e0c <memset>

    cons_init();                // init the console
  100056:	e8 56 15 00 00       	call   1015b1 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 a0 5f 10 00 	movl   $0x105fa0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 bc 5f 10 00 	movl   $0x105fbc,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 a4 42 00 00       	call   104328 <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 91 16 00 00       	call   10171a <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 09 18 00 00       	call   101897 <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 d4 0c 00 00       	call   100d67 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 f0 15 00 00       	call   101688 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 dd 0b 00 00       	call   100c99 <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 c1 5f 10 00 	movl   $0x105fc1,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 cf 5f 10 00 	movl   $0x105fcf,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 dd 5f 10 00 	movl   $0x105fdd,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 eb 5f 10 00 	movl   $0x105feb,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 f9 5f 10 00 	movl   $0x105ff9,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 08 60 10 00 	movl   $0x106008,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 28 60 10 00 	movl   $0x106028,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 47 60 10 00 	movl   $0x106047,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 e3 12 00 00       	call   1015dd <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 ee 52 00 00       	call   105625 <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 6a 12 00 00       	call   1015dd <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 4a 12 00 00       	call   101619 <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 4c 60 10 00    	movl   $0x10604c,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 4c 60 10 00 	movl   $0x10604c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 a8 72 10 00 	movl   $0x1072a8,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 5c 1e 11 00 	movl   $0x111e5c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec 5d 1e 11 00 	movl   $0x111e5d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 88 48 11 00 	movl   $0x114888,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 94 55 00 00       	call   105c80 <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 56 60 10 00 	movl   $0x106056,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 6f 60 10 00 	movl   $0x10606f,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 95 5f 10 	movl   $0x105f95,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 87 60 10 00 	movl   $0x106087,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 9f 60 10 00 	movl   $0x10609f,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 b7 60 10 00 	movl   $0x1060b7,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 68 89 11 00       	mov    $0x118968,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 d0 60 10 00 	movl   $0x1060d0,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 fa 60 10 00 	movl   $0x1060fa,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 16 61 10 00 	movl   $0x106116,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	53                   	push   %ebx
  1009be:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009c1:	89 e8                	mov    %ebp,%eax
  1009c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
  1009c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp(),eip=read_eip(),i=0;
  1009c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1009cc:	e8 d8 ff ff ff       	call   1009a9 <read_eip>
  1009d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1009d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for(; i<STACKFRAME_DEPTH && ebp != 0; i++){
  1009db:	eb 6f                	jmp    100a4c <print_stackframe+0x92>
        cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n", ebp, eip,
            ((uint32_t *)ebp)[2],((uint32_t *)ebp)[3],((uint32_t *)ebp)[4],((uint32_t *)ebp)[5]);
  1009dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e0:	83 c0 14             	add    $0x14,%eax
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp(),eip=read_eip(),i=0;
    for(; i<STACKFRAME_DEPTH && ebp != 0; i++){
        cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n", ebp, eip,
  1009e3:	8b 18                	mov    (%eax),%ebx
            ((uint32_t *)ebp)[2],((uint32_t *)ebp)[3],((uint32_t *)ebp)[4],((uint32_t *)ebp)[5]);
  1009e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e8:	83 c0 10             	add    $0x10,%eax
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp(),eip=read_eip(),i=0;
    for(; i<STACKFRAME_DEPTH && ebp != 0; i++){
        cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n", ebp, eip,
  1009eb:	8b 08                	mov    (%eax),%ecx
            ((uint32_t *)ebp)[2],((uint32_t *)ebp)[3],((uint32_t *)ebp)[4],((uint32_t *)ebp)[5]);
  1009ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f0:	83 c0 0c             	add    $0xc,%eax
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp(),eip=read_eip(),i=0;
    for(; i<STACKFRAME_DEPTH && ebp != 0; i++){
        cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n", ebp, eip,
  1009f3:	8b 10                	mov    (%eax),%edx
            ((uint32_t *)ebp)[2],((uint32_t *)ebp)[3],((uint32_t *)ebp)[4],((uint32_t *)ebp)[5]);
  1009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f8:	83 c0 08             	add    $0x8,%eax
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp(),eip=read_eip(),i=0;
    for(; i<STACKFRAME_DEPTH && ebp != 0; i++){
        cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n", ebp, eip,
  1009fb:	8b 00                	mov    (%eax),%eax
  1009fd:	89 5c 24 18          	mov    %ebx,0x18(%esp)
  100a01:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  100a05:	89 54 24 10          	mov    %edx,0x10(%esp)
  100a09:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a10:	89 44 24 08          	mov    %eax,0x8(%esp)
  100a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a17:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a1b:	c7 04 24 28 61 10 00 	movl   $0x106128,(%esp)
  100a22:	e8 15 f9 ff ff       	call   10033c <cprintf>
            ((uint32_t *)ebp)[2],((uint32_t *)ebp)[3],((uint32_t *)ebp)[4],((uint32_t *)ebp)[5]);
        print_debuginfo(eip - 1);
  100a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a2a:	83 e8 01             	sub    $0x1,%eax
  100a2d:	89 04 24             	mov    %eax,(%esp)
  100a30:	e8 d1 fe ff ff       	call   100906 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a38:	83 c0 04             	add    $0x4,%eax
  100a3b:	8b 00                	mov    (%eax),%eax
  100a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a43:	8b 00                	mov    (%eax),%eax
  100a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp(),eip=read_eip(),i=0;
    for(; i<STACKFRAME_DEPTH && ebp != 0; i++){
  100a48:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a4c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a50:	77 06                	ja     100a58 <print_stackframe+0x9e>
  100a52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a56:	75 85                	jne    1009dd <print_stackframe+0x23>
            ((uint32_t *)ebp)[2],((uint32_t *)ebp)[3],((uint32_t *)ebp)[4],((uint32_t *)ebp)[5]);
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
  100a58:	83 c4 34             	add    $0x34,%esp
  100a5b:	5b                   	pop    %ebx
  100a5c:	5d                   	pop    %ebp
  100a5d:	c3                   	ret    

00100a5e <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a5e:	55                   	push   %ebp
  100a5f:	89 e5                	mov    %esp,%ebp
  100a61:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a6b:	eb 0c                	jmp    100a79 <parse+0x1b>
            *buf ++ = '\0';
  100a6d:	8b 45 08             	mov    0x8(%ebp),%eax
  100a70:	8d 50 01             	lea    0x1(%eax),%edx
  100a73:	89 55 08             	mov    %edx,0x8(%ebp)
  100a76:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a79:	8b 45 08             	mov    0x8(%ebp),%eax
  100a7c:	0f b6 00             	movzbl (%eax),%eax
  100a7f:	84 c0                	test   %al,%al
  100a81:	74 1d                	je     100aa0 <parse+0x42>
  100a83:	8b 45 08             	mov    0x8(%ebp),%eax
  100a86:	0f b6 00             	movzbl (%eax),%eax
  100a89:	0f be c0             	movsbl %al,%eax
  100a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a90:	c7 04 24 e0 61 10 00 	movl   $0x1061e0,(%esp)
  100a97:	e8 b1 51 00 00       	call   105c4d <strchr>
  100a9c:	85 c0                	test   %eax,%eax
  100a9e:	75 cd                	jne    100a6d <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa3:	0f b6 00             	movzbl (%eax),%eax
  100aa6:	84 c0                	test   %al,%al
  100aa8:	75 02                	jne    100aac <parse+0x4e>
            break;
  100aaa:	eb 67                	jmp    100b13 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100aac:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ab0:	75 14                	jne    100ac6 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ab2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ab9:	00 
  100aba:	c7 04 24 e5 61 10 00 	movl   $0x1061e5,(%esp)
  100ac1:	e8 76 f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac9:	8d 50 01             	lea    0x1(%eax),%edx
  100acc:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100acf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ad9:	01 c2                	add    %eax,%edx
  100adb:	8b 45 08             	mov    0x8(%ebp),%eax
  100ade:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ae0:	eb 04                	jmp    100ae6 <parse+0x88>
            buf ++;
  100ae2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae9:	0f b6 00             	movzbl (%eax),%eax
  100aec:	84 c0                	test   %al,%al
  100aee:	74 1d                	je     100b0d <parse+0xaf>
  100af0:	8b 45 08             	mov    0x8(%ebp),%eax
  100af3:	0f b6 00             	movzbl (%eax),%eax
  100af6:	0f be c0             	movsbl %al,%eax
  100af9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100afd:	c7 04 24 e0 61 10 00 	movl   $0x1061e0,(%esp)
  100b04:	e8 44 51 00 00       	call   105c4d <strchr>
  100b09:	85 c0                	test   %eax,%eax
  100b0b:	74 d5                	je     100ae2 <parse+0x84>
            buf ++;
        }
    }
  100b0d:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b0e:	e9 66 ff ff ff       	jmp    100a79 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b16:	c9                   	leave  
  100b17:	c3                   	ret    

00100b18 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b18:	55                   	push   %ebp
  100b19:	89 e5                	mov    %esp,%ebp
  100b1b:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b1e:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b21:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b25:	8b 45 08             	mov    0x8(%ebp),%eax
  100b28:	89 04 24             	mov    %eax,(%esp)
  100b2b:	e8 2e ff ff ff       	call   100a5e <parse>
  100b30:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b37:	75 0a                	jne    100b43 <runcmd+0x2b>
        return 0;
  100b39:	b8 00 00 00 00       	mov    $0x0,%eax
  100b3e:	e9 85 00 00 00       	jmp    100bc8 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b4a:	eb 5c                	jmp    100ba8 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b4c:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b52:	89 d0                	mov    %edx,%eax
  100b54:	01 c0                	add    %eax,%eax
  100b56:	01 d0                	add    %edx,%eax
  100b58:	c1 e0 02             	shl    $0x2,%eax
  100b5b:	05 20 70 11 00       	add    $0x117020,%eax
  100b60:	8b 00                	mov    (%eax),%eax
  100b62:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b66:	89 04 24             	mov    %eax,(%esp)
  100b69:	e8 40 50 00 00       	call   105bae <strcmp>
  100b6e:	85 c0                	test   %eax,%eax
  100b70:	75 32                	jne    100ba4 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b75:	89 d0                	mov    %edx,%eax
  100b77:	01 c0                	add    %eax,%eax
  100b79:	01 d0                	add    %edx,%eax
  100b7b:	c1 e0 02             	shl    $0x2,%eax
  100b7e:	05 20 70 11 00       	add    $0x117020,%eax
  100b83:	8b 40 08             	mov    0x8(%eax),%eax
  100b86:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b89:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b8f:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b93:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b96:	83 c2 04             	add    $0x4,%edx
  100b99:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b9d:	89 0c 24             	mov    %ecx,(%esp)
  100ba0:	ff d0                	call   *%eax
  100ba2:	eb 24                	jmp    100bc8 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ba4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bab:	83 f8 02             	cmp    $0x2,%eax
  100bae:	76 9c                	jbe    100b4c <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bb0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bb7:	c7 04 24 03 62 10 00 	movl   $0x106203,(%esp)
  100bbe:	e8 79 f7 ff ff       	call   10033c <cprintf>
    return 0;
  100bc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bc8:	c9                   	leave  
  100bc9:	c3                   	ret    

00100bca <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bca:	55                   	push   %ebp
  100bcb:	89 e5                	mov    %esp,%ebp
  100bcd:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bd0:	c7 04 24 1c 62 10 00 	movl   $0x10621c,(%esp)
  100bd7:	e8 60 f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bdc:	c7 04 24 44 62 10 00 	movl   $0x106244,(%esp)
  100be3:	e8 54 f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100be8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bec:	74 0b                	je     100bf9 <kmonitor+0x2f>
        print_trapframe(tf);
  100bee:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf1:	89 04 24             	mov    %eax,(%esp)
  100bf4:	e8 a4 0e 00 00       	call   101a9d <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bf9:	c7 04 24 69 62 10 00 	movl   $0x106269,(%esp)
  100c00:	e8 2e f6 ff ff       	call   100233 <readline>
  100c05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c0c:	74 18                	je     100c26 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c11:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c18:	89 04 24             	mov    %eax,(%esp)
  100c1b:	e8 f8 fe ff ff       	call   100b18 <runcmd>
  100c20:	85 c0                	test   %eax,%eax
  100c22:	79 02                	jns    100c26 <kmonitor+0x5c>
                break;
  100c24:	eb 02                	jmp    100c28 <kmonitor+0x5e>
            }
        }
    }
  100c26:	eb d1                	jmp    100bf9 <kmonitor+0x2f>
}
  100c28:	c9                   	leave  
  100c29:	c3                   	ret    

00100c2a <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c2a:	55                   	push   %ebp
  100c2b:	89 e5                	mov    %esp,%ebp
  100c2d:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c37:	eb 3f                	jmp    100c78 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c39:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c3c:	89 d0                	mov    %edx,%eax
  100c3e:	01 c0                	add    %eax,%eax
  100c40:	01 d0                	add    %edx,%eax
  100c42:	c1 e0 02             	shl    $0x2,%eax
  100c45:	05 20 70 11 00       	add    $0x117020,%eax
  100c4a:	8b 48 04             	mov    0x4(%eax),%ecx
  100c4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c50:	89 d0                	mov    %edx,%eax
  100c52:	01 c0                	add    %eax,%eax
  100c54:	01 d0                	add    %edx,%eax
  100c56:	c1 e0 02             	shl    $0x2,%eax
  100c59:	05 20 70 11 00       	add    $0x117020,%eax
  100c5e:	8b 00                	mov    (%eax),%eax
  100c60:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c64:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c68:	c7 04 24 6d 62 10 00 	movl   $0x10626d,(%esp)
  100c6f:	e8 c8 f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c74:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c7b:	83 f8 02             	cmp    $0x2,%eax
  100c7e:	76 b9                	jbe    100c39 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c85:	c9                   	leave  
  100c86:	c3                   	ret    

00100c87 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c87:	55                   	push   %ebp
  100c88:	89 e5                	mov    %esp,%ebp
  100c8a:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c8d:	e8 de fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100c92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c97:	c9                   	leave  
  100c98:	c3                   	ret    

00100c99 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c99:	55                   	push   %ebp
  100c9a:	89 e5                	mov    %esp,%ebp
  100c9c:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c9f:	e8 16 fd ff ff       	call   1009ba <print_stackframe>
    return 0;
  100ca4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca9:	c9                   	leave  
  100caa:	c3                   	ret    

00100cab <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cab:	55                   	push   %ebp
  100cac:	89 e5                	mov    %esp,%ebp
  100cae:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cb1:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100cb6:	85 c0                	test   %eax,%eax
  100cb8:	74 02                	je     100cbc <__panic+0x11>
        goto panic_dead;
  100cba:	eb 48                	jmp    100d04 <__panic+0x59>
    }
    is_panic = 1;
  100cbc:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100cc3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cc6:	8d 45 14             	lea    0x14(%ebp),%eax
  100cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ccf:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  100cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cda:	c7 04 24 76 62 10 00 	movl   $0x106276,(%esp)
  100ce1:	e8 56 f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ced:	8b 45 10             	mov    0x10(%ebp),%eax
  100cf0:	89 04 24             	mov    %eax,(%esp)
  100cf3:	e8 11 f6 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100cf8:	c7 04 24 92 62 10 00 	movl   $0x106292,(%esp)
  100cff:	e8 38 f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d04:	e8 85 09 00 00       	call   10168e <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d10:	e8 b5 fe ff ff       	call   100bca <kmonitor>
    }
  100d15:	eb f2                	jmp    100d09 <__panic+0x5e>

00100d17 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d17:	55                   	push   %ebp
  100d18:	89 e5                	mov    %esp,%ebp
  100d1a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d1d:	8d 45 14             	lea    0x14(%ebp),%eax
  100d20:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d23:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d26:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  100d2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d31:	c7 04 24 94 62 10 00 	movl   $0x106294,(%esp)
  100d38:	e8 ff f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d40:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d44:	8b 45 10             	mov    0x10(%ebp),%eax
  100d47:	89 04 24             	mov    %eax,(%esp)
  100d4a:	e8 ba f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d4f:	c7 04 24 92 62 10 00 	movl   $0x106292,(%esp)
  100d56:	e8 e1 f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d5b:	c9                   	leave  
  100d5c:	c3                   	ret    

00100d5d <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d5d:	55                   	push   %ebp
  100d5e:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d60:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d65:	5d                   	pop    %ebp
  100d66:	c3                   	ret    

00100d67 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d67:	55                   	push   %ebp
  100d68:	89 e5                	mov    %esp,%ebp
  100d6a:	83 ec 28             	sub    $0x28,%esp
  100d6d:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d73:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d77:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d7b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d7f:	ee                   	out    %al,(%dx)
  100d80:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d86:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d8a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d8e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d92:	ee                   	out    %al,(%dx)
  100d93:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d99:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d9d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100da1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100da5:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100da6:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100dad:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100db0:	c7 04 24 b2 62 10 00 	movl   $0x1062b2,(%esp)
  100db7:	e8 80 f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100dbc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dc3:	e8 24 09 00 00       	call   1016ec <pic_enable>
}
  100dc8:	c9                   	leave  
  100dc9:	c3                   	ret    

00100dca <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dca:	55                   	push   %ebp
  100dcb:	89 e5                	mov    %esp,%ebp
  100dcd:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100dd0:	9c                   	pushf  
  100dd1:	58                   	pop    %eax
  100dd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100dd8:	25 00 02 00 00       	and    $0x200,%eax
  100ddd:	85 c0                	test   %eax,%eax
  100ddf:	74 0c                	je     100ded <__intr_save+0x23>
        intr_disable();
  100de1:	e8 a8 08 00 00       	call   10168e <intr_disable>
        return 1;
  100de6:	b8 01 00 00 00       	mov    $0x1,%eax
  100deb:	eb 05                	jmp    100df2 <__intr_save+0x28>
    }
    return 0;
  100ded:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100df2:	c9                   	leave  
  100df3:	c3                   	ret    

00100df4 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100df4:	55                   	push   %ebp
  100df5:	89 e5                	mov    %esp,%ebp
  100df7:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100dfa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100dfe:	74 05                	je     100e05 <__intr_restore+0x11>
        intr_enable();
  100e00:	e8 83 08 00 00       	call   101688 <intr_enable>
    }
}
  100e05:	c9                   	leave  
  100e06:	c3                   	ret    

00100e07 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e07:	55                   	push   %ebp
  100e08:	89 e5                	mov    %esp,%ebp
  100e0a:	83 ec 10             	sub    $0x10,%esp
  100e0d:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e13:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e17:	89 c2                	mov    %eax,%edx
  100e19:	ec                   	in     (%dx),%al
  100e1a:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e1d:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e23:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e27:	89 c2                	mov    %eax,%edx
  100e29:	ec                   	in     (%dx),%al
  100e2a:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e2d:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e33:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e37:	89 c2                	mov    %eax,%edx
  100e39:	ec                   	in     (%dx),%al
  100e3a:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e3d:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e43:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e47:	89 c2                	mov    %eax,%edx
  100e49:	ec                   	in     (%dx),%al
  100e4a:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e4d:	c9                   	leave  
  100e4e:	c3                   	ret    

00100e4f <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e4f:	55                   	push   %ebp
  100e50:	89 e5                	mov    %esp,%ebp
  100e52:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e55:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e5f:	0f b7 00             	movzwl (%eax),%eax
  100e62:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e69:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e71:	0f b7 00             	movzwl (%eax),%eax
  100e74:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e78:	74 12                	je     100e8c <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e7a:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e81:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100e88:	b4 03 
  100e8a:	eb 13                	jmp    100e9f <cga_init+0x50>
    } else {
        *cp = was;
  100e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e93:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e96:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100e9d:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e9f:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ea6:	0f b7 c0             	movzwl %ax,%eax
  100ea9:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ead:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100eb1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100eb5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100eb9:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100eba:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ec1:	83 c0 01             	add    $0x1,%eax
  100ec4:	0f b7 c0             	movzwl %ax,%eax
  100ec7:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ecb:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ecf:	89 c2                	mov    %eax,%edx
  100ed1:	ec                   	in     (%dx),%al
  100ed2:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ed5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ed9:	0f b6 c0             	movzbl %al,%eax
  100edc:	c1 e0 08             	shl    $0x8,%eax
  100edf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ee2:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ee9:	0f b7 c0             	movzwl %ax,%eax
  100eec:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100ef0:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ef4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ef8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100efc:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100efd:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f04:	83 c0 01             	add    $0x1,%eax
  100f07:	0f b7 c0             	movzwl %ax,%eax
  100f0a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f0e:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f12:	89 c2                	mov    %eax,%edx
  100f14:	ec                   	in     (%dx),%al
  100f15:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f18:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f1c:	0f b6 c0             	movzbl %al,%eax
  100f1f:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f25:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f2d:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f33:	c9                   	leave  
  100f34:	c3                   	ret    

00100f35 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f35:	55                   	push   %ebp
  100f36:	89 e5                	mov    %esp,%ebp
  100f38:	83 ec 48             	sub    $0x48,%esp
  100f3b:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f41:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f45:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f49:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f4d:	ee                   	out    %al,(%dx)
  100f4e:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f54:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f58:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f5c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f60:	ee                   	out    %al,(%dx)
  100f61:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f67:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f6b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f6f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f73:	ee                   	out    %al,(%dx)
  100f74:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f7a:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f7e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f82:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f86:	ee                   	out    %al,(%dx)
  100f87:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f8d:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f91:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f95:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f99:	ee                   	out    %al,(%dx)
  100f9a:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fa0:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fa4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fa8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fac:	ee                   	out    %al,(%dx)
  100fad:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fb3:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fb7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fbb:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fbf:	ee                   	out    %al,(%dx)
  100fc0:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fc6:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fca:	89 c2                	mov    %eax,%edx
  100fcc:	ec                   	in     (%dx),%al
  100fcd:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100fd0:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fd4:	3c ff                	cmp    $0xff,%al
  100fd6:	0f 95 c0             	setne  %al
  100fd9:	0f b6 c0             	movzbl %al,%eax
  100fdc:	a3 88 7e 11 00       	mov    %eax,0x117e88
  100fe1:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fe7:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100feb:	89 c2                	mov    %eax,%edx
  100fed:	ec                   	in     (%dx),%al
  100fee:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100ff1:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100ff7:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100ffb:	89 c2                	mov    %eax,%edx
  100ffd:	ec                   	in     (%dx),%al
  100ffe:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101001:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101006:	85 c0                	test   %eax,%eax
  101008:	74 0c                	je     101016 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  10100a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101011:	e8 d6 06 00 00       	call   1016ec <pic_enable>
    }
}
  101016:	c9                   	leave  
  101017:	c3                   	ret    

00101018 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101018:	55                   	push   %ebp
  101019:	89 e5                	mov    %esp,%ebp
  10101b:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10101e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101025:	eb 09                	jmp    101030 <lpt_putc_sub+0x18>
        delay();
  101027:	e8 db fd ff ff       	call   100e07 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10102c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101030:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101036:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10103a:	89 c2                	mov    %eax,%edx
  10103c:	ec                   	in     (%dx),%al
  10103d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101040:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101044:	84 c0                	test   %al,%al
  101046:	78 09                	js     101051 <lpt_putc_sub+0x39>
  101048:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10104f:	7e d6                	jle    101027 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101051:	8b 45 08             	mov    0x8(%ebp),%eax
  101054:	0f b6 c0             	movzbl %al,%eax
  101057:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  10105d:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101060:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101064:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101068:	ee                   	out    %al,(%dx)
  101069:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10106f:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101073:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101077:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10107b:	ee                   	out    %al,(%dx)
  10107c:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  101082:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  101086:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10108a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10108e:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10108f:	c9                   	leave  
  101090:	c3                   	ret    

00101091 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101091:	55                   	push   %ebp
  101092:	89 e5                	mov    %esp,%ebp
  101094:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101097:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10109b:	74 0d                	je     1010aa <lpt_putc+0x19>
        lpt_putc_sub(c);
  10109d:	8b 45 08             	mov    0x8(%ebp),%eax
  1010a0:	89 04 24             	mov    %eax,(%esp)
  1010a3:	e8 70 ff ff ff       	call   101018 <lpt_putc_sub>
  1010a8:	eb 24                	jmp    1010ce <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010aa:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010b1:	e8 62 ff ff ff       	call   101018 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010b6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010bd:	e8 56 ff ff ff       	call   101018 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010c2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010c9:	e8 4a ff ff ff       	call   101018 <lpt_putc_sub>
    }
}
  1010ce:	c9                   	leave  
  1010cf:	c3                   	ret    

001010d0 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010d0:	55                   	push   %ebp
  1010d1:	89 e5                	mov    %esp,%ebp
  1010d3:	53                   	push   %ebx
  1010d4:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1010da:	b0 00                	mov    $0x0,%al
  1010dc:	85 c0                	test   %eax,%eax
  1010de:	75 07                	jne    1010e7 <cga_putc+0x17>
        c |= 0x0700;
  1010e0:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ea:	0f b6 c0             	movzbl %al,%eax
  1010ed:	83 f8 0a             	cmp    $0xa,%eax
  1010f0:	74 4c                	je     10113e <cga_putc+0x6e>
  1010f2:	83 f8 0d             	cmp    $0xd,%eax
  1010f5:	74 57                	je     10114e <cga_putc+0x7e>
  1010f7:	83 f8 08             	cmp    $0x8,%eax
  1010fa:	0f 85 88 00 00 00    	jne    101188 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101100:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101107:	66 85 c0             	test   %ax,%ax
  10110a:	74 30                	je     10113c <cga_putc+0x6c>
            crt_pos --;
  10110c:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101113:	83 e8 01             	sub    $0x1,%eax
  101116:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10111c:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101121:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  101128:	0f b7 d2             	movzwl %dx,%edx
  10112b:	01 d2                	add    %edx,%edx
  10112d:	01 c2                	add    %eax,%edx
  10112f:	8b 45 08             	mov    0x8(%ebp),%eax
  101132:	b0 00                	mov    $0x0,%al
  101134:	83 c8 20             	or     $0x20,%eax
  101137:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10113a:	eb 72                	jmp    1011ae <cga_putc+0xde>
  10113c:	eb 70                	jmp    1011ae <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  10113e:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101145:	83 c0 50             	add    $0x50,%eax
  101148:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  10114e:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  101155:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  10115c:	0f b7 c1             	movzwl %cx,%eax
  10115f:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101165:	c1 e8 10             	shr    $0x10,%eax
  101168:	89 c2                	mov    %eax,%edx
  10116a:	66 c1 ea 06          	shr    $0x6,%dx
  10116e:	89 d0                	mov    %edx,%eax
  101170:	c1 e0 02             	shl    $0x2,%eax
  101173:	01 d0                	add    %edx,%eax
  101175:	c1 e0 04             	shl    $0x4,%eax
  101178:	29 c1                	sub    %eax,%ecx
  10117a:	89 ca                	mov    %ecx,%edx
  10117c:	89 d8                	mov    %ebx,%eax
  10117e:	29 d0                	sub    %edx,%eax
  101180:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  101186:	eb 26                	jmp    1011ae <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101188:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  10118e:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101195:	8d 50 01             	lea    0x1(%eax),%edx
  101198:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  10119f:	0f b7 c0             	movzwl %ax,%eax
  1011a2:	01 c0                	add    %eax,%eax
  1011a4:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1011aa:	66 89 02             	mov    %ax,(%edx)
        break;
  1011ad:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011ae:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011b5:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011b9:	76 5b                	jbe    101216 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011bb:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011c0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011c6:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011cb:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011d2:	00 
  1011d3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011d7:	89 04 24             	mov    %eax,(%esp)
  1011da:	e8 6c 4c 00 00       	call   105e4b <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011df:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011e6:	eb 15                	jmp    1011fd <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011e8:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011f0:	01 d2                	add    %edx,%edx
  1011f2:	01 d0                	add    %edx,%eax
  1011f4:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011f9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011fd:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101204:	7e e2                	jle    1011e8 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101206:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10120d:	83 e8 50             	sub    $0x50,%eax
  101210:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101216:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10121d:	0f b7 c0             	movzwl %ax,%eax
  101220:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101224:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101228:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10122c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101230:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101231:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101238:	66 c1 e8 08          	shr    $0x8,%ax
  10123c:	0f b6 c0             	movzbl %al,%eax
  10123f:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101246:	83 c2 01             	add    $0x1,%edx
  101249:	0f b7 d2             	movzwl %dx,%edx
  10124c:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101250:	88 45 ed             	mov    %al,-0x13(%ebp)
  101253:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101257:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10125b:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10125c:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101263:	0f b7 c0             	movzwl %ax,%eax
  101266:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10126a:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  10126e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101272:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101276:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101277:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10127e:	0f b6 c0             	movzbl %al,%eax
  101281:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101288:	83 c2 01             	add    $0x1,%edx
  10128b:	0f b7 d2             	movzwl %dx,%edx
  10128e:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101292:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101295:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101299:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10129d:	ee                   	out    %al,(%dx)
}
  10129e:	83 c4 34             	add    $0x34,%esp
  1012a1:	5b                   	pop    %ebx
  1012a2:	5d                   	pop    %ebp
  1012a3:	c3                   	ret    

001012a4 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012a4:	55                   	push   %ebp
  1012a5:	89 e5                	mov    %esp,%ebp
  1012a7:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012b1:	eb 09                	jmp    1012bc <serial_putc_sub+0x18>
        delay();
  1012b3:	e8 4f fb ff ff       	call   100e07 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012b8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012bc:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012c2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012c6:	89 c2                	mov    %eax,%edx
  1012c8:	ec                   	in     (%dx),%al
  1012c9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012cc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012d0:	0f b6 c0             	movzbl %al,%eax
  1012d3:	83 e0 20             	and    $0x20,%eax
  1012d6:	85 c0                	test   %eax,%eax
  1012d8:	75 09                	jne    1012e3 <serial_putc_sub+0x3f>
  1012da:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012e1:	7e d0                	jle    1012b3 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1012e6:	0f b6 c0             	movzbl %al,%eax
  1012e9:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012ef:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012f2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012f6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012fa:	ee                   	out    %al,(%dx)
}
  1012fb:	c9                   	leave  
  1012fc:	c3                   	ret    

001012fd <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012fd:	55                   	push   %ebp
  1012fe:	89 e5                	mov    %esp,%ebp
  101300:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101303:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101307:	74 0d                	je     101316 <serial_putc+0x19>
        serial_putc_sub(c);
  101309:	8b 45 08             	mov    0x8(%ebp),%eax
  10130c:	89 04 24             	mov    %eax,(%esp)
  10130f:	e8 90 ff ff ff       	call   1012a4 <serial_putc_sub>
  101314:	eb 24                	jmp    10133a <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101316:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10131d:	e8 82 ff ff ff       	call   1012a4 <serial_putc_sub>
        serial_putc_sub(' ');
  101322:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101329:	e8 76 ff ff ff       	call   1012a4 <serial_putc_sub>
        serial_putc_sub('\b');
  10132e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101335:	e8 6a ff ff ff       	call   1012a4 <serial_putc_sub>
    }
}
  10133a:	c9                   	leave  
  10133b:	c3                   	ret    

0010133c <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10133c:	55                   	push   %ebp
  10133d:	89 e5                	mov    %esp,%ebp
  10133f:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101342:	eb 33                	jmp    101377 <cons_intr+0x3b>
        if (c != 0) {
  101344:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101348:	74 2d                	je     101377 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10134a:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  10134f:	8d 50 01             	lea    0x1(%eax),%edx
  101352:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  101358:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10135b:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101361:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101366:	3d 00 02 00 00       	cmp    $0x200,%eax
  10136b:	75 0a                	jne    101377 <cons_intr+0x3b>
                cons.wpos = 0;
  10136d:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  101374:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101377:	8b 45 08             	mov    0x8(%ebp),%eax
  10137a:	ff d0                	call   *%eax
  10137c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10137f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101383:	75 bf                	jne    101344 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101385:	c9                   	leave  
  101386:	c3                   	ret    

00101387 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101387:	55                   	push   %ebp
  101388:	89 e5                	mov    %esp,%ebp
  10138a:	83 ec 10             	sub    $0x10,%esp
  10138d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101393:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101397:	89 c2                	mov    %eax,%edx
  101399:	ec                   	in     (%dx),%al
  10139a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10139d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013a1:	0f b6 c0             	movzbl %al,%eax
  1013a4:	83 e0 01             	and    $0x1,%eax
  1013a7:	85 c0                	test   %eax,%eax
  1013a9:	75 07                	jne    1013b2 <serial_proc_data+0x2b>
        return -1;
  1013ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013b0:	eb 2a                	jmp    1013dc <serial_proc_data+0x55>
  1013b2:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013b8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013bc:	89 c2                	mov    %eax,%edx
  1013be:	ec                   	in     (%dx),%al
  1013bf:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013c2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013c6:	0f b6 c0             	movzbl %al,%eax
  1013c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013cc:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013d0:	75 07                	jne    1013d9 <serial_proc_data+0x52>
        c = '\b';
  1013d2:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013dc:	c9                   	leave  
  1013dd:	c3                   	ret    

001013de <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013de:	55                   	push   %ebp
  1013df:	89 e5                	mov    %esp,%ebp
  1013e1:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013e4:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1013e9:	85 c0                	test   %eax,%eax
  1013eb:	74 0c                	je     1013f9 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013ed:	c7 04 24 87 13 10 00 	movl   $0x101387,(%esp)
  1013f4:	e8 43 ff ff ff       	call   10133c <cons_intr>
    }
}
  1013f9:	c9                   	leave  
  1013fa:	c3                   	ret    

001013fb <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013fb:	55                   	push   %ebp
  1013fc:	89 e5                	mov    %esp,%ebp
  1013fe:	83 ec 38             	sub    $0x38,%esp
  101401:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101407:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10140b:	89 c2                	mov    %eax,%edx
  10140d:	ec                   	in     (%dx),%al
  10140e:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101411:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101415:	0f b6 c0             	movzbl %al,%eax
  101418:	83 e0 01             	and    $0x1,%eax
  10141b:	85 c0                	test   %eax,%eax
  10141d:	75 0a                	jne    101429 <kbd_proc_data+0x2e>
        return -1;
  10141f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101424:	e9 59 01 00 00       	jmp    101582 <kbd_proc_data+0x187>
  101429:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10142f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101433:	89 c2                	mov    %eax,%edx
  101435:	ec                   	in     (%dx),%al
  101436:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101439:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10143d:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101440:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101444:	75 17                	jne    10145d <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101446:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10144b:	83 c8 40             	or     $0x40,%eax
  10144e:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101453:	b8 00 00 00 00       	mov    $0x0,%eax
  101458:	e9 25 01 00 00       	jmp    101582 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10145d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101461:	84 c0                	test   %al,%al
  101463:	79 47                	jns    1014ac <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101465:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10146a:	83 e0 40             	and    $0x40,%eax
  10146d:	85 c0                	test   %eax,%eax
  10146f:	75 09                	jne    10147a <kbd_proc_data+0x7f>
  101471:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101475:	83 e0 7f             	and    $0x7f,%eax
  101478:	eb 04                	jmp    10147e <kbd_proc_data+0x83>
  10147a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147e:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101481:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101485:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  10148c:	83 c8 40             	or     $0x40,%eax
  10148f:	0f b6 c0             	movzbl %al,%eax
  101492:	f7 d0                	not    %eax
  101494:	89 c2                	mov    %eax,%edx
  101496:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10149b:	21 d0                	and    %edx,%eax
  10149d:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014a2:	b8 00 00 00 00       	mov    $0x0,%eax
  1014a7:	e9 d6 00 00 00       	jmp    101582 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014ac:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014b1:	83 e0 40             	and    $0x40,%eax
  1014b4:	85 c0                	test   %eax,%eax
  1014b6:	74 11                	je     1014c9 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014b8:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014bc:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014c1:	83 e0 bf             	and    $0xffffffbf,%eax
  1014c4:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014c9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014cd:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014d4:	0f b6 d0             	movzbl %al,%edx
  1014d7:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014dc:	09 d0                	or     %edx,%eax
  1014de:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  1014e3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e7:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  1014ee:	0f b6 d0             	movzbl %al,%edx
  1014f1:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014f6:	31 d0                	xor    %edx,%eax
  1014f8:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  1014fd:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101502:	83 e0 03             	and    $0x3,%eax
  101505:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  10150c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101510:	01 d0                	add    %edx,%eax
  101512:	0f b6 00             	movzbl (%eax),%eax
  101515:	0f b6 c0             	movzbl %al,%eax
  101518:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10151b:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101520:	83 e0 08             	and    $0x8,%eax
  101523:	85 c0                	test   %eax,%eax
  101525:	74 22                	je     101549 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101527:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10152b:	7e 0c                	jle    101539 <kbd_proc_data+0x13e>
  10152d:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101531:	7f 06                	jg     101539 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101533:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101537:	eb 10                	jmp    101549 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101539:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10153d:	7e 0a                	jle    101549 <kbd_proc_data+0x14e>
  10153f:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101543:	7f 04                	jg     101549 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101545:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101549:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10154e:	f7 d0                	not    %eax
  101550:	83 e0 06             	and    $0x6,%eax
  101553:	85 c0                	test   %eax,%eax
  101555:	75 28                	jne    10157f <kbd_proc_data+0x184>
  101557:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10155e:	75 1f                	jne    10157f <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101560:	c7 04 24 cd 62 10 00 	movl   $0x1062cd,(%esp)
  101567:	e8 d0 ed ff ff       	call   10033c <cprintf>
  10156c:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101572:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101576:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10157a:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  10157e:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10157f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101582:	c9                   	leave  
  101583:	c3                   	ret    

00101584 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101584:	55                   	push   %ebp
  101585:	89 e5                	mov    %esp,%ebp
  101587:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10158a:	c7 04 24 fb 13 10 00 	movl   $0x1013fb,(%esp)
  101591:	e8 a6 fd ff ff       	call   10133c <cons_intr>
}
  101596:	c9                   	leave  
  101597:	c3                   	ret    

00101598 <kbd_init>:

static void
kbd_init(void) {
  101598:	55                   	push   %ebp
  101599:	89 e5                	mov    %esp,%ebp
  10159b:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10159e:	e8 e1 ff ff ff       	call   101584 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015aa:	e8 3d 01 00 00       	call   1016ec <pic_enable>
}
  1015af:	c9                   	leave  
  1015b0:	c3                   	ret    

001015b1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015b1:	55                   	push   %ebp
  1015b2:	89 e5                	mov    %esp,%ebp
  1015b4:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015b7:	e8 93 f8 ff ff       	call   100e4f <cga_init>
    serial_init();
  1015bc:	e8 74 f9 ff ff       	call   100f35 <serial_init>
    kbd_init();
  1015c1:	e8 d2 ff ff ff       	call   101598 <kbd_init>
    if (!serial_exists) {
  1015c6:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015cb:	85 c0                	test   %eax,%eax
  1015cd:	75 0c                	jne    1015db <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015cf:	c7 04 24 d9 62 10 00 	movl   $0x1062d9,(%esp)
  1015d6:	e8 61 ed ff ff       	call   10033c <cprintf>
    }
}
  1015db:	c9                   	leave  
  1015dc:	c3                   	ret    

001015dd <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015dd:	55                   	push   %ebp
  1015de:	89 e5                	mov    %esp,%ebp
  1015e0:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1015e3:	e8 e2 f7 ff ff       	call   100dca <__intr_save>
  1015e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1015eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1015ee:	89 04 24             	mov    %eax,(%esp)
  1015f1:	e8 9b fa ff ff       	call   101091 <lpt_putc>
        cga_putc(c);
  1015f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1015f9:	89 04 24             	mov    %eax,(%esp)
  1015fc:	e8 cf fa ff ff       	call   1010d0 <cga_putc>
        serial_putc(c);
  101601:	8b 45 08             	mov    0x8(%ebp),%eax
  101604:	89 04 24             	mov    %eax,(%esp)
  101607:	e8 f1 fc ff ff       	call   1012fd <serial_putc>
    }
    local_intr_restore(intr_flag);
  10160c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10160f:	89 04 24             	mov    %eax,(%esp)
  101612:	e8 dd f7 ff ff       	call   100df4 <__intr_restore>
}
  101617:	c9                   	leave  
  101618:	c3                   	ret    

00101619 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101619:	55                   	push   %ebp
  10161a:	89 e5                	mov    %esp,%ebp
  10161c:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10161f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101626:	e8 9f f7 ff ff       	call   100dca <__intr_save>
  10162b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10162e:	e8 ab fd ff ff       	call   1013de <serial_intr>
        kbd_intr();
  101633:	e8 4c ff ff ff       	call   101584 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101638:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  10163e:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101643:	39 c2                	cmp    %eax,%edx
  101645:	74 31                	je     101678 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101647:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  10164c:	8d 50 01             	lea    0x1(%eax),%edx
  10164f:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  101655:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  10165c:	0f b6 c0             	movzbl %al,%eax
  10165f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101662:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101667:	3d 00 02 00 00       	cmp    $0x200,%eax
  10166c:	75 0a                	jne    101678 <cons_getc+0x5f>
                cons.rpos = 0;
  10166e:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  101675:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101678:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10167b:	89 04 24             	mov    %eax,(%esp)
  10167e:	e8 71 f7 ff ff       	call   100df4 <__intr_restore>
    return c;
  101683:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101686:	c9                   	leave  
  101687:	c3                   	ret    

00101688 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101688:	55                   	push   %ebp
  101689:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  10168b:	fb                   	sti    
    sti();
}
  10168c:	5d                   	pop    %ebp
  10168d:	c3                   	ret    

0010168e <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10168e:	55                   	push   %ebp
  10168f:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  101691:	fa                   	cli    
    cli();
}
  101692:	5d                   	pop    %ebp
  101693:	c3                   	ret    

00101694 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101694:	55                   	push   %ebp
  101695:	89 e5                	mov    %esp,%ebp
  101697:	83 ec 14             	sub    $0x14,%esp
  10169a:	8b 45 08             	mov    0x8(%ebp),%eax
  10169d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016a1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016a5:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016ab:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016b0:	85 c0                	test   %eax,%eax
  1016b2:	74 36                	je     1016ea <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016b4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016b8:	0f b6 c0             	movzbl %al,%eax
  1016bb:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016c1:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016c4:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016c8:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016cc:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016cd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016d1:	66 c1 e8 08          	shr    $0x8,%ax
  1016d5:	0f b6 c0             	movzbl %al,%eax
  1016d8:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016de:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016e1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016e5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016e9:	ee                   	out    %al,(%dx)
    }
}
  1016ea:	c9                   	leave  
  1016eb:	c3                   	ret    

001016ec <pic_enable>:

void
pic_enable(unsigned int irq) {
  1016ec:	55                   	push   %ebp
  1016ed:	89 e5                	mov    %esp,%ebp
  1016ef:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1016f5:	ba 01 00 00 00       	mov    $0x1,%edx
  1016fa:	89 c1                	mov    %eax,%ecx
  1016fc:	d3 e2                	shl    %cl,%edx
  1016fe:	89 d0                	mov    %edx,%eax
  101700:	f7 d0                	not    %eax
  101702:	89 c2                	mov    %eax,%edx
  101704:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10170b:	21 d0                	and    %edx,%eax
  10170d:	0f b7 c0             	movzwl %ax,%eax
  101710:	89 04 24             	mov    %eax,(%esp)
  101713:	e8 7c ff ff ff       	call   101694 <pic_setmask>
}
  101718:	c9                   	leave  
  101719:	c3                   	ret    

0010171a <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10171a:	55                   	push   %ebp
  10171b:	89 e5                	mov    %esp,%ebp
  10171d:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101720:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101727:	00 00 00 
  10172a:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101730:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101734:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101738:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10173c:	ee                   	out    %al,(%dx)
  10173d:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101743:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101747:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10174b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10174f:	ee                   	out    %al,(%dx)
  101750:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101756:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  10175a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10175e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101762:	ee                   	out    %al,(%dx)
  101763:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  101769:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10176d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101771:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101775:	ee                   	out    %al,(%dx)
  101776:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10177c:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101780:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101784:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101788:	ee                   	out    %al,(%dx)
  101789:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  10178f:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101793:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101797:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10179b:	ee                   	out    %al,(%dx)
  10179c:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017a2:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017a6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017aa:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017ae:	ee                   	out    %al,(%dx)
  1017af:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017b5:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017b9:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017bd:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017c1:	ee                   	out    %al,(%dx)
  1017c2:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017c8:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017cc:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017d0:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017d4:	ee                   	out    %al,(%dx)
  1017d5:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017db:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  1017df:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  1017e3:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017e7:	ee                   	out    %al,(%dx)
  1017e8:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  1017ee:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  1017f2:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1017f6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1017fa:	ee                   	out    %al,(%dx)
  1017fb:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101801:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101805:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101809:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10180d:	ee                   	out    %al,(%dx)
  10180e:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101814:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101818:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10181c:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101820:	ee                   	out    %al,(%dx)
  101821:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101827:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  10182b:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  10182f:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101833:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101834:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10183b:	66 83 f8 ff          	cmp    $0xffff,%ax
  10183f:	74 12                	je     101853 <pic_init+0x139>
        pic_setmask(irq_mask);
  101841:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  101848:	0f b7 c0             	movzwl %ax,%eax
  10184b:	89 04 24             	mov    %eax,(%esp)
  10184e:	e8 41 fe ff ff       	call   101694 <pic_setmask>
    }
}
  101853:	c9                   	leave  
  101854:	c3                   	ret    

00101855 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101855:	55                   	push   %ebp
  101856:	89 e5                	mov    %esp,%ebp
  101858:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10185b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101862:	00 
  101863:	c7 04 24 00 63 10 00 	movl   $0x106300,(%esp)
  10186a:	e8 cd ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  10186f:	c7 04 24 0a 63 10 00 	movl   $0x10630a,(%esp)
  101876:	e8 c1 ea ff ff       	call   10033c <cprintf>
    panic("EOT: kernel seems ok.");
  10187b:	c7 44 24 08 18 63 10 	movl   $0x106318,0x8(%esp)
  101882:	00 
  101883:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  10188a:	00 
  10188b:	c7 04 24 2e 63 10 00 	movl   $0x10632e,(%esp)
  101892:	e8 14 f4 ff ff       	call   100cab <__panic>

00101897 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101897:	55                   	push   %ebp
  101898:	89 e5                	mov    %esp,%ebp
  10189a:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for(i=0; i < 256 ; i++){
  10189d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018a4:	e9 91 01 00 00       	jmp    101a3a <idt_init+0x1a3>
        if(i != T_SWITCH_TOK){
  1018a9:	83 7d fc 79          	cmpl   $0x79,-0x4(%ebp)
  1018ad:	0f 84 c4 00 00 00    	je     101977 <idt_init+0xe0>
           SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL); 
  1018b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b6:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018bd:	89 c2                	mov    %eax,%edx
  1018bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c2:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018c9:	00 
  1018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018cd:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018d4:	00 08 00 
  1018d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018da:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018e1:	00 
  1018e2:	83 e2 e0             	and    $0xffffffe0,%edx
  1018e5:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ef:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018f6:	00 
  1018f7:	83 e2 1f             	and    $0x1f,%edx
  1018fa:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  101901:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101904:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10190b:	00 
  10190c:	83 e2 f0             	and    $0xfffffff0,%edx
  10190f:	83 ca 0e             	or     $0xe,%edx
  101912:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101919:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10191c:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101923:	00 
  101924:	83 e2 ef             	and    $0xffffffef,%edx
  101927:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10192e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101931:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101938:	00 
  101939:	83 e2 9f             	and    $0xffffff9f,%edx
  10193c:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101943:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101946:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10194d:	00 
  10194e:	83 ca 80             	or     $0xffffff80,%edx
  101951:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101958:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195b:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101962:	c1 e8 10             	shr    $0x10,%eax
  101965:	89 c2                	mov    %eax,%edx
  101967:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196a:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  101971:	00 
  101972:	e9 bf 00 00 00       	jmp    101a36 <idt_init+0x19f>
        } else{
            SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_USER);
  101977:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197a:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101981:	89 c2                	mov    %eax,%edx
  101983:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101986:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  10198d:	00 
  10198e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101991:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  101998:	00 08 00 
  10199b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10199e:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1019a5:	00 
  1019a6:	83 e2 e0             	and    $0xffffffe0,%edx
  1019a9:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1019b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b3:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1019ba:	00 
  1019bb:	83 e2 1f             	and    $0x1f,%edx
  1019be:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1019c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019c8:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  1019cf:	00 
  1019d0:	83 e2 f0             	and    $0xfffffff0,%edx
  1019d3:	83 ca 0e             	or     $0xe,%edx
  1019d6:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  1019dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e0:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  1019e7:	00 
  1019e8:	83 e2 ef             	and    $0xffffffef,%edx
  1019eb:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  1019f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019f5:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  1019fc:	00 
  1019fd:	83 ca 60             	or     $0x60,%edx
  101a00:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101a07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a0a:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101a11:	00 
  101a12:	83 ca 80             	or     $0xffffff80,%edx
  101a15:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101a1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a1f:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  101a26:	c1 e8 10             	shr    $0x10,%eax
  101a29:	89 c2                	mov    %eax,%edx
  101a2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a2e:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  101a35:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for(i=0; i < 256 ; i++){
  101a36:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101a3a:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101a41:	0f 8e 62 fe ff ff    	jle    1018a9 <idt_init+0x12>
  101a47:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a51:	0f 01 18             	lidtl  (%eax)
        } else{
            SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_USER);
        }
    }
    lidt(&idt_pd);
}
  101a54:	c9                   	leave  
  101a55:	c3                   	ret    

00101a56 <trapname>:

static const char *
trapname(int trapno) {
  101a56:	55                   	push   %ebp
  101a57:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a59:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5c:	83 f8 13             	cmp    $0x13,%eax
  101a5f:	77 0c                	ja     101a6d <trapname+0x17>
        return excnames[trapno];
  101a61:	8b 45 08             	mov    0x8(%ebp),%eax
  101a64:	8b 04 85 80 66 10 00 	mov    0x106680(,%eax,4),%eax
  101a6b:	eb 18                	jmp    101a85 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a6d:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a71:	7e 0d                	jle    101a80 <trapname+0x2a>
  101a73:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a77:	7f 07                	jg     101a80 <trapname+0x2a>
        return "Hardware Interrupt";
  101a79:	b8 3f 63 10 00       	mov    $0x10633f,%eax
  101a7e:	eb 05                	jmp    101a85 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a80:	b8 52 63 10 00       	mov    $0x106352,%eax
}
  101a85:	5d                   	pop    %ebp
  101a86:	c3                   	ret    

00101a87 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a87:	55                   	push   %ebp
  101a88:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a91:	66 83 f8 08          	cmp    $0x8,%ax
  101a95:	0f 94 c0             	sete   %al
  101a98:	0f b6 c0             	movzbl %al,%eax
}
  101a9b:	5d                   	pop    %ebp
  101a9c:	c3                   	ret    

00101a9d <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a9d:	55                   	push   %ebp
  101a9e:	89 e5                	mov    %esp,%ebp
  101aa0:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aaa:	c7 04 24 93 63 10 00 	movl   $0x106393,(%esp)
  101ab1:	e8 86 e8 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab9:	89 04 24             	mov    %eax,(%esp)
  101abc:	e8 a1 01 00 00       	call   101c62 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac4:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101ac8:	0f b7 c0             	movzwl %ax,%eax
  101acb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101acf:	c7 04 24 a4 63 10 00 	movl   $0x1063a4,(%esp)
  101ad6:	e8 61 e8 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101adb:	8b 45 08             	mov    0x8(%ebp),%eax
  101ade:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101ae2:	0f b7 c0             	movzwl %ax,%eax
  101ae5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae9:	c7 04 24 b7 63 10 00 	movl   $0x1063b7,(%esp)
  101af0:	e8 47 e8 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101af5:	8b 45 08             	mov    0x8(%ebp),%eax
  101af8:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101afc:	0f b7 c0             	movzwl %ax,%eax
  101aff:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b03:	c7 04 24 ca 63 10 00 	movl   $0x1063ca,(%esp)
  101b0a:	e8 2d e8 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b12:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b16:	0f b7 c0             	movzwl %ax,%eax
  101b19:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b1d:	c7 04 24 dd 63 10 00 	movl   $0x1063dd,(%esp)
  101b24:	e8 13 e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b29:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2c:	8b 40 30             	mov    0x30(%eax),%eax
  101b2f:	89 04 24             	mov    %eax,(%esp)
  101b32:	e8 1f ff ff ff       	call   101a56 <trapname>
  101b37:	8b 55 08             	mov    0x8(%ebp),%edx
  101b3a:	8b 52 30             	mov    0x30(%edx),%edx
  101b3d:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b41:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b45:	c7 04 24 f0 63 10 00 	movl   $0x1063f0,(%esp)
  101b4c:	e8 eb e7 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b51:	8b 45 08             	mov    0x8(%ebp),%eax
  101b54:	8b 40 34             	mov    0x34(%eax),%eax
  101b57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5b:	c7 04 24 02 64 10 00 	movl   $0x106402,(%esp)
  101b62:	e8 d5 e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b67:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6a:	8b 40 38             	mov    0x38(%eax),%eax
  101b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b71:	c7 04 24 11 64 10 00 	movl   $0x106411,(%esp)
  101b78:	e8 bf e7 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b80:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b84:	0f b7 c0             	movzwl %ax,%eax
  101b87:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b8b:	c7 04 24 20 64 10 00 	movl   $0x106420,(%esp)
  101b92:	e8 a5 e7 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b97:	8b 45 08             	mov    0x8(%ebp),%eax
  101b9a:	8b 40 40             	mov    0x40(%eax),%eax
  101b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba1:	c7 04 24 33 64 10 00 	movl   $0x106433,(%esp)
  101ba8:	e8 8f e7 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101bb4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101bbb:	eb 3e                	jmp    101bfb <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc0:	8b 50 40             	mov    0x40(%eax),%edx
  101bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101bc6:	21 d0                	and    %edx,%eax
  101bc8:	85 c0                	test   %eax,%eax
  101bca:	74 28                	je     101bf4 <print_trapframe+0x157>
  101bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bcf:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101bd6:	85 c0                	test   %eax,%eax
  101bd8:	74 1a                	je     101bf4 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bdd:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101be4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be8:	c7 04 24 42 64 10 00 	movl   $0x106442,(%esp)
  101bef:	e8 48 e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bf4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bf8:	d1 65 f0             	shll   -0x10(%ebp)
  101bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bfe:	83 f8 17             	cmp    $0x17,%eax
  101c01:	76 ba                	jbe    101bbd <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c03:	8b 45 08             	mov    0x8(%ebp),%eax
  101c06:	8b 40 40             	mov    0x40(%eax),%eax
  101c09:	25 00 30 00 00       	and    $0x3000,%eax
  101c0e:	c1 e8 0c             	shr    $0xc,%eax
  101c11:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c15:	c7 04 24 46 64 10 00 	movl   $0x106446,(%esp)
  101c1c:	e8 1b e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101c21:	8b 45 08             	mov    0x8(%ebp),%eax
  101c24:	89 04 24             	mov    %eax,(%esp)
  101c27:	e8 5b fe ff ff       	call   101a87 <trap_in_kernel>
  101c2c:	85 c0                	test   %eax,%eax
  101c2e:	75 30                	jne    101c60 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c30:	8b 45 08             	mov    0x8(%ebp),%eax
  101c33:	8b 40 44             	mov    0x44(%eax),%eax
  101c36:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3a:	c7 04 24 4f 64 10 00 	movl   $0x10644f,(%esp)
  101c41:	e8 f6 e6 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c46:	8b 45 08             	mov    0x8(%ebp),%eax
  101c49:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c4d:	0f b7 c0             	movzwl %ax,%eax
  101c50:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c54:	c7 04 24 5e 64 10 00 	movl   $0x10645e,(%esp)
  101c5b:	e8 dc e6 ff ff       	call   10033c <cprintf>
    }
}
  101c60:	c9                   	leave  
  101c61:	c3                   	ret    

00101c62 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c62:	55                   	push   %ebp
  101c63:	89 e5                	mov    %esp,%ebp
  101c65:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c68:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6b:	8b 00                	mov    (%eax),%eax
  101c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c71:	c7 04 24 71 64 10 00 	movl   $0x106471,(%esp)
  101c78:	e8 bf e6 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c80:	8b 40 04             	mov    0x4(%eax),%eax
  101c83:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c87:	c7 04 24 80 64 10 00 	movl   $0x106480,(%esp)
  101c8e:	e8 a9 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c93:	8b 45 08             	mov    0x8(%ebp),%eax
  101c96:	8b 40 08             	mov    0x8(%eax),%eax
  101c99:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9d:	c7 04 24 8f 64 10 00 	movl   $0x10648f,(%esp)
  101ca4:	e8 93 e6 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cac:	8b 40 0c             	mov    0xc(%eax),%eax
  101caf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb3:	c7 04 24 9e 64 10 00 	movl   $0x10649e,(%esp)
  101cba:	e8 7d e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc2:	8b 40 10             	mov    0x10(%eax),%eax
  101cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc9:	c7 04 24 ad 64 10 00 	movl   $0x1064ad,(%esp)
  101cd0:	e8 67 e6 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd8:	8b 40 14             	mov    0x14(%eax),%eax
  101cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cdf:	c7 04 24 bc 64 10 00 	movl   $0x1064bc,(%esp)
  101ce6:	e8 51 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101ceb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cee:	8b 40 18             	mov    0x18(%eax),%eax
  101cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf5:	c7 04 24 cb 64 10 00 	movl   $0x1064cb,(%esp)
  101cfc:	e8 3b e6 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d01:	8b 45 08             	mov    0x8(%ebp),%eax
  101d04:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d07:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d0b:	c7 04 24 da 64 10 00 	movl   $0x1064da,(%esp)
  101d12:	e8 25 e6 ff ff       	call   10033c <cprintf>
}
  101d17:	c9                   	leave  
  101d18:	c3                   	ret    

00101d19 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d19:	55                   	push   %ebp
  101d1a:	89 e5                	mov    %esp,%ebp
  101d1c:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  101d22:	8b 40 30             	mov    0x30(%eax),%eax
  101d25:	83 f8 2f             	cmp    $0x2f,%eax
  101d28:	77 21                	ja     101d4b <trap_dispatch+0x32>
  101d2a:	83 f8 2e             	cmp    $0x2e,%eax
  101d2d:	0f 83 04 01 00 00    	jae    101e37 <trap_dispatch+0x11e>
  101d33:	83 f8 21             	cmp    $0x21,%eax
  101d36:	0f 84 81 00 00 00    	je     101dbd <trap_dispatch+0xa4>
  101d3c:	83 f8 24             	cmp    $0x24,%eax
  101d3f:	74 56                	je     101d97 <trap_dispatch+0x7e>
  101d41:	83 f8 20             	cmp    $0x20,%eax
  101d44:	74 16                	je     101d5c <trap_dispatch+0x43>
  101d46:	e9 b4 00 00 00       	jmp    101dff <trap_dispatch+0xe6>
  101d4b:	83 e8 78             	sub    $0x78,%eax
  101d4e:	83 f8 01             	cmp    $0x1,%eax
  101d51:	0f 87 a8 00 00 00    	ja     101dff <trap_dispatch+0xe6>
  101d57:	e9 87 00 00 00       	jmp    101de3 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101d5c:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d61:	83 c0 01             	add    $0x1,%eax
  101d64:	a3 4c 89 11 00       	mov    %eax,0x11894c
        if (ticks % TICK_NUM == 0) {
  101d69:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101d6f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d74:	89 c8                	mov    %ecx,%eax
  101d76:	f7 e2                	mul    %edx
  101d78:	89 d0                	mov    %edx,%eax
  101d7a:	c1 e8 05             	shr    $0x5,%eax
  101d7d:	6b c0 64             	imul   $0x64,%eax,%eax
  101d80:	29 c1                	sub    %eax,%ecx
  101d82:	89 c8                	mov    %ecx,%eax
  101d84:	85 c0                	test   %eax,%eax
  101d86:	75 0a                	jne    101d92 <trap_dispatch+0x79>
            print_ticks();
  101d88:	e8 c8 fa ff ff       	call   101855 <print_ticks>
        }
        break;
  101d8d:	e9 a6 00 00 00       	jmp    101e38 <trap_dispatch+0x11f>
  101d92:	e9 a1 00 00 00       	jmp    101e38 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d97:	e8 7d f8 ff ff       	call   101619 <cons_getc>
  101d9c:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d9f:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101da3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101da7:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dab:	89 44 24 04          	mov    %eax,0x4(%esp)
  101daf:	c7 04 24 e9 64 10 00 	movl   $0x1064e9,(%esp)
  101db6:	e8 81 e5 ff ff       	call   10033c <cprintf>
        break;
  101dbb:	eb 7b                	jmp    101e38 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101dbd:	e8 57 f8 ff ff       	call   101619 <cons_getc>
  101dc2:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101dc5:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101dc9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101dcd:	89 54 24 08          	mov    %edx,0x8(%esp)
  101dd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101dd5:	c7 04 24 fb 64 10 00 	movl   $0x1064fb,(%esp)
  101ddc:	e8 5b e5 ff ff       	call   10033c <cprintf>
        break;
  101de1:	eb 55                	jmp    101e38 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101de3:	c7 44 24 08 0a 65 10 	movl   $0x10650a,0x8(%esp)
  101dea:	00 
  101deb:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  101df2:	00 
  101df3:	c7 04 24 2e 63 10 00 	movl   $0x10632e,(%esp)
  101dfa:	e8 ac ee ff ff       	call   100cab <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101dff:	8b 45 08             	mov    0x8(%ebp),%eax
  101e02:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e06:	0f b7 c0             	movzwl %ax,%eax
  101e09:	83 e0 03             	and    $0x3,%eax
  101e0c:	85 c0                	test   %eax,%eax
  101e0e:	75 28                	jne    101e38 <trap_dispatch+0x11f>
            print_trapframe(tf);
  101e10:	8b 45 08             	mov    0x8(%ebp),%eax
  101e13:	89 04 24             	mov    %eax,(%esp)
  101e16:	e8 82 fc ff ff       	call   101a9d <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e1b:	c7 44 24 08 1a 65 10 	movl   $0x10651a,0x8(%esp)
  101e22:	00 
  101e23:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  101e2a:	00 
  101e2b:	c7 04 24 2e 63 10 00 	movl   $0x10632e,(%esp)
  101e32:	e8 74 ee ff ff       	call   100cab <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e37:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e38:	c9                   	leave  
  101e39:	c3                   	ret    

00101e3a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e3a:	55                   	push   %ebp
  101e3b:	89 e5                	mov    %esp,%ebp
  101e3d:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e40:	8b 45 08             	mov    0x8(%ebp),%eax
  101e43:	89 04 24             	mov    %eax,(%esp)
  101e46:	e8 ce fe ff ff       	call   101d19 <trap_dispatch>
}
  101e4b:	c9                   	leave  
  101e4c:	c3                   	ret    

00101e4d <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e4d:	1e                   	push   %ds
    pushl %es
  101e4e:	06                   	push   %es
    pushl %fs
  101e4f:	0f a0                	push   %fs
    pushl %gs
  101e51:	0f a8                	push   %gs
    pushal
  101e53:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e54:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e59:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e5b:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e5d:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e5e:	e8 d7 ff ff ff       	call   101e3a <trap>

    # pop the pushed stack pointer
    popl %esp
  101e63:	5c                   	pop    %esp

00101e64 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e64:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e65:	0f a9                	pop    %gs
    popl %fs
  101e67:	0f a1                	pop    %fs
    popl %es
  101e69:	07                   	pop    %es
    popl %ds
  101e6a:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e6b:	83 c4 08             	add    $0x8,%esp
    iret
  101e6e:	cf                   	iret   

00101e6f <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e6f:	6a 00                	push   $0x0
  pushl $0
  101e71:	6a 00                	push   $0x0
  jmp __alltraps
  101e73:	e9 d5 ff ff ff       	jmp    101e4d <__alltraps>

00101e78 <vector1>:
.globl vector1
vector1:
  pushl $0
  101e78:	6a 00                	push   $0x0
  pushl $1
  101e7a:	6a 01                	push   $0x1
  jmp __alltraps
  101e7c:	e9 cc ff ff ff       	jmp    101e4d <__alltraps>

00101e81 <vector2>:
.globl vector2
vector2:
  pushl $0
  101e81:	6a 00                	push   $0x0
  pushl $2
  101e83:	6a 02                	push   $0x2
  jmp __alltraps
  101e85:	e9 c3 ff ff ff       	jmp    101e4d <__alltraps>

00101e8a <vector3>:
.globl vector3
vector3:
  pushl $0
  101e8a:	6a 00                	push   $0x0
  pushl $3
  101e8c:	6a 03                	push   $0x3
  jmp __alltraps
  101e8e:	e9 ba ff ff ff       	jmp    101e4d <__alltraps>

00101e93 <vector4>:
.globl vector4
vector4:
  pushl $0
  101e93:	6a 00                	push   $0x0
  pushl $4
  101e95:	6a 04                	push   $0x4
  jmp __alltraps
  101e97:	e9 b1 ff ff ff       	jmp    101e4d <__alltraps>

00101e9c <vector5>:
.globl vector5
vector5:
  pushl $0
  101e9c:	6a 00                	push   $0x0
  pushl $5
  101e9e:	6a 05                	push   $0x5
  jmp __alltraps
  101ea0:	e9 a8 ff ff ff       	jmp    101e4d <__alltraps>

00101ea5 <vector6>:
.globl vector6
vector6:
  pushl $0
  101ea5:	6a 00                	push   $0x0
  pushl $6
  101ea7:	6a 06                	push   $0x6
  jmp __alltraps
  101ea9:	e9 9f ff ff ff       	jmp    101e4d <__alltraps>

00101eae <vector7>:
.globl vector7
vector7:
  pushl $0
  101eae:	6a 00                	push   $0x0
  pushl $7
  101eb0:	6a 07                	push   $0x7
  jmp __alltraps
  101eb2:	e9 96 ff ff ff       	jmp    101e4d <__alltraps>

00101eb7 <vector8>:
.globl vector8
vector8:
  pushl $8
  101eb7:	6a 08                	push   $0x8
  jmp __alltraps
  101eb9:	e9 8f ff ff ff       	jmp    101e4d <__alltraps>

00101ebe <vector9>:
.globl vector9
vector9:
  pushl $9
  101ebe:	6a 09                	push   $0x9
  jmp __alltraps
  101ec0:	e9 88 ff ff ff       	jmp    101e4d <__alltraps>

00101ec5 <vector10>:
.globl vector10
vector10:
  pushl $10
  101ec5:	6a 0a                	push   $0xa
  jmp __alltraps
  101ec7:	e9 81 ff ff ff       	jmp    101e4d <__alltraps>

00101ecc <vector11>:
.globl vector11
vector11:
  pushl $11
  101ecc:	6a 0b                	push   $0xb
  jmp __alltraps
  101ece:	e9 7a ff ff ff       	jmp    101e4d <__alltraps>

00101ed3 <vector12>:
.globl vector12
vector12:
  pushl $12
  101ed3:	6a 0c                	push   $0xc
  jmp __alltraps
  101ed5:	e9 73 ff ff ff       	jmp    101e4d <__alltraps>

00101eda <vector13>:
.globl vector13
vector13:
  pushl $13
  101eda:	6a 0d                	push   $0xd
  jmp __alltraps
  101edc:	e9 6c ff ff ff       	jmp    101e4d <__alltraps>

00101ee1 <vector14>:
.globl vector14
vector14:
  pushl $14
  101ee1:	6a 0e                	push   $0xe
  jmp __alltraps
  101ee3:	e9 65 ff ff ff       	jmp    101e4d <__alltraps>

00101ee8 <vector15>:
.globl vector15
vector15:
  pushl $0
  101ee8:	6a 00                	push   $0x0
  pushl $15
  101eea:	6a 0f                	push   $0xf
  jmp __alltraps
  101eec:	e9 5c ff ff ff       	jmp    101e4d <__alltraps>

00101ef1 <vector16>:
.globl vector16
vector16:
  pushl $0
  101ef1:	6a 00                	push   $0x0
  pushl $16
  101ef3:	6a 10                	push   $0x10
  jmp __alltraps
  101ef5:	e9 53 ff ff ff       	jmp    101e4d <__alltraps>

00101efa <vector17>:
.globl vector17
vector17:
  pushl $17
  101efa:	6a 11                	push   $0x11
  jmp __alltraps
  101efc:	e9 4c ff ff ff       	jmp    101e4d <__alltraps>

00101f01 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f01:	6a 00                	push   $0x0
  pushl $18
  101f03:	6a 12                	push   $0x12
  jmp __alltraps
  101f05:	e9 43 ff ff ff       	jmp    101e4d <__alltraps>

00101f0a <vector19>:
.globl vector19
vector19:
  pushl $0
  101f0a:	6a 00                	push   $0x0
  pushl $19
  101f0c:	6a 13                	push   $0x13
  jmp __alltraps
  101f0e:	e9 3a ff ff ff       	jmp    101e4d <__alltraps>

00101f13 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f13:	6a 00                	push   $0x0
  pushl $20
  101f15:	6a 14                	push   $0x14
  jmp __alltraps
  101f17:	e9 31 ff ff ff       	jmp    101e4d <__alltraps>

00101f1c <vector21>:
.globl vector21
vector21:
  pushl $0
  101f1c:	6a 00                	push   $0x0
  pushl $21
  101f1e:	6a 15                	push   $0x15
  jmp __alltraps
  101f20:	e9 28 ff ff ff       	jmp    101e4d <__alltraps>

00101f25 <vector22>:
.globl vector22
vector22:
  pushl $0
  101f25:	6a 00                	push   $0x0
  pushl $22
  101f27:	6a 16                	push   $0x16
  jmp __alltraps
  101f29:	e9 1f ff ff ff       	jmp    101e4d <__alltraps>

00101f2e <vector23>:
.globl vector23
vector23:
  pushl $0
  101f2e:	6a 00                	push   $0x0
  pushl $23
  101f30:	6a 17                	push   $0x17
  jmp __alltraps
  101f32:	e9 16 ff ff ff       	jmp    101e4d <__alltraps>

00101f37 <vector24>:
.globl vector24
vector24:
  pushl $0
  101f37:	6a 00                	push   $0x0
  pushl $24
  101f39:	6a 18                	push   $0x18
  jmp __alltraps
  101f3b:	e9 0d ff ff ff       	jmp    101e4d <__alltraps>

00101f40 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f40:	6a 00                	push   $0x0
  pushl $25
  101f42:	6a 19                	push   $0x19
  jmp __alltraps
  101f44:	e9 04 ff ff ff       	jmp    101e4d <__alltraps>

00101f49 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f49:	6a 00                	push   $0x0
  pushl $26
  101f4b:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f4d:	e9 fb fe ff ff       	jmp    101e4d <__alltraps>

00101f52 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f52:	6a 00                	push   $0x0
  pushl $27
  101f54:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f56:	e9 f2 fe ff ff       	jmp    101e4d <__alltraps>

00101f5b <vector28>:
.globl vector28
vector28:
  pushl $0
  101f5b:	6a 00                	push   $0x0
  pushl $28
  101f5d:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f5f:	e9 e9 fe ff ff       	jmp    101e4d <__alltraps>

00101f64 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f64:	6a 00                	push   $0x0
  pushl $29
  101f66:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f68:	e9 e0 fe ff ff       	jmp    101e4d <__alltraps>

00101f6d <vector30>:
.globl vector30
vector30:
  pushl $0
  101f6d:	6a 00                	push   $0x0
  pushl $30
  101f6f:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f71:	e9 d7 fe ff ff       	jmp    101e4d <__alltraps>

00101f76 <vector31>:
.globl vector31
vector31:
  pushl $0
  101f76:	6a 00                	push   $0x0
  pushl $31
  101f78:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f7a:	e9 ce fe ff ff       	jmp    101e4d <__alltraps>

00101f7f <vector32>:
.globl vector32
vector32:
  pushl $0
  101f7f:	6a 00                	push   $0x0
  pushl $32
  101f81:	6a 20                	push   $0x20
  jmp __alltraps
  101f83:	e9 c5 fe ff ff       	jmp    101e4d <__alltraps>

00101f88 <vector33>:
.globl vector33
vector33:
  pushl $0
  101f88:	6a 00                	push   $0x0
  pushl $33
  101f8a:	6a 21                	push   $0x21
  jmp __alltraps
  101f8c:	e9 bc fe ff ff       	jmp    101e4d <__alltraps>

00101f91 <vector34>:
.globl vector34
vector34:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $34
  101f93:	6a 22                	push   $0x22
  jmp __alltraps
  101f95:	e9 b3 fe ff ff       	jmp    101e4d <__alltraps>

00101f9a <vector35>:
.globl vector35
vector35:
  pushl $0
  101f9a:	6a 00                	push   $0x0
  pushl $35
  101f9c:	6a 23                	push   $0x23
  jmp __alltraps
  101f9e:	e9 aa fe ff ff       	jmp    101e4d <__alltraps>

00101fa3 <vector36>:
.globl vector36
vector36:
  pushl $0
  101fa3:	6a 00                	push   $0x0
  pushl $36
  101fa5:	6a 24                	push   $0x24
  jmp __alltraps
  101fa7:	e9 a1 fe ff ff       	jmp    101e4d <__alltraps>

00101fac <vector37>:
.globl vector37
vector37:
  pushl $0
  101fac:	6a 00                	push   $0x0
  pushl $37
  101fae:	6a 25                	push   $0x25
  jmp __alltraps
  101fb0:	e9 98 fe ff ff       	jmp    101e4d <__alltraps>

00101fb5 <vector38>:
.globl vector38
vector38:
  pushl $0
  101fb5:	6a 00                	push   $0x0
  pushl $38
  101fb7:	6a 26                	push   $0x26
  jmp __alltraps
  101fb9:	e9 8f fe ff ff       	jmp    101e4d <__alltraps>

00101fbe <vector39>:
.globl vector39
vector39:
  pushl $0
  101fbe:	6a 00                	push   $0x0
  pushl $39
  101fc0:	6a 27                	push   $0x27
  jmp __alltraps
  101fc2:	e9 86 fe ff ff       	jmp    101e4d <__alltraps>

00101fc7 <vector40>:
.globl vector40
vector40:
  pushl $0
  101fc7:	6a 00                	push   $0x0
  pushl $40
  101fc9:	6a 28                	push   $0x28
  jmp __alltraps
  101fcb:	e9 7d fe ff ff       	jmp    101e4d <__alltraps>

00101fd0 <vector41>:
.globl vector41
vector41:
  pushl $0
  101fd0:	6a 00                	push   $0x0
  pushl $41
  101fd2:	6a 29                	push   $0x29
  jmp __alltraps
  101fd4:	e9 74 fe ff ff       	jmp    101e4d <__alltraps>

00101fd9 <vector42>:
.globl vector42
vector42:
  pushl $0
  101fd9:	6a 00                	push   $0x0
  pushl $42
  101fdb:	6a 2a                	push   $0x2a
  jmp __alltraps
  101fdd:	e9 6b fe ff ff       	jmp    101e4d <__alltraps>

00101fe2 <vector43>:
.globl vector43
vector43:
  pushl $0
  101fe2:	6a 00                	push   $0x0
  pushl $43
  101fe4:	6a 2b                	push   $0x2b
  jmp __alltraps
  101fe6:	e9 62 fe ff ff       	jmp    101e4d <__alltraps>

00101feb <vector44>:
.globl vector44
vector44:
  pushl $0
  101feb:	6a 00                	push   $0x0
  pushl $44
  101fed:	6a 2c                	push   $0x2c
  jmp __alltraps
  101fef:	e9 59 fe ff ff       	jmp    101e4d <__alltraps>

00101ff4 <vector45>:
.globl vector45
vector45:
  pushl $0
  101ff4:	6a 00                	push   $0x0
  pushl $45
  101ff6:	6a 2d                	push   $0x2d
  jmp __alltraps
  101ff8:	e9 50 fe ff ff       	jmp    101e4d <__alltraps>

00101ffd <vector46>:
.globl vector46
vector46:
  pushl $0
  101ffd:	6a 00                	push   $0x0
  pushl $46
  101fff:	6a 2e                	push   $0x2e
  jmp __alltraps
  102001:	e9 47 fe ff ff       	jmp    101e4d <__alltraps>

00102006 <vector47>:
.globl vector47
vector47:
  pushl $0
  102006:	6a 00                	push   $0x0
  pushl $47
  102008:	6a 2f                	push   $0x2f
  jmp __alltraps
  10200a:	e9 3e fe ff ff       	jmp    101e4d <__alltraps>

0010200f <vector48>:
.globl vector48
vector48:
  pushl $0
  10200f:	6a 00                	push   $0x0
  pushl $48
  102011:	6a 30                	push   $0x30
  jmp __alltraps
  102013:	e9 35 fe ff ff       	jmp    101e4d <__alltraps>

00102018 <vector49>:
.globl vector49
vector49:
  pushl $0
  102018:	6a 00                	push   $0x0
  pushl $49
  10201a:	6a 31                	push   $0x31
  jmp __alltraps
  10201c:	e9 2c fe ff ff       	jmp    101e4d <__alltraps>

00102021 <vector50>:
.globl vector50
vector50:
  pushl $0
  102021:	6a 00                	push   $0x0
  pushl $50
  102023:	6a 32                	push   $0x32
  jmp __alltraps
  102025:	e9 23 fe ff ff       	jmp    101e4d <__alltraps>

0010202a <vector51>:
.globl vector51
vector51:
  pushl $0
  10202a:	6a 00                	push   $0x0
  pushl $51
  10202c:	6a 33                	push   $0x33
  jmp __alltraps
  10202e:	e9 1a fe ff ff       	jmp    101e4d <__alltraps>

00102033 <vector52>:
.globl vector52
vector52:
  pushl $0
  102033:	6a 00                	push   $0x0
  pushl $52
  102035:	6a 34                	push   $0x34
  jmp __alltraps
  102037:	e9 11 fe ff ff       	jmp    101e4d <__alltraps>

0010203c <vector53>:
.globl vector53
vector53:
  pushl $0
  10203c:	6a 00                	push   $0x0
  pushl $53
  10203e:	6a 35                	push   $0x35
  jmp __alltraps
  102040:	e9 08 fe ff ff       	jmp    101e4d <__alltraps>

00102045 <vector54>:
.globl vector54
vector54:
  pushl $0
  102045:	6a 00                	push   $0x0
  pushl $54
  102047:	6a 36                	push   $0x36
  jmp __alltraps
  102049:	e9 ff fd ff ff       	jmp    101e4d <__alltraps>

0010204e <vector55>:
.globl vector55
vector55:
  pushl $0
  10204e:	6a 00                	push   $0x0
  pushl $55
  102050:	6a 37                	push   $0x37
  jmp __alltraps
  102052:	e9 f6 fd ff ff       	jmp    101e4d <__alltraps>

00102057 <vector56>:
.globl vector56
vector56:
  pushl $0
  102057:	6a 00                	push   $0x0
  pushl $56
  102059:	6a 38                	push   $0x38
  jmp __alltraps
  10205b:	e9 ed fd ff ff       	jmp    101e4d <__alltraps>

00102060 <vector57>:
.globl vector57
vector57:
  pushl $0
  102060:	6a 00                	push   $0x0
  pushl $57
  102062:	6a 39                	push   $0x39
  jmp __alltraps
  102064:	e9 e4 fd ff ff       	jmp    101e4d <__alltraps>

00102069 <vector58>:
.globl vector58
vector58:
  pushl $0
  102069:	6a 00                	push   $0x0
  pushl $58
  10206b:	6a 3a                	push   $0x3a
  jmp __alltraps
  10206d:	e9 db fd ff ff       	jmp    101e4d <__alltraps>

00102072 <vector59>:
.globl vector59
vector59:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $59
  102074:	6a 3b                	push   $0x3b
  jmp __alltraps
  102076:	e9 d2 fd ff ff       	jmp    101e4d <__alltraps>

0010207b <vector60>:
.globl vector60
vector60:
  pushl $0
  10207b:	6a 00                	push   $0x0
  pushl $60
  10207d:	6a 3c                	push   $0x3c
  jmp __alltraps
  10207f:	e9 c9 fd ff ff       	jmp    101e4d <__alltraps>

00102084 <vector61>:
.globl vector61
vector61:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $61
  102086:	6a 3d                	push   $0x3d
  jmp __alltraps
  102088:	e9 c0 fd ff ff       	jmp    101e4d <__alltraps>

0010208d <vector62>:
.globl vector62
vector62:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $62
  10208f:	6a 3e                	push   $0x3e
  jmp __alltraps
  102091:	e9 b7 fd ff ff       	jmp    101e4d <__alltraps>

00102096 <vector63>:
.globl vector63
vector63:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $63
  102098:	6a 3f                	push   $0x3f
  jmp __alltraps
  10209a:	e9 ae fd ff ff       	jmp    101e4d <__alltraps>

0010209f <vector64>:
.globl vector64
vector64:
  pushl $0
  10209f:	6a 00                	push   $0x0
  pushl $64
  1020a1:	6a 40                	push   $0x40
  jmp __alltraps
  1020a3:	e9 a5 fd ff ff       	jmp    101e4d <__alltraps>

001020a8 <vector65>:
.globl vector65
vector65:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $65
  1020aa:	6a 41                	push   $0x41
  jmp __alltraps
  1020ac:	e9 9c fd ff ff       	jmp    101e4d <__alltraps>

001020b1 <vector66>:
.globl vector66
vector66:
  pushl $0
  1020b1:	6a 00                	push   $0x0
  pushl $66
  1020b3:	6a 42                	push   $0x42
  jmp __alltraps
  1020b5:	e9 93 fd ff ff       	jmp    101e4d <__alltraps>

001020ba <vector67>:
.globl vector67
vector67:
  pushl $0
  1020ba:	6a 00                	push   $0x0
  pushl $67
  1020bc:	6a 43                	push   $0x43
  jmp __alltraps
  1020be:	e9 8a fd ff ff       	jmp    101e4d <__alltraps>

001020c3 <vector68>:
.globl vector68
vector68:
  pushl $0
  1020c3:	6a 00                	push   $0x0
  pushl $68
  1020c5:	6a 44                	push   $0x44
  jmp __alltraps
  1020c7:	e9 81 fd ff ff       	jmp    101e4d <__alltraps>

001020cc <vector69>:
.globl vector69
vector69:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $69
  1020ce:	6a 45                	push   $0x45
  jmp __alltraps
  1020d0:	e9 78 fd ff ff       	jmp    101e4d <__alltraps>

001020d5 <vector70>:
.globl vector70
vector70:
  pushl $0
  1020d5:	6a 00                	push   $0x0
  pushl $70
  1020d7:	6a 46                	push   $0x46
  jmp __alltraps
  1020d9:	e9 6f fd ff ff       	jmp    101e4d <__alltraps>

001020de <vector71>:
.globl vector71
vector71:
  pushl $0
  1020de:	6a 00                	push   $0x0
  pushl $71
  1020e0:	6a 47                	push   $0x47
  jmp __alltraps
  1020e2:	e9 66 fd ff ff       	jmp    101e4d <__alltraps>

001020e7 <vector72>:
.globl vector72
vector72:
  pushl $0
  1020e7:	6a 00                	push   $0x0
  pushl $72
  1020e9:	6a 48                	push   $0x48
  jmp __alltraps
  1020eb:	e9 5d fd ff ff       	jmp    101e4d <__alltraps>

001020f0 <vector73>:
.globl vector73
vector73:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $73
  1020f2:	6a 49                	push   $0x49
  jmp __alltraps
  1020f4:	e9 54 fd ff ff       	jmp    101e4d <__alltraps>

001020f9 <vector74>:
.globl vector74
vector74:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $74
  1020fb:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020fd:	e9 4b fd ff ff       	jmp    101e4d <__alltraps>

00102102 <vector75>:
.globl vector75
vector75:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $75
  102104:	6a 4b                	push   $0x4b
  jmp __alltraps
  102106:	e9 42 fd ff ff       	jmp    101e4d <__alltraps>

0010210b <vector76>:
.globl vector76
vector76:
  pushl $0
  10210b:	6a 00                	push   $0x0
  pushl $76
  10210d:	6a 4c                	push   $0x4c
  jmp __alltraps
  10210f:	e9 39 fd ff ff       	jmp    101e4d <__alltraps>

00102114 <vector77>:
.globl vector77
vector77:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $77
  102116:	6a 4d                	push   $0x4d
  jmp __alltraps
  102118:	e9 30 fd ff ff       	jmp    101e4d <__alltraps>

0010211d <vector78>:
.globl vector78
vector78:
  pushl $0
  10211d:	6a 00                	push   $0x0
  pushl $78
  10211f:	6a 4e                	push   $0x4e
  jmp __alltraps
  102121:	e9 27 fd ff ff       	jmp    101e4d <__alltraps>

00102126 <vector79>:
.globl vector79
vector79:
  pushl $0
  102126:	6a 00                	push   $0x0
  pushl $79
  102128:	6a 4f                	push   $0x4f
  jmp __alltraps
  10212a:	e9 1e fd ff ff       	jmp    101e4d <__alltraps>

0010212f <vector80>:
.globl vector80
vector80:
  pushl $0
  10212f:	6a 00                	push   $0x0
  pushl $80
  102131:	6a 50                	push   $0x50
  jmp __alltraps
  102133:	e9 15 fd ff ff       	jmp    101e4d <__alltraps>

00102138 <vector81>:
.globl vector81
vector81:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $81
  10213a:	6a 51                	push   $0x51
  jmp __alltraps
  10213c:	e9 0c fd ff ff       	jmp    101e4d <__alltraps>

00102141 <vector82>:
.globl vector82
vector82:
  pushl $0
  102141:	6a 00                	push   $0x0
  pushl $82
  102143:	6a 52                	push   $0x52
  jmp __alltraps
  102145:	e9 03 fd ff ff       	jmp    101e4d <__alltraps>

0010214a <vector83>:
.globl vector83
vector83:
  pushl $0
  10214a:	6a 00                	push   $0x0
  pushl $83
  10214c:	6a 53                	push   $0x53
  jmp __alltraps
  10214e:	e9 fa fc ff ff       	jmp    101e4d <__alltraps>

00102153 <vector84>:
.globl vector84
vector84:
  pushl $0
  102153:	6a 00                	push   $0x0
  pushl $84
  102155:	6a 54                	push   $0x54
  jmp __alltraps
  102157:	e9 f1 fc ff ff       	jmp    101e4d <__alltraps>

0010215c <vector85>:
.globl vector85
vector85:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $85
  10215e:	6a 55                	push   $0x55
  jmp __alltraps
  102160:	e9 e8 fc ff ff       	jmp    101e4d <__alltraps>

00102165 <vector86>:
.globl vector86
vector86:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $86
  102167:	6a 56                	push   $0x56
  jmp __alltraps
  102169:	e9 df fc ff ff       	jmp    101e4d <__alltraps>

0010216e <vector87>:
.globl vector87
vector87:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $87
  102170:	6a 57                	push   $0x57
  jmp __alltraps
  102172:	e9 d6 fc ff ff       	jmp    101e4d <__alltraps>

00102177 <vector88>:
.globl vector88
vector88:
  pushl $0
  102177:	6a 00                	push   $0x0
  pushl $88
  102179:	6a 58                	push   $0x58
  jmp __alltraps
  10217b:	e9 cd fc ff ff       	jmp    101e4d <__alltraps>

00102180 <vector89>:
.globl vector89
vector89:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $89
  102182:	6a 59                	push   $0x59
  jmp __alltraps
  102184:	e9 c4 fc ff ff       	jmp    101e4d <__alltraps>

00102189 <vector90>:
.globl vector90
vector90:
  pushl $0
  102189:	6a 00                	push   $0x0
  pushl $90
  10218b:	6a 5a                	push   $0x5a
  jmp __alltraps
  10218d:	e9 bb fc ff ff       	jmp    101e4d <__alltraps>

00102192 <vector91>:
.globl vector91
vector91:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $91
  102194:	6a 5b                	push   $0x5b
  jmp __alltraps
  102196:	e9 b2 fc ff ff       	jmp    101e4d <__alltraps>

0010219b <vector92>:
.globl vector92
vector92:
  pushl $0
  10219b:	6a 00                	push   $0x0
  pushl $92
  10219d:	6a 5c                	push   $0x5c
  jmp __alltraps
  10219f:	e9 a9 fc ff ff       	jmp    101e4d <__alltraps>

001021a4 <vector93>:
.globl vector93
vector93:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $93
  1021a6:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021a8:	e9 a0 fc ff ff       	jmp    101e4d <__alltraps>

001021ad <vector94>:
.globl vector94
vector94:
  pushl $0
  1021ad:	6a 00                	push   $0x0
  pushl $94
  1021af:	6a 5e                	push   $0x5e
  jmp __alltraps
  1021b1:	e9 97 fc ff ff       	jmp    101e4d <__alltraps>

001021b6 <vector95>:
.globl vector95
vector95:
  pushl $0
  1021b6:	6a 00                	push   $0x0
  pushl $95
  1021b8:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021ba:	e9 8e fc ff ff       	jmp    101e4d <__alltraps>

001021bf <vector96>:
.globl vector96
vector96:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $96
  1021c1:	6a 60                	push   $0x60
  jmp __alltraps
  1021c3:	e9 85 fc ff ff       	jmp    101e4d <__alltraps>

001021c8 <vector97>:
.globl vector97
vector97:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $97
  1021ca:	6a 61                	push   $0x61
  jmp __alltraps
  1021cc:	e9 7c fc ff ff       	jmp    101e4d <__alltraps>

001021d1 <vector98>:
.globl vector98
vector98:
  pushl $0
  1021d1:	6a 00                	push   $0x0
  pushl $98
  1021d3:	6a 62                	push   $0x62
  jmp __alltraps
  1021d5:	e9 73 fc ff ff       	jmp    101e4d <__alltraps>

001021da <vector99>:
.globl vector99
vector99:
  pushl $0
  1021da:	6a 00                	push   $0x0
  pushl $99
  1021dc:	6a 63                	push   $0x63
  jmp __alltraps
  1021de:	e9 6a fc ff ff       	jmp    101e4d <__alltraps>

001021e3 <vector100>:
.globl vector100
vector100:
  pushl $0
  1021e3:	6a 00                	push   $0x0
  pushl $100
  1021e5:	6a 64                	push   $0x64
  jmp __alltraps
  1021e7:	e9 61 fc ff ff       	jmp    101e4d <__alltraps>

001021ec <vector101>:
.globl vector101
vector101:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $101
  1021ee:	6a 65                	push   $0x65
  jmp __alltraps
  1021f0:	e9 58 fc ff ff       	jmp    101e4d <__alltraps>

001021f5 <vector102>:
.globl vector102
vector102:
  pushl $0
  1021f5:	6a 00                	push   $0x0
  pushl $102
  1021f7:	6a 66                	push   $0x66
  jmp __alltraps
  1021f9:	e9 4f fc ff ff       	jmp    101e4d <__alltraps>

001021fe <vector103>:
.globl vector103
vector103:
  pushl $0
  1021fe:	6a 00                	push   $0x0
  pushl $103
  102200:	6a 67                	push   $0x67
  jmp __alltraps
  102202:	e9 46 fc ff ff       	jmp    101e4d <__alltraps>

00102207 <vector104>:
.globl vector104
vector104:
  pushl $0
  102207:	6a 00                	push   $0x0
  pushl $104
  102209:	6a 68                	push   $0x68
  jmp __alltraps
  10220b:	e9 3d fc ff ff       	jmp    101e4d <__alltraps>

00102210 <vector105>:
.globl vector105
vector105:
  pushl $0
  102210:	6a 00                	push   $0x0
  pushl $105
  102212:	6a 69                	push   $0x69
  jmp __alltraps
  102214:	e9 34 fc ff ff       	jmp    101e4d <__alltraps>

00102219 <vector106>:
.globl vector106
vector106:
  pushl $0
  102219:	6a 00                	push   $0x0
  pushl $106
  10221b:	6a 6a                	push   $0x6a
  jmp __alltraps
  10221d:	e9 2b fc ff ff       	jmp    101e4d <__alltraps>

00102222 <vector107>:
.globl vector107
vector107:
  pushl $0
  102222:	6a 00                	push   $0x0
  pushl $107
  102224:	6a 6b                	push   $0x6b
  jmp __alltraps
  102226:	e9 22 fc ff ff       	jmp    101e4d <__alltraps>

0010222b <vector108>:
.globl vector108
vector108:
  pushl $0
  10222b:	6a 00                	push   $0x0
  pushl $108
  10222d:	6a 6c                	push   $0x6c
  jmp __alltraps
  10222f:	e9 19 fc ff ff       	jmp    101e4d <__alltraps>

00102234 <vector109>:
.globl vector109
vector109:
  pushl $0
  102234:	6a 00                	push   $0x0
  pushl $109
  102236:	6a 6d                	push   $0x6d
  jmp __alltraps
  102238:	e9 10 fc ff ff       	jmp    101e4d <__alltraps>

0010223d <vector110>:
.globl vector110
vector110:
  pushl $0
  10223d:	6a 00                	push   $0x0
  pushl $110
  10223f:	6a 6e                	push   $0x6e
  jmp __alltraps
  102241:	e9 07 fc ff ff       	jmp    101e4d <__alltraps>

00102246 <vector111>:
.globl vector111
vector111:
  pushl $0
  102246:	6a 00                	push   $0x0
  pushl $111
  102248:	6a 6f                	push   $0x6f
  jmp __alltraps
  10224a:	e9 fe fb ff ff       	jmp    101e4d <__alltraps>

0010224f <vector112>:
.globl vector112
vector112:
  pushl $0
  10224f:	6a 00                	push   $0x0
  pushl $112
  102251:	6a 70                	push   $0x70
  jmp __alltraps
  102253:	e9 f5 fb ff ff       	jmp    101e4d <__alltraps>

00102258 <vector113>:
.globl vector113
vector113:
  pushl $0
  102258:	6a 00                	push   $0x0
  pushl $113
  10225a:	6a 71                	push   $0x71
  jmp __alltraps
  10225c:	e9 ec fb ff ff       	jmp    101e4d <__alltraps>

00102261 <vector114>:
.globl vector114
vector114:
  pushl $0
  102261:	6a 00                	push   $0x0
  pushl $114
  102263:	6a 72                	push   $0x72
  jmp __alltraps
  102265:	e9 e3 fb ff ff       	jmp    101e4d <__alltraps>

0010226a <vector115>:
.globl vector115
vector115:
  pushl $0
  10226a:	6a 00                	push   $0x0
  pushl $115
  10226c:	6a 73                	push   $0x73
  jmp __alltraps
  10226e:	e9 da fb ff ff       	jmp    101e4d <__alltraps>

00102273 <vector116>:
.globl vector116
vector116:
  pushl $0
  102273:	6a 00                	push   $0x0
  pushl $116
  102275:	6a 74                	push   $0x74
  jmp __alltraps
  102277:	e9 d1 fb ff ff       	jmp    101e4d <__alltraps>

0010227c <vector117>:
.globl vector117
vector117:
  pushl $0
  10227c:	6a 00                	push   $0x0
  pushl $117
  10227e:	6a 75                	push   $0x75
  jmp __alltraps
  102280:	e9 c8 fb ff ff       	jmp    101e4d <__alltraps>

00102285 <vector118>:
.globl vector118
vector118:
  pushl $0
  102285:	6a 00                	push   $0x0
  pushl $118
  102287:	6a 76                	push   $0x76
  jmp __alltraps
  102289:	e9 bf fb ff ff       	jmp    101e4d <__alltraps>

0010228e <vector119>:
.globl vector119
vector119:
  pushl $0
  10228e:	6a 00                	push   $0x0
  pushl $119
  102290:	6a 77                	push   $0x77
  jmp __alltraps
  102292:	e9 b6 fb ff ff       	jmp    101e4d <__alltraps>

00102297 <vector120>:
.globl vector120
vector120:
  pushl $0
  102297:	6a 00                	push   $0x0
  pushl $120
  102299:	6a 78                	push   $0x78
  jmp __alltraps
  10229b:	e9 ad fb ff ff       	jmp    101e4d <__alltraps>

001022a0 <vector121>:
.globl vector121
vector121:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $121
  1022a2:	6a 79                	push   $0x79
  jmp __alltraps
  1022a4:	e9 a4 fb ff ff       	jmp    101e4d <__alltraps>

001022a9 <vector122>:
.globl vector122
vector122:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $122
  1022ab:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022ad:	e9 9b fb ff ff       	jmp    101e4d <__alltraps>

001022b2 <vector123>:
.globl vector123
vector123:
  pushl $0
  1022b2:	6a 00                	push   $0x0
  pushl $123
  1022b4:	6a 7b                	push   $0x7b
  jmp __alltraps
  1022b6:	e9 92 fb ff ff       	jmp    101e4d <__alltraps>

001022bb <vector124>:
.globl vector124
vector124:
  pushl $0
  1022bb:	6a 00                	push   $0x0
  pushl $124
  1022bd:	6a 7c                	push   $0x7c
  jmp __alltraps
  1022bf:	e9 89 fb ff ff       	jmp    101e4d <__alltraps>

001022c4 <vector125>:
.globl vector125
vector125:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $125
  1022c6:	6a 7d                	push   $0x7d
  jmp __alltraps
  1022c8:	e9 80 fb ff ff       	jmp    101e4d <__alltraps>

001022cd <vector126>:
.globl vector126
vector126:
  pushl $0
  1022cd:	6a 00                	push   $0x0
  pushl $126
  1022cf:	6a 7e                	push   $0x7e
  jmp __alltraps
  1022d1:	e9 77 fb ff ff       	jmp    101e4d <__alltraps>

001022d6 <vector127>:
.globl vector127
vector127:
  pushl $0
  1022d6:	6a 00                	push   $0x0
  pushl $127
  1022d8:	6a 7f                	push   $0x7f
  jmp __alltraps
  1022da:	e9 6e fb ff ff       	jmp    101e4d <__alltraps>

001022df <vector128>:
.globl vector128
vector128:
  pushl $0
  1022df:	6a 00                	push   $0x0
  pushl $128
  1022e1:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1022e6:	e9 62 fb ff ff       	jmp    101e4d <__alltraps>

001022eb <vector129>:
.globl vector129
vector129:
  pushl $0
  1022eb:	6a 00                	push   $0x0
  pushl $129
  1022ed:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022f2:	e9 56 fb ff ff       	jmp    101e4d <__alltraps>

001022f7 <vector130>:
.globl vector130
vector130:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $130
  1022f9:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022fe:	e9 4a fb ff ff       	jmp    101e4d <__alltraps>

00102303 <vector131>:
.globl vector131
vector131:
  pushl $0
  102303:	6a 00                	push   $0x0
  pushl $131
  102305:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10230a:	e9 3e fb ff ff       	jmp    101e4d <__alltraps>

0010230f <vector132>:
.globl vector132
vector132:
  pushl $0
  10230f:	6a 00                	push   $0x0
  pushl $132
  102311:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102316:	e9 32 fb ff ff       	jmp    101e4d <__alltraps>

0010231b <vector133>:
.globl vector133
vector133:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $133
  10231d:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102322:	e9 26 fb ff ff       	jmp    101e4d <__alltraps>

00102327 <vector134>:
.globl vector134
vector134:
  pushl $0
  102327:	6a 00                	push   $0x0
  pushl $134
  102329:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10232e:	e9 1a fb ff ff       	jmp    101e4d <__alltraps>

00102333 <vector135>:
.globl vector135
vector135:
  pushl $0
  102333:	6a 00                	push   $0x0
  pushl $135
  102335:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10233a:	e9 0e fb ff ff       	jmp    101e4d <__alltraps>

0010233f <vector136>:
.globl vector136
vector136:
  pushl $0
  10233f:	6a 00                	push   $0x0
  pushl $136
  102341:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102346:	e9 02 fb ff ff       	jmp    101e4d <__alltraps>

0010234b <vector137>:
.globl vector137
vector137:
  pushl $0
  10234b:	6a 00                	push   $0x0
  pushl $137
  10234d:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102352:	e9 f6 fa ff ff       	jmp    101e4d <__alltraps>

00102357 <vector138>:
.globl vector138
vector138:
  pushl $0
  102357:	6a 00                	push   $0x0
  pushl $138
  102359:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10235e:	e9 ea fa ff ff       	jmp    101e4d <__alltraps>

00102363 <vector139>:
.globl vector139
vector139:
  pushl $0
  102363:	6a 00                	push   $0x0
  pushl $139
  102365:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10236a:	e9 de fa ff ff       	jmp    101e4d <__alltraps>

0010236f <vector140>:
.globl vector140
vector140:
  pushl $0
  10236f:	6a 00                	push   $0x0
  pushl $140
  102371:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102376:	e9 d2 fa ff ff       	jmp    101e4d <__alltraps>

0010237b <vector141>:
.globl vector141
vector141:
  pushl $0
  10237b:	6a 00                	push   $0x0
  pushl $141
  10237d:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102382:	e9 c6 fa ff ff       	jmp    101e4d <__alltraps>

00102387 <vector142>:
.globl vector142
vector142:
  pushl $0
  102387:	6a 00                	push   $0x0
  pushl $142
  102389:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10238e:	e9 ba fa ff ff       	jmp    101e4d <__alltraps>

00102393 <vector143>:
.globl vector143
vector143:
  pushl $0
  102393:	6a 00                	push   $0x0
  pushl $143
  102395:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10239a:	e9 ae fa ff ff       	jmp    101e4d <__alltraps>

0010239f <vector144>:
.globl vector144
vector144:
  pushl $0
  10239f:	6a 00                	push   $0x0
  pushl $144
  1023a1:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023a6:	e9 a2 fa ff ff       	jmp    101e4d <__alltraps>

001023ab <vector145>:
.globl vector145
vector145:
  pushl $0
  1023ab:	6a 00                	push   $0x0
  pushl $145
  1023ad:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1023b2:	e9 96 fa ff ff       	jmp    101e4d <__alltraps>

001023b7 <vector146>:
.globl vector146
vector146:
  pushl $0
  1023b7:	6a 00                	push   $0x0
  pushl $146
  1023b9:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1023be:	e9 8a fa ff ff       	jmp    101e4d <__alltraps>

001023c3 <vector147>:
.globl vector147
vector147:
  pushl $0
  1023c3:	6a 00                	push   $0x0
  pushl $147
  1023c5:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1023ca:	e9 7e fa ff ff       	jmp    101e4d <__alltraps>

001023cf <vector148>:
.globl vector148
vector148:
  pushl $0
  1023cf:	6a 00                	push   $0x0
  pushl $148
  1023d1:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1023d6:	e9 72 fa ff ff       	jmp    101e4d <__alltraps>

001023db <vector149>:
.globl vector149
vector149:
  pushl $0
  1023db:	6a 00                	push   $0x0
  pushl $149
  1023dd:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1023e2:	e9 66 fa ff ff       	jmp    101e4d <__alltraps>

001023e7 <vector150>:
.globl vector150
vector150:
  pushl $0
  1023e7:	6a 00                	push   $0x0
  pushl $150
  1023e9:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023ee:	e9 5a fa ff ff       	jmp    101e4d <__alltraps>

001023f3 <vector151>:
.globl vector151
vector151:
  pushl $0
  1023f3:	6a 00                	push   $0x0
  pushl $151
  1023f5:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023fa:	e9 4e fa ff ff       	jmp    101e4d <__alltraps>

001023ff <vector152>:
.globl vector152
vector152:
  pushl $0
  1023ff:	6a 00                	push   $0x0
  pushl $152
  102401:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102406:	e9 42 fa ff ff       	jmp    101e4d <__alltraps>

0010240b <vector153>:
.globl vector153
vector153:
  pushl $0
  10240b:	6a 00                	push   $0x0
  pushl $153
  10240d:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102412:	e9 36 fa ff ff       	jmp    101e4d <__alltraps>

00102417 <vector154>:
.globl vector154
vector154:
  pushl $0
  102417:	6a 00                	push   $0x0
  pushl $154
  102419:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10241e:	e9 2a fa ff ff       	jmp    101e4d <__alltraps>

00102423 <vector155>:
.globl vector155
vector155:
  pushl $0
  102423:	6a 00                	push   $0x0
  pushl $155
  102425:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10242a:	e9 1e fa ff ff       	jmp    101e4d <__alltraps>

0010242f <vector156>:
.globl vector156
vector156:
  pushl $0
  10242f:	6a 00                	push   $0x0
  pushl $156
  102431:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102436:	e9 12 fa ff ff       	jmp    101e4d <__alltraps>

0010243b <vector157>:
.globl vector157
vector157:
  pushl $0
  10243b:	6a 00                	push   $0x0
  pushl $157
  10243d:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102442:	e9 06 fa ff ff       	jmp    101e4d <__alltraps>

00102447 <vector158>:
.globl vector158
vector158:
  pushl $0
  102447:	6a 00                	push   $0x0
  pushl $158
  102449:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10244e:	e9 fa f9 ff ff       	jmp    101e4d <__alltraps>

00102453 <vector159>:
.globl vector159
vector159:
  pushl $0
  102453:	6a 00                	push   $0x0
  pushl $159
  102455:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10245a:	e9 ee f9 ff ff       	jmp    101e4d <__alltraps>

0010245f <vector160>:
.globl vector160
vector160:
  pushl $0
  10245f:	6a 00                	push   $0x0
  pushl $160
  102461:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102466:	e9 e2 f9 ff ff       	jmp    101e4d <__alltraps>

0010246b <vector161>:
.globl vector161
vector161:
  pushl $0
  10246b:	6a 00                	push   $0x0
  pushl $161
  10246d:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102472:	e9 d6 f9 ff ff       	jmp    101e4d <__alltraps>

00102477 <vector162>:
.globl vector162
vector162:
  pushl $0
  102477:	6a 00                	push   $0x0
  pushl $162
  102479:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10247e:	e9 ca f9 ff ff       	jmp    101e4d <__alltraps>

00102483 <vector163>:
.globl vector163
vector163:
  pushl $0
  102483:	6a 00                	push   $0x0
  pushl $163
  102485:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10248a:	e9 be f9 ff ff       	jmp    101e4d <__alltraps>

0010248f <vector164>:
.globl vector164
vector164:
  pushl $0
  10248f:	6a 00                	push   $0x0
  pushl $164
  102491:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102496:	e9 b2 f9 ff ff       	jmp    101e4d <__alltraps>

0010249b <vector165>:
.globl vector165
vector165:
  pushl $0
  10249b:	6a 00                	push   $0x0
  pushl $165
  10249d:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024a2:	e9 a6 f9 ff ff       	jmp    101e4d <__alltraps>

001024a7 <vector166>:
.globl vector166
vector166:
  pushl $0
  1024a7:	6a 00                	push   $0x0
  pushl $166
  1024a9:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024ae:	e9 9a f9 ff ff       	jmp    101e4d <__alltraps>

001024b3 <vector167>:
.globl vector167
vector167:
  pushl $0
  1024b3:	6a 00                	push   $0x0
  pushl $167
  1024b5:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024ba:	e9 8e f9 ff ff       	jmp    101e4d <__alltraps>

001024bf <vector168>:
.globl vector168
vector168:
  pushl $0
  1024bf:	6a 00                	push   $0x0
  pushl $168
  1024c1:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1024c6:	e9 82 f9 ff ff       	jmp    101e4d <__alltraps>

001024cb <vector169>:
.globl vector169
vector169:
  pushl $0
  1024cb:	6a 00                	push   $0x0
  pushl $169
  1024cd:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1024d2:	e9 76 f9 ff ff       	jmp    101e4d <__alltraps>

001024d7 <vector170>:
.globl vector170
vector170:
  pushl $0
  1024d7:	6a 00                	push   $0x0
  pushl $170
  1024d9:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1024de:	e9 6a f9 ff ff       	jmp    101e4d <__alltraps>

001024e3 <vector171>:
.globl vector171
vector171:
  pushl $0
  1024e3:	6a 00                	push   $0x0
  pushl $171
  1024e5:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1024ea:	e9 5e f9 ff ff       	jmp    101e4d <__alltraps>

001024ef <vector172>:
.globl vector172
vector172:
  pushl $0
  1024ef:	6a 00                	push   $0x0
  pushl $172
  1024f1:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024f6:	e9 52 f9 ff ff       	jmp    101e4d <__alltraps>

001024fb <vector173>:
.globl vector173
vector173:
  pushl $0
  1024fb:	6a 00                	push   $0x0
  pushl $173
  1024fd:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102502:	e9 46 f9 ff ff       	jmp    101e4d <__alltraps>

00102507 <vector174>:
.globl vector174
vector174:
  pushl $0
  102507:	6a 00                	push   $0x0
  pushl $174
  102509:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10250e:	e9 3a f9 ff ff       	jmp    101e4d <__alltraps>

00102513 <vector175>:
.globl vector175
vector175:
  pushl $0
  102513:	6a 00                	push   $0x0
  pushl $175
  102515:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10251a:	e9 2e f9 ff ff       	jmp    101e4d <__alltraps>

0010251f <vector176>:
.globl vector176
vector176:
  pushl $0
  10251f:	6a 00                	push   $0x0
  pushl $176
  102521:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102526:	e9 22 f9 ff ff       	jmp    101e4d <__alltraps>

0010252b <vector177>:
.globl vector177
vector177:
  pushl $0
  10252b:	6a 00                	push   $0x0
  pushl $177
  10252d:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102532:	e9 16 f9 ff ff       	jmp    101e4d <__alltraps>

00102537 <vector178>:
.globl vector178
vector178:
  pushl $0
  102537:	6a 00                	push   $0x0
  pushl $178
  102539:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10253e:	e9 0a f9 ff ff       	jmp    101e4d <__alltraps>

00102543 <vector179>:
.globl vector179
vector179:
  pushl $0
  102543:	6a 00                	push   $0x0
  pushl $179
  102545:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10254a:	e9 fe f8 ff ff       	jmp    101e4d <__alltraps>

0010254f <vector180>:
.globl vector180
vector180:
  pushl $0
  10254f:	6a 00                	push   $0x0
  pushl $180
  102551:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102556:	e9 f2 f8 ff ff       	jmp    101e4d <__alltraps>

0010255b <vector181>:
.globl vector181
vector181:
  pushl $0
  10255b:	6a 00                	push   $0x0
  pushl $181
  10255d:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102562:	e9 e6 f8 ff ff       	jmp    101e4d <__alltraps>

00102567 <vector182>:
.globl vector182
vector182:
  pushl $0
  102567:	6a 00                	push   $0x0
  pushl $182
  102569:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10256e:	e9 da f8 ff ff       	jmp    101e4d <__alltraps>

00102573 <vector183>:
.globl vector183
vector183:
  pushl $0
  102573:	6a 00                	push   $0x0
  pushl $183
  102575:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10257a:	e9 ce f8 ff ff       	jmp    101e4d <__alltraps>

0010257f <vector184>:
.globl vector184
vector184:
  pushl $0
  10257f:	6a 00                	push   $0x0
  pushl $184
  102581:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102586:	e9 c2 f8 ff ff       	jmp    101e4d <__alltraps>

0010258b <vector185>:
.globl vector185
vector185:
  pushl $0
  10258b:	6a 00                	push   $0x0
  pushl $185
  10258d:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102592:	e9 b6 f8 ff ff       	jmp    101e4d <__alltraps>

00102597 <vector186>:
.globl vector186
vector186:
  pushl $0
  102597:	6a 00                	push   $0x0
  pushl $186
  102599:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10259e:	e9 aa f8 ff ff       	jmp    101e4d <__alltraps>

001025a3 <vector187>:
.globl vector187
vector187:
  pushl $0
  1025a3:	6a 00                	push   $0x0
  pushl $187
  1025a5:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025aa:	e9 9e f8 ff ff       	jmp    101e4d <__alltraps>

001025af <vector188>:
.globl vector188
vector188:
  pushl $0
  1025af:	6a 00                	push   $0x0
  pushl $188
  1025b1:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1025b6:	e9 92 f8 ff ff       	jmp    101e4d <__alltraps>

001025bb <vector189>:
.globl vector189
vector189:
  pushl $0
  1025bb:	6a 00                	push   $0x0
  pushl $189
  1025bd:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1025c2:	e9 86 f8 ff ff       	jmp    101e4d <__alltraps>

001025c7 <vector190>:
.globl vector190
vector190:
  pushl $0
  1025c7:	6a 00                	push   $0x0
  pushl $190
  1025c9:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1025ce:	e9 7a f8 ff ff       	jmp    101e4d <__alltraps>

001025d3 <vector191>:
.globl vector191
vector191:
  pushl $0
  1025d3:	6a 00                	push   $0x0
  pushl $191
  1025d5:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1025da:	e9 6e f8 ff ff       	jmp    101e4d <__alltraps>

001025df <vector192>:
.globl vector192
vector192:
  pushl $0
  1025df:	6a 00                	push   $0x0
  pushl $192
  1025e1:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1025e6:	e9 62 f8 ff ff       	jmp    101e4d <__alltraps>

001025eb <vector193>:
.globl vector193
vector193:
  pushl $0
  1025eb:	6a 00                	push   $0x0
  pushl $193
  1025ed:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025f2:	e9 56 f8 ff ff       	jmp    101e4d <__alltraps>

001025f7 <vector194>:
.globl vector194
vector194:
  pushl $0
  1025f7:	6a 00                	push   $0x0
  pushl $194
  1025f9:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025fe:	e9 4a f8 ff ff       	jmp    101e4d <__alltraps>

00102603 <vector195>:
.globl vector195
vector195:
  pushl $0
  102603:	6a 00                	push   $0x0
  pushl $195
  102605:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10260a:	e9 3e f8 ff ff       	jmp    101e4d <__alltraps>

0010260f <vector196>:
.globl vector196
vector196:
  pushl $0
  10260f:	6a 00                	push   $0x0
  pushl $196
  102611:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102616:	e9 32 f8 ff ff       	jmp    101e4d <__alltraps>

0010261b <vector197>:
.globl vector197
vector197:
  pushl $0
  10261b:	6a 00                	push   $0x0
  pushl $197
  10261d:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102622:	e9 26 f8 ff ff       	jmp    101e4d <__alltraps>

00102627 <vector198>:
.globl vector198
vector198:
  pushl $0
  102627:	6a 00                	push   $0x0
  pushl $198
  102629:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10262e:	e9 1a f8 ff ff       	jmp    101e4d <__alltraps>

00102633 <vector199>:
.globl vector199
vector199:
  pushl $0
  102633:	6a 00                	push   $0x0
  pushl $199
  102635:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10263a:	e9 0e f8 ff ff       	jmp    101e4d <__alltraps>

0010263f <vector200>:
.globl vector200
vector200:
  pushl $0
  10263f:	6a 00                	push   $0x0
  pushl $200
  102641:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102646:	e9 02 f8 ff ff       	jmp    101e4d <__alltraps>

0010264b <vector201>:
.globl vector201
vector201:
  pushl $0
  10264b:	6a 00                	push   $0x0
  pushl $201
  10264d:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102652:	e9 f6 f7 ff ff       	jmp    101e4d <__alltraps>

00102657 <vector202>:
.globl vector202
vector202:
  pushl $0
  102657:	6a 00                	push   $0x0
  pushl $202
  102659:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10265e:	e9 ea f7 ff ff       	jmp    101e4d <__alltraps>

00102663 <vector203>:
.globl vector203
vector203:
  pushl $0
  102663:	6a 00                	push   $0x0
  pushl $203
  102665:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10266a:	e9 de f7 ff ff       	jmp    101e4d <__alltraps>

0010266f <vector204>:
.globl vector204
vector204:
  pushl $0
  10266f:	6a 00                	push   $0x0
  pushl $204
  102671:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102676:	e9 d2 f7 ff ff       	jmp    101e4d <__alltraps>

0010267b <vector205>:
.globl vector205
vector205:
  pushl $0
  10267b:	6a 00                	push   $0x0
  pushl $205
  10267d:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102682:	e9 c6 f7 ff ff       	jmp    101e4d <__alltraps>

00102687 <vector206>:
.globl vector206
vector206:
  pushl $0
  102687:	6a 00                	push   $0x0
  pushl $206
  102689:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10268e:	e9 ba f7 ff ff       	jmp    101e4d <__alltraps>

00102693 <vector207>:
.globl vector207
vector207:
  pushl $0
  102693:	6a 00                	push   $0x0
  pushl $207
  102695:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10269a:	e9 ae f7 ff ff       	jmp    101e4d <__alltraps>

0010269f <vector208>:
.globl vector208
vector208:
  pushl $0
  10269f:	6a 00                	push   $0x0
  pushl $208
  1026a1:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026a6:	e9 a2 f7 ff ff       	jmp    101e4d <__alltraps>

001026ab <vector209>:
.globl vector209
vector209:
  pushl $0
  1026ab:	6a 00                	push   $0x0
  pushl $209
  1026ad:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1026b2:	e9 96 f7 ff ff       	jmp    101e4d <__alltraps>

001026b7 <vector210>:
.globl vector210
vector210:
  pushl $0
  1026b7:	6a 00                	push   $0x0
  pushl $210
  1026b9:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1026be:	e9 8a f7 ff ff       	jmp    101e4d <__alltraps>

001026c3 <vector211>:
.globl vector211
vector211:
  pushl $0
  1026c3:	6a 00                	push   $0x0
  pushl $211
  1026c5:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1026ca:	e9 7e f7 ff ff       	jmp    101e4d <__alltraps>

001026cf <vector212>:
.globl vector212
vector212:
  pushl $0
  1026cf:	6a 00                	push   $0x0
  pushl $212
  1026d1:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1026d6:	e9 72 f7 ff ff       	jmp    101e4d <__alltraps>

001026db <vector213>:
.globl vector213
vector213:
  pushl $0
  1026db:	6a 00                	push   $0x0
  pushl $213
  1026dd:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1026e2:	e9 66 f7 ff ff       	jmp    101e4d <__alltraps>

001026e7 <vector214>:
.globl vector214
vector214:
  pushl $0
  1026e7:	6a 00                	push   $0x0
  pushl $214
  1026e9:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026ee:	e9 5a f7 ff ff       	jmp    101e4d <__alltraps>

001026f3 <vector215>:
.globl vector215
vector215:
  pushl $0
  1026f3:	6a 00                	push   $0x0
  pushl $215
  1026f5:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026fa:	e9 4e f7 ff ff       	jmp    101e4d <__alltraps>

001026ff <vector216>:
.globl vector216
vector216:
  pushl $0
  1026ff:	6a 00                	push   $0x0
  pushl $216
  102701:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102706:	e9 42 f7 ff ff       	jmp    101e4d <__alltraps>

0010270b <vector217>:
.globl vector217
vector217:
  pushl $0
  10270b:	6a 00                	push   $0x0
  pushl $217
  10270d:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102712:	e9 36 f7 ff ff       	jmp    101e4d <__alltraps>

00102717 <vector218>:
.globl vector218
vector218:
  pushl $0
  102717:	6a 00                	push   $0x0
  pushl $218
  102719:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10271e:	e9 2a f7 ff ff       	jmp    101e4d <__alltraps>

00102723 <vector219>:
.globl vector219
vector219:
  pushl $0
  102723:	6a 00                	push   $0x0
  pushl $219
  102725:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10272a:	e9 1e f7 ff ff       	jmp    101e4d <__alltraps>

0010272f <vector220>:
.globl vector220
vector220:
  pushl $0
  10272f:	6a 00                	push   $0x0
  pushl $220
  102731:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102736:	e9 12 f7 ff ff       	jmp    101e4d <__alltraps>

0010273b <vector221>:
.globl vector221
vector221:
  pushl $0
  10273b:	6a 00                	push   $0x0
  pushl $221
  10273d:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102742:	e9 06 f7 ff ff       	jmp    101e4d <__alltraps>

00102747 <vector222>:
.globl vector222
vector222:
  pushl $0
  102747:	6a 00                	push   $0x0
  pushl $222
  102749:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10274e:	e9 fa f6 ff ff       	jmp    101e4d <__alltraps>

00102753 <vector223>:
.globl vector223
vector223:
  pushl $0
  102753:	6a 00                	push   $0x0
  pushl $223
  102755:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10275a:	e9 ee f6 ff ff       	jmp    101e4d <__alltraps>

0010275f <vector224>:
.globl vector224
vector224:
  pushl $0
  10275f:	6a 00                	push   $0x0
  pushl $224
  102761:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102766:	e9 e2 f6 ff ff       	jmp    101e4d <__alltraps>

0010276b <vector225>:
.globl vector225
vector225:
  pushl $0
  10276b:	6a 00                	push   $0x0
  pushl $225
  10276d:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102772:	e9 d6 f6 ff ff       	jmp    101e4d <__alltraps>

00102777 <vector226>:
.globl vector226
vector226:
  pushl $0
  102777:	6a 00                	push   $0x0
  pushl $226
  102779:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10277e:	e9 ca f6 ff ff       	jmp    101e4d <__alltraps>

00102783 <vector227>:
.globl vector227
vector227:
  pushl $0
  102783:	6a 00                	push   $0x0
  pushl $227
  102785:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10278a:	e9 be f6 ff ff       	jmp    101e4d <__alltraps>

0010278f <vector228>:
.globl vector228
vector228:
  pushl $0
  10278f:	6a 00                	push   $0x0
  pushl $228
  102791:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102796:	e9 b2 f6 ff ff       	jmp    101e4d <__alltraps>

0010279b <vector229>:
.globl vector229
vector229:
  pushl $0
  10279b:	6a 00                	push   $0x0
  pushl $229
  10279d:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027a2:	e9 a6 f6 ff ff       	jmp    101e4d <__alltraps>

001027a7 <vector230>:
.globl vector230
vector230:
  pushl $0
  1027a7:	6a 00                	push   $0x0
  pushl $230
  1027a9:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027ae:	e9 9a f6 ff ff       	jmp    101e4d <__alltraps>

001027b3 <vector231>:
.globl vector231
vector231:
  pushl $0
  1027b3:	6a 00                	push   $0x0
  pushl $231
  1027b5:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027ba:	e9 8e f6 ff ff       	jmp    101e4d <__alltraps>

001027bf <vector232>:
.globl vector232
vector232:
  pushl $0
  1027bf:	6a 00                	push   $0x0
  pushl $232
  1027c1:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1027c6:	e9 82 f6 ff ff       	jmp    101e4d <__alltraps>

001027cb <vector233>:
.globl vector233
vector233:
  pushl $0
  1027cb:	6a 00                	push   $0x0
  pushl $233
  1027cd:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1027d2:	e9 76 f6 ff ff       	jmp    101e4d <__alltraps>

001027d7 <vector234>:
.globl vector234
vector234:
  pushl $0
  1027d7:	6a 00                	push   $0x0
  pushl $234
  1027d9:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1027de:	e9 6a f6 ff ff       	jmp    101e4d <__alltraps>

001027e3 <vector235>:
.globl vector235
vector235:
  pushl $0
  1027e3:	6a 00                	push   $0x0
  pushl $235
  1027e5:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1027ea:	e9 5e f6 ff ff       	jmp    101e4d <__alltraps>

001027ef <vector236>:
.globl vector236
vector236:
  pushl $0
  1027ef:	6a 00                	push   $0x0
  pushl $236
  1027f1:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027f6:	e9 52 f6 ff ff       	jmp    101e4d <__alltraps>

001027fb <vector237>:
.globl vector237
vector237:
  pushl $0
  1027fb:	6a 00                	push   $0x0
  pushl $237
  1027fd:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102802:	e9 46 f6 ff ff       	jmp    101e4d <__alltraps>

00102807 <vector238>:
.globl vector238
vector238:
  pushl $0
  102807:	6a 00                	push   $0x0
  pushl $238
  102809:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10280e:	e9 3a f6 ff ff       	jmp    101e4d <__alltraps>

00102813 <vector239>:
.globl vector239
vector239:
  pushl $0
  102813:	6a 00                	push   $0x0
  pushl $239
  102815:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10281a:	e9 2e f6 ff ff       	jmp    101e4d <__alltraps>

0010281f <vector240>:
.globl vector240
vector240:
  pushl $0
  10281f:	6a 00                	push   $0x0
  pushl $240
  102821:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102826:	e9 22 f6 ff ff       	jmp    101e4d <__alltraps>

0010282b <vector241>:
.globl vector241
vector241:
  pushl $0
  10282b:	6a 00                	push   $0x0
  pushl $241
  10282d:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102832:	e9 16 f6 ff ff       	jmp    101e4d <__alltraps>

00102837 <vector242>:
.globl vector242
vector242:
  pushl $0
  102837:	6a 00                	push   $0x0
  pushl $242
  102839:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10283e:	e9 0a f6 ff ff       	jmp    101e4d <__alltraps>

00102843 <vector243>:
.globl vector243
vector243:
  pushl $0
  102843:	6a 00                	push   $0x0
  pushl $243
  102845:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10284a:	e9 fe f5 ff ff       	jmp    101e4d <__alltraps>

0010284f <vector244>:
.globl vector244
vector244:
  pushl $0
  10284f:	6a 00                	push   $0x0
  pushl $244
  102851:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102856:	e9 f2 f5 ff ff       	jmp    101e4d <__alltraps>

0010285b <vector245>:
.globl vector245
vector245:
  pushl $0
  10285b:	6a 00                	push   $0x0
  pushl $245
  10285d:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102862:	e9 e6 f5 ff ff       	jmp    101e4d <__alltraps>

00102867 <vector246>:
.globl vector246
vector246:
  pushl $0
  102867:	6a 00                	push   $0x0
  pushl $246
  102869:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10286e:	e9 da f5 ff ff       	jmp    101e4d <__alltraps>

00102873 <vector247>:
.globl vector247
vector247:
  pushl $0
  102873:	6a 00                	push   $0x0
  pushl $247
  102875:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10287a:	e9 ce f5 ff ff       	jmp    101e4d <__alltraps>

0010287f <vector248>:
.globl vector248
vector248:
  pushl $0
  10287f:	6a 00                	push   $0x0
  pushl $248
  102881:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102886:	e9 c2 f5 ff ff       	jmp    101e4d <__alltraps>

0010288b <vector249>:
.globl vector249
vector249:
  pushl $0
  10288b:	6a 00                	push   $0x0
  pushl $249
  10288d:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102892:	e9 b6 f5 ff ff       	jmp    101e4d <__alltraps>

00102897 <vector250>:
.globl vector250
vector250:
  pushl $0
  102897:	6a 00                	push   $0x0
  pushl $250
  102899:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10289e:	e9 aa f5 ff ff       	jmp    101e4d <__alltraps>

001028a3 <vector251>:
.globl vector251
vector251:
  pushl $0
  1028a3:	6a 00                	push   $0x0
  pushl $251
  1028a5:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028aa:	e9 9e f5 ff ff       	jmp    101e4d <__alltraps>

001028af <vector252>:
.globl vector252
vector252:
  pushl $0
  1028af:	6a 00                	push   $0x0
  pushl $252
  1028b1:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1028b6:	e9 92 f5 ff ff       	jmp    101e4d <__alltraps>

001028bb <vector253>:
.globl vector253
vector253:
  pushl $0
  1028bb:	6a 00                	push   $0x0
  pushl $253
  1028bd:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1028c2:	e9 86 f5 ff ff       	jmp    101e4d <__alltraps>

001028c7 <vector254>:
.globl vector254
vector254:
  pushl $0
  1028c7:	6a 00                	push   $0x0
  pushl $254
  1028c9:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1028ce:	e9 7a f5 ff ff       	jmp    101e4d <__alltraps>

001028d3 <vector255>:
.globl vector255
vector255:
  pushl $0
  1028d3:	6a 00                	push   $0x0
  pushl $255
  1028d5:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1028da:	e9 6e f5 ff ff       	jmp    101e4d <__alltraps>

001028df <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1028df:	55                   	push   %ebp
  1028e0:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1028e2:	8b 55 08             	mov    0x8(%ebp),%edx
  1028e5:	a1 64 89 11 00       	mov    0x118964,%eax
  1028ea:	29 c2                	sub    %eax,%edx
  1028ec:	89 d0                	mov    %edx,%eax
  1028ee:	c1 f8 02             	sar    $0x2,%eax
  1028f1:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1028f7:	5d                   	pop    %ebp
  1028f8:	c3                   	ret    

001028f9 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1028f9:	55                   	push   %ebp
  1028fa:	89 e5                	mov    %esp,%ebp
  1028fc:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1028ff:	8b 45 08             	mov    0x8(%ebp),%eax
  102902:	89 04 24             	mov    %eax,(%esp)
  102905:	e8 d5 ff ff ff       	call   1028df <page2ppn>
  10290a:	c1 e0 0c             	shl    $0xc,%eax
}
  10290d:	c9                   	leave  
  10290e:	c3                   	ret    

0010290f <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  10290f:	55                   	push   %ebp
  102910:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102912:	8b 45 08             	mov    0x8(%ebp),%eax
  102915:	8b 00                	mov    (%eax),%eax
}
  102917:	5d                   	pop    %ebp
  102918:	c3                   	ret    

00102919 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102919:	55                   	push   %ebp
  10291a:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  10291c:	8b 45 08             	mov    0x8(%ebp),%eax
  10291f:	8b 55 0c             	mov    0xc(%ebp),%edx
  102922:	89 10                	mov    %edx,(%eax)
}
  102924:	5d                   	pop    %ebp
  102925:	c3                   	ret    

00102926 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  102926:	55                   	push   %ebp
  102927:	89 e5                	mov    %esp,%ebp
  102929:	83 ec 10             	sub    $0x10,%esp
  10292c:	c7 45 fc 50 89 11 00 	movl   $0x118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102933:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102936:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102939:	89 50 04             	mov    %edx,0x4(%eax)
  10293c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10293f:	8b 50 04             	mov    0x4(%eax),%edx
  102942:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102945:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  102947:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  10294e:	00 00 00 
}
  102951:	c9                   	leave  
  102952:	c3                   	ret    

00102953 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  102953:	55                   	push   %ebp
  102954:	89 e5                	mov    %esp,%ebp
  102956:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  102959:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10295d:	75 24                	jne    102983 <default_init_memmap+0x30>
  10295f:	c7 44 24 0c d0 66 10 	movl   $0x1066d0,0xc(%esp)
  102966:	00 
  102967:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10296e:	00 
  10296f:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  102976:	00 
  102977:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10297e:	e8 28 e3 ff ff       	call   100cab <__panic>
    struct Page *p = base;
  102983:	8b 45 08             	mov    0x8(%ebp),%eax
  102986:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102989:	e9 dc 00 00 00       	jmp    102a6a <default_init_memmap+0x117>
        assert(PageReserved(p));
  10298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102991:	83 c0 04             	add    $0x4,%eax
  102994:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  10299b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10299e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1029a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029a4:	0f a3 10             	bt     %edx,(%eax)
  1029a7:	19 c0                	sbb    %eax,%eax
  1029a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1029ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1029b0:	0f 95 c0             	setne  %al
  1029b3:	0f b6 c0             	movzbl %al,%eax
  1029b6:	85 c0                	test   %eax,%eax
  1029b8:	75 24                	jne    1029de <default_init_memmap+0x8b>
  1029ba:	c7 44 24 0c 01 67 10 	movl   $0x106701,0xc(%esp)
  1029c1:	00 
  1029c2:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1029c9:	00 
  1029ca:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  1029d1:	00 
  1029d2:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1029d9:	e8 cd e2 ff ff       	call   100cab <__panic>
        p->flags = 0;
  1029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
  1029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029eb:	83 c0 04             	add    $0x4,%eax
  1029ee:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  1029f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1029f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1029fe:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
  102a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a04:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
  102a0b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102a12:	00 
  102a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a16:	89 04 24             	mov    %eax,(%esp)
  102a19:	e8 fb fe ff ff       	call   102919 <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
  102a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a21:	83 c0 0c             	add    $0xc,%eax
  102a24:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
  102a2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102a2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a31:	8b 00                	mov    (%eax),%eax
  102a33:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102a36:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102a39:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102a3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a3f:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102a42:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a45:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a48:	89 10                	mov    %edx,(%eax)
  102a4a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a4d:	8b 10                	mov    (%eax),%edx
  102a4f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102a52:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102a55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a58:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102a5b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102a5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a61:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102a64:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102a66:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102a6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a6d:	89 d0                	mov    %edx,%eax
  102a6f:	c1 e0 02             	shl    $0x2,%eax
  102a72:	01 d0                	add    %edx,%eax
  102a74:	c1 e0 02             	shl    $0x2,%eax
  102a77:	89 c2                	mov    %eax,%edx
  102a79:	8b 45 08             	mov    0x8(%ebp),%eax
  102a7c:	01 d0                	add    %edx,%eax
  102a7e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102a81:	0f 85 07 ff ff ff    	jne    10298e <default_init_memmap+0x3b>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
  102a87:	8b 45 08             	mov    0x8(%ebp),%eax
  102a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a8d:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
  102a90:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102a96:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a99:	01 d0                	add    %edx,%eax
  102a9b:	a3 58 89 11 00       	mov    %eax,0x118958
}
  102aa0:	c9                   	leave  
  102aa1:	c3                   	ret    

00102aa2 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102aa2:	55                   	push   %ebp
  102aa3:	89 e5                	mov    %esp,%ebp
  102aa5:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102aa8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102aac:	75 24                	jne    102ad2 <default_alloc_pages+0x30>
  102aae:	c7 44 24 0c d0 66 10 	movl   $0x1066d0,0xc(%esp)
  102ab5:	00 
  102ab6:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102abd:	00 
  102abe:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
  102ac5:	00 
  102ac6:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102acd:	e8 d9 e1 ff ff       	call   100cab <__panic>
    if (n > nr_free) {
  102ad2:	a1 58 89 11 00       	mov    0x118958,%eax
  102ad7:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ada:	73 0a                	jae    102ae6 <default_alloc_pages+0x44>
        return NULL;
  102adc:	b8 00 00 00 00       	mov    $0x0,%eax
  102ae1:	e9 37 01 00 00       	jmp    102c1d <default_alloc_pages+0x17b>
    }
    list_entry_t *le, *len;
    le = &free_list;
  102ae6:	c7 45 f4 50 89 11 00 	movl   $0x118950,-0xc(%ebp)
    while((le=list_next(le)) != &free_list) {
  102aed:	e9 0a 01 00 00       	jmp    102bfc <default_alloc_pages+0x15a>
      struct Page *p = le2page(le, page_link);
  102af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102af5:	83 e8 0c             	sub    $0xc,%eax
  102af8:	89 45 ec             	mov    %eax,-0x14(%ebp)
      ClearPageProperty(p);
  102afb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102afe:	83 c0 04             	add    $0x4,%eax
  102b01:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102b08:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102b11:	0f b3 10             	btr    %edx,(%eax)
      SetPageReserved(p);
  102b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b17:	83 c0 04             	add    $0x4,%eax
  102b1a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  102b21:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102b27:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102b2a:	0f ab 10             	bts    %edx,(%eax)
      if(p->property >= n){
  102b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b30:	8b 40 08             	mov    0x8(%eax),%eax
  102b33:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b36:	0f 82 c0 00 00 00    	jb     102bfc <default_alloc_pages+0x15a>
        int i;
        for(i=0;i<n;i++){
  102b3c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102b43:	eb 7c                	jmp    102bc1 <default_alloc_pages+0x11f>
  102b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b48:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102b4b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b4e:	8b 40 04             	mov    0x4(%eax),%eax
          len = list_next(le);
  102b51:	89 45 e8             	mov    %eax,-0x18(%ebp)
          struct Page *pp = le2page(le, page_link);
  102b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b57:	83 e8 0c             	sub    $0xc,%eax
  102b5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          SetPageReserved(pp);
  102b5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b60:	83 c0 04             	add    $0x4,%eax
  102b63:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  102b6a:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102b6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102b70:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102b73:	0f ab 10             	bts    %edx,(%eax)
          ClearPageProperty(pp);
  102b76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b79:	83 c0 04             	add    $0x4,%eax
  102b7c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  102b83:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b86:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102b89:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102b8c:	0f b3 10             	btr    %edx,(%eax)
  102b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b92:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102b95:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102b98:	8b 40 04             	mov    0x4(%eax),%eax
  102b9b:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102b9e:	8b 12                	mov    (%edx),%edx
  102ba0:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102ba3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102ba6:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102ba9:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102bac:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102baf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102bb2:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102bb5:	89 10                	mov    %edx,(%eax)
          list_del(le);//由于各页本身是链在一起的分配出去的页只需给出第一个页的地址，不用管从空闲页链表中删除这些页后这些页的指针是否会丢失
          le = len;
  102bb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bba:	89 45 f4             	mov    %eax,-0xc(%ebp)
      struct Page *p = le2page(le, page_link);
      ClearPageProperty(p);
      SetPageReserved(p);
      if(p->property >= n){
        int i;
        for(i=0;i<n;i++){
  102bbd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  102bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bc4:	3b 45 08             	cmp    0x8(%ebp),%eax
  102bc7:	0f 82 78 ff ff ff    	jb     102b45 <default_alloc_pages+0xa3>
          SetPageReserved(pp);
          ClearPageProperty(pp);
          list_del(le);//由于各页本身是链在一起的分配出去的页只需给出第一个页的地址，不用管从空闲页链表中删除这些页后这些页的指针是否会丢失
          le = len;
        }
        if(p->property>n){
  102bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102bd0:	8b 40 08             	mov    0x8(%eax),%eax
  102bd3:	3b 45 08             	cmp    0x8(%ebp),%eax
  102bd6:	76 12                	jbe    102bea <default_alloc_pages+0x148>
          (le2page(le,page_link))->property = p->property - n;//重新设置空闲块的起始页
  102bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bdb:	8d 50 f4             	lea    -0xc(%eax),%edx
  102bde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102be1:	8b 40 08             	mov    0x8(%eax),%eax
  102be4:	2b 45 08             	sub    0x8(%ebp),%eax
  102be7:	89 42 08             	mov    %eax,0x8(%edx)
        }
        nr_free -= n;
  102bea:	a1 58 89 11 00       	mov    0x118958,%eax
  102bef:	2b 45 08             	sub    0x8(%ebp),%eax
  102bf2:	a3 58 89 11 00       	mov    %eax,0x118958
        return p;
  102bf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102bfa:	eb 21                	jmp    102c1d <default_alloc_pages+0x17b>
  102bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bff:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102c02:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102c05:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    list_entry_t *le, *len;
    le = &free_list;
    while((le=list_next(le)) != &free_list) {
  102c08:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c0b:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102c12:	0f 85 da fe ff ff    	jne    102af2 <default_alloc_pages+0x50>
        }
        nr_free -= n;
        return p;
      }
    }
    return NULL;
  102c18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c1d:	c9                   	leave  
  102c1e:	c3                   	ret    

00102c1f <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102c1f:	55                   	push   %ebp
  102c20:	89 e5                	mov    %esp,%ebp
  102c22:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102c25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c29:	75 24                	jne    102c4f <default_free_pages+0x30>
  102c2b:	c7 44 24 0c d0 66 10 	movl   $0x1066d0,0xc(%esp)
  102c32:	00 
  102c33:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102c3a:	00 
  102c3b:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
  102c42:	00 
  102c43:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102c4a:	e8 5c e0 ff ff       	call   100cab <__panic>
    assert(PageReserved(base));
  102c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  102c52:	83 c0 04             	add    $0x4,%eax
  102c55:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102c5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c62:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c65:	0f a3 10             	bt     %edx,(%eax)
  102c68:	19 c0                	sbb    %eax,%eax
  102c6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  102c6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102c71:	0f 95 c0             	setne  %al
  102c74:	0f b6 c0             	movzbl %al,%eax
  102c77:	85 c0                	test   %eax,%eax
  102c79:	75 24                	jne    102c9f <default_free_pages+0x80>
  102c7b:	c7 44 24 0c 11 67 10 	movl   $0x106711,0xc(%esp)
  102c82:	00 
  102c83:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102c8a:	00 
  102c8b:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
  102c92:	00 
  102c93:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102c9a:	e8 0c e0 ff ff       	call   100cab <__panic>

    list_entry_t *le = &free_list;
  102c9f:	c7 45 f4 50 89 11 00 	movl   $0x118950,-0xc(%ebp)
    struct Page * p;
    //找到第一个起始页地址大于释放块起始页地址的空闲页
    while((le=list_next(le)) != &free_list) {
  102ca6:	eb 13                	jmp    102cbb <default_free_pages+0x9c>
      p = le2page(le, page_link);
  102ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cab:	83 e8 0c             	sub    $0xc,%eax
  102cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(p>base){
  102cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cb4:	3b 45 08             	cmp    0x8(%ebp),%eax
  102cb7:	76 02                	jbe    102cbb <default_free_pages+0x9c>
        break;
  102cb9:	eb 18                	jmp    102cd3 <default_free_pages+0xb4>
  102cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102cc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cc4:	8b 40 04             	mov    0x4(%eax),%eax
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page * p;
    //找到第一个起始页地址大于释放块起始页地址的空闲页
    while((le=list_next(le)) != &free_list) {
  102cc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cca:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102cd1:	75 d5                	jne    102ca8 <default_free_pages+0x89>
      if(p>base){
        break;
      }
    }
    //不断在空闲链中插入要释放的页，插入点在刚找到的空闲页之前，这样可以保证空闲链中的各页还是地址从小到大有序的
    for(p=base;p<base+n;p++){
  102cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  102cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102cd9:	eb 4b                	jmp    102d26 <default_free_pages+0x107>
      list_add_before(le, &(p->page_link));
  102cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cde:	8d 50 0c             	lea    0xc(%eax),%edx
  102ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ce4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  102ce7:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102cea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ced:	8b 00                	mov    (%eax),%eax
  102cef:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102cf2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102cf5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102cf8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102cfb:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102cfe:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102d01:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102d04:	89 10                	mov    %edx,(%eax)
  102d06:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102d09:	8b 10                	mov    (%eax),%edx
  102d0b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102d0e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102d11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102d14:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102d17:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102d1a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102d1d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102d20:	89 10                	mov    %edx,(%eax)
      if(p>base){
        break;
      }
    }
    //不断在空闲链中插入要释放的页，插入点在刚找到的空闲页之前，这样可以保证空闲链中的各页还是地址从小到大有序的
    for(p=base;p<base+n;p++){
  102d22:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
  102d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d29:	89 d0                	mov    %edx,%eax
  102d2b:	c1 e0 02             	shl    $0x2,%eax
  102d2e:	01 d0                	add    %edx,%eax
  102d30:	c1 e0 02             	shl    $0x2,%eax
  102d33:	89 c2                	mov    %eax,%edx
  102d35:	8b 45 08             	mov    0x8(%ebp),%eax
  102d38:	01 d0                	add    %edx,%eax
  102d3a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102d3d:	77 9c                	ja     102cdb <default_free_pages+0xbc>
      list_add_before(le, &(p->page_link));
    }
    //暂时先把释放的这n页初始化为一个空闲块
    base->flags = 0;
  102d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  102d42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
  102d49:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102d50:	00 
  102d51:	8b 45 08             	mov    0x8(%ebp),%eax
  102d54:	89 04 24             	mov    %eax,(%esp)
  102d57:	e8 bd fb ff ff       	call   102919 <set_page_ref>
    ClearPageProperty(base);
  102d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5f:	83 c0 04             	add    $0x4,%eax
  102d62:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  102d69:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d6c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d6f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102d72:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
  102d75:	8b 45 08             	mov    0x8(%ebp),%eax
  102d78:	83 c0 04             	add    $0x4,%eax
  102d7b:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  102d82:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d85:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102d88:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102d8b:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
  102d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  102d91:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d94:	89 50 08             	mov    %edx,0x8(%eax)
    
    //空闲页le刚好在释放的这个n页之后,则将以这个空闲页为首的空闲块合并到这n个释放页组成的空闲块中
    p = le2page(le,page_link) ;
  102d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d9a:	83 e8 0c             	sub    $0xc,%eax
  102d9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if( base+n == p ){
  102da0:	8b 55 0c             	mov    0xc(%ebp),%edx
  102da3:	89 d0                	mov    %edx,%eax
  102da5:	c1 e0 02             	shl    $0x2,%eax
  102da8:	01 d0                	add    %edx,%eax
  102daa:	c1 e0 02             	shl    $0x2,%eax
  102dad:	89 c2                	mov    %eax,%edx
  102daf:	8b 45 08             	mov    0x8(%ebp),%eax
  102db2:	01 d0                	add    %edx,%eax
  102db4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102db7:	75 1e                	jne    102dd7 <default_free_pages+0x1b8>
      base->property += p->property;
  102db9:	8b 45 08             	mov    0x8(%ebp),%eax
  102dbc:	8b 50 08             	mov    0x8(%eax),%edx
  102dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dc2:	8b 40 08             	mov    0x8(%eax),%eax
  102dc5:	01 c2                	add    %eax,%edx
  102dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  102dca:	89 50 08             	mov    %edx,0x8(%eax)
      p->property = 0;
  102dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dd0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    //从释放块的首页开始向前找，找到一个空闲块，把释放块和这一个空闲块合并
    le = list_prev(&(base->page_link));
  102dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  102dda:	83 c0 0c             	add    $0xc,%eax
  102ddd:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102de0:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102de3:	8b 00                	mov    (%eax),%eax
  102de5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
  102de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102deb:	83 e8 0c             	sub    $0xc,%eax
  102dee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(le!=&free_list && p==base-1){
  102df1:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102df8:	74 57                	je     102e51 <default_free_pages+0x232>
  102dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfd:	83 e8 14             	sub    $0x14,%eax
  102e00:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102e03:	75 4c                	jne    102e51 <default_free_pages+0x232>
      while(le!=&free_list){
  102e05:	eb 41                	jmp    102e48 <default_free_pages+0x229>
        if(p->property){
  102e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e0a:	8b 40 08             	mov    0x8(%eax),%eax
  102e0d:	85 c0                	test   %eax,%eax
  102e0f:	74 20                	je     102e31 <default_free_pages+0x212>
          p->property += base->property;
  102e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e14:	8b 50 08             	mov    0x8(%eax),%edx
  102e17:	8b 45 08             	mov    0x8(%ebp),%eax
  102e1a:	8b 40 08             	mov    0x8(%eax),%eax
  102e1d:	01 c2                	add    %eax,%edx
  102e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e22:	89 50 08             	mov    %edx,0x8(%eax)
          base->property = 0;
  102e25:	8b 45 08             	mov    0x8(%ebp),%eax
  102e28:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          break;
  102e2f:	eb 20                	jmp    102e51 <default_free_pages+0x232>
  102e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e34:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  102e37:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102e3a:	8b 00                	mov    (%eax),%eax
        }
        le = list_prev(le);
  102e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = le2page(le,page_link);
  102e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e42:	83 e8 0c             	sub    $0xc,%eax
  102e45:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    //从释放块的首页开始向前找，找到一个空闲块，把释放块和这一个空闲块合并
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if(le!=&free_list && p==base-1){
      while(le!=&free_list){
  102e48:	81 7d f4 50 89 11 00 	cmpl   $0x118950,-0xc(%ebp)
  102e4f:	75 b6                	jne    102e07 <default_free_pages+0x1e8>
        le = list_prev(le);
        p = le2page(le,page_link);
      }
    }
    //总空闲页数加n
    nr_free += n;
  102e51:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e5a:	01 d0                	add    %edx,%eax
  102e5c:	a3 58 89 11 00       	mov    %eax,0x118958
    return ;
  102e61:	90                   	nop
}
  102e62:	c9                   	leave  
  102e63:	c3                   	ret    

00102e64 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102e64:	55                   	push   %ebp
  102e65:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102e67:	a1 58 89 11 00       	mov    0x118958,%eax
}
  102e6c:	5d                   	pop    %ebp
  102e6d:	c3                   	ret    

00102e6e <basic_check>:

static void
basic_check(void) {
  102e6e:	55                   	push   %ebp
  102e6f:	89 e5                	mov    %esp,%ebp
  102e71:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102e74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e84:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102e87:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e8e:	e8 85 0e 00 00       	call   103d18 <alloc_pages>
  102e93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e96:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102e9a:	75 24                	jne    102ec0 <basic_check+0x52>
  102e9c:	c7 44 24 0c 24 67 10 	movl   $0x106724,0xc(%esp)
  102ea3:	00 
  102ea4:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102eab:	00 
  102eac:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
  102eb3:	00 
  102eb4:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102ebb:	e8 eb dd ff ff       	call   100cab <__panic>
    assert((p1 = alloc_page()) != NULL);
  102ec0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102ec7:	e8 4c 0e 00 00       	call   103d18 <alloc_pages>
  102ecc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ecf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102ed3:	75 24                	jne    102ef9 <basic_check+0x8b>
  102ed5:	c7 44 24 0c 40 67 10 	movl   $0x106740,0xc(%esp)
  102edc:	00 
  102edd:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102ee4:	00 
  102ee5:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  102eec:	00 
  102eed:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102ef4:	e8 b2 dd ff ff       	call   100cab <__panic>
    assert((p2 = alloc_page()) != NULL);
  102ef9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f00:	e8 13 0e 00 00       	call   103d18 <alloc_pages>
  102f05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102f0c:	75 24                	jne    102f32 <basic_check+0xc4>
  102f0e:	c7 44 24 0c 5c 67 10 	movl   $0x10675c,0xc(%esp)
  102f15:	00 
  102f16:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102f1d:	00 
  102f1e:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  102f25:	00 
  102f26:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102f2d:	e8 79 dd ff ff       	call   100cab <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102f32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f35:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102f38:	74 10                	je     102f4a <basic_check+0xdc>
  102f3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f3d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f40:	74 08                	je     102f4a <basic_check+0xdc>
  102f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f45:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102f48:	75 24                	jne    102f6e <basic_check+0x100>
  102f4a:	c7 44 24 0c 78 67 10 	movl   $0x106778,0xc(%esp)
  102f51:	00 
  102f52:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102f59:	00 
  102f5a:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
  102f61:	00 
  102f62:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102f69:	e8 3d dd ff ff       	call   100cab <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102f6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f71:	89 04 24             	mov    %eax,(%esp)
  102f74:	e8 96 f9 ff ff       	call   10290f <page_ref>
  102f79:	85 c0                	test   %eax,%eax
  102f7b:	75 1e                	jne    102f9b <basic_check+0x12d>
  102f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f80:	89 04 24             	mov    %eax,(%esp)
  102f83:	e8 87 f9 ff ff       	call   10290f <page_ref>
  102f88:	85 c0                	test   %eax,%eax
  102f8a:	75 0f                	jne    102f9b <basic_check+0x12d>
  102f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f8f:	89 04 24             	mov    %eax,(%esp)
  102f92:	e8 78 f9 ff ff       	call   10290f <page_ref>
  102f97:	85 c0                	test   %eax,%eax
  102f99:	74 24                	je     102fbf <basic_check+0x151>
  102f9b:	c7 44 24 0c 9c 67 10 	movl   $0x10679c,0xc(%esp)
  102fa2:	00 
  102fa3:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102faa:	00 
  102fab:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  102fb2:	00 
  102fb3:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102fba:	e8 ec dc ff ff       	call   100cab <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102fbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fc2:	89 04 24             	mov    %eax,(%esp)
  102fc5:	e8 2f f9 ff ff       	call   1028f9 <page2pa>
  102fca:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102fd0:	c1 e2 0c             	shl    $0xc,%edx
  102fd3:	39 d0                	cmp    %edx,%eax
  102fd5:	72 24                	jb     102ffb <basic_check+0x18d>
  102fd7:	c7 44 24 0c d8 67 10 	movl   $0x1067d8,0xc(%esp)
  102fde:	00 
  102fdf:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  102fe6:	00 
  102fe7:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  102fee:	00 
  102fef:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  102ff6:	e8 b0 dc ff ff       	call   100cab <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ffe:	89 04 24             	mov    %eax,(%esp)
  103001:	e8 f3 f8 ff ff       	call   1028f9 <page2pa>
  103006:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  10300c:	c1 e2 0c             	shl    $0xc,%edx
  10300f:	39 d0                	cmp    %edx,%eax
  103011:	72 24                	jb     103037 <basic_check+0x1c9>
  103013:	c7 44 24 0c f5 67 10 	movl   $0x1067f5,0xc(%esp)
  10301a:	00 
  10301b:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103022:	00 
  103023:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  10302a:	00 
  10302b:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103032:	e8 74 dc ff ff       	call   100cab <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  103037:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10303a:	89 04 24             	mov    %eax,(%esp)
  10303d:	e8 b7 f8 ff ff       	call   1028f9 <page2pa>
  103042:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103048:	c1 e2 0c             	shl    $0xc,%edx
  10304b:	39 d0                	cmp    %edx,%eax
  10304d:	72 24                	jb     103073 <basic_check+0x205>
  10304f:	c7 44 24 0c 12 68 10 	movl   $0x106812,0xc(%esp)
  103056:	00 
  103057:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10305e:	00 
  10305f:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  103066:	00 
  103067:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10306e:	e8 38 dc ff ff       	call   100cab <__panic>

    list_entry_t free_list_store = free_list;
  103073:	a1 50 89 11 00       	mov    0x118950,%eax
  103078:	8b 15 54 89 11 00    	mov    0x118954,%edx
  10307e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103081:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103084:	c7 45 e0 50 89 11 00 	movl   $0x118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10308b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10308e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103091:	89 50 04             	mov    %edx,0x4(%eax)
  103094:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103097:	8b 50 04             	mov    0x4(%eax),%edx
  10309a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10309d:	89 10                	mov    %edx,(%eax)
  10309f:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1030a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1030a9:	8b 40 04             	mov    0x4(%eax),%eax
  1030ac:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1030af:	0f 94 c0             	sete   %al
  1030b2:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1030b5:	85 c0                	test   %eax,%eax
  1030b7:	75 24                	jne    1030dd <basic_check+0x26f>
  1030b9:	c7 44 24 0c 2f 68 10 	movl   $0x10682f,0xc(%esp)
  1030c0:	00 
  1030c1:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1030c8:	00 
  1030c9:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
  1030d0:	00 
  1030d1:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1030d8:	e8 ce db ff ff       	call   100cab <__panic>

    unsigned int nr_free_store = nr_free;
  1030dd:	a1 58 89 11 00       	mov    0x118958,%eax
  1030e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  1030e5:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  1030ec:	00 00 00 

    assert(alloc_page() == NULL);
  1030ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030f6:	e8 1d 0c 00 00       	call   103d18 <alloc_pages>
  1030fb:	85 c0                	test   %eax,%eax
  1030fd:	74 24                	je     103123 <basic_check+0x2b5>
  1030ff:	c7 44 24 0c 46 68 10 	movl   $0x106846,0xc(%esp)
  103106:	00 
  103107:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10310e:	00 
  10310f:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
  103116:	00 
  103117:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10311e:	e8 88 db ff ff       	call   100cab <__panic>

    free_page(p0);
  103123:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10312a:	00 
  10312b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10312e:	89 04 24             	mov    %eax,(%esp)
  103131:	e8 1a 0c 00 00       	call   103d50 <free_pages>
    free_page(p1);
  103136:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10313d:	00 
  10313e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103141:	89 04 24             	mov    %eax,(%esp)
  103144:	e8 07 0c 00 00       	call   103d50 <free_pages>
    free_page(p2);
  103149:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103150:	00 
  103151:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103154:	89 04 24             	mov    %eax,(%esp)
  103157:	e8 f4 0b 00 00       	call   103d50 <free_pages>
    assert(nr_free == 3);
  10315c:	a1 58 89 11 00       	mov    0x118958,%eax
  103161:	83 f8 03             	cmp    $0x3,%eax
  103164:	74 24                	je     10318a <basic_check+0x31c>
  103166:	c7 44 24 0c 5b 68 10 	movl   $0x10685b,0xc(%esp)
  10316d:	00 
  10316e:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103175:	00 
  103176:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
  10317d:	00 
  10317e:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103185:	e8 21 db ff ff       	call   100cab <__panic>

    assert((p0 = alloc_page()) != NULL);
  10318a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103191:	e8 82 0b 00 00       	call   103d18 <alloc_pages>
  103196:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103199:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  10319d:	75 24                	jne    1031c3 <basic_check+0x355>
  10319f:	c7 44 24 0c 24 67 10 	movl   $0x106724,0xc(%esp)
  1031a6:	00 
  1031a7:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1031ae:	00 
  1031af:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
  1031b6:	00 
  1031b7:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1031be:	e8 e8 da ff ff       	call   100cab <__panic>
    assert((p1 = alloc_page()) != NULL);
  1031c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031ca:	e8 49 0b 00 00       	call   103d18 <alloc_pages>
  1031cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1031d6:	75 24                	jne    1031fc <basic_check+0x38e>
  1031d8:	c7 44 24 0c 40 67 10 	movl   $0x106740,0xc(%esp)
  1031df:	00 
  1031e0:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1031e7:	00 
  1031e8:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
  1031ef:	00 
  1031f0:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1031f7:	e8 af da ff ff       	call   100cab <__panic>
    assert((p2 = alloc_page()) != NULL);
  1031fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103203:	e8 10 0b 00 00       	call   103d18 <alloc_pages>
  103208:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10320b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10320f:	75 24                	jne    103235 <basic_check+0x3c7>
  103211:	c7 44 24 0c 5c 67 10 	movl   $0x10675c,0xc(%esp)
  103218:	00 
  103219:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103220:	00 
  103221:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
  103228:	00 
  103229:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103230:	e8 76 da ff ff       	call   100cab <__panic>

    assert(alloc_page() == NULL);
  103235:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10323c:	e8 d7 0a 00 00       	call   103d18 <alloc_pages>
  103241:	85 c0                	test   %eax,%eax
  103243:	74 24                	je     103269 <basic_check+0x3fb>
  103245:	c7 44 24 0c 46 68 10 	movl   $0x106846,0xc(%esp)
  10324c:	00 
  10324d:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103254:	00 
  103255:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
  10325c:	00 
  10325d:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103264:	e8 42 da ff ff       	call   100cab <__panic>

    free_page(p0);
  103269:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103270:	00 
  103271:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103274:	89 04 24             	mov    %eax,(%esp)
  103277:	e8 d4 0a 00 00       	call   103d50 <free_pages>
  10327c:	c7 45 d8 50 89 11 00 	movl   $0x118950,-0x28(%ebp)
  103283:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103286:	8b 40 04             	mov    0x4(%eax),%eax
  103289:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  10328c:	0f 94 c0             	sete   %al
  10328f:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  103292:	85 c0                	test   %eax,%eax
  103294:	74 24                	je     1032ba <basic_check+0x44c>
  103296:	c7 44 24 0c 68 68 10 	movl   $0x106868,0xc(%esp)
  10329d:	00 
  10329e:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1032a5:	00 
  1032a6:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
  1032ad:	00 
  1032ae:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1032b5:	e8 f1 d9 ff ff       	call   100cab <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1032ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032c1:	e8 52 0a 00 00       	call   103d18 <alloc_pages>
  1032c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1032c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1032cf:	74 24                	je     1032f5 <basic_check+0x487>
  1032d1:	c7 44 24 0c 80 68 10 	movl   $0x106880,0xc(%esp)
  1032d8:	00 
  1032d9:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1032e0:	00 
  1032e1:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  1032e8:	00 
  1032e9:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1032f0:	e8 b6 d9 ff ff       	call   100cab <__panic>
    assert(alloc_page() == NULL);
  1032f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032fc:	e8 17 0a 00 00       	call   103d18 <alloc_pages>
  103301:	85 c0                	test   %eax,%eax
  103303:	74 24                	je     103329 <basic_check+0x4bb>
  103305:	c7 44 24 0c 46 68 10 	movl   $0x106846,0xc(%esp)
  10330c:	00 
  10330d:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103314:	00 
  103315:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
  10331c:	00 
  10331d:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103324:	e8 82 d9 ff ff       	call   100cab <__panic>

    assert(nr_free == 0);
  103329:	a1 58 89 11 00       	mov    0x118958,%eax
  10332e:	85 c0                	test   %eax,%eax
  103330:	74 24                	je     103356 <basic_check+0x4e8>
  103332:	c7 44 24 0c 99 68 10 	movl   $0x106899,0xc(%esp)
  103339:	00 
  10333a:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103341:	00 
  103342:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  103349:	00 
  10334a:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103351:	e8 55 d9 ff ff       	call   100cab <__panic>
    free_list = free_list_store;
  103356:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103359:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10335c:	a3 50 89 11 00       	mov    %eax,0x118950
  103361:	89 15 54 89 11 00    	mov    %edx,0x118954
    nr_free = nr_free_store;
  103367:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10336a:	a3 58 89 11 00       	mov    %eax,0x118958

    free_page(p);
  10336f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103376:	00 
  103377:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10337a:	89 04 24             	mov    %eax,(%esp)
  10337d:	e8 ce 09 00 00       	call   103d50 <free_pages>
    free_page(p1);
  103382:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103389:	00 
  10338a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10338d:	89 04 24             	mov    %eax,(%esp)
  103390:	e8 bb 09 00 00       	call   103d50 <free_pages>
    free_page(p2);
  103395:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10339c:	00 
  10339d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033a0:	89 04 24             	mov    %eax,(%esp)
  1033a3:	e8 a8 09 00 00       	call   103d50 <free_pages>
}
  1033a8:	c9                   	leave  
  1033a9:	c3                   	ret    

001033aa <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1033aa:	55                   	push   %ebp
  1033ab:	89 e5                	mov    %esp,%ebp
  1033ad:	53                   	push   %ebx
  1033ae:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  1033b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1033bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1033c2:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1033c9:	eb 6b                	jmp    103436 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  1033cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033ce:	83 e8 0c             	sub    $0xc,%eax
  1033d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  1033d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033d7:	83 c0 04             	add    $0x4,%eax
  1033da:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1033e1:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1033e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1033e7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1033ea:	0f a3 10             	bt     %edx,(%eax)
  1033ed:	19 c0                	sbb    %eax,%eax
  1033ef:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  1033f2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  1033f6:	0f 95 c0             	setne  %al
  1033f9:	0f b6 c0             	movzbl %al,%eax
  1033fc:	85 c0                	test   %eax,%eax
  1033fe:	75 24                	jne    103424 <default_check+0x7a>
  103400:	c7 44 24 0c a6 68 10 	movl   $0x1068a6,0xc(%esp)
  103407:	00 
  103408:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10340f:	00 
  103410:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  103417:	00 
  103418:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10341f:	e8 87 d8 ff ff       	call   100cab <__panic>
        count ++, total += p->property;
  103424:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  103428:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10342b:	8b 50 08             	mov    0x8(%eax),%edx
  10342e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103431:	01 d0                	add    %edx,%eax
  103433:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103436:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103439:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10343c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10343f:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103442:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103445:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  10344c:	0f 85 79 ff ff ff    	jne    1033cb <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  103452:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  103455:	e8 28 09 00 00       	call   103d82 <nr_free_pages>
  10345a:	39 c3                	cmp    %eax,%ebx
  10345c:	74 24                	je     103482 <default_check+0xd8>
  10345e:	c7 44 24 0c b6 68 10 	movl   $0x1068b6,0xc(%esp)
  103465:	00 
  103466:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10346d:	00 
  10346e:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
  103475:	00 
  103476:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10347d:	e8 29 d8 ff ff       	call   100cab <__panic>

    basic_check();
  103482:	e8 e7 f9 ff ff       	call   102e6e <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  103487:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10348e:	e8 85 08 00 00       	call   103d18 <alloc_pages>
  103493:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  103496:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10349a:	75 24                	jne    1034c0 <default_check+0x116>
  10349c:	c7 44 24 0c cf 68 10 	movl   $0x1068cf,0xc(%esp)
  1034a3:	00 
  1034a4:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1034ab:	00 
  1034ac:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  1034b3:	00 
  1034b4:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1034bb:	e8 eb d7 ff ff       	call   100cab <__panic>
    assert(!PageProperty(p0));
  1034c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034c3:	83 c0 04             	add    $0x4,%eax
  1034c6:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  1034cd:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1034d0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  1034d3:	8b 55 c0             	mov    -0x40(%ebp),%edx
  1034d6:	0f a3 10             	bt     %edx,(%eax)
  1034d9:	19 c0                	sbb    %eax,%eax
  1034db:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  1034de:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  1034e2:	0f 95 c0             	setne  %al
  1034e5:	0f b6 c0             	movzbl %al,%eax
  1034e8:	85 c0                	test   %eax,%eax
  1034ea:	74 24                	je     103510 <default_check+0x166>
  1034ec:	c7 44 24 0c da 68 10 	movl   $0x1068da,0xc(%esp)
  1034f3:	00 
  1034f4:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1034fb:	00 
  1034fc:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  103503:	00 
  103504:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10350b:	e8 9b d7 ff ff       	call   100cab <__panic>

    list_entry_t free_list_store = free_list;
  103510:	a1 50 89 11 00       	mov    0x118950,%eax
  103515:	8b 15 54 89 11 00    	mov    0x118954,%edx
  10351b:	89 45 80             	mov    %eax,-0x80(%ebp)
  10351e:	89 55 84             	mov    %edx,-0x7c(%ebp)
  103521:	c7 45 b4 50 89 11 00 	movl   $0x118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103528:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10352b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10352e:	89 50 04             	mov    %edx,0x4(%eax)
  103531:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103534:	8b 50 04             	mov    0x4(%eax),%edx
  103537:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10353a:	89 10                	mov    %edx,(%eax)
  10353c:	c7 45 b0 50 89 11 00 	movl   $0x118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103543:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103546:	8b 40 04             	mov    0x4(%eax),%eax
  103549:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  10354c:	0f 94 c0             	sete   %al
  10354f:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103552:	85 c0                	test   %eax,%eax
  103554:	75 24                	jne    10357a <default_check+0x1d0>
  103556:	c7 44 24 0c 2f 68 10 	movl   $0x10682f,0xc(%esp)
  10355d:	00 
  10355e:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103565:	00 
  103566:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  10356d:	00 
  10356e:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103575:	e8 31 d7 ff ff       	call   100cab <__panic>
    assert(alloc_page() == NULL);
  10357a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103581:	e8 92 07 00 00       	call   103d18 <alloc_pages>
  103586:	85 c0                	test   %eax,%eax
  103588:	74 24                	je     1035ae <default_check+0x204>
  10358a:	c7 44 24 0c 46 68 10 	movl   $0x106846,0xc(%esp)
  103591:	00 
  103592:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103599:	00 
  10359a:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  1035a1:	00 
  1035a2:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1035a9:	e8 fd d6 ff ff       	call   100cab <__panic>

    unsigned int nr_free_store = nr_free;
  1035ae:	a1 58 89 11 00       	mov    0x118958,%eax
  1035b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1035b6:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  1035bd:	00 00 00 

    free_pages(p0 + 2, 3);
  1035c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035c3:	83 c0 28             	add    $0x28,%eax
  1035c6:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1035cd:	00 
  1035ce:	89 04 24             	mov    %eax,(%esp)
  1035d1:	e8 7a 07 00 00       	call   103d50 <free_pages>
    assert(alloc_pages(4) == NULL);
  1035d6:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1035dd:	e8 36 07 00 00       	call   103d18 <alloc_pages>
  1035e2:	85 c0                	test   %eax,%eax
  1035e4:	74 24                	je     10360a <default_check+0x260>
  1035e6:	c7 44 24 0c ec 68 10 	movl   $0x1068ec,0xc(%esp)
  1035ed:	00 
  1035ee:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1035f5:	00 
  1035f6:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  1035fd:	00 
  1035fe:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103605:	e8 a1 d6 ff ff       	call   100cab <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  10360a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10360d:	83 c0 28             	add    $0x28,%eax
  103610:	83 c0 04             	add    $0x4,%eax
  103613:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  10361a:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10361d:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103620:	8b 55 ac             	mov    -0x54(%ebp),%edx
  103623:	0f a3 10             	bt     %edx,(%eax)
  103626:	19 c0                	sbb    %eax,%eax
  103628:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  10362b:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  10362f:	0f 95 c0             	setne  %al
  103632:	0f b6 c0             	movzbl %al,%eax
  103635:	85 c0                	test   %eax,%eax
  103637:	74 0e                	je     103647 <default_check+0x29d>
  103639:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10363c:	83 c0 28             	add    $0x28,%eax
  10363f:	8b 40 08             	mov    0x8(%eax),%eax
  103642:	83 f8 03             	cmp    $0x3,%eax
  103645:	74 24                	je     10366b <default_check+0x2c1>
  103647:	c7 44 24 0c 04 69 10 	movl   $0x106904,0xc(%esp)
  10364e:	00 
  10364f:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103656:	00 
  103657:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  10365e:	00 
  10365f:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103666:	e8 40 d6 ff ff       	call   100cab <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  10366b:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  103672:	e8 a1 06 00 00       	call   103d18 <alloc_pages>
  103677:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10367a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10367e:	75 24                	jne    1036a4 <default_check+0x2fa>
  103680:	c7 44 24 0c 30 69 10 	movl   $0x106930,0xc(%esp)
  103687:	00 
  103688:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10368f:	00 
  103690:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
  103697:	00 
  103698:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10369f:	e8 07 d6 ff ff       	call   100cab <__panic>
    assert(alloc_page() == NULL);
  1036a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1036ab:	e8 68 06 00 00       	call   103d18 <alloc_pages>
  1036b0:	85 c0                	test   %eax,%eax
  1036b2:	74 24                	je     1036d8 <default_check+0x32e>
  1036b4:	c7 44 24 0c 46 68 10 	movl   $0x106846,0xc(%esp)
  1036bb:	00 
  1036bc:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1036c3:	00 
  1036c4:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  1036cb:	00 
  1036cc:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1036d3:	e8 d3 d5 ff ff       	call   100cab <__panic>
    assert(p0 + 2 == p1);
  1036d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036db:	83 c0 28             	add    $0x28,%eax
  1036de:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1036e1:	74 24                	je     103707 <default_check+0x35d>
  1036e3:	c7 44 24 0c 4e 69 10 	movl   $0x10694e,0xc(%esp)
  1036ea:	00 
  1036eb:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1036f2:	00 
  1036f3:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  1036fa:	00 
  1036fb:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103702:	e8 a4 d5 ff ff       	call   100cab <__panic>

    p2 = p0 + 1;
  103707:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10370a:	83 c0 14             	add    $0x14,%eax
  10370d:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  103710:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103717:	00 
  103718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10371b:	89 04 24             	mov    %eax,(%esp)
  10371e:	e8 2d 06 00 00       	call   103d50 <free_pages>
    free_pages(p1, 3);
  103723:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10372a:	00 
  10372b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10372e:	89 04 24             	mov    %eax,(%esp)
  103731:	e8 1a 06 00 00       	call   103d50 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  103736:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103739:	83 c0 04             	add    $0x4,%eax
  10373c:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  103743:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103746:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103749:	8b 55 a0             	mov    -0x60(%ebp),%edx
  10374c:	0f a3 10             	bt     %edx,(%eax)
  10374f:	19 c0                	sbb    %eax,%eax
  103751:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  103754:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  103758:	0f 95 c0             	setne  %al
  10375b:	0f b6 c0             	movzbl %al,%eax
  10375e:	85 c0                	test   %eax,%eax
  103760:	74 0b                	je     10376d <default_check+0x3c3>
  103762:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103765:	8b 40 08             	mov    0x8(%eax),%eax
  103768:	83 f8 01             	cmp    $0x1,%eax
  10376b:	74 24                	je     103791 <default_check+0x3e7>
  10376d:	c7 44 24 0c 5c 69 10 	movl   $0x10695c,0xc(%esp)
  103774:	00 
  103775:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  10377c:	00 
  10377d:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  103784:	00 
  103785:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  10378c:	e8 1a d5 ff ff       	call   100cab <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103791:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103794:	83 c0 04             	add    $0x4,%eax
  103797:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  10379e:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1037a1:	8b 45 90             	mov    -0x70(%ebp),%eax
  1037a4:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1037a7:	0f a3 10             	bt     %edx,(%eax)
  1037aa:	19 c0                	sbb    %eax,%eax
  1037ac:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  1037af:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1037b3:	0f 95 c0             	setne  %al
  1037b6:	0f b6 c0             	movzbl %al,%eax
  1037b9:	85 c0                	test   %eax,%eax
  1037bb:	74 0b                	je     1037c8 <default_check+0x41e>
  1037bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1037c0:	8b 40 08             	mov    0x8(%eax),%eax
  1037c3:	83 f8 03             	cmp    $0x3,%eax
  1037c6:	74 24                	je     1037ec <default_check+0x442>
  1037c8:	c7 44 24 0c 84 69 10 	movl   $0x106984,0xc(%esp)
  1037cf:	00 
  1037d0:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1037d7:	00 
  1037d8:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  1037df:	00 
  1037e0:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1037e7:	e8 bf d4 ff ff       	call   100cab <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  1037ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1037f3:	e8 20 05 00 00       	call   103d18 <alloc_pages>
  1037f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037fe:	83 e8 14             	sub    $0x14,%eax
  103801:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103804:	74 24                	je     10382a <default_check+0x480>
  103806:	c7 44 24 0c aa 69 10 	movl   $0x1069aa,0xc(%esp)
  10380d:	00 
  10380e:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103815:	00 
  103816:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  10381d:	00 
  10381e:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103825:	e8 81 d4 ff ff       	call   100cab <__panic>
    free_page(p0);
  10382a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103831:	00 
  103832:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103835:	89 04 24             	mov    %eax,(%esp)
  103838:	e8 13 05 00 00       	call   103d50 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  10383d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103844:	e8 cf 04 00 00       	call   103d18 <alloc_pages>
  103849:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10384c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10384f:	83 c0 14             	add    $0x14,%eax
  103852:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103855:	74 24                	je     10387b <default_check+0x4d1>
  103857:	c7 44 24 0c c8 69 10 	movl   $0x1069c8,0xc(%esp)
  10385e:	00 
  10385f:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103866:	00 
  103867:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  10386e:	00 
  10386f:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103876:	e8 30 d4 ff ff       	call   100cab <__panic>

    free_pages(p0, 2);
  10387b:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103882:	00 
  103883:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103886:	89 04 24             	mov    %eax,(%esp)
  103889:	e8 c2 04 00 00       	call   103d50 <free_pages>
    free_page(p2);
  10388e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103895:	00 
  103896:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103899:	89 04 24             	mov    %eax,(%esp)
  10389c:	e8 af 04 00 00       	call   103d50 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  1038a1:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1038a8:	e8 6b 04 00 00       	call   103d18 <alloc_pages>
  1038ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1038b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1038b4:	75 24                	jne    1038da <default_check+0x530>
  1038b6:	c7 44 24 0c e8 69 10 	movl   $0x1069e8,0xc(%esp)
  1038bd:	00 
  1038be:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1038c5:	00 
  1038c6:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  1038cd:	00 
  1038ce:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1038d5:	e8 d1 d3 ff ff       	call   100cab <__panic>
    assert(alloc_page() == NULL);
  1038da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1038e1:	e8 32 04 00 00       	call   103d18 <alloc_pages>
  1038e6:	85 c0                	test   %eax,%eax
  1038e8:	74 24                	je     10390e <default_check+0x564>
  1038ea:	c7 44 24 0c 46 68 10 	movl   $0x106846,0xc(%esp)
  1038f1:	00 
  1038f2:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1038f9:	00 
  1038fa:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  103901:	00 
  103902:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103909:	e8 9d d3 ff ff       	call   100cab <__panic>

    assert(nr_free == 0);
  10390e:	a1 58 89 11 00       	mov    0x118958,%eax
  103913:	85 c0                	test   %eax,%eax
  103915:	74 24                	je     10393b <default_check+0x591>
  103917:	c7 44 24 0c 99 68 10 	movl   $0x106899,0xc(%esp)
  10391e:	00 
  10391f:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  103926:	00 
  103927:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  10392e:	00 
  10392f:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  103936:	e8 70 d3 ff ff       	call   100cab <__panic>
    nr_free = nr_free_store;
  10393b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10393e:	a3 58 89 11 00       	mov    %eax,0x118958

    free_list = free_list_store;
  103943:	8b 45 80             	mov    -0x80(%ebp),%eax
  103946:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103949:	a3 50 89 11 00       	mov    %eax,0x118950
  10394e:	89 15 54 89 11 00    	mov    %edx,0x118954
    free_pages(p0, 5);
  103954:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  10395b:	00 
  10395c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10395f:	89 04 24             	mov    %eax,(%esp)
  103962:	e8 e9 03 00 00       	call   103d50 <free_pages>

    le = &free_list;
  103967:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10396e:	eb 1d                	jmp    10398d <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103970:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103973:	83 e8 0c             	sub    $0xc,%eax
  103976:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103979:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10397d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103980:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103983:	8b 40 08             	mov    0x8(%eax),%eax
  103986:	29 c2                	sub    %eax,%edx
  103988:	89 d0                	mov    %edx,%eax
  10398a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10398d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103990:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103993:	8b 45 88             	mov    -0x78(%ebp),%eax
  103996:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103999:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10399c:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  1039a3:	75 cb                	jne    103970 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  1039a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1039a9:	74 24                	je     1039cf <default_check+0x625>
  1039ab:	c7 44 24 0c 06 6a 10 	movl   $0x106a06,0xc(%esp)
  1039b2:	00 
  1039b3:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1039ba:	00 
  1039bb:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
  1039c2:	00 
  1039c3:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1039ca:	e8 dc d2 ff ff       	call   100cab <__panic>
    assert(total == 0);
  1039cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1039d3:	74 24                	je     1039f9 <default_check+0x64f>
  1039d5:	c7 44 24 0c 11 6a 10 	movl   $0x106a11,0xc(%esp)
  1039dc:	00 
  1039dd:	c7 44 24 08 d6 66 10 	movl   $0x1066d6,0x8(%esp)
  1039e4:	00 
  1039e5:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  1039ec:	00 
  1039ed:	c7 04 24 eb 66 10 00 	movl   $0x1066eb,(%esp)
  1039f4:	e8 b2 d2 ff ff       	call   100cab <__panic>
}
  1039f9:	81 c4 94 00 00 00    	add    $0x94,%esp
  1039ff:	5b                   	pop    %ebx
  103a00:	5d                   	pop    %ebp
  103a01:	c3                   	ret    

00103a02 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103a02:	55                   	push   %ebp
  103a03:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103a05:	8b 55 08             	mov    0x8(%ebp),%edx
  103a08:	a1 64 89 11 00       	mov    0x118964,%eax
  103a0d:	29 c2                	sub    %eax,%edx
  103a0f:	89 d0                	mov    %edx,%eax
  103a11:	c1 f8 02             	sar    $0x2,%eax
  103a14:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103a1a:	5d                   	pop    %ebp
  103a1b:	c3                   	ret    

00103a1c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103a1c:	55                   	push   %ebp
  103a1d:	89 e5                	mov    %esp,%ebp
  103a1f:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103a22:	8b 45 08             	mov    0x8(%ebp),%eax
  103a25:	89 04 24             	mov    %eax,(%esp)
  103a28:	e8 d5 ff ff ff       	call   103a02 <page2ppn>
  103a2d:	c1 e0 0c             	shl    $0xc,%eax
}
  103a30:	c9                   	leave  
  103a31:	c3                   	ret    

00103a32 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103a32:	55                   	push   %ebp
  103a33:	89 e5                	mov    %esp,%ebp
  103a35:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103a38:	8b 45 08             	mov    0x8(%ebp),%eax
  103a3b:	c1 e8 0c             	shr    $0xc,%eax
  103a3e:	89 c2                	mov    %eax,%edx
  103a40:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103a45:	39 c2                	cmp    %eax,%edx
  103a47:	72 1c                	jb     103a65 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103a49:	c7 44 24 08 4c 6a 10 	movl   $0x106a4c,0x8(%esp)
  103a50:	00 
  103a51:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103a58:	00 
  103a59:	c7 04 24 6b 6a 10 00 	movl   $0x106a6b,(%esp)
  103a60:	e8 46 d2 ff ff       	call   100cab <__panic>
    }
    return &pages[PPN(pa)];
  103a65:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  103a6e:	c1 e8 0c             	shr    $0xc,%eax
  103a71:	89 c2                	mov    %eax,%edx
  103a73:	89 d0                	mov    %edx,%eax
  103a75:	c1 e0 02             	shl    $0x2,%eax
  103a78:	01 d0                	add    %edx,%eax
  103a7a:	c1 e0 02             	shl    $0x2,%eax
  103a7d:	01 c8                	add    %ecx,%eax
}
  103a7f:	c9                   	leave  
  103a80:	c3                   	ret    

00103a81 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103a81:	55                   	push   %ebp
  103a82:	89 e5                	mov    %esp,%ebp
  103a84:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103a87:	8b 45 08             	mov    0x8(%ebp),%eax
  103a8a:	89 04 24             	mov    %eax,(%esp)
  103a8d:	e8 8a ff ff ff       	call   103a1c <page2pa>
  103a92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a98:	c1 e8 0c             	shr    $0xc,%eax
  103a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a9e:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103aa3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103aa6:	72 23                	jb     103acb <page2kva+0x4a>
  103aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103aab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103aaf:	c7 44 24 08 7c 6a 10 	movl   $0x106a7c,0x8(%esp)
  103ab6:	00 
  103ab7:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103abe:	00 
  103abf:	c7 04 24 6b 6a 10 00 	movl   $0x106a6b,(%esp)
  103ac6:	e8 e0 d1 ff ff       	call   100cab <__panic>
  103acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ace:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103ad3:	c9                   	leave  
  103ad4:	c3                   	ret    

00103ad5 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103ad5:	55                   	push   %ebp
  103ad6:	89 e5                	mov    %esp,%ebp
  103ad8:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103adb:	8b 45 08             	mov    0x8(%ebp),%eax
  103ade:	83 e0 01             	and    $0x1,%eax
  103ae1:	85 c0                	test   %eax,%eax
  103ae3:	75 1c                	jne    103b01 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103ae5:	c7 44 24 08 a0 6a 10 	movl   $0x106aa0,0x8(%esp)
  103aec:	00 
  103aed:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103af4:	00 
  103af5:	c7 04 24 6b 6a 10 00 	movl   $0x106a6b,(%esp)
  103afc:	e8 aa d1 ff ff       	call   100cab <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103b01:	8b 45 08             	mov    0x8(%ebp),%eax
  103b04:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103b09:	89 04 24             	mov    %eax,(%esp)
  103b0c:	e8 21 ff ff ff       	call   103a32 <pa2page>
}
  103b11:	c9                   	leave  
  103b12:	c3                   	ret    

00103b13 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103b13:	55                   	push   %ebp
  103b14:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103b16:	8b 45 08             	mov    0x8(%ebp),%eax
  103b19:	8b 00                	mov    (%eax),%eax
}
  103b1b:	5d                   	pop    %ebp
  103b1c:	c3                   	ret    

00103b1d <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103b1d:	55                   	push   %ebp
  103b1e:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103b20:	8b 45 08             	mov    0x8(%ebp),%eax
  103b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  103b26:	89 10                	mov    %edx,(%eax)
}
  103b28:	5d                   	pop    %ebp
  103b29:	c3                   	ret    

00103b2a <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103b2a:	55                   	push   %ebp
  103b2b:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  103b30:	8b 00                	mov    (%eax),%eax
  103b32:	8d 50 01             	lea    0x1(%eax),%edx
  103b35:	8b 45 08             	mov    0x8(%ebp),%eax
  103b38:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103b3a:	8b 45 08             	mov    0x8(%ebp),%eax
  103b3d:	8b 00                	mov    (%eax),%eax
}
  103b3f:	5d                   	pop    %ebp
  103b40:	c3                   	ret    

00103b41 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103b41:	55                   	push   %ebp
  103b42:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103b44:	8b 45 08             	mov    0x8(%ebp),%eax
  103b47:	8b 00                	mov    (%eax),%eax
  103b49:	8d 50 ff             	lea    -0x1(%eax),%edx
  103b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  103b4f:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103b51:	8b 45 08             	mov    0x8(%ebp),%eax
  103b54:	8b 00                	mov    (%eax),%eax
}
  103b56:	5d                   	pop    %ebp
  103b57:	c3                   	ret    

00103b58 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103b58:	55                   	push   %ebp
  103b59:	89 e5                	mov    %esp,%ebp
  103b5b:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103b5e:	9c                   	pushf  
  103b5f:	58                   	pop    %eax
  103b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103b66:	25 00 02 00 00       	and    $0x200,%eax
  103b6b:	85 c0                	test   %eax,%eax
  103b6d:	74 0c                	je     103b7b <__intr_save+0x23>
        intr_disable();
  103b6f:	e8 1a db ff ff       	call   10168e <intr_disable>
        return 1;
  103b74:	b8 01 00 00 00       	mov    $0x1,%eax
  103b79:	eb 05                	jmp    103b80 <__intr_save+0x28>
    }
    return 0;
  103b7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103b80:	c9                   	leave  
  103b81:	c3                   	ret    

00103b82 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103b82:	55                   	push   %ebp
  103b83:	89 e5                	mov    %esp,%ebp
  103b85:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103b88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103b8c:	74 05                	je     103b93 <__intr_restore+0x11>
        intr_enable();
  103b8e:	e8 f5 da ff ff       	call   101688 <intr_enable>
    }
}
  103b93:	c9                   	leave  
  103b94:	c3                   	ret    

00103b95 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103b95:	55                   	push   %ebp
  103b96:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103b98:	8b 45 08             	mov    0x8(%ebp),%eax
  103b9b:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103b9e:	b8 23 00 00 00       	mov    $0x23,%eax
  103ba3:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103ba5:	b8 23 00 00 00       	mov    $0x23,%eax
  103baa:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103bac:	b8 10 00 00 00       	mov    $0x10,%eax
  103bb1:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103bb3:	b8 10 00 00 00       	mov    $0x10,%eax
  103bb8:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103bba:	b8 10 00 00 00       	mov    $0x10,%eax
  103bbf:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103bc1:	ea c8 3b 10 00 08 00 	ljmp   $0x8,$0x103bc8
}
  103bc8:	5d                   	pop    %ebp
  103bc9:	c3                   	ret    

00103bca <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103bca:	55                   	push   %ebp
  103bcb:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  103bd0:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103bd5:	5d                   	pop    %ebp
  103bd6:	c3                   	ret    

00103bd7 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103bd7:	55                   	push   %ebp
  103bd8:	89 e5                	mov    %esp,%ebp
  103bda:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103bdd:	b8 00 70 11 00       	mov    $0x117000,%eax
  103be2:	89 04 24             	mov    %eax,(%esp)
  103be5:	e8 e0 ff ff ff       	call   103bca <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103bea:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103bf1:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103bf3:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103bfa:	68 00 
  103bfc:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103c01:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103c07:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103c0c:	c1 e8 10             	shr    $0x10,%eax
  103c0f:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103c14:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c1b:	83 e0 f0             	and    $0xfffffff0,%eax
  103c1e:	83 c8 09             	or     $0x9,%eax
  103c21:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c26:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c2d:	83 e0 ef             	and    $0xffffffef,%eax
  103c30:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c35:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c3c:	83 e0 9f             	and    $0xffffff9f,%eax
  103c3f:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c44:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103c4b:	83 c8 80             	or     $0xffffff80,%eax
  103c4e:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103c53:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c5a:	83 e0 f0             	and    $0xfffffff0,%eax
  103c5d:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c62:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c69:	83 e0 ef             	and    $0xffffffef,%eax
  103c6c:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c71:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c78:	83 e0 df             	and    $0xffffffdf,%eax
  103c7b:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c80:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c87:	83 c8 40             	or     $0x40,%eax
  103c8a:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c8f:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c96:	83 e0 7f             	and    $0x7f,%eax
  103c99:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c9e:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103ca3:	c1 e8 18             	shr    $0x18,%eax
  103ca6:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103cab:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103cb2:	e8 de fe ff ff       	call   103b95 <lgdt>
  103cb7:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103cbd:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103cc1:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103cc4:	c9                   	leave  
  103cc5:	c3                   	ret    

00103cc6 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103cc6:	55                   	push   %ebp
  103cc7:	89 e5                	mov    %esp,%ebp
  103cc9:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103ccc:	c7 05 5c 89 11 00 30 	movl   $0x106a30,0x11895c
  103cd3:	6a 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103cd6:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103cdb:	8b 00                	mov    (%eax),%eax
  103cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  103ce1:	c7 04 24 cc 6a 10 00 	movl   $0x106acc,(%esp)
  103ce8:	e8 4f c6 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103ced:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103cf2:	8b 40 04             	mov    0x4(%eax),%eax
  103cf5:	ff d0                	call   *%eax
}
  103cf7:	c9                   	leave  
  103cf8:	c3                   	ret    

00103cf9 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103cf9:	55                   	push   %ebp
  103cfa:	89 e5                	mov    %esp,%ebp
  103cfc:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103cff:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d04:	8b 40 08             	mov    0x8(%eax),%eax
  103d07:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d0a:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d0e:	8b 55 08             	mov    0x8(%ebp),%edx
  103d11:	89 14 24             	mov    %edx,(%esp)
  103d14:	ff d0                	call   *%eax
}
  103d16:	c9                   	leave  
  103d17:	c3                   	ret    

00103d18 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103d18:	55                   	push   %ebp
  103d19:	89 e5                	mov    %esp,%ebp
  103d1b:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103d1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103d25:	e8 2e fe ff ff       	call   103b58 <__intr_save>
  103d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103d2d:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d32:	8b 40 0c             	mov    0xc(%eax),%eax
  103d35:	8b 55 08             	mov    0x8(%ebp),%edx
  103d38:	89 14 24             	mov    %edx,(%esp)
  103d3b:	ff d0                	call   *%eax
  103d3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d43:	89 04 24             	mov    %eax,(%esp)
  103d46:	e8 37 fe ff ff       	call   103b82 <__intr_restore>
    return page;
  103d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103d4e:	c9                   	leave  
  103d4f:	c3                   	ret    

00103d50 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103d50:	55                   	push   %ebp
  103d51:	89 e5                	mov    %esp,%ebp
  103d53:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103d56:	e8 fd fd ff ff       	call   103b58 <__intr_save>
  103d5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103d5e:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d63:	8b 40 10             	mov    0x10(%eax),%eax
  103d66:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d69:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d6d:	8b 55 08             	mov    0x8(%ebp),%edx
  103d70:	89 14 24             	mov    %edx,(%esp)
  103d73:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d78:	89 04 24             	mov    %eax,(%esp)
  103d7b:	e8 02 fe ff ff       	call   103b82 <__intr_restore>
}
  103d80:	c9                   	leave  
  103d81:	c3                   	ret    

00103d82 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103d82:	55                   	push   %ebp
  103d83:	89 e5                	mov    %esp,%ebp
  103d85:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103d88:	e8 cb fd ff ff       	call   103b58 <__intr_save>
  103d8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103d90:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d95:	8b 40 14             	mov    0x14(%eax),%eax
  103d98:	ff d0                	call   *%eax
  103d9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103da0:	89 04 24             	mov    %eax,(%esp)
  103da3:	e8 da fd ff ff       	call   103b82 <__intr_restore>
    return ret;
  103da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103dab:	c9                   	leave  
  103dac:	c3                   	ret    

00103dad <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103dad:	55                   	push   %ebp
  103dae:	89 e5                	mov    %esp,%ebp
  103db0:	57                   	push   %edi
  103db1:	56                   	push   %esi
  103db2:	53                   	push   %ebx
  103db3:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103db9:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103dc0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103dc7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103dce:	c7 04 24 e3 6a 10 00 	movl   $0x106ae3,(%esp)
  103dd5:	e8 62 c5 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103dda:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103de1:	e9 15 01 00 00       	jmp    103efb <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103de6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103de9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103dec:	89 d0                	mov    %edx,%eax
  103dee:	c1 e0 02             	shl    $0x2,%eax
  103df1:	01 d0                	add    %edx,%eax
  103df3:	c1 e0 02             	shl    $0x2,%eax
  103df6:	01 c8                	add    %ecx,%eax
  103df8:	8b 50 08             	mov    0x8(%eax),%edx
  103dfb:	8b 40 04             	mov    0x4(%eax),%eax
  103dfe:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103e01:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103e04:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e07:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e0a:	89 d0                	mov    %edx,%eax
  103e0c:	c1 e0 02             	shl    $0x2,%eax
  103e0f:	01 d0                	add    %edx,%eax
  103e11:	c1 e0 02             	shl    $0x2,%eax
  103e14:	01 c8                	add    %ecx,%eax
  103e16:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e19:	8b 58 10             	mov    0x10(%eax),%ebx
  103e1c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e1f:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e22:	01 c8                	add    %ecx,%eax
  103e24:	11 da                	adc    %ebx,%edx
  103e26:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103e29:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103e2c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e2f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e32:	89 d0                	mov    %edx,%eax
  103e34:	c1 e0 02             	shl    $0x2,%eax
  103e37:	01 d0                	add    %edx,%eax
  103e39:	c1 e0 02             	shl    $0x2,%eax
  103e3c:	01 c8                	add    %ecx,%eax
  103e3e:	83 c0 14             	add    $0x14,%eax
  103e41:	8b 00                	mov    (%eax),%eax
  103e43:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103e49:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103e4c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103e4f:	83 c0 ff             	add    $0xffffffff,%eax
  103e52:	83 d2 ff             	adc    $0xffffffff,%edx
  103e55:	89 c6                	mov    %eax,%esi
  103e57:	89 d7                	mov    %edx,%edi
  103e59:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e5f:	89 d0                	mov    %edx,%eax
  103e61:	c1 e0 02             	shl    $0x2,%eax
  103e64:	01 d0                	add    %edx,%eax
  103e66:	c1 e0 02             	shl    $0x2,%eax
  103e69:	01 c8                	add    %ecx,%eax
  103e6b:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e6e:	8b 58 10             	mov    0x10(%eax),%ebx
  103e71:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103e77:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103e7b:	89 74 24 14          	mov    %esi,0x14(%esp)
  103e7f:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103e83:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e86:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e89:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e8d:	89 54 24 10          	mov    %edx,0x10(%esp)
  103e91:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103e95:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103e99:	c7 04 24 f0 6a 10 00 	movl   $0x106af0,(%esp)
  103ea0:	e8 97 c4 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103ea5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103ea8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103eab:	89 d0                	mov    %edx,%eax
  103ead:	c1 e0 02             	shl    $0x2,%eax
  103eb0:	01 d0                	add    %edx,%eax
  103eb2:	c1 e0 02             	shl    $0x2,%eax
  103eb5:	01 c8                	add    %ecx,%eax
  103eb7:	83 c0 14             	add    $0x14,%eax
  103eba:	8b 00                	mov    (%eax),%eax
  103ebc:	83 f8 01             	cmp    $0x1,%eax
  103ebf:	75 36                	jne    103ef7 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103ec1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103ec4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103ec7:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103eca:	77 2b                	ja     103ef7 <page_init+0x14a>
  103ecc:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103ecf:	72 05                	jb     103ed6 <page_init+0x129>
  103ed1:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103ed4:	73 21                	jae    103ef7 <page_init+0x14a>
  103ed6:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103eda:	77 1b                	ja     103ef7 <page_init+0x14a>
  103edc:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103ee0:	72 09                	jb     103eeb <page_init+0x13e>
  103ee2:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103ee9:	77 0c                	ja     103ef7 <page_init+0x14a>
                maxpa = end;
  103eeb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103eee:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103ef1:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103ef4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103ef7:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103efb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103efe:	8b 00                	mov    (%eax),%eax
  103f00:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103f03:	0f 8f dd fe ff ff    	jg     103de6 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103f09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f0d:	72 1d                	jb     103f2c <page_init+0x17f>
  103f0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103f13:	77 09                	ja     103f1e <page_init+0x171>
  103f15:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103f1c:	76 0e                	jbe    103f2c <page_init+0x17f>
        maxpa = KMEMSIZE;
  103f1e:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103f25:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103f2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103f2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103f32:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103f36:	c1 ea 0c             	shr    $0xc,%edx
  103f39:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103f3e:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103f45:	b8 68 89 11 00       	mov    $0x118968,%eax
  103f4a:	8d 50 ff             	lea    -0x1(%eax),%edx
  103f4d:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103f50:	01 d0                	add    %edx,%eax
  103f52:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103f55:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103f58:	ba 00 00 00 00       	mov    $0x0,%edx
  103f5d:	f7 75 ac             	divl   -0x54(%ebp)
  103f60:	89 d0                	mov    %edx,%eax
  103f62:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103f65:	29 c2                	sub    %eax,%edx
  103f67:	89 d0                	mov    %edx,%eax
  103f69:	a3 64 89 11 00       	mov    %eax,0x118964

    for (i = 0; i < npage; i ++) {
  103f6e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f75:	eb 2f                	jmp    103fa6 <page_init+0x1f9>
        SetPageReserved(pages + i);
  103f77:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103f7d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f80:	89 d0                	mov    %edx,%eax
  103f82:	c1 e0 02             	shl    $0x2,%eax
  103f85:	01 d0                	add    %edx,%eax
  103f87:	c1 e0 02             	shl    $0x2,%eax
  103f8a:	01 c8                	add    %ecx,%eax
  103f8c:	83 c0 04             	add    $0x4,%eax
  103f8f:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103f96:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103f99:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103f9c:	8b 55 90             	mov    -0x70(%ebp),%edx
  103f9f:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103fa2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103fa6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fa9:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103fae:	39 c2                	cmp    %eax,%edx
  103fb0:	72 c5                	jb     103f77 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103fb2:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103fb8:	89 d0                	mov    %edx,%eax
  103fba:	c1 e0 02             	shl    $0x2,%eax
  103fbd:	01 d0                	add    %edx,%eax
  103fbf:	c1 e0 02             	shl    $0x2,%eax
  103fc2:	89 c2                	mov    %eax,%edx
  103fc4:	a1 64 89 11 00       	mov    0x118964,%eax
  103fc9:	01 d0                	add    %edx,%eax
  103fcb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103fce:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103fd5:	77 23                	ja     103ffa <page_init+0x24d>
  103fd7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103fda:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103fde:	c7 44 24 08 20 6b 10 	movl   $0x106b20,0x8(%esp)
  103fe5:	00 
  103fe6:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103fed:	00 
  103fee:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  103ff5:	e8 b1 cc ff ff       	call   100cab <__panic>
  103ffa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103ffd:	05 00 00 00 40       	add    $0x40000000,%eax
  104002:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  104005:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10400c:	e9 74 01 00 00       	jmp    104185 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  104011:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104014:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104017:	89 d0                	mov    %edx,%eax
  104019:	c1 e0 02             	shl    $0x2,%eax
  10401c:	01 d0                	add    %edx,%eax
  10401e:	c1 e0 02             	shl    $0x2,%eax
  104021:	01 c8                	add    %ecx,%eax
  104023:	8b 50 08             	mov    0x8(%eax),%edx
  104026:	8b 40 04             	mov    0x4(%eax),%eax
  104029:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10402c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10402f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104032:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104035:	89 d0                	mov    %edx,%eax
  104037:	c1 e0 02             	shl    $0x2,%eax
  10403a:	01 d0                	add    %edx,%eax
  10403c:	c1 e0 02             	shl    $0x2,%eax
  10403f:	01 c8                	add    %ecx,%eax
  104041:	8b 48 0c             	mov    0xc(%eax),%ecx
  104044:	8b 58 10             	mov    0x10(%eax),%ebx
  104047:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10404a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10404d:	01 c8                	add    %ecx,%eax
  10404f:	11 da                	adc    %ebx,%edx
  104051:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104054:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  104057:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10405a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10405d:	89 d0                	mov    %edx,%eax
  10405f:	c1 e0 02             	shl    $0x2,%eax
  104062:	01 d0                	add    %edx,%eax
  104064:	c1 e0 02             	shl    $0x2,%eax
  104067:	01 c8                	add    %ecx,%eax
  104069:	83 c0 14             	add    $0x14,%eax
  10406c:	8b 00                	mov    (%eax),%eax
  10406e:	83 f8 01             	cmp    $0x1,%eax
  104071:	0f 85 0a 01 00 00    	jne    104181 <page_init+0x3d4>
            if (begin < freemem) {
  104077:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10407a:	ba 00 00 00 00       	mov    $0x0,%edx
  10407f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104082:	72 17                	jb     10409b <page_init+0x2ee>
  104084:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104087:	77 05                	ja     10408e <page_init+0x2e1>
  104089:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  10408c:	76 0d                	jbe    10409b <page_init+0x2ee>
                begin = freemem;
  10408e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104091:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104094:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  10409b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10409f:	72 1d                	jb     1040be <page_init+0x311>
  1040a1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1040a5:	77 09                	ja     1040b0 <page_init+0x303>
  1040a7:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  1040ae:	76 0e                	jbe    1040be <page_init+0x311>
                end = KMEMSIZE;
  1040b0:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1040b7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  1040be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1040c4:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040c7:	0f 87 b4 00 00 00    	ja     104181 <page_init+0x3d4>
  1040cd:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040d0:	72 09                	jb     1040db <page_init+0x32e>
  1040d2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1040d5:	0f 83 a6 00 00 00    	jae    104181 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  1040db:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  1040e2:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1040e5:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1040e8:	01 d0                	add    %edx,%eax
  1040ea:	83 e8 01             	sub    $0x1,%eax
  1040ed:	89 45 98             	mov    %eax,-0x68(%ebp)
  1040f0:	8b 45 98             	mov    -0x68(%ebp),%eax
  1040f3:	ba 00 00 00 00       	mov    $0x0,%edx
  1040f8:	f7 75 9c             	divl   -0x64(%ebp)
  1040fb:	89 d0                	mov    %edx,%eax
  1040fd:	8b 55 98             	mov    -0x68(%ebp),%edx
  104100:	29 c2                	sub    %eax,%edx
  104102:	89 d0                	mov    %edx,%eax
  104104:	ba 00 00 00 00       	mov    $0x0,%edx
  104109:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10410c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  10410f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104112:	89 45 94             	mov    %eax,-0x6c(%ebp)
  104115:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104118:	ba 00 00 00 00       	mov    $0x0,%edx
  10411d:	89 c7                	mov    %eax,%edi
  10411f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  104125:	89 7d 80             	mov    %edi,-0x80(%ebp)
  104128:	89 d0                	mov    %edx,%eax
  10412a:	83 e0 00             	and    $0x0,%eax
  10412d:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104130:	8b 45 80             	mov    -0x80(%ebp),%eax
  104133:	8b 55 84             	mov    -0x7c(%ebp),%edx
  104136:	89 45 c8             	mov    %eax,-0x38(%ebp)
  104139:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  10413c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10413f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104142:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104145:	77 3a                	ja     104181 <page_init+0x3d4>
  104147:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10414a:	72 05                	jb     104151 <page_init+0x3a4>
  10414c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10414f:	73 30                	jae    104181 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  104151:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  104154:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  104157:	8b 45 c8             	mov    -0x38(%ebp),%eax
  10415a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  10415d:	29 c8                	sub    %ecx,%eax
  10415f:	19 da                	sbb    %ebx,%edx
  104161:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104165:	c1 ea 0c             	shr    $0xc,%edx
  104168:	89 c3                	mov    %eax,%ebx
  10416a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10416d:	89 04 24             	mov    %eax,(%esp)
  104170:	e8 bd f8 ff ff       	call   103a32 <pa2page>
  104175:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104179:	89 04 24             	mov    %eax,(%esp)
  10417c:	e8 78 fb ff ff       	call   103cf9 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  104181:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104185:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104188:	8b 00                	mov    (%eax),%eax
  10418a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10418d:	0f 8f 7e fe ff ff    	jg     104011 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  104193:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104199:	5b                   	pop    %ebx
  10419a:	5e                   	pop    %esi
  10419b:	5f                   	pop    %edi
  10419c:	5d                   	pop    %ebp
  10419d:	c3                   	ret    

0010419e <enable_paging>:

static void
enable_paging(void) {
  10419e:	55                   	push   %ebp
  10419f:	89 e5                	mov    %esp,%ebp
  1041a1:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  1041a4:	a1 60 89 11 00       	mov    0x118960,%eax
  1041a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  1041ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1041af:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  1041b2:	0f 20 c0             	mov    %cr0,%eax
  1041b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  1041b8:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  1041bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  1041be:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  1041c5:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  1041c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  1041cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041d2:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  1041d5:	c9                   	leave  
  1041d6:	c3                   	ret    

001041d7 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1041d7:	55                   	push   %ebp
  1041d8:	89 e5                	mov    %esp,%ebp
  1041da:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1041dd:	8b 45 14             	mov    0x14(%ebp),%eax
  1041e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  1041e3:	31 d0                	xor    %edx,%eax
  1041e5:	25 ff 0f 00 00       	and    $0xfff,%eax
  1041ea:	85 c0                	test   %eax,%eax
  1041ec:	74 24                	je     104212 <boot_map_segment+0x3b>
  1041ee:	c7 44 24 0c 52 6b 10 	movl   $0x106b52,0xc(%esp)
  1041f5:	00 
  1041f6:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  1041fd:	00 
  1041fe:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  104205:	00 
  104206:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  10420d:	e8 99 ca ff ff       	call   100cab <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  104212:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  104219:	8b 45 0c             	mov    0xc(%ebp),%eax
  10421c:	25 ff 0f 00 00       	and    $0xfff,%eax
  104221:	89 c2                	mov    %eax,%edx
  104223:	8b 45 10             	mov    0x10(%ebp),%eax
  104226:	01 c2                	add    %eax,%edx
  104228:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10422b:	01 d0                	add    %edx,%eax
  10422d:	83 e8 01             	sub    $0x1,%eax
  104230:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104233:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104236:	ba 00 00 00 00       	mov    $0x0,%edx
  10423b:	f7 75 f0             	divl   -0x10(%ebp)
  10423e:	89 d0                	mov    %edx,%eax
  104240:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104243:	29 c2                	sub    %eax,%edx
  104245:	89 d0                	mov    %edx,%eax
  104247:	c1 e8 0c             	shr    $0xc,%eax
  10424a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  10424d:	8b 45 0c             	mov    0xc(%ebp),%eax
  104250:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104256:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10425b:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  10425e:	8b 45 14             	mov    0x14(%ebp),%eax
  104261:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104264:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104267:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10426c:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10426f:	eb 6b                	jmp    1042dc <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  104271:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104278:	00 
  104279:	8b 45 0c             	mov    0xc(%ebp),%eax
  10427c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104280:	8b 45 08             	mov    0x8(%ebp),%eax
  104283:	89 04 24             	mov    %eax,(%esp)
  104286:	e8 cc 01 00 00       	call   104457 <get_pte>
  10428b:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  10428e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104292:	75 24                	jne    1042b8 <boot_map_segment+0xe1>
  104294:	c7 44 24 0c 7e 6b 10 	movl   $0x106b7e,0xc(%esp)
  10429b:	00 
  10429c:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  1042a3:	00 
  1042a4:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  1042ab:	00 
  1042ac:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  1042b3:	e8 f3 c9 ff ff       	call   100cab <__panic>
        *ptep = pa | PTE_P | perm;
  1042b8:	8b 45 18             	mov    0x18(%ebp),%eax
  1042bb:	8b 55 14             	mov    0x14(%ebp),%edx
  1042be:	09 d0                	or     %edx,%eax
  1042c0:	83 c8 01             	or     $0x1,%eax
  1042c3:	89 c2                	mov    %eax,%edx
  1042c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1042c8:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1042ca:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1042ce:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1042d5:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1042dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1042e0:	75 8f                	jne    104271 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  1042e2:	c9                   	leave  
  1042e3:	c3                   	ret    

001042e4 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1042e4:	55                   	push   %ebp
  1042e5:	89 e5                	mov    %esp,%ebp
  1042e7:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1042ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1042f1:	e8 22 fa ff ff       	call   103d18 <alloc_pages>
  1042f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1042f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1042fd:	75 1c                	jne    10431b <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1042ff:	c7 44 24 08 8b 6b 10 	movl   $0x106b8b,0x8(%esp)
  104306:	00 
  104307:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  10430e:	00 
  10430f:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104316:	e8 90 c9 ff ff       	call   100cab <__panic>
    }
    return page2kva(p);
  10431b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10431e:	89 04 24             	mov    %eax,(%esp)
  104321:	e8 5b f7 ff ff       	call   103a81 <page2kva>
}
  104326:	c9                   	leave  
  104327:	c3                   	ret    

00104328 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  104328:	55                   	push   %ebp
  104329:	89 e5                	mov    %esp,%ebp
  10432b:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  10432e:	e8 93 f9 ff ff       	call   103cc6 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  104333:	e8 75 fa ff ff       	call   103dad <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  104338:	e8 66 04 00 00       	call   1047a3 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  10433d:	e8 a2 ff ff ff       	call   1042e4 <boot_alloc_page>
  104342:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  104347:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10434c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104353:	00 
  104354:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10435b:	00 
  10435c:	89 04 24             	mov    %eax,(%esp)
  10435f:	e8 a8 1a 00 00       	call   105e0c <memset>
    boot_cr3 = PADDR(boot_pgdir);
  104364:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104369:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10436c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104373:	77 23                	ja     104398 <pmm_init+0x70>
  104375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104378:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10437c:	c7 44 24 08 20 6b 10 	movl   $0x106b20,0x8(%esp)
  104383:	00 
  104384:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  10438b:	00 
  10438c:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104393:	e8 13 c9 ff ff       	call   100cab <__panic>
  104398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10439b:	05 00 00 00 40       	add    $0x40000000,%eax
  1043a0:	a3 60 89 11 00       	mov    %eax,0x118960

    check_pgdir();
  1043a5:	e8 17 04 00 00       	call   1047c1 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1043aa:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043af:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  1043b5:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1043bd:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1043c4:	77 23                	ja     1043e9 <pmm_init+0xc1>
  1043c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1043cd:	c7 44 24 08 20 6b 10 	movl   $0x106b20,0x8(%esp)
  1043d4:	00 
  1043d5:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  1043dc:	00 
  1043dd:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  1043e4:	e8 c2 c8 ff ff       	call   100cab <__panic>
  1043e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1043ec:	05 00 00 00 40       	add    $0x40000000,%eax
  1043f1:	83 c8 03             	or     $0x3,%eax
  1043f4:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1043f6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043fb:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  104402:	00 
  104403:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10440a:	00 
  10440b:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  104412:	38 
  104413:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  10441a:	c0 
  10441b:	89 04 24             	mov    %eax,(%esp)
  10441e:	e8 b4 fd ff ff       	call   1041d7 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  104423:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104428:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  10442e:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  104434:	89 10                	mov    %edx,(%eax)

    enable_paging();
  104436:	e8 63 fd ff ff       	call   10419e <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10443b:	e8 97 f7 ff ff       	call   103bd7 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  104440:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104445:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  10444b:	e8 0c 0a 00 00       	call   104e5c <check_boot_pgdir>

    print_pgdir();
  104450:	e8 99 0e 00 00       	call   1052ee <print_pgdir>

}
  104455:	c9                   	leave  
  104456:	c3                   	ret    

00104457 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  104457:	55                   	push   %ebp
  104458:	89 e5                	mov    %esp,%ebp
  10445a:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    //首先从la中取出页目录项编号，再在页目录中取出相应的页目录项
    pde_t *pdep = &pgdir[PDX(la)];
  10445d:	8b 45 0c             	mov    0xc(%ebp),%eax
  104460:	c1 e8 16             	shr    $0x16,%eax
  104463:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10446a:	8b 45 08             	mov    0x8(%ebp),%eax
  10446d:	01 d0                	add    %edx,%eax
  10446f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
  104472:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104475:	8b 00                	mov    (%eax),%eax
  104477:	83 e0 01             	and    $0x1,%eax
  10447a:	85 c0                	test   %eax,%eax
  10447c:	0f 85 af 00 00 00    	jne    104531 <get_pte+0xda>
        //若该pde中的标记位显示对应的pt不存在，则为此pde分配一个页，对此页引用+1,然后初始化pt,修改pde中的标记
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
  104482:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104486:	74 15                	je     10449d <get_pte+0x46>
  104488:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10448f:	e8 84 f8 ff ff       	call   103d18 <alloc_pages>
  104494:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104497:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10449b:	75 0a                	jne    1044a7 <get_pte+0x50>
            return NULL;
  10449d:	b8 00 00 00 00       	mov    $0x0,%eax
  1044a2:	e9 e6 00 00 00       	jmp    10458d <get_pte+0x136>
        }
        set_page_ref(page, 1);
  1044a7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1044ae:	00 
  1044af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044b2:	89 04 24             	mov    %eax,(%esp)
  1044b5:	e8 63 f6 ff ff       	call   103b1d <set_page_ref>
        uintptr_t pa = page2pa(page);
  1044ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1044bd:	89 04 24             	mov    %eax,(%esp)
  1044c0:	e8 57 f5 ff ff       	call   103a1c <page2pa>
  1044c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
  1044c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1044cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1044ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044d1:	c1 e8 0c             	shr    $0xc,%eax
  1044d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1044d7:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1044dc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1044df:	72 23                	jb     104504 <get_pte+0xad>
  1044e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1044e8:	c7 44 24 08 7c 6a 10 	movl   $0x106a7c,0x8(%esp)
  1044ef:	00 
  1044f0:	c7 44 24 04 89 01 00 	movl   $0x189,0x4(%esp)
  1044f7:	00 
  1044f8:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  1044ff:	e8 a7 c7 ff ff       	call   100cab <__panic>
  104504:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104507:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10450c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104513:	00 
  104514:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10451b:	00 
  10451c:	89 04 24             	mov    %eax,(%esp)
  10451f:	e8 e8 18 00 00       	call   105e0c <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
  104524:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104527:	83 c8 07             	or     $0x7,%eax
  10452a:	89 c2                	mov    %eax,%edx
  10452c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10452f:	89 10                	mov    %edx,(%eax)
    }
    //若该目录项显示对应的页表存在，则从此页表中利用la中的页表项号取出所需的页表项
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  104531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104534:	8b 00                	mov    (%eax),%eax
  104536:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10453b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10453e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104541:	c1 e8 0c             	shr    $0xc,%eax
  104544:	89 45 dc             	mov    %eax,-0x24(%ebp)
  104547:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  10454c:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10454f:	72 23                	jb     104574 <get_pte+0x11d>
  104551:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104554:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104558:	c7 44 24 08 7c 6a 10 	movl   $0x106a7c,0x8(%esp)
  10455f:	00 
  104560:	c7 44 24 04 8d 01 00 	movl   $0x18d,0x4(%esp)
  104567:	00 
  104568:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  10456f:	e8 37 c7 ff ff       	call   100cab <__panic>
  104574:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104577:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10457c:	8b 55 0c             	mov    0xc(%ebp),%edx
  10457f:	c1 ea 0c             	shr    $0xc,%edx
  104582:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  104588:	c1 e2 02             	shl    $0x2,%edx
  10458b:	01 d0                	add    %edx,%eax
}
  10458d:	c9                   	leave  
  10458e:	c3                   	ret    

0010458f <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10458f:	55                   	push   %ebp
  104590:	89 e5                	mov    %esp,%ebp
  104592:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104595:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10459c:	00 
  10459d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1045a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1045a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1045a7:	89 04 24             	mov    %eax,(%esp)
  1045aa:	e8 a8 fe ff ff       	call   104457 <get_pte>
  1045af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  1045b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1045b6:	74 08                	je     1045c0 <get_page+0x31>
        *ptep_store = ptep;
  1045b8:	8b 45 10             	mov    0x10(%ebp),%eax
  1045bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1045be:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1045c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1045c4:	74 1b                	je     1045e1 <get_page+0x52>
  1045c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045c9:	8b 00                	mov    (%eax),%eax
  1045cb:	83 e0 01             	and    $0x1,%eax
  1045ce:	85 c0                	test   %eax,%eax
  1045d0:	74 0f                	je     1045e1 <get_page+0x52>
        return pa2page(*ptep);
  1045d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045d5:	8b 00                	mov    (%eax),%eax
  1045d7:	89 04 24             	mov    %eax,(%esp)
  1045da:	e8 53 f4 ff ff       	call   103a32 <pa2page>
  1045df:	eb 05                	jmp    1045e6 <get_page+0x57>
    }
    return NULL;
  1045e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1045e6:	c9                   	leave  
  1045e7:	c3                   	ret    

001045e8 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1045e8:	55                   	push   %ebp
  1045e9:	89 e5                	mov    %esp,%ebp
  1045eb:	83 ec 28             	sub    $0x28,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    //首先检查此pte对应的页是否存在，若不存在则什么也不干
    if (*ptep & PTE_P) {
  1045ee:	8b 45 10             	mov    0x10(%ebp),%eax
  1045f1:	8b 00                	mov    (%eax),%eax
  1045f3:	83 e0 01             	and    $0x1,%eax
  1045f6:	85 c0                	test   %eax,%eax
  1045f8:	74 4d                	je     104647 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
  1045fa:	8b 45 10             	mov    0x10(%ebp),%eax
  1045fd:	8b 00                	mov    (%eax),%eax
  1045ff:	89 04 24             	mov    %eax,(%esp)
  104602:	e8 ce f4 ff ff       	call   103ad5 <pte2page>
  104607:	89 45 f4             	mov    %eax,-0xc(%ebp)
        //则此页的引用减1,若此页的引用为0则回收此页
        if (page_ref_dec(page) == 0) {
  10460a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10460d:	89 04 24             	mov    %eax,(%esp)
  104610:	e8 2c f5 ff ff       	call   103b41 <page_ref_dec>
  104615:	85 c0                	test   %eax,%eax
  104617:	75 13                	jne    10462c <page_remove_pte+0x44>
            free_page(page);
  104619:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104620:	00 
  104621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104624:	89 04 24             	mov    %eax,(%esp)
  104627:	e8 24 f7 ff ff       	call   103d50 <free_pages>
        }
        //更新此pte，并刷新tlb
        *ptep = 0;
  10462c:	8b 45 10             	mov    0x10(%ebp),%eax
  10462f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
  104635:	8b 45 0c             	mov    0xc(%ebp),%eax
  104638:	89 44 24 04          	mov    %eax,0x4(%esp)
  10463c:	8b 45 08             	mov    0x8(%ebp),%eax
  10463f:	89 04 24             	mov    %eax,(%esp)
  104642:	e8 ff 00 00 00       	call   104746 <tlb_invalidate>
    }
}
  104647:	c9                   	leave  
  104648:	c3                   	ret    

00104649 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  104649:	55                   	push   %ebp
  10464a:	89 e5                	mov    %esp,%ebp
  10464c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10464f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104656:	00 
  104657:	8b 45 0c             	mov    0xc(%ebp),%eax
  10465a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10465e:	8b 45 08             	mov    0x8(%ebp),%eax
  104661:	89 04 24             	mov    %eax,(%esp)
  104664:	e8 ee fd ff ff       	call   104457 <get_pte>
  104669:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  10466c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104670:	74 19                	je     10468b <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  104672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104675:	89 44 24 08          	mov    %eax,0x8(%esp)
  104679:	8b 45 0c             	mov    0xc(%ebp),%eax
  10467c:	89 44 24 04          	mov    %eax,0x4(%esp)
  104680:	8b 45 08             	mov    0x8(%ebp),%eax
  104683:	89 04 24             	mov    %eax,(%esp)
  104686:	e8 5d ff ff ff       	call   1045e8 <page_remove_pte>
    }
}
  10468b:	c9                   	leave  
  10468c:	c3                   	ret    

0010468d <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10468d:	55                   	push   %ebp
  10468e:	89 e5                	mov    %esp,%ebp
  104690:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104693:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10469a:	00 
  10469b:	8b 45 10             	mov    0x10(%ebp),%eax
  10469e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1046a5:	89 04 24             	mov    %eax,(%esp)
  1046a8:	e8 aa fd ff ff       	call   104457 <get_pte>
  1046ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1046b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1046b4:	75 0a                	jne    1046c0 <page_insert+0x33>
        return -E_NO_MEM;
  1046b6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1046bb:	e9 84 00 00 00       	jmp    104744 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1046c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046c3:	89 04 24             	mov    %eax,(%esp)
  1046c6:	e8 5f f4 ff ff       	call   103b2a <page_ref_inc>
    if (*ptep & PTE_P) {
  1046cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046ce:	8b 00                	mov    (%eax),%eax
  1046d0:	83 e0 01             	and    $0x1,%eax
  1046d3:	85 c0                	test   %eax,%eax
  1046d5:	74 3e                	je     104715 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1046d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046da:	8b 00                	mov    (%eax),%eax
  1046dc:	89 04 24             	mov    %eax,(%esp)
  1046df:	e8 f1 f3 ff ff       	call   103ad5 <pte2page>
  1046e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1046e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1046ed:	75 0d                	jne    1046fc <page_insert+0x6f>
            page_ref_dec(page);
  1046ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046f2:	89 04 24             	mov    %eax,(%esp)
  1046f5:	e8 47 f4 ff ff       	call   103b41 <page_ref_dec>
  1046fa:	eb 19                	jmp    104715 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1046fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046ff:	89 44 24 08          	mov    %eax,0x8(%esp)
  104703:	8b 45 10             	mov    0x10(%ebp),%eax
  104706:	89 44 24 04          	mov    %eax,0x4(%esp)
  10470a:	8b 45 08             	mov    0x8(%ebp),%eax
  10470d:	89 04 24             	mov    %eax,(%esp)
  104710:	e8 d3 fe ff ff       	call   1045e8 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  104715:	8b 45 0c             	mov    0xc(%ebp),%eax
  104718:	89 04 24             	mov    %eax,(%esp)
  10471b:	e8 fc f2 ff ff       	call   103a1c <page2pa>
  104720:	0b 45 14             	or     0x14(%ebp),%eax
  104723:	83 c8 01             	or     $0x1,%eax
  104726:	89 c2                	mov    %eax,%edx
  104728:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10472b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10472d:	8b 45 10             	mov    0x10(%ebp),%eax
  104730:	89 44 24 04          	mov    %eax,0x4(%esp)
  104734:	8b 45 08             	mov    0x8(%ebp),%eax
  104737:	89 04 24             	mov    %eax,(%esp)
  10473a:	e8 07 00 00 00       	call   104746 <tlb_invalidate>
    return 0;
  10473f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104744:	c9                   	leave  
  104745:	c3                   	ret    

00104746 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  104746:	55                   	push   %ebp
  104747:	89 e5                	mov    %esp,%ebp
  104749:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10474c:	0f 20 d8             	mov    %cr3,%eax
  10474f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  104752:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  104755:	89 c2                	mov    %eax,%edx
  104757:	8b 45 08             	mov    0x8(%ebp),%eax
  10475a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10475d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104764:	77 23                	ja     104789 <tlb_invalidate+0x43>
  104766:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104769:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10476d:	c7 44 24 08 20 6b 10 	movl   $0x106b20,0x8(%esp)
  104774:	00 
  104775:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  10477c:	00 
  10477d:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104784:	e8 22 c5 ff ff       	call   100cab <__panic>
  104789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10478c:	05 00 00 00 40       	add    $0x40000000,%eax
  104791:	39 c2                	cmp    %eax,%edx
  104793:	75 0c                	jne    1047a1 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  104795:	8b 45 0c             	mov    0xc(%ebp),%eax
  104798:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10479b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10479e:	0f 01 38             	invlpg (%eax)
    }
}
  1047a1:	c9                   	leave  
  1047a2:	c3                   	ret    

001047a3 <check_alloc_page>:

static void
check_alloc_page(void) {
  1047a3:	55                   	push   %ebp
  1047a4:	89 e5                	mov    %esp,%ebp
  1047a6:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1047a9:	a1 5c 89 11 00       	mov    0x11895c,%eax
  1047ae:	8b 40 18             	mov    0x18(%eax),%eax
  1047b1:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1047b3:	c7 04 24 a4 6b 10 00 	movl   $0x106ba4,(%esp)
  1047ba:	e8 7d bb ff ff       	call   10033c <cprintf>
}
  1047bf:	c9                   	leave  
  1047c0:	c3                   	ret    

001047c1 <check_pgdir>:

static void
check_pgdir(void) {
  1047c1:	55                   	push   %ebp
  1047c2:	89 e5                	mov    %esp,%ebp
  1047c4:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1047c7:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1047cc:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1047d1:	76 24                	jbe    1047f7 <check_pgdir+0x36>
  1047d3:	c7 44 24 0c c3 6b 10 	movl   $0x106bc3,0xc(%esp)
  1047da:	00 
  1047db:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  1047e2:	00 
  1047e3:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  1047ea:	00 
  1047eb:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  1047f2:	e8 b4 c4 ff ff       	call   100cab <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1047f7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047fc:	85 c0                	test   %eax,%eax
  1047fe:	74 0e                	je     10480e <check_pgdir+0x4d>
  104800:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104805:	25 ff 0f 00 00       	and    $0xfff,%eax
  10480a:	85 c0                	test   %eax,%eax
  10480c:	74 24                	je     104832 <check_pgdir+0x71>
  10480e:	c7 44 24 0c e0 6b 10 	movl   $0x106be0,0xc(%esp)
  104815:	00 
  104816:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  10481d:	00 
  10481e:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  104825:	00 
  104826:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  10482d:	e8 79 c4 ff ff       	call   100cab <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104832:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104837:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10483e:	00 
  10483f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104846:	00 
  104847:	89 04 24             	mov    %eax,(%esp)
  10484a:	e8 40 fd ff ff       	call   10458f <get_page>
  10484f:	85 c0                	test   %eax,%eax
  104851:	74 24                	je     104877 <check_pgdir+0xb6>
  104853:	c7 44 24 0c 18 6c 10 	movl   $0x106c18,0xc(%esp)
  10485a:	00 
  10485b:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104862:	00 
  104863:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  10486a:	00 
  10486b:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104872:	e8 34 c4 ff ff       	call   100cab <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104877:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10487e:	e8 95 f4 ff ff       	call   103d18 <alloc_pages>
  104883:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104886:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10488b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104892:	00 
  104893:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10489a:	00 
  10489b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10489e:	89 54 24 04          	mov    %edx,0x4(%esp)
  1048a2:	89 04 24             	mov    %eax,(%esp)
  1048a5:	e8 e3 fd ff ff       	call   10468d <page_insert>
  1048aa:	85 c0                	test   %eax,%eax
  1048ac:	74 24                	je     1048d2 <check_pgdir+0x111>
  1048ae:	c7 44 24 0c 40 6c 10 	movl   $0x106c40,0xc(%esp)
  1048b5:	00 
  1048b6:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  1048bd:	00 
  1048be:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  1048c5:	00 
  1048c6:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  1048cd:	e8 d9 c3 ff ff       	call   100cab <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1048d2:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1048d7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048de:	00 
  1048df:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1048e6:	00 
  1048e7:	89 04 24             	mov    %eax,(%esp)
  1048ea:	e8 68 fb ff ff       	call   104457 <get_pte>
  1048ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1048f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1048f6:	75 24                	jne    10491c <check_pgdir+0x15b>
  1048f8:	c7 44 24 0c 6c 6c 10 	movl   $0x106c6c,0xc(%esp)
  1048ff:	00 
  104900:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104907:	00 
  104908:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  10490f:	00 
  104910:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104917:	e8 8f c3 ff ff       	call   100cab <__panic>
    assert(pa2page(*ptep) == p1);
  10491c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10491f:	8b 00                	mov    (%eax),%eax
  104921:	89 04 24             	mov    %eax,(%esp)
  104924:	e8 09 f1 ff ff       	call   103a32 <pa2page>
  104929:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10492c:	74 24                	je     104952 <check_pgdir+0x191>
  10492e:	c7 44 24 0c 99 6c 10 	movl   $0x106c99,0xc(%esp)
  104935:	00 
  104936:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  10493d:	00 
  10493e:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  104945:	00 
  104946:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  10494d:	e8 59 c3 ff ff       	call   100cab <__panic>
    assert(page_ref(p1) == 1);
  104952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104955:	89 04 24             	mov    %eax,(%esp)
  104958:	e8 b6 f1 ff ff       	call   103b13 <page_ref>
  10495d:	83 f8 01             	cmp    $0x1,%eax
  104960:	74 24                	je     104986 <check_pgdir+0x1c5>
  104962:	c7 44 24 0c ae 6c 10 	movl   $0x106cae,0xc(%esp)
  104969:	00 
  10496a:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104971:	00 
  104972:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104979:	00 
  10497a:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104981:	e8 25 c3 ff ff       	call   100cab <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104986:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10498b:	8b 00                	mov    (%eax),%eax
  10498d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104992:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104995:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104998:	c1 e8 0c             	shr    $0xc,%eax
  10499b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10499e:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1049a3:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1049a6:	72 23                	jb     1049cb <check_pgdir+0x20a>
  1049a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1049af:	c7 44 24 08 7c 6a 10 	movl   $0x106a7c,0x8(%esp)
  1049b6:	00 
  1049b7:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  1049be:	00 
  1049bf:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  1049c6:	e8 e0 c2 ff ff       	call   100cab <__panic>
  1049cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1049ce:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1049d3:	83 c0 04             	add    $0x4,%eax
  1049d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1049d9:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1049de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1049e5:	00 
  1049e6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1049ed:	00 
  1049ee:	89 04 24             	mov    %eax,(%esp)
  1049f1:	e8 61 fa ff ff       	call   104457 <get_pte>
  1049f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1049f9:	74 24                	je     104a1f <check_pgdir+0x25e>
  1049fb:	c7 44 24 0c c0 6c 10 	movl   $0x106cc0,0xc(%esp)
  104a02:	00 
  104a03:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104a0a:	00 
  104a0b:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104a12:	00 
  104a13:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104a1a:	e8 8c c2 ff ff       	call   100cab <__panic>

    p2 = alloc_page();
  104a1f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a26:	e8 ed f2 ff ff       	call   103d18 <alloc_pages>
  104a2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104a2e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a33:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104a3a:	00 
  104a3b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104a42:	00 
  104a43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104a46:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a4a:	89 04 24             	mov    %eax,(%esp)
  104a4d:	e8 3b fc ff ff       	call   10468d <page_insert>
  104a52:	85 c0                	test   %eax,%eax
  104a54:	74 24                	je     104a7a <check_pgdir+0x2b9>
  104a56:	c7 44 24 0c e8 6c 10 	movl   $0x106ce8,0xc(%esp)
  104a5d:	00 
  104a5e:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104a65:	00 
  104a66:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
  104a6d:	00 
  104a6e:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104a75:	e8 31 c2 ff ff       	call   100cab <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104a7a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a7f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a86:	00 
  104a87:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a8e:	00 
  104a8f:	89 04 24             	mov    %eax,(%esp)
  104a92:	e8 c0 f9 ff ff       	call   104457 <get_pte>
  104a97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a9e:	75 24                	jne    104ac4 <check_pgdir+0x303>
  104aa0:	c7 44 24 0c 20 6d 10 	movl   $0x106d20,0xc(%esp)
  104aa7:	00 
  104aa8:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104aaf:	00 
  104ab0:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104ab7:	00 
  104ab8:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104abf:	e8 e7 c1 ff ff       	call   100cab <__panic>
    assert(*ptep & PTE_U);
  104ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ac7:	8b 00                	mov    (%eax),%eax
  104ac9:	83 e0 04             	and    $0x4,%eax
  104acc:	85 c0                	test   %eax,%eax
  104ace:	75 24                	jne    104af4 <check_pgdir+0x333>
  104ad0:	c7 44 24 0c 50 6d 10 	movl   $0x106d50,0xc(%esp)
  104ad7:	00 
  104ad8:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104adf:	00 
  104ae0:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104ae7:	00 
  104ae8:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104aef:	e8 b7 c1 ff ff       	call   100cab <__panic>
    assert(*ptep & PTE_W);
  104af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104af7:	8b 00                	mov    (%eax),%eax
  104af9:	83 e0 02             	and    $0x2,%eax
  104afc:	85 c0                	test   %eax,%eax
  104afe:	75 24                	jne    104b24 <check_pgdir+0x363>
  104b00:	c7 44 24 0c 5e 6d 10 	movl   $0x106d5e,0xc(%esp)
  104b07:	00 
  104b08:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104b0f:	00 
  104b10:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104b17:	00 
  104b18:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104b1f:	e8 87 c1 ff ff       	call   100cab <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104b24:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b29:	8b 00                	mov    (%eax),%eax
  104b2b:	83 e0 04             	and    $0x4,%eax
  104b2e:	85 c0                	test   %eax,%eax
  104b30:	75 24                	jne    104b56 <check_pgdir+0x395>
  104b32:	c7 44 24 0c 6c 6d 10 	movl   $0x106d6c,0xc(%esp)
  104b39:	00 
  104b3a:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104b41:	00 
  104b42:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104b49:	00 
  104b4a:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104b51:	e8 55 c1 ff ff       	call   100cab <__panic>
    assert(page_ref(p2) == 1);
  104b56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b59:	89 04 24             	mov    %eax,(%esp)
  104b5c:	e8 b2 ef ff ff       	call   103b13 <page_ref>
  104b61:	83 f8 01             	cmp    $0x1,%eax
  104b64:	74 24                	je     104b8a <check_pgdir+0x3c9>
  104b66:	c7 44 24 0c 82 6d 10 	movl   $0x106d82,0xc(%esp)
  104b6d:	00 
  104b6e:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104b75:	00 
  104b76:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  104b7d:	00 
  104b7e:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104b85:	e8 21 c1 ff ff       	call   100cab <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104b8a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b8f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104b96:	00 
  104b97:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104b9e:	00 
  104b9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104ba2:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ba6:	89 04 24             	mov    %eax,(%esp)
  104ba9:	e8 df fa ff ff       	call   10468d <page_insert>
  104bae:	85 c0                	test   %eax,%eax
  104bb0:	74 24                	je     104bd6 <check_pgdir+0x415>
  104bb2:	c7 44 24 0c 94 6d 10 	movl   $0x106d94,0xc(%esp)
  104bb9:	00 
  104bba:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104bc1:	00 
  104bc2:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  104bc9:	00 
  104bca:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104bd1:	e8 d5 c0 ff ff       	call   100cab <__panic>
    assert(page_ref(p1) == 2);
  104bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bd9:	89 04 24             	mov    %eax,(%esp)
  104bdc:	e8 32 ef ff ff       	call   103b13 <page_ref>
  104be1:	83 f8 02             	cmp    $0x2,%eax
  104be4:	74 24                	je     104c0a <check_pgdir+0x449>
  104be6:	c7 44 24 0c c0 6d 10 	movl   $0x106dc0,0xc(%esp)
  104bed:	00 
  104bee:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104bf5:	00 
  104bf6:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104bfd:	00 
  104bfe:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104c05:	e8 a1 c0 ff ff       	call   100cab <__panic>
    assert(page_ref(p2) == 0);
  104c0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c0d:	89 04 24             	mov    %eax,(%esp)
  104c10:	e8 fe ee ff ff       	call   103b13 <page_ref>
  104c15:	85 c0                	test   %eax,%eax
  104c17:	74 24                	je     104c3d <check_pgdir+0x47c>
  104c19:	c7 44 24 0c d2 6d 10 	movl   $0x106dd2,0xc(%esp)
  104c20:	00 
  104c21:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104c28:	00 
  104c29:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104c30:	00 
  104c31:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104c38:	e8 6e c0 ff ff       	call   100cab <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104c3d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c42:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c49:	00 
  104c4a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c51:	00 
  104c52:	89 04 24             	mov    %eax,(%esp)
  104c55:	e8 fd f7 ff ff       	call   104457 <get_pte>
  104c5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c61:	75 24                	jne    104c87 <check_pgdir+0x4c6>
  104c63:	c7 44 24 0c 20 6d 10 	movl   $0x106d20,0xc(%esp)
  104c6a:	00 
  104c6b:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104c72:	00 
  104c73:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  104c7a:	00 
  104c7b:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104c82:	e8 24 c0 ff ff       	call   100cab <__panic>
    assert(pa2page(*ptep) == p1);
  104c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c8a:	8b 00                	mov    (%eax),%eax
  104c8c:	89 04 24             	mov    %eax,(%esp)
  104c8f:	e8 9e ed ff ff       	call   103a32 <pa2page>
  104c94:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104c97:	74 24                	je     104cbd <check_pgdir+0x4fc>
  104c99:	c7 44 24 0c 99 6c 10 	movl   $0x106c99,0xc(%esp)
  104ca0:	00 
  104ca1:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104ca8:	00 
  104ca9:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  104cb0:	00 
  104cb1:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104cb8:	e8 ee bf ff ff       	call   100cab <__panic>
    assert((*ptep & PTE_U) == 0);
  104cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cc0:	8b 00                	mov    (%eax),%eax
  104cc2:	83 e0 04             	and    $0x4,%eax
  104cc5:	85 c0                	test   %eax,%eax
  104cc7:	74 24                	je     104ced <check_pgdir+0x52c>
  104cc9:	c7 44 24 0c e4 6d 10 	movl   $0x106de4,0xc(%esp)
  104cd0:	00 
  104cd1:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104cd8:	00 
  104cd9:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104ce0:	00 
  104ce1:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104ce8:	e8 be bf ff ff       	call   100cab <__panic>

    page_remove(boot_pgdir, 0x0);
  104ced:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104cf2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104cf9:	00 
  104cfa:	89 04 24             	mov    %eax,(%esp)
  104cfd:	e8 47 f9 ff ff       	call   104649 <page_remove>
    assert(page_ref(p1) == 1);
  104d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d05:	89 04 24             	mov    %eax,(%esp)
  104d08:	e8 06 ee ff ff       	call   103b13 <page_ref>
  104d0d:	83 f8 01             	cmp    $0x1,%eax
  104d10:	74 24                	je     104d36 <check_pgdir+0x575>
  104d12:	c7 44 24 0c ae 6c 10 	movl   $0x106cae,0xc(%esp)
  104d19:	00 
  104d1a:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104d21:	00 
  104d22:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  104d29:	00 
  104d2a:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104d31:	e8 75 bf ff ff       	call   100cab <__panic>
    assert(page_ref(p2) == 0);
  104d36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d39:	89 04 24             	mov    %eax,(%esp)
  104d3c:	e8 d2 ed ff ff       	call   103b13 <page_ref>
  104d41:	85 c0                	test   %eax,%eax
  104d43:	74 24                	je     104d69 <check_pgdir+0x5a8>
  104d45:	c7 44 24 0c d2 6d 10 	movl   $0x106dd2,0xc(%esp)
  104d4c:	00 
  104d4d:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104d54:	00 
  104d55:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  104d5c:	00 
  104d5d:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104d64:	e8 42 bf ff ff       	call   100cab <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104d69:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d6e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104d75:	00 
  104d76:	89 04 24             	mov    %eax,(%esp)
  104d79:	e8 cb f8 ff ff       	call   104649 <page_remove>
    assert(page_ref(p1) == 0);
  104d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d81:	89 04 24             	mov    %eax,(%esp)
  104d84:	e8 8a ed ff ff       	call   103b13 <page_ref>
  104d89:	85 c0                	test   %eax,%eax
  104d8b:	74 24                	je     104db1 <check_pgdir+0x5f0>
  104d8d:	c7 44 24 0c f9 6d 10 	movl   $0x106df9,0xc(%esp)
  104d94:	00 
  104d95:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104d9c:	00 
  104d9d:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  104da4:	00 
  104da5:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104dac:	e8 fa be ff ff       	call   100cab <__panic>
    assert(page_ref(p2) == 0);
  104db1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104db4:	89 04 24             	mov    %eax,(%esp)
  104db7:	e8 57 ed ff ff       	call   103b13 <page_ref>
  104dbc:	85 c0                	test   %eax,%eax
  104dbe:	74 24                	je     104de4 <check_pgdir+0x623>
  104dc0:	c7 44 24 0c d2 6d 10 	movl   $0x106dd2,0xc(%esp)
  104dc7:	00 
  104dc8:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104dcf:	00 
  104dd0:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  104dd7:	00 
  104dd8:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104ddf:	e8 c7 be ff ff       	call   100cab <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104de4:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104de9:	8b 00                	mov    (%eax),%eax
  104deb:	89 04 24             	mov    %eax,(%esp)
  104dee:	e8 3f ec ff ff       	call   103a32 <pa2page>
  104df3:	89 04 24             	mov    %eax,(%esp)
  104df6:	e8 18 ed ff ff       	call   103b13 <page_ref>
  104dfb:	83 f8 01             	cmp    $0x1,%eax
  104dfe:	74 24                	je     104e24 <check_pgdir+0x663>
  104e00:	c7 44 24 0c 0c 6e 10 	movl   $0x106e0c,0xc(%esp)
  104e07:	00 
  104e08:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104e0f:	00 
  104e10:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
  104e17:	00 
  104e18:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104e1f:	e8 87 be ff ff       	call   100cab <__panic>
    free_page(pa2page(boot_pgdir[0]));
  104e24:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e29:	8b 00                	mov    (%eax),%eax
  104e2b:	89 04 24             	mov    %eax,(%esp)
  104e2e:	e8 ff eb ff ff       	call   103a32 <pa2page>
  104e33:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e3a:	00 
  104e3b:	89 04 24             	mov    %eax,(%esp)
  104e3e:	e8 0d ef ff ff       	call   103d50 <free_pages>
    boot_pgdir[0] = 0;
  104e43:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104e4e:	c7 04 24 32 6e 10 00 	movl   $0x106e32,(%esp)
  104e55:	e8 e2 b4 ff ff       	call   10033c <cprintf>
}
  104e5a:	c9                   	leave  
  104e5b:	c3                   	ret    

00104e5c <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104e5c:	55                   	push   %ebp
  104e5d:	89 e5                	mov    %esp,%ebp
  104e5f:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104e62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104e69:	e9 ca 00 00 00       	jmp    104f38 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e77:	c1 e8 0c             	shr    $0xc,%eax
  104e7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104e7d:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104e82:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104e85:	72 23                	jb     104eaa <check_boot_pgdir+0x4e>
  104e87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104e8e:	c7 44 24 08 7c 6a 10 	movl   $0x106a7c,0x8(%esp)
  104e95:	00 
  104e96:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
  104e9d:	00 
  104e9e:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104ea5:	e8 01 be ff ff       	call   100cab <__panic>
  104eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ead:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104eb2:	89 c2                	mov    %eax,%edx
  104eb4:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104eb9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104ec0:	00 
  104ec1:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ec5:	89 04 24             	mov    %eax,(%esp)
  104ec8:	e8 8a f5 ff ff       	call   104457 <get_pte>
  104ecd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104ed0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104ed4:	75 24                	jne    104efa <check_boot_pgdir+0x9e>
  104ed6:	c7 44 24 0c 4c 6e 10 	movl   $0x106e4c,0xc(%esp)
  104edd:	00 
  104ede:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104ee5:	00 
  104ee6:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
  104eed:	00 
  104eee:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104ef5:	e8 b1 bd ff ff       	call   100cab <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104efa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104efd:	8b 00                	mov    (%eax),%eax
  104eff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f04:	89 c2                	mov    %eax,%edx
  104f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f09:	39 c2                	cmp    %eax,%edx
  104f0b:	74 24                	je     104f31 <check_boot_pgdir+0xd5>
  104f0d:	c7 44 24 0c 89 6e 10 	movl   $0x106e89,0xc(%esp)
  104f14:	00 
  104f15:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104f1c:	00 
  104f1d:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
  104f24:	00 
  104f25:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104f2c:	e8 7a bd ff ff       	call   100cab <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104f31:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104f38:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104f3b:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104f40:	39 c2                	cmp    %eax,%edx
  104f42:	0f 82 26 ff ff ff    	jb     104e6e <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104f48:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f4d:	05 ac 0f 00 00       	add    $0xfac,%eax
  104f52:	8b 00                	mov    (%eax),%eax
  104f54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f59:	89 c2                	mov    %eax,%edx
  104f5b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104f63:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104f6a:	77 23                	ja     104f8f <check_boot_pgdir+0x133>
  104f6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104f73:	c7 44 24 08 20 6b 10 	movl   $0x106b20,0x8(%esp)
  104f7a:	00 
  104f7b:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  104f82:	00 
  104f83:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104f8a:	e8 1c bd ff ff       	call   100cab <__panic>
  104f8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f92:	05 00 00 00 40       	add    $0x40000000,%eax
  104f97:	39 c2                	cmp    %eax,%edx
  104f99:	74 24                	je     104fbf <check_boot_pgdir+0x163>
  104f9b:	c7 44 24 0c a0 6e 10 	movl   $0x106ea0,0xc(%esp)
  104fa2:	00 
  104fa3:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104faa:	00 
  104fab:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  104fb2:	00 
  104fb3:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104fba:	e8 ec bc ff ff       	call   100cab <__panic>

    assert(boot_pgdir[0] == 0);
  104fbf:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104fc4:	8b 00                	mov    (%eax),%eax
  104fc6:	85 c0                	test   %eax,%eax
  104fc8:	74 24                	je     104fee <check_boot_pgdir+0x192>
  104fca:	c7 44 24 0c d4 6e 10 	movl   $0x106ed4,0xc(%esp)
  104fd1:	00 
  104fd2:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  104fd9:	00 
  104fda:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
  104fe1:	00 
  104fe2:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  104fe9:	e8 bd bc ff ff       	call   100cab <__panic>

    struct Page *p;
    p = alloc_page();
  104fee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ff5:	e8 1e ed ff ff       	call   103d18 <alloc_pages>
  104ffa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104ffd:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105002:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105009:	00 
  10500a:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  105011:	00 
  105012:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105015:	89 54 24 04          	mov    %edx,0x4(%esp)
  105019:	89 04 24             	mov    %eax,(%esp)
  10501c:	e8 6c f6 ff ff       	call   10468d <page_insert>
  105021:	85 c0                	test   %eax,%eax
  105023:	74 24                	je     105049 <check_boot_pgdir+0x1ed>
  105025:	c7 44 24 0c e8 6e 10 	movl   $0x106ee8,0xc(%esp)
  10502c:	00 
  10502d:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  105034:	00 
  105035:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
  10503c:	00 
  10503d:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  105044:	e8 62 bc ff ff       	call   100cab <__panic>
    assert(page_ref(p) == 1);
  105049:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10504c:	89 04 24             	mov    %eax,(%esp)
  10504f:	e8 bf ea ff ff       	call   103b13 <page_ref>
  105054:	83 f8 01             	cmp    $0x1,%eax
  105057:	74 24                	je     10507d <check_boot_pgdir+0x221>
  105059:	c7 44 24 0c 16 6f 10 	movl   $0x106f16,0xc(%esp)
  105060:	00 
  105061:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  105068:	00 
  105069:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  105070:	00 
  105071:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  105078:	e8 2e bc ff ff       	call   100cab <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  10507d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  105082:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105089:	00 
  10508a:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  105091:	00 
  105092:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105095:	89 54 24 04          	mov    %edx,0x4(%esp)
  105099:	89 04 24             	mov    %eax,(%esp)
  10509c:	e8 ec f5 ff ff       	call   10468d <page_insert>
  1050a1:	85 c0                	test   %eax,%eax
  1050a3:	74 24                	je     1050c9 <check_boot_pgdir+0x26d>
  1050a5:	c7 44 24 0c 28 6f 10 	movl   $0x106f28,0xc(%esp)
  1050ac:	00 
  1050ad:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  1050b4:	00 
  1050b5:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
  1050bc:	00 
  1050bd:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  1050c4:	e8 e2 bb ff ff       	call   100cab <__panic>
    assert(page_ref(p) == 2);
  1050c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1050cc:	89 04 24             	mov    %eax,(%esp)
  1050cf:	e8 3f ea ff ff       	call   103b13 <page_ref>
  1050d4:	83 f8 02             	cmp    $0x2,%eax
  1050d7:	74 24                	je     1050fd <check_boot_pgdir+0x2a1>
  1050d9:	c7 44 24 0c 5f 6f 10 	movl   $0x106f5f,0xc(%esp)
  1050e0:	00 
  1050e1:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  1050e8:	00 
  1050e9:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
  1050f0:	00 
  1050f1:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  1050f8:	e8 ae bb ff ff       	call   100cab <__panic>

    const char *str = "ucore: Hello world!!";
  1050fd:	c7 45 dc 70 6f 10 00 	movl   $0x106f70,-0x24(%ebp)
    strcpy((void *)0x100, str);
  105104:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105107:	89 44 24 04          	mov    %eax,0x4(%esp)
  10510b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105112:	e8 1e 0a 00 00       	call   105b35 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  105117:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  10511e:	00 
  10511f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105126:	e8 83 0a 00 00       	call   105bae <strcmp>
  10512b:	85 c0                	test   %eax,%eax
  10512d:	74 24                	je     105153 <check_boot_pgdir+0x2f7>
  10512f:	c7 44 24 0c 88 6f 10 	movl   $0x106f88,0xc(%esp)
  105136:	00 
  105137:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  10513e:	00 
  10513f:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
  105146:	00 
  105147:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  10514e:	e8 58 bb ff ff       	call   100cab <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  105153:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105156:	89 04 24             	mov    %eax,(%esp)
  105159:	e8 23 e9 ff ff       	call   103a81 <page2kva>
  10515e:	05 00 01 00 00       	add    $0x100,%eax
  105163:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  105166:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10516d:	e8 6b 09 00 00       	call   105add <strlen>
  105172:	85 c0                	test   %eax,%eax
  105174:	74 24                	je     10519a <check_boot_pgdir+0x33e>
  105176:	c7 44 24 0c c0 6f 10 	movl   $0x106fc0,0xc(%esp)
  10517d:	00 
  10517e:	c7 44 24 08 69 6b 10 	movl   $0x106b69,0x8(%esp)
  105185:	00 
  105186:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
  10518d:	00 
  10518e:	c7 04 24 44 6b 10 00 	movl   $0x106b44,(%esp)
  105195:	e8 11 bb ff ff       	call   100cab <__panic>

    free_page(p);
  10519a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1051a1:	00 
  1051a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1051a5:	89 04 24             	mov    %eax,(%esp)
  1051a8:	e8 a3 eb ff ff       	call   103d50 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  1051ad:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1051b2:	8b 00                	mov    (%eax),%eax
  1051b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1051b9:	89 04 24             	mov    %eax,(%esp)
  1051bc:	e8 71 e8 ff ff       	call   103a32 <pa2page>
  1051c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1051c8:	00 
  1051c9:	89 04 24             	mov    %eax,(%esp)
  1051cc:	e8 7f eb ff ff       	call   103d50 <free_pages>
    boot_pgdir[0] = 0;
  1051d1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1051d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1051dc:	c7 04 24 e4 6f 10 00 	movl   $0x106fe4,(%esp)
  1051e3:	e8 54 b1 ff ff       	call   10033c <cprintf>
}
  1051e8:	c9                   	leave  
  1051e9:	c3                   	ret    

001051ea <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1051ea:	55                   	push   %ebp
  1051eb:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1051ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1051f0:	83 e0 04             	and    $0x4,%eax
  1051f3:	85 c0                	test   %eax,%eax
  1051f5:	74 07                	je     1051fe <perm2str+0x14>
  1051f7:	b8 75 00 00 00       	mov    $0x75,%eax
  1051fc:	eb 05                	jmp    105203 <perm2str+0x19>
  1051fe:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105203:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  105208:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  10520f:	8b 45 08             	mov    0x8(%ebp),%eax
  105212:	83 e0 02             	and    $0x2,%eax
  105215:	85 c0                	test   %eax,%eax
  105217:	74 07                	je     105220 <perm2str+0x36>
  105219:	b8 77 00 00 00       	mov    $0x77,%eax
  10521e:	eb 05                	jmp    105225 <perm2str+0x3b>
  105220:	b8 2d 00 00 00       	mov    $0x2d,%eax
  105225:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  10522a:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  105231:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  105236:	5d                   	pop    %ebp
  105237:	c3                   	ret    

00105238 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  105238:	55                   	push   %ebp
  105239:	89 e5                	mov    %esp,%ebp
  10523b:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  10523e:	8b 45 10             	mov    0x10(%ebp),%eax
  105241:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105244:	72 0a                	jb     105250 <get_pgtable_items+0x18>
        return 0;
  105246:	b8 00 00 00 00       	mov    $0x0,%eax
  10524b:	e9 9c 00 00 00       	jmp    1052ec <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  105250:	eb 04                	jmp    105256 <get_pgtable_items+0x1e>
        start ++;
  105252:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  105256:	8b 45 10             	mov    0x10(%ebp),%eax
  105259:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10525c:	73 18                	jae    105276 <get_pgtable_items+0x3e>
  10525e:	8b 45 10             	mov    0x10(%ebp),%eax
  105261:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105268:	8b 45 14             	mov    0x14(%ebp),%eax
  10526b:	01 d0                	add    %edx,%eax
  10526d:	8b 00                	mov    (%eax),%eax
  10526f:	83 e0 01             	and    $0x1,%eax
  105272:	85 c0                	test   %eax,%eax
  105274:	74 dc                	je     105252 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  105276:	8b 45 10             	mov    0x10(%ebp),%eax
  105279:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10527c:	73 69                	jae    1052e7 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  10527e:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  105282:	74 08                	je     10528c <get_pgtable_items+0x54>
            *left_store = start;
  105284:	8b 45 18             	mov    0x18(%ebp),%eax
  105287:	8b 55 10             	mov    0x10(%ebp),%edx
  10528a:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  10528c:	8b 45 10             	mov    0x10(%ebp),%eax
  10528f:	8d 50 01             	lea    0x1(%eax),%edx
  105292:	89 55 10             	mov    %edx,0x10(%ebp)
  105295:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10529c:	8b 45 14             	mov    0x14(%ebp),%eax
  10529f:	01 d0                	add    %edx,%eax
  1052a1:	8b 00                	mov    (%eax),%eax
  1052a3:	83 e0 07             	and    $0x7,%eax
  1052a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1052a9:	eb 04                	jmp    1052af <get_pgtable_items+0x77>
            start ++;
  1052ab:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  1052af:	8b 45 10             	mov    0x10(%ebp),%eax
  1052b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1052b5:	73 1d                	jae    1052d4 <get_pgtable_items+0x9c>
  1052b7:	8b 45 10             	mov    0x10(%ebp),%eax
  1052ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1052c1:	8b 45 14             	mov    0x14(%ebp),%eax
  1052c4:	01 d0                	add    %edx,%eax
  1052c6:	8b 00                	mov    (%eax),%eax
  1052c8:	83 e0 07             	and    $0x7,%eax
  1052cb:	89 c2                	mov    %eax,%edx
  1052cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1052d0:	39 c2                	cmp    %eax,%edx
  1052d2:	74 d7                	je     1052ab <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  1052d4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1052d8:	74 08                	je     1052e2 <get_pgtable_items+0xaa>
            *right_store = start;
  1052da:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1052dd:	8b 55 10             	mov    0x10(%ebp),%edx
  1052e0:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1052e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1052e5:	eb 05                	jmp    1052ec <get_pgtable_items+0xb4>
    }
    return 0;
  1052e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1052ec:	c9                   	leave  
  1052ed:	c3                   	ret    

001052ee <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1052ee:	55                   	push   %ebp
  1052ef:	89 e5                	mov    %esp,%ebp
  1052f1:	57                   	push   %edi
  1052f2:	56                   	push   %esi
  1052f3:	53                   	push   %ebx
  1052f4:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1052f7:	c7 04 24 04 70 10 00 	movl   $0x107004,(%esp)
  1052fe:	e8 39 b0 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  105303:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10530a:	e9 fa 00 00 00       	jmp    105409 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10530f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105312:	89 04 24             	mov    %eax,(%esp)
  105315:	e8 d0 fe ff ff       	call   1051ea <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  10531a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10531d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105320:	29 d1                	sub    %edx,%ecx
  105322:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105324:	89 d6                	mov    %edx,%esi
  105326:	c1 e6 16             	shl    $0x16,%esi
  105329:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10532c:	89 d3                	mov    %edx,%ebx
  10532e:	c1 e3 16             	shl    $0x16,%ebx
  105331:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105334:	89 d1                	mov    %edx,%ecx
  105336:	c1 e1 16             	shl    $0x16,%ecx
  105339:	8b 7d dc             	mov    -0x24(%ebp),%edi
  10533c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10533f:	29 d7                	sub    %edx,%edi
  105341:	89 fa                	mov    %edi,%edx
  105343:	89 44 24 14          	mov    %eax,0x14(%esp)
  105347:	89 74 24 10          	mov    %esi,0x10(%esp)
  10534b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10534f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105353:	89 54 24 04          	mov    %edx,0x4(%esp)
  105357:	c7 04 24 35 70 10 00 	movl   $0x107035,(%esp)
  10535e:	e8 d9 af ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  105363:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105366:	c1 e0 0a             	shl    $0xa,%eax
  105369:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10536c:	eb 54                	jmp    1053c2 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10536e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105371:	89 04 24             	mov    %eax,(%esp)
  105374:	e8 71 fe ff ff       	call   1051ea <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  105379:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10537c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10537f:	29 d1                	sub    %edx,%ecx
  105381:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105383:	89 d6                	mov    %edx,%esi
  105385:	c1 e6 0c             	shl    $0xc,%esi
  105388:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10538b:	89 d3                	mov    %edx,%ebx
  10538d:	c1 e3 0c             	shl    $0xc,%ebx
  105390:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105393:	c1 e2 0c             	shl    $0xc,%edx
  105396:	89 d1                	mov    %edx,%ecx
  105398:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  10539b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10539e:	29 d7                	sub    %edx,%edi
  1053a0:	89 fa                	mov    %edi,%edx
  1053a2:	89 44 24 14          	mov    %eax,0x14(%esp)
  1053a6:	89 74 24 10          	mov    %esi,0x10(%esp)
  1053aa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1053ae:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1053b2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1053b6:	c7 04 24 54 70 10 00 	movl   $0x107054,(%esp)
  1053bd:	e8 7a af ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1053c2:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  1053c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1053ca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1053cd:	89 ce                	mov    %ecx,%esi
  1053cf:	c1 e6 0a             	shl    $0xa,%esi
  1053d2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1053d5:	89 cb                	mov    %ecx,%ebx
  1053d7:	c1 e3 0a             	shl    $0xa,%ebx
  1053da:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  1053dd:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1053e1:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  1053e4:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1053e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1053ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053f0:	89 74 24 04          	mov    %esi,0x4(%esp)
  1053f4:	89 1c 24             	mov    %ebx,(%esp)
  1053f7:	e8 3c fe ff ff       	call   105238 <get_pgtable_items>
  1053fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1053ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105403:	0f 85 65 ff ff ff    	jne    10536e <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105409:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  10540e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105411:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  105414:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105418:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  10541b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10541f:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105423:	89 44 24 08          	mov    %eax,0x8(%esp)
  105427:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  10542e:	00 
  10542f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105436:	e8 fd fd ff ff       	call   105238 <get_pgtable_items>
  10543b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10543e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105442:	0f 85 c7 fe ff ff    	jne    10530f <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  105448:	c7 04 24 78 70 10 00 	movl   $0x107078,(%esp)
  10544f:	e8 e8 ae ff ff       	call   10033c <cprintf>
}
  105454:	83 c4 4c             	add    $0x4c,%esp
  105457:	5b                   	pop    %ebx
  105458:	5e                   	pop    %esi
  105459:	5f                   	pop    %edi
  10545a:	5d                   	pop    %ebp
  10545b:	c3                   	ret    

0010545c <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10545c:	55                   	push   %ebp
  10545d:	89 e5                	mov    %esp,%ebp
  10545f:	83 ec 58             	sub    $0x58,%esp
  105462:	8b 45 10             	mov    0x10(%ebp),%eax
  105465:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105468:	8b 45 14             	mov    0x14(%ebp),%eax
  10546b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10546e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105471:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105474:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105477:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  10547a:	8b 45 18             	mov    0x18(%ebp),%eax
  10547d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105480:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105483:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105486:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105489:	89 55 f0             	mov    %edx,-0x10(%ebp)
  10548c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10548f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105492:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105496:	74 1c                	je     1054b4 <printnum+0x58>
  105498:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10549b:	ba 00 00 00 00       	mov    $0x0,%edx
  1054a0:	f7 75 e4             	divl   -0x1c(%ebp)
  1054a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1054a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054a9:	ba 00 00 00 00       	mov    $0x0,%edx
  1054ae:	f7 75 e4             	divl   -0x1c(%ebp)
  1054b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1054b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1054ba:	f7 75 e4             	divl   -0x1c(%ebp)
  1054bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1054c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1054c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1054c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1054cc:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1054cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1054d2:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1054d5:	8b 45 18             	mov    0x18(%ebp),%eax
  1054d8:	ba 00 00 00 00       	mov    $0x0,%edx
  1054dd:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1054e0:	77 56                	ja     105538 <printnum+0xdc>
  1054e2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1054e5:	72 05                	jb     1054ec <printnum+0x90>
  1054e7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1054ea:	77 4c                	ja     105538 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1054ec:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1054ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  1054f2:	8b 45 20             	mov    0x20(%ebp),%eax
  1054f5:	89 44 24 18          	mov    %eax,0x18(%esp)
  1054f9:	89 54 24 14          	mov    %edx,0x14(%esp)
  1054fd:	8b 45 18             	mov    0x18(%ebp),%eax
  105500:	89 44 24 10          	mov    %eax,0x10(%esp)
  105504:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105507:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10550a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10550e:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105512:	8b 45 0c             	mov    0xc(%ebp),%eax
  105515:	89 44 24 04          	mov    %eax,0x4(%esp)
  105519:	8b 45 08             	mov    0x8(%ebp),%eax
  10551c:	89 04 24             	mov    %eax,(%esp)
  10551f:	e8 38 ff ff ff       	call   10545c <printnum>
  105524:	eb 1c                	jmp    105542 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105526:	8b 45 0c             	mov    0xc(%ebp),%eax
  105529:	89 44 24 04          	mov    %eax,0x4(%esp)
  10552d:	8b 45 20             	mov    0x20(%ebp),%eax
  105530:	89 04 24             	mov    %eax,(%esp)
  105533:	8b 45 08             	mov    0x8(%ebp),%eax
  105536:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  105538:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  10553c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105540:	7f e4                	jg     105526 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105542:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105545:	05 2c 71 10 00       	add    $0x10712c,%eax
  10554a:	0f b6 00             	movzbl (%eax),%eax
  10554d:	0f be c0             	movsbl %al,%eax
  105550:	8b 55 0c             	mov    0xc(%ebp),%edx
  105553:	89 54 24 04          	mov    %edx,0x4(%esp)
  105557:	89 04 24             	mov    %eax,(%esp)
  10555a:	8b 45 08             	mov    0x8(%ebp),%eax
  10555d:	ff d0                	call   *%eax
}
  10555f:	c9                   	leave  
  105560:	c3                   	ret    

00105561 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105561:	55                   	push   %ebp
  105562:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105564:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105568:	7e 14                	jle    10557e <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  10556a:	8b 45 08             	mov    0x8(%ebp),%eax
  10556d:	8b 00                	mov    (%eax),%eax
  10556f:	8d 48 08             	lea    0x8(%eax),%ecx
  105572:	8b 55 08             	mov    0x8(%ebp),%edx
  105575:	89 0a                	mov    %ecx,(%edx)
  105577:	8b 50 04             	mov    0x4(%eax),%edx
  10557a:	8b 00                	mov    (%eax),%eax
  10557c:	eb 30                	jmp    1055ae <getuint+0x4d>
    }
    else if (lflag) {
  10557e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105582:	74 16                	je     10559a <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105584:	8b 45 08             	mov    0x8(%ebp),%eax
  105587:	8b 00                	mov    (%eax),%eax
  105589:	8d 48 04             	lea    0x4(%eax),%ecx
  10558c:	8b 55 08             	mov    0x8(%ebp),%edx
  10558f:	89 0a                	mov    %ecx,(%edx)
  105591:	8b 00                	mov    (%eax),%eax
  105593:	ba 00 00 00 00       	mov    $0x0,%edx
  105598:	eb 14                	jmp    1055ae <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  10559a:	8b 45 08             	mov    0x8(%ebp),%eax
  10559d:	8b 00                	mov    (%eax),%eax
  10559f:	8d 48 04             	lea    0x4(%eax),%ecx
  1055a2:	8b 55 08             	mov    0x8(%ebp),%edx
  1055a5:	89 0a                	mov    %ecx,(%edx)
  1055a7:	8b 00                	mov    (%eax),%eax
  1055a9:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1055ae:	5d                   	pop    %ebp
  1055af:	c3                   	ret    

001055b0 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1055b0:	55                   	push   %ebp
  1055b1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1055b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1055b7:	7e 14                	jle    1055cd <getint+0x1d>
        return va_arg(*ap, long long);
  1055b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1055bc:	8b 00                	mov    (%eax),%eax
  1055be:	8d 48 08             	lea    0x8(%eax),%ecx
  1055c1:	8b 55 08             	mov    0x8(%ebp),%edx
  1055c4:	89 0a                	mov    %ecx,(%edx)
  1055c6:	8b 50 04             	mov    0x4(%eax),%edx
  1055c9:	8b 00                	mov    (%eax),%eax
  1055cb:	eb 28                	jmp    1055f5 <getint+0x45>
    }
    else if (lflag) {
  1055cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1055d1:	74 12                	je     1055e5 <getint+0x35>
        return va_arg(*ap, long);
  1055d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1055d6:	8b 00                	mov    (%eax),%eax
  1055d8:	8d 48 04             	lea    0x4(%eax),%ecx
  1055db:	8b 55 08             	mov    0x8(%ebp),%edx
  1055de:	89 0a                	mov    %ecx,(%edx)
  1055e0:	8b 00                	mov    (%eax),%eax
  1055e2:	99                   	cltd   
  1055e3:	eb 10                	jmp    1055f5 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1055e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1055e8:	8b 00                	mov    (%eax),%eax
  1055ea:	8d 48 04             	lea    0x4(%eax),%ecx
  1055ed:	8b 55 08             	mov    0x8(%ebp),%edx
  1055f0:	89 0a                	mov    %ecx,(%edx)
  1055f2:	8b 00                	mov    (%eax),%eax
  1055f4:	99                   	cltd   
    }
}
  1055f5:	5d                   	pop    %ebp
  1055f6:	c3                   	ret    

001055f7 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1055f7:	55                   	push   %ebp
  1055f8:	89 e5                	mov    %esp,%ebp
  1055fa:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1055fd:	8d 45 14             	lea    0x14(%ebp),%eax
  105600:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105606:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10560a:	8b 45 10             	mov    0x10(%ebp),%eax
  10560d:	89 44 24 08          	mov    %eax,0x8(%esp)
  105611:	8b 45 0c             	mov    0xc(%ebp),%eax
  105614:	89 44 24 04          	mov    %eax,0x4(%esp)
  105618:	8b 45 08             	mov    0x8(%ebp),%eax
  10561b:	89 04 24             	mov    %eax,(%esp)
  10561e:	e8 02 00 00 00       	call   105625 <vprintfmt>
    va_end(ap);
}
  105623:	c9                   	leave  
  105624:	c3                   	ret    

00105625 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105625:	55                   	push   %ebp
  105626:	89 e5                	mov    %esp,%ebp
  105628:	56                   	push   %esi
  105629:	53                   	push   %ebx
  10562a:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10562d:	eb 18                	jmp    105647 <vprintfmt+0x22>
            if (ch == '\0') {
  10562f:	85 db                	test   %ebx,%ebx
  105631:	75 05                	jne    105638 <vprintfmt+0x13>
                return;
  105633:	e9 d1 03 00 00       	jmp    105a09 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  105638:	8b 45 0c             	mov    0xc(%ebp),%eax
  10563b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10563f:	89 1c 24             	mov    %ebx,(%esp)
  105642:	8b 45 08             	mov    0x8(%ebp),%eax
  105645:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105647:	8b 45 10             	mov    0x10(%ebp),%eax
  10564a:	8d 50 01             	lea    0x1(%eax),%edx
  10564d:	89 55 10             	mov    %edx,0x10(%ebp)
  105650:	0f b6 00             	movzbl (%eax),%eax
  105653:	0f b6 d8             	movzbl %al,%ebx
  105656:	83 fb 25             	cmp    $0x25,%ebx
  105659:	75 d4                	jne    10562f <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  10565b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10565f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105666:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105669:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  10566c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105673:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105676:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105679:	8b 45 10             	mov    0x10(%ebp),%eax
  10567c:	8d 50 01             	lea    0x1(%eax),%edx
  10567f:	89 55 10             	mov    %edx,0x10(%ebp)
  105682:	0f b6 00             	movzbl (%eax),%eax
  105685:	0f b6 d8             	movzbl %al,%ebx
  105688:	8d 43 dd             	lea    -0x23(%ebx),%eax
  10568b:	83 f8 55             	cmp    $0x55,%eax
  10568e:	0f 87 44 03 00 00    	ja     1059d8 <vprintfmt+0x3b3>
  105694:	8b 04 85 50 71 10 00 	mov    0x107150(,%eax,4),%eax
  10569b:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10569d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1056a1:	eb d6                	jmp    105679 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1056a3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1056a7:	eb d0                	jmp    105679 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1056a9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1056b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1056b3:	89 d0                	mov    %edx,%eax
  1056b5:	c1 e0 02             	shl    $0x2,%eax
  1056b8:	01 d0                	add    %edx,%eax
  1056ba:	01 c0                	add    %eax,%eax
  1056bc:	01 d8                	add    %ebx,%eax
  1056be:	83 e8 30             	sub    $0x30,%eax
  1056c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1056c4:	8b 45 10             	mov    0x10(%ebp),%eax
  1056c7:	0f b6 00             	movzbl (%eax),%eax
  1056ca:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1056cd:	83 fb 2f             	cmp    $0x2f,%ebx
  1056d0:	7e 0b                	jle    1056dd <vprintfmt+0xb8>
  1056d2:	83 fb 39             	cmp    $0x39,%ebx
  1056d5:	7f 06                	jg     1056dd <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1056d7:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1056db:	eb d3                	jmp    1056b0 <vprintfmt+0x8b>
            goto process_precision;
  1056dd:	eb 33                	jmp    105712 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1056df:	8b 45 14             	mov    0x14(%ebp),%eax
  1056e2:	8d 50 04             	lea    0x4(%eax),%edx
  1056e5:	89 55 14             	mov    %edx,0x14(%ebp)
  1056e8:	8b 00                	mov    (%eax),%eax
  1056ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1056ed:	eb 23                	jmp    105712 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1056ef:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056f3:	79 0c                	jns    105701 <vprintfmt+0xdc>
                width = 0;
  1056f5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1056fc:	e9 78 ff ff ff       	jmp    105679 <vprintfmt+0x54>
  105701:	e9 73 ff ff ff       	jmp    105679 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  105706:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10570d:	e9 67 ff ff ff       	jmp    105679 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  105712:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105716:	79 12                	jns    10572a <vprintfmt+0x105>
                width = precision, precision = -1;
  105718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10571b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10571e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105725:	e9 4f ff ff ff       	jmp    105679 <vprintfmt+0x54>
  10572a:	e9 4a ff ff ff       	jmp    105679 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  10572f:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  105733:	e9 41 ff ff ff       	jmp    105679 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105738:	8b 45 14             	mov    0x14(%ebp),%eax
  10573b:	8d 50 04             	lea    0x4(%eax),%edx
  10573e:	89 55 14             	mov    %edx,0x14(%ebp)
  105741:	8b 00                	mov    (%eax),%eax
  105743:	8b 55 0c             	mov    0xc(%ebp),%edx
  105746:	89 54 24 04          	mov    %edx,0x4(%esp)
  10574a:	89 04 24             	mov    %eax,(%esp)
  10574d:	8b 45 08             	mov    0x8(%ebp),%eax
  105750:	ff d0                	call   *%eax
            break;
  105752:	e9 ac 02 00 00       	jmp    105a03 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105757:	8b 45 14             	mov    0x14(%ebp),%eax
  10575a:	8d 50 04             	lea    0x4(%eax),%edx
  10575d:	89 55 14             	mov    %edx,0x14(%ebp)
  105760:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105762:	85 db                	test   %ebx,%ebx
  105764:	79 02                	jns    105768 <vprintfmt+0x143>
                err = -err;
  105766:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105768:	83 fb 06             	cmp    $0x6,%ebx
  10576b:	7f 0b                	jg     105778 <vprintfmt+0x153>
  10576d:	8b 34 9d 10 71 10 00 	mov    0x107110(,%ebx,4),%esi
  105774:	85 f6                	test   %esi,%esi
  105776:	75 23                	jne    10579b <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  105778:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10577c:	c7 44 24 08 3d 71 10 	movl   $0x10713d,0x8(%esp)
  105783:	00 
  105784:	8b 45 0c             	mov    0xc(%ebp),%eax
  105787:	89 44 24 04          	mov    %eax,0x4(%esp)
  10578b:	8b 45 08             	mov    0x8(%ebp),%eax
  10578e:	89 04 24             	mov    %eax,(%esp)
  105791:	e8 61 fe ff ff       	call   1055f7 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105796:	e9 68 02 00 00       	jmp    105a03 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  10579b:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10579f:	c7 44 24 08 46 71 10 	movl   $0x107146,0x8(%esp)
  1057a6:	00 
  1057a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057aa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1057b1:	89 04 24             	mov    %eax,(%esp)
  1057b4:	e8 3e fe ff ff       	call   1055f7 <printfmt>
            }
            break;
  1057b9:	e9 45 02 00 00       	jmp    105a03 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1057be:	8b 45 14             	mov    0x14(%ebp),%eax
  1057c1:	8d 50 04             	lea    0x4(%eax),%edx
  1057c4:	89 55 14             	mov    %edx,0x14(%ebp)
  1057c7:	8b 30                	mov    (%eax),%esi
  1057c9:	85 f6                	test   %esi,%esi
  1057cb:	75 05                	jne    1057d2 <vprintfmt+0x1ad>
                p = "(null)";
  1057cd:	be 49 71 10 00       	mov    $0x107149,%esi
            }
            if (width > 0 && padc != '-') {
  1057d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057d6:	7e 3e                	jle    105816 <vprintfmt+0x1f1>
  1057d8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1057dc:	74 38                	je     105816 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1057de:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1057e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057e8:	89 34 24             	mov    %esi,(%esp)
  1057eb:	e8 15 03 00 00       	call   105b05 <strnlen>
  1057f0:	29 c3                	sub    %eax,%ebx
  1057f2:	89 d8                	mov    %ebx,%eax
  1057f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1057f7:	eb 17                	jmp    105810 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1057f9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1057fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  105800:	89 54 24 04          	mov    %edx,0x4(%esp)
  105804:	89 04 24             	mov    %eax,(%esp)
  105807:	8b 45 08             	mov    0x8(%ebp),%eax
  10580a:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  10580c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105810:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105814:	7f e3                	jg     1057f9 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105816:	eb 38                	jmp    105850 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  105818:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10581c:	74 1f                	je     10583d <vprintfmt+0x218>
  10581e:	83 fb 1f             	cmp    $0x1f,%ebx
  105821:	7e 05                	jle    105828 <vprintfmt+0x203>
  105823:	83 fb 7e             	cmp    $0x7e,%ebx
  105826:	7e 15                	jle    10583d <vprintfmt+0x218>
                    putch('?', putdat);
  105828:	8b 45 0c             	mov    0xc(%ebp),%eax
  10582b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10582f:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105836:	8b 45 08             	mov    0x8(%ebp),%eax
  105839:	ff d0                	call   *%eax
  10583b:	eb 0f                	jmp    10584c <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  10583d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105840:	89 44 24 04          	mov    %eax,0x4(%esp)
  105844:	89 1c 24             	mov    %ebx,(%esp)
  105847:	8b 45 08             	mov    0x8(%ebp),%eax
  10584a:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10584c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105850:	89 f0                	mov    %esi,%eax
  105852:	8d 70 01             	lea    0x1(%eax),%esi
  105855:	0f b6 00             	movzbl (%eax),%eax
  105858:	0f be d8             	movsbl %al,%ebx
  10585b:	85 db                	test   %ebx,%ebx
  10585d:	74 10                	je     10586f <vprintfmt+0x24a>
  10585f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105863:	78 b3                	js     105818 <vprintfmt+0x1f3>
  105865:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105869:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10586d:	79 a9                	jns    105818 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10586f:	eb 17                	jmp    105888 <vprintfmt+0x263>
                putch(' ', putdat);
  105871:	8b 45 0c             	mov    0xc(%ebp),%eax
  105874:	89 44 24 04          	mov    %eax,0x4(%esp)
  105878:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10587f:	8b 45 08             	mov    0x8(%ebp),%eax
  105882:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105884:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105888:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10588c:	7f e3                	jg     105871 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  10588e:	e9 70 01 00 00       	jmp    105a03 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105893:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105896:	89 44 24 04          	mov    %eax,0x4(%esp)
  10589a:	8d 45 14             	lea    0x14(%ebp),%eax
  10589d:	89 04 24             	mov    %eax,(%esp)
  1058a0:	e8 0b fd ff ff       	call   1055b0 <getint>
  1058a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1058ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1058b1:	85 d2                	test   %edx,%edx
  1058b3:	79 26                	jns    1058db <vprintfmt+0x2b6>
                putch('-', putdat);
  1058b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058b8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058bc:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1058c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1058c6:	ff d0                	call   *%eax
                num = -(long long)num;
  1058c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1058ce:	f7 d8                	neg    %eax
  1058d0:	83 d2 00             	adc    $0x0,%edx
  1058d3:	f7 da                	neg    %edx
  1058d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1058db:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1058e2:	e9 a8 00 00 00       	jmp    10598f <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1058e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058ee:	8d 45 14             	lea    0x14(%ebp),%eax
  1058f1:	89 04 24             	mov    %eax,(%esp)
  1058f4:	e8 68 fc ff ff       	call   105561 <getuint>
  1058f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1058ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105906:	e9 84 00 00 00       	jmp    10598f <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  10590b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10590e:	89 44 24 04          	mov    %eax,0x4(%esp)
  105912:	8d 45 14             	lea    0x14(%ebp),%eax
  105915:	89 04 24             	mov    %eax,(%esp)
  105918:	e8 44 fc ff ff       	call   105561 <getuint>
  10591d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105920:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105923:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  10592a:	eb 63                	jmp    10598f <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  10592c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10592f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105933:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  10593a:	8b 45 08             	mov    0x8(%ebp),%eax
  10593d:	ff d0                	call   *%eax
            putch('x', putdat);
  10593f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105942:	89 44 24 04          	mov    %eax,0x4(%esp)
  105946:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10594d:	8b 45 08             	mov    0x8(%ebp),%eax
  105950:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105952:	8b 45 14             	mov    0x14(%ebp),%eax
  105955:	8d 50 04             	lea    0x4(%eax),%edx
  105958:	89 55 14             	mov    %edx,0x14(%ebp)
  10595b:	8b 00                	mov    (%eax),%eax
  10595d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105960:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105967:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10596e:	eb 1f                	jmp    10598f <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105970:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105973:	89 44 24 04          	mov    %eax,0x4(%esp)
  105977:	8d 45 14             	lea    0x14(%ebp),%eax
  10597a:	89 04 24             	mov    %eax,(%esp)
  10597d:	e8 df fb ff ff       	call   105561 <getuint>
  105982:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105985:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105988:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10598f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105993:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105996:	89 54 24 18          	mov    %edx,0x18(%esp)
  10599a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10599d:	89 54 24 14          	mov    %edx,0x14(%esp)
  1059a1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1059a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059ab:	89 44 24 08          	mov    %eax,0x8(%esp)
  1059af:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1059b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1059bd:	89 04 24             	mov    %eax,(%esp)
  1059c0:	e8 97 fa ff ff       	call   10545c <printnum>
            break;
  1059c5:	eb 3c                	jmp    105a03 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1059c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059ce:	89 1c 24             	mov    %ebx,(%esp)
  1059d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1059d4:	ff d0                	call   *%eax
            break;
  1059d6:	eb 2b                	jmp    105a03 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1059d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059df:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1059e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1059e9:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1059eb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1059ef:	eb 04                	jmp    1059f5 <vprintfmt+0x3d0>
  1059f1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1059f5:	8b 45 10             	mov    0x10(%ebp),%eax
  1059f8:	83 e8 01             	sub    $0x1,%eax
  1059fb:	0f b6 00             	movzbl (%eax),%eax
  1059fe:	3c 25                	cmp    $0x25,%al
  105a00:	75 ef                	jne    1059f1 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  105a02:	90                   	nop
        }
    }
  105a03:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105a04:	e9 3e fc ff ff       	jmp    105647 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105a09:	83 c4 40             	add    $0x40,%esp
  105a0c:	5b                   	pop    %ebx
  105a0d:	5e                   	pop    %esi
  105a0e:	5d                   	pop    %ebp
  105a0f:	c3                   	ret    

00105a10 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105a10:	55                   	push   %ebp
  105a11:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105a13:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a16:	8b 40 08             	mov    0x8(%eax),%eax
  105a19:	8d 50 01             	lea    0x1(%eax),%edx
  105a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a1f:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a25:	8b 10                	mov    (%eax),%edx
  105a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a2a:	8b 40 04             	mov    0x4(%eax),%eax
  105a2d:	39 c2                	cmp    %eax,%edx
  105a2f:	73 12                	jae    105a43 <sprintputch+0x33>
        *b->buf ++ = ch;
  105a31:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a34:	8b 00                	mov    (%eax),%eax
  105a36:	8d 48 01             	lea    0x1(%eax),%ecx
  105a39:	8b 55 0c             	mov    0xc(%ebp),%edx
  105a3c:	89 0a                	mov    %ecx,(%edx)
  105a3e:	8b 55 08             	mov    0x8(%ebp),%edx
  105a41:	88 10                	mov    %dl,(%eax)
    }
}
  105a43:	5d                   	pop    %ebp
  105a44:	c3                   	ret    

00105a45 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105a45:	55                   	push   %ebp
  105a46:	89 e5                	mov    %esp,%ebp
  105a48:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105a4b:	8d 45 14             	lea    0x14(%ebp),%eax
  105a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a54:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a58:	8b 45 10             	mov    0x10(%ebp),%eax
  105a5b:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a62:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a66:	8b 45 08             	mov    0x8(%ebp),%eax
  105a69:	89 04 24             	mov    %eax,(%esp)
  105a6c:	e8 08 00 00 00       	call   105a79 <vsnprintf>
  105a71:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105a77:	c9                   	leave  
  105a78:	c3                   	ret    

00105a79 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105a79:	55                   	push   %ebp
  105a7a:	89 e5                	mov    %esp,%ebp
  105a7c:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  105a82:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a85:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a88:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  105a8e:	01 d0                	add    %edx,%eax
  105a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105a9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105a9e:	74 0a                	je     105aaa <vsnprintf+0x31>
  105aa0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105aa6:	39 c2                	cmp    %eax,%edx
  105aa8:	76 07                	jbe    105ab1 <vsnprintf+0x38>
        return -E_INVAL;
  105aaa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105aaf:	eb 2a                	jmp    105adb <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105ab1:	8b 45 14             	mov    0x14(%ebp),%eax
  105ab4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105ab8:	8b 45 10             	mov    0x10(%ebp),%eax
  105abb:	89 44 24 08          	mov    %eax,0x8(%esp)
  105abf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ac6:	c7 04 24 10 5a 10 00 	movl   $0x105a10,(%esp)
  105acd:	e8 53 fb ff ff       	call   105625 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105ad2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ad5:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105adb:	c9                   	leave  
  105adc:	c3                   	ret    

00105add <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105add:	55                   	push   %ebp
  105ade:	89 e5                	mov    %esp,%ebp
  105ae0:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105ae3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105aea:	eb 04                	jmp    105af0 <strlen+0x13>
        cnt ++;
  105aec:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105af0:	8b 45 08             	mov    0x8(%ebp),%eax
  105af3:	8d 50 01             	lea    0x1(%eax),%edx
  105af6:	89 55 08             	mov    %edx,0x8(%ebp)
  105af9:	0f b6 00             	movzbl (%eax),%eax
  105afc:	84 c0                	test   %al,%al
  105afe:	75 ec                	jne    105aec <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b03:	c9                   	leave  
  105b04:	c3                   	ret    

00105b05 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105b05:	55                   	push   %ebp
  105b06:	89 e5                	mov    %esp,%ebp
  105b08:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105b0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105b12:	eb 04                	jmp    105b18 <strnlen+0x13>
        cnt ++;
  105b14:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105b18:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b1b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105b1e:	73 10                	jae    105b30 <strnlen+0x2b>
  105b20:	8b 45 08             	mov    0x8(%ebp),%eax
  105b23:	8d 50 01             	lea    0x1(%eax),%edx
  105b26:	89 55 08             	mov    %edx,0x8(%ebp)
  105b29:	0f b6 00             	movzbl (%eax),%eax
  105b2c:	84 c0                	test   %al,%al
  105b2e:	75 e4                	jne    105b14 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105b30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b33:	c9                   	leave  
  105b34:	c3                   	ret    

00105b35 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105b35:	55                   	push   %ebp
  105b36:	89 e5                	mov    %esp,%ebp
  105b38:	57                   	push   %edi
  105b39:	56                   	push   %esi
  105b3a:	83 ec 20             	sub    $0x20,%esp
  105b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  105b40:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b43:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b46:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105b49:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b4f:	89 d1                	mov    %edx,%ecx
  105b51:	89 c2                	mov    %eax,%edx
  105b53:	89 ce                	mov    %ecx,%esi
  105b55:	89 d7                	mov    %edx,%edi
  105b57:	ac                   	lods   %ds:(%esi),%al
  105b58:	aa                   	stos   %al,%es:(%edi)
  105b59:	84 c0                	test   %al,%al
  105b5b:	75 fa                	jne    105b57 <strcpy+0x22>
  105b5d:	89 fa                	mov    %edi,%edx
  105b5f:	89 f1                	mov    %esi,%ecx
  105b61:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105b64:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105b67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105b6d:	83 c4 20             	add    $0x20,%esp
  105b70:	5e                   	pop    %esi
  105b71:	5f                   	pop    %edi
  105b72:	5d                   	pop    %ebp
  105b73:	c3                   	ret    

00105b74 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105b74:	55                   	push   %ebp
  105b75:	89 e5                	mov    %esp,%ebp
  105b77:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  105b7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105b80:	eb 21                	jmp    105ba3 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b85:	0f b6 10             	movzbl (%eax),%edx
  105b88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b8b:	88 10                	mov    %dl,(%eax)
  105b8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b90:	0f b6 00             	movzbl (%eax),%eax
  105b93:	84 c0                	test   %al,%al
  105b95:	74 04                	je     105b9b <strncpy+0x27>
            src ++;
  105b97:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105b9b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105b9f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105ba3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ba7:	75 d9                	jne    105b82 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105ba9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105bac:	c9                   	leave  
  105bad:	c3                   	ret    

00105bae <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105bae:	55                   	push   %ebp
  105baf:	89 e5                	mov    %esp,%ebp
  105bb1:	57                   	push   %edi
  105bb2:	56                   	push   %esi
  105bb3:	83 ec 20             	sub    $0x20,%esp
  105bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  105bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105bc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105bc8:	89 d1                	mov    %edx,%ecx
  105bca:	89 c2                	mov    %eax,%edx
  105bcc:	89 ce                	mov    %ecx,%esi
  105bce:	89 d7                	mov    %edx,%edi
  105bd0:	ac                   	lods   %ds:(%esi),%al
  105bd1:	ae                   	scas   %es:(%edi),%al
  105bd2:	75 08                	jne    105bdc <strcmp+0x2e>
  105bd4:	84 c0                	test   %al,%al
  105bd6:	75 f8                	jne    105bd0 <strcmp+0x22>
  105bd8:	31 c0                	xor    %eax,%eax
  105bda:	eb 04                	jmp    105be0 <strcmp+0x32>
  105bdc:	19 c0                	sbb    %eax,%eax
  105bde:	0c 01                	or     $0x1,%al
  105be0:	89 fa                	mov    %edi,%edx
  105be2:	89 f1                	mov    %esi,%ecx
  105be4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105be7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105bea:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105bed:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105bf0:	83 c4 20             	add    $0x20,%esp
  105bf3:	5e                   	pop    %esi
  105bf4:	5f                   	pop    %edi
  105bf5:	5d                   	pop    %ebp
  105bf6:	c3                   	ret    

00105bf7 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105bf7:	55                   	push   %ebp
  105bf8:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105bfa:	eb 0c                	jmp    105c08 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105bfc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105c00:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105c04:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105c08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c0c:	74 1a                	je     105c28 <strncmp+0x31>
  105c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  105c11:	0f b6 00             	movzbl (%eax),%eax
  105c14:	84 c0                	test   %al,%al
  105c16:	74 10                	je     105c28 <strncmp+0x31>
  105c18:	8b 45 08             	mov    0x8(%ebp),%eax
  105c1b:	0f b6 10             	movzbl (%eax),%edx
  105c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c21:	0f b6 00             	movzbl (%eax),%eax
  105c24:	38 c2                	cmp    %al,%dl
  105c26:	74 d4                	je     105bfc <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105c28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105c2c:	74 18                	je     105c46 <strncmp+0x4f>
  105c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  105c31:	0f b6 00             	movzbl (%eax),%eax
  105c34:	0f b6 d0             	movzbl %al,%edx
  105c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c3a:	0f b6 00             	movzbl (%eax),%eax
  105c3d:	0f b6 c0             	movzbl %al,%eax
  105c40:	29 c2                	sub    %eax,%edx
  105c42:	89 d0                	mov    %edx,%eax
  105c44:	eb 05                	jmp    105c4b <strncmp+0x54>
  105c46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c4b:	5d                   	pop    %ebp
  105c4c:	c3                   	ret    

00105c4d <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105c4d:	55                   	push   %ebp
  105c4e:	89 e5                	mov    %esp,%ebp
  105c50:	83 ec 04             	sub    $0x4,%esp
  105c53:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c56:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c59:	eb 14                	jmp    105c6f <strchr+0x22>
        if (*s == c) {
  105c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  105c5e:	0f b6 00             	movzbl (%eax),%eax
  105c61:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105c64:	75 05                	jne    105c6b <strchr+0x1e>
            return (char *)s;
  105c66:	8b 45 08             	mov    0x8(%ebp),%eax
  105c69:	eb 13                	jmp    105c7e <strchr+0x31>
        }
        s ++;
  105c6b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c72:	0f b6 00             	movzbl (%eax),%eax
  105c75:	84 c0                	test   %al,%al
  105c77:	75 e2                	jne    105c5b <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105c79:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c7e:	c9                   	leave  
  105c7f:	c3                   	ret    

00105c80 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105c80:	55                   	push   %ebp
  105c81:	89 e5                	mov    %esp,%ebp
  105c83:	83 ec 04             	sub    $0x4,%esp
  105c86:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c89:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c8c:	eb 11                	jmp    105c9f <strfind+0x1f>
        if (*s == c) {
  105c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  105c91:	0f b6 00             	movzbl (%eax),%eax
  105c94:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105c97:	75 02                	jne    105c9b <strfind+0x1b>
            break;
  105c99:	eb 0e                	jmp    105ca9 <strfind+0x29>
        }
        s ++;
  105c9b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  105ca2:	0f b6 00             	movzbl (%eax),%eax
  105ca5:	84 c0                	test   %al,%al
  105ca7:	75 e5                	jne    105c8e <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105ca9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105cac:	c9                   	leave  
  105cad:	c3                   	ret    

00105cae <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105cae:	55                   	push   %ebp
  105caf:	89 e5                	mov    %esp,%ebp
  105cb1:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105cb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105cbb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105cc2:	eb 04                	jmp    105cc8 <strtol+0x1a>
        s ++;
  105cc4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  105ccb:	0f b6 00             	movzbl (%eax),%eax
  105cce:	3c 20                	cmp    $0x20,%al
  105cd0:	74 f2                	je     105cc4 <strtol+0x16>
  105cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  105cd5:	0f b6 00             	movzbl (%eax),%eax
  105cd8:	3c 09                	cmp    $0x9,%al
  105cda:	74 e8                	je     105cc4 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  105cdf:	0f b6 00             	movzbl (%eax),%eax
  105ce2:	3c 2b                	cmp    $0x2b,%al
  105ce4:	75 06                	jne    105cec <strtol+0x3e>
        s ++;
  105ce6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105cea:	eb 15                	jmp    105d01 <strtol+0x53>
    }
    else if (*s == '-') {
  105cec:	8b 45 08             	mov    0x8(%ebp),%eax
  105cef:	0f b6 00             	movzbl (%eax),%eax
  105cf2:	3c 2d                	cmp    $0x2d,%al
  105cf4:	75 0b                	jne    105d01 <strtol+0x53>
        s ++, neg = 1;
  105cf6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105cfa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105d01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d05:	74 06                	je     105d0d <strtol+0x5f>
  105d07:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105d0b:	75 24                	jne    105d31 <strtol+0x83>
  105d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  105d10:	0f b6 00             	movzbl (%eax),%eax
  105d13:	3c 30                	cmp    $0x30,%al
  105d15:	75 1a                	jne    105d31 <strtol+0x83>
  105d17:	8b 45 08             	mov    0x8(%ebp),%eax
  105d1a:	83 c0 01             	add    $0x1,%eax
  105d1d:	0f b6 00             	movzbl (%eax),%eax
  105d20:	3c 78                	cmp    $0x78,%al
  105d22:	75 0d                	jne    105d31 <strtol+0x83>
        s += 2, base = 16;
  105d24:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105d28:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105d2f:	eb 2a                	jmp    105d5b <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105d31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d35:	75 17                	jne    105d4e <strtol+0xa0>
  105d37:	8b 45 08             	mov    0x8(%ebp),%eax
  105d3a:	0f b6 00             	movzbl (%eax),%eax
  105d3d:	3c 30                	cmp    $0x30,%al
  105d3f:	75 0d                	jne    105d4e <strtol+0xa0>
        s ++, base = 8;
  105d41:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d45:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105d4c:	eb 0d                	jmp    105d5b <strtol+0xad>
    }
    else if (base == 0) {
  105d4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d52:	75 07                	jne    105d5b <strtol+0xad>
        base = 10;
  105d54:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  105d5e:	0f b6 00             	movzbl (%eax),%eax
  105d61:	3c 2f                	cmp    $0x2f,%al
  105d63:	7e 1b                	jle    105d80 <strtol+0xd2>
  105d65:	8b 45 08             	mov    0x8(%ebp),%eax
  105d68:	0f b6 00             	movzbl (%eax),%eax
  105d6b:	3c 39                	cmp    $0x39,%al
  105d6d:	7f 11                	jg     105d80 <strtol+0xd2>
            dig = *s - '0';
  105d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  105d72:	0f b6 00             	movzbl (%eax),%eax
  105d75:	0f be c0             	movsbl %al,%eax
  105d78:	83 e8 30             	sub    $0x30,%eax
  105d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d7e:	eb 48                	jmp    105dc8 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105d80:	8b 45 08             	mov    0x8(%ebp),%eax
  105d83:	0f b6 00             	movzbl (%eax),%eax
  105d86:	3c 60                	cmp    $0x60,%al
  105d88:	7e 1b                	jle    105da5 <strtol+0xf7>
  105d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  105d8d:	0f b6 00             	movzbl (%eax),%eax
  105d90:	3c 7a                	cmp    $0x7a,%al
  105d92:	7f 11                	jg     105da5 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105d94:	8b 45 08             	mov    0x8(%ebp),%eax
  105d97:	0f b6 00             	movzbl (%eax),%eax
  105d9a:	0f be c0             	movsbl %al,%eax
  105d9d:	83 e8 57             	sub    $0x57,%eax
  105da0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105da3:	eb 23                	jmp    105dc8 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105da5:	8b 45 08             	mov    0x8(%ebp),%eax
  105da8:	0f b6 00             	movzbl (%eax),%eax
  105dab:	3c 40                	cmp    $0x40,%al
  105dad:	7e 3d                	jle    105dec <strtol+0x13e>
  105daf:	8b 45 08             	mov    0x8(%ebp),%eax
  105db2:	0f b6 00             	movzbl (%eax),%eax
  105db5:	3c 5a                	cmp    $0x5a,%al
  105db7:	7f 33                	jg     105dec <strtol+0x13e>
            dig = *s - 'A' + 10;
  105db9:	8b 45 08             	mov    0x8(%ebp),%eax
  105dbc:	0f b6 00             	movzbl (%eax),%eax
  105dbf:	0f be c0             	movsbl %al,%eax
  105dc2:	83 e8 37             	sub    $0x37,%eax
  105dc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105dcb:	3b 45 10             	cmp    0x10(%ebp),%eax
  105dce:	7c 02                	jl     105dd2 <strtol+0x124>
            break;
  105dd0:	eb 1a                	jmp    105dec <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105dd2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105dd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105dd9:	0f af 45 10          	imul   0x10(%ebp),%eax
  105ddd:	89 c2                	mov    %eax,%edx
  105ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105de2:	01 d0                	add    %edx,%eax
  105de4:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105de7:	e9 6f ff ff ff       	jmp    105d5b <strtol+0xad>

    if (endptr) {
  105dec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105df0:	74 08                	je     105dfa <strtol+0x14c>
        *endptr = (char *) s;
  105df2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105df5:	8b 55 08             	mov    0x8(%ebp),%edx
  105df8:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105dfa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105dfe:	74 07                	je     105e07 <strtol+0x159>
  105e00:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105e03:	f7 d8                	neg    %eax
  105e05:	eb 03                	jmp    105e0a <strtol+0x15c>
  105e07:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105e0a:	c9                   	leave  
  105e0b:	c3                   	ret    

00105e0c <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105e0c:	55                   	push   %ebp
  105e0d:	89 e5                	mov    %esp,%ebp
  105e0f:	57                   	push   %edi
  105e10:	83 ec 24             	sub    $0x24,%esp
  105e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e16:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105e19:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105e1d:	8b 55 08             	mov    0x8(%ebp),%edx
  105e20:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105e23:	88 45 f7             	mov    %al,-0x9(%ebp)
  105e26:	8b 45 10             	mov    0x10(%ebp),%eax
  105e29:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105e2c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105e2f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105e33:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105e36:	89 d7                	mov    %edx,%edi
  105e38:	f3 aa                	rep stos %al,%es:(%edi)
  105e3a:	89 fa                	mov    %edi,%edx
  105e3c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105e3f:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105e42:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105e45:	83 c4 24             	add    $0x24,%esp
  105e48:	5f                   	pop    %edi
  105e49:	5d                   	pop    %ebp
  105e4a:	c3                   	ret    

00105e4b <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105e4b:	55                   	push   %ebp
  105e4c:	89 e5                	mov    %esp,%ebp
  105e4e:	57                   	push   %edi
  105e4f:	56                   	push   %esi
  105e50:	53                   	push   %ebx
  105e51:	83 ec 30             	sub    $0x30,%esp
  105e54:	8b 45 08             	mov    0x8(%ebp),%eax
  105e57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105e60:	8b 45 10             	mov    0x10(%ebp),%eax
  105e63:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e69:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105e6c:	73 42                	jae    105eb0 <memmove+0x65>
  105e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105e74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e77:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105e7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e7d:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105e80:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105e83:	c1 e8 02             	shr    $0x2,%eax
  105e86:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105e88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105e8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105e8e:	89 d7                	mov    %edx,%edi
  105e90:	89 c6                	mov    %eax,%esi
  105e92:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105e94:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105e97:	83 e1 03             	and    $0x3,%ecx
  105e9a:	74 02                	je     105e9e <memmove+0x53>
  105e9c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e9e:	89 f0                	mov    %esi,%eax
  105ea0:	89 fa                	mov    %edi,%edx
  105ea2:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105ea5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105ea8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105eab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105eae:	eb 36                	jmp    105ee6 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105eb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105eb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  105eb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105eb9:	01 c2                	add    %eax,%edx
  105ebb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ebe:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ec4:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105ec7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105eca:	89 c1                	mov    %eax,%ecx
  105ecc:	89 d8                	mov    %ebx,%eax
  105ece:	89 d6                	mov    %edx,%esi
  105ed0:	89 c7                	mov    %eax,%edi
  105ed2:	fd                   	std    
  105ed3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105ed5:	fc                   	cld    
  105ed6:	89 f8                	mov    %edi,%eax
  105ed8:	89 f2                	mov    %esi,%edx
  105eda:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105edd:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105ee0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105ee6:	83 c4 30             	add    $0x30,%esp
  105ee9:	5b                   	pop    %ebx
  105eea:	5e                   	pop    %esi
  105eeb:	5f                   	pop    %edi
  105eec:	5d                   	pop    %ebp
  105eed:	c3                   	ret    

00105eee <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105eee:	55                   	push   %ebp
  105eef:	89 e5                	mov    %esp,%ebp
  105ef1:	57                   	push   %edi
  105ef2:	56                   	push   %esi
  105ef3:	83 ec 20             	sub    $0x20,%esp
  105ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  105ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  105eff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f02:	8b 45 10             	mov    0x10(%ebp),%eax
  105f05:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105f08:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105f0b:	c1 e8 02             	shr    $0x2,%eax
  105f0e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105f10:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105f16:	89 d7                	mov    %edx,%edi
  105f18:	89 c6                	mov    %eax,%esi
  105f1a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105f1c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105f1f:	83 e1 03             	and    $0x3,%ecx
  105f22:	74 02                	je     105f26 <memcpy+0x38>
  105f24:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105f26:	89 f0                	mov    %esi,%eax
  105f28:	89 fa                	mov    %edi,%edx
  105f2a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105f2d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105f30:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105f36:	83 c4 20             	add    $0x20,%esp
  105f39:	5e                   	pop    %esi
  105f3a:	5f                   	pop    %edi
  105f3b:	5d                   	pop    %ebp
  105f3c:	c3                   	ret    

00105f3d <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105f3d:	55                   	push   %ebp
  105f3e:	89 e5                	mov    %esp,%ebp
  105f40:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105f43:	8b 45 08             	mov    0x8(%ebp),%eax
  105f46:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105f4f:	eb 30                	jmp    105f81 <memcmp+0x44>
        if (*s1 != *s2) {
  105f51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f54:	0f b6 10             	movzbl (%eax),%edx
  105f57:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f5a:	0f b6 00             	movzbl (%eax),%eax
  105f5d:	38 c2                	cmp    %al,%dl
  105f5f:	74 18                	je     105f79 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105f61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f64:	0f b6 00             	movzbl (%eax),%eax
  105f67:	0f b6 d0             	movzbl %al,%edx
  105f6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f6d:	0f b6 00             	movzbl (%eax),%eax
  105f70:	0f b6 c0             	movzbl %al,%eax
  105f73:	29 c2                	sub    %eax,%edx
  105f75:	89 d0                	mov    %edx,%eax
  105f77:	eb 1a                	jmp    105f93 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105f79:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105f7d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105f81:	8b 45 10             	mov    0x10(%ebp),%eax
  105f84:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f87:	89 55 10             	mov    %edx,0x10(%ebp)
  105f8a:	85 c0                	test   %eax,%eax
  105f8c:	75 c3                	jne    105f51 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105f8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105f93:	c9                   	leave  
  105f94:	c3                   	ret    
