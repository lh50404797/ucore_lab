
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 60 11 40 	lgdtl  0x40116018
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
  10001e:	bc 00 60 11 00       	mov    $0x116000,%esp
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
  100030:	ba 68 79 11 00       	mov    $0x117968,%edx
  100035:	b8 36 6a 11 00       	mov    $0x116a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 6a 11 00 	movl   $0x116a36,(%esp)
  100051:	e8 be 59 00 00       	call   105a14 <memset>

    cons_init();                // init the console
  100056:	e8 b7 14 00 00       	call   101512 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 a0 5b 10 00 	movl   $0x105ba0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 bc 5b 10 00 	movl   $0x105bbc,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 3b 40 00 00       	call   1040bf <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 f2 15 00 00       	call   10167b <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 44 17 00 00       	call   1017d2 <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 35 0c 00 00       	call   100cc8 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 51 15 00 00       	call   1015e9 <intr_enable>
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
  1000b7:	e8 3e 0b 00 00       	call   100bfa <mon_backtrace>
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
  100148:	a1 40 6a 11 00       	mov    0x116a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 c1 5b 10 00 	movl   $0x105bc1,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 6a 11 00       	mov    0x116a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 cf 5b 10 00 	movl   $0x105bcf,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 6a 11 00       	mov    0x116a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 dd 5b 10 00 	movl   $0x105bdd,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 6a 11 00       	mov    0x116a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 eb 5b 10 00 	movl   $0x105beb,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 6a 11 00       	mov    0x116a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 f9 5b 10 00 	movl   $0x105bf9,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 6a 11 00       	mov    0x116a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 6a 11 00       	mov    %eax,0x116a40
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
  100205:	c7 04 24 08 5c 10 00 	movl   $0x105c08,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 28 5c 10 00 	movl   $0x105c28,(%esp)
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
  100246:	c7 04 24 47 5c 10 00 	movl   $0x105c47,(%esp)
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
  100294:	88 90 60 6a 11 00    	mov    %dl,0x116a60(%eax)
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
  1002d3:	05 60 6a 11 00       	add    $0x116a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 6a 11 00       	mov    $0x116a60,%eax
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
  1002f5:	e8 44 12 00 00       	call   10153e <cons_putc>
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
  100332:	e8 f6 4e 00 00       	call   10522d <vprintfmt>
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
  10036e:	e8 cb 11 00 00       	call   10153e <cons_putc>
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
  1003ca:	e8 ab 11 00 00       	call   10157a <cons_getc>
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
  10053c:	c7 00 4c 5c 10 00    	movl   $0x105c4c,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 4c 5c 10 00 	movl   $0x105c4c,0x8(%eax)
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
  100573:	c7 45 f4 60 6e 10 00 	movl   $0x106e60,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 e8 15 11 00 	movl   $0x1115e8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec e9 15 11 00 	movl   $0x1115e9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 e3 3f 11 00 	movl   $0x113fe3,-0x18(%ebp)

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
  1006e7:	e8 9c 51 00 00       	call   105888 <strfind>
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
  100876:	c7 04 24 56 5c 10 00 	movl   $0x105c56,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 6f 5c 10 00 	movl   $0x105c6f,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 9d 5b 10 	movl   $0x105b9d,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 87 5c 10 00 	movl   $0x105c87,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 6a 11 	movl   $0x116a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 9f 5c 10 00 	movl   $0x105c9f,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 68 79 11 	movl   $0x117968,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 b7 5c 10 00 	movl   $0x105cb7,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 68 79 11 00       	mov    $0x117968,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 d0 5c 10 00 	movl   $0x105cd0,(%esp)
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
  10092c:	c7 04 24 fa 5c 10 00 	movl   $0x105cfa,(%esp)
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
  10099b:	c7 04 24 16 5d 10 00 	movl   $0x105d16,(%esp)
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
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
  1009bd:	5d                   	pop    %ebp
  1009be:	c3                   	ret    

001009bf <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  1009bf:	55                   	push   %ebp
  1009c0:	89 e5                	mov    %esp,%ebp
  1009c2:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  1009c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  1009cc:	eb 0c                	jmp    1009da <parse+0x1b>
            *buf ++ = '\0';
  1009ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1009d1:	8d 50 01             	lea    0x1(%eax),%edx
  1009d4:	89 55 08             	mov    %edx,0x8(%ebp)
  1009d7:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  1009da:	8b 45 08             	mov    0x8(%ebp),%eax
  1009dd:	0f b6 00             	movzbl (%eax),%eax
  1009e0:	84 c0                	test   %al,%al
  1009e2:	74 1d                	je     100a01 <parse+0x42>
  1009e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1009e7:	0f b6 00             	movzbl (%eax),%eax
  1009ea:	0f be c0             	movsbl %al,%eax
  1009ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f1:	c7 04 24 a8 5d 10 00 	movl   $0x105da8,(%esp)
  1009f8:	e8 58 4e 00 00       	call   105855 <strchr>
  1009fd:	85 c0                	test   %eax,%eax
  1009ff:	75 cd                	jne    1009ce <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a01:	8b 45 08             	mov    0x8(%ebp),%eax
  100a04:	0f b6 00             	movzbl (%eax),%eax
  100a07:	84 c0                	test   %al,%al
  100a09:	75 02                	jne    100a0d <parse+0x4e>
            break;
  100a0b:	eb 67                	jmp    100a74 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a0d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a11:	75 14                	jne    100a27 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100a13:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100a1a:	00 
  100a1b:	c7 04 24 ad 5d 10 00 	movl   $0x105dad,(%esp)
  100a22:	e8 15 f9 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a2a:	8d 50 01             	lea    0x1(%eax),%edx
  100a2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100a30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a37:	8b 45 0c             	mov    0xc(%ebp),%eax
  100a3a:	01 c2                	add    %eax,%edx
  100a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  100a3f:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a41:	eb 04                	jmp    100a47 <parse+0x88>
            buf ++;
  100a43:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100a47:	8b 45 08             	mov    0x8(%ebp),%eax
  100a4a:	0f b6 00             	movzbl (%eax),%eax
  100a4d:	84 c0                	test   %al,%al
  100a4f:	74 1d                	je     100a6e <parse+0xaf>
  100a51:	8b 45 08             	mov    0x8(%ebp),%eax
  100a54:	0f b6 00             	movzbl (%eax),%eax
  100a57:	0f be c0             	movsbl %al,%eax
  100a5a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a5e:	c7 04 24 a8 5d 10 00 	movl   $0x105da8,(%esp)
  100a65:	e8 eb 4d 00 00       	call   105855 <strchr>
  100a6a:	85 c0                	test   %eax,%eax
  100a6c:	74 d5                	je     100a43 <parse+0x84>
            buf ++;
        }
    }
  100a6e:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a6f:	e9 66 ff ff ff       	jmp    1009da <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100a77:	c9                   	leave  
  100a78:	c3                   	ret    

00100a79 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100a79:	55                   	push   %ebp
  100a7a:	89 e5                	mov    %esp,%ebp
  100a7c:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100a7f:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100a82:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a86:	8b 45 08             	mov    0x8(%ebp),%eax
  100a89:	89 04 24             	mov    %eax,(%esp)
  100a8c:	e8 2e ff ff ff       	call   1009bf <parse>
  100a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100a94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100a98:	75 0a                	jne    100aa4 <runcmd+0x2b>
        return 0;
  100a9a:	b8 00 00 00 00       	mov    $0x0,%eax
  100a9f:	e9 85 00 00 00       	jmp    100b29 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100aa4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100aab:	eb 5c                	jmp    100b09 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100aad:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100ab0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ab3:	89 d0                	mov    %edx,%eax
  100ab5:	01 c0                	add    %eax,%eax
  100ab7:	01 d0                	add    %edx,%eax
  100ab9:	c1 e0 02             	shl    $0x2,%eax
  100abc:	05 20 60 11 00       	add    $0x116020,%eax
  100ac1:	8b 00                	mov    (%eax),%eax
  100ac3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100ac7:	89 04 24             	mov    %eax,(%esp)
  100aca:	e8 e7 4c 00 00       	call   1057b6 <strcmp>
  100acf:	85 c0                	test   %eax,%eax
  100ad1:	75 32                	jne    100b05 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100ad3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ad6:	89 d0                	mov    %edx,%eax
  100ad8:	01 c0                	add    %eax,%eax
  100ada:	01 d0                	add    %edx,%eax
  100adc:	c1 e0 02             	shl    $0x2,%eax
  100adf:	05 20 60 11 00       	add    $0x116020,%eax
  100ae4:	8b 40 08             	mov    0x8(%eax),%eax
  100ae7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100aea:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100aed:	8b 55 0c             	mov    0xc(%ebp),%edx
  100af0:	89 54 24 08          	mov    %edx,0x8(%esp)
  100af4:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100af7:	83 c2 04             	add    $0x4,%edx
  100afa:	89 54 24 04          	mov    %edx,0x4(%esp)
  100afe:	89 0c 24             	mov    %ecx,(%esp)
  100b01:	ff d0                	call   *%eax
  100b03:	eb 24                	jmp    100b29 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b05:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b0c:	83 f8 02             	cmp    $0x2,%eax
  100b0f:	76 9c                	jbe    100aad <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b11:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100b14:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b18:	c7 04 24 cb 5d 10 00 	movl   $0x105dcb,(%esp)
  100b1f:	e8 18 f8 ff ff       	call   10033c <cprintf>
    return 0;
  100b24:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100b29:	c9                   	leave  
  100b2a:	c3                   	ret    

00100b2b <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100b2b:	55                   	push   %ebp
  100b2c:	89 e5                	mov    %esp,%ebp
  100b2e:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100b31:	c7 04 24 e4 5d 10 00 	movl   $0x105de4,(%esp)
  100b38:	e8 ff f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100b3d:	c7 04 24 0c 5e 10 00 	movl   $0x105e0c,(%esp)
  100b44:	e8 f3 f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100b49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100b4d:	74 0b                	je     100b5a <kmonitor+0x2f>
        print_trapframe(tf);
  100b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b52:	89 04 24             	mov    %eax,(%esp)
  100b55:	e8 c4 0c 00 00       	call   10181e <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100b5a:	c7 04 24 31 5e 10 00 	movl   $0x105e31,(%esp)
  100b61:	e8 cd f6 ff ff       	call   100233 <readline>
  100b66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100b69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b6d:	74 18                	je     100b87 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  100b72:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b79:	89 04 24             	mov    %eax,(%esp)
  100b7c:	e8 f8 fe ff ff       	call   100a79 <runcmd>
  100b81:	85 c0                	test   %eax,%eax
  100b83:	79 02                	jns    100b87 <kmonitor+0x5c>
                break;
  100b85:	eb 02                	jmp    100b89 <kmonitor+0x5e>
            }
        }
    }
  100b87:	eb d1                	jmp    100b5a <kmonitor+0x2f>
}
  100b89:	c9                   	leave  
  100b8a:	c3                   	ret    

00100b8b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100b8b:	55                   	push   %ebp
  100b8c:	89 e5                	mov    %esp,%ebp
  100b8e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b98:	eb 3f                	jmp    100bd9 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100b9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b9d:	89 d0                	mov    %edx,%eax
  100b9f:	01 c0                	add    %eax,%eax
  100ba1:	01 d0                	add    %edx,%eax
  100ba3:	c1 e0 02             	shl    $0x2,%eax
  100ba6:	05 20 60 11 00       	add    $0x116020,%eax
  100bab:	8b 48 04             	mov    0x4(%eax),%ecx
  100bae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100bb1:	89 d0                	mov    %edx,%eax
  100bb3:	01 c0                	add    %eax,%eax
  100bb5:	01 d0                	add    %edx,%eax
  100bb7:	c1 e0 02             	shl    $0x2,%eax
  100bba:	05 20 60 11 00       	add    $0x116020,%eax
  100bbf:	8b 00                	mov    (%eax),%eax
  100bc1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100bc5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bc9:	c7 04 24 35 5e 10 00 	movl   $0x105e35,(%esp)
  100bd0:	e8 67 f7 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bd5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bdc:	83 f8 02             	cmp    $0x2,%eax
  100bdf:	76 b9                	jbe    100b9a <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100be1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100be6:	c9                   	leave  
  100be7:	c3                   	ret    

00100be8 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100be8:	55                   	push   %ebp
  100be9:	89 e5                	mov    %esp,%ebp
  100beb:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100bee:	e8 7d fc ff ff       	call   100870 <print_kerninfo>
    return 0;
  100bf3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bf8:	c9                   	leave  
  100bf9:	c3                   	ret    

00100bfa <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100bfa:	55                   	push   %ebp
  100bfb:	89 e5                	mov    %esp,%ebp
  100bfd:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c00:	e8 b5 fd ff ff       	call   1009ba <print_stackframe>
    return 0;
  100c05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c0a:	c9                   	leave  
  100c0b:	c3                   	ret    

00100c0c <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c0c:	55                   	push   %ebp
  100c0d:	89 e5                	mov    %esp,%ebp
  100c0f:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100c12:	a1 60 6e 11 00       	mov    0x116e60,%eax
  100c17:	85 c0                	test   %eax,%eax
  100c19:	74 02                	je     100c1d <__panic+0x11>
        goto panic_dead;
  100c1b:	eb 48                	jmp    100c65 <__panic+0x59>
    }
    is_panic = 1;
  100c1d:	c7 05 60 6e 11 00 01 	movl   $0x1,0x116e60
  100c24:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100c27:	8d 45 14             	lea    0x14(%ebp),%eax
  100c2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c30:	89 44 24 08          	mov    %eax,0x8(%esp)
  100c34:	8b 45 08             	mov    0x8(%ebp),%eax
  100c37:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c3b:	c7 04 24 3e 5e 10 00 	movl   $0x105e3e,(%esp)
  100c42:	e8 f5 f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c4e:	8b 45 10             	mov    0x10(%ebp),%eax
  100c51:	89 04 24             	mov    %eax,(%esp)
  100c54:	e8 b0 f6 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100c59:	c7 04 24 5a 5e 10 00 	movl   $0x105e5a,(%esp)
  100c60:	e8 d7 f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100c65:	e8 85 09 00 00       	call   1015ef <intr_disable>
    while (1) {
        kmonitor(NULL);
  100c6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100c71:	e8 b5 fe ff ff       	call   100b2b <kmonitor>
    }
  100c76:	eb f2                	jmp    100c6a <__panic+0x5e>

00100c78 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100c78:	55                   	push   %ebp
  100c79:	89 e5                	mov    %esp,%ebp
  100c7b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100c7e:	8d 45 14             	lea    0x14(%ebp),%eax
  100c81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100c84:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c87:	89 44 24 08          	mov    %eax,0x8(%esp)
  100c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  100c8e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c92:	c7 04 24 5c 5e 10 00 	movl   $0x105e5c,(%esp)
  100c99:	e8 9e f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ca5:	8b 45 10             	mov    0x10(%ebp),%eax
  100ca8:	89 04 24             	mov    %eax,(%esp)
  100cab:	e8 59 f6 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100cb0:	c7 04 24 5a 5e 10 00 	movl   $0x105e5a,(%esp)
  100cb7:	e8 80 f6 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100cbc:	c9                   	leave  
  100cbd:	c3                   	ret    

00100cbe <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100cbe:	55                   	push   %ebp
  100cbf:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100cc1:	a1 60 6e 11 00       	mov    0x116e60,%eax
}
  100cc6:	5d                   	pop    %ebp
  100cc7:	c3                   	ret    

00100cc8 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100cc8:	55                   	push   %ebp
  100cc9:	89 e5                	mov    %esp,%ebp
  100ccb:	83 ec 28             	sub    $0x28,%esp
  100cce:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100cd4:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100cd8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100cdc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100ce0:	ee                   	out    %al,(%dx)
  100ce1:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100ce7:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100ceb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100cef:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100cf3:	ee                   	out    %al,(%dx)
  100cf4:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100cfa:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100cfe:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d02:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d06:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d07:	c7 05 4c 79 11 00 00 	movl   $0x0,0x11794c
  100d0e:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d11:	c7 04 24 7a 5e 10 00 	movl   $0x105e7a,(%esp)
  100d18:	e8 1f f6 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100d1d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d24:	e8 24 09 00 00       	call   10164d <pic_enable>
}
  100d29:	c9                   	leave  
  100d2a:	c3                   	ret    

00100d2b <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100d2b:	55                   	push   %ebp
  100d2c:	89 e5                	mov    %esp,%ebp
  100d2e:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100d31:	9c                   	pushf  
  100d32:	58                   	pop    %eax
  100d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100d39:	25 00 02 00 00       	and    $0x200,%eax
  100d3e:	85 c0                	test   %eax,%eax
  100d40:	74 0c                	je     100d4e <__intr_save+0x23>
        intr_disable();
  100d42:	e8 a8 08 00 00       	call   1015ef <intr_disable>
        return 1;
  100d47:	b8 01 00 00 00       	mov    $0x1,%eax
  100d4c:	eb 05                	jmp    100d53 <__intr_save+0x28>
    }
    return 0;
  100d4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d53:	c9                   	leave  
  100d54:	c3                   	ret    

00100d55 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100d55:	55                   	push   %ebp
  100d56:	89 e5                	mov    %esp,%ebp
  100d58:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100d5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d5f:	74 05                	je     100d66 <__intr_restore+0x11>
        intr_enable();
  100d61:	e8 83 08 00 00       	call   1015e9 <intr_enable>
    }
}
  100d66:	c9                   	leave  
  100d67:	c3                   	ret    

00100d68 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100d68:	55                   	push   %ebp
  100d69:	89 e5                	mov    %esp,%ebp
  100d6b:	83 ec 10             	sub    $0x10,%esp
  100d6e:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100d74:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100d78:	89 c2                	mov    %eax,%edx
  100d7a:	ec                   	in     (%dx),%al
  100d7b:	88 45 fd             	mov    %al,-0x3(%ebp)
  100d7e:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100d84:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100d88:	89 c2                	mov    %eax,%edx
  100d8a:	ec                   	in     (%dx),%al
  100d8b:	88 45 f9             	mov    %al,-0x7(%ebp)
  100d8e:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100d94:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100d98:	89 c2                	mov    %eax,%edx
  100d9a:	ec                   	in     (%dx),%al
  100d9b:	88 45 f5             	mov    %al,-0xb(%ebp)
  100d9e:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100da4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100da8:	89 c2                	mov    %eax,%edx
  100daa:	ec                   	in     (%dx),%al
  100dab:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100dae:	c9                   	leave  
  100daf:	c3                   	ret    

00100db0 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100db0:	55                   	push   %ebp
  100db1:	89 e5                	mov    %esp,%ebp
  100db3:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100db6:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100dbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dc0:	0f b7 00             	movzwl (%eax),%eax
  100dc3:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100dc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dca:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100dcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100dd2:	0f b7 00             	movzwl (%eax),%eax
  100dd5:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100dd9:	74 12                	je     100ded <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100ddb:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100de2:	66 c7 05 86 6e 11 00 	movw   $0x3b4,0x116e86
  100de9:	b4 03 
  100deb:	eb 13                	jmp    100e00 <cga_init+0x50>
    } else {
        *cp = was;
  100ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100df0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100df4:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100df7:	66 c7 05 86 6e 11 00 	movw   $0x3d4,0x116e86
  100dfe:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e00:	0f b7 05 86 6e 11 00 	movzwl 0x116e86,%eax
  100e07:	0f b7 c0             	movzwl %ax,%eax
  100e0a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e0e:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e12:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e16:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e1a:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100e1b:	0f b7 05 86 6e 11 00 	movzwl 0x116e86,%eax
  100e22:	83 c0 01             	add    $0x1,%eax
  100e25:	0f b7 c0             	movzwl %ax,%eax
  100e28:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e2c:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e30:	89 c2                	mov    %eax,%edx
  100e32:	ec                   	in     (%dx),%al
  100e33:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e36:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e3a:	0f b6 c0             	movzbl %al,%eax
  100e3d:	c1 e0 08             	shl    $0x8,%eax
  100e40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e43:	0f b7 05 86 6e 11 00 	movzwl 0x116e86,%eax
  100e4a:	0f b7 c0             	movzwl %ax,%eax
  100e4d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100e51:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e55:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e59:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e5d:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100e5e:	0f b7 05 86 6e 11 00 	movzwl 0x116e86,%eax
  100e65:	83 c0 01             	add    $0x1,%eax
  100e68:	0f b7 c0             	movzwl %ax,%eax
  100e6b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e6f:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100e73:	89 c2                	mov    %eax,%edx
  100e75:	ec                   	in     (%dx),%al
  100e76:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100e79:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e7d:	0f b6 c0             	movzbl %al,%eax
  100e80:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100e83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e86:	a3 80 6e 11 00       	mov    %eax,0x116e80
    crt_pos = pos;
  100e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100e8e:	66 a3 84 6e 11 00    	mov    %ax,0x116e84
}
  100e94:	c9                   	leave  
  100e95:	c3                   	ret    

00100e96 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100e96:	55                   	push   %ebp
  100e97:	89 e5                	mov    %esp,%ebp
  100e99:	83 ec 48             	sub    $0x48,%esp
  100e9c:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100ea2:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ea6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100eaa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100eae:	ee                   	out    %al,(%dx)
  100eaf:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100eb5:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100eb9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ebd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ec1:	ee                   	out    %al,(%dx)
  100ec2:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100ec8:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100ecc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ed0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ed4:	ee                   	out    %al,(%dx)
  100ed5:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100edb:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100edf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ee3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ee7:	ee                   	out    %al,(%dx)
  100ee8:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100eee:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100ef2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ef6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100efa:	ee                   	out    %al,(%dx)
  100efb:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f01:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f05:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f09:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f0d:	ee                   	out    %al,(%dx)
  100f0e:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f14:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f18:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f1c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f20:	ee                   	out    %al,(%dx)
  100f21:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f27:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f2b:	89 c2                	mov    %eax,%edx
  100f2d:	ec                   	in     (%dx),%al
  100f2e:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f31:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f35:	3c ff                	cmp    $0xff,%al
  100f37:	0f 95 c0             	setne  %al
  100f3a:	0f b6 c0             	movzbl %al,%eax
  100f3d:	a3 88 6e 11 00       	mov    %eax,0x116e88
  100f42:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f48:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100f4c:	89 c2                	mov    %eax,%edx
  100f4e:	ec                   	in     (%dx),%al
  100f4f:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100f52:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100f58:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100f5c:	89 c2                	mov    %eax,%edx
  100f5e:	ec                   	in     (%dx),%al
  100f5f:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100f62:	a1 88 6e 11 00       	mov    0x116e88,%eax
  100f67:	85 c0                	test   %eax,%eax
  100f69:	74 0c                	je     100f77 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100f6b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100f72:	e8 d6 06 00 00       	call   10164d <pic_enable>
    }
}
  100f77:	c9                   	leave  
  100f78:	c3                   	ret    

00100f79 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100f79:	55                   	push   %ebp
  100f7a:	89 e5                	mov    %esp,%ebp
  100f7c:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100f86:	eb 09                	jmp    100f91 <lpt_putc_sub+0x18>
        delay();
  100f88:	e8 db fd ff ff       	call   100d68 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100f8d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100f91:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100f97:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100f9b:	89 c2                	mov    %eax,%edx
  100f9d:	ec                   	in     (%dx),%al
  100f9e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fa1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100fa5:	84 c0                	test   %al,%al
  100fa7:	78 09                	js     100fb2 <lpt_putc_sub+0x39>
  100fa9:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fb0:	7e d6                	jle    100f88 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100fb2:	8b 45 08             	mov    0x8(%ebp),%eax
  100fb5:	0f b6 c0             	movzbl %al,%eax
  100fb8:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  100fbe:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fc1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100fc5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100fc9:	ee                   	out    %al,(%dx)
  100fca:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  100fd0:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  100fd4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fd8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100fdc:	ee                   	out    %al,(%dx)
  100fdd:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  100fe3:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  100fe7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100feb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fef:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  100ff0:	c9                   	leave  
  100ff1:	c3                   	ret    

00100ff2 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  100ff2:	55                   	push   %ebp
  100ff3:	89 e5                	mov    %esp,%ebp
  100ff5:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  100ff8:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  100ffc:	74 0d                	je     10100b <lpt_putc+0x19>
        lpt_putc_sub(c);
  100ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  101001:	89 04 24             	mov    %eax,(%esp)
  101004:	e8 70 ff ff ff       	call   100f79 <lpt_putc_sub>
  101009:	eb 24                	jmp    10102f <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  10100b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101012:	e8 62 ff ff ff       	call   100f79 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101017:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10101e:	e8 56 ff ff ff       	call   100f79 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101023:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10102a:	e8 4a ff ff ff       	call   100f79 <lpt_putc_sub>
    }
}
  10102f:	c9                   	leave  
  101030:	c3                   	ret    

00101031 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101031:	55                   	push   %ebp
  101032:	89 e5                	mov    %esp,%ebp
  101034:	53                   	push   %ebx
  101035:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101038:	8b 45 08             	mov    0x8(%ebp),%eax
  10103b:	b0 00                	mov    $0x0,%al
  10103d:	85 c0                	test   %eax,%eax
  10103f:	75 07                	jne    101048 <cga_putc+0x17>
        c |= 0x0700;
  101041:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101048:	8b 45 08             	mov    0x8(%ebp),%eax
  10104b:	0f b6 c0             	movzbl %al,%eax
  10104e:	83 f8 0a             	cmp    $0xa,%eax
  101051:	74 4c                	je     10109f <cga_putc+0x6e>
  101053:	83 f8 0d             	cmp    $0xd,%eax
  101056:	74 57                	je     1010af <cga_putc+0x7e>
  101058:	83 f8 08             	cmp    $0x8,%eax
  10105b:	0f 85 88 00 00 00    	jne    1010e9 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101061:	0f b7 05 84 6e 11 00 	movzwl 0x116e84,%eax
  101068:	66 85 c0             	test   %ax,%ax
  10106b:	74 30                	je     10109d <cga_putc+0x6c>
            crt_pos --;
  10106d:	0f b7 05 84 6e 11 00 	movzwl 0x116e84,%eax
  101074:	83 e8 01             	sub    $0x1,%eax
  101077:	66 a3 84 6e 11 00    	mov    %ax,0x116e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10107d:	a1 80 6e 11 00       	mov    0x116e80,%eax
  101082:	0f b7 15 84 6e 11 00 	movzwl 0x116e84,%edx
  101089:	0f b7 d2             	movzwl %dx,%edx
  10108c:	01 d2                	add    %edx,%edx
  10108e:	01 c2                	add    %eax,%edx
  101090:	8b 45 08             	mov    0x8(%ebp),%eax
  101093:	b0 00                	mov    $0x0,%al
  101095:	83 c8 20             	or     $0x20,%eax
  101098:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10109b:	eb 72                	jmp    10110f <cga_putc+0xde>
  10109d:	eb 70                	jmp    10110f <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  10109f:	0f b7 05 84 6e 11 00 	movzwl 0x116e84,%eax
  1010a6:	83 c0 50             	add    $0x50,%eax
  1010a9:	66 a3 84 6e 11 00    	mov    %ax,0x116e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010af:	0f b7 1d 84 6e 11 00 	movzwl 0x116e84,%ebx
  1010b6:	0f b7 0d 84 6e 11 00 	movzwl 0x116e84,%ecx
  1010bd:	0f b7 c1             	movzwl %cx,%eax
  1010c0:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1010c6:	c1 e8 10             	shr    $0x10,%eax
  1010c9:	89 c2                	mov    %eax,%edx
  1010cb:	66 c1 ea 06          	shr    $0x6,%dx
  1010cf:	89 d0                	mov    %edx,%eax
  1010d1:	c1 e0 02             	shl    $0x2,%eax
  1010d4:	01 d0                	add    %edx,%eax
  1010d6:	c1 e0 04             	shl    $0x4,%eax
  1010d9:	29 c1                	sub    %eax,%ecx
  1010db:	89 ca                	mov    %ecx,%edx
  1010dd:	89 d8                	mov    %ebx,%eax
  1010df:	29 d0                	sub    %edx,%eax
  1010e1:	66 a3 84 6e 11 00    	mov    %ax,0x116e84
        break;
  1010e7:	eb 26                	jmp    10110f <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1010e9:	8b 0d 80 6e 11 00    	mov    0x116e80,%ecx
  1010ef:	0f b7 05 84 6e 11 00 	movzwl 0x116e84,%eax
  1010f6:	8d 50 01             	lea    0x1(%eax),%edx
  1010f9:	66 89 15 84 6e 11 00 	mov    %dx,0x116e84
  101100:	0f b7 c0             	movzwl %ax,%eax
  101103:	01 c0                	add    %eax,%eax
  101105:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101108:	8b 45 08             	mov    0x8(%ebp),%eax
  10110b:	66 89 02             	mov    %ax,(%edx)
        break;
  10110e:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10110f:	0f b7 05 84 6e 11 00 	movzwl 0x116e84,%eax
  101116:	66 3d cf 07          	cmp    $0x7cf,%ax
  10111a:	76 5b                	jbe    101177 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10111c:	a1 80 6e 11 00       	mov    0x116e80,%eax
  101121:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101127:	a1 80 6e 11 00       	mov    0x116e80,%eax
  10112c:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101133:	00 
  101134:	89 54 24 04          	mov    %edx,0x4(%esp)
  101138:	89 04 24             	mov    %eax,(%esp)
  10113b:	e8 13 49 00 00       	call   105a53 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101140:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101147:	eb 15                	jmp    10115e <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101149:	a1 80 6e 11 00       	mov    0x116e80,%eax
  10114e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101151:	01 d2                	add    %edx,%edx
  101153:	01 d0                	add    %edx,%eax
  101155:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10115a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10115e:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101165:	7e e2                	jle    101149 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101167:	0f b7 05 84 6e 11 00 	movzwl 0x116e84,%eax
  10116e:	83 e8 50             	sub    $0x50,%eax
  101171:	66 a3 84 6e 11 00    	mov    %ax,0x116e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101177:	0f b7 05 86 6e 11 00 	movzwl 0x116e86,%eax
  10117e:	0f b7 c0             	movzwl %ax,%eax
  101181:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101185:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  101189:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10118d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101191:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101192:	0f b7 05 84 6e 11 00 	movzwl 0x116e84,%eax
  101199:	66 c1 e8 08          	shr    $0x8,%ax
  10119d:	0f b6 c0             	movzbl %al,%eax
  1011a0:	0f b7 15 86 6e 11 00 	movzwl 0x116e86,%edx
  1011a7:	83 c2 01             	add    $0x1,%edx
  1011aa:	0f b7 d2             	movzwl %dx,%edx
  1011ad:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  1011b1:	88 45 ed             	mov    %al,-0x13(%ebp)
  1011b4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1011b8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1011bc:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011bd:	0f b7 05 86 6e 11 00 	movzwl 0x116e86,%eax
  1011c4:	0f b7 c0             	movzwl %ax,%eax
  1011c7:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  1011cb:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  1011cf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1011d3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1011d7:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1011d8:	0f b7 05 84 6e 11 00 	movzwl 0x116e84,%eax
  1011df:	0f b6 c0             	movzbl %al,%eax
  1011e2:	0f b7 15 86 6e 11 00 	movzwl 0x116e86,%edx
  1011e9:	83 c2 01             	add    $0x1,%edx
  1011ec:	0f b7 d2             	movzwl %dx,%edx
  1011ef:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1011f3:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1011f6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1011fa:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1011fe:	ee                   	out    %al,(%dx)
}
  1011ff:	83 c4 34             	add    $0x34,%esp
  101202:	5b                   	pop    %ebx
  101203:	5d                   	pop    %ebp
  101204:	c3                   	ret    

00101205 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101205:	55                   	push   %ebp
  101206:	89 e5                	mov    %esp,%ebp
  101208:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10120b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101212:	eb 09                	jmp    10121d <serial_putc_sub+0x18>
        delay();
  101214:	e8 4f fb ff ff       	call   100d68 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101219:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10121d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101223:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101227:	89 c2                	mov    %eax,%edx
  101229:	ec                   	in     (%dx),%al
  10122a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10122d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101231:	0f b6 c0             	movzbl %al,%eax
  101234:	83 e0 20             	and    $0x20,%eax
  101237:	85 c0                	test   %eax,%eax
  101239:	75 09                	jne    101244 <serial_putc_sub+0x3f>
  10123b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101242:	7e d0                	jle    101214 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101244:	8b 45 08             	mov    0x8(%ebp),%eax
  101247:	0f b6 c0             	movzbl %al,%eax
  10124a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101250:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101253:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101257:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10125b:	ee                   	out    %al,(%dx)
}
  10125c:	c9                   	leave  
  10125d:	c3                   	ret    

0010125e <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10125e:	55                   	push   %ebp
  10125f:	89 e5                	mov    %esp,%ebp
  101261:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101264:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101268:	74 0d                	je     101277 <serial_putc+0x19>
        serial_putc_sub(c);
  10126a:	8b 45 08             	mov    0x8(%ebp),%eax
  10126d:	89 04 24             	mov    %eax,(%esp)
  101270:	e8 90 ff ff ff       	call   101205 <serial_putc_sub>
  101275:	eb 24                	jmp    10129b <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101277:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10127e:	e8 82 ff ff ff       	call   101205 <serial_putc_sub>
        serial_putc_sub(' ');
  101283:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10128a:	e8 76 ff ff ff       	call   101205 <serial_putc_sub>
        serial_putc_sub('\b');
  10128f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101296:	e8 6a ff ff ff       	call   101205 <serial_putc_sub>
    }
}
  10129b:	c9                   	leave  
  10129c:	c3                   	ret    

0010129d <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10129d:	55                   	push   %ebp
  10129e:	89 e5                	mov    %esp,%ebp
  1012a0:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012a3:	eb 33                	jmp    1012d8 <cons_intr+0x3b>
        if (c != 0) {
  1012a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012a9:	74 2d                	je     1012d8 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012ab:	a1 a4 70 11 00       	mov    0x1170a4,%eax
  1012b0:	8d 50 01             	lea    0x1(%eax),%edx
  1012b3:	89 15 a4 70 11 00    	mov    %edx,0x1170a4
  1012b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012bc:	88 90 a0 6e 11 00    	mov    %dl,0x116ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012c2:	a1 a4 70 11 00       	mov    0x1170a4,%eax
  1012c7:	3d 00 02 00 00       	cmp    $0x200,%eax
  1012cc:	75 0a                	jne    1012d8 <cons_intr+0x3b>
                cons.wpos = 0;
  1012ce:	c7 05 a4 70 11 00 00 	movl   $0x0,0x1170a4
  1012d5:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  1012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  1012db:	ff d0                	call   *%eax
  1012dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1012e0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1012e4:	75 bf                	jne    1012a5 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1012e6:	c9                   	leave  
  1012e7:	c3                   	ret    

001012e8 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1012e8:	55                   	push   %ebp
  1012e9:	89 e5                	mov    %esp,%ebp
  1012eb:	83 ec 10             	sub    $0x10,%esp
  1012ee:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012f4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012f8:	89 c2                	mov    %eax,%edx
  1012fa:	ec                   	in     (%dx),%al
  1012fb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012fe:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101302:	0f b6 c0             	movzbl %al,%eax
  101305:	83 e0 01             	and    $0x1,%eax
  101308:	85 c0                	test   %eax,%eax
  10130a:	75 07                	jne    101313 <serial_proc_data+0x2b>
        return -1;
  10130c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101311:	eb 2a                	jmp    10133d <serial_proc_data+0x55>
  101313:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101319:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10131d:	89 c2                	mov    %eax,%edx
  10131f:	ec                   	in     (%dx),%al
  101320:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101323:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101327:	0f b6 c0             	movzbl %al,%eax
  10132a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10132d:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101331:	75 07                	jne    10133a <serial_proc_data+0x52>
        c = '\b';
  101333:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10133a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10133d:	c9                   	leave  
  10133e:	c3                   	ret    

0010133f <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  10133f:	55                   	push   %ebp
  101340:	89 e5                	mov    %esp,%ebp
  101342:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101345:	a1 88 6e 11 00       	mov    0x116e88,%eax
  10134a:	85 c0                	test   %eax,%eax
  10134c:	74 0c                	je     10135a <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10134e:	c7 04 24 e8 12 10 00 	movl   $0x1012e8,(%esp)
  101355:	e8 43 ff ff ff       	call   10129d <cons_intr>
    }
}
  10135a:	c9                   	leave  
  10135b:	c3                   	ret    

0010135c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10135c:	55                   	push   %ebp
  10135d:	89 e5                	mov    %esp,%ebp
  10135f:	83 ec 38             	sub    $0x38,%esp
  101362:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101368:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10136c:	89 c2                	mov    %eax,%edx
  10136e:	ec                   	in     (%dx),%al
  10136f:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101372:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101376:	0f b6 c0             	movzbl %al,%eax
  101379:	83 e0 01             	and    $0x1,%eax
  10137c:	85 c0                	test   %eax,%eax
  10137e:	75 0a                	jne    10138a <kbd_proc_data+0x2e>
        return -1;
  101380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101385:	e9 59 01 00 00       	jmp    1014e3 <kbd_proc_data+0x187>
  10138a:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101390:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101394:	89 c2                	mov    %eax,%edx
  101396:	ec                   	in     (%dx),%al
  101397:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10139a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10139e:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013a1:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013a5:	75 17                	jne    1013be <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013a7:	a1 a8 70 11 00       	mov    0x1170a8,%eax
  1013ac:	83 c8 40             	or     $0x40,%eax
  1013af:	a3 a8 70 11 00       	mov    %eax,0x1170a8
        return 0;
  1013b4:	b8 00 00 00 00       	mov    $0x0,%eax
  1013b9:	e9 25 01 00 00       	jmp    1014e3 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  1013be:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013c2:	84 c0                	test   %al,%al
  1013c4:	79 47                	jns    10140d <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1013c6:	a1 a8 70 11 00       	mov    0x1170a8,%eax
  1013cb:	83 e0 40             	and    $0x40,%eax
  1013ce:	85 c0                	test   %eax,%eax
  1013d0:	75 09                	jne    1013db <kbd_proc_data+0x7f>
  1013d2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013d6:	83 e0 7f             	and    $0x7f,%eax
  1013d9:	eb 04                	jmp    1013df <kbd_proc_data+0x83>
  1013db:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013df:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1013e2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013e6:	0f b6 80 60 60 11 00 	movzbl 0x116060(%eax),%eax
  1013ed:	83 c8 40             	or     $0x40,%eax
  1013f0:	0f b6 c0             	movzbl %al,%eax
  1013f3:	f7 d0                	not    %eax
  1013f5:	89 c2                	mov    %eax,%edx
  1013f7:	a1 a8 70 11 00       	mov    0x1170a8,%eax
  1013fc:	21 d0                	and    %edx,%eax
  1013fe:	a3 a8 70 11 00       	mov    %eax,0x1170a8
        return 0;
  101403:	b8 00 00 00 00       	mov    $0x0,%eax
  101408:	e9 d6 00 00 00       	jmp    1014e3 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  10140d:	a1 a8 70 11 00       	mov    0x1170a8,%eax
  101412:	83 e0 40             	and    $0x40,%eax
  101415:	85 c0                	test   %eax,%eax
  101417:	74 11                	je     10142a <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101419:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  10141d:	a1 a8 70 11 00       	mov    0x1170a8,%eax
  101422:	83 e0 bf             	and    $0xffffffbf,%eax
  101425:	a3 a8 70 11 00       	mov    %eax,0x1170a8
    }

    shift |= shiftcode[data];
  10142a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10142e:	0f b6 80 60 60 11 00 	movzbl 0x116060(%eax),%eax
  101435:	0f b6 d0             	movzbl %al,%edx
  101438:	a1 a8 70 11 00       	mov    0x1170a8,%eax
  10143d:	09 d0                	or     %edx,%eax
  10143f:	a3 a8 70 11 00       	mov    %eax,0x1170a8
    shift ^= togglecode[data];
  101444:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101448:	0f b6 80 60 61 11 00 	movzbl 0x116160(%eax),%eax
  10144f:	0f b6 d0             	movzbl %al,%edx
  101452:	a1 a8 70 11 00       	mov    0x1170a8,%eax
  101457:	31 d0                	xor    %edx,%eax
  101459:	a3 a8 70 11 00       	mov    %eax,0x1170a8

    c = charcode[shift & (CTL | SHIFT)][data];
  10145e:	a1 a8 70 11 00       	mov    0x1170a8,%eax
  101463:	83 e0 03             	and    $0x3,%eax
  101466:	8b 14 85 60 65 11 00 	mov    0x116560(,%eax,4),%edx
  10146d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101471:	01 d0                	add    %edx,%eax
  101473:	0f b6 00             	movzbl (%eax),%eax
  101476:	0f b6 c0             	movzbl %al,%eax
  101479:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10147c:	a1 a8 70 11 00       	mov    0x1170a8,%eax
  101481:	83 e0 08             	and    $0x8,%eax
  101484:	85 c0                	test   %eax,%eax
  101486:	74 22                	je     1014aa <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101488:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10148c:	7e 0c                	jle    10149a <kbd_proc_data+0x13e>
  10148e:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101492:	7f 06                	jg     10149a <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101494:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101498:	eb 10                	jmp    1014aa <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10149a:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10149e:	7e 0a                	jle    1014aa <kbd_proc_data+0x14e>
  1014a0:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014a4:	7f 04                	jg     1014aa <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014a6:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014aa:	a1 a8 70 11 00       	mov    0x1170a8,%eax
  1014af:	f7 d0                	not    %eax
  1014b1:	83 e0 06             	and    $0x6,%eax
  1014b4:	85 c0                	test   %eax,%eax
  1014b6:	75 28                	jne    1014e0 <kbd_proc_data+0x184>
  1014b8:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1014bf:	75 1f                	jne    1014e0 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  1014c1:	c7 04 24 95 5e 10 00 	movl   $0x105e95,(%esp)
  1014c8:	e8 6f ee ff ff       	call   10033c <cprintf>
  1014cd:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  1014d3:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1014d7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  1014db:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1014df:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1014e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1014e3:	c9                   	leave  
  1014e4:	c3                   	ret    

001014e5 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1014e5:	55                   	push   %ebp
  1014e6:	89 e5                	mov    %esp,%ebp
  1014e8:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1014eb:	c7 04 24 5c 13 10 00 	movl   $0x10135c,(%esp)
  1014f2:	e8 a6 fd ff ff       	call   10129d <cons_intr>
}
  1014f7:	c9                   	leave  
  1014f8:	c3                   	ret    

001014f9 <kbd_init>:

static void
kbd_init(void) {
  1014f9:	55                   	push   %ebp
  1014fa:	89 e5                	mov    %esp,%ebp
  1014fc:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1014ff:	e8 e1 ff ff ff       	call   1014e5 <kbd_intr>
    pic_enable(IRQ_KBD);
  101504:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10150b:	e8 3d 01 00 00       	call   10164d <pic_enable>
}
  101510:	c9                   	leave  
  101511:	c3                   	ret    

00101512 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101512:	55                   	push   %ebp
  101513:	89 e5                	mov    %esp,%ebp
  101515:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101518:	e8 93 f8 ff ff       	call   100db0 <cga_init>
    serial_init();
  10151d:	e8 74 f9 ff ff       	call   100e96 <serial_init>
    kbd_init();
  101522:	e8 d2 ff ff ff       	call   1014f9 <kbd_init>
    if (!serial_exists) {
  101527:	a1 88 6e 11 00       	mov    0x116e88,%eax
  10152c:	85 c0                	test   %eax,%eax
  10152e:	75 0c                	jne    10153c <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101530:	c7 04 24 a1 5e 10 00 	movl   $0x105ea1,(%esp)
  101537:	e8 00 ee ff ff       	call   10033c <cprintf>
    }
}
  10153c:	c9                   	leave  
  10153d:	c3                   	ret    

0010153e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  10153e:	55                   	push   %ebp
  10153f:	89 e5                	mov    %esp,%ebp
  101541:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101544:	e8 e2 f7 ff ff       	call   100d2b <__intr_save>
  101549:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10154c:	8b 45 08             	mov    0x8(%ebp),%eax
  10154f:	89 04 24             	mov    %eax,(%esp)
  101552:	e8 9b fa ff ff       	call   100ff2 <lpt_putc>
        cga_putc(c);
  101557:	8b 45 08             	mov    0x8(%ebp),%eax
  10155a:	89 04 24             	mov    %eax,(%esp)
  10155d:	e8 cf fa ff ff       	call   101031 <cga_putc>
        serial_putc(c);
  101562:	8b 45 08             	mov    0x8(%ebp),%eax
  101565:	89 04 24             	mov    %eax,(%esp)
  101568:	e8 f1 fc ff ff       	call   10125e <serial_putc>
    }
    local_intr_restore(intr_flag);
  10156d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101570:	89 04 24             	mov    %eax,(%esp)
  101573:	e8 dd f7 ff ff       	call   100d55 <__intr_restore>
}
  101578:	c9                   	leave  
  101579:	c3                   	ret    

0010157a <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10157a:	55                   	push   %ebp
  10157b:	89 e5                	mov    %esp,%ebp
  10157d:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101580:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101587:	e8 9f f7 ff ff       	call   100d2b <__intr_save>
  10158c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10158f:	e8 ab fd ff ff       	call   10133f <serial_intr>
        kbd_intr();
  101594:	e8 4c ff ff ff       	call   1014e5 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101599:	8b 15 a0 70 11 00    	mov    0x1170a0,%edx
  10159f:	a1 a4 70 11 00       	mov    0x1170a4,%eax
  1015a4:	39 c2                	cmp    %eax,%edx
  1015a6:	74 31                	je     1015d9 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  1015a8:	a1 a0 70 11 00       	mov    0x1170a0,%eax
  1015ad:	8d 50 01             	lea    0x1(%eax),%edx
  1015b0:	89 15 a0 70 11 00    	mov    %edx,0x1170a0
  1015b6:	0f b6 80 a0 6e 11 00 	movzbl 0x116ea0(%eax),%eax
  1015bd:	0f b6 c0             	movzbl %al,%eax
  1015c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  1015c3:	a1 a0 70 11 00       	mov    0x1170a0,%eax
  1015c8:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015cd:	75 0a                	jne    1015d9 <cons_getc+0x5f>
                cons.rpos = 0;
  1015cf:	c7 05 a0 70 11 00 00 	movl   $0x0,0x1170a0
  1015d6:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  1015d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1015dc:	89 04 24             	mov    %eax,(%esp)
  1015df:	e8 71 f7 ff ff       	call   100d55 <__intr_restore>
    return c;
  1015e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015e7:	c9                   	leave  
  1015e8:	c3                   	ret    

001015e9 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1015e9:	55                   	push   %ebp
  1015ea:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1015ec:	fb                   	sti    
    sti();
}
  1015ed:	5d                   	pop    %ebp
  1015ee:	c3                   	ret    

001015ef <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1015ef:	55                   	push   %ebp
  1015f0:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1015f2:	fa                   	cli    
    cli();
}
  1015f3:	5d                   	pop    %ebp
  1015f4:	c3                   	ret    

001015f5 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1015f5:	55                   	push   %ebp
  1015f6:	89 e5                	mov    %esp,%ebp
  1015f8:	83 ec 14             	sub    $0x14,%esp
  1015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1015fe:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101602:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101606:	66 a3 70 65 11 00    	mov    %ax,0x116570
    if (did_init) {
  10160c:	a1 ac 70 11 00       	mov    0x1170ac,%eax
  101611:	85 c0                	test   %eax,%eax
  101613:	74 36                	je     10164b <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101615:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101619:	0f b6 c0             	movzbl %al,%eax
  10161c:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101622:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101625:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101629:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10162d:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  10162e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101632:	66 c1 e8 08          	shr    $0x8,%ax
  101636:	0f b6 c0             	movzbl %al,%eax
  101639:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10163f:	88 45 f9             	mov    %al,-0x7(%ebp)
  101642:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101646:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10164a:	ee                   	out    %al,(%dx)
    }
}
  10164b:	c9                   	leave  
  10164c:	c3                   	ret    

0010164d <pic_enable>:

void
pic_enable(unsigned int irq) {
  10164d:	55                   	push   %ebp
  10164e:	89 e5                	mov    %esp,%ebp
  101650:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101653:	8b 45 08             	mov    0x8(%ebp),%eax
  101656:	ba 01 00 00 00       	mov    $0x1,%edx
  10165b:	89 c1                	mov    %eax,%ecx
  10165d:	d3 e2                	shl    %cl,%edx
  10165f:	89 d0                	mov    %edx,%eax
  101661:	f7 d0                	not    %eax
  101663:	89 c2                	mov    %eax,%edx
  101665:	0f b7 05 70 65 11 00 	movzwl 0x116570,%eax
  10166c:	21 d0                	and    %edx,%eax
  10166e:	0f b7 c0             	movzwl %ax,%eax
  101671:	89 04 24             	mov    %eax,(%esp)
  101674:	e8 7c ff ff ff       	call   1015f5 <pic_setmask>
}
  101679:	c9                   	leave  
  10167a:	c3                   	ret    

0010167b <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10167b:	55                   	push   %ebp
  10167c:	89 e5                	mov    %esp,%ebp
  10167e:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101681:	c7 05 ac 70 11 00 01 	movl   $0x1,0x1170ac
  101688:	00 00 00 
  10168b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101691:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101695:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101699:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10169d:	ee                   	out    %al,(%dx)
  10169e:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016a4:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016a8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016ac:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016b0:	ee                   	out    %al,(%dx)
  1016b1:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016b7:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016bb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016bf:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016c3:	ee                   	out    %al,(%dx)
  1016c4:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1016ca:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1016ce:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1016d2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1016d6:	ee                   	out    %al,(%dx)
  1016d7:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1016dd:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1016e1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1016e5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1016e9:	ee                   	out    %al,(%dx)
  1016ea:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1016f0:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1016f4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1016f8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1016fc:	ee                   	out    %al,(%dx)
  1016fd:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101703:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101707:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10170b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10170f:	ee                   	out    %al,(%dx)
  101710:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101716:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  10171a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10171e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101722:	ee                   	out    %al,(%dx)
  101723:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  101729:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10172d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101731:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101735:	ee                   	out    %al,(%dx)
  101736:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10173c:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101740:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101744:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101748:	ee                   	out    %al,(%dx)
  101749:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  10174f:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101753:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101757:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10175b:	ee                   	out    %al,(%dx)
  10175c:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101762:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101766:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10176a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10176e:	ee                   	out    %al,(%dx)
  10176f:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101775:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  101779:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10177d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101781:	ee                   	out    %al,(%dx)
  101782:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101788:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  10178c:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101790:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101794:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101795:	0f b7 05 70 65 11 00 	movzwl 0x116570,%eax
  10179c:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017a0:	74 12                	je     1017b4 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017a2:	0f b7 05 70 65 11 00 	movzwl 0x116570,%eax
  1017a9:	0f b7 c0             	movzwl %ax,%eax
  1017ac:	89 04 24             	mov    %eax,(%esp)
  1017af:	e8 41 fe ff ff       	call   1015f5 <pic_setmask>
    }
}
  1017b4:	c9                   	leave  
  1017b5:	c3                   	ret    

001017b6 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017b6:	55                   	push   %ebp
  1017b7:	89 e5                	mov    %esp,%ebp
  1017b9:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017bc:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017c3:	00 
  1017c4:	c7 04 24 c0 5e 10 00 	movl   $0x105ec0,(%esp)
  1017cb:	e8 6c eb ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1017d0:	c9                   	leave  
  1017d1:	c3                   	ret    

001017d2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1017d2:	55                   	push   %ebp
  1017d3:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
  1017d5:	5d                   	pop    %ebp
  1017d6:	c3                   	ret    

001017d7 <trapname>:

static const char *
trapname(int trapno) {
  1017d7:	55                   	push   %ebp
  1017d8:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1017da:	8b 45 08             	mov    0x8(%ebp),%eax
  1017dd:	83 f8 13             	cmp    $0x13,%eax
  1017e0:	77 0c                	ja     1017ee <trapname+0x17>
        return excnames[trapno];
  1017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1017e5:	8b 04 85 20 62 10 00 	mov    0x106220(,%eax,4),%eax
  1017ec:	eb 18                	jmp    101806 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1017ee:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1017f2:	7e 0d                	jle    101801 <trapname+0x2a>
  1017f4:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1017f8:	7f 07                	jg     101801 <trapname+0x2a>
        return "Hardware Interrupt";
  1017fa:	b8 ca 5e 10 00       	mov    $0x105eca,%eax
  1017ff:	eb 05                	jmp    101806 <trapname+0x2f>
    }
    return "(unknown trap)";
  101801:	b8 dd 5e 10 00       	mov    $0x105edd,%eax
}
  101806:	5d                   	pop    %ebp
  101807:	c3                   	ret    

00101808 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101808:	55                   	push   %ebp
  101809:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  10180b:	8b 45 08             	mov    0x8(%ebp),%eax
  10180e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101812:	66 83 f8 08          	cmp    $0x8,%ax
  101816:	0f 94 c0             	sete   %al
  101819:	0f b6 c0             	movzbl %al,%eax
}
  10181c:	5d                   	pop    %ebp
  10181d:	c3                   	ret    

0010181e <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  10181e:	55                   	push   %ebp
  10181f:	89 e5                	mov    %esp,%ebp
  101821:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101824:	8b 45 08             	mov    0x8(%ebp),%eax
  101827:	89 44 24 04          	mov    %eax,0x4(%esp)
  10182b:	c7 04 24 1e 5f 10 00 	movl   $0x105f1e,(%esp)
  101832:	e8 05 eb ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101837:	8b 45 08             	mov    0x8(%ebp),%eax
  10183a:	89 04 24             	mov    %eax,(%esp)
  10183d:	e8 a1 01 00 00       	call   1019e3 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101842:	8b 45 08             	mov    0x8(%ebp),%eax
  101845:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101849:	0f b7 c0             	movzwl %ax,%eax
  10184c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101850:	c7 04 24 2f 5f 10 00 	movl   $0x105f2f,(%esp)
  101857:	e8 e0 ea ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  10185c:	8b 45 08             	mov    0x8(%ebp),%eax
  10185f:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101863:	0f b7 c0             	movzwl %ax,%eax
  101866:	89 44 24 04          	mov    %eax,0x4(%esp)
  10186a:	c7 04 24 42 5f 10 00 	movl   $0x105f42,(%esp)
  101871:	e8 c6 ea ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101876:	8b 45 08             	mov    0x8(%ebp),%eax
  101879:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  10187d:	0f b7 c0             	movzwl %ax,%eax
  101880:	89 44 24 04          	mov    %eax,0x4(%esp)
  101884:	c7 04 24 55 5f 10 00 	movl   $0x105f55,(%esp)
  10188b:	e8 ac ea ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101890:	8b 45 08             	mov    0x8(%ebp),%eax
  101893:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101897:	0f b7 c0             	movzwl %ax,%eax
  10189a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10189e:	c7 04 24 68 5f 10 00 	movl   $0x105f68,(%esp)
  1018a5:	e8 92 ea ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  1018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1018ad:	8b 40 30             	mov    0x30(%eax),%eax
  1018b0:	89 04 24             	mov    %eax,(%esp)
  1018b3:	e8 1f ff ff ff       	call   1017d7 <trapname>
  1018b8:	8b 55 08             	mov    0x8(%ebp),%edx
  1018bb:	8b 52 30             	mov    0x30(%edx),%edx
  1018be:	89 44 24 08          	mov    %eax,0x8(%esp)
  1018c2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1018c6:	c7 04 24 7b 5f 10 00 	movl   $0x105f7b,(%esp)
  1018cd:	e8 6a ea ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  1018d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1018d5:	8b 40 34             	mov    0x34(%eax),%eax
  1018d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018dc:	c7 04 24 8d 5f 10 00 	movl   $0x105f8d,(%esp)
  1018e3:	e8 54 ea ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  1018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1018eb:	8b 40 38             	mov    0x38(%eax),%eax
  1018ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1018f2:	c7 04 24 9c 5f 10 00 	movl   $0x105f9c,(%esp)
  1018f9:	e8 3e ea ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  1018fe:	8b 45 08             	mov    0x8(%ebp),%eax
  101901:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101905:	0f b7 c0             	movzwl %ax,%eax
  101908:	89 44 24 04          	mov    %eax,0x4(%esp)
  10190c:	c7 04 24 ab 5f 10 00 	movl   $0x105fab,(%esp)
  101913:	e8 24 ea ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101918:	8b 45 08             	mov    0x8(%ebp),%eax
  10191b:	8b 40 40             	mov    0x40(%eax),%eax
  10191e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101922:	c7 04 24 be 5f 10 00 	movl   $0x105fbe,(%esp)
  101929:	e8 0e ea ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  10192e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101935:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  10193c:	eb 3e                	jmp    10197c <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  10193e:	8b 45 08             	mov    0x8(%ebp),%eax
  101941:	8b 50 40             	mov    0x40(%eax),%edx
  101944:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101947:	21 d0                	and    %edx,%eax
  101949:	85 c0                	test   %eax,%eax
  10194b:	74 28                	je     101975 <print_trapframe+0x157>
  10194d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101950:	8b 04 85 a0 65 11 00 	mov    0x1165a0(,%eax,4),%eax
  101957:	85 c0                	test   %eax,%eax
  101959:	74 1a                	je     101975 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  10195b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10195e:	8b 04 85 a0 65 11 00 	mov    0x1165a0(,%eax,4),%eax
  101965:	89 44 24 04          	mov    %eax,0x4(%esp)
  101969:	c7 04 24 cd 5f 10 00 	movl   $0x105fcd,(%esp)
  101970:	e8 c7 e9 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101975:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101979:	d1 65 f0             	shll   -0x10(%ebp)
  10197c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10197f:	83 f8 17             	cmp    $0x17,%eax
  101982:	76 ba                	jbe    10193e <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101984:	8b 45 08             	mov    0x8(%ebp),%eax
  101987:	8b 40 40             	mov    0x40(%eax),%eax
  10198a:	25 00 30 00 00       	and    $0x3000,%eax
  10198f:	c1 e8 0c             	shr    $0xc,%eax
  101992:	89 44 24 04          	mov    %eax,0x4(%esp)
  101996:	c7 04 24 d1 5f 10 00 	movl   $0x105fd1,(%esp)
  10199d:	e8 9a e9 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  1019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019a5:	89 04 24             	mov    %eax,(%esp)
  1019a8:	e8 5b fe ff ff       	call   101808 <trap_in_kernel>
  1019ad:	85 c0                	test   %eax,%eax
  1019af:	75 30                	jne    1019e1 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  1019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b4:	8b 40 44             	mov    0x44(%eax),%eax
  1019b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019bb:	c7 04 24 da 5f 10 00 	movl   $0x105fda,(%esp)
  1019c2:	e8 75 e9 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  1019c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ca:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  1019ce:	0f b7 c0             	movzwl %ax,%eax
  1019d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019d5:	c7 04 24 e9 5f 10 00 	movl   $0x105fe9,(%esp)
  1019dc:	e8 5b e9 ff ff       	call   10033c <cprintf>
    }
}
  1019e1:	c9                   	leave  
  1019e2:	c3                   	ret    

001019e3 <print_regs>:

void
print_regs(struct pushregs *regs) {
  1019e3:	55                   	push   %ebp
  1019e4:	89 e5                	mov    %esp,%ebp
  1019e6:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  1019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ec:	8b 00                	mov    (%eax),%eax
  1019ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019f2:	c7 04 24 fc 5f 10 00 	movl   $0x105ffc,(%esp)
  1019f9:	e8 3e e9 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  1019fe:	8b 45 08             	mov    0x8(%ebp),%eax
  101a01:	8b 40 04             	mov    0x4(%eax),%eax
  101a04:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a08:	c7 04 24 0b 60 10 00 	movl   $0x10600b,(%esp)
  101a0f:	e8 28 e9 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101a14:	8b 45 08             	mov    0x8(%ebp),%eax
  101a17:	8b 40 08             	mov    0x8(%eax),%eax
  101a1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a1e:	c7 04 24 1a 60 10 00 	movl   $0x10601a,(%esp)
  101a25:	e8 12 e9 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2d:	8b 40 0c             	mov    0xc(%eax),%eax
  101a30:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a34:	c7 04 24 29 60 10 00 	movl   $0x106029,(%esp)
  101a3b:	e8 fc e8 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101a40:	8b 45 08             	mov    0x8(%ebp),%eax
  101a43:	8b 40 10             	mov    0x10(%eax),%eax
  101a46:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a4a:	c7 04 24 38 60 10 00 	movl   $0x106038,(%esp)
  101a51:	e8 e6 e8 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101a56:	8b 45 08             	mov    0x8(%ebp),%eax
  101a59:	8b 40 14             	mov    0x14(%eax),%eax
  101a5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a60:	c7 04 24 47 60 10 00 	movl   $0x106047,(%esp)
  101a67:	e8 d0 e8 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6f:	8b 40 18             	mov    0x18(%eax),%eax
  101a72:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a76:	c7 04 24 56 60 10 00 	movl   $0x106056,(%esp)
  101a7d:	e8 ba e8 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101a82:	8b 45 08             	mov    0x8(%ebp),%eax
  101a85:	8b 40 1c             	mov    0x1c(%eax),%eax
  101a88:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a8c:	c7 04 24 65 60 10 00 	movl   $0x106065,(%esp)
  101a93:	e8 a4 e8 ff ff       	call   10033c <cprintf>
}
  101a98:	c9                   	leave  
  101a99:	c3                   	ret    

00101a9a <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101a9a:	55                   	push   %ebp
  101a9b:	89 e5                	mov    %esp,%ebp
  101a9d:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa3:	8b 40 30             	mov    0x30(%eax),%eax
  101aa6:	83 f8 2f             	cmp    $0x2f,%eax
  101aa9:	77 1e                	ja     101ac9 <trap_dispatch+0x2f>
  101aab:	83 f8 2e             	cmp    $0x2e,%eax
  101aae:	0f 83 bf 00 00 00    	jae    101b73 <trap_dispatch+0xd9>
  101ab4:	83 f8 21             	cmp    $0x21,%eax
  101ab7:	74 40                	je     101af9 <trap_dispatch+0x5f>
  101ab9:	83 f8 24             	cmp    $0x24,%eax
  101abc:	74 15                	je     101ad3 <trap_dispatch+0x39>
  101abe:	83 f8 20             	cmp    $0x20,%eax
  101ac1:	0f 84 af 00 00 00    	je     101b76 <trap_dispatch+0xdc>
  101ac7:	eb 72                	jmp    101b3b <trap_dispatch+0xa1>
  101ac9:	83 e8 78             	sub    $0x78,%eax
  101acc:	83 f8 01             	cmp    $0x1,%eax
  101acf:	77 6a                	ja     101b3b <trap_dispatch+0xa1>
  101ad1:	eb 4c                	jmp    101b1f <trap_dispatch+0x85>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101ad3:	e8 a2 fa ff ff       	call   10157a <cons_getc>
  101ad8:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101adb:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101adf:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ae3:	89 54 24 08          	mov    %edx,0x8(%esp)
  101ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aeb:	c7 04 24 74 60 10 00 	movl   $0x106074,(%esp)
  101af2:	e8 45 e8 ff ff       	call   10033c <cprintf>
        break;
  101af7:	eb 7e                	jmp    101b77 <trap_dispatch+0xdd>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101af9:	e8 7c fa ff ff       	call   10157a <cons_getc>
  101afe:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101b01:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101b05:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101b09:	89 54 24 08          	mov    %edx,0x8(%esp)
  101b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b11:	c7 04 24 86 60 10 00 	movl   $0x106086,(%esp)
  101b18:	e8 1f e8 ff ff       	call   10033c <cprintf>
        break;
  101b1d:	eb 58                	jmp    101b77 <trap_dispatch+0xdd>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101b1f:	c7 44 24 08 95 60 10 	movl   $0x106095,0x8(%esp)
  101b26:	00 
  101b27:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
  101b2e:	00 
  101b2f:	c7 04 24 a5 60 10 00 	movl   $0x1060a5,(%esp)
  101b36:	e8 d1 f0 ff ff       	call   100c0c <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b3e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b42:	0f b7 c0             	movzwl %ax,%eax
  101b45:	83 e0 03             	and    $0x3,%eax
  101b48:	85 c0                	test   %eax,%eax
  101b4a:	75 2b                	jne    101b77 <trap_dispatch+0xdd>
            print_trapframe(tf);
  101b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4f:	89 04 24             	mov    %eax,(%esp)
  101b52:	e8 c7 fc ff ff       	call   10181e <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101b57:	c7 44 24 08 b6 60 10 	movl   $0x1060b6,0x8(%esp)
  101b5e:	00 
  101b5f:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  101b66:	00 
  101b67:	c7 04 24 a5 60 10 00 	movl   $0x1060a5,(%esp)
  101b6e:	e8 99 f0 ff ff       	call   100c0c <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101b73:	90                   	nop
  101b74:	eb 01                	jmp    101b77 <trap_dispatch+0xdd>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
  101b76:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101b77:	c9                   	leave  
  101b78:	c3                   	ret    

00101b79 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101b79:	55                   	push   %ebp
  101b7a:	89 e5                	mov    %esp,%ebp
  101b7c:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b82:	89 04 24             	mov    %eax,(%esp)
  101b85:	e8 10 ff ff ff       	call   101a9a <trap_dispatch>
}
  101b8a:	c9                   	leave  
  101b8b:	c3                   	ret    

00101b8c <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101b8c:	1e                   	push   %ds
    pushl %es
  101b8d:	06                   	push   %es
    pushl %fs
  101b8e:	0f a0                	push   %fs
    pushl %gs
  101b90:	0f a8                	push   %gs
    pushal
  101b92:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101b93:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101b98:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101b9a:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101b9c:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101b9d:	e8 d7 ff ff ff       	call   101b79 <trap>

    # pop the pushed stack pointer
    popl %esp
  101ba2:	5c                   	pop    %esp

00101ba3 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101ba3:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101ba4:	0f a9                	pop    %gs
    popl %fs
  101ba6:	0f a1                	pop    %fs
    popl %es
  101ba8:	07                   	pop    %es
    popl %ds
  101ba9:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101baa:	83 c4 08             	add    $0x8,%esp
    iret
  101bad:	cf                   	iret   

00101bae <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101bae:	6a 00                	push   $0x0
  pushl $0
  101bb0:	6a 00                	push   $0x0
  jmp __alltraps
  101bb2:	e9 d5 ff ff ff       	jmp    101b8c <__alltraps>

00101bb7 <vector1>:
.globl vector1
vector1:
  pushl $0
  101bb7:	6a 00                	push   $0x0
  pushl $1
  101bb9:	6a 01                	push   $0x1
  jmp __alltraps
  101bbb:	e9 cc ff ff ff       	jmp    101b8c <__alltraps>

00101bc0 <vector2>:
.globl vector2
vector2:
  pushl $0
  101bc0:	6a 00                	push   $0x0
  pushl $2
  101bc2:	6a 02                	push   $0x2
  jmp __alltraps
  101bc4:	e9 c3 ff ff ff       	jmp    101b8c <__alltraps>

00101bc9 <vector3>:
.globl vector3
vector3:
  pushl $0
  101bc9:	6a 00                	push   $0x0
  pushl $3
  101bcb:	6a 03                	push   $0x3
  jmp __alltraps
  101bcd:	e9 ba ff ff ff       	jmp    101b8c <__alltraps>

00101bd2 <vector4>:
.globl vector4
vector4:
  pushl $0
  101bd2:	6a 00                	push   $0x0
  pushl $4
  101bd4:	6a 04                	push   $0x4
  jmp __alltraps
  101bd6:	e9 b1 ff ff ff       	jmp    101b8c <__alltraps>

00101bdb <vector5>:
.globl vector5
vector5:
  pushl $0
  101bdb:	6a 00                	push   $0x0
  pushl $5
  101bdd:	6a 05                	push   $0x5
  jmp __alltraps
  101bdf:	e9 a8 ff ff ff       	jmp    101b8c <__alltraps>

00101be4 <vector6>:
.globl vector6
vector6:
  pushl $0
  101be4:	6a 00                	push   $0x0
  pushl $6
  101be6:	6a 06                	push   $0x6
  jmp __alltraps
  101be8:	e9 9f ff ff ff       	jmp    101b8c <__alltraps>

00101bed <vector7>:
.globl vector7
vector7:
  pushl $0
  101bed:	6a 00                	push   $0x0
  pushl $7
  101bef:	6a 07                	push   $0x7
  jmp __alltraps
  101bf1:	e9 96 ff ff ff       	jmp    101b8c <__alltraps>

00101bf6 <vector8>:
.globl vector8
vector8:
  pushl $8
  101bf6:	6a 08                	push   $0x8
  jmp __alltraps
  101bf8:	e9 8f ff ff ff       	jmp    101b8c <__alltraps>

00101bfd <vector9>:
.globl vector9
vector9:
  pushl $9
  101bfd:	6a 09                	push   $0x9
  jmp __alltraps
  101bff:	e9 88 ff ff ff       	jmp    101b8c <__alltraps>

00101c04 <vector10>:
.globl vector10
vector10:
  pushl $10
  101c04:	6a 0a                	push   $0xa
  jmp __alltraps
  101c06:	e9 81 ff ff ff       	jmp    101b8c <__alltraps>

00101c0b <vector11>:
.globl vector11
vector11:
  pushl $11
  101c0b:	6a 0b                	push   $0xb
  jmp __alltraps
  101c0d:	e9 7a ff ff ff       	jmp    101b8c <__alltraps>

00101c12 <vector12>:
.globl vector12
vector12:
  pushl $12
  101c12:	6a 0c                	push   $0xc
  jmp __alltraps
  101c14:	e9 73 ff ff ff       	jmp    101b8c <__alltraps>

00101c19 <vector13>:
.globl vector13
vector13:
  pushl $13
  101c19:	6a 0d                	push   $0xd
  jmp __alltraps
  101c1b:	e9 6c ff ff ff       	jmp    101b8c <__alltraps>

00101c20 <vector14>:
.globl vector14
vector14:
  pushl $14
  101c20:	6a 0e                	push   $0xe
  jmp __alltraps
  101c22:	e9 65 ff ff ff       	jmp    101b8c <__alltraps>

00101c27 <vector15>:
.globl vector15
vector15:
  pushl $0
  101c27:	6a 00                	push   $0x0
  pushl $15
  101c29:	6a 0f                	push   $0xf
  jmp __alltraps
  101c2b:	e9 5c ff ff ff       	jmp    101b8c <__alltraps>

00101c30 <vector16>:
.globl vector16
vector16:
  pushl $0
  101c30:	6a 00                	push   $0x0
  pushl $16
  101c32:	6a 10                	push   $0x10
  jmp __alltraps
  101c34:	e9 53 ff ff ff       	jmp    101b8c <__alltraps>

00101c39 <vector17>:
.globl vector17
vector17:
  pushl $17
  101c39:	6a 11                	push   $0x11
  jmp __alltraps
  101c3b:	e9 4c ff ff ff       	jmp    101b8c <__alltraps>

00101c40 <vector18>:
.globl vector18
vector18:
  pushl $0
  101c40:	6a 00                	push   $0x0
  pushl $18
  101c42:	6a 12                	push   $0x12
  jmp __alltraps
  101c44:	e9 43 ff ff ff       	jmp    101b8c <__alltraps>

00101c49 <vector19>:
.globl vector19
vector19:
  pushl $0
  101c49:	6a 00                	push   $0x0
  pushl $19
  101c4b:	6a 13                	push   $0x13
  jmp __alltraps
  101c4d:	e9 3a ff ff ff       	jmp    101b8c <__alltraps>

00101c52 <vector20>:
.globl vector20
vector20:
  pushl $0
  101c52:	6a 00                	push   $0x0
  pushl $20
  101c54:	6a 14                	push   $0x14
  jmp __alltraps
  101c56:	e9 31 ff ff ff       	jmp    101b8c <__alltraps>

00101c5b <vector21>:
.globl vector21
vector21:
  pushl $0
  101c5b:	6a 00                	push   $0x0
  pushl $21
  101c5d:	6a 15                	push   $0x15
  jmp __alltraps
  101c5f:	e9 28 ff ff ff       	jmp    101b8c <__alltraps>

00101c64 <vector22>:
.globl vector22
vector22:
  pushl $0
  101c64:	6a 00                	push   $0x0
  pushl $22
  101c66:	6a 16                	push   $0x16
  jmp __alltraps
  101c68:	e9 1f ff ff ff       	jmp    101b8c <__alltraps>

00101c6d <vector23>:
.globl vector23
vector23:
  pushl $0
  101c6d:	6a 00                	push   $0x0
  pushl $23
  101c6f:	6a 17                	push   $0x17
  jmp __alltraps
  101c71:	e9 16 ff ff ff       	jmp    101b8c <__alltraps>

00101c76 <vector24>:
.globl vector24
vector24:
  pushl $0
  101c76:	6a 00                	push   $0x0
  pushl $24
  101c78:	6a 18                	push   $0x18
  jmp __alltraps
  101c7a:	e9 0d ff ff ff       	jmp    101b8c <__alltraps>

00101c7f <vector25>:
.globl vector25
vector25:
  pushl $0
  101c7f:	6a 00                	push   $0x0
  pushl $25
  101c81:	6a 19                	push   $0x19
  jmp __alltraps
  101c83:	e9 04 ff ff ff       	jmp    101b8c <__alltraps>

00101c88 <vector26>:
.globl vector26
vector26:
  pushl $0
  101c88:	6a 00                	push   $0x0
  pushl $26
  101c8a:	6a 1a                	push   $0x1a
  jmp __alltraps
  101c8c:	e9 fb fe ff ff       	jmp    101b8c <__alltraps>

00101c91 <vector27>:
.globl vector27
vector27:
  pushl $0
  101c91:	6a 00                	push   $0x0
  pushl $27
  101c93:	6a 1b                	push   $0x1b
  jmp __alltraps
  101c95:	e9 f2 fe ff ff       	jmp    101b8c <__alltraps>

00101c9a <vector28>:
.globl vector28
vector28:
  pushl $0
  101c9a:	6a 00                	push   $0x0
  pushl $28
  101c9c:	6a 1c                	push   $0x1c
  jmp __alltraps
  101c9e:	e9 e9 fe ff ff       	jmp    101b8c <__alltraps>

00101ca3 <vector29>:
.globl vector29
vector29:
  pushl $0
  101ca3:	6a 00                	push   $0x0
  pushl $29
  101ca5:	6a 1d                	push   $0x1d
  jmp __alltraps
  101ca7:	e9 e0 fe ff ff       	jmp    101b8c <__alltraps>

00101cac <vector30>:
.globl vector30
vector30:
  pushl $0
  101cac:	6a 00                	push   $0x0
  pushl $30
  101cae:	6a 1e                	push   $0x1e
  jmp __alltraps
  101cb0:	e9 d7 fe ff ff       	jmp    101b8c <__alltraps>

00101cb5 <vector31>:
.globl vector31
vector31:
  pushl $0
  101cb5:	6a 00                	push   $0x0
  pushl $31
  101cb7:	6a 1f                	push   $0x1f
  jmp __alltraps
  101cb9:	e9 ce fe ff ff       	jmp    101b8c <__alltraps>

00101cbe <vector32>:
.globl vector32
vector32:
  pushl $0
  101cbe:	6a 00                	push   $0x0
  pushl $32
  101cc0:	6a 20                	push   $0x20
  jmp __alltraps
  101cc2:	e9 c5 fe ff ff       	jmp    101b8c <__alltraps>

00101cc7 <vector33>:
.globl vector33
vector33:
  pushl $0
  101cc7:	6a 00                	push   $0x0
  pushl $33
  101cc9:	6a 21                	push   $0x21
  jmp __alltraps
  101ccb:	e9 bc fe ff ff       	jmp    101b8c <__alltraps>

00101cd0 <vector34>:
.globl vector34
vector34:
  pushl $0
  101cd0:	6a 00                	push   $0x0
  pushl $34
  101cd2:	6a 22                	push   $0x22
  jmp __alltraps
  101cd4:	e9 b3 fe ff ff       	jmp    101b8c <__alltraps>

00101cd9 <vector35>:
.globl vector35
vector35:
  pushl $0
  101cd9:	6a 00                	push   $0x0
  pushl $35
  101cdb:	6a 23                	push   $0x23
  jmp __alltraps
  101cdd:	e9 aa fe ff ff       	jmp    101b8c <__alltraps>

00101ce2 <vector36>:
.globl vector36
vector36:
  pushl $0
  101ce2:	6a 00                	push   $0x0
  pushl $36
  101ce4:	6a 24                	push   $0x24
  jmp __alltraps
  101ce6:	e9 a1 fe ff ff       	jmp    101b8c <__alltraps>

00101ceb <vector37>:
.globl vector37
vector37:
  pushl $0
  101ceb:	6a 00                	push   $0x0
  pushl $37
  101ced:	6a 25                	push   $0x25
  jmp __alltraps
  101cef:	e9 98 fe ff ff       	jmp    101b8c <__alltraps>

00101cf4 <vector38>:
.globl vector38
vector38:
  pushl $0
  101cf4:	6a 00                	push   $0x0
  pushl $38
  101cf6:	6a 26                	push   $0x26
  jmp __alltraps
  101cf8:	e9 8f fe ff ff       	jmp    101b8c <__alltraps>

00101cfd <vector39>:
.globl vector39
vector39:
  pushl $0
  101cfd:	6a 00                	push   $0x0
  pushl $39
  101cff:	6a 27                	push   $0x27
  jmp __alltraps
  101d01:	e9 86 fe ff ff       	jmp    101b8c <__alltraps>

00101d06 <vector40>:
.globl vector40
vector40:
  pushl $0
  101d06:	6a 00                	push   $0x0
  pushl $40
  101d08:	6a 28                	push   $0x28
  jmp __alltraps
  101d0a:	e9 7d fe ff ff       	jmp    101b8c <__alltraps>

00101d0f <vector41>:
.globl vector41
vector41:
  pushl $0
  101d0f:	6a 00                	push   $0x0
  pushl $41
  101d11:	6a 29                	push   $0x29
  jmp __alltraps
  101d13:	e9 74 fe ff ff       	jmp    101b8c <__alltraps>

00101d18 <vector42>:
.globl vector42
vector42:
  pushl $0
  101d18:	6a 00                	push   $0x0
  pushl $42
  101d1a:	6a 2a                	push   $0x2a
  jmp __alltraps
  101d1c:	e9 6b fe ff ff       	jmp    101b8c <__alltraps>

00101d21 <vector43>:
.globl vector43
vector43:
  pushl $0
  101d21:	6a 00                	push   $0x0
  pushl $43
  101d23:	6a 2b                	push   $0x2b
  jmp __alltraps
  101d25:	e9 62 fe ff ff       	jmp    101b8c <__alltraps>

00101d2a <vector44>:
.globl vector44
vector44:
  pushl $0
  101d2a:	6a 00                	push   $0x0
  pushl $44
  101d2c:	6a 2c                	push   $0x2c
  jmp __alltraps
  101d2e:	e9 59 fe ff ff       	jmp    101b8c <__alltraps>

00101d33 <vector45>:
.globl vector45
vector45:
  pushl $0
  101d33:	6a 00                	push   $0x0
  pushl $45
  101d35:	6a 2d                	push   $0x2d
  jmp __alltraps
  101d37:	e9 50 fe ff ff       	jmp    101b8c <__alltraps>

00101d3c <vector46>:
.globl vector46
vector46:
  pushl $0
  101d3c:	6a 00                	push   $0x0
  pushl $46
  101d3e:	6a 2e                	push   $0x2e
  jmp __alltraps
  101d40:	e9 47 fe ff ff       	jmp    101b8c <__alltraps>

00101d45 <vector47>:
.globl vector47
vector47:
  pushl $0
  101d45:	6a 00                	push   $0x0
  pushl $47
  101d47:	6a 2f                	push   $0x2f
  jmp __alltraps
  101d49:	e9 3e fe ff ff       	jmp    101b8c <__alltraps>

00101d4e <vector48>:
.globl vector48
vector48:
  pushl $0
  101d4e:	6a 00                	push   $0x0
  pushl $48
  101d50:	6a 30                	push   $0x30
  jmp __alltraps
  101d52:	e9 35 fe ff ff       	jmp    101b8c <__alltraps>

00101d57 <vector49>:
.globl vector49
vector49:
  pushl $0
  101d57:	6a 00                	push   $0x0
  pushl $49
  101d59:	6a 31                	push   $0x31
  jmp __alltraps
  101d5b:	e9 2c fe ff ff       	jmp    101b8c <__alltraps>

00101d60 <vector50>:
.globl vector50
vector50:
  pushl $0
  101d60:	6a 00                	push   $0x0
  pushl $50
  101d62:	6a 32                	push   $0x32
  jmp __alltraps
  101d64:	e9 23 fe ff ff       	jmp    101b8c <__alltraps>

00101d69 <vector51>:
.globl vector51
vector51:
  pushl $0
  101d69:	6a 00                	push   $0x0
  pushl $51
  101d6b:	6a 33                	push   $0x33
  jmp __alltraps
  101d6d:	e9 1a fe ff ff       	jmp    101b8c <__alltraps>

00101d72 <vector52>:
.globl vector52
vector52:
  pushl $0
  101d72:	6a 00                	push   $0x0
  pushl $52
  101d74:	6a 34                	push   $0x34
  jmp __alltraps
  101d76:	e9 11 fe ff ff       	jmp    101b8c <__alltraps>

00101d7b <vector53>:
.globl vector53
vector53:
  pushl $0
  101d7b:	6a 00                	push   $0x0
  pushl $53
  101d7d:	6a 35                	push   $0x35
  jmp __alltraps
  101d7f:	e9 08 fe ff ff       	jmp    101b8c <__alltraps>

00101d84 <vector54>:
.globl vector54
vector54:
  pushl $0
  101d84:	6a 00                	push   $0x0
  pushl $54
  101d86:	6a 36                	push   $0x36
  jmp __alltraps
  101d88:	e9 ff fd ff ff       	jmp    101b8c <__alltraps>

00101d8d <vector55>:
.globl vector55
vector55:
  pushl $0
  101d8d:	6a 00                	push   $0x0
  pushl $55
  101d8f:	6a 37                	push   $0x37
  jmp __alltraps
  101d91:	e9 f6 fd ff ff       	jmp    101b8c <__alltraps>

00101d96 <vector56>:
.globl vector56
vector56:
  pushl $0
  101d96:	6a 00                	push   $0x0
  pushl $56
  101d98:	6a 38                	push   $0x38
  jmp __alltraps
  101d9a:	e9 ed fd ff ff       	jmp    101b8c <__alltraps>

00101d9f <vector57>:
.globl vector57
vector57:
  pushl $0
  101d9f:	6a 00                	push   $0x0
  pushl $57
  101da1:	6a 39                	push   $0x39
  jmp __alltraps
  101da3:	e9 e4 fd ff ff       	jmp    101b8c <__alltraps>

00101da8 <vector58>:
.globl vector58
vector58:
  pushl $0
  101da8:	6a 00                	push   $0x0
  pushl $58
  101daa:	6a 3a                	push   $0x3a
  jmp __alltraps
  101dac:	e9 db fd ff ff       	jmp    101b8c <__alltraps>

00101db1 <vector59>:
.globl vector59
vector59:
  pushl $0
  101db1:	6a 00                	push   $0x0
  pushl $59
  101db3:	6a 3b                	push   $0x3b
  jmp __alltraps
  101db5:	e9 d2 fd ff ff       	jmp    101b8c <__alltraps>

00101dba <vector60>:
.globl vector60
vector60:
  pushl $0
  101dba:	6a 00                	push   $0x0
  pushl $60
  101dbc:	6a 3c                	push   $0x3c
  jmp __alltraps
  101dbe:	e9 c9 fd ff ff       	jmp    101b8c <__alltraps>

00101dc3 <vector61>:
.globl vector61
vector61:
  pushl $0
  101dc3:	6a 00                	push   $0x0
  pushl $61
  101dc5:	6a 3d                	push   $0x3d
  jmp __alltraps
  101dc7:	e9 c0 fd ff ff       	jmp    101b8c <__alltraps>

00101dcc <vector62>:
.globl vector62
vector62:
  pushl $0
  101dcc:	6a 00                	push   $0x0
  pushl $62
  101dce:	6a 3e                	push   $0x3e
  jmp __alltraps
  101dd0:	e9 b7 fd ff ff       	jmp    101b8c <__alltraps>

00101dd5 <vector63>:
.globl vector63
vector63:
  pushl $0
  101dd5:	6a 00                	push   $0x0
  pushl $63
  101dd7:	6a 3f                	push   $0x3f
  jmp __alltraps
  101dd9:	e9 ae fd ff ff       	jmp    101b8c <__alltraps>

00101dde <vector64>:
.globl vector64
vector64:
  pushl $0
  101dde:	6a 00                	push   $0x0
  pushl $64
  101de0:	6a 40                	push   $0x40
  jmp __alltraps
  101de2:	e9 a5 fd ff ff       	jmp    101b8c <__alltraps>

00101de7 <vector65>:
.globl vector65
vector65:
  pushl $0
  101de7:	6a 00                	push   $0x0
  pushl $65
  101de9:	6a 41                	push   $0x41
  jmp __alltraps
  101deb:	e9 9c fd ff ff       	jmp    101b8c <__alltraps>

00101df0 <vector66>:
.globl vector66
vector66:
  pushl $0
  101df0:	6a 00                	push   $0x0
  pushl $66
  101df2:	6a 42                	push   $0x42
  jmp __alltraps
  101df4:	e9 93 fd ff ff       	jmp    101b8c <__alltraps>

00101df9 <vector67>:
.globl vector67
vector67:
  pushl $0
  101df9:	6a 00                	push   $0x0
  pushl $67
  101dfb:	6a 43                	push   $0x43
  jmp __alltraps
  101dfd:	e9 8a fd ff ff       	jmp    101b8c <__alltraps>

00101e02 <vector68>:
.globl vector68
vector68:
  pushl $0
  101e02:	6a 00                	push   $0x0
  pushl $68
  101e04:	6a 44                	push   $0x44
  jmp __alltraps
  101e06:	e9 81 fd ff ff       	jmp    101b8c <__alltraps>

00101e0b <vector69>:
.globl vector69
vector69:
  pushl $0
  101e0b:	6a 00                	push   $0x0
  pushl $69
  101e0d:	6a 45                	push   $0x45
  jmp __alltraps
  101e0f:	e9 78 fd ff ff       	jmp    101b8c <__alltraps>

00101e14 <vector70>:
.globl vector70
vector70:
  pushl $0
  101e14:	6a 00                	push   $0x0
  pushl $70
  101e16:	6a 46                	push   $0x46
  jmp __alltraps
  101e18:	e9 6f fd ff ff       	jmp    101b8c <__alltraps>

00101e1d <vector71>:
.globl vector71
vector71:
  pushl $0
  101e1d:	6a 00                	push   $0x0
  pushl $71
  101e1f:	6a 47                	push   $0x47
  jmp __alltraps
  101e21:	e9 66 fd ff ff       	jmp    101b8c <__alltraps>

00101e26 <vector72>:
.globl vector72
vector72:
  pushl $0
  101e26:	6a 00                	push   $0x0
  pushl $72
  101e28:	6a 48                	push   $0x48
  jmp __alltraps
  101e2a:	e9 5d fd ff ff       	jmp    101b8c <__alltraps>

00101e2f <vector73>:
.globl vector73
vector73:
  pushl $0
  101e2f:	6a 00                	push   $0x0
  pushl $73
  101e31:	6a 49                	push   $0x49
  jmp __alltraps
  101e33:	e9 54 fd ff ff       	jmp    101b8c <__alltraps>

00101e38 <vector74>:
.globl vector74
vector74:
  pushl $0
  101e38:	6a 00                	push   $0x0
  pushl $74
  101e3a:	6a 4a                	push   $0x4a
  jmp __alltraps
  101e3c:	e9 4b fd ff ff       	jmp    101b8c <__alltraps>

00101e41 <vector75>:
.globl vector75
vector75:
  pushl $0
  101e41:	6a 00                	push   $0x0
  pushl $75
  101e43:	6a 4b                	push   $0x4b
  jmp __alltraps
  101e45:	e9 42 fd ff ff       	jmp    101b8c <__alltraps>

00101e4a <vector76>:
.globl vector76
vector76:
  pushl $0
  101e4a:	6a 00                	push   $0x0
  pushl $76
  101e4c:	6a 4c                	push   $0x4c
  jmp __alltraps
  101e4e:	e9 39 fd ff ff       	jmp    101b8c <__alltraps>

00101e53 <vector77>:
.globl vector77
vector77:
  pushl $0
  101e53:	6a 00                	push   $0x0
  pushl $77
  101e55:	6a 4d                	push   $0x4d
  jmp __alltraps
  101e57:	e9 30 fd ff ff       	jmp    101b8c <__alltraps>

00101e5c <vector78>:
.globl vector78
vector78:
  pushl $0
  101e5c:	6a 00                	push   $0x0
  pushl $78
  101e5e:	6a 4e                	push   $0x4e
  jmp __alltraps
  101e60:	e9 27 fd ff ff       	jmp    101b8c <__alltraps>

00101e65 <vector79>:
.globl vector79
vector79:
  pushl $0
  101e65:	6a 00                	push   $0x0
  pushl $79
  101e67:	6a 4f                	push   $0x4f
  jmp __alltraps
  101e69:	e9 1e fd ff ff       	jmp    101b8c <__alltraps>

00101e6e <vector80>:
.globl vector80
vector80:
  pushl $0
  101e6e:	6a 00                	push   $0x0
  pushl $80
  101e70:	6a 50                	push   $0x50
  jmp __alltraps
  101e72:	e9 15 fd ff ff       	jmp    101b8c <__alltraps>

00101e77 <vector81>:
.globl vector81
vector81:
  pushl $0
  101e77:	6a 00                	push   $0x0
  pushl $81
  101e79:	6a 51                	push   $0x51
  jmp __alltraps
  101e7b:	e9 0c fd ff ff       	jmp    101b8c <__alltraps>

00101e80 <vector82>:
.globl vector82
vector82:
  pushl $0
  101e80:	6a 00                	push   $0x0
  pushl $82
  101e82:	6a 52                	push   $0x52
  jmp __alltraps
  101e84:	e9 03 fd ff ff       	jmp    101b8c <__alltraps>

00101e89 <vector83>:
.globl vector83
vector83:
  pushl $0
  101e89:	6a 00                	push   $0x0
  pushl $83
  101e8b:	6a 53                	push   $0x53
  jmp __alltraps
  101e8d:	e9 fa fc ff ff       	jmp    101b8c <__alltraps>

00101e92 <vector84>:
.globl vector84
vector84:
  pushl $0
  101e92:	6a 00                	push   $0x0
  pushl $84
  101e94:	6a 54                	push   $0x54
  jmp __alltraps
  101e96:	e9 f1 fc ff ff       	jmp    101b8c <__alltraps>

00101e9b <vector85>:
.globl vector85
vector85:
  pushl $0
  101e9b:	6a 00                	push   $0x0
  pushl $85
  101e9d:	6a 55                	push   $0x55
  jmp __alltraps
  101e9f:	e9 e8 fc ff ff       	jmp    101b8c <__alltraps>

00101ea4 <vector86>:
.globl vector86
vector86:
  pushl $0
  101ea4:	6a 00                	push   $0x0
  pushl $86
  101ea6:	6a 56                	push   $0x56
  jmp __alltraps
  101ea8:	e9 df fc ff ff       	jmp    101b8c <__alltraps>

00101ead <vector87>:
.globl vector87
vector87:
  pushl $0
  101ead:	6a 00                	push   $0x0
  pushl $87
  101eaf:	6a 57                	push   $0x57
  jmp __alltraps
  101eb1:	e9 d6 fc ff ff       	jmp    101b8c <__alltraps>

00101eb6 <vector88>:
.globl vector88
vector88:
  pushl $0
  101eb6:	6a 00                	push   $0x0
  pushl $88
  101eb8:	6a 58                	push   $0x58
  jmp __alltraps
  101eba:	e9 cd fc ff ff       	jmp    101b8c <__alltraps>

00101ebf <vector89>:
.globl vector89
vector89:
  pushl $0
  101ebf:	6a 00                	push   $0x0
  pushl $89
  101ec1:	6a 59                	push   $0x59
  jmp __alltraps
  101ec3:	e9 c4 fc ff ff       	jmp    101b8c <__alltraps>

00101ec8 <vector90>:
.globl vector90
vector90:
  pushl $0
  101ec8:	6a 00                	push   $0x0
  pushl $90
  101eca:	6a 5a                	push   $0x5a
  jmp __alltraps
  101ecc:	e9 bb fc ff ff       	jmp    101b8c <__alltraps>

00101ed1 <vector91>:
.globl vector91
vector91:
  pushl $0
  101ed1:	6a 00                	push   $0x0
  pushl $91
  101ed3:	6a 5b                	push   $0x5b
  jmp __alltraps
  101ed5:	e9 b2 fc ff ff       	jmp    101b8c <__alltraps>

00101eda <vector92>:
.globl vector92
vector92:
  pushl $0
  101eda:	6a 00                	push   $0x0
  pushl $92
  101edc:	6a 5c                	push   $0x5c
  jmp __alltraps
  101ede:	e9 a9 fc ff ff       	jmp    101b8c <__alltraps>

00101ee3 <vector93>:
.globl vector93
vector93:
  pushl $0
  101ee3:	6a 00                	push   $0x0
  pushl $93
  101ee5:	6a 5d                	push   $0x5d
  jmp __alltraps
  101ee7:	e9 a0 fc ff ff       	jmp    101b8c <__alltraps>

00101eec <vector94>:
.globl vector94
vector94:
  pushl $0
  101eec:	6a 00                	push   $0x0
  pushl $94
  101eee:	6a 5e                	push   $0x5e
  jmp __alltraps
  101ef0:	e9 97 fc ff ff       	jmp    101b8c <__alltraps>

00101ef5 <vector95>:
.globl vector95
vector95:
  pushl $0
  101ef5:	6a 00                	push   $0x0
  pushl $95
  101ef7:	6a 5f                	push   $0x5f
  jmp __alltraps
  101ef9:	e9 8e fc ff ff       	jmp    101b8c <__alltraps>

00101efe <vector96>:
.globl vector96
vector96:
  pushl $0
  101efe:	6a 00                	push   $0x0
  pushl $96
  101f00:	6a 60                	push   $0x60
  jmp __alltraps
  101f02:	e9 85 fc ff ff       	jmp    101b8c <__alltraps>

00101f07 <vector97>:
.globl vector97
vector97:
  pushl $0
  101f07:	6a 00                	push   $0x0
  pushl $97
  101f09:	6a 61                	push   $0x61
  jmp __alltraps
  101f0b:	e9 7c fc ff ff       	jmp    101b8c <__alltraps>

00101f10 <vector98>:
.globl vector98
vector98:
  pushl $0
  101f10:	6a 00                	push   $0x0
  pushl $98
  101f12:	6a 62                	push   $0x62
  jmp __alltraps
  101f14:	e9 73 fc ff ff       	jmp    101b8c <__alltraps>

00101f19 <vector99>:
.globl vector99
vector99:
  pushl $0
  101f19:	6a 00                	push   $0x0
  pushl $99
  101f1b:	6a 63                	push   $0x63
  jmp __alltraps
  101f1d:	e9 6a fc ff ff       	jmp    101b8c <__alltraps>

00101f22 <vector100>:
.globl vector100
vector100:
  pushl $0
  101f22:	6a 00                	push   $0x0
  pushl $100
  101f24:	6a 64                	push   $0x64
  jmp __alltraps
  101f26:	e9 61 fc ff ff       	jmp    101b8c <__alltraps>

00101f2b <vector101>:
.globl vector101
vector101:
  pushl $0
  101f2b:	6a 00                	push   $0x0
  pushl $101
  101f2d:	6a 65                	push   $0x65
  jmp __alltraps
  101f2f:	e9 58 fc ff ff       	jmp    101b8c <__alltraps>

00101f34 <vector102>:
.globl vector102
vector102:
  pushl $0
  101f34:	6a 00                	push   $0x0
  pushl $102
  101f36:	6a 66                	push   $0x66
  jmp __alltraps
  101f38:	e9 4f fc ff ff       	jmp    101b8c <__alltraps>

00101f3d <vector103>:
.globl vector103
vector103:
  pushl $0
  101f3d:	6a 00                	push   $0x0
  pushl $103
  101f3f:	6a 67                	push   $0x67
  jmp __alltraps
  101f41:	e9 46 fc ff ff       	jmp    101b8c <__alltraps>

00101f46 <vector104>:
.globl vector104
vector104:
  pushl $0
  101f46:	6a 00                	push   $0x0
  pushl $104
  101f48:	6a 68                	push   $0x68
  jmp __alltraps
  101f4a:	e9 3d fc ff ff       	jmp    101b8c <__alltraps>

00101f4f <vector105>:
.globl vector105
vector105:
  pushl $0
  101f4f:	6a 00                	push   $0x0
  pushl $105
  101f51:	6a 69                	push   $0x69
  jmp __alltraps
  101f53:	e9 34 fc ff ff       	jmp    101b8c <__alltraps>

00101f58 <vector106>:
.globl vector106
vector106:
  pushl $0
  101f58:	6a 00                	push   $0x0
  pushl $106
  101f5a:	6a 6a                	push   $0x6a
  jmp __alltraps
  101f5c:	e9 2b fc ff ff       	jmp    101b8c <__alltraps>

00101f61 <vector107>:
.globl vector107
vector107:
  pushl $0
  101f61:	6a 00                	push   $0x0
  pushl $107
  101f63:	6a 6b                	push   $0x6b
  jmp __alltraps
  101f65:	e9 22 fc ff ff       	jmp    101b8c <__alltraps>

00101f6a <vector108>:
.globl vector108
vector108:
  pushl $0
  101f6a:	6a 00                	push   $0x0
  pushl $108
  101f6c:	6a 6c                	push   $0x6c
  jmp __alltraps
  101f6e:	e9 19 fc ff ff       	jmp    101b8c <__alltraps>

00101f73 <vector109>:
.globl vector109
vector109:
  pushl $0
  101f73:	6a 00                	push   $0x0
  pushl $109
  101f75:	6a 6d                	push   $0x6d
  jmp __alltraps
  101f77:	e9 10 fc ff ff       	jmp    101b8c <__alltraps>

00101f7c <vector110>:
.globl vector110
vector110:
  pushl $0
  101f7c:	6a 00                	push   $0x0
  pushl $110
  101f7e:	6a 6e                	push   $0x6e
  jmp __alltraps
  101f80:	e9 07 fc ff ff       	jmp    101b8c <__alltraps>

00101f85 <vector111>:
.globl vector111
vector111:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $111
  101f87:	6a 6f                	push   $0x6f
  jmp __alltraps
  101f89:	e9 fe fb ff ff       	jmp    101b8c <__alltraps>

00101f8e <vector112>:
.globl vector112
vector112:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $112
  101f90:	6a 70                	push   $0x70
  jmp __alltraps
  101f92:	e9 f5 fb ff ff       	jmp    101b8c <__alltraps>

00101f97 <vector113>:
.globl vector113
vector113:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $113
  101f99:	6a 71                	push   $0x71
  jmp __alltraps
  101f9b:	e9 ec fb ff ff       	jmp    101b8c <__alltraps>

00101fa0 <vector114>:
.globl vector114
vector114:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $114
  101fa2:	6a 72                	push   $0x72
  jmp __alltraps
  101fa4:	e9 e3 fb ff ff       	jmp    101b8c <__alltraps>

00101fa9 <vector115>:
.globl vector115
vector115:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $115
  101fab:	6a 73                	push   $0x73
  jmp __alltraps
  101fad:	e9 da fb ff ff       	jmp    101b8c <__alltraps>

00101fb2 <vector116>:
.globl vector116
vector116:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $116
  101fb4:	6a 74                	push   $0x74
  jmp __alltraps
  101fb6:	e9 d1 fb ff ff       	jmp    101b8c <__alltraps>

00101fbb <vector117>:
.globl vector117
vector117:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $117
  101fbd:	6a 75                	push   $0x75
  jmp __alltraps
  101fbf:	e9 c8 fb ff ff       	jmp    101b8c <__alltraps>

00101fc4 <vector118>:
.globl vector118
vector118:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $118
  101fc6:	6a 76                	push   $0x76
  jmp __alltraps
  101fc8:	e9 bf fb ff ff       	jmp    101b8c <__alltraps>

00101fcd <vector119>:
.globl vector119
vector119:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $119
  101fcf:	6a 77                	push   $0x77
  jmp __alltraps
  101fd1:	e9 b6 fb ff ff       	jmp    101b8c <__alltraps>

00101fd6 <vector120>:
.globl vector120
vector120:
  pushl $0
  101fd6:	6a 00                	push   $0x0
  pushl $120
  101fd8:	6a 78                	push   $0x78
  jmp __alltraps
  101fda:	e9 ad fb ff ff       	jmp    101b8c <__alltraps>

00101fdf <vector121>:
.globl vector121
vector121:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $121
  101fe1:	6a 79                	push   $0x79
  jmp __alltraps
  101fe3:	e9 a4 fb ff ff       	jmp    101b8c <__alltraps>

00101fe8 <vector122>:
.globl vector122
vector122:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $122
  101fea:	6a 7a                	push   $0x7a
  jmp __alltraps
  101fec:	e9 9b fb ff ff       	jmp    101b8c <__alltraps>

00101ff1 <vector123>:
.globl vector123
vector123:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $123
  101ff3:	6a 7b                	push   $0x7b
  jmp __alltraps
  101ff5:	e9 92 fb ff ff       	jmp    101b8c <__alltraps>

00101ffa <vector124>:
.globl vector124
vector124:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $124
  101ffc:	6a 7c                	push   $0x7c
  jmp __alltraps
  101ffe:	e9 89 fb ff ff       	jmp    101b8c <__alltraps>

00102003 <vector125>:
.globl vector125
vector125:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $125
  102005:	6a 7d                	push   $0x7d
  jmp __alltraps
  102007:	e9 80 fb ff ff       	jmp    101b8c <__alltraps>

0010200c <vector126>:
.globl vector126
vector126:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $126
  10200e:	6a 7e                	push   $0x7e
  jmp __alltraps
  102010:	e9 77 fb ff ff       	jmp    101b8c <__alltraps>

00102015 <vector127>:
.globl vector127
vector127:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $127
  102017:	6a 7f                	push   $0x7f
  jmp __alltraps
  102019:	e9 6e fb ff ff       	jmp    101b8c <__alltraps>

0010201e <vector128>:
.globl vector128
vector128:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $128
  102020:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102025:	e9 62 fb ff ff       	jmp    101b8c <__alltraps>

0010202a <vector129>:
.globl vector129
vector129:
  pushl $0
  10202a:	6a 00                	push   $0x0
  pushl $129
  10202c:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102031:	e9 56 fb ff ff       	jmp    101b8c <__alltraps>

00102036 <vector130>:
.globl vector130
vector130:
  pushl $0
  102036:	6a 00                	push   $0x0
  pushl $130
  102038:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  10203d:	e9 4a fb ff ff       	jmp    101b8c <__alltraps>

00102042 <vector131>:
.globl vector131
vector131:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $131
  102044:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102049:	e9 3e fb ff ff       	jmp    101b8c <__alltraps>

0010204e <vector132>:
.globl vector132
vector132:
  pushl $0
  10204e:	6a 00                	push   $0x0
  pushl $132
  102050:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102055:	e9 32 fb ff ff       	jmp    101b8c <__alltraps>

0010205a <vector133>:
.globl vector133
vector133:
  pushl $0
  10205a:	6a 00                	push   $0x0
  pushl $133
  10205c:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102061:	e9 26 fb ff ff       	jmp    101b8c <__alltraps>

00102066 <vector134>:
.globl vector134
vector134:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $134
  102068:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  10206d:	e9 1a fb ff ff       	jmp    101b8c <__alltraps>

00102072 <vector135>:
.globl vector135
vector135:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $135
  102074:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102079:	e9 0e fb ff ff       	jmp    101b8c <__alltraps>

0010207e <vector136>:
.globl vector136
vector136:
  pushl $0
  10207e:	6a 00                	push   $0x0
  pushl $136
  102080:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102085:	e9 02 fb ff ff       	jmp    101b8c <__alltraps>

0010208a <vector137>:
.globl vector137
vector137:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $137
  10208c:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102091:	e9 f6 fa ff ff       	jmp    101b8c <__alltraps>

00102096 <vector138>:
.globl vector138
vector138:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $138
  102098:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10209d:	e9 ea fa ff ff       	jmp    101b8c <__alltraps>

001020a2 <vector139>:
.globl vector139
vector139:
  pushl $0
  1020a2:	6a 00                	push   $0x0
  pushl $139
  1020a4:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1020a9:	e9 de fa ff ff       	jmp    101b8c <__alltraps>

001020ae <vector140>:
.globl vector140
vector140:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $140
  1020b0:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1020b5:	e9 d2 fa ff ff       	jmp    101b8c <__alltraps>

001020ba <vector141>:
.globl vector141
vector141:
  pushl $0
  1020ba:	6a 00                	push   $0x0
  pushl $141
  1020bc:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1020c1:	e9 c6 fa ff ff       	jmp    101b8c <__alltraps>

001020c6 <vector142>:
.globl vector142
vector142:
  pushl $0
  1020c6:	6a 00                	push   $0x0
  pushl $142
  1020c8:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1020cd:	e9 ba fa ff ff       	jmp    101b8c <__alltraps>

001020d2 <vector143>:
.globl vector143
vector143:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $143
  1020d4:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1020d9:	e9 ae fa ff ff       	jmp    101b8c <__alltraps>

001020de <vector144>:
.globl vector144
vector144:
  pushl $0
  1020de:	6a 00                	push   $0x0
  pushl $144
  1020e0:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1020e5:	e9 a2 fa ff ff       	jmp    101b8c <__alltraps>

001020ea <vector145>:
.globl vector145
vector145:
  pushl $0
  1020ea:	6a 00                	push   $0x0
  pushl $145
  1020ec:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1020f1:	e9 96 fa ff ff       	jmp    101b8c <__alltraps>

001020f6 <vector146>:
.globl vector146
vector146:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $146
  1020f8:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1020fd:	e9 8a fa ff ff       	jmp    101b8c <__alltraps>

00102102 <vector147>:
.globl vector147
vector147:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $147
  102104:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102109:	e9 7e fa ff ff       	jmp    101b8c <__alltraps>

0010210e <vector148>:
.globl vector148
vector148:
  pushl $0
  10210e:	6a 00                	push   $0x0
  pushl $148
  102110:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102115:	e9 72 fa ff ff       	jmp    101b8c <__alltraps>

0010211a <vector149>:
.globl vector149
vector149:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $149
  10211c:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102121:	e9 66 fa ff ff       	jmp    101b8c <__alltraps>

00102126 <vector150>:
.globl vector150
vector150:
  pushl $0
  102126:	6a 00                	push   $0x0
  pushl $150
  102128:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  10212d:	e9 5a fa ff ff       	jmp    101b8c <__alltraps>

00102132 <vector151>:
.globl vector151
vector151:
  pushl $0
  102132:	6a 00                	push   $0x0
  pushl $151
  102134:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102139:	e9 4e fa ff ff       	jmp    101b8c <__alltraps>

0010213e <vector152>:
.globl vector152
vector152:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $152
  102140:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102145:	e9 42 fa ff ff       	jmp    101b8c <__alltraps>

0010214a <vector153>:
.globl vector153
vector153:
  pushl $0
  10214a:	6a 00                	push   $0x0
  pushl $153
  10214c:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102151:	e9 36 fa ff ff       	jmp    101b8c <__alltraps>

00102156 <vector154>:
.globl vector154
vector154:
  pushl $0
  102156:	6a 00                	push   $0x0
  pushl $154
  102158:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  10215d:	e9 2a fa ff ff       	jmp    101b8c <__alltraps>

00102162 <vector155>:
.globl vector155
vector155:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $155
  102164:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102169:	e9 1e fa ff ff       	jmp    101b8c <__alltraps>

0010216e <vector156>:
.globl vector156
vector156:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $156
  102170:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102175:	e9 12 fa ff ff       	jmp    101b8c <__alltraps>

0010217a <vector157>:
.globl vector157
vector157:
  pushl $0
  10217a:	6a 00                	push   $0x0
  pushl $157
  10217c:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102181:	e9 06 fa ff ff       	jmp    101b8c <__alltraps>

00102186 <vector158>:
.globl vector158
vector158:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $158
  102188:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10218d:	e9 fa f9 ff ff       	jmp    101b8c <__alltraps>

00102192 <vector159>:
.globl vector159
vector159:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $159
  102194:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102199:	e9 ee f9 ff ff       	jmp    101b8c <__alltraps>

0010219e <vector160>:
.globl vector160
vector160:
  pushl $0
  10219e:	6a 00                	push   $0x0
  pushl $160
  1021a0:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1021a5:	e9 e2 f9 ff ff       	jmp    101b8c <__alltraps>

001021aa <vector161>:
.globl vector161
vector161:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $161
  1021ac:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1021b1:	e9 d6 f9 ff ff       	jmp    101b8c <__alltraps>

001021b6 <vector162>:
.globl vector162
vector162:
  pushl $0
  1021b6:	6a 00                	push   $0x0
  pushl $162
  1021b8:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1021bd:	e9 ca f9 ff ff       	jmp    101b8c <__alltraps>

001021c2 <vector163>:
.globl vector163
vector163:
  pushl $0
  1021c2:	6a 00                	push   $0x0
  pushl $163
  1021c4:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1021c9:	e9 be f9 ff ff       	jmp    101b8c <__alltraps>

001021ce <vector164>:
.globl vector164
vector164:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $164
  1021d0:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1021d5:	e9 b2 f9 ff ff       	jmp    101b8c <__alltraps>

001021da <vector165>:
.globl vector165
vector165:
  pushl $0
  1021da:	6a 00                	push   $0x0
  pushl $165
  1021dc:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1021e1:	e9 a6 f9 ff ff       	jmp    101b8c <__alltraps>

001021e6 <vector166>:
.globl vector166
vector166:
  pushl $0
  1021e6:	6a 00                	push   $0x0
  pushl $166
  1021e8:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1021ed:	e9 9a f9 ff ff       	jmp    101b8c <__alltraps>

001021f2 <vector167>:
.globl vector167
vector167:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $167
  1021f4:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1021f9:	e9 8e f9 ff ff       	jmp    101b8c <__alltraps>

001021fe <vector168>:
.globl vector168
vector168:
  pushl $0
  1021fe:	6a 00                	push   $0x0
  pushl $168
  102200:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102205:	e9 82 f9 ff ff       	jmp    101b8c <__alltraps>

0010220a <vector169>:
.globl vector169
vector169:
  pushl $0
  10220a:	6a 00                	push   $0x0
  pushl $169
  10220c:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102211:	e9 76 f9 ff ff       	jmp    101b8c <__alltraps>

00102216 <vector170>:
.globl vector170
vector170:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $170
  102218:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  10221d:	e9 6a f9 ff ff       	jmp    101b8c <__alltraps>

00102222 <vector171>:
.globl vector171
vector171:
  pushl $0
  102222:	6a 00                	push   $0x0
  pushl $171
  102224:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102229:	e9 5e f9 ff ff       	jmp    101b8c <__alltraps>

0010222e <vector172>:
.globl vector172
vector172:
  pushl $0
  10222e:	6a 00                	push   $0x0
  pushl $172
  102230:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102235:	e9 52 f9 ff ff       	jmp    101b8c <__alltraps>

0010223a <vector173>:
.globl vector173
vector173:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $173
  10223c:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102241:	e9 46 f9 ff ff       	jmp    101b8c <__alltraps>

00102246 <vector174>:
.globl vector174
vector174:
  pushl $0
  102246:	6a 00                	push   $0x0
  pushl $174
  102248:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  10224d:	e9 3a f9 ff ff       	jmp    101b8c <__alltraps>

00102252 <vector175>:
.globl vector175
vector175:
  pushl $0
  102252:	6a 00                	push   $0x0
  pushl $175
  102254:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102259:	e9 2e f9 ff ff       	jmp    101b8c <__alltraps>

0010225e <vector176>:
.globl vector176
vector176:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $176
  102260:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102265:	e9 22 f9 ff ff       	jmp    101b8c <__alltraps>

0010226a <vector177>:
.globl vector177
vector177:
  pushl $0
  10226a:	6a 00                	push   $0x0
  pushl $177
  10226c:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102271:	e9 16 f9 ff ff       	jmp    101b8c <__alltraps>

00102276 <vector178>:
.globl vector178
vector178:
  pushl $0
  102276:	6a 00                	push   $0x0
  pushl $178
  102278:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10227d:	e9 0a f9 ff ff       	jmp    101b8c <__alltraps>

00102282 <vector179>:
.globl vector179
vector179:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $179
  102284:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102289:	e9 fe f8 ff ff       	jmp    101b8c <__alltraps>

0010228e <vector180>:
.globl vector180
vector180:
  pushl $0
  10228e:	6a 00                	push   $0x0
  pushl $180
  102290:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102295:	e9 f2 f8 ff ff       	jmp    101b8c <__alltraps>

0010229a <vector181>:
.globl vector181
vector181:
  pushl $0
  10229a:	6a 00                	push   $0x0
  pushl $181
  10229c:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1022a1:	e9 e6 f8 ff ff       	jmp    101b8c <__alltraps>

001022a6 <vector182>:
.globl vector182
vector182:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $182
  1022a8:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1022ad:	e9 da f8 ff ff       	jmp    101b8c <__alltraps>

001022b2 <vector183>:
.globl vector183
vector183:
  pushl $0
  1022b2:	6a 00                	push   $0x0
  pushl $183
  1022b4:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1022b9:	e9 ce f8 ff ff       	jmp    101b8c <__alltraps>

001022be <vector184>:
.globl vector184
vector184:
  pushl $0
  1022be:	6a 00                	push   $0x0
  pushl $184
  1022c0:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1022c5:	e9 c2 f8 ff ff       	jmp    101b8c <__alltraps>

001022ca <vector185>:
.globl vector185
vector185:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $185
  1022cc:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1022d1:	e9 b6 f8 ff ff       	jmp    101b8c <__alltraps>

001022d6 <vector186>:
.globl vector186
vector186:
  pushl $0
  1022d6:	6a 00                	push   $0x0
  pushl $186
  1022d8:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1022dd:	e9 aa f8 ff ff       	jmp    101b8c <__alltraps>

001022e2 <vector187>:
.globl vector187
vector187:
  pushl $0
  1022e2:	6a 00                	push   $0x0
  pushl $187
  1022e4:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1022e9:	e9 9e f8 ff ff       	jmp    101b8c <__alltraps>

001022ee <vector188>:
.globl vector188
vector188:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $188
  1022f0:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1022f5:	e9 92 f8 ff ff       	jmp    101b8c <__alltraps>

001022fa <vector189>:
.globl vector189
vector189:
  pushl $0
  1022fa:	6a 00                	push   $0x0
  pushl $189
  1022fc:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102301:	e9 86 f8 ff ff       	jmp    101b8c <__alltraps>

00102306 <vector190>:
.globl vector190
vector190:
  pushl $0
  102306:	6a 00                	push   $0x0
  pushl $190
  102308:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10230d:	e9 7a f8 ff ff       	jmp    101b8c <__alltraps>

00102312 <vector191>:
.globl vector191
vector191:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $191
  102314:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102319:	e9 6e f8 ff ff       	jmp    101b8c <__alltraps>

0010231e <vector192>:
.globl vector192
vector192:
  pushl $0
  10231e:	6a 00                	push   $0x0
  pushl $192
  102320:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102325:	e9 62 f8 ff ff       	jmp    101b8c <__alltraps>

0010232a <vector193>:
.globl vector193
vector193:
  pushl $0
  10232a:	6a 00                	push   $0x0
  pushl $193
  10232c:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102331:	e9 56 f8 ff ff       	jmp    101b8c <__alltraps>

00102336 <vector194>:
.globl vector194
vector194:
  pushl $0
  102336:	6a 00                	push   $0x0
  pushl $194
  102338:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  10233d:	e9 4a f8 ff ff       	jmp    101b8c <__alltraps>

00102342 <vector195>:
.globl vector195
vector195:
  pushl $0
  102342:	6a 00                	push   $0x0
  pushl $195
  102344:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102349:	e9 3e f8 ff ff       	jmp    101b8c <__alltraps>

0010234e <vector196>:
.globl vector196
vector196:
  pushl $0
  10234e:	6a 00                	push   $0x0
  pushl $196
  102350:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102355:	e9 32 f8 ff ff       	jmp    101b8c <__alltraps>

0010235a <vector197>:
.globl vector197
vector197:
  pushl $0
  10235a:	6a 00                	push   $0x0
  pushl $197
  10235c:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102361:	e9 26 f8 ff ff       	jmp    101b8c <__alltraps>

00102366 <vector198>:
.globl vector198
vector198:
  pushl $0
  102366:	6a 00                	push   $0x0
  pushl $198
  102368:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  10236d:	e9 1a f8 ff ff       	jmp    101b8c <__alltraps>

00102372 <vector199>:
.globl vector199
vector199:
  pushl $0
  102372:	6a 00                	push   $0x0
  pushl $199
  102374:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102379:	e9 0e f8 ff ff       	jmp    101b8c <__alltraps>

0010237e <vector200>:
.globl vector200
vector200:
  pushl $0
  10237e:	6a 00                	push   $0x0
  pushl $200
  102380:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102385:	e9 02 f8 ff ff       	jmp    101b8c <__alltraps>

0010238a <vector201>:
.globl vector201
vector201:
  pushl $0
  10238a:	6a 00                	push   $0x0
  pushl $201
  10238c:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102391:	e9 f6 f7 ff ff       	jmp    101b8c <__alltraps>

00102396 <vector202>:
.globl vector202
vector202:
  pushl $0
  102396:	6a 00                	push   $0x0
  pushl $202
  102398:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10239d:	e9 ea f7 ff ff       	jmp    101b8c <__alltraps>

001023a2 <vector203>:
.globl vector203
vector203:
  pushl $0
  1023a2:	6a 00                	push   $0x0
  pushl $203
  1023a4:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1023a9:	e9 de f7 ff ff       	jmp    101b8c <__alltraps>

001023ae <vector204>:
.globl vector204
vector204:
  pushl $0
  1023ae:	6a 00                	push   $0x0
  pushl $204
  1023b0:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1023b5:	e9 d2 f7 ff ff       	jmp    101b8c <__alltraps>

001023ba <vector205>:
.globl vector205
vector205:
  pushl $0
  1023ba:	6a 00                	push   $0x0
  pushl $205
  1023bc:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1023c1:	e9 c6 f7 ff ff       	jmp    101b8c <__alltraps>

001023c6 <vector206>:
.globl vector206
vector206:
  pushl $0
  1023c6:	6a 00                	push   $0x0
  pushl $206
  1023c8:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1023cd:	e9 ba f7 ff ff       	jmp    101b8c <__alltraps>

001023d2 <vector207>:
.globl vector207
vector207:
  pushl $0
  1023d2:	6a 00                	push   $0x0
  pushl $207
  1023d4:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1023d9:	e9 ae f7 ff ff       	jmp    101b8c <__alltraps>

001023de <vector208>:
.globl vector208
vector208:
  pushl $0
  1023de:	6a 00                	push   $0x0
  pushl $208
  1023e0:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1023e5:	e9 a2 f7 ff ff       	jmp    101b8c <__alltraps>

001023ea <vector209>:
.globl vector209
vector209:
  pushl $0
  1023ea:	6a 00                	push   $0x0
  pushl $209
  1023ec:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1023f1:	e9 96 f7 ff ff       	jmp    101b8c <__alltraps>

001023f6 <vector210>:
.globl vector210
vector210:
  pushl $0
  1023f6:	6a 00                	push   $0x0
  pushl $210
  1023f8:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1023fd:	e9 8a f7 ff ff       	jmp    101b8c <__alltraps>

00102402 <vector211>:
.globl vector211
vector211:
  pushl $0
  102402:	6a 00                	push   $0x0
  pushl $211
  102404:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102409:	e9 7e f7 ff ff       	jmp    101b8c <__alltraps>

0010240e <vector212>:
.globl vector212
vector212:
  pushl $0
  10240e:	6a 00                	push   $0x0
  pushl $212
  102410:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102415:	e9 72 f7 ff ff       	jmp    101b8c <__alltraps>

0010241a <vector213>:
.globl vector213
vector213:
  pushl $0
  10241a:	6a 00                	push   $0x0
  pushl $213
  10241c:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102421:	e9 66 f7 ff ff       	jmp    101b8c <__alltraps>

00102426 <vector214>:
.globl vector214
vector214:
  pushl $0
  102426:	6a 00                	push   $0x0
  pushl $214
  102428:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  10242d:	e9 5a f7 ff ff       	jmp    101b8c <__alltraps>

00102432 <vector215>:
.globl vector215
vector215:
  pushl $0
  102432:	6a 00                	push   $0x0
  pushl $215
  102434:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102439:	e9 4e f7 ff ff       	jmp    101b8c <__alltraps>

0010243e <vector216>:
.globl vector216
vector216:
  pushl $0
  10243e:	6a 00                	push   $0x0
  pushl $216
  102440:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102445:	e9 42 f7 ff ff       	jmp    101b8c <__alltraps>

0010244a <vector217>:
.globl vector217
vector217:
  pushl $0
  10244a:	6a 00                	push   $0x0
  pushl $217
  10244c:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102451:	e9 36 f7 ff ff       	jmp    101b8c <__alltraps>

00102456 <vector218>:
.globl vector218
vector218:
  pushl $0
  102456:	6a 00                	push   $0x0
  pushl $218
  102458:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  10245d:	e9 2a f7 ff ff       	jmp    101b8c <__alltraps>

00102462 <vector219>:
.globl vector219
vector219:
  pushl $0
  102462:	6a 00                	push   $0x0
  pushl $219
  102464:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102469:	e9 1e f7 ff ff       	jmp    101b8c <__alltraps>

0010246e <vector220>:
.globl vector220
vector220:
  pushl $0
  10246e:	6a 00                	push   $0x0
  pushl $220
  102470:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102475:	e9 12 f7 ff ff       	jmp    101b8c <__alltraps>

0010247a <vector221>:
.globl vector221
vector221:
  pushl $0
  10247a:	6a 00                	push   $0x0
  pushl $221
  10247c:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102481:	e9 06 f7 ff ff       	jmp    101b8c <__alltraps>

00102486 <vector222>:
.globl vector222
vector222:
  pushl $0
  102486:	6a 00                	push   $0x0
  pushl $222
  102488:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10248d:	e9 fa f6 ff ff       	jmp    101b8c <__alltraps>

00102492 <vector223>:
.globl vector223
vector223:
  pushl $0
  102492:	6a 00                	push   $0x0
  pushl $223
  102494:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102499:	e9 ee f6 ff ff       	jmp    101b8c <__alltraps>

0010249e <vector224>:
.globl vector224
vector224:
  pushl $0
  10249e:	6a 00                	push   $0x0
  pushl $224
  1024a0:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1024a5:	e9 e2 f6 ff ff       	jmp    101b8c <__alltraps>

001024aa <vector225>:
.globl vector225
vector225:
  pushl $0
  1024aa:	6a 00                	push   $0x0
  pushl $225
  1024ac:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1024b1:	e9 d6 f6 ff ff       	jmp    101b8c <__alltraps>

001024b6 <vector226>:
.globl vector226
vector226:
  pushl $0
  1024b6:	6a 00                	push   $0x0
  pushl $226
  1024b8:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1024bd:	e9 ca f6 ff ff       	jmp    101b8c <__alltraps>

001024c2 <vector227>:
.globl vector227
vector227:
  pushl $0
  1024c2:	6a 00                	push   $0x0
  pushl $227
  1024c4:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1024c9:	e9 be f6 ff ff       	jmp    101b8c <__alltraps>

001024ce <vector228>:
.globl vector228
vector228:
  pushl $0
  1024ce:	6a 00                	push   $0x0
  pushl $228
  1024d0:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1024d5:	e9 b2 f6 ff ff       	jmp    101b8c <__alltraps>

001024da <vector229>:
.globl vector229
vector229:
  pushl $0
  1024da:	6a 00                	push   $0x0
  pushl $229
  1024dc:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1024e1:	e9 a6 f6 ff ff       	jmp    101b8c <__alltraps>

001024e6 <vector230>:
.globl vector230
vector230:
  pushl $0
  1024e6:	6a 00                	push   $0x0
  pushl $230
  1024e8:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1024ed:	e9 9a f6 ff ff       	jmp    101b8c <__alltraps>

001024f2 <vector231>:
.globl vector231
vector231:
  pushl $0
  1024f2:	6a 00                	push   $0x0
  pushl $231
  1024f4:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1024f9:	e9 8e f6 ff ff       	jmp    101b8c <__alltraps>

001024fe <vector232>:
.globl vector232
vector232:
  pushl $0
  1024fe:	6a 00                	push   $0x0
  pushl $232
  102500:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102505:	e9 82 f6 ff ff       	jmp    101b8c <__alltraps>

0010250a <vector233>:
.globl vector233
vector233:
  pushl $0
  10250a:	6a 00                	push   $0x0
  pushl $233
  10250c:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102511:	e9 76 f6 ff ff       	jmp    101b8c <__alltraps>

00102516 <vector234>:
.globl vector234
vector234:
  pushl $0
  102516:	6a 00                	push   $0x0
  pushl $234
  102518:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  10251d:	e9 6a f6 ff ff       	jmp    101b8c <__alltraps>

00102522 <vector235>:
.globl vector235
vector235:
  pushl $0
  102522:	6a 00                	push   $0x0
  pushl $235
  102524:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102529:	e9 5e f6 ff ff       	jmp    101b8c <__alltraps>

0010252e <vector236>:
.globl vector236
vector236:
  pushl $0
  10252e:	6a 00                	push   $0x0
  pushl $236
  102530:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102535:	e9 52 f6 ff ff       	jmp    101b8c <__alltraps>

0010253a <vector237>:
.globl vector237
vector237:
  pushl $0
  10253a:	6a 00                	push   $0x0
  pushl $237
  10253c:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102541:	e9 46 f6 ff ff       	jmp    101b8c <__alltraps>

00102546 <vector238>:
.globl vector238
vector238:
  pushl $0
  102546:	6a 00                	push   $0x0
  pushl $238
  102548:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  10254d:	e9 3a f6 ff ff       	jmp    101b8c <__alltraps>

00102552 <vector239>:
.globl vector239
vector239:
  pushl $0
  102552:	6a 00                	push   $0x0
  pushl $239
  102554:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102559:	e9 2e f6 ff ff       	jmp    101b8c <__alltraps>

0010255e <vector240>:
.globl vector240
vector240:
  pushl $0
  10255e:	6a 00                	push   $0x0
  pushl $240
  102560:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102565:	e9 22 f6 ff ff       	jmp    101b8c <__alltraps>

0010256a <vector241>:
.globl vector241
vector241:
  pushl $0
  10256a:	6a 00                	push   $0x0
  pushl $241
  10256c:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102571:	e9 16 f6 ff ff       	jmp    101b8c <__alltraps>

00102576 <vector242>:
.globl vector242
vector242:
  pushl $0
  102576:	6a 00                	push   $0x0
  pushl $242
  102578:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10257d:	e9 0a f6 ff ff       	jmp    101b8c <__alltraps>

00102582 <vector243>:
.globl vector243
vector243:
  pushl $0
  102582:	6a 00                	push   $0x0
  pushl $243
  102584:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102589:	e9 fe f5 ff ff       	jmp    101b8c <__alltraps>

0010258e <vector244>:
.globl vector244
vector244:
  pushl $0
  10258e:	6a 00                	push   $0x0
  pushl $244
  102590:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102595:	e9 f2 f5 ff ff       	jmp    101b8c <__alltraps>

0010259a <vector245>:
.globl vector245
vector245:
  pushl $0
  10259a:	6a 00                	push   $0x0
  pushl $245
  10259c:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1025a1:	e9 e6 f5 ff ff       	jmp    101b8c <__alltraps>

001025a6 <vector246>:
.globl vector246
vector246:
  pushl $0
  1025a6:	6a 00                	push   $0x0
  pushl $246
  1025a8:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1025ad:	e9 da f5 ff ff       	jmp    101b8c <__alltraps>

001025b2 <vector247>:
.globl vector247
vector247:
  pushl $0
  1025b2:	6a 00                	push   $0x0
  pushl $247
  1025b4:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1025b9:	e9 ce f5 ff ff       	jmp    101b8c <__alltraps>

001025be <vector248>:
.globl vector248
vector248:
  pushl $0
  1025be:	6a 00                	push   $0x0
  pushl $248
  1025c0:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1025c5:	e9 c2 f5 ff ff       	jmp    101b8c <__alltraps>

001025ca <vector249>:
.globl vector249
vector249:
  pushl $0
  1025ca:	6a 00                	push   $0x0
  pushl $249
  1025cc:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1025d1:	e9 b6 f5 ff ff       	jmp    101b8c <__alltraps>

001025d6 <vector250>:
.globl vector250
vector250:
  pushl $0
  1025d6:	6a 00                	push   $0x0
  pushl $250
  1025d8:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1025dd:	e9 aa f5 ff ff       	jmp    101b8c <__alltraps>

001025e2 <vector251>:
.globl vector251
vector251:
  pushl $0
  1025e2:	6a 00                	push   $0x0
  pushl $251
  1025e4:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1025e9:	e9 9e f5 ff ff       	jmp    101b8c <__alltraps>

001025ee <vector252>:
.globl vector252
vector252:
  pushl $0
  1025ee:	6a 00                	push   $0x0
  pushl $252
  1025f0:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1025f5:	e9 92 f5 ff ff       	jmp    101b8c <__alltraps>

001025fa <vector253>:
.globl vector253
vector253:
  pushl $0
  1025fa:	6a 00                	push   $0x0
  pushl $253
  1025fc:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102601:	e9 86 f5 ff ff       	jmp    101b8c <__alltraps>

00102606 <vector254>:
.globl vector254
vector254:
  pushl $0
  102606:	6a 00                	push   $0x0
  pushl $254
  102608:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10260d:	e9 7a f5 ff ff       	jmp    101b8c <__alltraps>

00102612 <vector255>:
.globl vector255
vector255:
  pushl $0
  102612:	6a 00                	push   $0x0
  pushl $255
  102614:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102619:	e9 6e f5 ff ff       	jmp    101b8c <__alltraps>

0010261e <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  10261e:	55                   	push   %ebp
  10261f:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102621:	8b 55 08             	mov    0x8(%ebp),%edx
  102624:	a1 64 79 11 00       	mov    0x117964,%eax
  102629:	29 c2                	sub    %eax,%edx
  10262b:	89 d0                	mov    %edx,%eax
  10262d:	c1 f8 02             	sar    $0x2,%eax
  102630:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102636:	5d                   	pop    %ebp
  102637:	c3                   	ret    

00102638 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102638:	55                   	push   %ebp
  102639:	89 e5                	mov    %esp,%ebp
  10263b:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  10263e:	8b 45 08             	mov    0x8(%ebp),%eax
  102641:	89 04 24             	mov    %eax,(%esp)
  102644:	e8 d5 ff ff ff       	call   10261e <page2ppn>
  102649:	c1 e0 0c             	shl    $0xc,%eax
}
  10264c:	c9                   	leave  
  10264d:	c3                   	ret    

0010264e <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  10264e:	55                   	push   %ebp
  10264f:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102651:	8b 45 08             	mov    0x8(%ebp),%eax
  102654:	8b 00                	mov    (%eax),%eax
}
  102656:	5d                   	pop    %ebp
  102657:	c3                   	ret    

00102658 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102658:	55                   	push   %ebp
  102659:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  10265b:	8b 45 08             	mov    0x8(%ebp),%eax
  10265e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102661:	89 10                	mov    %edx,(%eax)
}
  102663:	5d                   	pop    %ebp
  102664:	c3                   	ret    

00102665 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  102665:	55                   	push   %ebp
  102666:	89 e5                	mov    %esp,%ebp
  102668:	83 ec 10             	sub    $0x10,%esp
  10266b:	c7 45 fc 50 79 11 00 	movl   $0x117950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102672:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102675:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102678:	89 50 04             	mov    %edx,0x4(%eax)
  10267b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10267e:	8b 50 04             	mov    0x4(%eax),%edx
  102681:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102684:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  102686:	c7 05 58 79 11 00 00 	movl   $0x0,0x117958
  10268d:	00 00 00 
}
  102690:	c9                   	leave  
  102691:	c3                   	ret    

00102692 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  102692:	55                   	push   %ebp
  102693:	89 e5                	mov    %esp,%ebp
  102695:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  102698:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10269c:	75 24                	jne    1026c2 <default_init_memmap+0x30>
  10269e:	c7 44 24 0c 70 62 10 	movl   $0x106270,0xc(%esp)
  1026a5:	00 
  1026a6:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  1026ad:	00 
  1026ae:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  1026b5:	00 
  1026b6:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1026bd:	e8 4a e5 ff ff       	call   100c0c <__panic>
    struct Page *p = base;
  1026c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1026c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1026c8:	eb 7d                	jmp    102747 <default_init_memmap+0xb5>
        assert(PageReserved(p));
  1026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1026cd:	83 c0 04             	add    $0x4,%eax
  1026d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1026d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1026da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1026dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1026e0:	0f a3 10             	bt     %edx,(%eax)
  1026e3:	19 c0                	sbb    %eax,%eax
  1026e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1026e8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1026ec:	0f 95 c0             	setne  %al
  1026ef:	0f b6 c0             	movzbl %al,%eax
  1026f2:	85 c0                	test   %eax,%eax
  1026f4:	75 24                	jne    10271a <default_init_memmap+0x88>
  1026f6:	c7 44 24 0c a1 62 10 	movl   $0x1062a1,0xc(%esp)
  1026fd:	00 
  1026fe:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102705:	00 
  102706:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  10270d:	00 
  10270e:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102715:	e8 f2 e4 ff ff       	call   100c0c <__panic>
        p->flags = p->property = 0;
  10271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10271d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  102724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102727:	8b 50 08             	mov    0x8(%eax),%edx
  10272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10272d:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  102730:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102737:	00 
  102738:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10273b:	89 04 24             	mov    %eax,(%esp)
  10273e:	e8 15 ff ff ff       	call   102658 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102743:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102747:	8b 55 0c             	mov    0xc(%ebp),%edx
  10274a:	89 d0                	mov    %edx,%eax
  10274c:	c1 e0 02             	shl    $0x2,%eax
  10274f:	01 d0                	add    %edx,%eax
  102751:	c1 e0 02             	shl    $0x2,%eax
  102754:	89 c2                	mov    %eax,%edx
  102756:	8b 45 08             	mov    0x8(%ebp),%eax
  102759:	01 d0                	add    %edx,%eax
  10275b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10275e:	0f 85 66 ff ff ff    	jne    1026ca <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102764:	8b 45 08             	mov    0x8(%ebp),%eax
  102767:	8b 55 0c             	mov    0xc(%ebp),%edx
  10276a:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  10276d:	8b 45 08             	mov    0x8(%ebp),%eax
  102770:	83 c0 04             	add    $0x4,%eax
  102773:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  10277a:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10277d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102780:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102783:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  102786:	8b 15 58 79 11 00    	mov    0x117958,%edx
  10278c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10278f:	01 d0                	add    %edx,%eax
  102791:	a3 58 79 11 00       	mov    %eax,0x117958
    list_add(&free_list, &(base->page_link));
  102796:	8b 45 08             	mov    0x8(%ebp),%eax
  102799:	83 c0 0c             	add    $0xc,%eax
  10279c:	c7 45 dc 50 79 11 00 	movl   $0x117950,-0x24(%ebp)
  1027a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1027a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1027a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1027ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1027af:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1027b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1027b5:	8b 40 04             	mov    0x4(%eax),%eax
  1027b8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1027bb:	89 55 cc             	mov    %edx,-0x34(%ebp)
  1027be:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1027c1:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1027c4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1027c7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1027ca:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1027cd:	89 10                	mov    %edx,(%eax)
  1027cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1027d2:	8b 10                	mov    (%eax),%edx
  1027d4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1027d7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1027da:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1027dd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1027e0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1027e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1027e6:	8b 55 c8             	mov    -0x38(%ebp),%edx
  1027e9:	89 10                	mov    %edx,(%eax)
}
  1027eb:	c9                   	leave  
  1027ec:	c3                   	ret    

001027ed <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  1027ed:	55                   	push   %ebp
  1027ee:	89 e5                	mov    %esp,%ebp
  1027f0:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  1027f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1027f7:	75 24                	jne    10281d <default_alloc_pages+0x30>
  1027f9:	c7 44 24 0c 70 62 10 	movl   $0x106270,0xc(%esp)
  102800:	00 
  102801:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102808:	00 
  102809:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
  102810:	00 
  102811:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102818:	e8 ef e3 ff ff       	call   100c0c <__panic>
    if (n > nr_free) {
  10281d:	a1 58 79 11 00       	mov    0x117958,%eax
  102822:	3b 45 08             	cmp    0x8(%ebp),%eax
  102825:	73 0a                	jae    102831 <default_alloc_pages+0x44>
        return NULL;
  102827:	b8 00 00 00 00       	mov    $0x0,%eax
  10282c:	e9 2a 01 00 00       	jmp    10295b <default_alloc_pages+0x16e>
    }
    struct Page *page = NULL;
  102831:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102838:	c7 45 f0 50 79 11 00 	movl   $0x117950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10283f:	eb 1c                	jmp    10285d <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102844:	83 e8 0c             	sub    $0xc,%eax
  102847:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  10284a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10284d:	8b 40 08             	mov    0x8(%eax),%eax
  102850:	3b 45 08             	cmp    0x8(%ebp),%eax
  102853:	72 08                	jb     10285d <default_alloc_pages+0x70>
            page = p;
  102855:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102858:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  10285b:	eb 18                	jmp    102875 <default_alloc_pages+0x88>
  10285d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102860:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102863:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102866:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102869:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10286c:	81 7d f0 50 79 11 00 	cmpl   $0x117950,-0x10(%ebp)
  102873:	75 cc                	jne    102841 <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
  102875:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102879:	0f 84 d9 00 00 00    	je     102958 <default_alloc_pages+0x16b>
        list_del(&(page->page_link));
  10287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102882:	83 c0 0c             	add    $0xc,%eax
  102885:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102888:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10288b:	8b 40 04             	mov    0x4(%eax),%eax
  10288e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102891:	8b 12                	mov    (%edx),%edx
  102893:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102896:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102899:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10289c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10289f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1028a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1028a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1028a8:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
  1028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028ad:	8b 40 08             	mov    0x8(%eax),%eax
  1028b0:	3b 45 08             	cmp    0x8(%ebp),%eax
  1028b3:	76 7d                	jbe    102932 <default_alloc_pages+0x145>
            struct Page *p = page + n;
  1028b5:	8b 55 08             	mov    0x8(%ebp),%edx
  1028b8:	89 d0                	mov    %edx,%eax
  1028ba:	c1 e0 02             	shl    $0x2,%eax
  1028bd:	01 d0                	add    %edx,%eax
  1028bf:	c1 e0 02             	shl    $0x2,%eax
  1028c2:	89 c2                	mov    %eax,%edx
  1028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028c7:	01 d0                	add    %edx,%eax
  1028c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  1028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028cf:	8b 40 08             	mov    0x8(%eax),%eax
  1028d2:	2b 45 08             	sub    0x8(%ebp),%eax
  1028d5:	89 c2                	mov    %eax,%edx
  1028d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1028da:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
  1028dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1028e0:	83 c0 0c             	add    $0xc,%eax
  1028e3:	c7 45 d4 50 79 11 00 	movl   $0x117950,-0x2c(%ebp)
  1028ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1028ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1028f0:	89 45 cc             	mov    %eax,-0x34(%ebp)
  1028f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1028f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1028f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1028fc:	8b 40 04             	mov    0x4(%eax),%eax
  1028ff:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102902:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102905:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102908:	89 55 c0             	mov    %edx,-0x40(%ebp)
  10290b:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  10290e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102911:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102914:	89 10                	mov    %edx,(%eax)
  102916:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102919:	8b 10                	mov    (%eax),%edx
  10291b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10291e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102921:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102924:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102927:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10292a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10292d:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102930:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
  102932:	a1 58 79 11 00       	mov    0x117958,%eax
  102937:	2b 45 08             	sub    0x8(%ebp),%eax
  10293a:	a3 58 79 11 00       	mov    %eax,0x117958
        ClearPageProperty(page);
  10293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102942:	83 c0 04             	add    $0x4,%eax
  102945:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  10294c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10294f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102952:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102955:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  102958:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10295b:	c9                   	leave  
  10295c:	c3                   	ret    

0010295d <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  10295d:	55                   	push   %ebp
  10295e:	89 e5                	mov    %esp,%ebp
  102960:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  102966:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10296a:	75 24                	jne    102990 <default_free_pages+0x33>
  10296c:	c7 44 24 0c 70 62 10 	movl   $0x106270,0xc(%esp)
  102973:	00 
  102974:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  10297b:	00 
  10297c:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
  102983:	00 
  102984:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  10298b:	e8 7c e2 ff ff       	call   100c0c <__panic>
    struct Page *p = base;
  102990:	8b 45 08             	mov    0x8(%ebp),%eax
  102993:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102996:	e9 9d 00 00 00       	jmp    102a38 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  10299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10299e:	83 c0 04             	add    $0x4,%eax
  1029a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1029a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1029ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1029ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1029b1:	0f a3 10             	bt     %edx,(%eax)
  1029b4:	19 c0                	sbb    %eax,%eax
  1029b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  1029b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1029bd:	0f 95 c0             	setne  %al
  1029c0:	0f b6 c0             	movzbl %al,%eax
  1029c3:	85 c0                	test   %eax,%eax
  1029c5:	75 2c                	jne    1029f3 <default_free_pages+0x96>
  1029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029ca:	83 c0 04             	add    $0x4,%eax
  1029cd:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  1029d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1029d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029da:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1029dd:	0f a3 10             	bt     %edx,(%eax)
  1029e0:	19 c0                	sbb    %eax,%eax
  1029e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  1029e5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  1029e9:	0f 95 c0             	setne  %al
  1029ec:	0f b6 c0             	movzbl %al,%eax
  1029ef:	85 c0                	test   %eax,%eax
  1029f1:	74 24                	je     102a17 <default_free_pages+0xba>
  1029f3:	c7 44 24 0c b4 62 10 	movl   $0x1062b4,0xc(%esp)
  1029fa:	00 
  1029fb:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102a02:	00 
  102a03:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
  102a0a:	00 
  102a0b:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102a12:	e8 f5 e1 ff ff       	call   100c0c <__panic>
        p->flags = 0;
  102a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102a21:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102a28:	00 
  102a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a2c:	89 04 24             	mov    %eax,(%esp)
  102a2f:	e8 24 fc ff ff       	call   102658 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102a34:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102a38:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a3b:	89 d0                	mov    %edx,%eax
  102a3d:	c1 e0 02             	shl    $0x2,%eax
  102a40:	01 d0                	add    %edx,%eax
  102a42:	c1 e0 02             	shl    $0x2,%eax
  102a45:	89 c2                	mov    %eax,%edx
  102a47:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4a:	01 d0                	add    %edx,%eax
  102a4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102a4f:	0f 85 46 ff ff ff    	jne    10299b <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102a55:	8b 45 08             	mov    0x8(%ebp),%eax
  102a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a5b:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  102a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a61:	83 c0 04             	add    $0x4,%eax
  102a64:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  102a6b:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102a6e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102a71:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a74:	0f ab 10             	bts    %edx,(%eax)
  102a77:	c7 45 cc 50 79 11 00 	movl   $0x117950,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102a7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a81:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  102a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102a87:	e9 08 01 00 00       	jmp    102b94 <default_free_pages+0x237>
        p = le2page(le, page_link);
  102a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a8f:	83 e8 0c             	sub    $0xc,%eax
  102a92:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102a98:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102a9b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102a9e:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  102aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  102aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa7:	8b 50 08             	mov    0x8(%eax),%edx
  102aaa:	89 d0                	mov    %edx,%eax
  102aac:	c1 e0 02             	shl    $0x2,%eax
  102aaf:	01 d0                	add    %edx,%eax
  102ab1:	c1 e0 02             	shl    $0x2,%eax
  102ab4:	89 c2                	mov    %eax,%edx
  102ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab9:	01 d0                	add    %edx,%eax
  102abb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102abe:	75 5a                	jne    102b1a <default_free_pages+0x1bd>
            base->property += p->property;
  102ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac3:	8b 50 08             	mov    0x8(%eax),%edx
  102ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ac9:	8b 40 08             	mov    0x8(%eax),%eax
  102acc:	01 c2                	add    %eax,%edx
  102ace:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad1:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  102ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ad7:	83 c0 04             	add    $0x4,%eax
  102ada:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  102ae1:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102ae4:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102ae7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102aea:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  102aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102af0:	83 c0 0c             	add    $0xc,%eax
  102af3:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102af6:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102af9:	8b 40 04             	mov    0x4(%eax),%eax
  102afc:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102aff:	8b 12                	mov    (%edx),%edx
  102b01:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102b04:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102b07:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102b0a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102b0d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102b10:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102b13:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102b16:	89 10                	mov    %edx,(%eax)
  102b18:	eb 7a                	jmp    102b94 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
  102b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b1d:	8b 50 08             	mov    0x8(%eax),%edx
  102b20:	89 d0                	mov    %edx,%eax
  102b22:	c1 e0 02             	shl    $0x2,%eax
  102b25:	01 d0                	add    %edx,%eax
  102b27:	c1 e0 02             	shl    $0x2,%eax
  102b2a:	89 c2                	mov    %eax,%edx
  102b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b2f:	01 d0                	add    %edx,%eax
  102b31:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b34:	75 5e                	jne    102b94 <default_free_pages+0x237>
            p->property += base->property;
  102b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b39:	8b 50 08             	mov    0x8(%eax),%edx
  102b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b3f:	8b 40 08             	mov    0x8(%eax),%eax
  102b42:	01 c2                	add    %eax,%edx
  102b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b47:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  102b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  102b4d:	83 c0 04             	add    $0x4,%eax
  102b50:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  102b57:	89 45 ac             	mov    %eax,-0x54(%ebp)
  102b5a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102b5d:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102b60:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  102b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b66:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  102b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b6c:	83 c0 0c             	add    $0xc,%eax
  102b6f:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102b72:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102b75:	8b 40 04             	mov    0x4(%eax),%eax
  102b78:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102b7b:	8b 12                	mov    (%edx),%edx
  102b7d:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102b80:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102b83:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102b86:	8b 55 a0             	mov    -0x60(%ebp),%edx
  102b89:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102b8c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102b8f:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102b92:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
  102b94:	81 7d f0 50 79 11 00 	cmpl   $0x117950,-0x10(%ebp)
  102b9b:	0f 85 eb fe ff ff    	jne    102a8c <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
  102ba1:	8b 15 58 79 11 00    	mov    0x117958,%edx
  102ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102baa:	01 d0                	add    %edx,%eax
  102bac:	a3 58 79 11 00       	mov    %eax,0x117958
    list_add(&free_list, &(base->page_link));
  102bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  102bb4:	83 c0 0c             	add    $0xc,%eax
  102bb7:	c7 45 9c 50 79 11 00 	movl   $0x117950,-0x64(%ebp)
  102bbe:	89 45 98             	mov    %eax,-0x68(%ebp)
  102bc1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  102bc4:	89 45 94             	mov    %eax,-0x6c(%ebp)
  102bc7:	8b 45 98             	mov    -0x68(%ebp),%eax
  102bca:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102bcd:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102bd0:	8b 40 04             	mov    0x4(%eax),%eax
  102bd3:	8b 55 90             	mov    -0x70(%ebp),%edx
  102bd6:	89 55 8c             	mov    %edx,-0x74(%ebp)
  102bd9:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102bdc:	89 55 88             	mov    %edx,-0x78(%ebp)
  102bdf:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102be2:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102be5:	8b 55 8c             	mov    -0x74(%ebp),%edx
  102be8:	89 10                	mov    %edx,(%eax)
  102bea:	8b 45 84             	mov    -0x7c(%ebp),%eax
  102bed:	8b 10                	mov    (%eax),%edx
  102bef:	8b 45 88             	mov    -0x78(%ebp),%eax
  102bf2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102bf5:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102bf8:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102bfb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102bfe:	8b 45 8c             	mov    -0x74(%ebp),%eax
  102c01:	8b 55 88             	mov    -0x78(%ebp),%edx
  102c04:	89 10                	mov    %edx,(%eax)
}
  102c06:	c9                   	leave  
  102c07:	c3                   	ret    

00102c08 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102c08:	55                   	push   %ebp
  102c09:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102c0b:	a1 58 79 11 00       	mov    0x117958,%eax
}
  102c10:	5d                   	pop    %ebp
  102c11:	c3                   	ret    

00102c12 <basic_check>:

static void
basic_check(void) {
  102c12:	55                   	push   %ebp
  102c13:	89 e5                	mov    %esp,%ebp
  102c15:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102c18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c22:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c28:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102c2b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102c32:	e8 78 0e 00 00       	call   103aaf <alloc_pages>
  102c37:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102c3a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102c3e:	75 24                	jne    102c64 <basic_check+0x52>
  102c40:	c7 44 24 0c d9 62 10 	movl   $0x1062d9,0xc(%esp)
  102c47:	00 
  102c48:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102c4f:	00 
  102c50:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
  102c57:	00 
  102c58:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102c5f:	e8 a8 df ff ff       	call   100c0c <__panic>
    assert((p1 = alloc_page()) != NULL);
  102c64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102c6b:	e8 3f 0e 00 00       	call   103aaf <alloc_pages>
  102c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102c77:	75 24                	jne    102c9d <basic_check+0x8b>
  102c79:	c7 44 24 0c f5 62 10 	movl   $0x1062f5,0xc(%esp)
  102c80:	00 
  102c81:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102c88:	00 
  102c89:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
  102c90:	00 
  102c91:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102c98:	e8 6f df ff ff       	call   100c0c <__panic>
    assert((p2 = alloc_page()) != NULL);
  102c9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102ca4:	e8 06 0e 00 00       	call   103aaf <alloc_pages>
  102ca9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102cac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102cb0:	75 24                	jne    102cd6 <basic_check+0xc4>
  102cb2:	c7 44 24 0c 11 63 10 	movl   $0x106311,0xc(%esp)
  102cb9:	00 
  102cba:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102cc1:	00 
  102cc2:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
  102cc9:	00 
  102cca:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102cd1:	e8 36 df ff ff       	call   100c0c <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102cd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102cd9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102cdc:	74 10                	je     102cee <basic_check+0xdc>
  102cde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ce1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ce4:	74 08                	je     102cee <basic_check+0xdc>
  102ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ce9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102cec:	75 24                	jne    102d12 <basic_check+0x100>
  102cee:	c7 44 24 0c 30 63 10 	movl   $0x106330,0xc(%esp)
  102cf5:	00 
  102cf6:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102cfd:	00 
  102cfe:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  102d05:	00 
  102d06:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102d0d:	e8 fa de ff ff       	call   100c0c <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102d12:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d15:	89 04 24             	mov    %eax,(%esp)
  102d18:	e8 31 f9 ff ff       	call   10264e <page_ref>
  102d1d:	85 c0                	test   %eax,%eax
  102d1f:	75 1e                	jne    102d3f <basic_check+0x12d>
  102d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d24:	89 04 24             	mov    %eax,(%esp)
  102d27:	e8 22 f9 ff ff       	call   10264e <page_ref>
  102d2c:	85 c0                	test   %eax,%eax
  102d2e:	75 0f                	jne    102d3f <basic_check+0x12d>
  102d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d33:	89 04 24             	mov    %eax,(%esp)
  102d36:	e8 13 f9 ff ff       	call   10264e <page_ref>
  102d3b:	85 c0                	test   %eax,%eax
  102d3d:	74 24                	je     102d63 <basic_check+0x151>
  102d3f:	c7 44 24 0c 54 63 10 	movl   $0x106354,0xc(%esp)
  102d46:	00 
  102d47:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102d4e:	00 
  102d4f:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
  102d56:	00 
  102d57:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102d5e:	e8 a9 de ff ff       	call   100c0c <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102d63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d66:	89 04 24             	mov    %eax,(%esp)
  102d69:	e8 ca f8 ff ff       	call   102638 <page2pa>
  102d6e:	8b 15 c0 78 11 00    	mov    0x1178c0,%edx
  102d74:	c1 e2 0c             	shl    $0xc,%edx
  102d77:	39 d0                	cmp    %edx,%eax
  102d79:	72 24                	jb     102d9f <basic_check+0x18d>
  102d7b:	c7 44 24 0c 90 63 10 	movl   $0x106390,0xc(%esp)
  102d82:	00 
  102d83:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102d8a:	00 
  102d8b:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
  102d92:	00 
  102d93:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102d9a:	e8 6d de ff ff       	call   100c0c <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102da2:	89 04 24             	mov    %eax,(%esp)
  102da5:	e8 8e f8 ff ff       	call   102638 <page2pa>
  102daa:	8b 15 c0 78 11 00    	mov    0x1178c0,%edx
  102db0:	c1 e2 0c             	shl    $0xc,%edx
  102db3:	39 d0                	cmp    %edx,%eax
  102db5:	72 24                	jb     102ddb <basic_check+0x1c9>
  102db7:	c7 44 24 0c ad 63 10 	movl   $0x1063ad,0xc(%esp)
  102dbe:	00 
  102dbf:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102dc6:	00 
  102dc7:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
  102dce:	00 
  102dcf:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102dd6:	e8 31 de ff ff       	call   100c0c <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  102ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dde:	89 04 24             	mov    %eax,(%esp)
  102de1:	e8 52 f8 ff ff       	call   102638 <page2pa>
  102de6:	8b 15 c0 78 11 00    	mov    0x1178c0,%edx
  102dec:	c1 e2 0c             	shl    $0xc,%edx
  102def:	39 d0                	cmp    %edx,%eax
  102df1:	72 24                	jb     102e17 <basic_check+0x205>
  102df3:	c7 44 24 0c ca 63 10 	movl   $0x1063ca,0xc(%esp)
  102dfa:	00 
  102dfb:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102e02:	00 
  102e03:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
  102e0a:	00 
  102e0b:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102e12:	e8 f5 dd ff ff       	call   100c0c <__panic>

    list_entry_t free_list_store = free_list;
  102e17:	a1 50 79 11 00       	mov    0x117950,%eax
  102e1c:	8b 15 54 79 11 00    	mov    0x117954,%edx
  102e22:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102e25:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102e28:	c7 45 e0 50 79 11 00 	movl   $0x117950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102e2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e32:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102e35:	89 50 04             	mov    %edx,0x4(%eax)
  102e38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e3b:	8b 50 04             	mov    0x4(%eax),%edx
  102e3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e41:	89 10                	mov    %edx,(%eax)
  102e43:	c7 45 dc 50 79 11 00 	movl   $0x117950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  102e4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102e4d:	8b 40 04             	mov    0x4(%eax),%eax
  102e50:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102e53:	0f 94 c0             	sete   %al
  102e56:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  102e59:	85 c0                	test   %eax,%eax
  102e5b:	75 24                	jne    102e81 <basic_check+0x26f>
  102e5d:	c7 44 24 0c e7 63 10 	movl   $0x1063e7,0xc(%esp)
  102e64:	00 
  102e65:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102e6c:	00 
  102e6d:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
  102e74:	00 
  102e75:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102e7c:	e8 8b dd ff ff       	call   100c0c <__panic>

    unsigned int nr_free_store = nr_free;
  102e81:	a1 58 79 11 00       	mov    0x117958,%eax
  102e86:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  102e89:	c7 05 58 79 11 00 00 	movl   $0x0,0x117958
  102e90:	00 00 00 

    assert(alloc_page() == NULL);
  102e93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e9a:	e8 10 0c 00 00       	call   103aaf <alloc_pages>
  102e9f:	85 c0                	test   %eax,%eax
  102ea1:	74 24                	je     102ec7 <basic_check+0x2b5>
  102ea3:	c7 44 24 0c fe 63 10 	movl   $0x1063fe,0xc(%esp)
  102eaa:	00 
  102eab:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102eb2:	00 
  102eb3:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
  102eba:	00 
  102ebb:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102ec2:	e8 45 dd ff ff       	call   100c0c <__panic>

    free_page(p0);
  102ec7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  102ece:	00 
  102ecf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ed2:	89 04 24             	mov    %eax,(%esp)
  102ed5:	e8 0d 0c 00 00       	call   103ae7 <free_pages>
    free_page(p1);
  102eda:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  102ee1:	00 
  102ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ee5:	89 04 24             	mov    %eax,(%esp)
  102ee8:	e8 fa 0b 00 00       	call   103ae7 <free_pages>
    free_page(p2);
  102eed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  102ef4:	00 
  102ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ef8:	89 04 24             	mov    %eax,(%esp)
  102efb:	e8 e7 0b 00 00       	call   103ae7 <free_pages>
    assert(nr_free == 3);
  102f00:	a1 58 79 11 00       	mov    0x117958,%eax
  102f05:	83 f8 03             	cmp    $0x3,%eax
  102f08:	74 24                	je     102f2e <basic_check+0x31c>
  102f0a:	c7 44 24 0c 13 64 10 	movl   $0x106413,0xc(%esp)
  102f11:	00 
  102f12:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102f19:	00 
  102f1a:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  102f21:	00 
  102f22:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102f29:	e8 de dc ff ff       	call   100c0c <__panic>

    assert((p0 = alloc_page()) != NULL);
  102f2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f35:	e8 75 0b 00 00       	call   103aaf <alloc_pages>
  102f3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102f41:	75 24                	jne    102f67 <basic_check+0x355>
  102f43:	c7 44 24 0c d9 62 10 	movl   $0x1062d9,0xc(%esp)
  102f4a:	00 
  102f4b:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102f52:	00 
  102f53:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
  102f5a:	00 
  102f5b:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102f62:	e8 a5 dc ff ff       	call   100c0c <__panic>
    assert((p1 = alloc_page()) != NULL);
  102f67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102f6e:	e8 3c 0b 00 00       	call   103aaf <alloc_pages>
  102f73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102f7a:	75 24                	jne    102fa0 <basic_check+0x38e>
  102f7c:	c7 44 24 0c f5 62 10 	movl   $0x1062f5,0xc(%esp)
  102f83:	00 
  102f84:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102f8b:	00 
  102f8c:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  102f93:	00 
  102f94:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102f9b:	e8 6c dc ff ff       	call   100c0c <__panic>
    assert((p2 = alloc_page()) != NULL);
  102fa0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102fa7:	e8 03 0b 00 00       	call   103aaf <alloc_pages>
  102fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102faf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102fb3:	75 24                	jne    102fd9 <basic_check+0x3c7>
  102fb5:	c7 44 24 0c 11 63 10 	movl   $0x106311,0xc(%esp)
  102fbc:	00 
  102fbd:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102fc4:	00 
  102fc5:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
  102fcc:	00 
  102fcd:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  102fd4:	e8 33 dc ff ff       	call   100c0c <__panic>

    assert(alloc_page() == NULL);
  102fd9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102fe0:	e8 ca 0a 00 00       	call   103aaf <alloc_pages>
  102fe5:	85 c0                	test   %eax,%eax
  102fe7:	74 24                	je     10300d <basic_check+0x3fb>
  102fe9:	c7 44 24 0c fe 63 10 	movl   $0x1063fe,0xc(%esp)
  102ff0:	00 
  102ff1:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  102ff8:	00 
  102ff9:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
  103000:	00 
  103001:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  103008:	e8 ff db ff ff       	call   100c0c <__panic>

    free_page(p0);
  10300d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103014:	00 
  103015:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103018:	89 04 24             	mov    %eax,(%esp)
  10301b:	e8 c7 0a 00 00       	call   103ae7 <free_pages>
  103020:	c7 45 d8 50 79 11 00 	movl   $0x117950,-0x28(%ebp)
  103027:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10302a:	8b 40 04             	mov    0x4(%eax),%eax
  10302d:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103030:	0f 94 c0             	sete   %al
  103033:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  103036:	85 c0                	test   %eax,%eax
  103038:	74 24                	je     10305e <basic_check+0x44c>
  10303a:	c7 44 24 0c 20 64 10 	movl   $0x106420,0xc(%esp)
  103041:	00 
  103042:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  103049:	00 
  10304a:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
  103051:	00 
  103052:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  103059:	e8 ae db ff ff       	call   100c0c <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  10305e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103065:	e8 45 0a 00 00       	call   103aaf <alloc_pages>
  10306a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10306d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103070:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103073:	74 24                	je     103099 <basic_check+0x487>
  103075:	c7 44 24 0c 38 64 10 	movl   $0x106438,0xc(%esp)
  10307c:	00 
  10307d:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  103084:	00 
  103085:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  10308c:	00 
  10308d:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  103094:	e8 73 db ff ff       	call   100c0c <__panic>
    assert(alloc_page() == NULL);
  103099:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030a0:	e8 0a 0a 00 00       	call   103aaf <alloc_pages>
  1030a5:	85 c0                	test   %eax,%eax
  1030a7:	74 24                	je     1030cd <basic_check+0x4bb>
  1030a9:	c7 44 24 0c fe 63 10 	movl   $0x1063fe,0xc(%esp)
  1030b0:	00 
  1030b1:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  1030b8:	00 
  1030b9:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  1030c0:	00 
  1030c1:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1030c8:	e8 3f db ff ff       	call   100c0c <__panic>

    assert(nr_free == 0);
  1030cd:	a1 58 79 11 00       	mov    0x117958,%eax
  1030d2:	85 c0                	test   %eax,%eax
  1030d4:	74 24                	je     1030fa <basic_check+0x4e8>
  1030d6:	c7 44 24 0c 51 64 10 	movl   $0x106451,0xc(%esp)
  1030dd:	00 
  1030de:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  1030e5:	00 
  1030e6:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
  1030ed:	00 
  1030ee:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1030f5:	e8 12 db ff ff       	call   100c0c <__panic>
    free_list = free_list_store;
  1030fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030fd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103100:	a3 50 79 11 00       	mov    %eax,0x117950
  103105:	89 15 54 79 11 00    	mov    %edx,0x117954
    nr_free = nr_free_store;
  10310b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10310e:	a3 58 79 11 00       	mov    %eax,0x117958

    free_page(p);
  103113:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10311a:	00 
  10311b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10311e:	89 04 24             	mov    %eax,(%esp)
  103121:	e8 c1 09 00 00       	call   103ae7 <free_pages>
    free_page(p1);
  103126:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10312d:	00 
  10312e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103131:	89 04 24             	mov    %eax,(%esp)
  103134:	e8 ae 09 00 00       	call   103ae7 <free_pages>
    free_page(p2);
  103139:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103140:	00 
  103141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103144:	89 04 24             	mov    %eax,(%esp)
  103147:	e8 9b 09 00 00       	call   103ae7 <free_pages>
}
  10314c:	c9                   	leave  
  10314d:	c3                   	ret    

0010314e <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  10314e:	55                   	push   %ebp
  10314f:	89 e5                	mov    %esp,%ebp
  103151:	53                   	push   %ebx
  103152:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  103158:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10315f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  103166:	c7 45 ec 50 79 11 00 	movl   $0x117950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10316d:	eb 6b                	jmp    1031da <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  10316f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103172:	83 e8 0c             	sub    $0xc,%eax
  103175:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  103178:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10317b:	83 c0 04             	add    $0x4,%eax
  10317e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103185:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103188:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10318b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10318e:	0f a3 10             	bt     %edx,(%eax)
  103191:	19 c0                	sbb    %eax,%eax
  103193:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  103196:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  10319a:	0f 95 c0             	setne  %al
  10319d:	0f b6 c0             	movzbl %al,%eax
  1031a0:	85 c0                	test   %eax,%eax
  1031a2:	75 24                	jne    1031c8 <default_check+0x7a>
  1031a4:	c7 44 24 0c 5e 64 10 	movl   $0x10645e,0xc(%esp)
  1031ab:	00 
  1031ac:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  1031b3:	00 
  1031b4:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
  1031bb:	00 
  1031bc:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1031c3:	e8 44 da ff ff       	call   100c0c <__panic>
        count ++, total += p->property;
  1031c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1031cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1031cf:	8b 50 08             	mov    0x8(%eax),%edx
  1031d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031d5:	01 d0                	add    %edx,%eax
  1031d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1031da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031dd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1031e0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1031e3:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1031e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1031e9:	81 7d ec 50 79 11 00 	cmpl   $0x117950,-0x14(%ebp)
  1031f0:	0f 85 79 ff ff ff    	jne    10316f <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  1031f6:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  1031f9:	e8 1b 09 00 00       	call   103b19 <nr_free_pages>
  1031fe:	39 c3                	cmp    %eax,%ebx
  103200:	74 24                	je     103226 <default_check+0xd8>
  103202:	c7 44 24 0c 6e 64 10 	movl   $0x10646e,0xc(%esp)
  103209:	00 
  10320a:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  103211:	00 
  103212:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
  103219:	00 
  10321a:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  103221:	e8 e6 d9 ff ff       	call   100c0c <__panic>

    basic_check();
  103226:	e8 e7 f9 ff ff       	call   102c12 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  10322b:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103232:	e8 78 08 00 00       	call   103aaf <alloc_pages>
  103237:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  10323a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10323e:	75 24                	jne    103264 <default_check+0x116>
  103240:	c7 44 24 0c 87 64 10 	movl   $0x106487,0xc(%esp)
  103247:	00 
  103248:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  10324f:	00 
  103250:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
  103257:	00 
  103258:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  10325f:	e8 a8 d9 ff ff       	call   100c0c <__panic>
    assert(!PageProperty(p0));
  103264:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103267:	83 c0 04             	add    $0x4,%eax
  10326a:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  103271:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103274:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103277:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10327a:	0f a3 10             	bt     %edx,(%eax)
  10327d:	19 c0                	sbb    %eax,%eax
  10327f:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  103282:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  103286:	0f 95 c0             	setne  %al
  103289:	0f b6 c0             	movzbl %al,%eax
  10328c:	85 c0                	test   %eax,%eax
  10328e:	74 24                	je     1032b4 <default_check+0x166>
  103290:	c7 44 24 0c 92 64 10 	movl   $0x106492,0xc(%esp)
  103297:	00 
  103298:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  10329f:	00 
  1032a0:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  1032a7:	00 
  1032a8:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1032af:	e8 58 d9 ff ff       	call   100c0c <__panic>

    list_entry_t free_list_store = free_list;
  1032b4:	a1 50 79 11 00       	mov    0x117950,%eax
  1032b9:	8b 15 54 79 11 00    	mov    0x117954,%edx
  1032bf:	89 45 80             	mov    %eax,-0x80(%ebp)
  1032c2:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1032c5:	c7 45 b4 50 79 11 00 	movl   $0x117950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1032cc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1032cf:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1032d2:	89 50 04             	mov    %edx,0x4(%eax)
  1032d5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1032d8:	8b 50 04             	mov    0x4(%eax),%edx
  1032db:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1032de:	89 10                	mov    %edx,(%eax)
  1032e0:	c7 45 b0 50 79 11 00 	movl   $0x117950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1032e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1032ea:	8b 40 04             	mov    0x4(%eax),%eax
  1032ed:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  1032f0:	0f 94 c0             	sete   %al
  1032f3:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1032f6:	85 c0                	test   %eax,%eax
  1032f8:	75 24                	jne    10331e <default_check+0x1d0>
  1032fa:	c7 44 24 0c e7 63 10 	movl   $0x1063e7,0xc(%esp)
  103301:	00 
  103302:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  103309:	00 
  10330a:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103311:	00 
  103312:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  103319:	e8 ee d8 ff ff       	call   100c0c <__panic>
    assert(alloc_page() == NULL);
  10331e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103325:	e8 85 07 00 00       	call   103aaf <alloc_pages>
  10332a:	85 c0                	test   %eax,%eax
  10332c:	74 24                	je     103352 <default_check+0x204>
  10332e:	c7 44 24 0c fe 63 10 	movl   $0x1063fe,0xc(%esp)
  103335:	00 
  103336:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  10333d:	00 
  10333e:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  103345:	00 
  103346:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  10334d:	e8 ba d8 ff ff       	call   100c0c <__panic>

    unsigned int nr_free_store = nr_free;
  103352:	a1 58 79 11 00       	mov    0x117958,%eax
  103357:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  10335a:	c7 05 58 79 11 00 00 	movl   $0x0,0x117958
  103361:	00 00 00 

    free_pages(p0 + 2, 3);
  103364:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103367:	83 c0 28             	add    $0x28,%eax
  10336a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103371:	00 
  103372:	89 04 24             	mov    %eax,(%esp)
  103375:	e8 6d 07 00 00       	call   103ae7 <free_pages>
    assert(alloc_pages(4) == NULL);
  10337a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  103381:	e8 29 07 00 00       	call   103aaf <alloc_pages>
  103386:	85 c0                	test   %eax,%eax
  103388:	74 24                	je     1033ae <default_check+0x260>
  10338a:	c7 44 24 0c a4 64 10 	movl   $0x1064a4,0xc(%esp)
  103391:	00 
  103392:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  103399:	00 
  10339a:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  1033a1:	00 
  1033a2:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1033a9:	e8 5e d8 ff ff       	call   100c0c <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1033ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033b1:	83 c0 28             	add    $0x28,%eax
  1033b4:	83 c0 04             	add    $0x4,%eax
  1033b7:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1033be:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1033c1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1033c4:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1033c7:	0f a3 10             	bt     %edx,(%eax)
  1033ca:	19 c0                	sbb    %eax,%eax
  1033cc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1033cf:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1033d3:	0f 95 c0             	setne  %al
  1033d6:	0f b6 c0             	movzbl %al,%eax
  1033d9:	85 c0                	test   %eax,%eax
  1033db:	74 0e                	je     1033eb <default_check+0x29d>
  1033dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033e0:	83 c0 28             	add    $0x28,%eax
  1033e3:	8b 40 08             	mov    0x8(%eax),%eax
  1033e6:	83 f8 03             	cmp    $0x3,%eax
  1033e9:	74 24                	je     10340f <default_check+0x2c1>
  1033eb:	c7 44 24 0c bc 64 10 	movl   $0x1064bc,0xc(%esp)
  1033f2:	00 
  1033f3:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  1033fa:	00 
  1033fb:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
  103402:	00 
  103403:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  10340a:	e8 fd d7 ff ff       	call   100c0c <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  10340f:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  103416:	e8 94 06 00 00       	call   103aaf <alloc_pages>
  10341b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10341e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103422:	75 24                	jne    103448 <default_check+0x2fa>
  103424:	c7 44 24 0c e8 64 10 	movl   $0x1064e8,0xc(%esp)
  10342b:	00 
  10342c:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  103433:	00 
  103434:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  10343b:	00 
  10343c:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  103443:	e8 c4 d7 ff ff       	call   100c0c <__panic>
    assert(alloc_page() == NULL);
  103448:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10344f:	e8 5b 06 00 00       	call   103aaf <alloc_pages>
  103454:	85 c0                	test   %eax,%eax
  103456:	74 24                	je     10347c <default_check+0x32e>
  103458:	c7 44 24 0c fe 63 10 	movl   $0x1063fe,0xc(%esp)
  10345f:	00 
  103460:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  103467:	00 
  103468:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
  10346f:	00 
  103470:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  103477:	e8 90 d7 ff ff       	call   100c0c <__panic>
    assert(p0 + 2 == p1);
  10347c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10347f:	83 c0 28             	add    $0x28,%eax
  103482:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103485:	74 24                	je     1034ab <default_check+0x35d>
  103487:	c7 44 24 0c 06 65 10 	movl   $0x106506,0xc(%esp)
  10348e:	00 
  10348f:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  103496:	00 
  103497:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  10349e:	00 
  10349f:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1034a6:	e8 61 d7 ff ff       	call   100c0c <__panic>

    p2 = p0 + 1;
  1034ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034ae:	83 c0 14             	add    $0x14,%eax
  1034b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  1034b4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1034bb:	00 
  1034bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034bf:	89 04 24             	mov    %eax,(%esp)
  1034c2:	e8 20 06 00 00       	call   103ae7 <free_pages>
    free_pages(p1, 3);
  1034c7:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1034ce:	00 
  1034cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1034d2:	89 04 24             	mov    %eax,(%esp)
  1034d5:	e8 0d 06 00 00       	call   103ae7 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1034da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1034dd:	83 c0 04             	add    $0x4,%eax
  1034e0:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1034e7:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1034ea:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1034ed:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1034f0:	0f a3 10             	bt     %edx,(%eax)
  1034f3:	19 c0                	sbb    %eax,%eax
  1034f5:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1034f8:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1034fc:	0f 95 c0             	setne  %al
  1034ff:	0f b6 c0             	movzbl %al,%eax
  103502:	85 c0                	test   %eax,%eax
  103504:	74 0b                	je     103511 <default_check+0x3c3>
  103506:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103509:	8b 40 08             	mov    0x8(%eax),%eax
  10350c:	83 f8 01             	cmp    $0x1,%eax
  10350f:	74 24                	je     103535 <default_check+0x3e7>
  103511:	c7 44 24 0c 14 65 10 	movl   $0x106514,0xc(%esp)
  103518:	00 
  103519:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  103520:	00 
  103521:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  103528:	00 
  103529:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  103530:	e8 d7 d6 ff ff       	call   100c0c <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103535:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103538:	83 c0 04             	add    $0x4,%eax
  10353b:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103542:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103545:	8b 45 90             	mov    -0x70(%ebp),%eax
  103548:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10354b:	0f a3 10             	bt     %edx,(%eax)
  10354e:	19 c0                	sbb    %eax,%eax
  103550:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103553:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  103557:	0f 95 c0             	setne  %al
  10355a:	0f b6 c0             	movzbl %al,%eax
  10355d:	85 c0                	test   %eax,%eax
  10355f:	74 0b                	je     10356c <default_check+0x41e>
  103561:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103564:	8b 40 08             	mov    0x8(%eax),%eax
  103567:	83 f8 03             	cmp    $0x3,%eax
  10356a:	74 24                	je     103590 <default_check+0x442>
  10356c:	c7 44 24 0c 3c 65 10 	movl   $0x10653c,0xc(%esp)
  103573:	00 
  103574:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  10357b:	00 
  10357c:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  103583:	00 
  103584:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  10358b:	e8 7c d6 ff ff       	call   100c0c <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  103590:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103597:	e8 13 05 00 00       	call   103aaf <alloc_pages>
  10359c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10359f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1035a2:	83 e8 14             	sub    $0x14,%eax
  1035a5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1035a8:	74 24                	je     1035ce <default_check+0x480>
  1035aa:	c7 44 24 0c 62 65 10 	movl   $0x106562,0xc(%esp)
  1035b1:	00 
  1035b2:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  1035b9:	00 
  1035ba:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  1035c1:	00 
  1035c2:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1035c9:	e8 3e d6 ff ff       	call   100c0c <__panic>
    free_page(p0);
  1035ce:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1035d5:	00 
  1035d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035d9:	89 04 24             	mov    %eax,(%esp)
  1035dc:	e8 06 05 00 00       	call   103ae7 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1035e1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1035e8:	e8 c2 04 00 00       	call   103aaf <alloc_pages>
  1035ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1035f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1035f3:	83 c0 14             	add    $0x14,%eax
  1035f6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1035f9:	74 24                	je     10361f <default_check+0x4d1>
  1035fb:	c7 44 24 0c 80 65 10 	movl   $0x106580,0xc(%esp)
  103602:	00 
  103603:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  10360a:	00 
  10360b:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  103612:	00 
  103613:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  10361a:	e8 ed d5 ff ff       	call   100c0c <__panic>

    free_pages(p0, 2);
  10361f:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103626:	00 
  103627:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10362a:	89 04 24             	mov    %eax,(%esp)
  10362d:	e8 b5 04 00 00       	call   103ae7 <free_pages>
    free_page(p2);
  103632:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103639:	00 
  10363a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10363d:	89 04 24             	mov    %eax,(%esp)
  103640:	e8 a2 04 00 00       	call   103ae7 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103645:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10364c:	e8 5e 04 00 00       	call   103aaf <alloc_pages>
  103651:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103654:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103658:	75 24                	jne    10367e <default_check+0x530>
  10365a:	c7 44 24 0c a0 65 10 	movl   $0x1065a0,0xc(%esp)
  103661:	00 
  103662:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  103669:	00 
  10366a:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
  103671:	00 
  103672:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  103679:	e8 8e d5 ff ff       	call   100c0c <__panic>
    assert(alloc_page() == NULL);
  10367e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103685:	e8 25 04 00 00       	call   103aaf <alloc_pages>
  10368a:	85 c0                	test   %eax,%eax
  10368c:	74 24                	je     1036b2 <default_check+0x564>
  10368e:	c7 44 24 0c fe 63 10 	movl   $0x1063fe,0xc(%esp)
  103695:	00 
  103696:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  10369d:	00 
  10369e:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
  1036a5:	00 
  1036a6:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1036ad:	e8 5a d5 ff ff       	call   100c0c <__panic>

    assert(nr_free == 0);
  1036b2:	a1 58 79 11 00       	mov    0x117958,%eax
  1036b7:	85 c0                	test   %eax,%eax
  1036b9:	74 24                	je     1036df <default_check+0x591>
  1036bb:	c7 44 24 0c 51 64 10 	movl   $0x106451,0xc(%esp)
  1036c2:	00 
  1036c3:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  1036ca:	00 
  1036cb:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  1036d2:	00 
  1036d3:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  1036da:	e8 2d d5 ff ff       	call   100c0c <__panic>
    nr_free = nr_free_store;
  1036df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1036e2:	a3 58 79 11 00       	mov    %eax,0x117958

    free_list = free_list_store;
  1036e7:	8b 45 80             	mov    -0x80(%ebp),%eax
  1036ea:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1036ed:	a3 50 79 11 00       	mov    %eax,0x117950
  1036f2:	89 15 54 79 11 00    	mov    %edx,0x117954
    free_pages(p0, 5);
  1036f8:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  1036ff:	00 
  103700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103703:	89 04 24             	mov    %eax,(%esp)
  103706:	e8 dc 03 00 00       	call   103ae7 <free_pages>

    le = &free_list;
  10370b:	c7 45 ec 50 79 11 00 	movl   $0x117950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103712:	eb 1d                	jmp    103731 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103714:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103717:	83 e8 0c             	sub    $0xc,%eax
  10371a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  10371d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103721:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103724:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103727:	8b 40 08             	mov    0x8(%eax),%eax
  10372a:	29 c2                	sub    %eax,%edx
  10372c:	89 d0                	mov    %edx,%eax
  10372e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103731:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103734:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103737:	8b 45 88             	mov    -0x78(%ebp),%eax
  10373a:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  10373d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103740:	81 7d ec 50 79 11 00 	cmpl   $0x117950,-0x14(%ebp)
  103747:	75 cb                	jne    103714 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103749:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10374d:	74 24                	je     103773 <default_check+0x625>
  10374f:	c7 44 24 0c be 65 10 	movl   $0x1065be,0xc(%esp)
  103756:	00 
  103757:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  10375e:	00 
  10375f:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  103766:	00 
  103767:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  10376e:	e8 99 d4 ff ff       	call   100c0c <__panic>
    assert(total == 0);
  103773:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103777:	74 24                	je     10379d <default_check+0x64f>
  103779:	c7 44 24 0c c9 65 10 	movl   $0x1065c9,0xc(%esp)
  103780:	00 
  103781:	c7 44 24 08 76 62 10 	movl   $0x106276,0x8(%esp)
  103788:	00 
  103789:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  103790:	00 
  103791:	c7 04 24 8b 62 10 00 	movl   $0x10628b,(%esp)
  103798:	e8 6f d4 ff ff       	call   100c0c <__panic>
}
  10379d:	81 c4 94 00 00 00    	add    $0x94,%esp
  1037a3:	5b                   	pop    %ebx
  1037a4:	5d                   	pop    %ebp
  1037a5:	c3                   	ret    

001037a6 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1037a6:	55                   	push   %ebp
  1037a7:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1037a9:	8b 55 08             	mov    0x8(%ebp),%edx
  1037ac:	a1 64 79 11 00       	mov    0x117964,%eax
  1037b1:	29 c2                	sub    %eax,%edx
  1037b3:	89 d0                	mov    %edx,%eax
  1037b5:	c1 f8 02             	sar    $0x2,%eax
  1037b8:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1037be:	5d                   	pop    %ebp
  1037bf:	c3                   	ret    

001037c0 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1037c0:	55                   	push   %ebp
  1037c1:	89 e5                	mov    %esp,%ebp
  1037c3:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1037c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1037c9:	89 04 24             	mov    %eax,(%esp)
  1037cc:	e8 d5 ff ff ff       	call   1037a6 <page2ppn>
  1037d1:	c1 e0 0c             	shl    $0xc,%eax
}
  1037d4:	c9                   	leave  
  1037d5:	c3                   	ret    

001037d6 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  1037d6:	55                   	push   %ebp
  1037d7:	89 e5                	mov    %esp,%ebp
  1037d9:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  1037dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1037df:	c1 e8 0c             	shr    $0xc,%eax
  1037e2:	89 c2                	mov    %eax,%edx
  1037e4:	a1 c0 78 11 00       	mov    0x1178c0,%eax
  1037e9:	39 c2                	cmp    %eax,%edx
  1037eb:	72 1c                	jb     103809 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  1037ed:	c7 44 24 08 04 66 10 	movl   $0x106604,0x8(%esp)
  1037f4:	00 
  1037f5:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  1037fc:	00 
  1037fd:	c7 04 24 23 66 10 00 	movl   $0x106623,(%esp)
  103804:	e8 03 d4 ff ff       	call   100c0c <__panic>
    }
    return &pages[PPN(pa)];
  103809:	8b 0d 64 79 11 00    	mov    0x117964,%ecx
  10380f:	8b 45 08             	mov    0x8(%ebp),%eax
  103812:	c1 e8 0c             	shr    $0xc,%eax
  103815:	89 c2                	mov    %eax,%edx
  103817:	89 d0                	mov    %edx,%eax
  103819:	c1 e0 02             	shl    $0x2,%eax
  10381c:	01 d0                	add    %edx,%eax
  10381e:	c1 e0 02             	shl    $0x2,%eax
  103821:	01 c8                	add    %ecx,%eax
}
  103823:	c9                   	leave  
  103824:	c3                   	ret    

00103825 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103825:	55                   	push   %ebp
  103826:	89 e5                	mov    %esp,%ebp
  103828:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  10382b:	8b 45 08             	mov    0x8(%ebp),%eax
  10382e:	89 04 24             	mov    %eax,(%esp)
  103831:	e8 8a ff ff ff       	call   1037c0 <page2pa>
  103836:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10383c:	c1 e8 0c             	shr    $0xc,%eax
  10383f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103842:	a1 c0 78 11 00       	mov    0x1178c0,%eax
  103847:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  10384a:	72 23                	jb     10386f <page2kva+0x4a>
  10384c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10384f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103853:	c7 44 24 08 34 66 10 	movl   $0x106634,0x8(%esp)
  10385a:	00 
  10385b:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103862:	00 
  103863:	c7 04 24 23 66 10 00 	movl   $0x106623,(%esp)
  10386a:	e8 9d d3 ff ff       	call   100c0c <__panic>
  10386f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103872:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103877:	c9                   	leave  
  103878:	c3                   	ret    

00103879 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103879:	55                   	push   %ebp
  10387a:	89 e5                	mov    %esp,%ebp
  10387c:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  10387f:	8b 45 08             	mov    0x8(%ebp),%eax
  103882:	83 e0 01             	and    $0x1,%eax
  103885:	85 c0                	test   %eax,%eax
  103887:	75 1c                	jne    1038a5 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103889:	c7 44 24 08 58 66 10 	movl   $0x106658,0x8(%esp)
  103890:	00 
  103891:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103898:	00 
  103899:	c7 04 24 23 66 10 00 	movl   $0x106623,(%esp)
  1038a0:	e8 67 d3 ff ff       	call   100c0c <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  1038a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1038a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1038ad:	89 04 24             	mov    %eax,(%esp)
  1038b0:	e8 21 ff ff ff       	call   1037d6 <pa2page>
}
  1038b5:	c9                   	leave  
  1038b6:	c3                   	ret    

001038b7 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1038b7:	55                   	push   %ebp
  1038b8:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1038ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1038bd:	8b 00                	mov    (%eax),%eax
}
  1038bf:	5d                   	pop    %ebp
  1038c0:	c3                   	ret    

001038c1 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
  1038c1:	55                   	push   %ebp
  1038c2:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  1038c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1038c7:	8b 00                	mov    (%eax),%eax
  1038c9:	8d 50 01             	lea    0x1(%eax),%edx
  1038cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1038cf:	89 10                	mov    %edx,(%eax)
    return page->ref;
  1038d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1038d4:	8b 00                	mov    (%eax),%eax
}
  1038d6:	5d                   	pop    %ebp
  1038d7:	c3                   	ret    

001038d8 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  1038d8:	55                   	push   %ebp
  1038d9:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  1038db:	8b 45 08             	mov    0x8(%ebp),%eax
  1038de:	8b 00                	mov    (%eax),%eax
  1038e0:	8d 50 ff             	lea    -0x1(%eax),%edx
  1038e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1038e6:	89 10                	mov    %edx,(%eax)
    return page->ref;
  1038e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1038eb:	8b 00                	mov    (%eax),%eax
}
  1038ed:	5d                   	pop    %ebp
  1038ee:	c3                   	ret    

001038ef <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  1038ef:	55                   	push   %ebp
  1038f0:	89 e5                	mov    %esp,%ebp
  1038f2:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  1038f5:	9c                   	pushf  
  1038f6:	58                   	pop    %eax
  1038f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  1038fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  1038fd:	25 00 02 00 00       	and    $0x200,%eax
  103902:	85 c0                	test   %eax,%eax
  103904:	74 0c                	je     103912 <__intr_save+0x23>
        intr_disable();
  103906:	e8 e4 dc ff ff       	call   1015ef <intr_disable>
        return 1;
  10390b:	b8 01 00 00 00       	mov    $0x1,%eax
  103910:	eb 05                	jmp    103917 <__intr_save+0x28>
    }
    return 0;
  103912:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103917:	c9                   	leave  
  103918:	c3                   	ret    

00103919 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103919:	55                   	push   %ebp
  10391a:	89 e5                	mov    %esp,%ebp
  10391c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  10391f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103923:	74 05                	je     10392a <__intr_restore+0x11>
        intr_enable();
  103925:	e8 bf dc ff ff       	call   1015e9 <intr_enable>
    }
}
  10392a:	c9                   	leave  
  10392b:	c3                   	ret    

0010392c <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  10392c:	55                   	push   %ebp
  10392d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  10392f:	8b 45 08             	mov    0x8(%ebp),%eax
  103932:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103935:	b8 23 00 00 00       	mov    $0x23,%eax
  10393a:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  10393c:	b8 23 00 00 00       	mov    $0x23,%eax
  103941:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103943:	b8 10 00 00 00       	mov    $0x10,%eax
  103948:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  10394a:	b8 10 00 00 00       	mov    $0x10,%eax
  10394f:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103951:	b8 10 00 00 00       	mov    $0x10,%eax
  103956:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103958:	ea 5f 39 10 00 08 00 	ljmp   $0x8,$0x10395f
}
  10395f:	5d                   	pop    %ebp
  103960:	c3                   	ret    

00103961 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103961:	55                   	push   %ebp
  103962:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103964:	8b 45 08             	mov    0x8(%ebp),%eax
  103967:	a3 e4 78 11 00       	mov    %eax,0x1178e4
}
  10396c:	5d                   	pop    %ebp
  10396d:	c3                   	ret    

0010396e <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  10396e:	55                   	push   %ebp
  10396f:	89 e5                	mov    %esp,%ebp
  103971:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103974:	b8 00 60 11 00       	mov    $0x116000,%eax
  103979:	89 04 24             	mov    %eax,(%esp)
  10397c:	e8 e0 ff ff ff       	call   103961 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103981:	66 c7 05 e8 78 11 00 	movw   $0x10,0x1178e8
  103988:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  10398a:	66 c7 05 28 6a 11 00 	movw   $0x68,0x116a28
  103991:	68 00 
  103993:	b8 e0 78 11 00       	mov    $0x1178e0,%eax
  103998:	66 a3 2a 6a 11 00    	mov    %ax,0x116a2a
  10399e:	b8 e0 78 11 00       	mov    $0x1178e0,%eax
  1039a3:	c1 e8 10             	shr    $0x10,%eax
  1039a6:	a2 2c 6a 11 00       	mov    %al,0x116a2c
  1039ab:	0f b6 05 2d 6a 11 00 	movzbl 0x116a2d,%eax
  1039b2:	83 e0 f0             	and    $0xfffffff0,%eax
  1039b5:	83 c8 09             	or     $0x9,%eax
  1039b8:	a2 2d 6a 11 00       	mov    %al,0x116a2d
  1039bd:	0f b6 05 2d 6a 11 00 	movzbl 0x116a2d,%eax
  1039c4:	83 e0 ef             	and    $0xffffffef,%eax
  1039c7:	a2 2d 6a 11 00       	mov    %al,0x116a2d
  1039cc:	0f b6 05 2d 6a 11 00 	movzbl 0x116a2d,%eax
  1039d3:	83 e0 9f             	and    $0xffffff9f,%eax
  1039d6:	a2 2d 6a 11 00       	mov    %al,0x116a2d
  1039db:	0f b6 05 2d 6a 11 00 	movzbl 0x116a2d,%eax
  1039e2:	83 c8 80             	or     $0xffffff80,%eax
  1039e5:	a2 2d 6a 11 00       	mov    %al,0x116a2d
  1039ea:	0f b6 05 2e 6a 11 00 	movzbl 0x116a2e,%eax
  1039f1:	83 e0 f0             	and    $0xfffffff0,%eax
  1039f4:	a2 2e 6a 11 00       	mov    %al,0x116a2e
  1039f9:	0f b6 05 2e 6a 11 00 	movzbl 0x116a2e,%eax
  103a00:	83 e0 ef             	and    $0xffffffef,%eax
  103a03:	a2 2e 6a 11 00       	mov    %al,0x116a2e
  103a08:	0f b6 05 2e 6a 11 00 	movzbl 0x116a2e,%eax
  103a0f:	83 e0 df             	and    $0xffffffdf,%eax
  103a12:	a2 2e 6a 11 00       	mov    %al,0x116a2e
  103a17:	0f b6 05 2e 6a 11 00 	movzbl 0x116a2e,%eax
  103a1e:	83 c8 40             	or     $0x40,%eax
  103a21:	a2 2e 6a 11 00       	mov    %al,0x116a2e
  103a26:	0f b6 05 2e 6a 11 00 	movzbl 0x116a2e,%eax
  103a2d:	83 e0 7f             	and    $0x7f,%eax
  103a30:	a2 2e 6a 11 00       	mov    %al,0x116a2e
  103a35:	b8 e0 78 11 00       	mov    $0x1178e0,%eax
  103a3a:	c1 e8 18             	shr    $0x18,%eax
  103a3d:	a2 2f 6a 11 00       	mov    %al,0x116a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103a42:	c7 04 24 30 6a 11 00 	movl   $0x116a30,(%esp)
  103a49:	e8 de fe ff ff       	call   10392c <lgdt>
  103a4e:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103a54:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103a58:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103a5b:	c9                   	leave  
  103a5c:	c3                   	ret    

00103a5d <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103a5d:	55                   	push   %ebp
  103a5e:	89 e5                	mov    %esp,%ebp
  103a60:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103a63:	c7 05 5c 79 11 00 e8 	movl   $0x1065e8,0x11795c
  103a6a:	65 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103a6d:	a1 5c 79 11 00       	mov    0x11795c,%eax
  103a72:	8b 00                	mov    (%eax),%eax
  103a74:	89 44 24 04          	mov    %eax,0x4(%esp)
  103a78:	c7 04 24 84 66 10 00 	movl   $0x106684,(%esp)
  103a7f:	e8 b8 c8 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103a84:	a1 5c 79 11 00       	mov    0x11795c,%eax
  103a89:	8b 40 04             	mov    0x4(%eax),%eax
  103a8c:	ff d0                	call   *%eax
}
  103a8e:	c9                   	leave  
  103a8f:	c3                   	ret    

00103a90 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103a90:	55                   	push   %ebp
  103a91:	89 e5                	mov    %esp,%ebp
  103a93:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103a96:	a1 5c 79 11 00       	mov    0x11795c,%eax
  103a9b:	8b 40 08             	mov    0x8(%eax),%eax
  103a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  103aa1:	89 54 24 04          	mov    %edx,0x4(%esp)
  103aa5:	8b 55 08             	mov    0x8(%ebp),%edx
  103aa8:	89 14 24             	mov    %edx,(%esp)
  103aab:	ff d0                	call   *%eax
}
  103aad:	c9                   	leave  
  103aae:	c3                   	ret    

00103aaf <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103aaf:	55                   	push   %ebp
  103ab0:	89 e5                	mov    %esp,%ebp
  103ab2:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103ab5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103abc:	e8 2e fe ff ff       	call   1038ef <__intr_save>
  103ac1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103ac4:	a1 5c 79 11 00       	mov    0x11795c,%eax
  103ac9:	8b 40 0c             	mov    0xc(%eax),%eax
  103acc:	8b 55 08             	mov    0x8(%ebp),%edx
  103acf:	89 14 24             	mov    %edx,(%esp)
  103ad2:	ff d0                	call   *%eax
  103ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103ada:	89 04 24             	mov    %eax,(%esp)
  103add:	e8 37 fe ff ff       	call   103919 <__intr_restore>
    return page;
  103ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103ae5:	c9                   	leave  
  103ae6:	c3                   	ret    

00103ae7 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103ae7:	55                   	push   %ebp
  103ae8:	89 e5                	mov    %esp,%ebp
  103aea:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103aed:	e8 fd fd ff ff       	call   1038ef <__intr_save>
  103af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103af5:	a1 5c 79 11 00       	mov    0x11795c,%eax
  103afa:	8b 40 10             	mov    0x10(%eax),%eax
  103afd:	8b 55 0c             	mov    0xc(%ebp),%edx
  103b00:	89 54 24 04          	mov    %edx,0x4(%esp)
  103b04:	8b 55 08             	mov    0x8(%ebp),%edx
  103b07:	89 14 24             	mov    %edx,(%esp)
  103b0a:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b0f:	89 04 24             	mov    %eax,(%esp)
  103b12:	e8 02 fe ff ff       	call   103919 <__intr_restore>
}
  103b17:	c9                   	leave  
  103b18:	c3                   	ret    

00103b19 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103b19:	55                   	push   %ebp
  103b1a:	89 e5                	mov    %esp,%ebp
  103b1c:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103b1f:	e8 cb fd ff ff       	call   1038ef <__intr_save>
  103b24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103b27:	a1 5c 79 11 00       	mov    0x11795c,%eax
  103b2c:	8b 40 14             	mov    0x14(%eax),%eax
  103b2f:	ff d0                	call   *%eax
  103b31:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b37:	89 04 24             	mov    %eax,(%esp)
  103b3a:	e8 da fd ff ff       	call   103919 <__intr_restore>
    return ret;
  103b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103b42:	c9                   	leave  
  103b43:	c3                   	ret    

00103b44 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103b44:	55                   	push   %ebp
  103b45:	89 e5                	mov    %esp,%ebp
  103b47:	57                   	push   %edi
  103b48:	56                   	push   %esi
  103b49:	53                   	push   %ebx
  103b4a:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103b50:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103b57:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103b5e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103b65:	c7 04 24 9b 66 10 00 	movl   $0x10669b,(%esp)
  103b6c:	e8 cb c7 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103b71:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103b78:	e9 15 01 00 00       	jmp    103c92 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103b7d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103b80:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103b83:	89 d0                	mov    %edx,%eax
  103b85:	c1 e0 02             	shl    $0x2,%eax
  103b88:	01 d0                	add    %edx,%eax
  103b8a:	c1 e0 02             	shl    $0x2,%eax
  103b8d:	01 c8                	add    %ecx,%eax
  103b8f:	8b 50 08             	mov    0x8(%eax),%edx
  103b92:	8b 40 04             	mov    0x4(%eax),%eax
  103b95:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103b98:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103b9b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103b9e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103ba1:	89 d0                	mov    %edx,%eax
  103ba3:	c1 e0 02             	shl    $0x2,%eax
  103ba6:	01 d0                	add    %edx,%eax
  103ba8:	c1 e0 02             	shl    $0x2,%eax
  103bab:	01 c8                	add    %ecx,%eax
  103bad:	8b 48 0c             	mov    0xc(%eax),%ecx
  103bb0:	8b 58 10             	mov    0x10(%eax),%ebx
  103bb3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103bb6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103bb9:	01 c8                	add    %ecx,%eax
  103bbb:	11 da                	adc    %ebx,%edx
  103bbd:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103bc0:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103bc3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103bc6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103bc9:	89 d0                	mov    %edx,%eax
  103bcb:	c1 e0 02             	shl    $0x2,%eax
  103bce:	01 d0                	add    %edx,%eax
  103bd0:	c1 e0 02             	shl    $0x2,%eax
  103bd3:	01 c8                	add    %ecx,%eax
  103bd5:	83 c0 14             	add    $0x14,%eax
  103bd8:	8b 00                	mov    (%eax),%eax
  103bda:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103be0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103be3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103be6:	83 c0 ff             	add    $0xffffffff,%eax
  103be9:	83 d2 ff             	adc    $0xffffffff,%edx
  103bec:	89 c6                	mov    %eax,%esi
  103bee:	89 d7                	mov    %edx,%edi
  103bf0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103bf3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103bf6:	89 d0                	mov    %edx,%eax
  103bf8:	c1 e0 02             	shl    $0x2,%eax
  103bfb:	01 d0                	add    %edx,%eax
  103bfd:	c1 e0 02             	shl    $0x2,%eax
  103c00:	01 c8                	add    %ecx,%eax
  103c02:	8b 48 0c             	mov    0xc(%eax),%ecx
  103c05:	8b 58 10             	mov    0x10(%eax),%ebx
  103c08:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103c0e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103c12:	89 74 24 14          	mov    %esi,0x14(%esp)
  103c16:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103c1a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103c1d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103c20:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103c24:	89 54 24 10          	mov    %edx,0x10(%esp)
  103c28:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103c2c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103c30:	c7 04 24 a8 66 10 00 	movl   $0x1066a8,(%esp)
  103c37:	e8 00 c7 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103c3c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103c3f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103c42:	89 d0                	mov    %edx,%eax
  103c44:	c1 e0 02             	shl    $0x2,%eax
  103c47:	01 d0                	add    %edx,%eax
  103c49:	c1 e0 02             	shl    $0x2,%eax
  103c4c:	01 c8                	add    %ecx,%eax
  103c4e:	83 c0 14             	add    $0x14,%eax
  103c51:	8b 00                	mov    (%eax),%eax
  103c53:	83 f8 01             	cmp    $0x1,%eax
  103c56:	75 36                	jne    103c8e <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103c58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103c5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103c5e:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103c61:	77 2b                	ja     103c8e <page_init+0x14a>
  103c63:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103c66:	72 05                	jb     103c6d <page_init+0x129>
  103c68:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103c6b:	73 21                	jae    103c8e <page_init+0x14a>
  103c6d:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103c71:	77 1b                	ja     103c8e <page_init+0x14a>
  103c73:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103c77:	72 09                	jb     103c82 <page_init+0x13e>
  103c79:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103c80:	77 0c                	ja     103c8e <page_init+0x14a>
                maxpa = end;
  103c82:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103c85:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103c88:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103c8b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103c8e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103c92:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103c95:	8b 00                	mov    (%eax),%eax
  103c97:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103c9a:	0f 8f dd fe ff ff    	jg     103b7d <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103ca0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103ca4:	72 1d                	jb     103cc3 <page_init+0x17f>
  103ca6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103caa:	77 09                	ja     103cb5 <page_init+0x171>
  103cac:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103cb3:	76 0e                	jbe    103cc3 <page_init+0x17f>
        maxpa = KMEMSIZE;
  103cb5:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103cbc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103cc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103cc6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103cc9:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103ccd:	c1 ea 0c             	shr    $0xc,%edx
  103cd0:	a3 c0 78 11 00       	mov    %eax,0x1178c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103cd5:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103cdc:	b8 68 79 11 00       	mov    $0x117968,%eax
  103ce1:	8d 50 ff             	lea    -0x1(%eax),%edx
  103ce4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103ce7:	01 d0                	add    %edx,%eax
  103ce9:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103cec:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103cef:	ba 00 00 00 00       	mov    $0x0,%edx
  103cf4:	f7 75 ac             	divl   -0x54(%ebp)
  103cf7:	89 d0                	mov    %edx,%eax
  103cf9:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103cfc:	29 c2                	sub    %eax,%edx
  103cfe:	89 d0                	mov    %edx,%eax
  103d00:	a3 64 79 11 00       	mov    %eax,0x117964

    for (i = 0; i < npage; i ++) {
  103d05:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103d0c:	eb 2f                	jmp    103d3d <page_init+0x1f9>
        SetPageReserved(pages + i);
  103d0e:	8b 0d 64 79 11 00    	mov    0x117964,%ecx
  103d14:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d17:	89 d0                	mov    %edx,%eax
  103d19:	c1 e0 02             	shl    $0x2,%eax
  103d1c:	01 d0                	add    %edx,%eax
  103d1e:	c1 e0 02             	shl    $0x2,%eax
  103d21:	01 c8                	add    %ecx,%eax
  103d23:	83 c0 04             	add    $0x4,%eax
  103d26:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103d2d:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103d30:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103d33:	8b 55 90             	mov    -0x70(%ebp),%edx
  103d36:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103d39:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103d3d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d40:	a1 c0 78 11 00       	mov    0x1178c0,%eax
  103d45:	39 c2                	cmp    %eax,%edx
  103d47:	72 c5                	jb     103d0e <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103d49:	8b 15 c0 78 11 00    	mov    0x1178c0,%edx
  103d4f:	89 d0                	mov    %edx,%eax
  103d51:	c1 e0 02             	shl    $0x2,%eax
  103d54:	01 d0                	add    %edx,%eax
  103d56:	c1 e0 02             	shl    $0x2,%eax
  103d59:	89 c2                	mov    %eax,%edx
  103d5b:	a1 64 79 11 00       	mov    0x117964,%eax
  103d60:	01 d0                	add    %edx,%eax
  103d62:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103d65:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103d6c:	77 23                	ja     103d91 <page_init+0x24d>
  103d6e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103d71:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103d75:	c7 44 24 08 d8 66 10 	movl   $0x1066d8,0x8(%esp)
  103d7c:	00 
  103d7d:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103d84:	00 
  103d85:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  103d8c:	e8 7b ce ff ff       	call   100c0c <__panic>
  103d91:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103d94:	05 00 00 00 40       	add    $0x40000000,%eax
  103d99:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103d9c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103da3:	e9 74 01 00 00       	jmp    103f1c <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103da8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dab:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103dae:	89 d0                	mov    %edx,%eax
  103db0:	c1 e0 02             	shl    $0x2,%eax
  103db3:	01 d0                	add    %edx,%eax
  103db5:	c1 e0 02             	shl    $0x2,%eax
  103db8:	01 c8                	add    %ecx,%eax
  103dba:	8b 50 08             	mov    0x8(%eax),%edx
  103dbd:	8b 40 04             	mov    0x4(%eax),%eax
  103dc0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103dc3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103dc6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dc9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103dcc:	89 d0                	mov    %edx,%eax
  103dce:	c1 e0 02             	shl    $0x2,%eax
  103dd1:	01 d0                	add    %edx,%eax
  103dd3:	c1 e0 02             	shl    $0x2,%eax
  103dd6:	01 c8                	add    %ecx,%eax
  103dd8:	8b 48 0c             	mov    0xc(%eax),%ecx
  103ddb:	8b 58 10             	mov    0x10(%eax),%ebx
  103dde:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103de1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103de4:	01 c8                	add    %ecx,%eax
  103de6:	11 da                	adc    %ebx,%edx
  103de8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103deb:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  103dee:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103df1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103df4:	89 d0                	mov    %edx,%eax
  103df6:	c1 e0 02             	shl    $0x2,%eax
  103df9:	01 d0                	add    %edx,%eax
  103dfb:	c1 e0 02             	shl    $0x2,%eax
  103dfe:	01 c8                	add    %ecx,%eax
  103e00:	83 c0 14             	add    $0x14,%eax
  103e03:	8b 00                	mov    (%eax),%eax
  103e05:	83 f8 01             	cmp    $0x1,%eax
  103e08:	0f 85 0a 01 00 00    	jne    103f18 <page_init+0x3d4>
            if (begin < freemem) {
  103e0e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103e11:	ba 00 00 00 00       	mov    $0x0,%edx
  103e16:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103e19:	72 17                	jb     103e32 <page_init+0x2ee>
  103e1b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  103e1e:	77 05                	ja     103e25 <page_init+0x2e1>
  103e20:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  103e23:	76 0d                	jbe    103e32 <page_init+0x2ee>
                begin = freemem;
  103e25:	8b 45 a0             	mov    -0x60(%ebp),%eax
  103e28:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103e2b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  103e32:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103e36:	72 1d                	jb     103e55 <page_init+0x311>
  103e38:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  103e3c:	77 09                	ja     103e47 <page_init+0x303>
  103e3e:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  103e45:	76 0e                	jbe    103e55 <page_init+0x311>
                end = KMEMSIZE;
  103e47:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  103e4e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  103e55:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103e58:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103e5b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103e5e:	0f 87 b4 00 00 00    	ja     103f18 <page_init+0x3d4>
  103e64:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103e67:	72 09                	jb     103e72 <page_init+0x32e>
  103e69:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103e6c:	0f 83 a6 00 00 00    	jae    103f18 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  103e72:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  103e79:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103e7c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103e7f:	01 d0                	add    %edx,%eax
  103e81:	83 e8 01             	sub    $0x1,%eax
  103e84:	89 45 98             	mov    %eax,-0x68(%ebp)
  103e87:	8b 45 98             	mov    -0x68(%ebp),%eax
  103e8a:	ba 00 00 00 00       	mov    $0x0,%edx
  103e8f:	f7 75 9c             	divl   -0x64(%ebp)
  103e92:	89 d0                	mov    %edx,%eax
  103e94:	8b 55 98             	mov    -0x68(%ebp),%edx
  103e97:	29 c2                	sub    %eax,%edx
  103e99:	89 d0                	mov    %edx,%eax
  103e9b:	ba 00 00 00 00       	mov    $0x0,%edx
  103ea0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103ea3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  103ea6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103ea9:	89 45 94             	mov    %eax,-0x6c(%ebp)
  103eac:	8b 45 94             	mov    -0x6c(%ebp),%eax
  103eaf:	ba 00 00 00 00       	mov    $0x0,%edx
  103eb4:	89 c7                	mov    %eax,%edi
  103eb6:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  103ebc:	89 7d 80             	mov    %edi,-0x80(%ebp)
  103ebf:	89 d0                	mov    %edx,%eax
  103ec1:	83 e0 00             	and    $0x0,%eax
  103ec4:	89 45 84             	mov    %eax,-0x7c(%ebp)
  103ec7:	8b 45 80             	mov    -0x80(%ebp),%eax
  103eca:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103ecd:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103ed0:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  103ed3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103ed6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103ed9:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103edc:	77 3a                	ja     103f18 <page_init+0x3d4>
  103ede:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  103ee1:	72 05                	jb     103ee8 <page_init+0x3a4>
  103ee3:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  103ee6:	73 30                	jae    103f18 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  103ee8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  103eeb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  103eee:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103ef1:	8b 55 cc             	mov    -0x34(%ebp),%edx
  103ef4:	29 c8                	sub    %ecx,%eax
  103ef6:	19 da                	sbb    %ebx,%edx
  103ef8:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103efc:	c1 ea 0c             	shr    $0xc,%edx
  103eff:	89 c3                	mov    %eax,%ebx
  103f01:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103f04:	89 04 24             	mov    %eax,(%esp)
  103f07:	e8 ca f8 ff ff       	call   1037d6 <pa2page>
  103f0c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  103f10:	89 04 24             	mov    %eax,(%esp)
  103f13:	e8 78 fb ff ff       	call   103a90 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  103f18:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103f1c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103f1f:	8b 00                	mov    (%eax),%eax
  103f21:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103f24:	0f 8f 7e fe ff ff    	jg     103da8 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  103f2a:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  103f30:	5b                   	pop    %ebx
  103f31:	5e                   	pop    %esi
  103f32:	5f                   	pop    %edi
  103f33:	5d                   	pop    %ebp
  103f34:	c3                   	ret    

00103f35 <enable_paging>:

static void
enable_paging(void) {
  103f35:	55                   	push   %ebp
  103f36:	89 e5                	mov    %esp,%ebp
  103f38:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  103f3b:	a1 60 79 11 00       	mov    0x117960,%eax
  103f40:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  103f43:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103f46:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  103f49:	0f 20 c0             	mov    %cr0,%eax
  103f4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  103f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  103f52:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  103f55:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  103f5c:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  103f60:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  103f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f69:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  103f6c:	c9                   	leave  
  103f6d:	c3                   	ret    

00103f6e <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  103f6e:	55                   	push   %ebp
  103f6f:	89 e5                	mov    %esp,%ebp
  103f71:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  103f74:	8b 45 14             	mov    0x14(%ebp),%eax
  103f77:	8b 55 0c             	mov    0xc(%ebp),%edx
  103f7a:	31 d0                	xor    %edx,%eax
  103f7c:	25 ff 0f 00 00       	and    $0xfff,%eax
  103f81:	85 c0                	test   %eax,%eax
  103f83:	74 24                	je     103fa9 <boot_map_segment+0x3b>
  103f85:	c7 44 24 0c 0a 67 10 	movl   $0x10670a,0xc(%esp)
  103f8c:	00 
  103f8d:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  103f94:	00 
  103f95:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  103f9c:	00 
  103f9d:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  103fa4:	e8 63 cc ff ff       	call   100c0c <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  103fa9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  103fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  103fb3:	25 ff 0f 00 00       	and    $0xfff,%eax
  103fb8:	89 c2                	mov    %eax,%edx
  103fba:	8b 45 10             	mov    0x10(%ebp),%eax
  103fbd:	01 c2                	add    %eax,%edx
  103fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103fc2:	01 d0                	add    %edx,%eax
  103fc4:	83 e8 01             	sub    $0x1,%eax
  103fc7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103fca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103fcd:	ba 00 00 00 00       	mov    $0x0,%edx
  103fd2:	f7 75 f0             	divl   -0x10(%ebp)
  103fd5:	89 d0                	mov    %edx,%eax
  103fd7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103fda:	29 c2                	sub    %eax,%edx
  103fdc:	89 d0                	mov    %edx,%eax
  103fde:	c1 e8 0c             	shr    $0xc,%eax
  103fe1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  103fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
  103fe7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103fea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103fed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103ff2:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  103ff5:	8b 45 14             	mov    0x14(%ebp),%eax
  103ff8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103ffb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103ffe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104003:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104006:	eb 6b                	jmp    104073 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  104008:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10400f:	00 
  104010:	8b 45 0c             	mov    0xc(%ebp),%eax
  104013:	89 44 24 04          	mov    %eax,0x4(%esp)
  104017:	8b 45 08             	mov    0x8(%ebp),%eax
  10401a:	89 04 24             	mov    %eax,(%esp)
  10401d:	e8 cc 01 00 00       	call   1041ee <get_pte>
  104022:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104025:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104029:	75 24                	jne    10404f <boot_map_segment+0xe1>
  10402b:	c7 44 24 0c 36 67 10 	movl   $0x106736,0xc(%esp)
  104032:	00 
  104033:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  10403a:	00 
  10403b:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  104042:	00 
  104043:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  10404a:	e8 bd cb ff ff       	call   100c0c <__panic>
        *ptep = pa | PTE_P | perm;
  10404f:	8b 45 18             	mov    0x18(%ebp),%eax
  104052:	8b 55 14             	mov    0x14(%ebp),%edx
  104055:	09 d0                	or     %edx,%eax
  104057:	83 c8 01             	or     $0x1,%eax
  10405a:	89 c2                	mov    %eax,%edx
  10405c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10405f:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104061:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  104065:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10406c:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  104073:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104077:	75 8f                	jne    104008 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  104079:	c9                   	leave  
  10407a:	c3                   	ret    

0010407b <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10407b:	55                   	push   %ebp
  10407c:	89 e5                	mov    %esp,%ebp
  10407e:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  104081:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104088:	e8 22 fa ff ff       	call   103aaf <alloc_pages>
  10408d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  104090:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104094:	75 1c                	jne    1040b2 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  104096:	c7 44 24 08 43 67 10 	movl   $0x106743,0x8(%esp)
  10409d:	00 
  10409e:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1040a5:	00 
  1040a6:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  1040ad:	e8 5a cb ff ff       	call   100c0c <__panic>
    }
    return page2kva(p);
  1040b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1040b5:	89 04 24             	mov    %eax,(%esp)
  1040b8:	e8 68 f7 ff ff       	call   103825 <page2kva>
}
  1040bd:	c9                   	leave  
  1040be:	c3                   	ret    

001040bf <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1040bf:	55                   	push   %ebp
  1040c0:	89 e5                	mov    %esp,%ebp
  1040c2:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1040c5:	e8 93 f9 ff ff       	call   103a5d <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1040ca:	e8 75 fa ff ff       	call   103b44 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1040cf:	e8 d7 02 00 00       	call   1043ab <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  1040d4:	e8 a2 ff ff ff       	call   10407b <boot_alloc_page>
  1040d9:	a3 c4 78 11 00       	mov    %eax,0x1178c4
    memset(boot_pgdir, 0, PGSIZE);
  1040de:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  1040e3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1040ea:	00 
  1040eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1040f2:	00 
  1040f3:	89 04 24             	mov    %eax,(%esp)
  1040f6:	e8 19 19 00 00       	call   105a14 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  1040fb:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104100:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104103:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10410a:	77 23                	ja     10412f <pmm_init+0x70>
  10410c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10410f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104113:	c7 44 24 08 d8 66 10 	movl   $0x1066d8,0x8(%esp)
  10411a:	00 
  10411b:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  104122:	00 
  104123:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  10412a:	e8 dd ca ff ff       	call   100c0c <__panic>
  10412f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104132:	05 00 00 00 40       	add    $0x40000000,%eax
  104137:	a3 60 79 11 00       	mov    %eax,0x117960

    check_pgdir();
  10413c:	e8 88 02 00 00       	call   1043c9 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104141:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104146:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  10414c:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104151:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104154:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10415b:	77 23                	ja     104180 <pmm_init+0xc1>
  10415d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104160:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104164:	c7 44 24 08 d8 66 10 	movl   $0x1066d8,0x8(%esp)
  10416b:	00 
  10416c:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  104173:	00 
  104174:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  10417b:	e8 8c ca ff ff       	call   100c0c <__panic>
  104180:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104183:	05 00 00 00 40       	add    $0x40000000,%eax
  104188:	83 c8 03             	or     $0x3,%eax
  10418b:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10418d:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104192:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  104199:	00 
  10419a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1041a1:	00 
  1041a2:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1041a9:	38 
  1041aa:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1041b1:	c0 
  1041b2:	89 04 24             	mov    %eax,(%esp)
  1041b5:	e8 b4 fd ff ff       	call   103f6e <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  1041ba:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  1041bf:	8b 15 c4 78 11 00    	mov    0x1178c4,%edx
  1041c5:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  1041cb:	89 10                	mov    %edx,(%eax)

    enable_paging();
  1041cd:	e8 63 fd ff ff       	call   103f35 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1041d2:	e8 97 f7 ff ff       	call   10396e <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  1041d7:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  1041dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1041e2:	e8 7d 08 00 00       	call   104a64 <check_boot_pgdir>

    print_pgdir();
  1041e7:	e8 0a 0d 00 00       	call   104ef6 <print_pgdir>

}
  1041ec:	c9                   	leave  
  1041ed:	c3                   	ret    

001041ee <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1041ee:	55                   	push   %ebp
  1041ef:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
  1041f1:	5d                   	pop    %ebp
  1041f2:	c3                   	ret    

001041f3 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1041f3:	55                   	push   %ebp
  1041f4:	89 e5                	mov    %esp,%ebp
  1041f6:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1041f9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104200:	00 
  104201:	8b 45 0c             	mov    0xc(%ebp),%eax
  104204:	89 44 24 04          	mov    %eax,0x4(%esp)
  104208:	8b 45 08             	mov    0x8(%ebp),%eax
  10420b:	89 04 24             	mov    %eax,(%esp)
  10420e:	e8 db ff ff ff       	call   1041ee <get_pte>
  104213:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  104216:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10421a:	74 08                	je     104224 <get_page+0x31>
        *ptep_store = ptep;
  10421c:	8b 45 10             	mov    0x10(%ebp),%eax
  10421f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104222:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104224:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104228:	74 1b                	je     104245 <get_page+0x52>
  10422a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10422d:	8b 00                	mov    (%eax),%eax
  10422f:	83 e0 01             	and    $0x1,%eax
  104232:	85 c0                	test   %eax,%eax
  104234:	74 0f                	je     104245 <get_page+0x52>
        return pa2page(*ptep);
  104236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104239:	8b 00                	mov    (%eax),%eax
  10423b:	89 04 24             	mov    %eax,(%esp)
  10423e:	e8 93 f5 ff ff       	call   1037d6 <pa2page>
  104243:	eb 05                	jmp    10424a <get_page+0x57>
    }
    return NULL;
  104245:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10424a:	c9                   	leave  
  10424b:	c3                   	ret    

0010424c <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  10424c:	55                   	push   %ebp
  10424d:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
  10424f:	5d                   	pop    %ebp
  104250:	c3                   	ret    

00104251 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  104251:	55                   	push   %ebp
  104252:	89 e5                	mov    %esp,%ebp
  104254:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104257:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10425e:	00 
  10425f:	8b 45 0c             	mov    0xc(%ebp),%eax
  104262:	89 44 24 04          	mov    %eax,0x4(%esp)
  104266:	8b 45 08             	mov    0x8(%ebp),%eax
  104269:	89 04 24             	mov    %eax,(%esp)
  10426c:	e8 7d ff ff ff       	call   1041ee <get_pte>
  104271:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
  104274:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  104278:	74 19                	je     104293 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  10427a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10427d:	89 44 24 08          	mov    %eax,0x8(%esp)
  104281:	8b 45 0c             	mov    0xc(%ebp),%eax
  104284:	89 44 24 04          	mov    %eax,0x4(%esp)
  104288:	8b 45 08             	mov    0x8(%ebp),%eax
  10428b:	89 04 24             	mov    %eax,(%esp)
  10428e:	e8 b9 ff ff ff       	call   10424c <page_remove_pte>
    }
}
  104293:	c9                   	leave  
  104294:	c3                   	ret    

00104295 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  104295:	55                   	push   %ebp
  104296:	89 e5                	mov    %esp,%ebp
  104298:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  10429b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1042a2:	00 
  1042a3:	8b 45 10             	mov    0x10(%ebp),%eax
  1042a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1042aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1042ad:	89 04 24             	mov    %eax,(%esp)
  1042b0:	e8 39 ff ff ff       	call   1041ee <get_pte>
  1042b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  1042b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1042bc:	75 0a                	jne    1042c8 <page_insert+0x33>
        return -E_NO_MEM;
  1042be:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1042c3:	e9 84 00 00 00       	jmp    10434c <page_insert+0xb7>
    }
    page_ref_inc(page);
  1042c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042cb:	89 04 24             	mov    %eax,(%esp)
  1042ce:	e8 ee f5 ff ff       	call   1038c1 <page_ref_inc>
    if (*ptep & PTE_P) {
  1042d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042d6:	8b 00                	mov    (%eax),%eax
  1042d8:	83 e0 01             	and    $0x1,%eax
  1042db:	85 c0                	test   %eax,%eax
  1042dd:	74 3e                	je     10431d <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1042df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042e2:	8b 00                	mov    (%eax),%eax
  1042e4:	89 04 24             	mov    %eax,(%esp)
  1042e7:	e8 8d f5 ff ff       	call   103879 <pte2page>
  1042ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1042ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1042f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1042f5:	75 0d                	jne    104304 <page_insert+0x6f>
            page_ref_dec(page);
  1042f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1042fa:	89 04 24             	mov    %eax,(%esp)
  1042fd:	e8 d6 f5 ff ff       	call   1038d8 <page_ref_dec>
  104302:	eb 19                	jmp    10431d <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  104304:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104307:	89 44 24 08          	mov    %eax,0x8(%esp)
  10430b:	8b 45 10             	mov    0x10(%ebp),%eax
  10430e:	89 44 24 04          	mov    %eax,0x4(%esp)
  104312:	8b 45 08             	mov    0x8(%ebp),%eax
  104315:	89 04 24             	mov    %eax,(%esp)
  104318:	e8 2f ff ff ff       	call   10424c <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  10431d:	8b 45 0c             	mov    0xc(%ebp),%eax
  104320:	89 04 24             	mov    %eax,(%esp)
  104323:	e8 98 f4 ff ff       	call   1037c0 <page2pa>
  104328:	0b 45 14             	or     0x14(%ebp),%eax
  10432b:	83 c8 01             	or     $0x1,%eax
  10432e:	89 c2                	mov    %eax,%edx
  104330:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104333:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  104335:	8b 45 10             	mov    0x10(%ebp),%eax
  104338:	89 44 24 04          	mov    %eax,0x4(%esp)
  10433c:	8b 45 08             	mov    0x8(%ebp),%eax
  10433f:	89 04 24             	mov    %eax,(%esp)
  104342:	e8 07 00 00 00       	call   10434e <tlb_invalidate>
    return 0;
  104347:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10434c:	c9                   	leave  
  10434d:	c3                   	ret    

0010434e <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  10434e:	55                   	push   %ebp
  10434f:	89 e5                	mov    %esp,%ebp
  104351:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  104354:	0f 20 d8             	mov    %cr3,%eax
  104357:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  10435a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  10435d:	89 c2                	mov    %eax,%edx
  10435f:	8b 45 08             	mov    0x8(%ebp),%eax
  104362:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104365:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10436c:	77 23                	ja     104391 <tlb_invalidate+0x43>
  10436e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104371:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104375:	c7 44 24 08 d8 66 10 	movl   $0x1066d8,0x8(%esp)
  10437c:	00 
  10437d:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
  104384:	00 
  104385:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  10438c:	e8 7b c8 ff ff       	call   100c0c <__panic>
  104391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104394:	05 00 00 00 40       	add    $0x40000000,%eax
  104399:	39 c2                	cmp    %eax,%edx
  10439b:	75 0c                	jne    1043a9 <tlb_invalidate+0x5b>
        invlpg((void *)la);
  10439d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1043a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  1043a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1043a6:	0f 01 38             	invlpg (%eax)
    }
}
  1043a9:	c9                   	leave  
  1043aa:	c3                   	ret    

001043ab <check_alloc_page>:

static void
check_alloc_page(void) {
  1043ab:	55                   	push   %ebp
  1043ac:	89 e5                	mov    %esp,%ebp
  1043ae:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  1043b1:	a1 5c 79 11 00       	mov    0x11795c,%eax
  1043b6:	8b 40 18             	mov    0x18(%eax),%eax
  1043b9:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1043bb:	c7 04 24 5c 67 10 00 	movl   $0x10675c,(%esp)
  1043c2:	e8 75 bf ff ff       	call   10033c <cprintf>
}
  1043c7:	c9                   	leave  
  1043c8:	c3                   	ret    

001043c9 <check_pgdir>:

static void
check_pgdir(void) {
  1043c9:	55                   	push   %ebp
  1043ca:	89 e5                	mov    %esp,%ebp
  1043cc:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1043cf:	a1 c0 78 11 00       	mov    0x1178c0,%eax
  1043d4:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1043d9:	76 24                	jbe    1043ff <check_pgdir+0x36>
  1043db:	c7 44 24 0c 7b 67 10 	movl   $0x10677b,0xc(%esp)
  1043e2:	00 
  1043e3:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  1043ea:	00 
  1043eb:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  1043f2:	00 
  1043f3:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  1043fa:	e8 0d c8 ff ff       	call   100c0c <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1043ff:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104404:	85 c0                	test   %eax,%eax
  104406:	74 0e                	je     104416 <check_pgdir+0x4d>
  104408:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  10440d:	25 ff 0f 00 00       	and    $0xfff,%eax
  104412:	85 c0                	test   %eax,%eax
  104414:	74 24                	je     10443a <check_pgdir+0x71>
  104416:	c7 44 24 0c 98 67 10 	movl   $0x106798,0xc(%esp)
  10441d:	00 
  10441e:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  104425:	00 
  104426:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  10442d:	00 
  10442e:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104435:	e8 d2 c7 ff ff       	call   100c0c <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  10443a:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  10443f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104446:	00 
  104447:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10444e:	00 
  10444f:	89 04 24             	mov    %eax,(%esp)
  104452:	e8 9c fd ff ff       	call   1041f3 <get_page>
  104457:	85 c0                	test   %eax,%eax
  104459:	74 24                	je     10447f <check_pgdir+0xb6>
  10445b:	c7 44 24 0c d0 67 10 	movl   $0x1067d0,0xc(%esp)
  104462:	00 
  104463:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  10446a:	00 
  10446b:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
  104472:	00 
  104473:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  10447a:	e8 8d c7 ff ff       	call   100c0c <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  10447f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104486:	e8 24 f6 ff ff       	call   103aaf <alloc_pages>
  10448b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  10448e:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104493:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10449a:	00 
  10449b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1044a2:	00 
  1044a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1044a6:	89 54 24 04          	mov    %edx,0x4(%esp)
  1044aa:	89 04 24             	mov    %eax,(%esp)
  1044ad:	e8 e3 fd ff ff       	call   104295 <page_insert>
  1044b2:	85 c0                	test   %eax,%eax
  1044b4:	74 24                	je     1044da <check_pgdir+0x111>
  1044b6:	c7 44 24 0c f8 67 10 	movl   $0x1067f8,0xc(%esp)
  1044bd:	00 
  1044be:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  1044c5:	00 
  1044c6:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
  1044cd:	00 
  1044ce:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  1044d5:	e8 32 c7 ff ff       	call   100c0c <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1044da:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  1044df:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1044e6:	00 
  1044e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1044ee:	00 
  1044ef:	89 04 24             	mov    %eax,(%esp)
  1044f2:	e8 f7 fc ff ff       	call   1041ee <get_pte>
  1044f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1044fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1044fe:	75 24                	jne    104524 <check_pgdir+0x15b>
  104500:	c7 44 24 0c 24 68 10 	movl   $0x106824,0xc(%esp)
  104507:	00 
  104508:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  10450f:	00 
  104510:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  104517:	00 
  104518:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  10451f:	e8 e8 c6 ff ff       	call   100c0c <__panic>
    assert(pa2page(*ptep) == p1);
  104524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104527:	8b 00                	mov    (%eax),%eax
  104529:	89 04 24             	mov    %eax,(%esp)
  10452c:	e8 a5 f2 ff ff       	call   1037d6 <pa2page>
  104531:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104534:	74 24                	je     10455a <check_pgdir+0x191>
  104536:	c7 44 24 0c 51 68 10 	movl   $0x106851,0xc(%esp)
  10453d:	00 
  10453e:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  104545:	00 
  104546:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  10454d:	00 
  10454e:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104555:	e8 b2 c6 ff ff       	call   100c0c <__panic>
    assert(page_ref(p1) == 1);
  10455a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10455d:	89 04 24             	mov    %eax,(%esp)
  104560:	e8 52 f3 ff ff       	call   1038b7 <page_ref>
  104565:	83 f8 01             	cmp    $0x1,%eax
  104568:	74 24                	je     10458e <check_pgdir+0x1c5>
  10456a:	c7 44 24 0c 66 68 10 	movl   $0x106866,0xc(%esp)
  104571:	00 
  104572:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  104579:	00 
  10457a:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  104581:	00 
  104582:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104589:	e8 7e c6 ff ff       	call   100c0c <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  10458e:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104593:	8b 00                	mov    (%eax),%eax
  104595:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10459a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10459d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045a0:	c1 e8 0c             	shr    $0xc,%eax
  1045a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1045a6:	a1 c0 78 11 00       	mov    0x1178c0,%eax
  1045ab:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1045ae:	72 23                	jb     1045d3 <check_pgdir+0x20a>
  1045b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1045b7:	c7 44 24 08 34 66 10 	movl   $0x106634,0x8(%esp)
  1045be:	00 
  1045bf:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  1045c6:	00 
  1045c7:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  1045ce:	e8 39 c6 ff ff       	call   100c0c <__panic>
  1045d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1045d6:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1045db:	83 c0 04             	add    $0x4,%eax
  1045de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1045e1:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  1045e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1045ed:	00 
  1045ee:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1045f5:	00 
  1045f6:	89 04 24             	mov    %eax,(%esp)
  1045f9:	e8 f0 fb ff ff       	call   1041ee <get_pte>
  1045fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104601:	74 24                	je     104627 <check_pgdir+0x25e>
  104603:	c7 44 24 0c 78 68 10 	movl   $0x106878,0xc(%esp)
  10460a:	00 
  10460b:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  104612:	00 
  104613:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  10461a:	00 
  10461b:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104622:	e8 e5 c5 ff ff       	call   100c0c <__panic>

    p2 = alloc_page();
  104627:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10462e:	e8 7c f4 ff ff       	call   103aaf <alloc_pages>
  104633:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104636:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  10463b:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104642:	00 
  104643:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10464a:	00 
  10464b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10464e:	89 54 24 04          	mov    %edx,0x4(%esp)
  104652:	89 04 24             	mov    %eax,(%esp)
  104655:	e8 3b fc ff ff       	call   104295 <page_insert>
  10465a:	85 c0                	test   %eax,%eax
  10465c:	74 24                	je     104682 <check_pgdir+0x2b9>
  10465e:	c7 44 24 0c a0 68 10 	movl   $0x1068a0,0xc(%esp)
  104665:	00 
  104666:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  10466d:	00 
  10466e:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  104675:	00 
  104676:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  10467d:	e8 8a c5 ff ff       	call   100c0c <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104682:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104687:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10468e:	00 
  10468f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104696:	00 
  104697:	89 04 24             	mov    %eax,(%esp)
  10469a:	e8 4f fb ff ff       	call   1041ee <get_pte>
  10469f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1046a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1046a6:	75 24                	jne    1046cc <check_pgdir+0x303>
  1046a8:	c7 44 24 0c d8 68 10 	movl   $0x1068d8,0xc(%esp)
  1046af:	00 
  1046b0:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  1046b7:	00 
  1046b8:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  1046bf:	00 
  1046c0:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  1046c7:	e8 40 c5 ff ff       	call   100c0c <__panic>
    assert(*ptep & PTE_U);
  1046cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046cf:	8b 00                	mov    (%eax),%eax
  1046d1:	83 e0 04             	and    $0x4,%eax
  1046d4:	85 c0                	test   %eax,%eax
  1046d6:	75 24                	jne    1046fc <check_pgdir+0x333>
  1046d8:	c7 44 24 0c 08 69 10 	movl   $0x106908,0xc(%esp)
  1046df:	00 
  1046e0:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  1046e7:	00 
  1046e8:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  1046ef:	00 
  1046f0:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  1046f7:	e8 10 c5 ff ff       	call   100c0c <__panic>
    assert(*ptep & PTE_W);
  1046fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046ff:	8b 00                	mov    (%eax),%eax
  104701:	83 e0 02             	and    $0x2,%eax
  104704:	85 c0                	test   %eax,%eax
  104706:	75 24                	jne    10472c <check_pgdir+0x363>
  104708:	c7 44 24 0c 16 69 10 	movl   $0x106916,0xc(%esp)
  10470f:	00 
  104710:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  104717:	00 
  104718:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  10471f:	00 
  104720:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104727:	e8 e0 c4 ff ff       	call   100c0c <__panic>
    assert(boot_pgdir[0] & PTE_U);
  10472c:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104731:	8b 00                	mov    (%eax),%eax
  104733:	83 e0 04             	and    $0x4,%eax
  104736:	85 c0                	test   %eax,%eax
  104738:	75 24                	jne    10475e <check_pgdir+0x395>
  10473a:	c7 44 24 0c 24 69 10 	movl   $0x106924,0xc(%esp)
  104741:	00 
  104742:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  104749:	00 
  10474a:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  104751:	00 
  104752:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104759:	e8 ae c4 ff ff       	call   100c0c <__panic>
    assert(page_ref(p2) == 1);
  10475e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104761:	89 04 24             	mov    %eax,(%esp)
  104764:	e8 4e f1 ff ff       	call   1038b7 <page_ref>
  104769:	83 f8 01             	cmp    $0x1,%eax
  10476c:	74 24                	je     104792 <check_pgdir+0x3c9>
  10476e:	c7 44 24 0c 3a 69 10 	movl   $0x10693a,0xc(%esp)
  104775:	00 
  104776:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  10477d:	00 
  10477e:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  104785:	00 
  104786:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  10478d:	e8 7a c4 ff ff       	call   100c0c <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104792:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104797:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10479e:	00 
  10479f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1047a6:	00 
  1047a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1047aa:	89 54 24 04          	mov    %edx,0x4(%esp)
  1047ae:	89 04 24             	mov    %eax,(%esp)
  1047b1:	e8 df fa ff ff       	call   104295 <page_insert>
  1047b6:	85 c0                	test   %eax,%eax
  1047b8:	74 24                	je     1047de <check_pgdir+0x415>
  1047ba:	c7 44 24 0c 4c 69 10 	movl   $0x10694c,0xc(%esp)
  1047c1:	00 
  1047c2:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  1047c9:	00 
  1047ca:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  1047d1:	00 
  1047d2:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  1047d9:	e8 2e c4 ff ff       	call   100c0c <__panic>
    assert(page_ref(p1) == 2);
  1047de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1047e1:	89 04 24             	mov    %eax,(%esp)
  1047e4:	e8 ce f0 ff ff       	call   1038b7 <page_ref>
  1047e9:	83 f8 02             	cmp    $0x2,%eax
  1047ec:	74 24                	je     104812 <check_pgdir+0x449>
  1047ee:	c7 44 24 0c 78 69 10 	movl   $0x106978,0xc(%esp)
  1047f5:	00 
  1047f6:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  1047fd:	00 
  1047fe:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  104805:	00 
  104806:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  10480d:	e8 fa c3 ff ff       	call   100c0c <__panic>
    assert(page_ref(p2) == 0);
  104812:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104815:	89 04 24             	mov    %eax,(%esp)
  104818:	e8 9a f0 ff ff       	call   1038b7 <page_ref>
  10481d:	85 c0                	test   %eax,%eax
  10481f:	74 24                	je     104845 <check_pgdir+0x47c>
  104821:	c7 44 24 0c 8a 69 10 	movl   $0x10698a,0xc(%esp)
  104828:	00 
  104829:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  104830:	00 
  104831:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  104838:	00 
  104839:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104840:	e8 c7 c3 ff ff       	call   100c0c <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104845:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  10484a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104851:	00 
  104852:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104859:	00 
  10485a:	89 04 24             	mov    %eax,(%esp)
  10485d:	e8 8c f9 ff ff       	call   1041ee <get_pte>
  104862:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104865:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104869:	75 24                	jne    10488f <check_pgdir+0x4c6>
  10486b:	c7 44 24 0c d8 68 10 	movl   $0x1068d8,0xc(%esp)
  104872:	00 
  104873:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  10487a:	00 
  10487b:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  104882:	00 
  104883:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  10488a:	e8 7d c3 ff ff       	call   100c0c <__panic>
    assert(pa2page(*ptep) == p1);
  10488f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104892:	8b 00                	mov    (%eax),%eax
  104894:	89 04 24             	mov    %eax,(%esp)
  104897:	e8 3a ef ff ff       	call   1037d6 <pa2page>
  10489c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10489f:	74 24                	je     1048c5 <check_pgdir+0x4fc>
  1048a1:	c7 44 24 0c 51 68 10 	movl   $0x106851,0xc(%esp)
  1048a8:	00 
  1048a9:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  1048b0:	00 
  1048b1:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  1048b8:	00 
  1048b9:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  1048c0:	e8 47 c3 ff ff       	call   100c0c <__panic>
    assert((*ptep & PTE_U) == 0);
  1048c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048c8:	8b 00                	mov    (%eax),%eax
  1048ca:	83 e0 04             	and    $0x4,%eax
  1048cd:	85 c0                	test   %eax,%eax
  1048cf:	74 24                	je     1048f5 <check_pgdir+0x52c>
  1048d1:	c7 44 24 0c 9c 69 10 	movl   $0x10699c,0xc(%esp)
  1048d8:	00 
  1048d9:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  1048e0:	00 
  1048e1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  1048e8:	00 
  1048e9:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  1048f0:	e8 17 c3 ff ff       	call   100c0c <__panic>

    page_remove(boot_pgdir, 0x0);
  1048f5:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  1048fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104901:	00 
  104902:	89 04 24             	mov    %eax,(%esp)
  104905:	e8 47 f9 ff ff       	call   104251 <page_remove>
    assert(page_ref(p1) == 1);
  10490a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10490d:	89 04 24             	mov    %eax,(%esp)
  104910:	e8 a2 ef ff ff       	call   1038b7 <page_ref>
  104915:	83 f8 01             	cmp    $0x1,%eax
  104918:	74 24                	je     10493e <check_pgdir+0x575>
  10491a:	c7 44 24 0c 66 68 10 	movl   $0x106866,0xc(%esp)
  104921:	00 
  104922:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  104929:	00 
  10492a:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  104931:	00 
  104932:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104939:	e8 ce c2 ff ff       	call   100c0c <__panic>
    assert(page_ref(p2) == 0);
  10493e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104941:	89 04 24             	mov    %eax,(%esp)
  104944:	e8 6e ef ff ff       	call   1038b7 <page_ref>
  104949:	85 c0                	test   %eax,%eax
  10494b:	74 24                	je     104971 <check_pgdir+0x5a8>
  10494d:	c7 44 24 0c 8a 69 10 	movl   $0x10698a,0xc(%esp)
  104954:	00 
  104955:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  10495c:	00 
  10495d:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  104964:	00 
  104965:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  10496c:	e8 9b c2 ff ff       	call   100c0c <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104971:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104976:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  10497d:	00 
  10497e:	89 04 24             	mov    %eax,(%esp)
  104981:	e8 cb f8 ff ff       	call   104251 <page_remove>
    assert(page_ref(p1) == 0);
  104986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104989:	89 04 24             	mov    %eax,(%esp)
  10498c:	e8 26 ef ff ff       	call   1038b7 <page_ref>
  104991:	85 c0                	test   %eax,%eax
  104993:	74 24                	je     1049b9 <check_pgdir+0x5f0>
  104995:	c7 44 24 0c b1 69 10 	movl   $0x1069b1,0xc(%esp)
  10499c:	00 
  10499d:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  1049a4:	00 
  1049a5:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  1049ac:	00 
  1049ad:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  1049b4:	e8 53 c2 ff ff       	call   100c0c <__panic>
    assert(page_ref(p2) == 0);
  1049b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1049bc:	89 04 24             	mov    %eax,(%esp)
  1049bf:	e8 f3 ee ff ff       	call   1038b7 <page_ref>
  1049c4:	85 c0                	test   %eax,%eax
  1049c6:	74 24                	je     1049ec <check_pgdir+0x623>
  1049c8:	c7 44 24 0c 8a 69 10 	movl   $0x10698a,0xc(%esp)
  1049cf:	00 
  1049d0:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  1049d7:	00 
  1049d8:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  1049df:	00 
  1049e0:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  1049e7:	e8 20 c2 ff ff       	call   100c0c <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  1049ec:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  1049f1:	8b 00                	mov    (%eax),%eax
  1049f3:	89 04 24             	mov    %eax,(%esp)
  1049f6:	e8 db ed ff ff       	call   1037d6 <pa2page>
  1049fb:	89 04 24             	mov    %eax,(%esp)
  1049fe:	e8 b4 ee ff ff       	call   1038b7 <page_ref>
  104a03:	83 f8 01             	cmp    $0x1,%eax
  104a06:	74 24                	je     104a2c <check_pgdir+0x663>
  104a08:	c7 44 24 0c c4 69 10 	movl   $0x1069c4,0xc(%esp)
  104a0f:	00 
  104a10:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  104a17:	00 
  104a18:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104a1f:	00 
  104a20:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104a27:	e8 e0 c1 ff ff       	call   100c0c <__panic>
    free_page(pa2page(boot_pgdir[0]));
  104a2c:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104a31:	8b 00                	mov    (%eax),%eax
  104a33:	89 04 24             	mov    %eax,(%esp)
  104a36:	e8 9b ed ff ff       	call   1037d6 <pa2page>
  104a3b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104a42:	00 
  104a43:	89 04 24             	mov    %eax,(%esp)
  104a46:	e8 9c f0 ff ff       	call   103ae7 <free_pages>
    boot_pgdir[0] = 0;
  104a4b:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104a50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104a56:	c7 04 24 ea 69 10 00 	movl   $0x1069ea,(%esp)
  104a5d:	e8 da b8 ff ff       	call   10033c <cprintf>
}
  104a62:	c9                   	leave  
  104a63:	c3                   	ret    

00104a64 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104a64:	55                   	push   %ebp
  104a65:	89 e5                	mov    %esp,%ebp
  104a67:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104a6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104a71:	e9 ca 00 00 00       	jmp    104b40 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a7f:	c1 e8 0c             	shr    $0xc,%eax
  104a82:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104a85:	a1 c0 78 11 00       	mov    0x1178c0,%eax
  104a8a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104a8d:	72 23                	jb     104ab2 <check_boot_pgdir+0x4e>
  104a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a92:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104a96:	c7 44 24 08 34 66 10 	movl   $0x106634,0x8(%esp)
  104a9d:	00 
  104a9e:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104aa5:	00 
  104aa6:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104aad:	e8 5a c1 ff ff       	call   100c0c <__panic>
  104ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ab5:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104aba:	89 c2                	mov    %eax,%edx
  104abc:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104ac1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104ac8:	00 
  104ac9:	89 54 24 04          	mov    %edx,0x4(%esp)
  104acd:	89 04 24             	mov    %eax,(%esp)
  104ad0:	e8 19 f7 ff ff       	call   1041ee <get_pte>
  104ad5:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104ad8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104adc:	75 24                	jne    104b02 <check_boot_pgdir+0x9e>
  104ade:	c7 44 24 0c 04 6a 10 	movl   $0x106a04,0xc(%esp)
  104ae5:	00 
  104ae6:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  104aed:	00 
  104aee:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  104af5:	00 
  104af6:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104afd:	e8 0a c1 ff ff       	call   100c0c <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104b02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104b05:	8b 00                	mov    (%eax),%eax
  104b07:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104b0c:	89 c2                	mov    %eax,%edx
  104b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b11:	39 c2                	cmp    %eax,%edx
  104b13:	74 24                	je     104b39 <check_boot_pgdir+0xd5>
  104b15:	c7 44 24 0c 41 6a 10 	movl   $0x106a41,0xc(%esp)
  104b1c:	00 
  104b1d:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  104b24:	00 
  104b25:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104b2c:	00 
  104b2d:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104b34:	e8 d3 c0 ff ff       	call   100c0c <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104b39:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104b43:	a1 c0 78 11 00       	mov    0x1178c0,%eax
  104b48:	39 c2                	cmp    %eax,%edx
  104b4a:	0f 82 26 ff ff ff    	jb     104a76 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104b50:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104b55:	05 ac 0f 00 00       	add    $0xfac,%eax
  104b5a:	8b 00                	mov    (%eax),%eax
  104b5c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104b61:	89 c2                	mov    %eax,%edx
  104b63:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104b68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104b6b:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104b72:	77 23                	ja     104b97 <check_boot_pgdir+0x133>
  104b74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104b7b:	c7 44 24 08 d8 66 10 	movl   $0x1066d8,0x8(%esp)
  104b82:	00 
  104b83:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104b8a:	00 
  104b8b:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104b92:	e8 75 c0 ff ff       	call   100c0c <__panic>
  104b97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b9a:	05 00 00 00 40       	add    $0x40000000,%eax
  104b9f:	39 c2                	cmp    %eax,%edx
  104ba1:	74 24                	je     104bc7 <check_boot_pgdir+0x163>
  104ba3:	c7 44 24 0c 58 6a 10 	movl   $0x106a58,0xc(%esp)
  104baa:	00 
  104bab:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  104bb2:	00 
  104bb3:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
  104bba:	00 
  104bbb:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104bc2:	e8 45 c0 ff ff       	call   100c0c <__panic>

    assert(boot_pgdir[0] == 0);
  104bc7:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104bcc:	8b 00                	mov    (%eax),%eax
  104bce:	85 c0                	test   %eax,%eax
  104bd0:	74 24                	je     104bf6 <check_boot_pgdir+0x192>
  104bd2:	c7 44 24 0c 8c 6a 10 	movl   $0x106a8c,0xc(%esp)
  104bd9:	00 
  104bda:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  104be1:	00 
  104be2:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104be9:	00 
  104bea:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104bf1:	e8 16 c0 ff ff       	call   100c0c <__panic>

    struct Page *p;
    p = alloc_page();
  104bf6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104bfd:	e8 ad ee ff ff       	call   103aaf <alloc_pages>
  104c02:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104c05:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104c0a:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104c11:	00 
  104c12:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104c19:	00 
  104c1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104c1d:	89 54 24 04          	mov    %edx,0x4(%esp)
  104c21:	89 04 24             	mov    %eax,(%esp)
  104c24:	e8 6c f6 ff ff       	call   104295 <page_insert>
  104c29:	85 c0                	test   %eax,%eax
  104c2b:	74 24                	je     104c51 <check_boot_pgdir+0x1ed>
  104c2d:	c7 44 24 0c a0 6a 10 	movl   $0x106aa0,0xc(%esp)
  104c34:	00 
  104c35:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  104c3c:	00 
  104c3d:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  104c44:	00 
  104c45:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104c4c:	e8 bb bf ff ff       	call   100c0c <__panic>
    assert(page_ref(p) == 1);
  104c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104c54:	89 04 24             	mov    %eax,(%esp)
  104c57:	e8 5b ec ff ff       	call   1038b7 <page_ref>
  104c5c:	83 f8 01             	cmp    $0x1,%eax
  104c5f:	74 24                	je     104c85 <check_boot_pgdir+0x221>
  104c61:	c7 44 24 0c ce 6a 10 	movl   $0x106ace,0xc(%esp)
  104c68:	00 
  104c69:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  104c70:	00 
  104c71:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  104c78:	00 
  104c79:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104c80:	e8 87 bf ff ff       	call   100c0c <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  104c85:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104c8a:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104c91:	00 
  104c92:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  104c99:	00 
  104c9a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104c9d:	89 54 24 04          	mov    %edx,0x4(%esp)
  104ca1:	89 04 24             	mov    %eax,(%esp)
  104ca4:	e8 ec f5 ff ff       	call   104295 <page_insert>
  104ca9:	85 c0                	test   %eax,%eax
  104cab:	74 24                	je     104cd1 <check_boot_pgdir+0x26d>
  104cad:	c7 44 24 0c e0 6a 10 	movl   $0x106ae0,0xc(%esp)
  104cb4:	00 
  104cb5:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  104cbc:	00 
  104cbd:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  104cc4:	00 
  104cc5:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104ccc:	e8 3b bf ff ff       	call   100c0c <__panic>
    assert(page_ref(p) == 2);
  104cd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104cd4:	89 04 24             	mov    %eax,(%esp)
  104cd7:	e8 db eb ff ff       	call   1038b7 <page_ref>
  104cdc:	83 f8 02             	cmp    $0x2,%eax
  104cdf:	74 24                	je     104d05 <check_boot_pgdir+0x2a1>
  104ce1:	c7 44 24 0c 17 6b 10 	movl   $0x106b17,0xc(%esp)
  104ce8:	00 
  104ce9:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  104cf0:	00 
  104cf1:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
  104cf8:	00 
  104cf9:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104d00:	e8 07 bf ff ff       	call   100c0c <__panic>

    const char *str = "ucore: Hello world!!";
  104d05:	c7 45 dc 28 6b 10 00 	movl   $0x106b28,-0x24(%ebp)
    strcpy((void *)0x100, str);
  104d0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104d0f:	89 44 24 04          	mov    %eax,0x4(%esp)
  104d13:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104d1a:	e8 1e 0a 00 00       	call   10573d <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104d1f:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  104d26:	00 
  104d27:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104d2e:	e8 83 0a 00 00       	call   1057b6 <strcmp>
  104d33:	85 c0                	test   %eax,%eax
  104d35:	74 24                	je     104d5b <check_boot_pgdir+0x2f7>
  104d37:	c7 44 24 0c 40 6b 10 	movl   $0x106b40,0xc(%esp)
  104d3e:	00 
  104d3f:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  104d46:	00 
  104d47:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
  104d4e:	00 
  104d4f:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104d56:	e8 b1 be ff ff       	call   100c0c <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  104d5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104d5e:	89 04 24             	mov    %eax,(%esp)
  104d61:	e8 bf ea ff ff       	call   103825 <page2kva>
  104d66:	05 00 01 00 00       	add    $0x100,%eax
  104d6b:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  104d6e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104d75:	e8 6b 09 00 00       	call   1056e5 <strlen>
  104d7a:	85 c0                	test   %eax,%eax
  104d7c:	74 24                	je     104da2 <check_boot_pgdir+0x33e>
  104d7e:	c7 44 24 0c 78 6b 10 	movl   $0x106b78,0xc(%esp)
  104d85:	00 
  104d86:	c7 44 24 08 21 67 10 	movl   $0x106721,0x8(%esp)
  104d8d:	00 
  104d8e:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  104d95:	00 
  104d96:	c7 04 24 fc 66 10 00 	movl   $0x1066fc,(%esp)
  104d9d:	e8 6a be ff ff       	call   100c0c <__panic>

    free_page(p);
  104da2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104da9:	00 
  104daa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104dad:	89 04 24             	mov    %eax,(%esp)
  104db0:	e8 32 ed ff ff       	call   103ae7 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  104db5:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104dba:	8b 00                	mov    (%eax),%eax
  104dbc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104dc1:	89 04 24             	mov    %eax,(%esp)
  104dc4:	e8 0d ea ff ff       	call   1037d6 <pa2page>
  104dc9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104dd0:	00 
  104dd1:	89 04 24             	mov    %eax,(%esp)
  104dd4:	e8 0e ed ff ff       	call   103ae7 <free_pages>
    boot_pgdir[0] = 0;
  104dd9:	a1 c4 78 11 00       	mov    0x1178c4,%eax
  104dde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  104de4:	c7 04 24 9c 6b 10 00 	movl   $0x106b9c,(%esp)
  104deb:	e8 4c b5 ff ff       	call   10033c <cprintf>
}
  104df0:	c9                   	leave  
  104df1:	c3                   	ret    

00104df2 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  104df2:	55                   	push   %ebp
  104df3:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  104df5:	8b 45 08             	mov    0x8(%ebp),%eax
  104df8:	83 e0 04             	and    $0x4,%eax
  104dfb:	85 c0                	test   %eax,%eax
  104dfd:	74 07                	je     104e06 <perm2str+0x14>
  104dff:	b8 75 00 00 00       	mov    $0x75,%eax
  104e04:	eb 05                	jmp    104e0b <perm2str+0x19>
  104e06:	b8 2d 00 00 00       	mov    $0x2d,%eax
  104e0b:	a2 48 79 11 00       	mov    %al,0x117948
    str[1] = 'r';
  104e10:	c6 05 49 79 11 00 72 	movb   $0x72,0x117949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  104e17:	8b 45 08             	mov    0x8(%ebp),%eax
  104e1a:	83 e0 02             	and    $0x2,%eax
  104e1d:	85 c0                	test   %eax,%eax
  104e1f:	74 07                	je     104e28 <perm2str+0x36>
  104e21:	b8 77 00 00 00       	mov    $0x77,%eax
  104e26:	eb 05                	jmp    104e2d <perm2str+0x3b>
  104e28:	b8 2d 00 00 00       	mov    $0x2d,%eax
  104e2d:	a2 4a 79 11 00       	mov    %al,0x11794a
    str[3] = '\0';
  104e32:	c6 05 4b 79 11 00 00 	movb   $0x0,0x11794b
    return str;
  104e39:	b8 48 79 11 00       	mov    $0x117948,%eax
}
  104e3e:	5d                   	pop    %ebp
  104e3f:	c3                   	ret    

00104e40 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  104e40:	55                   	push   %ebp
  104e41:	89 e5                	mov    %esp,%ebp
  104e43:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  104e46:	8b 45 10             	mov    0x10(%ebp),%eax
  104e49:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104e4c:	72 0a                	jb     104e58 <get_pgtable_items+0x18>
        return 0;
  104e4e:	b8 00 00 00 00       	mov    $0x0,%eax
  104e53:	e9 9c 00 00 00       	jmp    104ef4 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  104e58:	eb 04                	jmp    104e5e <get_pgtable_items+0x1e>
        start ++;
  104e5a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  104e5e:	8b 45 10             	mov    0x10(%ebp),%eax
  104e61:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104e64:	73 18                	jae    104e7e <get_pgtable_items+0x3e>
  104e66:	8b 45 10             	mov    0x10(%ebp),%eax
  104e69:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104e70:	8b 45 14             	mov    0x14(%ebp),%eax
  104e73:	01 d0                	add    %edx,%eax
  104e75:	8b 00                	mov    (%eax),%eax
  104e77:	83 e0 01             	and    $0x1,%eax
  104e7a:	85 c0                	test   %eax,%eax
  104e7c:	74 dc                	je     104e5a <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  104e7e:	8b 45 10             	mov    0x10(%ebp),%eax
  104e81:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104e84:	73 69                	jae    104eef <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  104e86:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  104e8a:	74 08                	je     104e94 <get_pgtable_items+0x54>
            *left_store = start;
  104e8c:	8b 45 18             	mov    0x18(%ebp),%eax
  104e8f:	8b 55 10             	mov    0x10(%ebp),%edx
  104e92:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  104e94:	8b 45 10             	mov    0x10(%ebp),%eax
  104e97:	8d 50 01             	lea    0x1(%eax),%edx
  104e9a:	89 55 10             	mov    %edx,0x10(%ebp)
  104e9d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104ea4:	8b 45 14             	mov    0x14(%ebp),%eax
  104ea7:	01 d0                	add    %edx,%eax
  104ea9:	8b 00                	mov    (%eax),%eax
  104eab:	83 e0 07             	and    $0x7,%eax
  104eae:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104eb1:	eb 04                	jmp    104eb7 <get_pgtable_items+0x77>
            start ++;
  104eb3:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  104eb7:	8b 45 10             	mov    0x10(%ebp),%eax
  104eba:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104ebd:	73 1d                	jae    104edc <get_pgtable_items+0x9c>
  104ebf:	8b 45 10             	mov    0x10(%ebp),%eax
  104ec2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104ec9:	8b 45 14             	mov    0x14(%ebp),%eax
  104ecc:	01 d0                	add    %edx,%eax
  104ece:	8b 00                	mov    (%eax),%eax
  104ed0:	83 e0 07             	and    $0x7,%eax
  104ed3:	89 c2                	mov    %eax,%edx
  104ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104ed8:	39 c2                	cmp    %eax,%edx
  104eda:	74 d7                	je     104eb3 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  104edc:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  104ee0:	74 08                	je     104eea <get_pgtable_items+0xaa>
            *right_store = start;
  104ee2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  104ee5:	8b 55 10             	mov    0x10(%ebp),%edx
  104ee8:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  104eea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104eed:	eb 05                	jmp    104ef4 <get_pgtable_items+0xb4>
    }
    return 0;
  104eef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104ef4:	c9                   	leave  
  104ef5:	c3                   	ret    

00104ef6 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  104ef6:	55                   	push   %ebp
  104ef7:	89 e5                	mov    %esp,%ebp
  104ef9:	57                   	push   %edi
  104efa:	56                   	push   %esi
  104efb:	53                   	push   %ebx
  104efc:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  104eff:	c7 04 24 bc 6b 10 00 	movl   $0x106bbc,(%esp)
  104f06:	e8 31 b4 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  104f0b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  104f12:	e9 fa 00 00 00       	jmp    105011 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104f17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f1a:	89 04 24             	mov    %eax,(%esp)
  104f1d:	e8 d0 fe ff ff       	call   104df2 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  104f22:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  104f25:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104f28:	29 d1                	sub    %edx,%ecx
  104f2a:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104f2c:	89 d6                	mov    %edx,%esi
  104f2e:	c1 e6 16             	shl    $0x16,%esi
  104f31:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104f34:	89 d3                	mov    %edx,%ebx
  104f36:	c1 e3 16             	shl    $0x16,%ebx
  104f39:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104f3c:	89 d1                	mov    %edx,%ecx
  104f3e:	c1 e1 16             	shl    $0x16,%ecx
  104f41:	8b 7d dc             	mov    -0x24(%ebp),%edi
  104f44:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104f47:	29 d7                	sub    %edx,%edi
  104f49:	89 fa                	mov    %edi,%edx
  104f4b:	89 44 24 14          	mov    %eax,0x14(%esp)
  104f4f:	89 74 24 10          	mov    %esi,0x10(%esp)
  104f53:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104f57:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104f5b:	89 54 24 04          	mov    %edx,0x4(%esp)
  104f5f:	c7 04 24 ed 6b 10 00 	movl   $0x106bed,(%esp)
  104f66:	e8 d1 b3 ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  104f6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104f6e:	c1 e0 0a             	shl    $0xa,%eax
  104f71:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104f74:	eb 54                	jmp    104fca <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104f76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f79:	89 04 24             	mov    %eax,(%esp)
  104f7c:	e8 71 fe ff ff       	call   104df2 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  104f81:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  104f84:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104f87:	29 d1                	sub    %edx,%ecx
  104f89:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104f8b:	89 d6                	mov    %edx,%esi
  104f8d:	c1 e6 0c             	shl    $0xc,%esi
  104f90:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104f93:	89 d3                	mov    %edx,%ebx
  104f95:	c1 e3 0c             	shl    $0xc,%ebx
  104f98:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104f9b:	c1 e2 0c             	shl    $0xc,%edx
  104f9e:	89 d1                	mov    %edx,%ecx
  104fa0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  104fa3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104fa6:	29 d7                	sub    %edx,%edi
  104fa8:	89 fa                	mov    %edi,%edx
  104faa:	89 44 24 14          	mov    %eax,0x14(%esp)
  104fae:	89 74 24 10          	mov    %esi,0x10(%esp)
  104fb2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104fb6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104fba:	89 54 24 04          	mov    %edx,0x4(%esp)
  104fbe:	c7 04 24 0c 6c 10 00 	movl   $0x106c0c,(%esp)
  104fc5:	e8 72 b3 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104fca:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  104fcf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104fd2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  104fd5:	89 ce                	mov    %ecx,%esi
  104fd7:	c1 e6 0a             	shl    $0xa,%esi
  104fda:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  104fdd:	89 cb                	mov    %ecx,%ebx
  104fdf:	c1 e3 0a             	shl    $0xa,%ebx
  104fe2:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  104fe5:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  104fe9:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  104fec:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  104ff0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  104ff4:	89 44 24 08          	mov    %eax,0x8(%esp)
  104ff8:	89 74 24 04          	mov    %esi,0x4(%esp)
  104ffc:	89 1c 24             	mov    %ebx,(%esp)
  104fff:	e8 3c fe ff ff       	call   104e40 <get_pgtable_items>
  105004:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105007:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10500b:	0f 85 65 ff ff ff    	jne    104f76 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  105011:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  105016:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105019:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  10501c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105020:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  105023:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105027:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10502b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10502f:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  105036:	00 
  105037:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10503e:	e8 fd fd ff ff       	call   104e40 <get_pgtable_items>
  105043:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105046:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10504a:	0f 85 c7 fe ff ff    	jne    104f17 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  105050:	c7 04 24 30 6c 10 00 	movl   $0x106c30,(%esp)
  105057:	e8 e0 b2 ff ff       	call   10033c <cprintf>
}
  10505c:	83 c4 4c             	add    $0x4c,%esp
  10505f:	5b                   	pop    %ebx
  105060:	5e                   	pop    %esi
  105061:	5f                   	pop    %edi
  105062:	5d                   	pop    %ebp
  105063:	c3                   	ret    

00105064 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105064:	55                   	push   %ebp
  105065:	89 e5                	mov    %esp,%ebp
  105067:	83 ec 58             	sub    $0x58,%esp
  10506a:	8b 45 10             	mov    0x10(%ebp),%eax
  10506d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105070:	8b 45 14             	mov    0x14(%ebp),%eax
  105073:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105076:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105079:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10507c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10507f:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105082:	8b 45 18             	mov    0x18(%ebp),%eax
  105085:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105088:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10508b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10508e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105091:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105094:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105097:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10509a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10509e:	74 1c                	je     1050bc <printnum+0x58>
  1050a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1050a3:	ba 00 00 00 00       	mov    $0x0,%edx
  1050a8:	f7 75 e4             	divl   -0x1c(%ebp)
  1050ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1050ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1050b1:	ba 00 00 00 00       	mov    $0x0,%edx
  1050b6:	f7 75 e4             	divl   -0x1c(%ebp)
  1050b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1050bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1050bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1050c2:	f7 75 e4             	divl   -0x1c(%ebp)
  1050c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1050c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1050cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1050ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1050d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1050d4:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1050d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050da:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1050dd:	8b 45 18             	mov    0x18(%ebp),%eax
  1050e0:	ba 00 00 00 00       	mov    $0x0,%edx
  1050e5:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1050e8:	77 56                	ja     105140 <printnum+0xdc>
  1050ea:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1050ed:	72 05                	jb     1050f4 <printnum+0x90>
  1050ef:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1050f2:	77 4c                	ja     105140 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1050f4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1050f7:	8d 50 ff             	lea    -0x1(%eax),%edx
  1050fa:	8b 45 20             	mov    0x20(%ebp),%eax
  1050fd:	89 44 24 18          	mov    %eax,0x18(%esp)
  105101:	89 54 24 14          	mov    %edx,0x14(%esp)
  105105:	8b 45 18             	mov    0x18(%ebp),%eax
  105108:	89 44 24 10          	mov    %eax,0x10(%esp)
  10510c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10510f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105112:	89 44 24 08          	mov    %eax,0x8(%esp)
  105116:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10511a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10511d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105121:	8b 45 08             	mov    0x8(%ebp),%eax
  105124:	89 04 24             	mov    %eax,(%esp)
  105127:	e8 38 ff ff ff       	call   105064 <printnum>
  10512c:	eb 1c                	jmp    10514a <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10512e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105131:	89 44 24 04          	mov    %eax,0x4(%esp)
  105135:	8b 45 20             	mov    0x20(%ebp),%eax
  105138:	89 04 24             	mov    %eax,(%esp)
  10513b:	8b 45 08             	mov    0x8(%ebp),%eax
  10513e:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  105140:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105144:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105148:	7f e4                	jg     10512e <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10514a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10514d:	05 e4 6c 10 00       	add    $0x106ce4,%eax
  105152:	0f b6 00             	movzbl (%eax),%eax
  105155:	0f be c0             	movsbl %al,%eax
  105158:	8b 55 0c             	mov    0xc(%ebp),%edx
  10515b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10515f:	89 04 24             	mov    %eax,(%esp)
  105162:	8b 45 08             	mov    0x8(%ebp),%eax
  105165:	ff d0                	call   *%eax
}
  105167:	c9                   	leave  
  105168:	c3                   	ret    

00105169 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105169:	55                   	push   %ebp
  10516a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10516c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105170:	7e 14                	jle    105186 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105172:	8b 45 08             	mov    0x8(%ebp),%eax
  105175:	8b 00                	mov    (%eax),%eax
  105177:	8d 48 08             	lea    0x8(%eax),%ecx
  10517a:	8b 55 08             	mov    0x8(%ebp),%edx
  10517d:	89 0a                	mov    %ecx,(%edx)
  10517f:	8b 50 04             	mov    0x4(%eax),%edx
  105182:	8b 00                	mov    (%eax),%eax
  105184:	eb 30                	jmp    1051b6 <getuint+0x4d>
    }
    else if (lflag) {
  105186:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10518a:	74 16                	je     1051a2 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10518c:	8b 45 08             	mov    0x8(%ebp),%eax
  10518f:	8b 00                	mov    (%eax),%eax
  105191:	8d 48 04             	lea    0x4(%eax),%ecx
  105194:	8b 55 08             	mov    0x8(%ebp),%edx
  105197:	89 0a                	mov    %ecx,(%edx)
  105199:	8b 00                	mov    (%eax),%eax
  10519b:	ba 00 00 00 00       	mov    $0x0,%edx
  1051a0:	eb 14                	jmp    1051b6 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1051a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1051a5:	8b 00                	mov    (%eax),%eax
  1051a7:	8d 48 04             	lea    0x4(%eax),%ecx
  1051aa:	8b 55 08             	mov    0x8(%ebp),%edx
  1051ad:	89 0a                	mov    %ecx,(%edx)
  1051af:	8b 00                	mov    (%eax),%eax
  1051b1:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1051b6:	5d                   	pop    %ebp
  1051b7:	c3                   	ret    

001051b8 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1051b8:	55                   	push   %ebp
  1051b9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1051bb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1051bf:	7e 14                	jle    1051d5 <getint+0x1d>
        return va_arg(*ap, long long);
  1051c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1051c4:	8b 00                	mov    (%eax),%eax
  1051c6:	8d 48 08             	lea    0x8(%eax),%ecx
  1051c9:	8b 55 08             	mov    0x8(%ebp),%edx
  1051cc:	89 0a                	mov    %ecx,(%edx)
  1051ce:	8b 50 04             	mov    0x4(%eax),%edx
  1051d1:	8b 00                	mov    (%eax),%eax
  1051d3:	eb 28                	jmp    1051fd <getint+0x45>
    }
    else if (lflag) {
  1051d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1051d9:	74 12                	je     1051ed <getint+0x35>
        return va_arg(*ap, long);
  1051db:	8b 45 08             	mov    0x8(%ebp),%eax
  1051de:	8b 00                	mov    (%eax),%eax
  1051e0:	8d 48 04             	lea    0x4(%eax),%ecx
  1051e3:	8b 55 08             	mov    0x8(%ebp),%edx
  1051e6:	89 0a                	mov    %ecx,(%edx)
  1051e8:	8b 00                	mov    (%eax),%eax
  1051ea:	99                   	cltd   
  1051eb:	eb 10                	jmp    1051fd <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1051ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1051f0:	8b 00                	mov    (%eax),%eax
  1051f2:	8d 48 04             	lea    0x4(%eax),%ecx
  1051f5:	8b 55 08             	mov    0x8(%ebp),%edx
  1051f8:	89 0a                	mov    %ecx,(%edx)
  1051fa:	8b 00                	mov    (%eax),%eax
  1051fc:	99                   	cltd   
    }
}
  1051fd:	5d                   	pop    %ebp
  1051fe:	c3                   	ret    

001051ff <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1051ff:	55                   	push   %ebp
  105200:	89 e5                	mov    %esp,%ebp
  105202:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105205:	8d 45 14             	lea    0x14(%ebp),%eax
  105208:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  10520b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10520e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105212:	8b 45 10             	mov    0x10(%ebp),%eax
  105215:	89 44 24 08          	mov    %eax,0x8(%esp)
  105219:	8b 45 0c             	mov    0xc(%ebp),%eax
  10521c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105220:	8b 45 08             	mov    0x8(%ebp),%eax
  105223:	89 04 24             	mov    %eax,(%esp)
  105226:	e8 02 00 00 00       	call   10522d <vprintfmt>
    va_end(ap);
}
  10522b:	c9                   	leave  
  10522c:	c3                   	ret    

0010522d <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10522d:	55                   	push   %ebp
  10522e:	89 e5                	mov    %esp,%ebp
  105230:	56                   	push   %esi
  105231:	53                   	push   %ebx
  105232:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105235:	eb 18                	jmp    10524f <vprintfmt+0x22>
            if (ch == '\0') {
  105237:	85 db                	test   %ebx,%ebx
  105239:	75 05                	jne    105240 <vprintfmt+0x13>
                return;
  10523b:	e9 d1 03 00 00       	jmp    105611 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  105240:	8b 45 0c             	mov    0xc(%ebp),%eax
  105243:	89 44 24 04          	mov    %eax,0x4(%esp)
  105247:	89 1c 24             	mov    %ebx,(%esp)
  10524a:	8b 45 08             	mov    0x8(%ebp),%eax
  10524d:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10524f:	8b 45 10             	mov    0x10(%ebp),%eax
  105252:	8d 50 01             	lea    0x1(%eax),%edx
  105255:	89 55 10             	mov    %edx,0x10(%ebp)
  105258:	0f b6 00             	movzbl (%eax),%eax
  10525b:	0f b6 d8             	movzbl %al,%ebx
  10525e:	83 fb 25             	cmp    $0x25,%ebx
  105261:	75 d4                	jne    105237 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105263:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105267:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10526e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105271:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105274:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10527b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10527e:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105281:	8b 45 10             	mov    0x10(%ebp),%eax
  105284:	8d 50 01             	lea    0x1(%eax),%edx
  105287:	89 55 10             	mov    %edx,0x10(%ebp)
  10528a:	0f b6 00             	movzbl (%eax),%eax
  10528d:	0f b6 d8             	movzbl %al,%ebx
  105290:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105293:	83 f8 55             	cmp    $0x55,%eax
  105296:	0f 87 44 03 00 00    	ja     1055e0 <vprintfmt+0x3b3>
  10529c:	8b 04 85 08 6d 10 00 	mov    0x106d08(,%eax,4),%eax
  1052a3:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1052a5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1052a9:	eb d6                	jmp    105281 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1052ab:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  1052af:	eb d0                	jmp    105281 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1052b1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  1052b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1052bb:	89 d0                	mov    %edx,%eax
  1052bd:	c1 e0 02             	shl    $0x2,%eax
  1052c0:	01 d0                	add    %edx,%eax
  1052c2:	01 c0                	add    %eax,%eax
  1052c4:	01 d8                	add    %ebx,%eax
  1052c6:	83 e8 30             	sub    $0x30,%eax
  1052c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  1052cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1052cf:	0f b6 00             	movzbl (%eax),%eax
  1052d2:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  1052d5:	83 fb 2f             	cmp    $0x2f,%ebx
  1052d8:	7e 0b                	jle    1052e5 <vprintfmt+0xb8>
  1052da:	83 fb 39             	cmp    $0x39,%ebx
  1052dd:	7f 06                	jg     1052e5 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1052df:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1052e3:	eb d3                	jmp    1052b8 <vprintfmt+0x8b>
            goto process_precision;
  1052e5:	eb 33                	jmp    10531a <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1052e7:	8b 45 14             	mov    0x14(%ebp),%eax
  1052ea:	8d 50 04             	lea    0x4(%eax),%edx
  1052ed:	89 55 14             	mov    %edx,0x14(%ebp)
  1052f0:	8b 00                	mov    (%eax),%eax
  1052f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1052f5:	eb 23                	jmp    10531a <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1052f7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1052fb:	79 0c                	jns    105309 <vprintfmt+0xdc>
                width = 0;
  1052fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105304:	e9 78 ff ff ff       	jmp    105281 <vprintfmt+0x54>
  105309:	e9 73 ff ff ff       	jmp    105281 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  10530e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105315:	e9 67 ff ff ff       	jmp    105281 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  10531a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10531e:	79 12                	jns    105332 <vprintfmt+0x105>
                width = precision, precision = -1;
  105320:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105323:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105326:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10532d:	e9 4f ff ff ff       	jmp    105281 <vprintfmt+0x54>
  105332:	e9 4a ff ff ff       	jmp    105281 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105337:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  10533b:	e9 41 ff ff ff       	jmp    105281 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105340:	8b 45 14             	mov    0x14(%ebp),%eax
  105343:	8d 50 04             	lea    0x4(%eax),%edx
  105346:	89 55 14             	mov    %edx,0x14(%ebp)
  105349:	8b 00                	mov    (%eax),%eax
  10534b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10534e:	89 54 24 04          	mov    %edx,0x4(%esp)
  105352:	89 04 24             	mov    %eax,(%esp)
  105355:	8b 45 08             	mov    0x8(%ebp),%eax
  105358:	ff d0                	call   *%eax
            break;
  10535a:	e9 ac 02 00 00       	jmp    10560b <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  10535f:	8b 45 14             	mov    0x14(%ebp),%eax
  105362:	8d 50 04             	lea    0x4(%eax),%edx
  105365:	89 55 14             	mov    %edx,0x14(%ebp)
  105368:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10536a:	85 db                	test   %ebx,%ebx
  10536c:	79 02                	jns    105370 <vprintfmt+0x143>
                err = -err;
  10536e:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105370:	83 fb 06             	cmp    $0x6,%ebx
  105373:	7f 0b                	jg     105380 <vprintfmt+0x153>
  105375:	8b 34 9d c8 6c 10 00 	mov    0x106cc8(,%ebx,4),%esi
  10537c:	85 f6                	test   %esi,%esi
  10537e:	75 23                	jne    1053a3 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  105380:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105384:	c7 44 24 08 f5 6c 10 	movl   $0x106cf5,0x8(%esp)
  10538b:	00 
  10538c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10538f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105393:	8b 45 08             	mov    0x8(%ebp),%eax
  105396:	89 04 24             	mov    %eax,(%esp)
  105399:	e8 61 fe ff ff       	call   1051ff <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  10539e:	e9 68 02 00 00       	jmp    10560b <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  1053a3:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1053a7:	c7 44 24 08 fe 6c 10 	movl   $0x106cfe,0x8(%esp)
  1053ae:	00 
  1053af:	8b 45 0c             	mov    0xc(%ebp),%eax
  1053b2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1053b6:	8b 45 08             	mov    0x8(%ebp),%eax
  1053b9:	89 04 24             	mov    %eax,(%esp)
  1053bc:	e8 3e fe ff ff       	call   1051ff <printfmt>
            }
            break;
  1053c1:	e9 45 02 00 00       	jmp    10560b <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  1053c6:	8b 45 14             	mov    0x14(%ebp),%eax
  1053c9:	8d 50 04             	lea    0x4(%eax),%edx
  1053cc:	89 55 14             	mov    %edx,0x14(%ebp)
  1053cf:	8b 30                	mov    (%eax),%esi
  1053d1:	85 f6                	test   %esi,%esi
  1053d3:	75 05                	jne    1053da <vprintfmt+0x1ad>
                p = "(null)";
  1053d5:	be 01 6d 10 00       	mov    $0x106d01,%esi
            }
            if (width > 0 && padc != '-') {
  1053da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1053de:	7e 3e                	jle    10541e <vprintfmt+0x1f1>
  1053e0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1053e4:	74 38                	je     10541e <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1053e6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1053e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1053ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1053f0:	89 34 24             	mov    %esi,(%esp)
  1053f3:	e8 15 03 00 00       	call   10570d <strnlen>
  1053f8:	29 c3                	sub    %eax,%ebx
  1053fa:	89 d8                	mov    %ebx,%eax
  1053fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1053ff:	eb 17                	jmp    105418 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  105401:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105405:	8b 55 0c             	mov    0xc(%ebp),%edx
  105408:	89 54 24 04          	mov    %edx,0x4(%esp)
  10540c:	89 04 24             	mov    %eax,(%esp)
  10540f:	8b 45 08             	mov    0x8(%ebp),%eax
  105412:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  105414:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105418:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10541c:	7f e3                	jg     105401 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10541e:	eb 38                	jmp    105458 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  105420:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105424:	74 1f                	je     105445 <vprintfmt+0x218>
  105426:	83 fb 1f             	cmp    $0x1f,%ebx
  105429:	7e 05                	jle    105430 <vprintfmt+0x203>
  10542b:	83 fb 7e             	cmp    $0x7e,%ebx
  10542e:	7e 15                	jle    105445 <vprintfmt+0x218>
                    putch('?', putdat);
  105430:	8b 45 0c             	mov    0xc(%ebp),%eax
  105433:	89 44 24 04          	mov    %eax,0x4(%esp)
  105437:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  10543e:	8b 45 08             	mov    0x8(%ebp),%eax
  105441:	ff d0                	call   *%eax
  105443:	eb 0f                	jmp    105454 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  105445:	8b 45 0c             	mov    0xc(%ebp),%eax
  105448:	89 44 24 04          	mov    %eax,0x4(%esp)
  10544c:	89 1c 24             	mov    %ebx,(%esp)
  10544f:	8b 45 08             	mov    0x8(%ebp),%eax
  105452:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105454:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105458:	89 f0                	mov    %esi,%eax
  10545a:	8d 70 01             	lea    0x1(%eax),%esi
  10545d:	0f b6 00             	movzbl (%eax),%eax
  105460:	0f be d8             	movsbl %al,%ebx
  105463:	85 db                	test   %ebx,%ebx
  105465:	74 10                	je     105477 <vprintfmt+0x24a>
  105467:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10546b:	78 b3                	js     105420 <vprintfmt+0x1f3>
  10546d:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105471:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105475:	79 a9                	jns    105420 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105477:	eb 17                	jmp    105490 <vprintfmt+0x263>
                putch(' ', putdat);
  105479:	8b 45 0c             	mov    0xc(%ebp),%eax
  10547c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105480:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105487:	8b 45 08             	mov    0x8(%ebp),%eax
  10548a:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10548c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105490:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105494:	7f e3                	jg     105479 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  105496:	e9 70 01 00 00       	jmp    10560b <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10549b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10549e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054a2:	8d 45 14             	lea    0x14(%ebp),%eax
  1054a5:	89 04 24             	mov    %eax,(%esp)
  1054a8:	e8 0b fd ff ff       	call   1051b8 <getint>
  1054ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1054b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1054b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1054b9:	85 d2                	test   %edx,%edx
  1054bb:	79 26                	jns    1054e3 <vprintfmt+0x2b6>
                putch('-', putdat);
  1054bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054c4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  1054cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1054ce:	ff d0                	call   *%eax
                num = -(long long)num;
  1054d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1054d6:	f7 d8                	neg    %eax
  1054d8:	83 d2 00             	adc    $0x0,%edx
  1054db:	f7 da                	neg    %edx
  1054dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1054e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1054e3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1054ea:	e9 a8 00 00 00       	jmp    105597 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1054ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1054f2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054f6:	8d 45 14             	lea    0x14(%ebp),%eax
  1054f9:	89 04 24             	mov    %eax,(%esp)
  1054fc:	e8 68 fc ff ff       	call   105169 <getuint>
  105501:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105504:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105507:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10550e:	e9 84 00 00 00       	jmp    105597 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105513:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105516:	89 44 24 04          	mov    %eax,0x4(%esp)
  10551a:	8d 45 14             	lea    0x14(%ebp),%eax
  10551d:	89 04 24             	mov    %eax,(%esp)
  105520:	e8 44 fc ff ff       	call   105169 <getuint>
  105525:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105528:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10552b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105532:	eb 63                	jmp    105597 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  105534:	8b 45 0c             	mov    0xc(%ebp),%eax
  105537:	89 44 24 04          	mov    %eax,0x4(%esp)
  10553b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105542:	8b 45 08             	mov    0x8(%ebp),%eax
  105545:	ff d0                	call   *%eax
            putch('x', putdat);
  105547:	8b 45 0c             	mov    0xc(%ebp),%eax
  10554a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10554e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105555:	8b 45 08             	mov    0x8(%ebp),%eax
  105558:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10555a:	8b 45 14             	mov    0x14(%ebp),%eax
  10555d:	8d 50 04             	lea    0x4(%eax),%edx
  105560:	89 55 14             	mov    %edx,0x14(%ebp)
  105563:	8b 00                	mov    (%eax),%eax
  105565:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105568:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10556f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105576:	eb 1f                	jmp    105597 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105578:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10557b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10557f:	8d 45 14             	lea    0x14(%ebp),%eax
  105582:	89 04 24             	mov    %eax,(%esp)
  105585:	e8 df fb ff ff       	call   105169 <getuint>
  10558a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10558d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105590:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105597:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10559b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10559e:	89 54 24 18          	mov    %edx,0x18(%esp)
  1055a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1055a5:	89 54 24 14          	mov    %edx,0x14(%esp)
  1055a9:	89 44 24 10          	mov    %eax,0x10(%esp)
  1055ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1055b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1055b3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055b7:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1055bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1055c5:	89 04 24             	mov    %eax,(%esp)
  1055c8:	e8 97 fa ff ff       	call   105064 <printnum>
            break;
  1055cd:	eb 3c                	jmp    10560b <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  1055cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055d2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055d6:	89 1c 24             	mov    %ebx,(%esp)
  1055d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1055dc:	ff d0                	call   *%eax
            break;
  1055de:	eb 2b                	jmp    10560b <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1055e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055e3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055e7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1055ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1055f1:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1055f3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1055f7:	eb 04                	jmp    1055fd <vprintfmt+0x3d0>
  1055f9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1055fd:	8b 45 10             	mov    0x10(%ebp),%eax
  105600:	83 e8 01             	sub    $0x1,%eax
  105603:	0f b6 00             	movzbl (%eax),%eax
  105606:	3c 25                	cmp    $0x25,%al
  105608:	75 ef                	jne    1055f9 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  10560a:	90                   	nop
        }
    }
  10560b:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  10560c:	e9 3e fc ff ff       	jmp    10524f <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105611:	83 c4 40             	add    $0x40,%esp
  105614:	5b                   	pop    %ebx
  105615:	5e                   	pop    %esi
  105616:	5d                   	pop    %ebp
  105617:	c3                   	ret    

00105618 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105618:	55                   	push   %ebp
  105619:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10561b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10561e:	8b 40 08             	mov    0x8(%eax),%eax
  105621:	8d 50 01             	lea    0x1(%eax),%edx
  105624:	8b 45 0c             	mov    0xc(%ebp),%eax
  105627:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10562a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10562d:	8b 10                	mov    (%eax),%edx
  10562f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105632:	8b 40 04             	mov    0x4(%eax),%eax
  105635:	39 c2                	cmp    %eax,%edx
  105637:	73 12                	jae    10564b <sprintputch+0x33>
        *b->buf ++ = ch;
  105639:	8b 45 0c             	mov    0xc(%ebp),%eax
  10563c:	8b 00                	mov    (%eax),%eax
  10563e:	8d 48 01             	lea    0x1(%eax),%ecx
  105641:	8b 55 0c             	mov    0xc(%ebp),%edx
  105644:	89 0a                	mov    %ecx,(%edx)
  105646:	8b 55 08             	mov    0x8(%ebp),%edx
  105649:	88 10                	mov    %dl,(%eax)
    }
}
  10564b:	5d                   	pop    %ebp
  10564c:	c3                   	ret    

0010564d <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10564d:	55                   	push   %ebp
  10564e:	89 e5                	mov    %esp,%ebp
  105650:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105653:	8d 45 14             	lea    0x14(%ebp),%eax
  105656:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105659:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10565c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105660:	8b 45 10             	mov    0x10(%ebp),%eax
  105663:	89 44 24 08          	mov    %eax,0x8(%esp)
  105667:	8b 45 0c             	mov    0xc(%ebp),%eax
  10566a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10566e:	8b 45 08             	mov    0x8(%ebp),%eax
  105671:	89 04 24             	mov    %eax,(%esp)
  105674:	e8 08 00 00 00       	call   105681 <vsnprintf>
  105679:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10567c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10567f:	c9                   	leave  
  105680:	c3                   	ret    

00105681 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105681:	55                   	push   %ebp
  105682:	89 e5                	mov    %esp,%ebp
  105684:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105687:	8b 45 08             	mov    0x8(%ebp),%eax
  10568a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10568d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105690:	8d 50 ff             	lea    -0x1(%eax),%edx
  105693:	8b 45 08             	mov    0x8(%ebp),%eax
  105696:	01 d0                	add    %edx,%eax
  105698:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10569b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1056a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1056a6:	74 0a                	je     1056b2 <vsnprintf+0x31>
  1056a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1056ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1056ae:	39 c2                	cmp    %eax,%edx
  1056b0:	76 07                	jbe    1056b9 <vsnprintf+0x38>
        return -E_INVAL;
  1056b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1056b7:	eb 2a                	jmp    1056e3 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1056b9:	8b 45 14             	mov    0x14(%ebp),%eax
  1056bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1056c0:	8b 45 10             	mov    0x10(%ebp),%eax
  1056c3:	89 44 24 08          	mov    %eax,0x8(%esp)
  1056c7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1056ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1056ce:	c7 04 24 18 56 10 00 	movl   $0x105618,(%esp)
  1056d5:	e8 53 fb ff ff       	call   10522d <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1056da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1056dd:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1056e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1056e3:	c9                   	leave  
  1056e4:	c3                   	ret    

001056e5 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1056e5:	55                   	push   %ebp
  1056e6:	89 e5                	mov    %esp,%ebp
  1056e8:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1056eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1056f2:	eb 04                	jmp    1056f8 <strlen+0x13>
        cnt ++;
  1056f4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  1056f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1056fb:	8d 50 01             	lea    0x1(%eax),%edx
  1056fe:	89 55 08             	mov    %edx,0x8(%ebp)
  105701:	0f b6 00             	movzbl (%eax),%eax
  105704:	84 c0                	test   %al,%al
  105706:	75 ec                	jne    1056f4 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105708:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10570b:	c9                   	leave  
  10570c:	c3                   	ret    

0010570d <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10570d:	55                   	push   %ebp
  10570e:	89 e5                	mov    %esp,%ebp
  105710:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105713:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10571a:	eb 04                	jmp    105720 <strnlen+0x13>
        cnt ++;
  10571c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105720:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105723:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105726:	73 10                	jae    105738 <strnlen+0x2b>
  105728:	8b 45 08             	mov    0x8(%ebp),%eax
  10572b:	8d 50 01             	lea    0x1(%eax),%edx
  10572e:	89 55 08             	mov    %edx,0x8(%ebp)
  105731:	0f b6 00             	movzbl (%eax),%eax
  105734:	84 c0                	test   %al,%al
  105736:	75 e4                	jne    10571c <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105738:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10573b:	c9                   	leave  
  10573c:	c3                   	ret    

0010573d <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10573d:	55                   	push   %ebp
  10573e:	89 e5                	mov    %esp,%ebp
  105740:	57                   	push   %edi
  105741:	56                   	push   %esi
  105742:	83 ec 20             	sub    $0x20,%esp
  105745:	8b 45 08             	mov    0x8(%ebp),%eax
  105748:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10574b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10574e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105751:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105757:	89 d1                	mov    %edx,%ecx
  105759:	89 c2                	mov    %eax,%edx
  10575b:	89 ce                	mov    %ecx,%esi
  10575d:	89 d7                	mov    %edx,%edi
  10575f:	ac                   	lods   %ds:(%esi),%al
  105760:	aa                   	stos   %al,%es:(%edi)
  105761:	84 c0                	test   %al,%al
  105763:	75 fa                	jne    10575f <strcpy+0x22>
  105765:	89 fa                	mov    %edi,%edx
  105767:	89 f1                	mov    %esi,%ecx
  105769:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10576c:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10576f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105772:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105775:	83 c4 20             	add    $0x20,%esp
  105778:	5e                   	pop    %esi
  105779:	5f                   	pop    %edi
  10577a:	5d                   	pop    %ebp
  10577b:	c3                   	ret    

0010577c <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  10577c:	55                   	push   %ebp
  10577d:	89 e5                	mov    %esp,%ebp
  10577f:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105782:	8b 45 08             	mov    0x8(%ebp),%eax
  105785:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105788:	eb 21                	jmp    1057ab <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  10578a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10578d:	0f b6 10             	movzbl (%eax),%edx
  105790:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105793:	88 10                	mov    %dl,(%eax)
  105795:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105798:	0f b6 00             	movzbl (%eax),%eax
  10579b:	84 c0                	test   %al,%al
  10579d:	74 04                	je     1057a3 <strncpy+0x27>
            src ++;
  10579f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  1057a3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1057a7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  1057ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1057af:	75 d9                	jne    10578a <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  1057b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1057b4:	c9                   	leave  
  1057b5:	c3                   	ret    

001057b6 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1057b6:	55                   	push   %ebp
  1057b7:	89 e5                	mov    %esp,%ebp
  1057b9:	57                   	push   %edi
  1057ba:	56                   	push   %esi
  1057bb:	83 ec 20             	sub    $0x20,%esp
  1057be:	8b 45 08             	mov    0x8(%ebp),%eax
  1057c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1057c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1057ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1057cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057d0:	89 d1                	mov    %edx,%ecx
  1057d2:	89 c2                	mov    %eax,%edx
  1057d4:	89 ce                	mov    %ecx,%esi
  1057d6:	89 d7                	mov    %edx,%edi
  1057d8:	ac                   	lods   %ds:(%esi),%al
  1057d9:	ae                   	scas   %es:(%edi),%al
  1057da:	75 08                	jne    1057e4 <strcmp+0x2e>
  1057dc:	84 c0                	test   %al,%al
  1057de:	75 f8                	jne    1057d8 <strcmp+0x22>
  1057e0:	31 c0                	xor    %eax,%eax
  1057e2:	eb 04                	jmp    1057e8 <strcmp+0x32>
  1057e4:	19 c0                	sbb    %eax,%eax
  1057e6:	0c 01                	or     $0x1,%al
  1057e8:	89 fa                	mov    %edi,%edx
  1057ea:	89 f1                	mov    %esi,%ecx
  1057ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1057ef:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1057f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  1057f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1057f8:	83 c4 20             	add    $0x20,%esp
  1057fb:	5e                   	pop    %esi
  1057fc:	5f                   	pop    %edi
  1057fd:	5d                   	pop    %ebp
  1057fe:	c3                   	ret    

001057ff <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1057ff:	55                   	push   %ebp
  105800:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105802:	eb 0c                	jmp    105810 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105804:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105808:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10580c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105810:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105814:	74 1a                	je     105830 <strncmp+0x31>
  105816:	8b 45 08             	mov    0x8(%ebp),%eax
  105819:	0f b6 00             	movzbl (%eax),%eax
  10581c:	84 c0                	test   %al,%al
  10581e:	74 10                	je     105830 <strncmp+0x31>
  105820:	8b 45 08             	mov    0x8(%ebp),%eax
  105823:	0f b6 10             	movzbl (%eax),%edx
  105826:	8b 45 0c             	mov    0xc(%ebp),%eax
  105829:	0f b6 00             	movzbl (%eax),%eax
  10582c:	38 c2                	cmp    %al,%dl
  10582e:	74 d4                	je     105804 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105830:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105834:	74 18                	je     10584e <strncmp+0x4f>
  105836:	8b 45 08             	mov    0x8(%ebp),%eax
  105839:	0f b6 00             	movzbl (%eax),%eax
  10583c:	0f b6 d0             	movzbl %al,%edx
  10583f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105842:	0f b6 00             	movzbl (%eax),%eax
  105845:	0f b6 c0             	movzbl %al,%eax
  105848:	29 c2                	sub    %eax,%edx
  10584a:	89 d0                	mov    %edx,%eax
  10584c:	eb 05                	jmp    105853 <strncmp+0x54>
  10584e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105853:	5d                   	pop    %ebp
  105854:	c3                   	ret    

00105855 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105855:	55                   	push   %ebp
  105856:	89 e5                	mov    %esp,%ebp
  105858:	83 ec 04             	sub    $0x4,%esp
  10585b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10585e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105861:	eb 14                	jmp    105877 <strchr+0x22>
        if (*s == c) {
  105863:	8b 45 08             	mov    0x8(%ebp),%eax
  105866:	0f b6 00             	movzbl (%eax),%eax
  105869:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10586c:	75 05                	jne    105873 <strchr+0x1e>
            return (char *)s;
  10586e:	8b 45 08             	mov    0x8(%ebp),%eax
  105871:	eb 13                	jmp    105886 <strchr+0x31>
        }
        s ++;
  105873:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105877:	8b 45 08             	mov    0x8(%ebp),%eax
  10587a:	0f b6 00             	movzbl (%eax),%eax
  10587d:	84 c0                	test   %al,%al
  10587f:	75 e2                	jne    105863 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105881:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105886:	c9                   	leave  
  105887:	c3                   	ret    

00105888 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105888:	55                   	push   %ebp
  105889:	89 e5                	mov    %esp,%ebp
  10588b:	83 ec 04             	sub    $0x4,%esp
  10588e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105891:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105894:	eb 11                	jmp    1058a7 <strfind+0x1f>
        if (*s == c) {
  105896:	8b 45 08             	mov    0x8(%ebp),%eax
  105899:	0f b6 00             	movzbl (%eax),%eax
  10589c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10589f:	75 02                	jne    1058a3 <strfind+0x1b>
            break;
  1058a1:	eb 0e                	jmp    1058b1 <strfind+0x29>
        }
        s ++;
  1058a3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  1058a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1058aa:	0f b6 00             	movzbl (%eax),%eax
  1058ad:	84 c0                	test   %al,%al
  1058af:	75 e5                	jne    105896 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  1058b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1058b4:	c9                   	leave  
  1058b5:	c3                   	ret    

001058b6 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1058b6:	55                   	push   %ebp
  1058b7:	89 e5                	mov    %esp,%ebp
  1058b9:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1058bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1058c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1058ca:	eb 04                	jmp    1058d0 <strtol+0x1a>
        s ++;
  1058cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1058d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1058d3:	0f b6 00             	movzbl (%eax),%eax
  1058d6:	3c 20                	cmp    $0x20,%al
  1058d8:	74 f2                	je     1058cc <strtol+0x16>
  1058da:	8b 45 08             	mov    0x8(%ebp),%eax
  1058dd:	0f b6 00             	movzbl (%eax),%eax
  1058e0:	3c 09                	cmp    $0x9,%al
  1058e2:	74 e8                	je     1058cc <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1058e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1058e7:	0f b6 00             	movzbl (%eax),%eax
  1058ea:	3c 2b                	cmp    $0x2b,%al
  1058ec:	75 06                	jne    1058f4 <strtol+0x3e>
        s ++;
  1058ee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1058f2:	eb 15                	jmp    105909 <strtol+0x53>
    }
    else if (*s == '-') {
  1058f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1058f7:	0f b6 00             	movzbl (%eax),%eax
  1058fa:	3c 2d                	cmp    $0x2d,%al
  1058fc:	75 0b                	jne    105909 <strtol+0x53>
        s ++, neg = 1;
  1058fe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105902:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105909:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10590d:	74 06                	je     105915 <strtol+0x5f>
  10590f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105913:	75 24                	jne    105939 <strtol+0x83>
  105915:	8b 45 08             	mov    0x8(%ebp),%eax
  105918:	0f b6 00             	movzbl (%eax),%eax
  10591b:	3c 30                	cmp    $0x30,%al
  10591d:	75 1a                	jne    105939 <strtol+0x83>
  10591f:	8b 45 08             	mov    0x8(%ebp),%eax
  105922:	83 c0 01             	add    $0x1,%eax
  105925:	0f b6 00             	movzbl (%eax),%eax
  105928:	3c 78                	cmp    $0x78,%al
  10592a:	75 0d                	jne    105939 <strtol+0x83>
        s += 2, base = 16;
  10592c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105930:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105937:	eb 2a                	jmp    105963 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105939:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10593d:	75 17                	jne    105956 <strtol+0xa0>
  10593f:	8b 45 08             	mov    0x8(%ebp),%eax
  105942:	0f b6 00             	movzbl (%eax),%eax
  105945:	3c 30                	cmp    $0x30,%al
  105947:	75 0d                	jne    105956 <strtol+0xa0>
        s ++, base = 8;
  105949:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10594d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105954:	eb 0d                	jmp    105963 <strtol+0xad>
    }
    else if (base == 0) {
  105956:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10595a:	75 07                	jne    105963 <strtol+0xad>
        base = 10;
  10595c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105963:	8b 45 08             	mov    0x8(%ebp),%eax
  105966:	0f b6 00             	movzbl (%eax),%eax
  105969:	3c 2f                	cmp    $0x2f,%al
  10596b:	7e 1b                	jle    105988 <strtol+0xd2>
  10596d:	8b 45 08             	mov    0x8(%ebp),%eax
  105970:	0f b6 00             	movzbl (%eax),%eax
  105973:	3c 39                	cmp    $0x39,%al
  105975:	7f 11                	jg     105988 <strtol+0xd2>
            dig = *s - '0';
  105977:	8b 45 08             	mov    0x8(%ebp),%eax
  10597a:	0f b6 00             	movzbl (%eax),%eax
  10597d:	0f be c0             	movsbl %al,%eax
  105980:	83 e8 30             	sub    $0x30,%eax
  105983:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105986:	eb 48                	jmp    1059d0 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105988:	8b 45 08             	mov    0x8(%ebp),%eax
  10598b:	0f b6 00             	movzbl (%eax),%eax
  10598e:	3c 60                	cmp    $0x60,%al
  105990:	7e 1b                	jle    1059ad <strtol+0xf7>
  105992:	8b 45 08             	mov    0x8(%ebp),%eax
  105995:	0f b6 00             	movzbl (%eax),%eax
  105998:	3c 7a                	cmp    $0x7a,%al
  10599a:	7f 11                	jg     1059ad <strtol+0xf7>
            dig = *s - 'a' + 10;
  10599c:	8b 45 08             	mov    0x8(%ebp),%eax
  10599f:	0f b6 00             	movzbl (%eax),%eax
  1059a2:	0f be c0             	movsbl %al,%eax
  1059a5:	83 e8 57             	sub    $0x57,%eax
  1059a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1059ab:	eb 23                	jmp    1059d0 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1059ad:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b0:	0f b6 00             	movzbl (%eax),%eax
  1059b3:	3c 40                	cmp    $0x40,%al
  1059b5:	7e 3d                	jle    1059f4 <strtol+0x13e>
  1059b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1059ba:	0f b6 00             	movzbl (%eax),%eax
  1059bd:	3c 5a                	cmp    $0x5a,%al
  1059bf:	7f 33                	jg     1059f4 <strtol+0x13e>
            dig = *s - 'A' + 10;
  1059c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1059c4:	0f b6 00             	movzbl (%eax),%eax
  1059c7:	0f be c0             	movsbl %al,%eax
  1059ca:	83 e8 37             	sub    $0x37,%eax
  1059cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1059d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1059d3:	3b 45 10             	cmp    0x10(%ebp),%eax
  1059d6:	7c 02                	jl     1059da <strtol+0x124>
            break;
  1059d8:	eb 1a                	jmp    1059f4 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  1059da:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1059de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1059e1:	0f af 45 10          	imul   0x10(%ebp),%eax
  1059e5:	89 c2                	mov    %eax,%edx
  1059e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1059ea:	01 d0                	add    %edx,%eax
  1059ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1059ef:	e9 6f ff ff ff       	jmp    105963 <strtol+0xad>

    if (endptr) {
  1059f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1059f8:	74 08                	je     105a02 <strtol+0x14c>
        *endptr = (char *) s;
  1059fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059fd:	8b 55 08             	mov    0x8(%ebp),%edx
  105a00:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105a02:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105a06:	74 07                	je     105a0f <strtol+0x159>
  105a08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105a0b:	f7 d8                	neg    %eax
  105a0d:	eb 03                	jmp    105a12 <strtol+0x15c>
  105a0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105a12:	c9                   	leave  
  105a13:	c3                   	ret    

00105a14 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105a14:	55                   	push   %ebp
  105a15:	89 e5                	mov    %esp,%ebp
  105a17:	57                   	push   %edi
  105a18:	83 ec 24             	sub    $0x24,%esp
  105a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a1e:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105a21:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105a25:	8b 55 08             	mov    0x8(%ebp),%edx
  105a28:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105a2b:	88 45 f7             	mov    %al,-0x9(%ebp)
  105a2e:	8b 45 10             	mov    0x10(%ebp),%eax
  105a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105a34:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105a37:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105a3b:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105a3e:	89 d7                	mov    %edx,%edi
  105a40:	f3 aa                	rep stos %al,%es:(%edi)
  105a42:	89 fa                	mov    %edi,%edx
  105a44:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105a47:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105a4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105a4d:	83 c4 24             	add    $0x24,%esp
  105a50:	5f                   	pop    %edi
  105a51:	5d                   	pop    %ebp
  105a52:	c3                   	ret    

00105a53 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105a53:	55                   	push   %ebp
  105a54:	89 e5                	mov    %esp,%ebp
  105a56:	57                   	push   %edi
  105a57:	56                   	push   %esi
  105a58:	53                   	push   %ebx
  105a59:	83 ec 30             	sub    $0x30,%esp
  105a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a62:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a65:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a68:	8b 45 10             	mov    0x10(%ebp),%eax
  105a6b:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a71:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105a74:	73 42                	jae    105ab8 <memmove+0x65>
  105a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105a7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105a7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105a82:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105a85:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105a88:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105a8b:	c1 e8 02             	shr    $0x2,%eax
  105a8e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105a90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105a93:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105a96:	89 d7                	mov    %edx,%edi
  105a98:	89 c6                	mov    %eax,%esi
  105a9a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105a9c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105a9f:	83 e1 03             	and    $0x3,%ecx
  105aa2:	74 02                	je     105aa6 <memmove+0x53>
  105aa4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105aa6:	89 f0                	mov    %esi,%eax
  105aa8:	89 fa                	mov    %edi,%edx
  105aaa:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105aad:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105ab0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105ab3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105ab6:	eb 36                	jmp    105aee <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105ab8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105abb:	8d 50 ff             	lea    -0x1(%eax),%edx
  105abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ac1:	01 c2                	add    %eax,%edx
  105ac3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ac6:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105ac9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105acc:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105acf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105ad2:	89 c1                	mov    %eax,%ecx
  105ad4:	89 d8                	mov    %ebx,%eax
  105ad6:	89 d6                	mov    %edx,%esi
  105ad8:	89 c7                	mov    %eax,%edi
  105ada:	fd                   	std    
  105adb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105add:	fc                   	cld    
  105ade:	89 f8                	mov    %edi,%eax
  105ae0:	89 f2                	mov    %esi,%edx
  105ae2:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105ae5:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105ae8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105aee:	83 c4 30             	add    $0x30,%esp
  105af1:	5b                   	pop    %ebx
  105af2:	5e                   	pop    %esi
  105af3:	5f                   	pop    %edi
  105af4:	5d                   	pop    %ebp
  105af5:	c3                   	ret    

00105af6 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105af6:	55                   	push   %ebp
  105af7:	89 e5                	mov    %esp,%ebp
  105af9:	57                   	push   %edi
  105afa:	56                   	push   %esi
  105afb:	83 ec 20             	sub    $0x20,%esp
  105afe:	8b 45 08             	mov    0x8(%ebp),%eax
  105b01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b04:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b0a:	8b 45 10             	mov    0x10(%ebp),%eax
  105b0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105b10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105b13:	c1 e8 02             	shr    $0x2,%eax
  105b16:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105b18:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b1e:	89 d7                	mov    %edx,%edi
  105b20:	89 c6                	mov    %eax,%esi
  105b22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105b24:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105b27:	83 e1 03             	and    $0x3,%ecx
  105b2a:	74 02                	je     105b2e <memcpy+0x38>
  105b2c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105b2e:	89 f0                	mov    %esi,%eax
  105b30:	89 fa                	mov    %edi,%edx
  105b32:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105b35:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105b38:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105b3e:	83 c4 20             	add    $0x20,%esp
  105b41:	5e                   	pop    %esi
  105b42:	5f                   	pop    %edi
  105b43:	5d                   	pop    %ebp
  105b44:	c3                   	ret    

00105b45 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105b45:	55                   	push   %ebp
  105b46:	89 e5                	mov    %esp,%ebp
  105b48:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  105b4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105b51:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b54:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105b57:	eb 30                	jmp    105b89 <memcmp+0x44>
        if (*s1 != *s2) {
  105b59:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b5c:	0f b6 10             	movzbl (%eax),%edx
  105b5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105b62:	0f b6 00             	movzbl (%eax),%eax
  105b65:	38 c2                	cmp    %al,%dl
  105b67:	74 18                	je     105b81 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105b69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b6c:	0f b6 00             	movzbl (%eax),%eax
  105b6f:	0f b6 d0             	movzbl %al,%edx
  105b72:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105b75:	0f b6 00             	movzbl (%eax),%eax
  105b78:	0f b6 c0             	movzbl %al,%eax
  105b7b:	29 c2                	sub    %eax,%edx
  105b7d:	89 d0                	mov    %edx,%eax
  105b7f:	eb 1a                	jmp    105b9b <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105b81:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105b85:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105b89:	8b 45 10             	mov    0x10(%ebp),%eax
  105b8c:	8d 50 ff             	lea    -0x1(%eax),%edx
  105b8f:	89 55 10             	mov    %edx,0x10(%ebp)
  105b92:	85 c0                	test   %eax,%eax
  105b94:	75 c3                	jne    105b59 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105b96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105b9b:	c9                   	leave  
  105b9c:	c3                   	ret    
