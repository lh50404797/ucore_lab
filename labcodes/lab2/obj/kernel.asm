
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 b6 5d 00 00       	call   c0105e0c <memset>

    cons_init();                // init the console
c0100056:	e8 56 15 00 00       	call   c01015b1 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 a0 5f 10 c0 	movl   $0xc0105fa0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 bc 5f 10 c0 	movl   $0xc0105fbc,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 a4 42 00 00       	call   c0104328 <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 91 16 00 00       	call   c010171a <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 09 18 00 00       	call   c0101897 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 d4 0c 00 00       	call   c0100d67 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 f0 15 00 00       	call   c0101688 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 dd 0b 00 00       	call   c0100c99 <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 c1 5f 10 c0 	movl   $0xc0105fc1,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 cf 5f 10 c0 	movl   $0xc0105fcf,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 dd 5f 10 c0 	movl   $0xc0105fdd,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 eb 5f 10 c0 	movl   $0xc0105feb,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 f9 5f 10 c0 	movl   $0xc0105ff9,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 08 60 10 c0 	movl   $0xc0106008,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 28 60 10 c0 	movl   $0xc0106028,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 47 60 10 c0 	movl   $0xc0106047,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 e3 12 00 00       	call   c01015dd <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 ee 52 00 00       	call   c0105625 <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 6a 12 00 00       	call   c01015dd <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 4a 12 00 00       	call   c0101619 <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 4c 60 10 c0    	movl   $0xc010604c,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 4c 60 10 c0 	movl   $0xc010604c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 a8 72 10 c0 	movl   $0xc01072a8,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 5c 1e 11 c0 	movl   $0xc0111e5c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec 5d 1e 11 c0 	movl   $0xc0111e5d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 88 48 11 c0 	movl   $0xc0114888,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 94 55 00 00       	call   c0105c80 <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 56 60 10 c0 	movl   $0xc0106056,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 6f 60 10 c0 	movl   $0xc010606f,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 95 5f 10 	movl   $0xc0105f95,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 87 60 10 c0 	movl   $0xc0106087,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 9f 60 10 c0 	movl   $0xc010609f,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 b7 60 10 c0 	movl   $0xc01060b7,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 d0 60 10 c0 	movl   $0xc01060d0,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 fa 60 10 c0 	movl   $0xc01060fa,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 16 61 10 c0 	movl   $0xc0106116,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	53                   	push   %ebx
c01009be:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c1:	89 e8                	mov    %ebp,%eax
c01009c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
c01009c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp(),eip=read_eip(),i=0;
c01009c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009cc:	e8 d8 ff ff ff       	call   c01009a9 <read_eip>
c01009d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01009d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for(; i<STACKFRAME_DEPTH && ebp != 0; i++){
c01009db:	eb 6f                	jmp    c0100a4c <print_stackframe+0x92>
        cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n", ebp, eip,
            ((uint32_t *)ebp)[2],((uint32_t *)ebp)[3],((uint32_t *)ebp)[4],((uint32_t *)ebp)[5]);
c01009dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009e0:	83 c0 14             	add    $0x14,%eax
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp(),eip=read_eip(),i=0;
    for(; i<STACKFRAME_DEPTH && ebp != 0; i++){
        cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n", ebp, eip,
c01009e3:	8b 18                	mov    (%eax),%ebx
            ((uint32_t *)ebp)[2],((uint32_t *)ebp)[3],((uint32_t *)ebp)[4],((uint32_t *)ebp)[5]);
c01009e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009e8:	83 c0 10             	add    $0x10,%eax
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp(),eip=read_eip(),i=0;
    for(; i<STACKFRAME_DEPTH && ebp != 0; i++){
        cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n", ebp, eip,
c01009eb:	8b 08                	mov    (%eax),%ecx
            ((uint32_t *)ebp)[2],((uint32_t *)ebp)[3],((uint32_t *)ebp)[4],((uint32_t *)ebp)[5]);
c01009ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f0:	83 c0 0c             	add    $0xc,%eax
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp(),eip=read_eip(),i=0;
    for(; i<STACKFRAME_DEPTH && ebp != 0; i++){
        cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n", ebp, eip,
c01009f3:	8b 10                	mov    (%eax),%edx
            ((uint32_t *)ebp)[2],((uint32_t *)ebp)[3],((uint32_t *)ebp)[4],((uint32_t *)ebp)[5]);
c01009f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f8:	83 c0 08             	add    $0x8,%eax
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp(),eip=read_eip(),i=0;
    for(; i<STACKFRAME_DEPTH && ebp != 0; i++){
        cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n", ebp, eip,
c01009fb:	8b 00                	mov    (%eax),%eax
c01009fd:	89 5c 24 18          	mov    %ebx,0x18(%esp)
c0100a01:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0100a05:	89 54 24 10          	mov    %edx,0x10(%esp)
c0100a09:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a10:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a17:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a1b:	c7 04 24 28 61 10 c0 	movl   $0xc0106128,(%esp)
c0100a22:	e8 15 f9 ff ff       	call   c010033c <cprintf>
            ((uint32_t *)ebp)[2],((uint32_t *)ebp)[3],((uint32_t *)ebp)[4],((uint32_t *)ebp)[5]);
        print_debuginfo(eip - 1);
c0100a27:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a2a:	83 e8 01             	sub    $0x1,%eax
c0100a2d:	89 04 24             	mov    %eax,(%esp)
c0100a30:	e8 d1 fe ff ff       	call   c0100906 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a38:	83 c0 04             	add    $0x4,%eax
c0100a3b:	8b 00                	mov    (%eax),%eax
c0100a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a43:	8b 00                	mov    (%eax),%eax
c0100a45:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp(),eip=read_eip(),i=0;
    for(; i<STACKFRAME_DEPTH && ebp != 0; i++){
c0100a48:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a4c:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a50:	77 06                	ja     c0100a58 <print_stackframe+0x9e>
c0100a52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a56:	75 85                	jne    c01009dd <print_stackframe+0x23>
            ((uint32_t *)ebp)[2],((uint32_t *)ebp)[3],((uint32_t *)ebp)[4],((uint32_t *)ebp)[5]);
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
c0100a58:	83 c4 34             	add    $0x34,%esp
c0100a5b:	5b                   	pop    %ebx
c0100a5c:	5d                   	pop    %ebp
c0100a5d:	c3                   	ret    

c0100a5e <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a5e:	55                   	push   %ebp
c0100a5f:	89 e5                	mov    %esp,%ebp
c0100a61:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a64:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a6b:	eb 0c                	jmp    c0100a79 <parse+0x1b>
            *buf ++ = '\0';
c0100a6d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a70:	8d 50 01             	lea    0x1(%eax),%edx
c0100a73:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a76:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a79:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a7c:	0f b6 00             	movzbl (%eax),%eax
c0100a7f:	84 c0                	test   %al,%al
c0100a81:	74 1d                	je     c0100aa0 <parse+0x42>
c0100a83:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a86:	0f b6 00             	movzbl (%eax),%eax
c0100a89:	0f be c0             	movsbl %al,%eax
c0100a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a90:	c7 04 24 e0 61 10 c0 	movl   $0xc01061e0,(%esp)
c0100a97:	e8 b1 51 00 00       	call   c0105c4d <strchr>
c0100a9c:	85 c0                	test   %eax,%eax
c0100a9e:	75 cd                	jne    c0100a6d <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100aa0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa3:	0f b6 00             	movzbl (%eax),%eax
c0100aa6:	84 c0                	test   %al,%al
c0100aa8:	75 02                	jne    c0100aac <parse+0x4e>
            break;
c0100aaa:	eb 67                	jmp    c0100b13 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100aac:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ab0:	75 14                	jne    c0100ac6 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ab2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ab9:	00 
c0100aba:	c7 04 24 e5 61 10 c0 	movl   $0xc01061e5,(%esp)
c0100ac1:	e8 76 f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ac9:	8d 50 01             	lea    0x1(%eax),%edx
c0100acc:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100acf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ad9:	01 c2                	add    %eax,%edx
c0100adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ade:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100ae0:	eb 04                	jmp    c0100ae6 <parse+0x88>
            buf ++;
c0100ae2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100ae6:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ae9:	0f b6 00             	movzbl (%eax),%eax
c0100aec:	84 c0                	test   %al,%al
c0100aee:	74 1d                	je     c0100b0d <parse+0xaf>
c0100af0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100af3:	0f b6 00             	movzbl (%eax),%eax
c0100af6:	0f be c0             	movsbl %al,%eax
c0100af9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100afd:	c7 04 24 e0 61 10 c0 	movl   $0xc01061e0,(%esp)
c0100b04:	e8 44 51 00 00       	call   c0105c4d <strchr>
c0100b09:	85 c0                	test   %eax,%eax
c0100b0b:	74 d5                	je     c0100ae2 <parse+0x84>
            buf ++;
        }
    }
c0100b0d:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b0e:	e9 66 ff ff ff       	jmp    c0100a79 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b13:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b16:	c9                   	leave  
c0100b17:	c3                   	ret    

c0100b18 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b18:	55                   	push   %ebp
c0100b19:	89 e5                	mov    %esp,%ebp
c0100b1b:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b1e:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b25:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b28:	89 04 24             	mov    %eax,(%esp)
c0100b2b:	e8 2e ff ff ff       	call   c0100a5e <parse>
c0100b30:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b33:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b37:	75 0a                	jne    c0100b43 <runcmd+0x2b>
        return 0;
c0100b39:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b3e:	e9 85 00 00 00       	jmp    c0100bc8 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b43:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b4a:	eb 5c                	jmp    c0100ba8 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b4c:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b52:	89 d0                	mov    %edx,%eax
c0100b54:	01 c0                	add    %eax,%eax
c0100b56:	01 d0                	add    %edx,%eax
c0100b58:	c1 e0 02             	shl    $0x2,%eax
c0100b5b:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b60:	8b 00                	mov    (%eax),%eax
c0100b62:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b66:	89 04 24             	mov    %eax,(%esp)
c0100b69:	e8 40 50 00 00       	call   c0105bae <strcmp>
c0100b6e:	85 c0                	test   %eax,%eax
c0100b70:	75 32                	jne    c0100ba4 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b72:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b75:	89 d0                	mov    %edx,%eax
c0100b77:	01 c0                	add    %eax,%eax
c0100b79:	01 d0                	add    %edx,%eax
c0100b7b:	c1 e0 02             	shl    $0x2,%eax
c0100b7e:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b83:	8b 40 08             	mov    0x8(%eax),%eax
c0100b86:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100b89:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100b8c:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100b8f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100b93:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100b96:	83 c2 04             	add    $0x4,%edx
c0100b99:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100b9d:	89 0c 24             	mov    %ecx,(%esp)
c0100ba0:	ff d0                	call   *%eax
c0100ba2:	eb 24                	jmp    c0100bc8 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ba4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100ba8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bab:	83 f8 02             	cmp    $0x2,%eax
c0100bae:	76 9c                	jbe    c0100b4c <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bb0:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bb7:	c7 04 24 03 62 10 c0 	movl   $0xc0106203,(%esp)
c0100bbe:	e8 79 f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100bc3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bc8:	c9                   	leave  
c0100bc9:	c3                   	ret    

c0100bca <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bca:	55                   	push   %ebp
c0100bcb:	89 e5                	mov    %esp,%ebp
c0100bcd:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bd0:	c7 04 24 1c 62 10 c0 	movl   $0xc010621c,(%esp)
c0100bd7:	e8 60 f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bdc:	c7 04 24 44 62 10 c0 	movl   $0xc0106244,(%esp)
c0100be3:	e8 54 f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100be8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100bec:	74 0b                	je     c0100bf9 <kmonitor+0x2f>
        print_trapframe(tf);
c0100bee:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bf1:	89 04 24             	mov    %eax,(%esp)
c0100bf4:	e8 a4 0e 00 00       	call   c0101a9d <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100bf9:	c7 04 24 69 62 10 c0 	movl   $0xc0106269,(%esp)
c0100c00:	e8 2e f6 ff ff       	call   c0100233 <readline>
c0100c05:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c0c:	74 18                	je     c0100c26 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c11:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c18:	89 04 24             	mov    %eax,(%esp)
c0100c1b:	e8 f8 fe ff ff       	call   c0100b18 <runcmd>
c0100c20:	85 c0                	test   %eax,%eax
c0100c22:	79 02                	jns    c0100c26 <kmonitor+0x5c>
                break;
c0100c24:	eb 02                	jmp    c0100c28 <kmonitor+0x5e>
            }
        }
    }
c0100c26:	eb d1                	jmp    c0100bf9 <kmonitor+0x2f>
}
c0100c28:	c9                   	leave  
c0100c29:	c3                   	ret    

c0100c2a <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c2a:	55                   	push   %ebp
c0100c2b:	89 e5                	mov    %esp,%ebp
c0100c2d:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c30:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c37:	eb 3f                	jmp    c0100c78 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c39:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c3c:	89 d0                	mov    %edx,%eax
c0100c3e:	01 c0                	add    %eax,%eax
c0100c40:	01 d0                	add    %edx,%eax
c0100c42:	c1 e0 02             	shl    $0x2,%eax
c0100c45:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c4a:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c4d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c50:	89 d0                	mov    %edx,%eax
c0100c52:	01 c0                	add    %eax,%eax
c0100c54:	01 d0                	add    %edx,%eax
c0100c56:	c1 e0 02             	shl    $0x2,%eax
c0100c59:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c5e:	8b 00                	mov    (%eax),%eax
c0100c60:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c68:	c7 04 24 6d 62 10 c0 	movl   $0xc010626d,(%esp)
c0100c6f:	e8 c8 f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c74:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c7b:	83 f8 02             	cmp    $0x2,%eax
c0100c7e:	76 b9                	jbe    c0100c39 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100c80:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c85:	c9                   	leave  
c0100c86:	c3                   	ret    

c0100c87 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100c87:	55                   	push   %ebp
c0100c88:	89 e5                	mov    %esp,%ebp
c0100c8a:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100c8d:	e8 de fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100c92:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c97:	c9                   	leave  
c0100c98:	c3                   	ret    

c0100c99 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100c99:	55                   	push   %ebp
c0100c9a:	89 e5                	mov    %esp,%ebp
c0100c9c:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100c9f:	e8 16 fd ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100ca4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca9:	c9                   	leave  
c0100caa:	c3                   	ret    

c0100cab <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cab:	55                   	push   %ebp
c0100cac:	89 e5                	mov    %esp,%ebp
c0100cae:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cb1:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100cb6:	85 c0                	test   %eax,%eax
c0100cb8:	74 02                	je     c0100cbc <__panic+0x11>
        goto panic_dead;
c0100cba:	eb 48                	jmp    c0100d04 <__panic+0x59>
    }
    is_panic = 1;
c0100cbc:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100cc3:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cc6:	8d 45 14             	lea    0x14(%ebp),%eax
c0100cc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ccf:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cd6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cda:	c7 04 24 76 62 10 c0 	movl   $0xc0106276,(%esp)
c0100ce1:	e8 56 f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100ce6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ce9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ced:	8b 45 10             	mov    0x10(%ebp),%eax
c0100cf0:	89 04 24             	mov    %eax,(%esp)
c0100cf3:	e8 11 f6 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100cf8:	c7 04 24 92 62 10 c0 	movl   $0xc0106292,(%esp)
c0100cff:	e8 38 f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d04:	e8 85 09 00 00       	call   c010168e <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d10:	e8 b5 fe ff ff       	call   c0100bca <kmonitor>
    }
c0100d15:	eb f2                	jmp    c0100d09 <__panic+0x5e>

c0100d17 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d17:	55                   	push   %ebp
c0100d18:	89 e5                	mov    %esp,%ebp
c0100d1a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d1d:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d20:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d23:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d26:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d2d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d31:	c7 04 24 94 62 10 c0 	movl   $0xc0106294,(%esp)
c0100d38:	e8 ff f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d40:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d44:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d47:	89 04 24             	mov    %eax,(%esp)
c0100d4a:	e8 ba f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d4f:	c7 04 24 92 62 10 c0 	movl   $0xc0106292,(%esp)
c0100d56:	e8 e1 f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d5b:	c9                   	leave  
c0100d5c:	c3                   	ret    

c0100d5d <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d5d:	55                   	push   %ebp
c0100d5e:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d60:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d65:	5d                   	pop    %ebp
c0100d66:	c3                   	ret    

c0100d67 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d67:	55                   	push   %ebp
c0100d68:	89 e5                	mov    %esp,%ebp
c0100d6a:	83 ec 28             	sub    $0x28,%esp
c0100d6d:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d73:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d77:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d7b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d7f:	ee                   	out    %al,(%dx)
c0100d80:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d86:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100d8a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d8e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100d92:	ee                   	out    %al,(%dx)
c0100d93:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100d99:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100d9d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100da1:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100da5:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100da6:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100dad:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100db0:	c7 04 24 b2 62 10 c0 	movl   $0xc01062b2,(%esp)
c0100db7:	e8 80 f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100dbc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100dc3:	e8 24 09 00 00       	call   c01016ec <pic_enable>
}
c0100dc8:	c9                   	leave  
c0100dc9:	c3                   	ret    

c0100dca <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dca:	55                   	push   %ebp
c0100dcb:	89 e5                	mov    %esp,%ebp
c0100dcd:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dd0:	9c                   	pushf  
c0100dd1:	58                   	pop    %eax
c0100dd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dd8:	25 00 02 00 00       	and    $0x200,%eax
c0100ddd:	85 c0                	test   %eax,%eax
c0100ddf:	74 0c                	je     c0100ded <__intr_save+0x23>
        intr_disable();
c0100de1:	e8 a8 08 00 00       	call   c010168e <intr_disable>
        return 1;
c0100de6:	b8 01 00 00 00       	mov    $0x1,%eax
c0100deb:	eb 05                	jmp    c0100df2 <__intr_save+0x28>
    }
    return 0;
c0100ded:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100df2:	c9                   	leave  
c0100df3:	c3                   	ret    

c0100df4 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100df4:	55                   	push   %ebp
c0100df5:	89 e5                	mov    %esp,%ebp
c0100df7:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100dfa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100dfe:	74 05                	je     c0100e05 <__intr_restore+0x11>
        intr_enable();
c0100e00:	e8 83 08 00 00       	call   c0101688 <intr_enable>
    }
}
c0100e05:	c9                   	leave  
c0100e06:	c3                   	ret    

c0100e07 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e07:	55                   	push   %ebp
c0100e08:	89 e5                	mov    %esp,%ebp
c0100e0a:	83 ec 10             	sub    $0x10,%esp
c0100e0d:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e13:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e17:	89 c2                	mov    %eax,%edx
c0100e19:	ec                   	in     (%dx),%al
c0100e1a:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e1d:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e23:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e27:	89 c2                	mov    %eax,%edx
c0100e29:	ec                   	in     (%dx),%al
c0100e2a:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e2d:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e33:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e37:	89 c2                	mov    %eax,%edx
c0100e39:	ec                   	in     (%dx),%al
c0100e3a:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e3d:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e43:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e47:	89 c2                	mov    %eax,%edx
c0100e49:	ec                   	in     (%dx),%al
c0100e4a:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e4d:	c9                   	leave  
c0100e4e:	c3                   	ret    

c0100e4f <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e4f:	55                   	push   %ebp
c0100e50:	89 e5                	mov    %esp,%ebp
c0100e52:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e55:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e5c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e5f:	0f b7 00             	movzwl (%eax),%eax
c0100e62:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e66:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e69:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e71:	0f b7 00             	movzwl (%eax),%eax
c0100e74:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e78:	74 12                	je     c0100e8c <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e7a:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e81:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100e88:	b4 03 
c0100e8a:	eb 13                	jmp    c0100e9f <cga_init+0x50>
    } else {
        *cp = was;
c0100e8c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e93:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100e96:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100e9d:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100e9f:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ea6:	0f b7 c0             	movzwl %ax,%eax
c0100ea9:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ead:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100eb1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100eb5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100eb9:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100eba:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ec1:	83 c0 01             	add    $0x1,%eax
c0100ec4:	0f b7 c0             	movzwl %ax,%eax
c0100ec7:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ecb:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ecf:	89 c2                	mov    %eax,%edx
c0100ed1:	ec                   	in     (%dx),%al
c0100ed2:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ed5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ed9:	0f b6 c0             	movzbl %al,%eax
c0100edc:	c1 e0 08             	shl    $0x8,%eax
c0100edf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100ee2:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ee9:	0f b7 c0             	movzwl %ax,%eax
c0100eec:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100ef0:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ef4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100ef8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100efc:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100efd:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f04:	83 c0 01             	add    $0x1,%eax
c0100f07:	0f b7 c0             	movzwl %ax,%eax
c0100f0a:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f0e:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f12:	89 c2                	mov    %eax,%edx
c0100f14:	ec                   	in     (%dx),%al
c0100f15:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f18:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f1c:	0f b6 c0             	movzbl %al,%eax
c0100f1f:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f22:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f25:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f2d:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f33:	c9                   	leave  
c0100f34:	c3                   	ret    

c0100f35 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f35:	55                   	push   %ebp
c0100f36:	89 e5                	mov    %esp,%ebp
c0100f38:	83 ec 48             	sub    $0x48,%esp
c0100f3b:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f41:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f45:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f49:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f4d:	ee                   	out    %al,(%dx)
c0100f4e:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f54:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f58:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f5c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f60:	ee                   	out    %al,(%dx)
c0100f61:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f67:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f6b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f6f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f73:	ee                   	out    %al,(%dx)
c0100f74:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f7a:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100f7e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f82:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f86:	ee                   	out    %al,(%dx)
c0100f87:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100f8d:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100f91:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f95:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f99:	ee                   	out    %al,(%dx)
c0100f9a:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fa0:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fa4:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fa8:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fac:	ee                   	out    %al,(%dx)
c0100fad:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fb3:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fb7:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fbb:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fbf:	ee                   	out    %al,(%dx)
c0100fc0:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fc6:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fca:	89 c2                	mov    %eax,%edx
c0100fcc:	ec                   	in     (%dx),%al
c0100fcd:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100fd0:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fd4:	3c ff                	cmp    $0xff,%al
c0100fd6:	0f 95 c0             	setne  %al
c0100fd9:	0f b6 c0             	movzbl %al,%eax
c0100fdc:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0100fe1:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fe7:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0100feb:	89 c2                	mov    %eax,%edx
c0100fed:	ec                   	in     (%dx),%al
c0100fee:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0100ff1:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0100ff7:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0100ffb:	89 c2                	mov    %eax,%edx
c0100ffd:	ec                   	in     (%dx),%al
c0100ffe:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101001:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101006:	85 c0                	test   %eax,%eax
c0101008:	74 0c                	je     c0101016 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010100a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101011:	e8 d6 06 00 00       	call   c01016ec <pic_enable>
    }
}
c0101016:	c9                   	leave  
c0101017:	c3                   	ret    

c0101018 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101018:	55                   	push   %ebp
c0101019:	89 e5                	mov    %esp,%ebp
c010101b:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010101e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101025:	eb 09                	jmp    c0101030 <lpt_putc_sub+0x18>
        delay();
c0101027:	e8 db fd ff ff       	call   c0100e07 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010102c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101030:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101036:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010103a:	89 c2                	mov    %eax,%edx
c010103c:	ec                   	in     (%dx),%al
c010103d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101040:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101044:	84 c0                	test   %al,%al
c0101046:	78 09                	js     c0101051 <lpt_putc_sub+0x39>
c0101048:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c010104f:	7e d6                	jle    c0101027 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101051:	8b 45 08             	mov    0x8(%ebp),%eax
c0101054:	0f b6 c0             	movzbl %al,%eax
c0101057:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010105d:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101060:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101064:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101068:	ee                   	out    %al,(%dx)
c0101069:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c010106f:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101073:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101077:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010107b:	ee                   	out    %al,(%dx)
c010107c:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c0101082:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c0101086:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010108a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010108e:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c010108f:	c9                   	leave  
c0101090:	c3                   	ret    

c0101091 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101091:	55                   	push   %ebp
c0101092:	89 e5                	mov    %esp,%ebp
c0101094:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101097:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010109b:	74 0d                	je     c01010aa <lpt_putc+0x19>
        lpt_putc_sub(c);
c010109d:	8b 45 08             	mov    0x8(%ebp),%eax
c01010a0:	89 04 24             	mov    %eax,(%esp)
c01010a3:	e8 70 ff ff ff       	call   c0101018 <lpt_putc_sub>
c01010a8:	eb 24                	jmp    c01010ce <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010aa:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010b1:	e8 62 ff ff ff       	call   c0101018 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010b6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010bd:	e8 56 ff ff ff       	call   c0101018 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010c2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010c9:	e8 4a ff ff ff       	call   c0101018 <lpt_putc_sub>
    }
}
c01010ce:	c9                   	leave  
c01010cf:	c3                   	ret    

c01010d0 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010d0:	55                   	push   %ebp
c01010d1:	89 e5                	mov    %esp,%ebp
c01010d3:	53                   	push   %ebx
c01010d4:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01010da:	b0 00                	mov    $0x0,%al
c01010dc:	85 c0                	test   %eax,%eax
c01010de:	75 07                	jne    c01010e7 <cga_putc+0x17>
        c |= 0x0700;
c01010e0:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01010e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01010ea:	0f b6 c0             	movzbl %al,%eax
c01010ed:	83 f8 0a             	cmp    $0xa,%eax
c01010f0:	74 4c                	je     c010113e <cga_putc+0x6e>
c01010f2:	83 f8 0d             	cmp    $0xd,%eax
c01010f5:	74 57                	je     c010114e <cga_putc+0x7e>
c01010f7:	83 f8 08             	cmp    $0x8,%eax
c01010fa:	0f 85 88 00 00 00    	jne    c0101188 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101100:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101107:	66 85 c0             	test   %ax,%ax
c010110a:	74 30                	je     c010113c <cga_putc+0x6c>
            crt_pos --;
c010110c:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101113:	83 e8 01             	sub    $0x1,%eax
c0101116:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010111c:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101121:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c0101128:	0f b7 d2             	movzwl %dx,%edx
c010112b:	01 d2                	add    %edx,%edx
c010112d:	01 c2                	add    %eax,%edx
c010112f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101132:	b0 00                	mov    $0x0,%al
c0101134:	83 c8 20             	or     $0x20,%eax
c0101137:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010113a:	eb 72                	jmp    c01011ae <cga_putc+0xde>
c010113c:	eb 70                	jmp    c01011ae <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c010113e:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101145:	83 c0 50             	add    $0x50,%eax
c0101148:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c010114e:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101155:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c010115c:	0f b7 c1             	movzwl %cx,%eax
c010115f:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101165:	c1 e8 10             	shr    $0x10,%eax
c0101168:	89 c2                	mov    %eax,%edx
c010116a:	66 c1 ea 06          	shr    $0x6,%dx
c010116e:	89 d0                	mov    %edx,%eax
c0101170:	c1 e0 02             	shl    $0x2,%eax
c0101173:	01 d0                	add    %edx,%eax
c0101175:	c1 e0 04             	shl    $0x4,%eax
c0101178:	29 c1                	sub    %eax,%ecx
c010117a:	89 ca                	mov    %ecx,%edx
c010117c:	89 d8                	mov    %ebx,%eax
c010117e:	29 d0                	sub    %edx,%eax
c0101180:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c0101186:	eb 26                	jmp    c01011ae <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101188:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c010118e:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101195:	8d 50 01             	lea    0x1(%eax),%edx
c0101198:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c010119f:	0f b7 c0             	movzwl %ax,%eax
c01011a2:	01 c0                	add    %eax,%eax
c01011a4:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01011aa:	66 89 02             	mov    %ax,(%edx)
        break;
c01011ad:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011ae:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011b5:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011b9:	76 5b                	jbe    c0101216 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011bb:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011c0:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011c6:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011cb:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011d2:	00 
c01011d3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011d7:	89 04 24             	mov    %eax,(%esp)
c01011da:	e8 6c 4c 00 00       	call   c0105e4b <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011df:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c01011e6:	eb 15                	jmp    c01011fd <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c01011e8:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01011f0:	01 d2                	add    %edx,%edx
c01011f2:	01 d0                	add    %edx,%eax
c01011f4:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c01011f9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01011fd:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101204:	7e e2                	jle    c01011e8 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101206:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010120d:	83 e8 50             	sub    $0x50,%eax
c0101210:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101216:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010121d:	0f b7 c0             	movzwl %ax,%eax
c0101220:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101224:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101228:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010122c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101230:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101231:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101238:	66 c1 e8 08          	shr    $0x8,%ax
c010123c:	0f b6 c0             	movzbl %al,%eax
c010123f:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101246:	83 c2 01             	add    $0x1,%edx
c0101249:	0f b7 d2             	movzwl %dx,%edx
c010124c:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101250:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101253:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101257:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010125b:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010125c:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101263:	0f b7 c0             	movzwl %ax,%eax
c0101266:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010126a:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c010126e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101272:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101276:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101277:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010127e:	0f b6 c0             	movzbl %al,%eax
c0101281:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101288:	83 c2 01             	add    $0x1,%edx
c010128b:	0f b7 d2             	movzwl %dx,%edx
c010128e:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101292:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101295:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101299:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010129d:	ee                   	out    %al,(%dx)
}
c010129e:	83 c4 34             	add    $0x34,%esp
c01012a1:	5b                   	pop    %ebx
c01012a2:	5d                   	pop    %ebp
c01012a3:	c3                   	ret    

c01012a4 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012a4:	55                   	push   %ebp
c01012a5:	89 e5                	mov    %esp,%ebp
c01012a7:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012b1:	eb 09                	jmp    c01012bc <serial_putc_sub+0x18>
        delay();
c01012b3:	e8 4f fb ff ff       	call   c0100e07 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012b8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012bc:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012c2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012c6:	89 c2                	mov    %eax,%edx
c01012c8:	ec                   	in     (%dx),%al
c01012c9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012cc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012d0:	0f b6 c0             	movzbl %al,%eax
c01012d3:	83 e0 20             	and    $0x20,%eax
c01012d6:	85 c0                	test   %eax,%eax
c01012d8:	75 09                	jne    c01012e3 <serial_putc_sub+0x3f>
c01012da:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012e1:	7e d0                	jle    c01012b3 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c01012e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01012e6:	0f b6 c0             	movzbl %al,%eax
c01012e9:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c01012ef:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01012f2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01012f6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01012fa:	ee                   	out    %al,(%dx)
}
c01012fb:	c9                   	leave  
c01012fc:	c3                   	ret    

c01012fd <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c01012fd:	55                   	push   %ebp
c01012fe:	89 e5                	mov    %esp,%ebp
c0101300:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101303:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101307:	74 0d                	je     c0101316 <serial_putc+0x19>
        serial_putc_sub(c);
c0101309:	8b 45 08             	mov    0x8(%ebp),%eax
c010130c:	89 04 24             	mov    %eax,(%esp)
c010130f:	e8 90 ff ff ff       	call   c01012a4 <serial_putc_sub>
c0101314:	eb 24                	jmp    c010133a <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101316:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010131d:	e8 82 ff ff ff       	call   c01012a4 <serial_putc_sub>
        serial_putc_sub(' ');
c0101322:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101329:	e8 76 ff ff ff       	call   c01012a4 <serial_putc_sub>
        serial_putc_sub('\b');
c010132e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101335:	e8 6a ff ff ff       	call   c01012a4 <serial_putc_sub>
    }
}
c010133a:	c9                   	leave  
c010133b:	c3                   	ret    

c010133c <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010133c:	55                   	push   %ebp
c010133d:	89 e5                	mov    %esp,%ebp
c010133f:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101342:	eb 33                	jmp    c0101377 <cons_intr+0x3b>
        if (c != 0) {
c0101344:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101348:	74 2d                	je     c0101377 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010134a:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c010134f:	8d 50 01             	lea    0x1(%eax),%edx
c0101352:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c0101358:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010135b:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101361:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101366:	3d 00 02 00 00       	cmp    $0x200,%eax
c010136b:	75 0a                	jne    c0101377 <cons_intr+0x3b>
                cons.wpos = 0;
c010136d:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c0101374:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101377:	8b 45 08             	mov    0x8(%ebp),%eax
c010137a:	ff d0                	call   *%eax
c010137c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010137f:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101383:	75 bf                	jne    c0101344 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c0101385:	c9                   	leave  
c0101386:	c3                   	ret    

c0101387 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101387:	55                   	push   %ebp
c0101388:	89 e5                	mov    %esp,%ebp
c010138a:	83 ec 10             	sub    $0x10,%esp
c010138d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101393:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101397:	89 c2                	mov    %eax,%edx
c0101399:	ec                   	in     (%dx),%al
c010139a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010139d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013a1:	0f b6 c0             	movzbl %al,%eax
c01013a4:	83 e0 01             	and    $0x1,%eax
c01013a7:	85 c0                	test   %eax,%eax
c01013a9:	75 07                	jne    c01013b2 <serial_proc_data+0x2b>
        return -1;
c01013ab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013b0:	eb 2a                	jmp    c01013dc <serial_proc_data+0x55>
c01013b2:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013b8:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013bc:	89 c2                	mov    %eax,%edx
c01013be:	ec                   	in     (%dx),%al
c01013bf:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013c2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013c6:	0f b6 c0             	movzbl %al,%eax
c01013c9:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013cc:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013d0:	75 07                	jne    c01013d9 <serial_proc_data+0x52>
        c = '\b';
c01013d2:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013dc:	c9                   	leave  
c01013dd:	c3                   	ret    

c01013de <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013de:	55                   	push   %ebp
c01013df:	89 e5                	mov    %esp,%ebp
c01013e1:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c01013e4:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01013e9:	85 c0                	test   %eax,%eax
c01013eb:	74 0c                	je     c01013f9 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c01013ed:	c7 04 24 87 13 10 c0 	movl   $0xc0101387,(%esp)
c01013f4:	e8 43 ff ff ff       	call   c010133c <cons_intr>
    }
}
c01013f9:	c9                   	leave  
c01013fa:	c3                   	ret    

c01013fb <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01013fb:	55                   	push   %ebp
c01013fc:	89 e5                	mov    %esp,%ebp
c01013fe:	83 ec 38             	sub    $0x38,%esp
c0101401:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101407:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010140b:	89 c2                	mov    %eax,%edx
c010140d:	ec                   	in     (%dx),%al
c010140e:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101411:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101415:	0f b6 c0             	movzbl %al,%eax
c0101418:	83 e0 01             	and    $0x1,%eax
c010141b:	85 c0                	test   %eax,%eax
c010141d:	75 0a                	jne    c0101429 <kbd_proc_data+0x2e>
        return -1;
c010141f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101424:	e9 59 01 00 00       	jmp    c0101582 <kbd_proc_data+0x187>
c0101429:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010142f:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101433:	89 c2                	mov    %eax,%edx
c0101435:	ec                   	in     (%dx),%al
c0101436:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101439:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010143d:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101440:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101444:	75 17                	jne    c010145d <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101446:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010144b:	83 c8 40             	or     $0x40,%eax
c010144e:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101453:	b8 00 00 00 00       	mov    $0x0,%eax
c0101458:	e9 25 01 00 00       	jmp    c0101582 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010145d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101461:	84 c0                	test   %al,%al
c0101463:	79 47                	jns    c01014ac <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101465:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010146a:	83 e0 40             	and    $0x40,%eax
c010146d:	85 c0                	test   %eax,%eax
c010146f:	75 09                	jne    c010147a <kbd_proc_data+0x7f>
c0101471:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101475:	83 e0 7f             	and    $0x7f,%eax
c0101478:	eb 04                	jmp    c010147e <kbd_proc_data+0x83>
c010147a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010147e:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101481:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101485:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c010148c:	83 c8 40             	or     $0x40,%eax
c010148f:	0f b6 c0             	movzbl %al,%eax
c0101492:	f7 d0                	not    %eax
c0101494:	89 c2                	mov    %eax,%edx
c0101496:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010149b:	21 d0                	and    %edx,%eax
c010149d:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014a2:	b8 00 00 00 00       	mov    $0x0,%eax
c01014a7:	e9 d6 00 00 00       	jmp    c0101582 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014ac:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014b1:	83 e0 40             	and    $0x40,%eax
c01014b4:	85 c0                	test   %eax,%eax
c01014b6:	74 11                	je     c01014c9 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014b8:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014bc:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014c1:	83 e0 bf             	and    $0xffffffbf,%eax
c01014c4:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014c9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014cd:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014d4:	0f b6 d0             	movzbl %al,%edx
c01014d7:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014dc:	09 d0                	or     %edx,%eax
c01014de:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c01014e3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014e7:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c01014ee:	0f b6 d0             	movzbl %al,%edx
c01014f1:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014f6:	31 d0                	xor    %edx,%eax
c01014f8:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c01014fd:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101502:	83 e0 03             	and    $0x3,%eax
c0101505:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c010150c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101510:	01 d0                	add    %edx,%eax
c0101512:	0f b6 00             	movzbl (%eax),%eax
c0101515:	0f b6 c0             	movzbl %al,%eax
c0101518:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010151b:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101520:	83 e0 08             	and    $0x8,%eax
c0101523:	85 c0                	test   %eax,%eax
c0101525:	74 22                	je     c0101549 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101527:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010152b:	7e 0c                	jle    c0101539 <kbd_proc_data+0x13e>
c010152d:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101531:	7f 06                	jg     c0101539 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101533:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101537:	eb 10                	jmp    c0101549 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c0101539:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010153d:	7e 0a                	jle    c0101549 <kbd_proc_data+0x14e>
c010153f:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101543:	7f 04                	jg     c0101549 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101545:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101549:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010154e:	f7 d0                	not    %eax
c0101550:	83 e0 06             	and    $0x6,%eax
c0101553:	85 c0                	test   %eax,%eax
c0101555:	75 28                	jne    c010157f <kbd_proc_data+0x184>
c0101557:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010155e:	75 1f                	jne    c010157f <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101560:	c7 04 24 cd 62 10 c0 	movl   $0xc01062cd,(%esp)
c0101567:	e8 d0 ed ff ff       	call   c010033c <cprintf>
c010156c:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101572:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101576:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010157a:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c010157e:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010157f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101582:	c9                   	leave  
c0101583:	c3                   	ret    

c0101584 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101584:	55                   	push   %ebp
c0101585:	89 e5                	mov    %esp,%ebp
c0101587:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c010158a:	c7 04 24 fb 13 10 c0 	movl   $0xc01013fb,(%esp)
c0101591:	e8 a6 fd ff ff       	call   c010133c <cons_intr>
}
c0101596:	c9                   	leave  
c0101597:	c3                   	ret    

c0101598 <kbd_init>:

static void
kbd_init(void) {
c0101598:	55                   	push   %ebp
c0101599:	89 e5                	mov    %esp,%ebp
c010159b:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c010159e:	e8 e1 ff ff ff       	call   c0101584 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015aa:	e8 3d 01 00 00       	call   c01016ec <pic_enable>
}
c01015af:	c9                   	leave  
c01015b0:	c3                   	ret    

c01015b1 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015b1:	55                   	push   %ebp
c01015b2:	89 e5                	mov    %esp,%ebp
c01015b4:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015b7:	e8 93 f8 ff ff       	call   c0100e4f <cga_init>
    serial_init();
c01015bc:	e8 74 f9 ff ff       	call   c0100f35 <serial_init>
    kbd_init();
c01015c1:	e8 d2 ff ff ff       	call   c0101598 <kbd_init>
    if (!serial_exists) {
c01015c6:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015cb:	85 c0                	test   %eax,%eax
c01015cd:	75 0c                	jne    c01015db <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015cf:	c7 04 24 d9 62 10 c0 	movl   $0xc01062d9,(%esp)
c01015d6:	e8 61 ed ff ff       	call   c010033c <cprintf>
    }
}
c01015db:	c9                   	leave  
c01015dc:	c3                   	ret    

c01015dd <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015dd:	55                   	push   %ebp
c01015de:	89 e5                	mov    %esp,%ebp
c01015e0:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01015e3:	e8 e2 f7 ff ff       	call   c0100dca <__intr_save>
c01015e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01015eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01015ee:	89 04 24             	mov    %eax,(%esp)
c01015f1:	e8 9b fa ff ff       	call   c0101091 <lpt_putc>
        cga_putc(c);
c01015f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01015f9:	89 04 24             	mov    %eax,(%esp)
c01015fc:	e8 cf fa ff ff       	call   c01010d0 <cga_putc>
        serial_putc(c);
c0101601:	8b 45 08             	mov    0x8(%ebp),%eax
c0101604:	89 04 24             	mov    %eax,(%esp)
c0101607:	e8 f1 fc ff ff       	call   c01012fd <serial_putc>
    }
    local_intr_restore(intr_flag);
c010160c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010160f:	89 04 24             	mov    %eax,(%esp)
c0101612:	e8 dd f7 ff ff       	call   c0100df4 <__intr_restore>
}
c0101617:	c9                   	leave  
c0101618:	c3                   	ret    

c0101619 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101619:	55                   	push   %ebp
c010161a:	89 e5                	mov    %esp,%ebp
c010161c:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010161f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101626:	e8 9f f7 ff ff       	call   c0100dca <__intr_save>
c010162b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010162e:	e8 ab fd ff ff       	call   c01013de <serial_intr>
        kbd_intr();
c0101633:	e8 4c ff ff ff       	call   c0101584 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101638:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c010163e:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101643:	39 c2                	cmp    %eax,%edx
c0101645:	74 31                	je     c0101678 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101647:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c010164c:	8d 50 01             	lea    0x1(%eax),%edx
c010164f:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c0101655:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c010165c:	0f b6 c0             	movzbl %al,%eax
c010165f:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101662:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101667:	3d 00 02 00 00       	cmp    $0x200,%eax
c010166c:	75 0a                	jne    c0101678 <cons_getc+0x5f>
                cons.rpos = 0;
c010166e:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c0101675:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101678:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010167b:	89 04 24             	mov    %eax,(%esp)
c010167e:	e8 71 f7 ff ff       	call   c0100df4 <__intr_restore>
    return c;
c0101683:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101686:	c9                   	leave  
c0101687:	c3                   	ret    

c0101688 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101688:	55                   	push   %ebp
c0101689:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c010168b:	fb                   	sti    
    sti();
}
c010168c:	5d                   	pop    %ebp
c010168d:	c3                   	ret    

c010168e <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010168e:	55                   	push   %ebp
c010168f:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101691:	fa                   	cli    
    cli();
}
c0101692:	5d                   	pop    %ebp
c0101693:	c3                   	ret    

c0101694 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101694:	55                   	push   %ebp
c0101695:	89 e5                	mov    %esp,%ebp
c0101697:	83 ec 14             	sub    $0x14,%esp
c010169a:	8b 45 08             	mov    0x8(%ebp),%eax
c010169d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016a1:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016a5:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016ab:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016b0:	85 c0                	test   %eax,%eax
c01016b2:	74 36                	je     c01016ea <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016b4:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016b8:	0f b6 c0             	movzbl %al,%eax
c01016bb:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016c1:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016c4:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016c8:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016cc:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016cd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016d1:	66 c1 e8 08          	shr    $0x8,%ax
c01016d5:	0f b6 c0             	movzbl %al,%eax
c01016d8:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016de:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016e1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016e5:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01016e9:	ee                   	out    %al,(%dx)
    }
}
c01016ea:	c9                   	leave  
c01016eb:	c3                   	ret    

c01016ec <pic_enable>:

void
pic_enable(unsigned int irq) {
c01016ec:	55                   	push   %ebp
c01016ed:	89 e5                	mov    %esp,%ebp
c01016ef:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c01016f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01016f5:	ba 01 00 00 00       	mov    $0x1,%edx
c01016fa:	89 c1                	mov    %eax,%ecx
c01016fc:	d3 e2                	shl    %cl,%edx
c01016fe:	89 d0                	mov    %edx,%eax
c0101700:	f7 d0                	not    %eax
c0101702:	89 c2                	mov    %eax,%edx
c0101704:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010170b:	21 d0                	and    %edx,%eax
c010170d:	0f b7 c0             	movzwl %ax,%eax
c0101710:	89 04 24             	mov    %eax,(%esp)
c0101713:	e8 7c ff ff ff       	call   c0101694 <pic_setmask>
}
c0101718:	c9                   	leave  
c0101719:	c3                   	ret    

c010171a <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010171a:	55                   	push   %ebp
c010171b:	89 e5                	mov    %esp,%ebp
c010171d:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101720:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101727:	00 00 00 
c010172a:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101730:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101734:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101738:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010173c:	ee                   	out    %al,(%dx)
c010173d:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101743:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101747:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010174b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010174f:	ee                   	out    %al,(%dx)
c0101750:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101756:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c010175a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010175e:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101762:	ee                   	out    %al,(%dx)
c0101763:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c0101769:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010176d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101771:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101775:	ee                   	out    %al,(%dx)
c0101776:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010177c:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0101780:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101784:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101788:	ee                   	out    %al,(%dx)
c0101789:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c010178f:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0101793:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101797:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010179b:	ee                   	out    %al,(%dx)
c010179c:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017a2:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017a6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017aa:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017ae:	ee                   	out    %al,(%dx)
c01017af:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017b5:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017b9:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017bd:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017c1:	ee                   	out    %al,(%dx)
c01017c2:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017c8:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017cc:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017d0:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017d4:	ee                   	out    %al,(%dx)
c01017d5:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017db:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c01017df:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c01017e3:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01017e7:	ee                   	out    %al,(%dx)
c01017e8:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c01017ee:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c01017f2:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01017f6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01017fa:	ee                   	out    %al,(%dx)
c01017fb:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101801:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101805:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101809:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010180d:	ee                   	out    %al,(%dx)
c010180e:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101814:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101818:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010181c:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101820:	ee                   	out    %al,(%dx)
c0101821:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101827:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c010182b:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010182f:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101833:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101834:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010183b:	66 83 f8 ff          	cmp    $0xffff,%ax
c010183f:	74 12                	je     c0101853 <pic_init+0x139>
        pic_setmask(irq_mask);
c0101841:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c0101848:	0f b7 c0             	movzwl %ax,%eax
c010184b:	89 04 24             	mov    %eax,(%esp)
c010184e:	e8 41 fe ff ff       	call   c0101694 <pic_setmask>
    }
}
c0101853:	c9                   	leave  
c0101854:	c3                   	ret    

c0101855 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101855:	55                   	push   %ebp
c0101856:	89 e5                	mov    %esp,%ebp
c0101858:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010185b:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101862:	00 
c0101863:	c7 04 24 00 63 10 c0 	movl   $0xc0106300,(%esp)
c010186a:	e8 cd ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c010186f:	c7 04 24 0a 63 10 c0 	movl   $0xc010630a,(%esp)
c0101876:	e8 c1 ea ff ff       	call   c010033c <cprintf>
    panic("EOT: kernel seems ok.");
c010187b:	c7 44 24 08 18 63 10 	movl   $0xc0106318,0x8(%esp)
c0101882:	c0 
c0101883:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c010188a:	00 
c010188b:	c7 04 24 2e 63 10 c0 	movl   $0xc010632e,(%esp)
c0101892:	e8 14 f4 ff ff       	call   c0100cab <__panic>

c0101897 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101897:	55                   	push   %ebp
c0101898:	89 e5                	mov    %esp,%ebp
c010189a:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for(i=0; i < 256 ; i++){
c010189d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018a4:	e9 91 01 00 00       	jmp    c0101a3a <idt_init+0x1a3>
        if(i != T_SWITCH_TOK){
c01018a9:	83 7d fc 79          	cmpl   $0x79,-0x4(%ebp)
c01018ad:	0f 84 c4 00 00 00    	je     c0101977 <idt_init+0xe0>
           SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL); 
c01018b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018b6:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018bd:	89 c2                	mov    %eax,%edx
c01018bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018c2:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018c9:	c0 
c01018ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018cd:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018d4:	c0 08 00 
c01018d7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018da:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018e1:	c0 
c01018e2:	83 e2 e0             	and    $0xffffffe0,%edx
c01018e5:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018ef:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018f6:	c0 
c01018f7:	83 e2 1f             	and    $0x1f,%edx
c01018fa:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c0101901:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101904:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010190b:	c0 
c010190c:	83 e2 f0             	and    $0xfffffff0,%edx
c010190f:	83 ca 0e             	or     $0xe,%edx
c0101912:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101919:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010191c:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101923:	c0 
c0101924:	83 e2 ef             	and    $0xffffffef,%edx
c0101927:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010192e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101931:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101938:	c0 
c0101939:	83 e2 9f             	and    $0xffffff9f,%edx
c010193c:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101943:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101946:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010194d:	c0 
c010194e:	83 ca 80             	or     $0xffffff80,%edx
c0101951:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101958:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195b:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101962:	c1 e8 10             	shr    $0x10,%eax
c0101965:	89 c2                	mov    %eax,%edx
c0101967:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010196a:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101971:	c0 
c0101972:	e9 bf 00 00 00       	jmp    c0101a36 <idt_init+0x19f>
        } else{
            SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_USER);
c0101977:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010197a:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101981:	89 c2                	mov    %eax,%edx
c0101983:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101986:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c010198d:	c0 
c010198e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101991:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c0101998:	c0 08 00 
c010199b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010199e:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01019a5:	c0 
c01019a6:	83 e2 e0             	and    $0xffffffe0,%edx
c01019a9:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01019b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019b3:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01019ba:	c0 
c01019bb:	83 e2 1f             	and    $0x1f,%edx
c01019be:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01019c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019c8:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c01019cf:	c0 
c01019d0:	83 e2 f0             	and    $0xfffffff0,%edx
c01019d3:	83 ca 0e             	or     $0xe,%edx
c01019d6:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c01019dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019e0:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c01019e7:	c0 
c01019e8:	83 e2 ef             	and    $0xffffffef,%edx
c01019eb:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c01019f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019f5:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c01019fc:	c0 
c01019fd:	83 ca 60             	or     $0x60,%edx
c0101a00:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101a07:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a0a:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101a11:	c0 
c0101a12:	83 ca 80             	or     $0xffffff80,%edx
c0101a15:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101a1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a1f:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c0101a26:	c1 e8 10             	shr    $0x10,%eax
c0101a29:	89 c2                	mov    %eax,%edx
c0101a2b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101a2e:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c0101a35:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for(i=0; i < 256 ; i++){
c0101a36:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101a3a:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101a41:	0f 8e 62 fe ff ff    	jle    c01018a9 <idt_init+0x12>
c0101a47:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a51:	0f 01 18             	lidtl  (%eax)
        } else{
            SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_USER);
        }
    }
    lidt(&idt_pd);
}
c0101a54:	c9                   	leave  
c0101a55:	c3                   	ret    

c0101a56 <trapname>:

static const char *
trapname(int trapno) {
c0101a56:	55                   	push   %ebp
c0101a57:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a59:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a5c:	83 f8 13             	cmp    $0x13,%eax
c0101a5f:	77 0c                	ja     c0101a6d <trapname+0x17>
        return excnames[trapno];
c0101a61:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a64:	8b 04 85 80 66 10 c0 	mov    -0x3fef9980(,%eax,4),%eax
c0101a6b:	eb 18                	jmp    c0101a85 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a6d:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a71:	7e 0d                	jle    c0101a80 <trapname+0x2a>
c0101a73:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a77:	7f 07                	jg     c0101a80 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a79:	b8 3f 63 10 c0       	mov    $0xc010633f,%eax
c0101a7e:	eb 05                	jmp    c0101a85 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a80:	b8 52 63 10 c0       	mov    $0xc0106352,%eax
}
c0101a85:	5d                   	pop    %ebp
c0101a86:	c3                   	ret    

c0101a87 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a87:	55                   	push   %ebp
c0101a88:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a8d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a91:	66 83 f8 08          	cmp    $0x8,%ax
c0101a95:	0f 94 c0             	sete   %al
c0101a98:	0f b6 c0             	movzbl %al,%eax
}
c0101a9b:	5d                   	pop    %ebp
c0101a9c:	c3                   	ret    

c0101a9d <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a9d:	55                   	push   %ebp
c0101a9e:	89 e5                	mov    %esp,%ebp
c0101aa0:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101aa3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aaa:	c7 04 24 93 63 10 c0 	movl   $0xc0106393,(%esp)
c0101ab1:	e8 86 e8 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c0101ab6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab9:	89 04 24             	mov    %eax,(%esp)
c0101abc:	e8 a1 01 00 00       	call   c0101c62 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101ac1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac4:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101ac8:	0f b7 c0             	movzwl %ax,%eax
c0101acb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101acf:	c7 04 24 a4 63 10 c0 	movl   $0xc01063a4,(%esp)
c0101ad6:	e8 61 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ade:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101ae2:	0f b7 c0             	movzwl %ax,%eax
c0101ae5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ae9:	c7 04 24 b7 63 10 c0 	movl   $0xc01063b7,(%esp)
c0101af0:	e8 47 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101af5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af8:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101afc:	0f b7 c0             	movzwl %ax,%eax
c0101aff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b03:	c7 04 24 ca 63 10 c0 	movl   $0xc01063ca,(%esp)
c0101b0a:	e8 2d e8 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b12:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b16:	0f b7 c0             	movzwl %ax,%eax
c0101b19:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b1d:	c7 04 24 dd 63 10 c0 	movl   $0xc01063dd,(%esp)
c0101b24:	e8 13 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b29:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b2c:	8b 40 30             	mov    0x30(%eax),%eax
c0101b2f:	89 04 24             	mov    %eax,(%esp)
c0101b32:	e8 1f ff ff ff       	call   c0101a56 <trapname>
c0101b37:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b3a:	8b 52 30             	mov    0x30(%edx),%edx
c0101b3d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101b41:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101b45:	c7 04 24 f0 63 10 c0 	movl   $0xc01063f0,(%esp)
c0101b4c:	e8 eb e7 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b51:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b54:	8b 40 34             	mov    0x34(%eax),%eax
c0101b57:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5b:	c7 04 24 02 64 10 c0 	movl   $0xc0106402,(%esp)
c0101b62:	e8 d5 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b67:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6a:	8b 40 38             	mov    0x38(%eax),%eax
c0101b6d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b71:	c7 04 24 11 64 10 c0 	movl   $0xc0106411,(%esp)
c0101b78:	e8 bf e7 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b80:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b84:	0f b7 c0             	movzwl %ax,%eax
c0101b87:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b8b:	c7 04 24 20 64 10 c0 	movl   $0xc0106420,(%esp)
c0101b92:	e8 a5 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b97:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b9a:	8b 40 40             	mov    0x40(%eax),%eax
c0101b9d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ba1:	c7 04 24 33 64 10 c0 	movl   $0xc0106433,(%esp)
c0101ba8:	e8 8f e7 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101bb4:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101bbb:	eb 3e                	jmp    c0101bfb <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101bbd:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc0:	8b 50 40             	mov    0x40(%eax),%edx
c0101bc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101bc6:	21 d0                	and    %edx,%eax
c0101bc8:	85 c0                	test   %eax,%eax
c0101bca:	74 28                	je     c0101bf4 <print_trapframe+0x157>
c0101bcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bcf:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101bd6:	85 c0                	test   %eax,%eax
c0101bd8:	74 1a                	je     c0101bf4 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101bda:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bdd:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101be4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be8:	c7 04 24 42 64 10 c0 	movl   $0xc0106442,(%esp)
c0101bef:	e8 48 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bf4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101bf8:	d1 65 f0             	shll   -0x10(%ebp)
c0101bfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bfe:	83 f8 17             	cmp    $0x17,%eax
c0101c01:	76 ba                	jbe    c0101bbd <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c03:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c06:	8b 40 40             	mov    0x40(%eax),%eax
c0101c09:	25 00 30 00 00       	and    $0x3000,%eax
c0101c0e:	c1 e8 0c             	shr    $0xc,%eax
c0101c11:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c15:	c7 04 24 46 64 10 c0 	movl   $0xc0106446,(%esp)
c0101c1c:	e8 1b e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101c21:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c24:	89 04 24             	mov    %eax,(%esp)
c0101c27:	e8 5b fe ff ff       	call   c0101a87 <trap_in_kernel>
c0101c2c:	85 c0                	test   %eax,%eax
c0101c2e:	75 30                	jne    c0101c60 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c33:	8b 40 44             	mov    0x44(%eax),%eax
c0101c36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c3a:	c7 04 24 4f 64 10 c0 	movl   $0xc010644f,(%esp)
c0101c41:	e8 f6 e6 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c46:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c49:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c4d:	0f b7 c0             	movzwl %ax,%eax
c0101c50:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c54:	c7 04 24 5e 64 10 c0 	movl   $0xc010645e,(%esp)
c0101c5b:	e8 dc e6 ff ff       	call   c010033c <cprintf>
    }
}
c0101c60:	c9                   	leave  
c0101c61:	c3                   	ret    

c0101c62 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c62:	55                   	push   %ebp
c0101c63:	89 e5                	mov    %esp,%ebp
c0101c65:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c68:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c6b:	8b 00                	mov    (%eax),%eax
c0101c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c71:	c7 04 24 71 64 10 c0 	movl   $0xc0106471,(%esp)
c0101c78:	e8 bf e6 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c80:	8b 40 04             	mov    0x4(%eax),%eax
c0101c83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c87:	c7 04 24 80 64 10 c0 	movl   $0xc0106480,(%esp)
c0101c8e:	e8 a9 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c93:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c96:	8b 40 08             	mov    0x8(%eax),%eax
c0101c99:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c9d:	c7 04 24 8f 64 10 c0 	movl   $0xc010648f,(%esp)
c0101ca4:	e8 93 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cac:	8b 40 0c             	mov    0xc(%eax),%eax
c0101caf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb3:	c7 04 24 9e 64 10 c0 	movl   $0xc010649e,(%esp)
c0101cba:	e8 7d e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101cbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cc2:	8b 40 10             	mov    0x10(%eax),%eax
c0101cc5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc9:	c7 04 24 ad 64 10 c0 	movl   $0xc01064ad,(%esp)
c0101cd0:	e8 67 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101cd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd8:	8b 40 14             	mov    0x14(%eax),%eax
c0101cdb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cdf:	c7 04 24 bc 64 10 c0 	movl   $0xc01064bc,(%esp)
c0101ce6:	e8 51 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101ceb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cee:	8b 40 18             	mov    0x18(%eax),%eax
c0101cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cf5:	c7 04 24 cb 64 10 c0 	movl   $0xc01064cb,(%esp)
c0101cfc:	e8 3b e6 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d01:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d04:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d0b:	c7 04 24 da 64 10 c0 	movl   $0xc01064da,(%esp)
c0101d12:	e8 25 e6 ff ff       	call   c010033c <cprintf>
}
c0101d17:	c9                   	leave  
c0101d18:	c3                   	ret    

c0101d19 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d19:	55                   	push   %ebp
c0101d1a:	89 e5                	mov    %esp,%ebp
c0101d1c:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d22:	8b 40 30             	mov    0x30(%eax),%eax
c0101d25:	83 f8 2f             	cmp    $0x2f,%eax
c0101d28:	77 21                	ja     c0101d4b <trap_dispatch+0x32>
c0101d2a:	83 f8 2e             	cmp    $0x2e,%eax
c0101d2d:	0f 83 04 01 00 00    	jae    c0101e37 <trap_dispatch+0x11e>
c0101d33:	83 f8 21             	cmp    $0x21,%eax
c0101d36:	0f 84 81 00 00 00    	je     c0101dbd <trap_dispatch+0xa4>
c0101d3c:	83 f8 24             	cmp    $0x24,%eax
c0101d3f:	74 56                	je     c0101d97 <trap_dispatch+0x7e>
c0101d41:	83 f8 20             	cmp    $0x20,%eax
c0101d44:	74 16                	je     c0101d5c <trap_dispatch+0x43>
c0101d46:	e9 b4 00 00 00       	jmp    c0101dff <trap_dispatch+0xe6>
c0101d4b:	83 e8 78             	sub    $0x78,%eax
c0101d4e:	83 f8 01             	cmp    $0x1,%eax
c0101d51:	0f 87 a8 00 00 00    	ja     c0101dff <trap_dispatch+0xe6>
c0101d57:	e9 87 00 00 00       	jmp    c0101de3 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101d5c:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d61:	83 c0 01             	add    $0x1,%eax
c0101d64:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
        if (ticks % TICK_NUM == 0) {
c0101d69:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101d6f:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d74:	89 c8                	mov    %ecx,%eax
c0101d76:	f7 e2                	mul    %edx
c0101d78:	89 d0                	mov    %edx,%eax
c0101d7a:	c1 e8 05             	shr    $0x5,%eax
c0101d7d:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d80:	29 c1                	sub    %eax,%ecx
c0101d82:	89 c8                	mov    %ecx,%eax
c0101d84:	85 c0                	test   %eax,%eax
c0101d86:	75 0a                	jne    c0101d92 <trap_dispatch+0x79>
            print_ticks();
c0101d88:	e8 c8 fa ff ff       	call   c0101855 <print_ticks>
        }
        break;
c0101d8d:	e9 a6 00 00 00       	jmp    c0101e38 <trap_dispatch+0x11f>
c0101d92:	e9 a1 00 00 00       	jmp    c0101e38 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d97:	e8 7d f8 ff ff       	call   c0101619 <cons_getc>
c0101d9c:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d9f:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101da3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101da7:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101dab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101daf:	c7 04 24 e9 64 10 c0 	movl   $0xc01064e9,(%esp)
c0101db6:	e8 81 e5 ff ff       	call   c010033c <cprintf>
        break;
c0101dbb:	eb 7b                	jmp    c0101e38 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101dbd:	e8 57 f8 ff ff       	call   c0101619 <cons_getc>
c0101dc2:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101dc5:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101dc9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101dcd:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101dd1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101dd5:	c7 04 24 fb 64 10 c0 	movl   $0xc01064fb,(%esp)
c0101ddc:	e8 5b e5 ff ff       	call   c010033c <cprintf>
        break;
c0101de1:	eb 55                	jmp    c0101e38 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101de3:	c7 44 24 08 0a 65 10 	movl   $0xc010650a,0x8(%esp)
c0101dea:	c0 
c0101deb:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c0101df2:	00 
c0101df3:	c7 04 24 2e 63 10 c0 	movl   $0xc010632e,(%esp)
c0101dfa:	e8 ac ee ff ff       	call   c0100cab <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101dff:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e02:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e06:	0f b7 c0             	movzwl %ax,%eax
c0101e09:	83 e0 03             	and    $0x3,%eax
c0101e0c:	85 c0                	test   %eax,%eax
c0101e0e:	75 28                	jne    c0101e38 <trap_dispatch+0x11f>
            print_trapframe(tf);
c0101e10:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e13:	89 04 24             	mov    %eax,(%esp)
c0101e16:	e8 82 fc ff ff       	call   c0101a9d <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101e1b:	c7 44 24 08 1a 65 10 	movl   $0xc010651a,0x8(%esp)
c0101e22:	c0 
c0101e23:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0101e2a:	00 
c0101e2b:	c7 04 24 2e 63 10 c0 	movl   $0xc010632e,(%esp)
c0101e32:	e8 74 ee ff ff       	call   c0100cab <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101e37:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101e38:	c9                   	leave  
c0101e39:	c3                   	ret    

c0101e3a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101e3a:	55                   	push   %ebp
c0101e3b:	89 e5                	mov    %esp,%ebp
c0101e3d:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101e40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e43:	89 04 24             	mov    %eax,(%esp)
c0101e46:	e8 ce fe ff ff       	call   c0101d19 <trap_dispatch>
}
c0101e4b:	c9                   	leave  
c0101e4c:	c3                   	ret    

c0101e4d <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101e4d:	1e                   	push   %ds
    pushl %es
c0101e4e:	06                   	push   %es
    pushl %fs
c0101e4f:	0f a0                	push   %fs
    pushl %gs
c0101e51:	0f a8                	push   %gs
    pushal
c0101e53:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101e54:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e59:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e5b:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101e5d:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101e5e:	e8 d7 ff ff ff       	call   c0101e3a <trap>

    # pop the pushed stack pointer
    popl %esp
c0101e63:	5c                   	pop    %esp

c0101e64 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101e64:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101e65:	0f a9                	pop    %gs
    popl %fs
c0101e67:	0f a1                	pop    %fs
    popl %es
c0101e69:	07                   	pop    %es
    popl %ds
c0101e6a:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e6b:	83 c4 08             	add    $0x8,%esp
    iret
c0101e6e:	cf                   	iret   

c0101e6f <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e6f:	6a 00                	push   $0x0
  pushl $0
c0101e71:	6a 00                	push   $0x0
  jmp __alltraps
c0101e73:	e9 d5 ff ff ff       	jmp    c0101e4d <__alltraps>

c0101e78 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e78:	6a 00                	push   $0x0
  pushl $1
c0101e7a:	6a 01                	push   $0x1
  jmp __alltraps
c0101e7c:	e9 cc ff ff ff       	jmp    c0101e4d <__alltraps>

c0101e81 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e81:	6a 00                	push   $0x0
  pushl $2
c0101e83:	6a 02                	push   $0x2
  jmp __alltraps
c0101e85:	e9 c3 ff ff ff       	jmp    c0101e4d <__alltraps>

c0101e8a <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e8a:	6a 00                	push   $0x0
  pushl $3
c0101e8c:	6a 03                	push   $0x3
  jmp __alltraps
c0101e8e:	e9 ba ff ff ff       	jmp    c0101e4d <__alltraps>

c0101e93 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e93:	6a 00                	push   $0x0
  pushl $4
c0101e95:	6a 04                	push   $0x4
  jmp __alltraps
c0101e97:	e9 b1 ff ff ff       	jmp    c0101e4d <__alltraps>

c0101e9c <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e9c:	6a 00                	push   $0x0
  pushl $5
c0101e9e:	6a 05                	push   $0x5
  jmp __alltraps
c0101ea0:	e9 a8 ff ff ff       	jmp    c0101e4d <__alltraps>

c0101ea5 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101ea5:	6a 00                	push   $0x0
  pushl $6
c0101ea7:	6a 06                	push   $0x6
  jmp __alltraps
c0101ea9:	e9 9f ff ff ff       	jmp    c0101e4d <__alltraps>

c0101eae <vector7>:
.globl vector7
vector7:
  pushl $0
c0101eae:	6a 00                	push   $0x0
  pushl $7
c0101eb0:	6a 07                	push   $0x7
  jmp __alltraps
c0101eb2:	e9 96 ff ff ff       	jmp    c0101e4d <__alltraps>

c0101eb7 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101eb7:	6a 08                	push   $0x8
  jmp __alltraps
c0101eb9:	e9 8f ff ff ff       	jmp    c0101e4d <__alltraps>

c0101ebe <vector9>:
.globl vector9
vector9:
  pushl $9
c0101ebe:	6a 09                	push   $0x9
  jmp __alltraps
c0101ec0:	e9 88 ff ff ff       	jmp    c0101e4d <__alltraps>

c0101ec5 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101ec5:	6a 0a                	push   $0xa
  jmp __alltraps
c0101ec7:	e9 81 ff ff ff       	jmp    c0101e4d <__alltraps>

c0101ecc <vector11>:
.globl vector11
vector11:
  pushl $11
c0101ecc:	6a 0b                	push   $0xb
  jmp __alltraps
c0101ece:	e9 7a ff ff ff       	jmp    c0101e4d <__alltraps>

c0101ed3 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101ed3:	6a 0c                	push   $0xc
  jmp __alltraps
c0101ed5:	e9 73 ff ff ff       	jmp    c0101e4d <__alltraps>

c0101eda <vector13>:
.globl vector13
vector13:
  pushl $13
c0101eda:	6a 0d                	push   $0xd
  jmp __alltraps
c0101edc:	e9 6c ff ff ff       	jmp    c0101e4d <__alltraps>

c0101ee1 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101ee1:	6a 0e                	push   $0xe
  jmp __alltraps
c0101ee3:	e9 65 ff ff ff       	jmp    c0101e4d <__alltraps>

c0101ee8 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101ee8:	6a 00                	push   $0x0
  pushl $15
c0101eea:	6a 0f                	push   $0xf
  jmp __alltraps
c0101eec:	e9 5c ff ff ff       	jmp    c0101e4d <__alltraps>

c0101ef1 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101ef1:	6a 00                	push   $0x0
  pushl $16
c0101ef3:	6a 10                	push   $0x10
  jmp __alltraps
c0101ef5:	e9 53 ff ff ff       	jmp    c0101e4d <__alltraps>

c0101efa <vector17>:
.globl vector17
vector17:
  pushl $17
c0101efa:	6a 11                	push   $0x11
  jmp __alltraps
c0101efc:	e9 4c ff ff ff       	jmp    c0101e4d <__alltraps>

c0101f01 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101f01:	6a 00                	push   $0x0
  pushl $18
c0101f03:	6a 12                	push   $0x12
  jmp __alltraps
c0101f05:	e9 43 ff ff ff       	jmp    c0101e4d <__alltraps>

c0101f0a <vector19>:
.globl vector19
vector19:
  pushl $0
c0101f0a:	6a 00                	push   $0x0
  pushl $19
c0101f0c:	6a 13                	push   $0x13
  jmp __alltraps
c0101f0e:	e9 3a ff ff ff       	jmp    c0101e4d <__alltraps>

c0101f13 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101f13:	6a 00                	push   $0x0
  pushl $20
c0101f15:	6a 14                	push   $0x14
  jmp __alltraps
c0101f17:	e9 31 ff ff ff       	jmp    c0101e4d <__alltraps>

c0101f1c <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f1c:	6a 00                	push   $0x0
  pushl $21
c0101f1e:	6a 15                	push   $0x15
  jmp __alltraps
c0101f20:	e9 28 ff ff ff       	jmp    c0101e4d <__alltraps>

c0101f25 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101f25:	6a 00                	push   $0x0
  pushl $22
c0101f27:	6a 16                	push   $0x16
  jmp __alltraps
c0101f29:	e9 1f ff ff ff       	jmp    c0101e4d <__alltraps>

c0101f2e <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f2e:	6a 00                	push   $0x0
  pushl $23
c0101f30:	6a 17                	push   $0x17
  jmp __alltraps
c0101f32:	e9 16 ff ff ff       	jmp    c0101e4d <__alltraps>

c0101f37 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101f37:	6a 00                	push   $0x0
  pushl $24
c0101f39:	6a 18                	push   $0x18
  jmp __alltraps
c0101f3b:	e9 0d ff ff ff       	jmp    c0101e4d <__alltraps>

c0101f40 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f40:	6a 00                	push   $0x0
  pushl $25
c0101f42:	6a 19                	push   $0x19
  jmp __alltraps
c0101f44:	e9 04 ff ff ff       	jmp    c0101e4d <__alltraps>

c0101f49 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f49:	6a 00                	push   $0x0
  pushl $26
c0101f4b:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f4d:	e9 fb fe ff ff       	jmp    c0101e4d <__alltraps>

c0101f52 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101f52:	6a 00                	push   $0x0
  pushl $27
c0101f54:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f56:	e9 f2 fe ff ff       	jmp    c0101e4d <__alltraps>

c0101f5b <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f5b:	6a 00                	push   $0x0
  pushl $28
c0101f5d:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f5f:	e9 e9 fe ff ff       	jmp    c0101e4d <__alltraps>

c0101f64 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f64:	6a 00                	push   $0x0
  pushl $29
c0101f66:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f68:	e9 e0 fe ff ff       	jmp    c0101e4d <__alltraps>

c0101f6d <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f6d:	6a 00                	push   $0x0
  pushl $30
c0101f6f:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f71:	e9 d7 fe ff ff       	jmp    c0101e4d <__alltraps>

c0101f76 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f76:	6a 00                	push   $0x0
  pushl $31
c0101f78:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f7a:	e9 ce fe ff ff       	jmp    c0101e4d <__alltraps>

c0101f7f <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f7f:	6a 00                	push   $0x0
  pushl $32
c0101f81:	6a 20                	push   $0x20
  jmp __alltraps
c0101f83:	e9 c5 fe ff ff       	jmp    c0101e4d <__alltraps>

c0101f88 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f88:	6a 00                	push   $0x0
  pushl $33
c0101f8a:	6a 21                	push   $0x21
  jmp __alltraps
c0101f8c:	e9 bc fe ff ff       	jmp    c0101e4d <__alltraps>

c0101f91 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f91:	6a 00                	push   $0x0
  pushl $34
c0101f93:	6a 22                	push   $0x22
  jmp __alltraps
c0101f95:	e9 b3 fe ff ff       	jmp    c0101e4d <__alltraps>

c0101f9a <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f9a:	6a 00                	push   $0x0
  pushl $35
c0101f9c:	6a 23                	push   $0x23
  jmp __alltraps
c0101f9e:	e9 aa fe ff ff       	jmp    c0101e4d <__alltraps>

c0101fa3 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101fa3:	6a 00                	push   $0x0
  pushl $36
c0101fa5:	6a 24                	push   $0x24
  jmp __alltraps
c0101fa7:	e9 a1 fe ff ff       	jmp    c0101e4d <__alltraps>

c0101fac <vector37>:
.globl vector37
vector37:
  pushl $0
c0101fac:	6a 00                	push   $0x0
  pushl $37
c0101fae:	6a 25                	push   $0x25
  jmp __alltraps
c0101fb0:	e9 98 fe ff ff       	jmp    c0101e4d <__alltraps>

c0101fb5 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101fb5:	6a 00                	push   $0x0
  pushl $38
c0101fb7:	6a 26                	push   $0x26
  jmp __alltraps
c0101fb9:	e9 8f fe ff ff       	jmp    c0101e4d <__alltraps>

c0101fbe <vector39>:
.globl vector39
vector39:
  pushl $0
c0101fbe:	6a 00                	push   $0x0
  pushl $39
c0101fc0:	6a 27                	push   $0x27
  jmp __alltraps
c0101fc2:	e9 86 fe ff ff       	jmp    c0101e4d <__alltraps>

c0101fc7 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101fc7:	6a 00                	push   $0x0
  pushl $40
c0101fc9:	6a 28                	push   $0x28
  jmp __alltraps
c0101fcb:	e9 7d fe ff ff       	jmp    c0101e4d <__alltraps>

c0101fd0 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101fd0:	6a 00                	push   $0x0
  pushl $41
c0101fd2:	6a 29                	push   $0x29
  jmp __alltraps
c0101fd4:	e9 74 fe ff ff       	jmp    c0101e4d <__alltraps>

c0101fd9 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101fd9:	6a 00                	push   $0x0
  pushl $42
c0101fdb:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101fdd:	e9 6b fe ff ff       	jmp    c0101e4d <__alltraps>

c0101fe2 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101fe2:	6a 00                	push   $0x0
  pushl $43
c0101fe4:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101fe6:	e9 62 fe ff ff       	jmp    c0101e4d <__alltraps>

c0101feb <vector44>:
.globl vector44
vector44:
  pushl $0
c0101feb:	6a 00                	push   $0x0
  pushl $44
c0101fed:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101fef:	e9 59 fe ff ff       	jmp    c0101e4d <__alltraps>

c0101ff4 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101ff4:	6a 00                	push   $0x0
  pushl $45
c0101ff6:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101ff8:	e9 50 fe ff ff       	jmp    c0101e4d <__alltraps>

c0101ffd <vector46>:
.globl vector46
vector46:
  pushl $0
c0101ffd:	6a 00                	push   $0x0
  pushl $46
c0101fff:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102001:	e9 47 fe ff ff       	jmp    c0101e4d <__alltraps>

c0102006 <vector47>:
.globl vector47
vector47:
  pushl $0
c0102006:	6a 00                	push   $0x0
  pushl $47
c0102008:	6a 2f                	push   $0x2f
  jmp __alltraps
c010200a:	e9 3e fe ff ff       	jmp    c0101e4d <__alltraps>

c010200f <vector48>:
.globl vector48
vector48:
  pushl $0
c010200f:	6a 00                	push   $0x0
  pushl $48
c0102011:	6a 30                	push   $0x30
  jmp __alltraps
c0102013:	e9 35 fe ff ff       	jmp    c0101e4d <__alltraps>

c0102018 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102018:	6a 00                	push   $0x0
  pushl $49
c010201a:	6a 31                	push   $0x31
  jmp __alltraps
c010201c:	e9 2c fe ff ff       	jmp    c0101e4d <__alltraps>

c0102021 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102021:	6a 00                	push   $0x0
  pushl $50
c0102023:	6a 32                	push   $0x32
  jmp __alltraps
c0102025:	e9 23 fe ff ff       	jmp    c0101e4d <__alltraps>

c010202a <vector51>:
.globl vector51
vector51:
  pushl $0
c010202a:	6a 00                	push   $0x0
  pushl $51
c010202c:	6a 33                	push   $0x33
  jmp __alltraps
c010202e:	e9 1a fe ff ff       	jmp    c0101e4d <__alltraps>

c0102033 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102033:	6a 00                	push   $0x0
  pushl $52
c0102035:	6a 34                	push   $0x34
  jmp __alltraps
c0102037:	e9 11 fe ff ff       	jmp    c0101e4d <__alltraps>

c010203c <vector53>:
.globl vector53
vector53:
  pushl $0
c010203c:	6a 00                	push   $0x0
  pushl $53
c010203e:	6a 35                	push   $0x35
  jmp __alltraps
c0102040:	e9 08 fe ff ff       	jmp    c0101e4d <__alltraps>

c0102045 <vector54>:
.globl vector54
vector54:
  pushl $0
c0102045:	6a 00                	push   $0x0
  pushl $54
c0102047:	6a 36                	push   $0x36
  jmp __alltraps
c0102049:	e9 ff fd ff ff       	jmp    c0101e4d <__alltraps>

c010204e <vector55>:
.globl vector55
vector55:
  pushl $0
c010204e:	6a 00                	push   $0x0
  pushl $55
c0102050:	6a 37                	push   $0x37
  jmp __alltraps
c0102052:	e9 f6 fd ff ff       	jmp    c0101e4d <__alltraps>

c0102057 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102057:	6a 00                	push   $0x0
  pushl $56
c0102059:	6a 38                	push   $0x38
  jmp __alltraps
c010205b:	e9 ed fd ff ff       	jmp    c0101e4d <__alltraps>

c0102060 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102060:	6a 00                	push   $0x0
  pushl $57
c0102062:	6a 39                	push   $0x39
  jmp __alltraps
c0102064:	e9 e4 fd ff ff       	jmp    c0101e4d <__alltraps>

c0102069 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102069:	6a 00                	push   $0x0
  pushl $58
c010206b:	6a 3a                	push   $0x3a
  jmp __alltraps
c010206d:	e9 db fd ff ff       	jmp    c0101e4d <__alltraps>

c0102072 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102072:	6a 00                	push   $0x0
  pushl $59
c0102074:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102076:	e9 d2 fd ff ff       	jmp    c0101e4d <__alltraps>

c010207b <vector60>:
.globl vector60
vector60:
  pushl $0
c010207b:	6a 00                	push   $0x0
  pushl $60
c010207d:	6a 3c                	push   $0x3c
  jmp __alltraps
c010207f:	e9 c9 fd ff ff       	jmp    c0101e4d <__alltraps>

c0102084 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102084:	6a 00                	push   $0x0
  pushl $61
c0102086:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102088:	e9 c0 fd ff ff       	jmp    c0101e4d <__alltraps>

c010208d <vector62>:
.globl vector62
vector62:
  pushl $0
c010208d:	6a 00                	push   $0x0
  pushl $62
c010208f:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102091:	e9 b7 fd ff ff       	jmp    c0101e4d <__alltraps>

c0102096 <vector63>:
.globl vector63
vector63:
  pushl $0
c0102096:	6a 00                	push   $0x0
  pushl $63
c0102098:	6a 3f                	push   $0x3f
  jmp __alltraps
c010209a:	e9 ae fd ff ff       	jmp    c0101e4d <__alltraps>

c010209f <vector64>:
.globl vector64
vector64:
  pushl $0
c010209f:	6a 00                	push   $0x0
  pushl $64
c01020a1:	6a 40                	push   $0x40
  jmp __alltraps
c01020a3:	e9 a5 fd ff ff       	jmp    c0101e4d <__alltraps>

c01020a8 <vector65>:
.globl vector65
vector65:
  pushl $0
c01020a8:	6a 00                	push   $0x0
  pushl $65
c01020aa:	6a 41                	push   $0x41
  jmp __alltraps
c01020ac:	e9 9c fd ff ff       	jmp    c0101e4d <__alltraps>

c01020b1 <vector66>:
.globl vector66
vector66:
  pushl $0
c01020b1:	6a 00                	push   $0x0
  pushl $66
c01020b3:	6a 42                	push   $0x42
  jmp __alltraps
c01020b5:	e9 93 fd ff ff       	jmp    c0101e4d <__alltraps>

c01020ba <vector67>:
.globl vector67
vector67:
  pushl $0
c01020ba:	6a 00                	push   $0x0
  pushl $67
c01020bc:	6a 43                	push   $0x43
  jmp __alltraps
c01020be:	e9 8a fd ff ff       	jmp    c0101e4d <__alltraps>

c01020c3 <vector68>:
.globl vector68
vector68:
  pushl $0
c01020c3:	6a 00                	push   $0x0
  pushl $68
c01020c5:	6a 44                	push   $0x44
  jmp __alltraps
c01020c7:	e9 81 fd ff ff       	jmp    c0101e4d <__alltraps>

c01020cc <vector69>:
.globl vector69
vector69:
  pushl $0
c01020cc:	6a 00                	push   $0x0
  pushl $69
c01020ce:	6a 45                	push   $0x45
  jmp __alltraps
c01020d0:	e9 78 fd ff ff       	jmp    c0101e4d <__alltraps>

c01020d5 <vector70>:
.globl vector70
vector70:
  pushl $0
c01020d5:	6a 00                	push   $0x0
  pushl $70
c01020d7:	6a 46                	push   $0x46
  jmp __alltraps
c01020d9:	e9 6f fd ff ff       	jmp    c0101e4d <__alltraps>

c01020de <vector71>:
.globl vector71
vector71:
  pushl $0
c01020de:	6a 00                	push   $0x0
  pushl $71
c01020e0:	6a 47                	push   $0x47
  jmp __alltraps
c01020e2:	e9 66 fd ff ff       	jmp    c0101e4d <__alltraps>

c01020e7 <vector72>:
.globl vector72
vector72:
  pushl $0
c01020e7:	6a 00                	push   $0x0
  pushl $72
c01020e9:	6a 48                	push   $0x48
  jmp __alltraps
c01020eb:	e9 5d fd ff ff       	jmp    c0101e4d <__alltraps>

c01020f0 <vector73>:
.globl vector73
vector73:
  pushl $0
c01020f0:	6a 00                	push   $0x0
  pushl $73
c01020f2:	6a 49                	push   $0x49
  jmp __alltraps
c01020f4:	e9 54 fd ff ff       	jmp    c0101e4d <__alltraps>

c01020f9 <vector74>:
.globl vector74
vector74:
  pushl $0
c01020f9:	6a 00                	push   $0x0
  pushl $74
c01020fb:	6a 4a                	push   $0x4a
  jmp __alltraps
c01020fd:	e9 4b fd ff ff       	jmp    c0101e4d <__alltraps>

c0102102 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102102:	6a 00                	push   $0x0
  pushl $75
c0102104:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102106:	e9 42 fd ff ff       	jmp    c0101e4d <__alltraps>

c010210b <vector76>:
.globl vector76
vector76:
  pushl $0
c010210b:	6a 00                	push   $0x0
  pushl $76
c010210d:	6a 4c                	push   $0x4c
  jmp __alltraps
c010210f:	e9 39 fd ff ff       	jmp    c0101e4d <__alltraps>

c0102114 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102114:	6a 00                	push   $0x0
  pushl $77
c0102116:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102118:	e9 30 fd ff ff       	jmp    c0101e4d <__alltraps>

c010211d <vector78>:
.globl vector78
vector78:
  pushl $0
c010211d:	6a 00                	push   $0x0
  pushl $78
c010211f:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102121:	e9 27 fd ff ff       	jmp    c0101e4d <__alltraps>

c0102126 <vector79>:
.globl vector79
vector79:
  pushl $0
c0102126:	6a 00                	push   $0x0
  pushl $79
c0102128:	6a 4f                	push   $0x4f
  jmp __alltraps
c010212a:	e9 1e fd ff ff       	jmp    c0101e4d <__alltraps>

c010212f <vector80>:
.globl vector80
vector80:
  pushl $0
c010212f:	6a 00                	push   $0x0
  pushl $80
c0102131:	6a 50                	push   $0x50
  jmp __alltraps
c0102133:	e9 15 fd ff ff       	jmp    c0101e4d <__alltraps>

c0102138 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102138:	6a 00                	push   $0x0
  pushl $81
c010213a:	6a 51                	push   $0x51
  jmp __alltraps
c010213c:	e9 0c fd ff ff       	jmp    c0101e4d <__alltraps>

c0102141 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102141:	6a 00                	push   $0x0
  pushl $82
c0102143:	6a 52                	push   $0x52
  jmp __alltraps
c0102145:	e9 03 fd ff ff       	jmp    c0101e4d <__alltraps>

c010214a <vector83>:
.globl vector83
vector83:
  pushl $0
c010214a:	6a 00                	push   $0x0
  pushl $83
c010214c:	6a 53                	push   $0x53
  jmp __alltraps
c010214e:	e9 fa fc ff ff       	jmp    c0101e4d <__alltraps>

c0102153 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102153:	6a 00                	push   $0x0
  pushl $84
c0102155:	6a 54                	push   $0x54
  jmp __alltraps
c0102157:	e9 f1 fc ff ff       	jmp    c0101e4d <__alltraps>

c010215c <vector85>:
.globl vector85
vector85:
  pushl $0
c010215c:	6a 00                	push   $0x0
  pushl $85
c010215e:	6a 55                	push   $0x55
  jmp __alltraps
c0102160:	e9 e8 fc ff ff       	jmp    c0101e4d <__alltraps>

c0102165 <vector86>:
.globl vector86
vector86:
  pushl $0
c0102165:	6a 00                	push   $0x0
  pushl $86
c0102167:	6a 56                	push   $0x56
  jmp __alltraps
c0102169:	e9 df fc ff ff       	jmp    c0101e4d <__alltraps>

c010216e <vector87>:
.globl vector87
vector87:
  pushl $0
c010216e:	6a 00                	push   $0x0
  pushl $87
c0102170:	6a 57                	push   $0x57
  jmp __alltraps
c0102172:	e9 d6 fc ff ff       	jmp    c0101e4d <__alltraps>

c0102177 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102177:	6a 00                	push   $0x0
  pushl $88
c0102179:	6a 58                	push   $0x58
  jmp __alltraps
c010217b:	e9 cd fc ff ff       	jmp    c0101e4d <__alltraps>

c0102180 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102180:	6a 00                	push   $0x0
  pushl $89
c0102182:	6a 59                	push   $0x59
  jmp __alltraps
c0102184:	e9 c4 fc ff ff       	jmp    c0101e4d <__alltraps>

c0102189 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102189:	6a 00                	push   $0x0
  pushl $90
c010218b:	6a 5a                	push   $0x5a
  jmp __alltraps
c010218d:	e9 bb fc ff ff       	jmp    c0101e4d <__alltraps>

c0102192 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102192:	6a 00                	push   $0x0
  pushl $91
c0102194:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102196:	e9 b2 fc ff ff       	jmp    c0101e4d <__alltraps>

c010219b <vector92>:
.globl vector92
vector92:
  pushl $0
c010219b:	6a 00                	push   $0x0
  pushl $92
c010219d:	6a 5c                	push   $0x5c
  jmp __alltraps
c010219f:	e9 a9 fc ff ff       	jmp    c0101e4d <__alltraps>

c01021a4 <vector93>:
.globl vector93
vector93:
  pushl $0
c01021a4:	6a 00                	push   $0x0
  pushl $93
c01021a6:	6a 5d                	push   $0x5d
  jmp __alltraps
c01021a8:	e9 a0 fc ff ff       	jmp    c0101e4d <__alltraps>

c01021ad <vector94>:
.globl vector94
vector94:
  pushl $0
c01021ad:	6a 00                	push   $0x0
  pushl $94
c01021af:	6a 5e                	push   $0x5e
  jmp __alltraps
c01021b1:	e9 97 fc ff ff       	jmp    c0101e4d <__alltraps>

c01021b6 <vector95>:
.globl vector95
vector95:
  pushl $0
c01021b6:	6a 00                	push   $0x0
  pushl $95
c01021b8:	6a 5f                	push   $0x5f
  jmp __alltraps
c01021ba:	e9 8e fc ff ff       	jmp    c0101e4d <__alltraps>

c01021bf <vector96>:
.globl vector96
vector96:
  pushl $0
c01021bf:	6a 00                	push   $0x0
  pushl $96
c01021c1:	6a 60                	push   $0x60
  jmp __alltraps
c01021c3:	e9 85 fc ff ff       	jmp    c0101e4d <__alltraps>

c01021c8 <vector97>:
.globl vector97
vector97:
  pushl $0
c01021c8:	6a 00                	push   $0x0
  pushl $97
c01021ca:	6a 61                	push   $0x61
  jmp __alltraps
c01021cc:	e9 7c fc ff ff       	jmp    c0101e4d <__alltraps>

c01021d1 <vector98>:
.globl vector98
vector98:
  pushl $0
c01021d1:	6a 00                	push   $0x0
  pushl $98
c01021d3:	6a 62                	push   $0x62
  jmp __alltraps
c01021d5:	e9 73 fc ff ff       	jmp    c0101e4d <__alltraps>

c01021da <vector99>:
.globl vector99
vector99:
  pushl $0
c01021da:	6a 00                	push   $0x0
  pushl $99
c01021dc:	6a 63                	push   $0x63
  jmp __alltraps
c01021de:	e9 6a fc ff ff       	jmp    c0101e4d <__alltraps>

c01021e3 <vector100>:
.globl vector100
vector100:
  pushl $0
c01021e3:	6a 00                	push   $0x0
  pushl $100
c01021e5:	6a 64                	push   $0x64
  jmp __alltraps
c01021e7:	e9 61 fc ff ff       	jmp    c0101e4d <__alltraps>

c01021ec <vector101>:
.globl vector101
vector101:
  pushl $0
c01021ec:	6a 00                	push   $0x0
  pushl $101
c01021ee:	6a 65                	push   $0x65
  jmp __alltraps
c01021f0:	e9 58 fc ff ff       	jmp    c0101e4d <__alltraps>

c01021f5 <vector102>:
.globl vector102
vector102:
  pushl $0
c01021f5:	6a 00                	push   $0x0
  pushl $102
c01021f7:	6a 66                	push   $0x66
  jmp __alltraps
c01021f9:	e9 4f fc ff ff       	jmp    c0101e4d <__alltraps>

c01021fe <vector103>:
.globl vector103
vector103:
  pushl $0
c01021fe:	6a 00                	push   $0x0
  pushl $103
c0102200:	6a 67                	push   $0x67
  jmp __alltraps
c0102202:	e9 46 fc ff ff       	jmp    c0101e4d <__alltraps>

c0102207 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102207:	6a 00                	push   $0x0
  pushl $104
c0102209:	6a 68                	push   $0x68
  jmp __alltraps
c010220b:	e9 3d fc ff ff       	jmp    c0101e4d <__alltraps>

c0102210 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102210:	6a 00                	push   $0x0
  pushl $105
c0102212:	6a 69                	push   $0x69
  jmp __alltraps
c0102214:	e9 34 fc ff ff       	jmp    c0101e4d <__alltraps>

c0102219 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102219:	6a 00                	push   $0x0
  pushl $106
c010221b:	6a 6a                	push   $0x6a
  jmp __alltraps
c010221d:	e9 2b fc ff ff       	jmp    c0101e4d <__alltraps>

c0102222 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102222:	6a 00                	push   $0x0
  pushl $107
c0102224:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102226:	e9 22 fc ff ff       	jmp    c0101e4d <__alltraps>

c010222b <vector108>:
.globl vector108
vector108:
  pushl $0
c010222b:	6a 00                	push   $0x0
  pushl $108
c010222d:	6a 6c                	push   $0x6c
  jmp __alltraps
c010222f:	e9 19 fc ff ff       	jmp    c0101e4d <__alltraps>

c0102234 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102234:	6a 00                	push   $0x0
  pushl $109
c0102236:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102238:	e9 10 fc ff ff       	jmp    c0101e4d <__alltraps>

c010223d <vector110>:
.globl vector110
vector110:
  pushl $0
c010223d:	6a 00                	push   $0x0
  pushl $110
c010223f:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102241:	e9 07 fc ff ff       	jmp    c0101e4d <__alltraps>

c0102246 <vector111>:
.globl vector111
vector111:
  pushl $0
c0102246:	6a 00                	push   $0x0
  pushl $111
c0102248:	6a 6f                	push   $0x6f
  jmp __alltraps
c010224a:	e9 fe fb ff ff       	jmp    c0101e4d <__alltraps>

c010224f <vector112>:
.globl vector112
vector112:
  pushl $0
c010224f:	6a 00                	push   $0x0
  pushl $112
c0102251:	6a 70                	push   $0x70
  jmp __alltraps
c0102253:	e9 f5 fb ff ff       	jmp    c0101e4d <__alltraps>

c0102258 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102258:	6a 00                	push   $0x0
  pushl $113
c010225a:	6a 71                	push   $0x71
  jmp __alltraps
c010225c:	e9 ec fb ff ff       	jmp    c0101e4d <__alltraps>

c0102261 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102261:	6a 00                	push   $0x0
  pushl $114
c0102263:	6a 72                	push   $0x72
  jmp __alltraps
c0102265:	e9 e3 fb ff ff       	jmp    c0101e4d <__alltraps>

c010226a <vector115>:
.globl vector115
vector115:
  pushl $0
c010226a:	6a 00                	push   $0x0
  pushl $115
c010226c:	6a 73                	push   $0x73
  jmp __alltraps
c010226e:	e9 da fb ff ff       	jmp    c0101e4d <__alltraps>

c0102273 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102273:	6a 00                	push   $0x0
  pushl $116
c0102275:	6a 74                	push   $0x74
  jmp __alltraps
c0102277:	e9 d1 fb ff ff       	jmp    c0101e4d <__alltraps>

c010227c <vector117>:
.globl vector117
vector117:
  pushl $0
c010227c:	6a 00                	push   $0x0
  pushl $117
c010227e:	6a 75                	push   $0x75
  jmp __alltraps
c0102280:	e9 c8 fb ff ff       	jmp    c0101e4d <__alltraps>

c0102285 <vector118>:
.globl vector118
vector118:
  pushl $0
c0102285:	6a 00                	push   $0x0
  pushl $118
c0102287:	6a 76                	push   $0x76
  jmp __alltraps
c0102289:	e9 bf fb ff ff       	jmp    c0101e4d <__alltraps>

c010228e <vector119>:
.globl vector119
vector119:
  pushl $0
c010228e:	6a 00                	push   $0x0
  pushl $119
c0102290:	6a 77                	push   $0x77
  jmp __alltraps
c0102292:	e9 b6 fb ff ff       	jmp    c0101e4d <__alltraps>

c0102297 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102297:	6a 00                	push   $0x0
  pushl $120
c0102299:	6a 78                	push   $0x78
  jmp __alltraps
c010229b:	e9 ad fb ff ff       	jmp    c0101e4d <__alltraps>

c01022a0 <vector121>:
.globl vector121
vector121:
  pushl $0
c01022a0:	6a 00                	push   $0x0
  pushl $121
c01022a2:	6a 79                	push   $0x79
  jmp __alltraps
c01022a4:	e9 a4 fb ff ff       	jmp    c0101e4d <__alltraps>

c01022a9 <vector122>:
.globl vector122
vector122:
  pushl $0
c01022a9:	6a 00                	push   $0x0
  pushl $122
c01022ab:	6a 7a                	push   $0x7a
  jmp __alltraps
c01022ad:	e9 9b fb ff ff       	jmp    c0101e4d <__alltraps>

c01022b2 <vector123>:
.globl vector123
vector123:
  pushl $0
c01022b2:	6a 00                	push   $0x0
  pushl $123
c01022b4:	6a 7b                	push   $0x7b
  jmp __alltraps
c01022b6:	e9 92 fb ff ff       	jmp    c0101e4d <__alltraps>

c01022bb <vector124>:
.globl vector124
vector124:
  pushl $0
c01022bb:	6a 00                	push   $0x0
  pushl $124
c01022bd:	6a 7c                	push   $0x7c
  jmp __alltraps
c01022bf:	e9 89 fb ff ff       	jmp    c0101e4d <__alltraps>

c01022c4 <vector125>:
.globl vector125
vector125:
  pushl $0
c01022c4:	6a 00                	push   $0x0
  pushl $125
c01022c6:	6a 7d                	push   $0x7d
  jmp __alltraps
c01022c8:	e9 80 fb ff ff       	jmp    c0101e4d <__alltraps>

c01022cd <vector126>:
.globl vector126
vector126:
  pushl $0
c01022cd:	6a 00                	push   $0x0
  pushl $126
c01022cf:	6a 7e                	push   $0x7e
  jmp __alltraps
c01022d1:	e9 77 fb ff ff       	jmp    c0101e4d <__alltraps>

c01022d6 <vector127>:
.globl vector127
vector127:
  pushl $0
c01022d6:	6a 00                	push   $0x0
  pushl $127
c01022d8:	6a 7f                	push   $0x7f
  jmp __alltraps
c01022da:	e9 6e fb ff ff       	jmp    c0101e4d <__alltraps>

c01022df <vector128>:
.globl vector128
vector128:
  pushl $0
c01022df:	6a 00                	push   $0x0
  pushl $128
c01022e1:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01022e6:	e9 62 fb ff ff       	jmp    c0101e4d <__alltraps>

c01022eb <vector129>:
.globl vector129
vector129:
  pushl $0
c01022eb:	6a 00                	push   $0x0
  pushl $129
c01022ed:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01022f2:	e9 56 fb ff ff       	jmp    c0101e4d <__alltraps>

c01022f7 <vector130>:
.globl vector130
vector130:
  pushl $0
c01022f7:	6a 00                	push   $0x0
  pushl $130
c01022f9:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01022fe:	e9 4a fb ff ff       	jmp    c0101e4d <__alltraps>

c0102303 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102303:	6a 00                	push   $0x0
  pushl $131
c0102305:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010230a:	e9 3e fb ff ff       	jmp    c0101e4d <__alltraps>

c010230f <vector132>:
.globl vector132
vector132:
  pushl $0
c010230f:	6a 00                	push   $0x0
  pushl $132
c0102311:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102316:	e9 32 fb ff ff       	jmp    c0101e4d <__alltraps>

c010231b <vector133>:
.globl vector133
vector133:
  pushl $0
c010231b:	6a 00                	push   $0x0
  pushl $133
c010231d:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102322:	e9 26 fb ff ff       	jmp    c0101e4d <__alltraps>

c0102327 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102327:	6a 00                	push   $0x0
  pushl $134
c0102329:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010232e:	e9 1a fb ff ff       	jmp    c0101e4d <__alltraps>

c0102333 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102333:	6a 00                	push   $0x0
  pushl $135
c0102335:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010233a:	e9 0e fb ff ff       	jmp    c0101e4d <__alltraps>

c010233f <vector136>:
.globl vector136
vector136:
  pushl $0
c010233f:	6a 00                	push   $0x0
  pushl $136
c0102341:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102346:	e9 02 fb ff ff       	jmp    c0101e4d <__alltraps>

c010234b <vector137>:
.globl vector137
vector137:
  pushl $0
c010234b:	6a 00                	push   $0x0
  pushl $137
c010234d:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102352:	e9 f6 fa ff ff       	jmp    c0101e4d <__alltraps>

c0102357 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102357:	6a 00                	push   $0x0
  pushl $138
c0102359:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010235e:	e9 ea fa ff ff       	jmp    c0101e4d <__alltraps>

c0102363 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102363:	6a 00                	push   $0x0
  pushl $139
c0102365:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c010236a:	e9 de fa ff ff       	jmp    c0101e4d <__alltraps>

c010236f <vector140>:
.globl vector140
vector140:
  pushl $0
c010236f:	6a 00                	push   $0x0
  pushl $140
c0102371:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102376:	e9 d2 fa ff ff       	jmp    c0101e4d <__alltraps>

c010237b <vector141>:
.globl vector141
vector141:
  pushl $0
c010237b:	6a 00                	push   $0x0
  pushl $141
c010237d:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102382:	e9 c6 fa ff ff       	jmp    c0101e4d <__alltraps>

c0102387 <vector142>:
.globl vector142
vector142:
  pushl $0
c0102387:	6a 00                	push   $0x0
  pushl $142
c0102389:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c010238e:	e9 ba fa ff ff       	jmp    c0101e4d <__alltraps>

c0102393 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102393:	6a 00                	push   $0x0
  pushl $143
c0102395:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c010239a:	e9 ae fa ff ff       	jmp    c0101e4d <__alltraps>

c010239f <vector144>:
.globl vector144
vector144:
  pushl $0
c010239f:	6a 00                	push   $0x0
  pushl $144
c01023a1:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01023a6:	e9 a2 fa ff ff       	jmp    c0101e4d <__alltraps>

c01023ab <vector145>:
.globl vector145
vector145:
  pushl $0
c01023ab:	6a 00                	push   $0x0
  pushl $145
c01023ad:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01023b2:	e9 96 fa ff ff       	jmp    c0101e4d <__alltraps>

c01023b7 <vector146>:
.globl vector146
vector146:
  pushl $0
c01023b7:	6a 00                	push   $0x0
  pushl $146
c01023b9:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01023be:	e9 8a fa ff ff       	jmp    c0101e4d <__alltraps>

c01023c3 <vector147>:
.globl vector147
vector147:
  pushl $0
c01023c3:	6a 00                	push   $0x0
  pushl $147
c01023c5:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01023ca:	e9 7e fa ff ff       	jmp    c0101e4d <__alltraps>

c01023cf <vector148>:
.globl vector148
vector148:
  pushl $0
c01023cf:	6a 00                	push   $0x0
  pushl $148
c01023d1:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01023d6:	e9 72 fa ff ff       	jmp    c0101e4d <__alltraps>

c01023db <vector149>:
.globl vector149
vector149:
  pushl $0
c01023db:	6a 00                	push   $0x0
  pushl $149
c01023dd:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01023e2:	e9 66 fa ff ff       	jmp    c0101e4d <__alltraps>

c01023e7 <vector150>:
.globl vector150
vector150:
  pushl $0
c01023e7:	6a 00                	push   $0x0
  pushl $150
c01023e9:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01023ee:	e9 5a fa ff ff       	jmp    c0101e4d <__alltraps>

c01023f3 <vector151>:
.globl vector151
vector151:
  pushl $0
c01023f3:	6a 00                	push   $0x0
  pushl $151
c01023f5:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01023fa:	e9 4e fa ff ff       	jmp    c0101e4d <__alltraps>

c01023ff <vector152>:
.globl vector152
vector152:
  pushl $0
c01023ff:	6a 00                	push   $0x0
  pushl $152
c0102401:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102406:	e9 42 fa ff ff       	jmp    c0101e4d <__alltraps>

c010240b <vector153>:
.globl vector153
vector153:
  pushl $0
c010240b:	6a 00                	push   $0x0
  pushl $153
c010240d:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102412:	e9 36 fa ff ff       	jmp    c0101e4d <__alltraps>

c0102417 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102417:	6a 00                	push   $0x0
  pushl $154
c0102419:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010241e:	e9 2a fa ff ff       	jmp    c0101e4d <__alltraps>

c0102423 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102423:	6a 00                	push   $0x0
  pushl $155
c0102425:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010242a:	e9 1e fa ff ff       	jmp    c0101e4d <__alltraps>

c010242f <vector156>:
.globl vector156
vector156:
  pushl $0
c010242f:	6a 00                	push   $0x0
  pushl $156
c0102431:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102436:	e9 12 fa ff ff       	jmp    c0101e4d <__alltraps>

c010243b <vector157>:
.globl vector157
vector157:
  pushl $0
c010243b:	6a 00                	push   $0x0
  pushl $157
c010243d:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102442:	e9 06 fa ff ff       	jmp    c0101e4d <__alltraps>

c0102447 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102447:	6a 00                	push   $0x0
  pushl $158
c0102449:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010244e:	e9 fa f9 ff ff       	jmp    c0101e4d <__alltraps>

c0102453 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102453:	6a 00                	push   $0x0
  pushl $159
c0102455:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010245a:	e9 ee f9 ff ff       	jmp    c0101e4d <__alltraps>

c010245f <vector160>:
.globl vector160
vector160:
  pushl $0
c010245f:	6a 00                	push   $0x0
  pushl $160
c0102461:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102466:	e9 e2 f9 ff ff       	jmp    c0101e4d <__alltraps>

c010246b <vector161>:
.globl vector161
vector161:
  pushl $0
c010246b:	6a 00                	push   $0x0
  pushl $161
c010246d:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102472:	e9 d6 f9 ff ff       	jmp    c0101e4d <__alltraps>

c0102477 <vector162>:
.globl vector162
vector162:
  pushl $0
c0102477:	6a 00                	push   $0x0
  pushl $162
c0102479:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c010247e:	e9 ca f9 ff ff       	jmp    c0101e4d <__alltraps>

c0102483 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102483:	6a 00                	push   $0x0
  pushl $163
c0102485:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c010248a:	e9 be f9 ff ff       	jmp    c0101e4d <__alltraps>

c010248f <vector164>:
.globl vector164
vector164:
  pushl $0
c010248f:	6a 00                	push   $0x0
  pushl $164
c0102491:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102496:	e9 b2 f9 ff ff       	jmp    c0101e4d <__alltraps>

c010249b <vector165>:
.globl vector165
vector165:
  pushl $0
c010249b:	6a 00                	push   $0x0
  pushl $165
c010249d:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01024a2:	e9 a6 f9 ff ff       	jmp    c0101e4d <__alltraps>

c01024a7 <vector166>:
.globl vector166
vector166:
  pushl $0
c01024a7:	6a 00                	push   $0x0
  pushl $166
c01024a9:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01024ae:	e9 9a f9 ff ff       	jmp    c0101e4d <__alltraps>

c01024b3 <vector167>:
.globl vector167
vector167:
  pushl $0
c01024b3:	6a 00                	push   $0x0
  pushl $167
c01024b5:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01024ba:	e9 8e f9 ff ff       	jmp    c0101e4d <__alltraps>

c01024bf <vector168>:
.globl vector168
vector168:
  pushl $0
c01024bf:	6a 00                	push   $0x0
  pushl $168
c01024c1:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01024c6:	e9 82 f9 ff ff       	jmp    c0101e4d <__alltraps>

c01024cb <vector169>:
.globl vector169
vector169:
  pushl $0
c01024cb:	6a 00                	push   $0x0
  pushl $169
c01024cd:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01024d2:	e9 76 f9 ff ff       	jmp    c0101e4d <__alltraps>

c01024d7 <vector170>:
.globl vector170
vector170:
  pushl $0
c01024d7:	6a 00                	push   $0x0
  pushl $170
c01024d9:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01024de:	e9 6a f9 ff ff       	jmp    c0101e4d <__alltraps>

c01024e3 <vector171>:
.globl vector171
vector171:
  pushl $0
c01024e3:	6a 00                	push   $0x0
  pushl $171
c01024e5:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01024ea:	e9 5e f9 ff ff       	jmp    c0101e4d <__alltraps>

c01024ef <vector172>:
.globl vector172
vector172:
  pushl $0
c01024ef:	6a 00                	push   $0x0
  pushl $172
c01024f1:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01024f6:	e9 52 f9 ff ff       	jmp    c0101e4d <__alltraps>

c01024fb <vector173>:
.globl vector173
vector173:
  pushl $0
c01024fb:	6a 00                	push   $0x0
  pushl $173
c01024fd:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102502:	e9 46 f9 ff ff       	jmp    c0101e4d <__alltraps>

c0102507 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102507:	6a 00                	push   $0x0
  pushl $174
c0102509:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010250e:	e9 3a f9 ff ff       	jmp    c0101e4d <__alltraps>

c0102513 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102513:	6a 00                	push   $0x0
  pushl $175
c0102515:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010251a:	e9 2e f9 ff ff       	jmp    c0101e4d <__alltraps>

c010251f <vector176>:
.globl vector176
vector176:
  pushl $0
c010251f:	6a 00                	push   $0x0
  pushl $176
c0102521:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102526:	e9 22 f9 ff ff       	jmp    c0101e4d <__alltraps>

c010252b <vector177>:
.globl vector177
vector177:
  pushl $0
c010252b:	6a 00                	push   $0x0
  pushl $177
c010252d:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102532:	e9 16 f9 ff ff       	jmp    c0101e4d <__alltraps>

c0102537 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102537:	6a 00                	push   $0x0
  pushl $178
c0102539:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010253e:	e9 0a f9 ff ff       	jmp    c0101e4d <__alltraps>

c0102543 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102543:	6a 00                	push   $0x0
  pushl $179
c0102545:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010254a:	e9 fe f8 ff ff       	jmp    c0101e4d <__alltraps>

c010254f <vector180>:
.globl vector180
vector180:
  pushl $0
c010254f:	6a 00                	push   $0x0
  pushl $180
c0102551:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102556:	e9 f2 f8 ff ff       	jmp    c0101e4d <__alltraps>

c010255b <vector181>:
.globl vector181
vector181:
  pushl $0
c010255b:	6a 00                	push   $0x0
  pushl $181
c010255d:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102562:	e9 e6 f8 ff ff       	jmp    c0101e4d <__alltraps>

c0102567 <vector182>:
.globl vector182
vector182:
  pushl $0
c0102567:	6a 00                	push   $0x0
  pushl $182
c0102569:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c010256e:	e9 da f8 ff ff       	jmp    c0101e4d <__alltraps>

c0102573 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102573:	6a 00                	push   $0x0
  pushl $183
c0102575:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c010257a:	e9 ce f8 ff ff       	jmp    c0101e4d <__alltraps>

c010257f <vector184>:
.globl vector184
vector184:
  pushl $0
c010257f:	6a 00                	push   $0x0
  pushl $184
c0102581:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102586:	e9 c2 f8 ff ff       	jmp    c0101e4d <__alltraps>

c010258b <vector185>:
.globl vector185
vector185:
  pushl $0
c010258b:	6a 00                	push   $0x0
  pushl $185
c010258d:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102592:	e9 b6 f8 ff ff       	jmp    c0101e4d <__alltraps>

c0102597 <vector186>:
.globl vector186
vector186:
  pushl $0
c0102597:	6a 00                	push   $0x0
  pushl $186
c0102599:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c010259e:	e9 aa f8 ff ff       	jmp    c0101e4d <__alltraps>

c01025a3 <vector187>:
.globl vector187
vector187:
  pushl $0
c01025a3:	6a 00                	push   $0x0
  pushl $187
c01025a5:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01025aa:	e9 9e f8 ff ff       	jmp    c0101e4d <__alltraps>

c01025af <vector188>:
.globl vector188
vector188:
  pushl $0
c01025af:	6a 00                	push   $0x0
  pushl $188
c01025b1:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01025b6:	e9 92 f8 ff ff       	jmp    c0101e4d <__alltraps>

c01025bb <vector189>:
.globl vector189
vector189:
  pushl $0
c01025bb:	6a 00                	push   $0x0
  pushl $189
c01025bd:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01025c2:	e9 86 f8 ff ff       	jmp    c0101e4d <__alltraps>

c01025c7 <vector190>:
.globl vector190
vector190:
  pushl $0
c01025c7:	6a 00                	push   $0x0
  pushl $190
c01025c9:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01025ce:	e9 7a f8 ff ff       	jmp    c0101e4d <__alltraps>

c01025d3 <vector191>:
.globl vector191
vector191:
  pushl $0
c01025d3:	6a 00                	push   $0x0
  pushl $191
c01025d5:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01025da:	e9 6e f8 ff ff       	jmp    c0101e4d <__alltraps>

c01025df <vector192>:
.globl vector192
vector192:
  pushl $0
c01025df:	6a 00                	push   $0x0
  pushl $192
c01025e1:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01025e6:	e9 62 f8 ff ff       	jmp    c0101e4d <__alltraps>

c01025eb <vector193>:
.globl vector193
vector193:
  pushl $0
c01025eb:	6a 00                	push   $0x0
  pushl $193
c01025ed:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01025f2:	e9 56 f8 ff ff       	jmp    c0101e4d <__alltraps>

c01025f7 <vector194>:
.globl vector194
vector194:
  pushl $0
c01025f7:	6a 00                	push   $0x0
  pushl $194
c01025f9:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01025fe:	e9 4a f8 ff ff       	jmp    c0101e4d <__alltraps>

c0102603 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102603:	6a 00                	push   $0x0
  pushl $195
c0102605:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010260a:	e9 3e f8 ff ff       	jmp    c0101e4d <__alltraps>

c010260f <vector196>:
.globl vector196
vector196:
  pushl $0
c010260f:	6a 00                	push   $0x0
  pushl $196
c0102611:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102616:	e9 32 f8 ff ff       	jmp    c0101e4d <__alltraps>

c010261b <vector197>:
.globl vector197
vector197:
  pushl $0
c010261b:	6a 00                	push   $0x0
  pushl $197
c010261d:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102622:	e9 26 f8 ff ff       	jmp    c0101e4d <__alltraps>

c0102627 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102627:	6a 00                	push   $0x0
  pushl $198
c0102629:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010262e:	e9 1a f8 ff ff       	jmp    c0101e4d <__alltraps>

c0102633 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102633:	6a 00                	push   $0x0
  pushl $199
c0102635:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010263a:	e9 0e f8 ff ff       	jmp    c0101e4d <__alltraps>

c010263f <vector200>:
.globl vector200
vector200:
  pushl $0
c010263f:	6a 00                	push   $0x0
  pushl $200
c0102641:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102646:	e9 02 f8 ff ff       	jmp    c0101e4d <__alltraps>

c010264b <vector201>:
.globl vector201
vector201:
  pushl $0
c010264b:	6a 00                	push   $0x0
  pushl $201
c010264d:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102652:	e9 f6 f7 ff ff       	jmp    c0101e4d <__alltraps>

c0102657 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102657:	6a 00                	push   $0x0
  pushl $202
c0102659:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010265e:	e9 ea f7 ff ff       	jmp    c0101e4d <__alltraps>

c0102663 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102663:	6a 00                	push   $0x0
  pushl $203
c0102665:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010266a:	e9 de f7 ff ff       	jmp    c0101e4d <__alltraps>

c010266f <vector204>:
.globl vector204
vector204:
  pushl $0
c010266f:	6a 00                	push   $0x0
  pushl $204
c0102671:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c0102676:	e9 d2 f7 ff ff       	jmp    c0101e4d <__alltraps>

c010267b <vector205>:
.globl vector205
vector205:
  pushl $0
c010267b:	6a 00                	push   $0x0
  pushl $205
c010267d:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102682:	e9 c6 f7 ff ff       	jmp    c0101e4d <__alltraps>

c0102687 <vector206>:
.globl vector206
vector206:
  pushl $0
c0102687:	6a 00                	push   $0x0
  pushl $206
c0102689:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c010268e:	e9 ba f7 ff ff       	jmp    c0101e4d <__alltraps>

c0102693 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102693:	6a 00                	push   $0x0
  pushl $207
c0102695:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010269a:	e9 ae f7 ff ff       	jmp    c0101e4d <__alltraps>

c010269f <vector208>:
.globl vector208
vector208:
  pushl $0
c010269f:	6a 00                	push   $0x0
  pushl $208
c01026a1:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01026a6:	e9 a2 f7 ff ff       	jmp    c0101e4d <__alltraps>

c01026ab <vector209>:
.globl vector209
vector209:
  pushl $0
c01026ab:	6a 00                	push   $0x0
  pushl $209
c01026ad:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01026b2:	e9 96 f7 ff ff       	jmp    c0101e4d <__alltraps>

c01026b7 <vector210>:
.globl vector210
vector210:
  pushl $0
c01026b7:	6a 00                	push   $0x0
  pushl $210
c01026b9:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01026be:	e9 8a f7 ff ff       	jmp    c0101e4d <__alltraps>

c01026c3 <vector211>:
.globl vector211
vector211:
  pushl $0
c01026c3:	6a 00                	push   $0x0
  pushl $211
c01026c5:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01026ca:	e9 7e f7 ff ff       	jmp    c0101e4d <__alltraps>

c01026cf <vector212>:
.globl vector212
vector212:
  pushl $0
c01026cf:	6a 00                	push   $0x0
  pushl $212
c01026d1:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01026d6:	e9 72 f7 ff ff       	jmp    c0101e4d <__alltraps>

c01026db <vector213>:
.globl vector213
vector213:
  pushl $0
c01026db:	6a 00                	push   $0x0
  pushl $213
c01026dd:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01026e2:	e9 66 f7 ff ff       	jmp    c0101e4d <__alltraps>

c01026e7 <vector214>:
.globl vector214
vector214:
  pushl $0
c01026e7:	6a 00                	push   $0x0
  pushl $214
c01026e9:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01026ee:	e9 5a f7 ff ff       	jmp    c0101e4d <__alltraps>

c01026f3 <vector215>:
.globl vector215
vector215:
  pushl $0
c01026f3:	6a 00                	push   $0x0
  pushl $215
c01026f5:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01026fa:	e9 4e f7 ff ff       	jmp    c0101e4d <__alltraps>

c01026ff <vector216>:
.globl vector216
vector216:
  pushl $0
c01026ff:	6a 00                	push   $0x0
  pushl $216
c0102701:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102706:	e9 42 f7 ff ff       	jmp    c0101e4d <__alltraps>

c010270b <vector217>:
.globl vector217
vector217:
  pushl $0
c010270b:	6a 00                	push   $0x0
  pushl $217
c010270d:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102712:	e9 36 f7 ff ff       	jmp    c0101e4d <__alltraps>

c0102717 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102717:	6a 00                	push   $0x0
  pushl $218
c0102719:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010271e:	e9 2a f7 ff ff       	jmp    c0101e4d <__alltraps>

c0102723 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102723:	6a 00                	push   $0x0
  pushl $219
c0102725:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010272a:	e9 1e f7 ff ff       	jmp    c0101e4d <__alltraps>

c010272f <vector220>:
.globl vector220
vector220:
  pushl $0
c010272f:	6a 00                	push   $0x0
  pushl $220
c0102731:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102736:	e9 12 f7 ff ff       	jmp    c0101e4d <__alltraps>

c010273b <vector221>:
.globl vector221
vector221:
  pushl $0
c010273b:	6a 00                	push   $0x0
  pushl $221
c010273d:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102742:	e9 06 f7 ff ff       	jmp    c0101e4d <__alltraps>

c0102747 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102747:	6a 00                	push   $0x0
  pushl $222
c0102749:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010274e:	e9 fa f6 ff ff       	jmp    c0101e4d <__alltraps>

c0102753 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102753:	6a 00                	push   $0x0
  pushl $223
c0102755:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010275a:	e9 ee f6 ff ff       	jmp    c0101e4d <__alltraps>

c010275f <vector224>:
.globl vector224
vector224:
  pushl $0
c010275f:	6a 00                	push   $0x0
  pushl $224
c0102761:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c0102766:	e9 e2 f6 ff ff       	jmp    c0101e4d <__alltraps>

c010276b <vector225>:
.globl vector225
vector225:
  pushl $0
c010276b:	6a 00                	push   $0x0
  pushl $225
c010276d:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102772:	e9 d6 f6 ff ff       	jmp    c0101e4d <__alltraps>

c0102777 <vector226>:
.globl vector226
vector226:
  pushl $0
c0102777:	6a 00                	push   $0x0
  pushl $226
c0102779:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c010277e:	e9 ca f6 ff ff       	jmp    c0101e4d <__alltraps>

c0102783 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102783:	6a 00                	push   $0x0
  pushl $227
c0102785:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010278a:	e9 be f6 ff ff       	jmp    c0101e4d <__alltraps>

c010278f <vector228>:
.globl vector228
vector228:
  pushl $0
c010278f:	6a 00                	push   $0x0
  pushl $228
c0102791:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c0102796:	e9 b2 f6 ff ff       	jmp    c0101e4d <__alltraps>

c010279b <vector229>:
.globl vector229
vector229:
  pushl $0
c010279b:	6a 00                	push   $0x0
  pushl $229
c010279d:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01027a2:	e9 a6 f6 ff ff       	jmp    c0101e4d <__alltraps>

c01027a7 <vector230>:
.globl vector230
vector230:
  pushl $0
c01027a7:	6a 00                	push   $0x0
  pushl $230
c01027a9:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01027ae:	e9 9a f6 ff ff       	jmp    c0101e4d <__alltraps>

c01027b3 <vector231>:
.globl vector231
vector231:
  pushl $0
c01027b3:	6a 00                	push   $0x0
  pushl $231
c01027b5:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01027ba:	e9 8e f6 ff ff       	jmp    c0101e4d <__alltraps>

c01027bf <vector232>:
.globl vector232
vector232:
  pushl $0
c01027bf:	6a 00                	push   $0x0
  pushl $232
c01027c1:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01027c6:	e9 82 f6 ff ff       	jmp    c0101e4d <__alltraps>

c01027cb <vector233>:
.globl vector233
vector233:
  pushl $0
c01027cb:	6a 00                	push   $0x0
  pushl $233
c01027cd:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01027d2:	e9 76 f6 ff ff       	jmp    c0101e4d <__alltraps>

c01027d7 <vector234>:
.globl vector234
vector234:
  pushl $0
c01027d7:	6a 00                	push   $0x0
  pushl $234
c01027d9:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01027de:	e9 6a f6 ff ff       	jmp    c0101e4d <__alltraps>

c01027e3 <vector235>:
.globl vector235
vector235:
  pushl $0
c01027e3:	6a 00                	push   $0x0
  pushl $235
c01027e5:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01027ea:	e9 5e f6 ff ff       	jmp    c0101e4d <__alltraps>

c01027ef <vector236>:
.globl vector236
vector236:
  pushl $0
c01027ef:	6a 00                	push   $0x0
  pushl $236
c01027f1:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01027f6:	e9 52 f6 ff ff       	jmp    c0101e4d <__alltraps>

c01027fb <vector237>:
.globl vector237
vector237:
  pushl $0
c01027fb:	6a 00                	push   $0x0
  pushl $237
c01027fd:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102802:	e9 46 f6 ff ff       	jmp    c0101e4d <__alltraps>

c0102807 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102807:	6a 00                	push   $0x0
  pushl $238
c0102809:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010280e:	e9 3a f6 ff ff       	jmp    c0101e4d <__alltraps>

c0102813 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102813:	6a 00                	push   $0x0
  pushl $239
c0102815:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010281a:	e9 2e f6 ff ff       	jmp    c0101e4d <__alltraps>

c010281f <vector240>:
.globl vector240
vector240:
  pushl $0
c010281f:	6a 00                	push   $0x0
  pushl $240
c0102821:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102826:	e9 22 f6 ff ff       	jmp    c0101e4d <__alltraps>

c010282b <vector241>:
.globl vector241
vector241:
  pushl $0
c010282b:	6a 00                	push   $0x0
  pushl $241
c010282d:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102832:	e9 16 f6 ff ff       	jmp    c0101e4d <__alltraps>

c0102837 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102837:	6a 00                	push   $0x0
  pushl $242
c0102839:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010283e:	e9 0a f6 ff ff       	jmp    c0101e4d <__alltraps>

c0102843 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102843:	6a 00                	push   $0x0
  pushl $243
c0102845:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010284a:	e9 fe f5 ff ff       	jmp    c0101e4d <__alltraps>

c010284f <vector244>:
.globl vector244
vector244:
  pushl $0
c010284f:	6a 00                	push   $0x0
  pushl $244
c0102851:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102856:	e9 f2 f5 ff ff       	jmp    c0101e4d <__alltraps>

c010285b <vector245>:
.globl vector245
vector245:
  pushl $0
c010285b:	6a 00                	push   $0x0
  pushl $245
c010285d:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102862:	e9 e6 f5 ff ff       	jmp    c0101e4d <__alltraps>

c0102867 <vector246>:
.globl vector246
vector246:
  pushl $0
c0102867:	6a 00                	push   $0x0
  pushl $246
c0102869:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c010286e:	e9 da f5 ff ff       	jmp    c0101e4d <__alltraps>

c0102873 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102873:	6a 00                	push   $0x0
  pushl $247
c0102875:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010287a:	e9 ce f5 ff ff       	jmp    c0101e4d <__alltraps>

c010287f <vector248>:
.globl vector248
vector248:
  pushl $0
c010287f:	6a 00                	push   $0x0
  pushl $248
c0102881:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c0102886:	e9 c2 f5 ff ff       	jmp    c0101e4d <__alltraps>

c010288b <vector249>:
.globl vector249
vector249:
  pushl $0
c010288b:	6a 00                	push   $0x0
  pushl $249
c010288d:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102892:	e9 b6 f5 ff ff       	jmp    c0101e4d <__alltraps>

c0102897 <vector250>:
.globl vector250
vector250:
  pushl $0
c0102897:	6a 00                	push   $0x0
  pushl $250
c0102899:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c010289e:	e9 aa f5 ff ff       	jmp    c0101e4d <__alltraps>

c01028a3 <vector251>:
.globl vector251
vector251:
  pushl $0
c01028a3:	6a 00                	push   $0x0
  pushl $251
c01028a5:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01028aa:	e9 9e f5 ff ff       	jmp    c0101e4d <__alltraps>

c01028af <vector252>:
.globl vector252
vector252:
  pushl $0
c01028af:	6a 00                	push   $0x0
  pushl $252
c01028b1:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01028b6:	e9 92 f5 ff ff       	jmp    c0101e4d <__alltraps>

c01028bb <vector253>:
.globl vector253
vector253:
  pushl $0
c01028bb:	6a 00                	push   $0x0
  pushl $253
c01028bd:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01028c2:	e9 86 f5 ff ff       	jmp    c0101e4d <__alltraps>

c01028c7 <vector254>:
.globl vector254
vector254:
  pushl $0
c01028c7:	6a 00                	push   $0x0
  pushl $254
c01028c9:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01028ce:	e9 7a f5 ff ff       	jmp    c0101e4d <__alltraps>

c01028d3 <vector255>:
.globl vector255
vector255:
  pushl $0
c01028d3:	6a 00                	push   $0x0
  pushl $255
c01028d5:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01028da:	e9 6e f5 ff ff       	jmp    c0101e4d <__alltraps>

c01028df <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01028df:	55                   	push   %ebp
c01028e0:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01028e2:	8b 55 08             	mov    0x8(%ebp),%edx
c01028e5:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01028ea:	29 c2                	sub    %eax,%edx
c01028ec:	89 d0                	mov    %edx,%eax
c01028ee:	c1 f8 02             	sar    $0x2,%eax
c01028f1:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028f7:	5d                   	pop    %ebp
c01028f8:	c3                   	ret    

c01028f9 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01028f9:	55                   	push   %ebp
c01028fa:	89 e5                	mov    %esp,%ebp
c01028fc:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01028ff:	8b 45 08             	mov    0x8(%ebp),%eax
c0102902:	89 04 24             	mov    %eax,(%esp)
c0102905:	e8 d5 ff ff ff       	call   c01028df <page2ppn>
c010290a:	c1 e0 0c             	shl    $0xc,%eax
}
c010290d:	c9                   	leave  
c010290e:	c3                   	ret    

c010290f <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010290f:	55                   	push   %ebp
c0102910:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102912:	8b 45 08             	mov    0x8(%ebp),%eax
c0102915:	8b 00                	mov    (%eax),%eax
}
c0102917:	5d                   	pop    %ebp
c0102918:	c3                   	ret    

c0102919 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102919:	55                   	push   %ebp
c010291a:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010291c:	8b 45 08             	mov    0x8(%ebp),%eax
c010291f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102922:	89 10                	mov    %edx,(%eax)
}
c0102924:	5d                   	pop    %ebp
c0102925:	c3                   	ret    

c0102926 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0102926:	55                   	push   %ebp
c0102927:	89 e5                	mov    %esp,%ebp
c0102929:	83 ec 10             	sub    $0x10,%esp
c010292c:	c7 45 fc 50 89 11 c0 	movl   $0xc0118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102933:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102936:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102939:	89 50 04             	mov    %edx,0x4(%eax)
c010293c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010293f:	8b 50 04             	mov    0x4(%eax),%edx
c0102942:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102945:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0102947:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c010294e:	00 00 00 
}
c0102951:	c9                   	leave  
c0102952:	c3                   	ret    

c0102953 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0102953:	55                   	push   %ebp
c0102954:	89 e5                	mov    %esp,%ebp
c0102956:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
c0102959:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010295d:	75 24                	jne    c0102983 <default_init_memmap+0x30>
c010295f:	c7 44 24 0c d0 66 10 	movl   $0xc01066d0,0xc(%esp)
c0102966:	c0 
c0102967:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010296e:	c0 
c010296f:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c0102976:	00 
c0102977:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010297e:	e8 28 e3 ff ff       	call   c0100cab <__panic>
    struct Page *p = base;
c0102983:	8b 45 08             	mov    0x8(%ebp),%eax
c0102986:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102989:	e9 dc 00 00 00       	jmp    c0102a6a <default_init_memmap+0x117>
        assert(PageReserved(p));
c010298e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102991:	83 c0 04             	add    $0x4,%eax
c0102994:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c010299b:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010299e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01029a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01029a4:	0f a3 10             	bt     %edx,(%eax)
c01029a7:	19 c0                	sbb    %eax,%eax
c01029a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01029ac:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01029b0:	0f 95 c0             	setne  %al
c01029b3:	0f b6 c0             	movzbl %al,%eax
c01029b6:	85 c0                	test   %eax,%eax
c01029b8:	75 24                	jne    c01029de <default_init_memmap+0x8b>
c01029ba:	c7 44 24 0c 01 67 10 	movl   $0xc0106701,0xc(%esp)
c01029c1:	c0 
c01029c2:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01029c9:	c0 
c01029ca:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01029d1:	00 
c01029d2:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01029d9:	e8 cd e2 ff ff       	call   c0100cab <__panic>
        p->flags = 0;
c01029de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029e1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
c01029e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029eb:	83 c0 04             	add    $0x4,%eax
c01029ee:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01029f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01029f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01029fb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01029fe:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
c0102a01:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a04:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
c0102a0b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102a12:	00 
c0102a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a16:	89 04 24             	mov    %eax,(%esp)
c0102a19:	e8 fb fe ff ff       	call   c0102919 <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
c0102a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a21:	83 c0 0c             	add    $0xc,%eax
c0102a24:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
c0102a2b:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102a2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a31:	8b 00                	mov    (%eax),%eax
c0102a33:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102a36:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102a39:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102a3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102a3f:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102a42:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a45:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a48:	89 10                	mov    %edx,(%eax)
c0102a4a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a4d:	8b 10                	mov    (%eax),%edx
c0102a4f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102a52:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102a55:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a58:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102a5b:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a5e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a61:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102a64:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102a66:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102a6a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a6d:	89 d0                	mov    %edx,%eax
c0102a6f:	c1 e0 02             	shl    $0x2,%eax
c0102a72:	01 d0                	add    %edx,%eax
c0102a74:	c1 e0 02             	shl    $0x2,%eax
c0102a77:	89 c2                	mov    %eax,%edx
c0102a79:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a7c:	01 d0                	add    %edx,%eax
c0102a7e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102a81:	0f 85 07 ff ff ff    	jne    c010298e <default_init_memmap+0x3b>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    base->property = n;
c0102a87:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a8a:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a8d:	89 50 08             	mov    %edx,0x8(%eax)
    nr_free += n;
c0102a90:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102a96:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a99:	01 d0                	add    %edx,%eax
c0102a9b:	a3 58 89 11 c0       	mov    %eax,0xc0118958
}
c0102aa0:	c9                   	leave  
c0102aa1:	c3                   	ret    

c0102aa2 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102aa2:	55                   	push   %ebp
c0102aa3:	89 e5                	mov    %esp,%ebp
c0102aa5:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102aa8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102aac:	75 24                	jne    c0102ad2 <default_alloc_pages+0x30>
c0102aae:	c7 44 24 0c d0 66 10 	movl   $0xc01066d0,0xc(%esp)
c0102ab5:	c0 
c0102ab6:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102abd:	c0 
c0102abe:	c7 44 24 04 56 00 00 	movl   $0x56,0x4(%esp)
c0102ac5:	00 
c0102ac6:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102acd:	e8 d9 e1 ff ff       	call   c0100cab <__panic>
    if (n > nr_free) {
c0102ad2:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102ad7:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ada:	73 0a                	jae    c0102ae6 <default_alloc_pages+0x44>
        return NULL;
c0102adc:	b8 00 00 00 00       	mov    $0x0,%eax
c0102ae1:	e9 37 01 00 00       	jmp    c0102c1d <default_alloc_pages+0x17b>
    }
    list_entry_t *le, *len;
    le = &free_list;
c0102ae6:	c7 45 f4 50 89 11 c0 	movl   $0xc0118950,-0xc(%ebp)
    while((le=list_next(le)) != &free_list) {
c0102aed:	e9 0a 01 00 00       	jmp    c0102bfc <default_alloc_pages+0x15a>
      struct Page *p = le2page(le, page_link);
c0102af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102af5:	83 e8 0c             	sub    $0xc,%eax
c0102af8:	89 45 ec             	mov    %eax,-0x14(%ebp)
      ClearPageProperty(p);
c0102afb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102afe:	83 c0 04             	add    $0x4,%eax
c0102b01:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102b08:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b0b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102b0e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102b11:	0f b3 10             	btr    %edx,(%eax)
      SetPageReserved(p);
c0102b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b17:	83 c0 04             	add    $0x4,%eax
c0102b1a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
c0102b21:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b24:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102b27:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102b2a:	0f ab 10             	bts    %edx,(%eax)
      if(p->property >= n){
c0102b2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b30:	8b 40 08             	mov    0x8(%eax),%eax
c0102b33:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b36:	0f 82 c0 00 00 00    	jb     c0102bfc <default_alloc_pages+0x15a>
        int i;
        for(i=0;i<n;i++){
c0102b3c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102b43:	eb 7c                	jmp    c0102bc1 <default_alloc_pages+0x11f>
c0102b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b48:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102b4b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b4e:	8b 40 04             	mov    0x4(%eax),%eax
          len = list_next(le);
c0102b51:	89 45 e8             	mov    %eax,-0x18(%ebp)
          struct Page *pp = le2page(le, page_link);
c0102b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b57:	83 e8 0c             	sub    $0xc,%eax
c0102b5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          SetPageReserved(pp);
c0102b5d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b60:	83 c0 04             	add    $0x4,%eax
c0102b63:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
c0102b6a:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102b6d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b70:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102b73:	0f ab 10             	bts    %edx,(%eax)
          ClearPageProperty(pp);
c0102b76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102b79:	83 c0 04             	add    $0x4,%eax
c0102b7c:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102b83:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b86:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102b89:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b8c:	0f b3 10             	btr    %edx,(%eax)
c0102b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b92:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102b95:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b98:	8b 40 04             	mov    0x4(%eax),%eax
c0102b9b:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102b9e:	8b 12                	mov    (%edx),%edx
c0102ba0:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102ba3:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102ba6:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102ba9:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102bac:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102baf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102bb2:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102bb5:	89 10                	mov    %edx,(%eax)
          list_del(le);//由于各页本身是链在一起的分配出去的页只需给出第一个页的地址，不用管从空闲页链表中删除这些页后这些页的指针是否会丢失
          le = len;
c0102bb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102bba:	89 45 f4             	mov    %eax,-0xc(%ebp)
      struct Page *p = le2page(le, page_link);
      ClearPageProperty(p);
      SetPageReserved(p);
      if(p->property >= n){
        int i;
        for(i=0;i<n;i++){
c0102bbd:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c0102bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102bc4:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102bc7:	0f 82 78 ff ff ff    	jb     c0102b45 <default_alloc_pages+0xa3>
          SetPageReserved(pp);
          ClearPageProperty(pp);
          list_del(le);//由于各页本身是链在一起的分配出去的页只需给出第一个页的地址，不用管从空闲页链表中删除这些页后这些页的指针是否会丢失
          le = len;
        }
        if(p->property>n){
c0102bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102bd0:	8b 40 08             	mov    0x8(%eax),%eax
c0102bd3:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102bd6:	76 12                	jbe    c0102bea <default_alloc_pages+0x148>
          (le2page(le,page_link))->property = p->property - n;//重新设置空闲块的起始页
c0102bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bdb:	8d 50 f4             	lea    -0xc(%eax),%edx
c0102bde:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102be1:	8b 40 08             	mov    0x8(%eax),%eax
c0102be4:	2b 45 08             	sub    0x8(%ebp),%eax
c0102be7:	89 42 08             	mov    %eax,0x8(%edx)
        }
        nr_free -= n;
c0102bea:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102bef:	2b 45 08             	sub    0x8(%ebp),%eax
c0102bf2:	a3 58 89 11 c0       	mov    %eax,0xc0118958
        return p;
c0102bf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102bfa:	eb 21                	jmp    c0102c1d <default_alloc_pages+0x17b>
c0102bfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bff:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102c02:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102c05:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    list_entry_t *le, *len;
    le = &free_list;
    while((le=list_next(le)) != &free_list) {
c0102c08:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102c0b:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102c12:	0f 85 da fe ff ff    	jne    c0102af2 <default_alloc_pages+0x50>
        }
        nr_free -= n;
        return p;
      }
    }
    return NULL;
c0102c18:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0102c1d:	c9                   	leave  
c0102c1e:	c3                   	ret    

c0102c1f <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102c1f:	55                   	push   %ebp
c0102c20:	89 e5                	mov    %esp,%ebp
c0102c22:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102c25:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102c29:	75 24                	jne    c0102c4f <default_free_pages+0x30>
c0102c2b:	c7 44 24 0c d0 66 10 	movl   $0xc01066d0,0xc(%esp)
c0102c32:	c0 
c0102c33:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102c3a:	c0 
c0102c3b:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
c0102c42:	00 
c0102c43:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102c4a:	e8 5c e0 ff ff       	call   c0100cab <__panic>
    assert(PageReserved(base));
c0102c4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c52:	83 c0 04             	add    $0x4,%eax
c0102c55:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102c5c:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c62:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102c65:	0f a3 10             	bt     %edx,(%eax)
c0102c68:	19 c0                	sbb    %eax,%eax
c0102c6a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c0102c6d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102c71:	0f 95 c0             	setne  %al
c0102c74:	0f b6 c0             	movzbl %al,%eax
c0102c77:	85 c0                	test   %eax,%eax
c0102c79:	75 24                	jne    c0102c9f <default_free_pages+0x80>
c0102c7b:	c7 44 24 0c 11 67 10 	movl   $0xc0106711,0xc(%esp)
c0102c82:	c0 
c0102c83:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102c8a:	c0 
c0102c8b:	c7 44 24 04 77 00 00 	movl   $0x77,0x4(%esp)
c0102c92:	00 
c0102c93:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102c9a:	e8 0c e0 ff ff       	call   c0100cab <__panic>

    list_entry_t *le = &free_list;
c0102c9f:	c7 45 f4 50 89 11 c0 	movl   $0xc0118950,-0xc(%ebp)
    struct Page * p;
    //找到第一个起始页地址大于释放块起始页地址的空闲页
    while((le=list_next(le)) != &free_list) {
c0102ca6:	eb 13                	jmp    c0102cbb <default_free_pages+0x9c>
      p = le2page(le, page_link);
c0102ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cab:	83 e8 0c             	sub    $0xc,%eax
c0102cae:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(p>base){
c0102cb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cb4:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102cb7:	76 02                	jbe    c0102cbb <default_free_pages+0x9c>
        break;
c0102cb9:	eb 18                	jmp    c0102cd3 <default_free_pages+0xb4>
c0102cbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102cc1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102cc4:	8b 40 04             	mov    0x4(%eax),%eax
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page * p;
    //找到第一个起始页地址大于释放块起始页地址的空闲页
    while((le=list_next(le)) != &free_list) {
c0102cc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102cca:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102cd1:	75 d5                	jne    c0102ca8 <default_free_pages+0x89>
      if(p>base){
        break;
      }
    }
    //不断在空闲链中插入要释放的页，插入点在刚找到的空闲页之前，这样可以保证空闲链中的各页还是地址从小到大有序的
    for(p=base;p<base+n;p++){
c0102cd3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102cd9:	eb 4b                	jmp    c0102d26 <default_free_pages+0x107>
      list_add_before(le, &(p->page_link));
c0102cdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cde:	8d 50 0c             	lea    0xc(%eax),%edx
c0102ce1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ce4:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0102ce7:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102cea:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102ced:	8b 00                	mov    (%eax),%eax
c0102cef:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102cf2:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102cf5:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102cf8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102cfb:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102cfe:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102d01:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102d04:	89 10                	mov    %edx,(%eax)
c0102d06:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102d09:	8b 10                	mov    (%eax),%edx
c0102d0b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102d0e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102d11:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102d14:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102d17:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102d1a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102d1d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102d20:	89 10                	mov    %edx,(%eax)
      if(p>base){
        break;
      }
    }
    //不断在空闲链中插入要释放的页，插入点在刚找到的空闲页之前，这样可以保证空闲链中的各页还是地址从小到大有序的
    for(p=base;p<base+n;p++){
c0102d22:	83 45 f0 14          	addl   $0x14,-0x10(%ebp)
c0102d26:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d29:	89 d0                	mov    %edx,%eax
c0102d2b:	c1 e0 02             	shl    $0x2,%eax
c0102d2e:	01 d0                	add    %edx,%eax
c0102d30:	c1 e0 02             	shl    $0x2,%eax
c0102d33:	89 c2                	mov    %eax,%edx
c0102d35:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d38:	01 d0                	add    %edx,%eax
c0102d3a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102d3d:	77 9c                	ja     c0102cdb <default_free_pages+0xbc>
      list_add_before(le, &(p->page_link));
    }
    //暂时先把释放的这n页初始化为一个空闲块
    base->flags = 0;
c0102d3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c0102d49:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102d50:	00 
c0102d51:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d54:	89 04 24             	mov    %eax,(%esp)
c0102d57:	e8 bd fb ff ff       	call   c0102919 <set_page_ref>
    ClearPageProperty(base);
c0102d5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d5f:	83 c0 04             	add    $0x4,%eax
c0102d62:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0102d69:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d6c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d6f:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102d72:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c0102d75:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d78:	83 c0 04             	add    $0x4,%eax
c0102d7b:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0102d82:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d85:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d88:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102d8b:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c0102d8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d91:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d94:	89 50 08             	mov    %edx,0x8(%eax)
    
    //空闲页le刚好在释放的这个n页之后,则将以这个空闲页为首的空闲块合并到这n个释放页组成的空闲块中
    p = le2page(le,page_link) ;
c0102d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d9a:	83 e8 0c             	sub    $0xc,%eax
c0102d9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if( base+n == p ){
c0102da0:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102da3:	89 d0                	mov    %edx,%eax
c0102da5:	c1 e0 02             	shl    $0x2,%eax
c0102da8:	01 d0                	add    %edx,%eax
c0102daa:	c1 e0 02             	shl    $0x2,%eax
c0102dad:	89 c2                	mov    %eax,%edx
c0102daf:	8b 45 08             	mov    0x8(%ebp),%eax
c0102db2:	01 d0                	add    %edx,%eax
c0102db4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102db7:	75 1e                	jne    c0102dd7 <default_free_pages+0x1b8>
      base->property += p->property;
c0102db9:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dbc:	8b 50 08             	mov    0x8(%eax),%edx
c0102dbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dc2:	8b 40 08             	mov    0x8(%eax),%eax
c0102dc5:	01 c2                	add    %eax,%edx
c0102dc7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dca:	89 50 08             	mov    %edx,0x8(%eax)
      p->property = 0;
c0102dcd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dd0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    //从释放块的首页开始向前找，找到一个空闲块，把释放块和这一个空闲块合并
    le = list_prev(&(base->page_link));
c0102dd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dda:	83 c0 0c             	add    $0xc,%eax
c0102ddd:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102de0:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102de3:	8b 00                	mov    (%eax),%eax
c0102de5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
c0102de8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102deb:	83 e8 0c             	sub    $0xc,%eax
c0102dee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(le!=&free_list && p==base-1){
c0102df1:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102df8:	74 57                	je     c0102e51 <default_free_pages+0x232>
c0102dfa:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dfd:	83 e8 14             	sub    $0x14,%eax
c0102e00:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102e03:	75 4c                	jne    c0102e51 <default_free_pages+0x232>
      while(le!=&free_list){
c0102e05:	eb 41                	jmp    c0102e48 <default_free_pages+0x229>
        if(p->property){
c0102e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e0a:	8b 40 08             	mov    0x8(%eax),%eax
c0102e0d:	85 c0                	test   %eax,%eax
c0102e0f:	74 20                	je     c0102e31 <default_free_pages+0x212>
          p->property += base->property;
c0102e11:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e14:	8b 50 08             	mov    0x8(%eax),%edx
c0102e17:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e1a:	8b 40 08             	mov    0x8(%eax),%eax
c0102e1d:	01 c2                	add    %eax,%edx
c0102e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e22:	89 50 08             	mov    %edx,0x8(%eax)
          base->property = 0;
c0102e25:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e28:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          break;
c0102e2f:	eb 20                	jmp    c0102e51 <default_free_pages+0x232>
c0102e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e34:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0102e37:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102e3a:	8b 00                	mov    (%eax),%eax
        }
        le = list_prev(le);
c0102e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = le2page(le,page_link);
c0102e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e42:	83 e8 0c             	sub    $0xc,%eax
c0102e45:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    //从释放块的首页开始向前找，找到一个空闲块，把释放块和这一个空闲块合并
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if(le!=&free_list && p==base-1){
      while(le!=&free_list){
c0102e48:	81 7d f4 50 89 11 c0 	cmpl   $0xc0118950,-0xc(%ebp)
c0102e4f:	75 b6                	jne    c0102e07 <default_free_pages+0x1e8>
        le = list_prev(le);
        p = le2page(le,page_link);
      }
    }
    //总空闲页数加n
    nr_free += n;
c0102e51:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102e57:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e5a:	01 d0                	add    %edx,%eax
c0102e5c:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    return ;
c0102e61:	90                   	nop
}
c0102e62:	c9                   	leave  
c0102e63:	c3                   	ret    

c0102e64 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102e64:	55                   	push   %ebp
c0102e65:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102e67:	a1 58 89 11 c0       	mov    0xc0118958,%eax
}
c0102e6c:	5d                   	pop    %ebp
c0102e6d:	c3                   	ret    

c0102e6e <basic_check>:

static void
basic_check(void) {
c0102e6e:	55                   	push   %ebp
c0102e6f:	89 e5                	mov    %esp,%ebp
c0102e71:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102e74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e81:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e84:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102e87:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e8e:	e8 85 0e 00 00       	call   c0103d18 <alloc_pages>
c0102e93:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102e96:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102e9a:	75 24                	jne    c0102ec0 <basic_check+0x52>
c0102e9c:	c7 44 24 0c 24 67 10 	movl   $0xc0106724,0xc(%esp)
c0102ea3:	c0 
c0102ea4:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102eab:	c0 
c0102eac:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c0102eb3:	00 
c0102eb4:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102ebb:	e8 eb dd ff ff       	call   c0100cab <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102ec0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ec7:	e8 4c 0e 00 00       	call   c0103d18 <alloc_pages>
c0102ecc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102ecf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102ed3:	75 24                	jne    c0102ef9 <basic_check+0x8b>
c0102ed5:	c7 44 24 0c 40 67 10 	movl   $0xc0106740,0xc(%esp)
c0102edc:	c0 
c0102edd:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102ee4:	c0 
c0102ee5:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c0102eec:	00 
c0102eed:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102ef4:	e8 b2 dd ff ff       	call   c0100cab <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102ef9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f00:	e8 13 0e 00 00       	call   c0103d18 <alloc_pages>
c0102f05:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102f08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102f0c:	75 24                	jne    c0102f32 <basic_check+0xc4>
c0102f0e:	c7 44 24 0c 5c 67 10 	movl   $0xc010675c,0xc(%esp)
c0102f15:	c0 
c0102f16:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102f1d:	c0 
c0102f1e:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0102f25:	00 
c0102f26:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102f2d:	e8 79 dd ff ff       	call   c0100cab <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102f32:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f35:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102f38:	74 10                	je     c0102f4a <basic_check+0xdc>
c0102f3a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f3d:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f40:	74 08                	je     c0102f4a <basic_check+0xdc>
c0102f42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f45:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102f48:	75 24                	jne    c0102f6e <basic_check+0x100>
c0102f4a:	c7 44 24 0c 78 67 10 	movl   $0xc0106778,0xc(%esp)
c0102f51:	c0 
c0102f52:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102f59:	c0 
c0102f5a:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0102f61:	00 
c0102f62:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102f69:	e8 3d dd ff ff       	call   c0100cab <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102f6e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f71:	89 04 24             	mov    %eax,(%esp)
c0102f74:	e8 96 f9 ff ff       	call   c010290f <page_ref>
c0102f79:	85 c0                	test   %eax,%eax
c0102f7b:	75 1e                	jne    c0102f9b <basic_check+0x12d>
c0102f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f80:	89 04 24             	mov    %eax,(%esp)
c0102f83:	e8 87 f9 ff ff       	call   c010290f <page_ref>
c0102f88:	85 c0                	test   %eax,%eax
c0102f8a:	75 0f                	jne    c0102f9b <basic_check+0x12d>
c0102f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f8f:	89 04 24             	mov    %eax,(%esp)
c0102f92:	e8 78 f9 ff ff       	call   c010290f <page_ref>
c0102f97:	85 c0                	test   %eax,%eax
c0102f99:	74 24                	je     c0102fbf <basic_check+0x151>
c0102f9b:	c7 44 24 0c 9c 67 10 	movl   $0xc010679c,0xc(%esp)
c0102fa2:	c0 
c0102fa3:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102faa:	c0 
c0102fab:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c0102fb2:	00 
c0102fb3:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102fba:	e8 ec dc ff ff       	call   c0100cab <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102fbf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fc2:	89 04 24             	mov    %eax,(%esp)
c0102fc5:	e8 2f f9 ff ff       	call   c01028f9 <page2pa>
c0102fca:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102fd0:	c1 e2 0c             	shl    $0xc,%edx
c0102fd3:	39 d0                	cmp    %edx,%eax
c0102fd5:	72 24                	jb     c0102ffb <basic_check+0x18d>
c0102fd7:	c7 44 24 0c d8 67 10 	movl   $0xc01067d8,0xc(%esp)
c0102fde:	c0 
c0102fdf:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0102fe6:	c0 
c0102fe7:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0102fee:	00 
c0102fef:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0102ff6:	e8 b0 dc ff ff       	call   c0100cab <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102ffb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ffe:	89 04 24             	mov    %eax,(%esp)
c0103001:	e8 f3 f8 ff ff       	call   c01028f9 <page2pa>
c0103006:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c010300c:	c1 e2 0c             	shl    $0xc,%edx
c010300f:	39 d0                	cmp    %edx,%eax
c0103011:	72 24                	jb     c0103037 <basic_check+0x1c9>
c0103013:	c7 44 24 0c f5 67 10 	movl   $0xc01067f5,0xc(%esp)
c010301a:	c0 
c010301b:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103022:	c0 
c0103023:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c010302a:	00 
c010302b:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103032:	e8 74 dc ff ff       	call   c0100cab <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103037:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010303a:	89 04 24             	mov    %eax,(%esp)
c010303d:	e8 b7 f8 ff ff       	call   c01028f9 <page2pa>
c0103042:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103048:	c1 e2 0c             	shl    $0xc,%edx
c010304b:	39 d0                	cmp    %edx,%eax
c010304d:	72 24                	jb     c0103073 <basic_check+0x205>
c010304f:	c7 44 24 0c 12 68 10 	movl   $0xc0106812,0xc(%esp)
c0103056:	c0 
c0103057:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010305e:	c0 
c010305f:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0103066:	00 
c0103067:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010306e:	e8 38 dc ff ff       	call   c0100cab <__panic>

    list_entry_t free_list_store = free_list;
c0103073:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0103078:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c010307e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103081:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103084:	c7 45 e0 50 89 11 c0 	movl   $0xc0118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010308b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010308e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103091:	89 50 04             	mov    %edx,0x4(%eax)
c0103094:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103097:	8b 50 04             	mov    0x4(%eax),%edx
c010309a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010309d:	89 10                	mov    %edx,(%eax)
c010309f:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01030a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01030a9:	8b 40 04             	mov    0x4(%eax),%eax
c01030ac:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01030af:	0f 94 c0             	sete   %al
c01030b2:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01030b5:	85 c0                	test   %eax,%eax
c01030b7:	75 24                	jne    c01030dd <basic_check+0x26f>
c01030b9:	c7 44 24 0c 2f 68 10 	movl   $0xc010682f,0xc(%esp)
c01030c0:	c0 
c01030c1:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01030c8:	c0 
c01030c9:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c01030d0:	00 
c01030d1:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01030d8:	e8 ce db ff ff       	call   c0100cab <__panic>

    unsigned int nr_free_store = nr_free;
c01030dd:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01030e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c01030e5:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c01030ec:	00 00 00 

    assert(alloc_page() == NULL);
c01030ef:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030f6:	e8 1d 0c 00 00       	call   c0103d18 <alloc_pages>
c01030fb:	85 c0                	test   %eax,%eax
c01030fd:	74 24                	je     c0103123 <basic_check+0x2b5>
c01030ff:	c7 44 24 0c 46 68 10 	movl   $0xc0106846,0xc(%esp)
c0103106:	c0 
c0103107:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010310e:	c0 
c010310f:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0103116:	00 
c0103117:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010311e:	e8 88 db ff ff       	call   c0100cab <__panic>

    free_page(p0);
c0103123:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010312a:	00 
c010312b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010312e:	89 04 24             	mov    %eax,(%esp)
c0103131:	e8 1a 0c 00 00       	call   c0103d50 <free_pages>
    free_page(p1);
c0103136:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010313d:	00 
c010313e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103141:	89 04 24             	mov    %eax,(%esp)
c0103144:	e8 07 0c 00 00       	call   c0103d50 <free_pages>
    free_page(p2);
c0103149:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103150:	00 
c0103151:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103154:	89 04 24             	mov    %eax,(%esp)
c0103157:	e8 f4 0b 00 00       	call   c0103d50 <free_pages>
    assert(nr_free == 3);
c010315c:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103161:	83 f8 03             	cmp    $0x3,%eax
c0103164:	74 24                	je     c010318a <basic_check+0x31c>
c0103166:	c7 44 24 0c 5b 68 10 	movl   $0xc010685b,0xc(%esp)
c010316d:	c0 
c010316e:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103175:	c0 
c0103176:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c010317d:	00 
c010317e:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103185:	e8 21 db ff ff       	call   c0100cab <__panic>

    assert((p0 = alloc_page()) != NULL);
c010318a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103191:	e8 82 0b 00 00       	call   c0103d18 <alloc_pages>
c0103196:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103199:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010319d:	75 24                	jne    c01031c3 <basic_check+0x355>
c010319f:	c7 44 24 0c 24 67 10 	movl   $0xc0106724,0xc(%esp)
c01031a6:	c0 
c01031a7:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01031ae:	c0 
c01031af:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c01031b6:	00 
c01031b7:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01031be:	e8 e8 da ff ff       	call   c0100cab <__panic>
    assert((p1 = alloc_page()) != NULL);
c01031c3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031ca:	e8 49 0b 00 00       	call   c0103d18 <alloc_pages>
c01031cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01031d2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01031d6:	75 24                	jne    c01031fc <basic_check+0x38e>
c01031d8:	c7 44 24 0c 40 67 10 	movl   $0xc0106740,0xc(%esp)
c01031df:	c0 
c01031e0:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01031e7:	c0 
c01031e8:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01031ef:	00 
c01031f0:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01031f7:	e8 af da ff ff       	call   c0100cab <__panic>
    assert((p2 = alloc_page()) != NULL);
c01031fc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103203:	e8 10 0b 00 00       	call   c0103d18 <alloc_pages>
c0103208:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010320b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010320f:	75 24                	jne    c0103235 <basic_check+0x3c7>
c0103211:	c7 44 24 0c 5c 67 10 	movl   $0xc010675c,0xc(%esp)
c0103218:	c0 
c0103219:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103220:	c0 
c0103221:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0103228:	00 
c0103229:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103230:	e8 76 da ff ff       	call   c0100cab <__panic>

    assert(alloc_page() == NULL);
c0103235:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010323c:	e8 d7 0a 00 00       	call   c0103d18 <alloc_pages>
c0103241:	85 c0                	test   %eax,%eax
c0103243:	74 24                	je     c0103269 <basic_check+0x3fb>
c0103245:	c7 44 24 0c 46 68 10 	movl   $0xc0106846,0xc(%esp)
c010324c:	c0 
c010324d:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103254:	c0 
c0103255:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c010325c:	00 
c010325d:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103264:	e8 42 da ff ff       	call   c0100cab <__panic>

    free_page(p0);
c0103269:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103270:	00 
c0103271:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103274:	89 04 24             	mov    %eax,(%esp)
c0103277:	e8 d4 0a 00 00       	call   c0103d50 <free_pages>
c010327c:	c7 45 d8 50 89 11 c0 	movl   $0xc0118950,-0x28(%ebp)
c0103283:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103286:	8b 40 04             	mov    0x4(%eax),%eax
c0103289:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c010328c:	0f 94 c0             	sete   %al
c010328f:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103292:	85 c0                	test   %eax,%eax
c0103294:	74 24                	je     c01032ba <basic_check+0x44c>
c0103296:	c7 44 24 0c 68 68 10 	movl   $0xc0106868,0xc(%esp)
c010329d:	c0 
c010329e:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01032a5:	c0 
c01032a6:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c01032ad:	00 
c01032ae:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01032b5:	e8 f1 d9 ff ff       	call   c0100cab <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01032ba:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032c1:	e8 52 0a 00 00       	call   c0103d18 <alloc_pages>
c01032c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01032c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01032cc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01032cf:	74 24                	je     c01032f5 <basic_check+0x487>
c01032d1:	c7 44 24 0c 80 68 10 	movl   $0xc0106880,0xc(%esp)
c01032d8:	c0 
c01032d9:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01032e0:	c0 
c01032e1:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c01032e8:	00 
c01032e9:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01032f0:	e8 b6 d9 ff ff       	call   c0100cab <__panic>
    assert(alloc_page() == NULL);
c01032f5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032fc:	e8 17 0a 00 00       	call   c0103d18 <alloc_pages>
c0103301:	85 c0                	test   %eax,%eax
c0103303:	74 24                	je     c0103329 <basic_check+0x4bb>
c0103305:	c7 44 24 0c 46 68 10 	movl   $0xc0106846,0xc(%esp)
c010330c:	c0 
c010330d:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103314:	c0 
c0103315:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c010331c:	00 
c010331d:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103324:	e8 82 d9 ff ff       	call   c0100cab <__panic>

    assert(nr_free == 0);
c0103329:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c010332e:	85 c0                	test   %eax,%eax
c0103330:	74 24                	je     c0103356 <basic_check+0x4e8>
c0103332:	c7 44 24 0c 99 68 10 	movl   $0xc0106899,0xc(%esp)
c0103339:	c0 
c010333a:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103341:	c0 
c0103342:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0103349:	00 
c010334a:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103351:	e8 55 d9 ff ff       	call   c0100cab <__panic>
    free_list = free_list_store;
c0103356:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103359:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010335c:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103361:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    nr_free = nr_free_store;
c0103367:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010336a:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_page(p);
c010336f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103376:	00 
c0103377:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010337a:	89 04 24             	mov    %eax,(%esp)
c010337d:	e8 ce 09 00 00       	call   c0103d50 <free_pages>
    free_page(p1);
c0103382:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103389:	00 
c010338a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010338d:	89 04 24             	mov    %eax,(%esp)
c0103390:	e8 bb 09 00 00       	call   c0103d50 <free_pages>
    free_page(p2);
c0103395:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010339c:	00 
c010339d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033a0:	89 04 24             	mov    %eax,(%esp)
c01033a3:	e8 a8 09 00 00       	call   c0103d50 <free_pages>
}
c01033a8:	c9                   	leave  
c01033a9:	c3                   	ret    

c01033aa <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01033aa:	55                   	push   %ebp
c01033ab:	89 e5                	mov    %esp,%ebp
c01033ad:	53                   	push   %ebx
c01033ae:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c01033b4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01033bb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01033c2:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01033c9:	eb 6b                	jmp    c0103436 <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01033cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033ce:	83 e8 0c             	sub    $0xc,%eax
c01033d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c01033d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033d7:	83 c0 04             	add    $0x4,%eax
c01033da:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c01033e1:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01033e4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01033e7:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01033ea:	0f a3 10             	bt     %edx,(%eax)
c01033ed:	19 c0                	sbb    %eax,%eax
c01033ef:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c01033f2:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01033f6:	0f 95 c0             	setne  %al
c01033f9:	0f b6 c0             	movzbl %al,%eax
c01033fc:	85 c0                	test   %eax,%eax
c01033fe:	75 24                	jne    c0103424 <default_check+0x7a>
c0103400:	c7 44 24 0c a6 68 10 	movl   $0xc01068a6,0xc(%esp)
c0103407:	c0 
c0103408:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010340f:	c0 
c0103410:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c0103417:	00 
c0103418:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010341f:	e8 87 d8 ff ff       	call   c0100cab <__panic>
        count ++, total += p->property;
c0103424:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103428:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010342b:	8b 50 08             	mov    0x8(%eax),%edx
c010342e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103431:	01 d0                	add    %edx,%eax
c0103433:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103436:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103439:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010343c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010343f:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103442:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103445:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c010344c:	0f 85 79 ff ff ff    	jne    c01033cb <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103452:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103455:	e8 28 09 00 00       	call   c0103d82 <nr_free_pages>
c010345a:	39 c3                	cmp    %eax,%ebx
c010345c:	74 24                	je     c0103482 <default_check+0xd8>
c010345e:	c7 44 24 0c b6 68 10 	movl   $0xc01068b6,0xc(%esp)
c0103465:	c0 
c0103466:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010346d:	c0 
c010346e:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c0103475:	00 
c0103476:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010347d:	e8 29 d8 ff ff       	call   c0100cab <__panic>

    basic_check();
c0103482:	e8 e7 f9 ff ff       	call   c0102e6e <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103487:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010348e:	e8 85 08 00 00       	call   c0103d18 <alloc_pages>
c0103493:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103496:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010349a:	75 24                	jne    c01034c0 <default_check+0x116>
c010349c:	c7 44 24 0c cf 68 10 	movl   $0xc01068cf,0xc(%esp)
c01034a3:	c0 
c01034a4:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01034ab:	c0 
c01034ac:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c01034b3:	00 
c01034b4:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01034bb:	e8 eb d7 ff ff       	call   c0100cab <__panic>
    assert(!PageProperty(p0));
c01034c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034c3:	83 c0 04             	add    $0x4,%eax
c01034c6:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01034cd:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01034d0:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01034d3:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01034d6:	0f a3 10             	bt     %edx,(%eax)
c01034d9:	19 c0                	sbb    %eax,%eax
c01034db:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c01034de:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c01034e2:	0f 95 c0             	setne  %al
c01034e5:	0f b6 c0             	movzbl %al,%eax
c01034e8:	85 c0                	test   %eax,%eax
c01034ea:	74 24                	je     c0103510 <default_check+0x166>
c01034ec:	c7 44 24 0c da 68 10 	movl   $0xc01068da,0xc(%esp)
c01034f3:	c0 
c01034f4:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01034fb:	c0 
c01034fc:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0103503:	00 
c0103504:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010350b:	e8 9b d7 ff ff       	call   c0100cab <__panic>

    list_entry_t free_list_store = free_list;
c0103510:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c0103515:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c010351b:	89 45 80             	mov    %eax,-0x80(%ebp)
c010351e:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103521:	c7 45 b4 50 89 11 c0 	movl   $0xc0118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103528:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010352b:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010352e:	89 50 04             	mov    %edx,0x4(%eax)
c0103531:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103534:	8b 50 04             	mov    0x4(%eax),%edx
c0103537:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010353a:	89 10                	mov    %edx,(%eax)
c010353c:	c7 45 b0 50 89 11 c0 	movl   $0xc0118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103543:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103546:	8b 40 04             	mov    0x4(%eax),%eax
c0103549:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c010354c:	0f 94 c0             	sete   %al
c010354f:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103552:	85 c0                	test   %eax,%eax
c0103554:	75 24                	jne    c010357a <default_check+0x1d0>
c0103556:	c7 44 24 0c 2f 68 10 	movl   $0xc010682f,0xc(%esp)
c010355d:	c0 
c010355e:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103565:	c0 
c0103566:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c010356d:	00 
c010356e:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103575:	e8 31 d7 ff ff       	call   c0100cab <__panic>
    assert(alloc_page() == NULL);
c010357a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103581:	e8 92 07 00 00       	call   c0103d18 <alloc_pages>
c0103586:	85 c0                	test   %eax,%eax
c0103588:	74 24                	je     c01035ae <default_check+0x204>
c010358a:	c7 44 24 0c 46 68 10 	movl   $0xc0106846,0xc(%esp)
c0103591:	c0 
c0103592:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103599:	c0 
c010359a:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c01035a1:	00 
c01035a2:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01035a9:	e8 fd d6 ff ff       	call   c0100cab <__panic>

    unsigned int nr_free_store = nr_free;
c01035ae:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01035b3:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01035b6:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c01035bd:	00 00 00 

    free_pages(p0 + 2, 3);
c01035c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035c3:	83 c0 28             	add    $0x28,%eax
c01035c6:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01035cd:	00 
c01035ce:	89 04 24             	mov    %eax,(%esp)
c01035d1:	e8 7a 07 00 00       	call   c0103d50 <free_pages>
    assert(alloc_pages(4) == NULL);
c01035d6:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c01035dd:	e8 36 07 00 00       	call   c0103d18 <alloc_pages>
c01035e2:	85 c0                	test   %eax,%eax
c01035e4:	74 24                	je     c010360a <default_check+0x260>
c01035e6:	c7 44 24 0c ec 68 10 	movl   $0xc01068ec,0xc(%esp)
c01035ed:	c0 
c01035ee:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01035f5:	c0 
c01035f6:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c01035fd:	00 
c01035fe:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103605:	e8 a1 d6 ff ff       	call   c0100cab <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010360a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010360d:	83 c0 28             	add    $0x28,%eax
c0103610:	83 c0 04             	add    $0x4,%eax
c0103613:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c010361a:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010361d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103620:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103623:	0f a3 10             	bt     %edx,(%eax)
c0103626:	19 c0                	sbb    %eax,%eax
c0103628:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c010362b:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c010362f:	0f 95 c0             	setne  %al
c0103632:	0f b6 c0             	movzbl %al,%eax
c0103635:	85 c0                	test   %eax,%eax
c0103637:	74 0e                	je     c0103647 <default_check+0x29d>
c0103639:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010363c:	83 c0 28             	add    $0x28,%eax
c010363f:	8b 40 08             	mov    0x8(%eax),%eax
c0103642:	83 f8 03             	cmp    $0x3,%eax
c0103645:	74 24                	je     c010366b <default_check+0x2c1>
c0103647:	c7 44 24 0c 04 69 10 	movl   $0xc0106904,0xc(%esp)
c010364e:	c0 
c010364f:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103656:	c0 
c0103657:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c010365e:	00 
c010365f:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103666:	e8 40 d6 ff ff       	call   c0100cab <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010366b:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103672:	e8 a1 06 00 00       	call   c0103d18 <alloc_pages>
c0103677:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010367a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010367e:	75 24                	jne    c01036a4 <default_check+0x2fa>
c0103680:	c7 44 24 0c 30 69 10 	movl   $0xc0106930,0xc(%esp)
c0103687:	c0 
c0103688:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010368f:	c0 
c0103690:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0103697:	00 
c0103698:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010369f:	e8 07 d6 ff ff       	call   c0100cab <__panic>
    assert(alloc_page() == NULL);
c01036a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01036ab:	e8 68 06 00 00       	call   c0103d18 <alloc_pages>
c01036b0:	85 c0                	test   %eax,%eax
c01036b2:	74 24                	je     c01036d8 <default_check+0x32e>
c01036b4:	c7 44 24 0c 46 68 10 	movl   $0xc0106846,0xc(%esp)
c01036bb:	c0 
c01036bc:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01036c3:	c0 
c01036c4:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c01036cb:	00 
c01036cc:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01036d3:	e8 d3 d5 ff ff       	call   c0100cab <__panic>
    assert(p0 + 2 == p1);
c01036d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036db:	83 c0 28             	add    $0x28,%eax
c01036de:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01036e1:	74 24                	je     c0103707 <default_check+0x35d>
c01036e3:	c7 44 24 0c 4e 69 10 	movl   $0xc010694e,0xc(%esp)
c01036ea:	c0 
c01036eb:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01036f2:	c0 
c01036f3:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c01036fa:	00 
c01036fb:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103702:	e8 a4 d5 ff ff       	call   c0100cab <__panic>

    p2 = p0 + 1;
c0103707:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010370a:	83 c0 14             	add    $0x14,%eax
c010370d:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103710:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103717:	00 
c0103718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010371b:	89 04 24             	mov    %eax,(%esp)
c010371e:	e8 2d 06 00 00       	call   c0103d50 <free_pages>
    free_pages(p1, 3);
c0103723:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010372a:	00 
c010372b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010372e:	89 04 24             	mov    %eax,(%esp)
c0103731:	e8 1a 06 00 00       	call   c0103d50 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c0103736:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103739:	83 c0 04             	add    $0x4,%eax
c010373c:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103743:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103746:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103749:	8b 55 a0             	mov    -0x60(%ebp),%edx
c010374c:	0f a3 10             	bt     %edx,(%eax)
c010374f:	19 c0                	sbb    %eax,%eax
c0103751:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c0103754:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0103758:	0f 95 c0             	setne  %al
c010375b:	0f b6 c0             	movzbl %al,%eax
c010375e:	85 c0                	test   %eax,%eax
c0103760:	74 0b                	je     c010376d <default_check+0x3c3>
c0103762:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103765:	8b 40 08             	mov    0x8(%eax),%eax
c0103768:	83 f8 01             	cmp    $0x1,%eax
c010376b:	74 24                	je     c0103791 <default_check+0x3e7>
c010376d:	c7 44 24 0c 5c 69 10 	movl   $0xc010695c,0xc(%esp)
c0103774:	c0 
c0103775:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c010377c:	c0 
c010377d:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0103784:	00 
c0103785:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c010378c:	e8 1a d5 ff ff       	call   c0100cab <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103791:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103794:	83 c0 04             	add    $0x4,%eax
c0103797:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c010379e:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01037a1:	8b 45 90             	mov    -0x70(%ebp),%eax
c01037a4:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01037a7:	0f a3 10             	bt     %edx,(%eax)
c01037aa:	19 c0                	sbb    %eax,%eax
c01037ac:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c01037af:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01037b3:	0f 95 c0             	setne  %al
c01037b6:	0f b6 c0             	movzbl %al,%eax
c01037b9:	85 c0                	test   %eax,%eax
c01037bb:	74 0b                	je     c01037c8 <default_check+0x41e>
c01037bd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01037c0:	8b 40 08             	mov    0x8(%eax),%eax
c01037c3:	83 f8 03             	cmp    $0x3,%eax
c01037c6:	74 24                	je     c01037ec <default_check+0x442>
c01037c8:	c7 44 24 0c 84 69 10 	movl   $0xc0106984,0xc(%esp)
c01037cf:	c0 
c01037d0:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01037d7:	c0 
c01037d8:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01037df:	00 
c01037e0:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01037e7:	e8 bf d4 ff ff       	call   c0100cab <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01037ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037f3:	e8 20 05 00 00       	call   c0103d18 <alloc_pages>
c01037f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037fe:	83 e8 14             	sub    $0x14,%eax
c0103801:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103804:	74 24                	je     c010382a <default_check+0x480>
c0103806:	c7 44 24 0c aa 69 10 	movl   $0xc01069aa,0xc(%esp)
c010380d:	c0 
c010380e:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103815:	c0 
c0103816:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c010381d:	00 
c010381e:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103825:	e8 81 d4 ff ff       	call   c0100cab <__panic>
    free_page(p0);
c010382a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103831:	00 
c0103832:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103835:	89 04 24             	mov    %eax,(%esp)
c0103838:	e8 13 05 00 00       	call   c0103d50 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c010383d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103844:	e8 cf 04 00 00       	call   c0103d18 <alloc_pages>
c0103849:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010384c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010384f:	83 c0 14             	add    $0x14,%eax
c0103852:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103855:	74 24                	je     c010387b <default_check+0x4d1>
c0103857:	c7 44 24 0c c8 69 10 	movl   $0xc01069c8,0xc(%esp)
c010385e:	c0 
c010385f:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103866:	c0 
c0103867:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c010386e:	00 
c010386f:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103876:	e8 30 d4 ff ff       	call   c0100cab <__panic>

    free_pages(p0, 2);
c010387b:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103882:	00 
c0103883:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103886:	89 04 24             	mov    %eax,(%esp)
c0103889:	e8 c2 04 00 00       	call   c0103d50 <free_pages>
    free_page(p2);
c010388e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103895:	00 
c0103896:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103899:	89 04 24             	mov    %eax,(%esp)
c010389c:	e8 af 04 00 00       	call   c0103d50 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01038a1:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01038a8:	e8 6b 04 00 00       	call   c0103d18 <alloc_pages>
c01038ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01038b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01038b4:	75 24                	jne    c01038da <default_check+0x530>
c01038b6:	c7 44 24 0c e8 69 10 	movl   $0xc01069e8,0xc(%esp)
c01038bd:	c0 
c01038be:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01038c5:	c0 
c01038c6:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c01038cd:	00 
c01038ce:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01038d5:	e8 d1 d3 ff ff       	call   c0100cab <__panic>
    assert(alloc_page() == NULL);
c01038da:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038e1:	e8 32 04 00 00       	call   c0103d18 <alloc_pages>
c01038e6:	85 c0                	test   %eax,%eax
c01038e8:	74 24                	je     c010390e <default_check+0x564>
c01038ea:	c7 44 24 0c 46 68 10 	movl   $0xc0106846,0xc(%esp)
c01038f1:	c0 
c01038f2:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01038f9:	c0 
c01038fa:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0103901:	00 
c0103902:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103909:	e8 9d d3 ff ff       	call   c0100cab <__panic>

    assert(nr_free == 0);
c010390e:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103913:	85 c0                	test   %eax,%eax
c0103915:	74 24                	je     c010393b <default_check+0x591>
c0103917:	c7 44 24 0c 99 68 10 	movl   $0xc0106899,0xc(%esp)
c010391e:	c0 
c010391f:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c0103926:	c0 
c0103927:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c010392e:	00 
c010392f:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c0103936:	e8 70 d3 ff ff       	call   c0100cab <__panic>
    nr_free = nr_free_store;
c010393b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010393e:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_list = free_list_store;
c0103943:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103946:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103949:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c010394e:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    free_pages(p0, 5);
c0103954:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c010395b:	00 
c010395c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010395f:	89 04 24             	mov    %eax,(%esp)
c0103962:	e8 e9 03 00 00       	call   c0103d50 <free_pages>

    le = &free_list;
c0103967:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010396e:	eb 1d                	jmp    c010398d <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103970:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103973:	83 e8 0c             	sub    $0xc,%eax
c0103976:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103979:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c010397d:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103980:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103983:	8b 40 08             	mov    0x8(%eax),%eax
c0103986:	29 c2                	sub    %eax,%edx
c0103988:	89 d0                	mov    %edx,%eax
c010398a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010398d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103990:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103993:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103996:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103999:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010399c:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c01039a3:	75 cb                	jne    c0103970 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01039a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01039a9:	74 24                	je     c01039cf <default_check+0x625>
c01039ab:	c7 44 24 0c 06 6a 10 	movl   $0xc0106a06,0xc(%esp)
c01039b2:	c0 
c01039b3:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01039ba:	c0 
c01039bb:	c7 44 24 04 1b 01 00 	movl   $0x11b,0x4(%esp)
c01039c2:	00 
c01039c3:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01039ca:	e8 dc d2 ff ff       	call   c0100cab <__panic>
    assert(total == 0);
c01039cf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01039d3:	74 24                	je     c01039f9 <default_check+0x64f>
c01039d5:	c7 44 24 0c 11 6a 10 	movl   $0xc0106a11,0xc(%esp)
c01039dc:	c0 
c01039dd:	c7 44 24 08 d6 66 10 	movl   $0xc01066d6,0x8(%esp)
c01039e4:	c0 
c01039e5:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c01039ec:	00 
c01039ed:	c7 04 24 eb 66 10 c0 	movl   $0xc01066eb,(%esp)
c01039f4:	e8 b2 d2 ff ff       	call   c0100cab <__panic>
}
c01039f9:	81 c4 94 00 00 00    	add    $0x94,%esp
c01039ff:	5b                   	pop    %ebx
c0103a00:	5d                   	pop    %ebp
c0103a01:	c3                   	ret    

c0103a02 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103a02:	55                   	push   %ebp
c0103a03:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103a05:	8b 55 08             	mov    0x8(%ebp),%edx
c0103a08:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103a0d:	29 c2                	sub    %eax,%edx
c0103a0f:	89 d0                	mov    %edx,%eax
c0103a11:	c1 f8 02             	sar    $0x2,%eax
c0103a14:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103a1a:	5d                   	pop    %ebp
c0103a1b:	c3                   	ret    

c0103a1c <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103a1c:	55                   	push   %ebp
c0103a1d:	89 e5                	mov    %esp,%ebp
c0103a1f:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103a22:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a25:	89 04 24             	mov    %eax,(%esp)
c0103a28:	e8 d5 ff ff ff       	call   c0103a02 <page2ppn>
c0103a2d:	c1 e0 0c             	shl    $0xc,%eax
}
c0103a30:	c9                   	leave  
c0103a31:	c3                   	ret    

c0103a32 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103a32:	55                   	push   %ebp
c0103a33:	89 e5                	mov    %esp,%ebp
c0103a35:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103a38:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a3b:	c1 e8 0c             	shr    $0xc,%eax
c0103a3e:	89 c2                	mov    %eax,%edx
c0103a40:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103a45:	39 c2                	cmp    %eax,%edx
c0103a47:	72 1c                	jb     c0103a65 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103a49:	c7 44 24 08 4c 6a 10 	movl   $0xc0106a4c,0x8(%esp)
c0103a50:	c0 
c0103a51:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103a58:	00 
c0103a59:	c7 04 24 6b 6a 10 c0 	movl   $0xc0106a6b,(%esp)
c0103a60:	e8 46 d2 ff ff       	call   c0100cab <__panic>
    }
    return &pages[PPN(pa)];
c0103a65:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103a6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a6e:	c1 e8 0c             	shr    $0xc,%eax
c0103a71:	89 c2                	mov    %eax,%edx
c0103a73:	89 d0                	mov    %edx,%eax
c0103a75:	c1 e0 02             	shl    $0x2,%eax
c0103a78:	01 d0                	add    %edx,%eax
c0103a7a:	c1 e0 02             	shl    $0x2,%eax
c0103a7d:	01 c8                	add    %ecx,%eax
}
c0103a7f:	c9                   	leave  
c0103a80:	c3                   	ret    

c0103a81 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103a81:	55                   	push   %ebp
c0103a82:	89 e5                	mov    %esp,%ebp
c0103a84:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103a87:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a8a:	89 04 24             	mov    %eax,(%esp)
c0103a8d:	e8 8a ff ff ff       	call   c0103a1c <page2pa>
c0103a92:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a98:	c1 e8 0c             	shr    $0xc,%eax
c0103a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a9e:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103aa3:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103aa6:	72 23                	jb     c0103acb <page2kva+0x4a>
c0103aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aab:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103aaf:	c7 44 24 08 7c 6a 10 	movl   $0xc0106a7c,0x8(%esp)
c0103ab6:	c0 
c0103ab7:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103abe:	00 
c0103abf:	c7 04 24 6b 6a 10 c0 	movl   $0xc0106a6b,(%esp)
c0103ac6:	e8 e0 d1 ff ff       	call   c0100cab <__panic>
c0103acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ace:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103ad3:	c9                   	leave  
c0103ad4:	c3                   	ret    

c0103ad5 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103ad5:	55                   	push   %ebp
c0103ad6:	89 e5                	mov    %esp,%ebp
c0103ad8:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103adb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ade:	83 e0 01             	and    $0x1,%eax
c0103ae1:	85 c0                	test   %eax,%eax
c0103ae3:	75 1c                	jne    c0103b01 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103ae5:	c7 44 24 08 a0 6a 10 	movl   $0xc0106aa0,0x8(%esp)
c0103aec:	c0 
c0103aed:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103af4:	00 
c0103af5:	c7 04 24 6b 6a 10 c0 	movl   $0xc0106a6b,(%esp)
c0103afc:	e8 aa d1 ff ff       	call   c0100cab <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103b01:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b04:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103b09:	89 04 24             	mov    %eax,(%esp)
c0103b0c:	e8 21 ff ff ff       	call   c0103a32 <pa2page>
}
c0103b11:	c9                   	leave  
c0103b12:	c3                   	ret    

c0103b13 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103b13:	55                   	push   %ebp
c0103b14:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103b16:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b19:	8b 00                	mov    (%eax),%eax
}
c0103b1b:	5d                   	pop    %ebp
c0103b1c:	c3                   	ret    

c0103b1d <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103b1d:	55                   	push   %ebp
c0103b1e:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103b20:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b23:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103b26:	89 10                	mov    %edx,(%eax)
}
c0103b28:	5d                   	pop    %ebp
c0103b29:	c3                   	ret    

c0103b2a <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103b2a:	55                   	push   %ebp
c0103b2b:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103b2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b30:	8b 00                	mov    (%eax),%eax
c0103b32:	8d 50 01             	lea    0x1(%eax),%edx
c0103b35:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b38:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b3d:	8b 00                	mov    (%eax),%eax
}
c0103b3f:	5d                   	pop    %ebp
c0103b40:	c3                   	ret    

c0103b41 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103b41:	55                   	push   %ebp
c0103b42:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103b44:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b47:	8b 00                	mov    (%eax),%eax
c0103b49:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103b4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b4f:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103b51:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b54:	8b 00                	mov    (%eax),%eax
}
c0103b56:	5d                   	pop    %ebp
c0103b57:	c3                   	ret    

c0103b58 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103b58:	55                   	push   %ebp
c0103b59:	89 e5                	mov    %esp,%ebp
c0103b5b:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103b5e:	9c                   	pushf  
c0103b5f:	58                   	pop    %eax
c0103b60:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103b66:	25 00 02 00 00       	and    $0x200,%eax
c0103b6b:	85 c0                	test   %eax,%eax
c0103b6d:	74 0c                	je     c0103b7b <__intr_save+0x23>
        intr_disable();
c0103b6f:	e8 1a db ff ff       	call   c010168e <intr_disable>
        return 1;
c0103b74:	b8 01 00 00 00       	mov    $0x1,%eax
c0103b79:	eb 05                	jmp    c0103b80 <__intr_save+0x28>
    }
    return 0;
c0103b7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103b80:	c9                   	leave  
c0103b81:	c3                   	ret    

c0103b82 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103b82:	55                   	push   %ebp
c0103b83:	89 e5                	mov    %esp,%ebp
c0103b85:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103b88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103b8c:	74 05                	je     c0103b93 <__intr_restore+0x11>
        intr_enable();
c0103b8e:	e8 f5 da ff ff       	call   c0101688 <intr_enable>
    }
}
c0103b93:	c9                   	leave  
c0103b94:	c3                   	ret    

c0103b95 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103b95:	55                   	push   %ebp
c0103b96:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103b98:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b9b:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103b9e:	b8 23 00 00 00       	mov    $0x23,%eax
c0103ba3:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103ba5:	b8 23 00 00 00       	mov    $0x23,%eax
c0103baa:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103bac:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bb1:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103bb3:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bb8:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103bba:	b8 10 00 00 00       	mov    $0x10,%eax
c0103bbf:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103bc1:	ea c8 3b 10 c0 08 00 	ljmp   $0x8,$0xc0103bc8
}
c0103bc8:	5d                   	pop    %ebp
c0103bc9:	c3                   	ret    

c0103bca <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103bca:	55                   	push   %ebp
c0103bcb:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103bcd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103bd0:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103bd5:	5d                   	pop    %ebp
c0103bd6:	c3                   	ret    

c0103bd7 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103bd7:	55                   	push   %ebp
c0103bd8:	89 e5                	mov    %esp,%ebp
c0103bda:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103bdd:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103be2:	89 04 24             	mov    %eax,(%esp)
c0103be5:	e8 e0 ff ff ff       	call   c0103bca <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103bea:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103bf1:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103bf3:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103bfa:	68 00 
c0103bfc:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c01:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103c07:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c0c:	c1 e8 10             	shr    $0x10,%eax
c0103c0f:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103c14:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c1b:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c1e:	83 c8 09             	or     $0x9,%eax
c0103c21:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c26:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c2d:	83 e0 ef             	and    $0xffffffef,%eax
c0103c30:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c35:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c3c:	83 e0 9f             	and    $0xffffff9f,%eax
c0103c3f:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c44:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103c4b:	83 c8 80             	or     $0xffffff80,%eax
c0103c4e:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103c53:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c5a:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c5d:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c62:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c69:	83 e0 ef             	and    $0xffffffef,%eax
c0103c6c:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c71:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c78:	83 e0 df             	and    $0xffffffdf,%eax
c0103c7b:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c80:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c87:	83 c8 40             	or     $0x40,%eax
c0103c8a:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c8f:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c96:	83 e0 7f             	and    $0x7f,%eax
c0103c99:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c9e:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103ca3:	c1 e8 18             	shr    $0x18,%eax
c0103ca6:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103cab:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103cb2:	e8 de fe ff ff       	call   c0103b95 <lgdt>
c0103cb7:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103cbd:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103cc1:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103cc4:	c9                   	leave  
c0103cc5:	c3                   	ret    

c0103cc6 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103cc6:	55                   	push   %ebp
c0103cc7:	89 e5                	mov    %esp,%ebp
c0103cc9:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103ccc:	c7 05 5c 89 11 c0 30 	movl   $0xc0106a30,0xc011895c
c0103cd3:	6a 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103cd6:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103cdb:	8b 00                	mov    (%eax),%eax
c0103cdd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103ce1:	c7 04 24 cc 6a 10 c0 	movl   $0xc0106acc,(%esp)
c0103ce8:	e8 4f c6 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103ced:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103cf2:	8b 40 04             	mov    0x4(%eax),%eax
c0103cf5:	ff d0                	call   *%eax
}
c0103cf7:	c9                   	leave  
c0103cf8:	c3                   	ret    

c0103cf9 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103cf9:	55                   	push   %ebp
c0103cfa:	89 e5                	mov    %esp,%ebp
c0103cfc:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103cff:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d04:	8b 40 08             	mov    0x8(%eax),%eax
c0103d07:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d0a:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d0e:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d11:	89 14 24             	mov    %edx,(%esp)
c0103d14:	ff d0                	call   *%eax
}
c0103d16:	c9                   	leave  
c0103d17:	c3                   	ret    

c0103d18 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103d18:	55                   	push   %ebp
c0103d19:	89 e5                	mov    %esp,%ebp
c0103d1b:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103d1e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d25:	e8 2e fe ff ff       	call   c0103b58 <__intr_save>
c0103d2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103d2d:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d32:	8b 40 0c             	mov    0xc(%eax),%eax
c0103d35:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d38:	89 14 24             	mov    %edx,(%esp)
c0103d3b:	ff d0                	call   *%eax
c0103d3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d43:	89 04 24             	mov    %eax,(%esp)
c0103d46:	e8 37 fe ff ff       	call   c0103b82 <__intr_restore>
    return page;
c0103d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103d4e:	c9                   	leave  
c0103d4f:	c3                   	ret    

c0103d50 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103d50:	55                   	push   %ebp
c0103d51:	89 e5                	mov    %esp,%ebp
c0103d53:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d56:	e8 fd fd ff ff       	call   c0103b58 <__intr_save>
c0103d5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103d5e:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d63:	8b 40 10             	mov    0x10(%eax),%eax
c0103d66:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d69:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d6d:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d70:	89 14 24             	mov    %edx,(%esp)
c0103d73:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d78:	89 04 24             	mov    %eax,(%esp)
c0103d7b:	e8 02 fe ff ff       	call   c0103b82 <__intr_restore>
}
c0103d80:	c9                   	leave  
c0103d81:	c3                   	ret    

c0103d82 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103d82:	55                   	push   %ebp
c0103d83:	89 e5                	mov    %esp,%ebp
c0103d85:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d88:	e8 cb fd ff ff       	call   c0103b58 <__intr_save>
c0103d8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103d90:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d95:	8b 40 14             	mov    0x14(%eax),%eax
c0103d98:	ff d0                	call   *%eax
c0103d9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103da0:	89 04 24             	mov    %eax,(%esp)
c0103da3:	e8 da fd ff ff       	call   c0103b82 <__intr_restore>
    return ret;
c0103da8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103dab:	c9                   	leave  
c0103dac:	c3                   	ret    

c0103dad <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103dad:	55                   	push   %ebp
c0103dae:	89 e5                	mov    %esp,%ebp
c0103db0:	57                   	push   %edi
c0103db1:	56                   	push   %esi
c0103db2:	53                   	push   %ebx
c0103db3:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103db9:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103dc0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103dc7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103dce:	c7 04 24 e3 6a 10 c0 	movl   $0xc0106ae3,(%esp)
c0103dd5:	e8 62 c5 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103dda:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103de1:	e9 15 01 00 00       	jmp    c0103efb <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103de6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103de9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dec:	89 d0                	mov    %edx,%eax
c0103dee:	c1 e0 02             	shl    $0x2,%eax
c0103df1:	01 d0                	add    %edx,%eax
c0103df3:	c1 e0 02             	shl    $0x2,%eax
c0103df6:	01 c8                	add    %ecx,%eax
c0103df8:	8b 50 08             	mov    0x8(%eax),%edx
c0103dfb:	8b 40 04             	mov    0x4(%eax),%eax
c0103dfe:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103e01:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103e04:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e07:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e0a:	89 d0                	mov    %edx,%eax
c0103e0c:	c1 e0 02             	shl    $0x2,%eax
c0103e0f:	01 d0                	add    %edx,%eax
c0103e11:	c1 e0 02             	shl    $0x2,%eax
c0103e14:	01 c8                	add    %ecx,%eax
c0103e16:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e19:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e1c:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e1f:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e22:	01 c8                	add    %ecx,%eax
c0103e24:	11 da                	adc    %ebx,%edx
c0103e26:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103e29:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103e2c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e2f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e32:	89 d0                	mov    %edx,%eax
c0103e34:	c1 e0 02             	shl    $0x2,%eax
c0103e37:	01 d0                	add    %edx,%eax
c0103e39:	c1 e0 02             	shl    $0x2,%eax
c0103e3c:	01 c8                	add    %ecx,%eax
c0103e3e:	83 c0 14             	add    $0x14,%eax
c0103e41:	8b 00                	mov    (%eax),%eax
c0103e43:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103e49:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e4c:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e4f:	83 c0 ff             	add    $0xffffffff,%eax
c0103e52:	83 d2 ff             	adc    $0xffffffff,%edx
c0103e55:	89 c6                	mov    %eax,%esi
c0103e57:	89 d7                	mov    %edx,%edi
c0103e59:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e5f:	89 d0                	mov    %edx,%eax
c0103e61:	c1 e0 02             	shl    $0x2,%eax
c0103e64:	01 d0                	add    %edx,%eax
c0103e66:	c1 e0 02             	shl    $0x2,%eax
c0103e69:	01 c8                	add    %ecx,%eax
c0103e6b:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e6e:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e71:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103e77:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103e7b:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103e7f:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103e83:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e86:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e89:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e8d:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103e91:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103e95:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103e99:	c7 04 24 f0 6a 10 c0 	movl   $0xc0106af0,(%esp)
c0103ea0:	e8 97 c4 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103ea5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103ea8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103eab:	89 d0                	mov    %edx,%eax
c0103ead:	c1 e0 02             	shl    $0x2,%eax
c0103eb0:	01 d0                	add    %edx,%eax
c0103eb2:	c1 e0 02             	shl    $0x2,%eax
c0103eb5:	01 c8                	add    %ecx,%eax
c0103eb7:	83 c0 14             	add    $0x14,%eax
c0103eba:	8b 00                	mov    (%eax),%eax
c0103ebc:	83 f8 01             	cmp    $0x1,%eax
c0103ebf:	75 36                	jne    c0103ef7 <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103ec1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ec4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103ec7:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103eca:	77 2b                	ja     c0103ef7 <page_init+0x14a>
c0103ecc:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103ecf:	72 05                	jb     c0103ed6 <page_init+0x129>
c0103ed1:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103ed4:	73 21                	jae    c0103ef7 <page_init+0x14a>
c0103ed6:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103eda:	77 1b                	ja     c0103ef7 <page_init+0x14a>
c0103edc:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103ee0:	72 09                	jb     c0103eeb <page_init+0x13e>
c0103ee2:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103ee9:	77 0c                	ja     c0103ef7 <page_init+0x14a>
                maxpa = end;
c0103eeb:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103eee:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103ef1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103ef4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103ef7:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103efb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103efe:	8b 00                	mov    (%eax),%eax
c0103f00:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103f03:	0f 8f dd fe ff ff    	jg     c0103de6 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103f09:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f0d:	72 1d                	jb     c0103f2c <page_init+0x17f>
c0103f0f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103f13:	77 09                	ja     c0103f1e <page_init+0x171>
c0103f15:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103f1c:	76 0e                	jbe    c0103f2c <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103f1e:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103f25:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103f2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103f2f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103f32:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103f36:	c1 ea 0c             	shr    $0xc,%edx
c0103f39:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103f3e:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103f45:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0103f4a:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103f4d:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103f50:	01 d0                	add    %edx,%eax
c0103f52:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103f55:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103f58:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f5d:	f7 75 ac             	divl   -0x54(%ebp)
c0103f60:	89 d0                	mov    %edx,%eax
c0103f62:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103f65:	29 c2                	sub    %eax,%edx
c0103f67:	89 d0                	mov    %edx,%eax
c0103f69:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    for (i = 0; i < npage; i ++) {
c0103f6e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f75:	eb 2f                	jmp    c0103fa6 <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103f77:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103f7d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f80:	89 d0                	mov    %edx,%eax
c0103f82:	c1 e0 02             	shl    $0x2,%eax
c0103f85:	01 d0                	add    %edx,%eax
c0103f87:	c1 e0 02             	shl    $0x2,%eax
c0103f8a:	01 c8                	add    %ecx,%eax
c0103f8c:	83 c0 04             	add    $0x4,%eax
c0103f8f:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103f96:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103f99:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103f9c:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103f9f:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103fa2:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103fa6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fa9:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103fae:	39 c2                	cmp    %eax,%edx
c0103fb0:	72 c5                	jb     c0103f77 <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103fb2:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103fb8:	89 d0                	mov    %edx,%eax
c0103fba:	c1 e0 02             	shl    $0x2,%eax
c0103fbd:	01 d0                	add    %edx,%eax
c0103fbf:	c1 e0 02             	shl    $0x2,%eax
c0103fc2:	89 c2                	mov    %eax,%edx
c0103fc4:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103fc9:	01 d0                	add    %edx,%eax
c0103fcb:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103fce:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103fd5:	77 23                	ja     c0103ffa <page_init+0x24d>
c0103fd7:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103fda:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103fde:	c7 44 24 08 20 6b 10 	movl   $0xc0106b20,0x8(%esp)
c0103fe5:	c0 
c0103fe6:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103fed:	00 
c0103fee:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0103ff5:	e8 b1 cc ff ff       	call   c0100cab <__panic>
c0103ffa:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103ffd:	05 00 00 00 40       	add    $0x40000000,%eax
c0104002:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104005:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010400c:	e9 74 01 00 00       	jmp    c0104185 <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104011:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104014:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104017:	89 d0                	mov    %edx,%eax
c0104019:	c1 e0 02             	shl    $0x2,%eax
c010401c:	01 d0                	add    %edx,%eax
c010401e:	c1 e0 02             	shl    $0x2,%eax
c0104021:	01 c8                	add    %ecx,%eax
c0104023:	8b 50 08             	mov    0x8(%eax),%edx
c0104026:	8b 40 04             	mov    0x4(%eax),%eax
c0104029:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010402c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010402f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104032:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104035:	89 d0                	mov    %edx,%eax
c0104037:	c1 e0 02             	shl    $0x2,%eax
c010403a:	01 d0                	add    %edx,%eax
c010403c:	c1 e0 02             	shl    $0x2,%eax
c010403f:	01 c8                	add    %ecx,%eax
c0104041:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104044:	8b 58 10             	mov    0x10(%eax),%ebx
c0104047:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010404a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010404d:	01 c8                	add    %ecx,%eax
c010404f:	11 da                	adc    %ebx,%edx
c0104051:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104054:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104057:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010405a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010405d:	89 d0                	mov    %edx,%eax
c010405f:	c1 e0 02             	shl    $0x2,%eax
c0104062:	01 d0                	add    %edx,%eax
c0104064:	c1 e0 02             	shl    $0x2,%eax
c0104067:	01 c8                	add    %ecx,%eax
c0104069:	83 c0 14             	add    $0x14,%eax
c010406c:	8b 00                	mov    (%eax),%eax
c010406e:	83 f8 01             	cmp    $0x1,%eax
c0104071:	0f 85 0a 01 00 00    	jne    c0104181 <page_init+0x3d4>
            if (begin < freemem) {
c0104077:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010407a:	ba 00 00 00 00       	mov    $0x0,%edx
c010407f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104082:	72 17                	jb     c010409b <page_init+0x2ee>
c0104084:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104087:	77 05                	ja     c010408e <page_init+0x2e1>
c0104089:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010408c:	76 0d                	jbe    c010409b <page_init+0x2ee>
                begin = freemem;
c010408e:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104091:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104094:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c010409b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010409f:	72 1d                	jb     c01040be <page_init+0x311>
c01040a1:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01040a5:	77 09                	ja     c01040b0 <page_init+0x303>
c01040a7:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01040ae:	76 0e                	jbe    c01040be <page_init+0x311>
                end = KMEMSIZE;
c01040b0:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01040b7:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01040be:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040c4:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040c7:	0f 87 b4 00 00 00    	ja     c0104181 <page_init+0x3d4>
c01040cd:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040d0:	72 09                	jb     c01040db <page_init+0x32e>
c01040d2:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01040d5:	0f 83 a6 00 00 00    	jae    c0104181 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c01040db:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01040e2:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01040e5:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01040e8:	01 d0                	add    %edx,%eax
c01040ea:	83 e8 01             	sub    $0x1,%eax
c01040ed:	89 45 98             	mov    %eax,-0x68(%ebp)
c01040f0:	8b 45 98             	mov    -0x68(%ebp),%eax
c01040f3:	ba 00 00 00 00       	mov    $0x0,%edx
c01040f8:	f7 75 9c             	divl   -0x64(%ebp)
c01040fb:	89 d0                	mov    %edx,%eax
c01040fd:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104100:	29 c2                	sub    %eax,%edx
c0104102:	89 d0                	mov    %edx,%eax
c0104104:	ba 00 00 00 00       	mov    $0x0,%edx
c0104109:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010410c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010410f:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104112:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104115:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104118:	ba 00 00 00 00       	mov    $0x0,%edx
c010411d:	89 c7                	mov    %eax,%edi
c010411f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0104125:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0104128:	89 d0                	mov    %edx,%eax
c010412a:	83 e0 00             	and    $0x0,%eax
c010412d:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104130:	8b 45 80             	mov    -0x80(%ebp),%eax
c0104133:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104136:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104139:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c010413c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010413f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104142:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104145:	77 3a                	ja     c0104181 <page_init+0x3d4>
c0104147:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010414a:	72 05                	jb     c0104151 <page_init+0x3a4>
c010414c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010414f:	73 30                	jae    c0104181 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104151:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104154:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104157:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010415a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010415d:	29 c8                	sub    %ecx,%eax
c010415f:	19 da                	sbb    %ebx,%edx
c0104161:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104165:	c1 ea 0c             	shr    $0xc,%edx
c0104168:	89 c3                	mov    %eax,%ebx
c010416a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010416d:	89 04 24             	mov    %eax,(%esp)
c0104170:	e8 bd f8 ff ff       	call   c0103a32 <pa2page>
c0104175:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104179:	89 04 24             	mov    %eax,(%esp)
c010417c:	e8 78 fb ff ff       	call   c0103cf9 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104181:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104185:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104188:	8b 00                	mov    (%eax),%eax
c010418a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010418d:	0f 8f 7e fe ff ff    	jg     c0104011 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104193:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104199:	5b                   	pop    %ebx
c010419a:	5e                   	pop    %esi
c010419b:	5f                   	pop    %edi
c010419c:	5d                   	pop    %ebp
c010419d:	c3                   	ret    

c010419e <enable_paging>:

static void
enable_paging(void) {
c010419e:	55                   	push   %ebp
c010419f:	89 e5                	mov    %esp,%ebp
c01041a1:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01041a4:	a1 60 89 11 c0       	mov    0xc0118960,%eax
c01041a9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01041ac:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01041af:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01041b2:	0f 20 c0             	mov    %cr0,%eax
c01041b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c01041b8:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c01041bb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c01041be:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c01041c5:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c01041c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01041cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01041cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041d2:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01041d5:	c9                   	leave  
c01041d6:	c3                   	ret    

c01041d7 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01041d7:	55                   	push   %ebp
c01041d8:	89 e5                	mov    %esp,%ebp
c01041da:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01041dd:	8b 45 14             	mov    0x14(%ebp),%eax
c01041e0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01041e3:	31 d0                	xor    %edx,%eax
c01041e5:	25 ff 0f 00 00       	and    $0xfff,%eax
c01041ea:	85 c0                	test   %eax,%eax
c01041ec:	74 24                	je     c0104212 <boot_map_segment+0x3b>
c01041ee:	c7 44 24 0c 52 6b 10 	movl   $0xc0106b52,0xc(%esp)
c01041f5:	c0 
c01041f6:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c01041fd:	c0 
c01041fe:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0104205:	00 
c0104206:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c010420d:	e8 99 ca ff ff       	call   c0100cab <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104212:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104219:	8b 45 0c             	mov    0xc(%ebp),%eax
c010421c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104221:	89 c2                	mov    %eax,%edx
c0104223:	8b 45 10             	mov    0x10(%ebp),%eax
c0104226:	01 c2                	add    %eax,%edx
c0104228:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010422b:	01 d0                	add    %edx,%eax
c010422d:	83 e8 01             	sub    $0x1,%eax
c0104230:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104233:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104236:	ba 00 00 00 00       	mov    $0x0,%edx
c010423b:	f7 75 f0             	divl   -0x10(%ebp)
c010423e:	89 d0                	mov    %edx,%eax
c0104240:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104243:	29 c2                	sub    %eax,%edx
c0104245:	89 d0                	mov    %edx,%eax
c0104247:	c1 e8 0c             	shr    $0xc,%eax
c010424a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010424d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104250:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104253:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104256:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010425b:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010425e:	8b 45 14             	mov    0x14(%ebp),%eax
c0104261:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104264:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104267:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010426c:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010426f:	eb 6b                	jmp    c01042dc <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104271:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104278:	00 
c0104279:	8b 45 0c             	mov    0xc(%ebp),%eax
c010427c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104280:	8b 45 08             	mov    0x8(%ebp),%eax
c0104283:	89 04 24             	mov    %eax,(%esp)
c0104286:	e8 cc 01 00 00       	call   c0104457 <get_pte>
c010428b:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010428e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104292:	75 24                	jne    c01042b8 <boot_map_segment+0xe1>
c0104294:	c7 44 24 0c 7e 6b 10 	movl   $0xc0106b7e,0xc(%esp)
c010429b:	c0 
c010429c:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c01042a3:	c0 
c01042a4:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01042ab:	00 
c01042ac:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c01042b3:	e8 f3 c9 ff ff       	call   c0100cab <__panic>
        *ptep = pa | PTE_P | perm;
c01042b8:	8b 45 18             	mov    0x18(%ebp),%eax
c01042bb:	8b 55 14             	mov    0x14(%ebp),%edx
c01042be:	09 d0                	or     %edx,%eax
c01042c0:	83 c8 01             	or     $0x1,%eax
c01042c3:	89 c2                	mov    %eax,%edx
c01042c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01042c8:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01042ca:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01042ce:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01042d5:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01042dc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042e0:	75 8f                	jne    c0104271 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01042e2:	c9                   	leave  
c01042e3:	c3                   	ret    

c01042e4 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01042e4:	55                   	push   %ebp
c01042e5:	89 e5                	mov    %esp,%ebp
c01042e7:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01042ea:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01042f1:	e8 22 fa ff ff       	call   c0103d18 <alloc_pages>
c01042f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01042f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042fd:	75 1c                	jne    c010431b <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01042ff:	c7 44 24 08 8b 6b 10 	movl   $0xc0106b8b,0x8(%esp)
c0104306:	c0 
c0104307:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c010430e:	00 
c010430f:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104316:	e8 90 c9 ff ff       	call   c0100cab <__panic>
    }
    return page2kva(p);
c010431b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010431e:	89 04 24             	mov    %eax,(%esp)
c0104321:	e8 5b f7 ff ff       	call   c0103a81 <page2kva>
}
c0104326:	c9                   	leave  
c0104327:	c3                   	ret    

c0104328 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104328:	55                   	push   %ebp
c0104329:	89 e5                	mov    %esp,%ebp
c010432b:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010432e:	e8 93 f9 ff ff       	call   c0103cc6 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104333:	e8 75 fa ff ff       	call   c0103dad <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104338:	e8 66 04 00 00       	call   c01047a3 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c010433d:	e8 a2 ff ff ff       	call   c01042e4 <boot_alloc_page>
c0104342:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c0104347:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010434c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104353:	00 
c0104354:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010435b:	00 
c010435c:	89 04 24             	mov    %eax,(%esp)
c010435f:	e8 a8 1a 00 00       	call   c0105e0c <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0104364:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104369:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010436c:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104373:	77 23                	ja     c0104398 <pmm_init+0x70>
c0104375:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104378:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010437c:	c7 44 24 08 20 6b 10 	movl   $0xc0106b20,0x8(%esp)
c0104383:	c0 
c0104384:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c010438b:	00 
c010438c:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104393:	e8 13 c9 ff ff       	call   c0100cab <__panic>
c0104398:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010439b:	05 00 00 00 40       	add    $0x40000000,%eax
c01043a0:	a3 60 89 11 c0       	mov    %eax,0xc0118960

    check_pgdir();
c01043a5:	e8 17 04 00 00       	call   c01047c1 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01043aa:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043af:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c01043b5:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043bd:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c01043c4:	77 23                	ja     c01043e9 <pmm_init+0xc1>
c01043c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043c9:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01043cd:	c7 44 24 08 20 6b 10 	movl   $0xc0106b20,0x8(%esp)
c01043d4:	c0 
c01043d5:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c01043dc:	00 
c01043dd:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c01043e4:	e8 c2 c8 ff ff       	call   c0100cab <__panic>
c01043e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01043ec:	05 00 00 00 40       	add    $0x40000000,%eax
c01043f1:	83 c8 03             	or     $0x3,%eax
c01043f4:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01043f6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043fb:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104402:	00 
c0104403:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010440a:	00 
c010440b:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104412:	38 
c0104413:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c010441a:	c0 
c010441b:	89 04 24             	mov    %eax,(%esp)
c010441e:	e8 b4 fd ff ff       	call   c01041d7 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0104423:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104428:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c010442e:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0104434:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0104436:	e8 63 fd ff ff       	call   c010419e <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010443b:	e8 97 f7 ff ff       	call   c0103bd7 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104440:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104445:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010444b:	e8 0c 0a 00 00       	call   c0104e5c <check_boot_pgdir>

    print_pgdir();
c0104450:	e8 99 0e 00 00       	call   c01052ee <print_pgdir>

}
c0104455:	c9                   	leave  
c0104456:	c3                   	ret    

c0104457 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104457:	55                   	push   %ebp
c0104458:	89 e5                	mov    %esp,%ebp
c010445a:	83 ec 38             	sub    $0x38,%esp
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    //首先从la中取出页目录项编号，再在页目录中取出相应的页目录项
    pde_t *pdep = &pgdir[PDX(la)];
c010445d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104460:	c1 e8 16             	shr    $0x16,%eax
c0104463:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010446a:	8b 45 08             	mov    0x8(%ebp),%eax
c010446d:	01 d0                	add    %edx,%eax
c010446f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
c0104472:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104475:	8b 00                	mov    (%eax),%eax
c0104477:	83 e0 01             	and    $0x1,%eax
c010447a:	85 c0                	test   %eax,%eax
c010447c:	0f 85 af 00 00 00    	jne    c0104531 <get_pte+0xda>
        //若该pde中的标记位显示对应的pt不存在，则为此pde分配一个页，对此页引用+1,然后初始化pt,修改pde中的标记
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
c0104482:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104486:	74 15                	je     c010449d <get_pte+0x46>
c0104488:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010448f:	e8 84 f8 ff ff       	call   c0103d18 <alloc_pages>
c0104494:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104497:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010449b:	75 0a                	jne    c01044a7 <get_pte+0x50>
            return NULL;
c010449d:	b8 00 00 00 00       	mov    $0x0,%eax
c01044a2:	e9 e6 00 00 00       	jmp    c010458d <get_pte+0x136>
        }
        set_page_ref(page, 1);
c01044a7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01044ae:	00 
c01044af:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044b2:	89 04 24             	mov    %eax,(%esp)
c01044b5:	e8 63 f6 ff ff       	call   c0103b1d <set_page_ref>
        uintptr_t pa = page2pa(page);
c01044ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01044bd:	89 04 24             	mov    %eax,(%esp)
c01044c0:	e8 57 f5 ff ff       	call   c0103a1c <page2pa>
c01044c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
c01044c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044cb:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01044ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044d1:	c1 e8 0c             	shr    $0xc,%eax
c01044d4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01044d7:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01044dc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01044df:	72 23                	jb     c0104504 <get_pte+0xad>
c01044e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044e4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01044e8:	c7 44 24 08 7c 6a 10 	movl   $0xc0106a7c,0x8(%esp)
c01044ef:	c0 
c01044f0:	c7 44 24 04 89 01 00 	movl   $0x189,0x4(%esp)
c01044f7:	00 
c01044f8:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c01044ff:	e8 a7 c7 ff ff       	call   c0100cab <__panic>
c0104504:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104507:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010450c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104513:	00 
c0104514:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010451b:	00 
c010451c:	89 04 24             	mov    %eax,(%esp)
c010451f:	e8 e8 18 00 00       	call   c0105e0c <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
c0104524:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104527:	83 c8 07             	or     $0x7,%eax
c010452a:	89 c2                	mov    %eax,%edx
c010452c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010452f:	89 10                	mov    %edx,(%eax)
    }
    //若该目录项显示对应的页表存在，则从此页表中利用la中的页表项号取出所需的页表项
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0104531:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104534:	8b 00                	mov    (%eax),%eax
c0104536:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010453b:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010453e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104541:	c1 e8 0c             	shr    $0xc,%eax
c0104544:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104547:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c010454c:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010454f:	72 23                	jb     c0104574 <get_pte+0x11d>
c0104551:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104554:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104558:	c7 44 24 08 7c 6a 10 	movl   $0xc0106a7c,0x8(%esp)
c010455f:	c0 
c0104560:	c7 44 24 04 8d 01 00 	movl   $0x18d,0x4(%esp)
c0104567:	00 
c0104568:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c010456f:	e8 37 c7 ff ff       	call   c0100cab <__panic>
c0104574:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104577:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010457c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010457f:	c1 ea 0c             	shr    $0xc,%edx
c0104582:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0104588:	c1 e2 02             	shl    $0x2,%edx
c010458b:	01 d0                	add    %edx,%eax
}
c010458d:	c9                   	leave  
c010458e:	c3                   	ret    

c010458f <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010458f:	55                   	push   %ebp
c0104590:	89 e5                	mov    %esp,%ebp
c0104592:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104595:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010459c:	00 
c010459d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01045a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01045a7:	89 04 24             	mov    %eax,(%esp)
c01045aa:	e8 a8 fe ff ff       	call   c0104457 <get_pte>
c01045af:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c01045b2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01045b6:	74 08                	je     c01045c0 <get_page+0x31>
        *ptep_store = ptep;
c01045b8:	8b 45 10             	mov    0x10(%ebp),%eax
c01045bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01045be:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01045c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01045c4:	74 1b                	je     c01045e1 <get_page+0x52>
c01045c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045c9:	8b 00                	mov    (%eax),%eax
c01045cb:	83 e0 01             	and    $0x1,%eax
c01045ce:	85 c0                	test   %eax,%eax
c01045d0:	74 0f                	je     c01045e1 <get_page+0x52>
        return pa2page(*ptep);
c01045d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045d5:	8b 00                	mov    (%eax),%eax
c01045d7:	89 04 24             	mov    %eax,(%esp)
c01045da:	e8 53 f4 ff ff       	call   c0103a32 <pa2page>
c01045df:	eb 05                	jmp    c01045e6 <get_page+0x57>
    }
    return NULL;
c01045e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01045e6:	c9                   	leave  
c01045e7:	c3                   	ret    

c01045e8 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01045e8:	55                   	push   %ebp
c01045e9:	89 e5                	mov    %esp,%ebp
c01045eb:	83 ec 28             	sub    $0x28,%esp
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    //首先检查此pte对应的页是否存在，若不存在则什么也不干
    if (*ptep & PTE_P) {
c01045ee:	8b 45 10             	mov    0x10(%ebp),%eax
c01045f1:	8b 00                	mov    (%eax),%eax
c01045f3:	83 e0 01             	and    $0x1,%eax
c01045f6:	85 c0                	test   %eax,%eax
c01045f8:	74 4d                	je     c0104647 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
c01045fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01045fd:	8b 00                	mov    (%eax),%eax
c01045ff:	89 04 24             	mov    %eax,(%esp)
c0104602:	e8 ce f4 ff ff       	call   c0103ad5 <pte2page>
c0104607:	89 45 f4             	mov    %eax,-0xc(%ebp)
        //则此页的引用减1,若此页的引用为0则回收此页
        if (page_ref_dec(page) == 0) {
c010460a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010460d:	89 04 24             	mov    %eax,(%esp)
c0104610:	e8 2c f5 ff ff       	call   c0103b41 <page_ref_dec>
c0104615:	85 c0                	test   %eax,%eax
c0104617:	75 13                	jne    c010462c <page_remove_pte+0x44>
            free_page(page);
c0104619:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104620:	00 
c0104621:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104624:	89 04 24             	mov    %eax,(%esp)
c0104627:	e8 24 f7 ff ff       	call   c0103d50 <free_pages>
        }
        //更新此pte，并刷新tlb
        *ptep = 0;
c010462c:	8b 45 10             	mov    0x10(%ebp),%eax
c010462f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0104635:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104638:	89 44 24 04          	mov    %eax,0x4(%esp)
c010463c:	8b 45 08             	mov    0x8(%ebp),%eax
c010463f:	89 04 24             	mov    %eax,(%esp)
c0104642:	e8 ff 00 00 00       	call   c0104746 <tlb_invalidate>
    }
}
c0104647:	c9                   	leave  
c0104648:	c3                   	ret    

c0104649 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104649:	55                   	push   %ebp
c010464a:	89 e5                	mov    %esp,%ebp
c010464c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010464f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104656:	00 
c0104657:	8b 45 0c             	mov    0xc(%ebp),%eax
c010465a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010465e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104661:	89 04 24             	mov    %eax,(%esp)
c0104664:	e8 ee fd ff ff       	call   c0104457 <get_pte>
c0104669:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c010466c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104670:	74 19                	je     c010468b <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0104672:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104675:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104679:	8b 45 0c             	mov    0xc(%ebp),%eax
c010467c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104680:	8b 45 08             	mov    0x8(%ebp),%eax
c0104683:	89 04 24             	mov    %eax,(%esp)
c0104686:	e8 5d ff ff ff       	call   c01045e8 <page_remove_pte>
    }
}
c010468b:	c9                   	leave  
c010468c:	c3                   	ret    

c010468d <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010468d:	55                   	push   %ebp
c010468e:	89 e5                	mov    %esp,%ebp
c0104690:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104693:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010469a:	00 
c010469b:	8b 45 10             	mov    0x10(%ebp),%eax
c010469e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01046a5:	89 04 24             	mov    %eax,(%esp)
c01046a8:	e8 aa fd ff ff       	call   c0104457 <get_pte>
c01046ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01046b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046b4:	75 0a                	jne    c01046c0 <page_insert+0x33>
        return -E_NO_MEM;
c01046b6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01046bb:	e9 84 00 00 00       	jmp    c0104744 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01046c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046c3:	89 04 24             	mov    %eax,(%esp)
c01046c6:	e8 5f f4 ff ff       	call   c0103b2a <page_ref_inc>
    if (*ptep & PTE_P) {
c01046cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046ce:	8b 00                	mov    (%eax),%eax
c01046d0:	83 e0 01             	and    $0x1,%eax
c01046d3:	85 c0                	test   %eax,%eax
c01046d5:	74 3e                	je     c0104715 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01046d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046da:	8b 00                	mov    (%eax),%eax
c01046dc:	89 04 24             	mov    %eax,(%esp)
c01046df:	e8 f1 f3 ff ff       	call   c0103ad5 <pte2page>
c01046e4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01046e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01046ed:	75 0d                	jne    c01046fc <page_insert+0x6f>
            page_ref_dec(page);
c01046ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046f2:	89 04 24             	mov    %eax,(%esp)
c01046f5:	e8 47 f4 ff ff       	call   c0103b41 <page_ref_dec>
c01046fa:	eb 19                	jmp    c0104715 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01046fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046ff:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104703:	8b 45 10             	mov    0x10(%ebp),%eax
c0104706:	89 44 24 04          	mov    %eax,0x4(%esp)
c010470a:	8b 45 08             	mov    0x8(%ebp),%eax
c010470d:	89 04 24             	mov    %eax,(%esp)
c0104710:	e8 d3 fe ff ff       	call   c01045e8 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0104715:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104718:	89 04 24             	mov    %eax,(%esp)
c010471b:	e8 fc f2 ff ff       	call   c0103a1c <page2pa>
c0104720:	0b 45 14             	or     0x14(%ebp),%eax
c0104723:	83 c8 01             	or     $0x1,%eax
c0104726:	89 c2                	mov    %eax,%edx
c0104728:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010472b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010472d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104730:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104734:	8b 45 08             	mov    0x8(%ebp),%eax
c0104737:	89 04 24             	mov    %eax,(%esp)
c010473a:	e8 07 00 00 00       	call   c0104746 <tlb_invalidate>
    return 0;
c010473f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104744:	c9                   	leave  
c0104745:	c3                   	ret    

c0104746 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104746:	55                   	push   %ebp
c0104747:	89 e5                	mov    %esp,%ebp
c0104749:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010474c:	0f 20 d8             	mov    %cr3,%eax
c010474f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0104752:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0104755:	89 c2                	mov    %eax,%edx
c0104757:	8b 45 08             	mov    0x8(%ebp),%eax
c010475a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010475d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104764:	77 23                	ja     c0104789 <tlb_invalidate+0x43>
c0104766:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104769:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010476d:	c7 44 24 08 20 6b 10 	movl   $0xc0106b20,0x8(%esp)
c0104774:	c0 
c0104775:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c010477c:	00 
c010477d:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104784:	e8 22 c5 ff ff       	call   c0100cab <__panic>
c0104789:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010478c:	05 00 00 00 40       	add    $0x40000000,%eax
c0104791:	39 c2                	cmp    %eax,%edx
c0104793:	75 0c                	jne    c01047a1 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0104795:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104798:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010479b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010479e:	0f 01 38             	invlpg (%eax)
    }
}
c01047a1:	c9                   	leave  
c01047a2:	c3                   	ret    

c01047a3 <check_alloc_page>:

static void
check_alloc_page(void) {
c01047a3:	55                   	push   %ebp
c01047a4:	89 e5                	mov    %esp,%ebp
c01047a6:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01047a9:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c01047ae:	8b 40 18             	mov    0x18(%eax),%eax
c01047b1:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01047b3:	c7 04 24 a4 6b 10 c0 	movl   $0xc0106ba4,(%esp)
c01047ba:	e8 7d bb ff ff       	call   c010033c <cprintf>
}
c01047bf:	c9                   	leave  
c01047c0:	c3                   	ret    

c01047c1 <check_pgdir>:

static void
check_pgdir(void) {
c01047c1:	55                   	push   %ebp
c01047c2:	89 e5                	mov    %esp,%ebp
c01047c4:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01047c7:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01047cc:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01047d1:	76 24                	jbe    c01047f7 <check_pgdir+0x36>
c01047d3:	c7 44 24 0c c3 6b 10 	movl   $0xc0106bc3,0xc(%esp)
c01047da:	c0 
c01047db:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c01047e2:	c0 
c01047e3:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c01047ea:	00 
c01047eb:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c01047f2:	e8 b4 c4 ff ff       	call   c0100cab <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01047f7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047fc:	85 c0                	test   %eax,%eax
c01047fe:	74 0e                	je     c010480e <check_pgdir+0x4d>
c0104800:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104805:	25 ff 0f 00 00       	and    $0xfff,%eax
c010480a:	85 c0                	test   %eax,%eax
c010480c:	74 24                	je     c0104832 <check_pgdir+0x71>
c010480e:	c7 44 24 0c e0 6b 10 	movl   $0xc0106be0,0xc(%esp)
c0104815:	c0 
c0104816:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c010481d:	c0 
c010481e:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0104825:	00 
c0104826:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c010482d:	e8 79 c4 ff ff       	call   c0100cab <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104832:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104837:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010483e:	00 
c010483f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104846:	00 
c0104847:	89 04 24             	mov    %eax,(%esp)
c010484a:	e8 40 fd ff ff       	call   c010458f <get_page>
c010484f:	85 c0                	test   %eax,%eax
c0104851:	74 24                	je     c0104877 <check_pgdir+0xb6>
c0104853:	c7 44 24 0c 18 6c 10 	movl   $0xc0106c18,0xc(%esp)
c010485a:	c0 
c010485b:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104862:	c0 
c0104863:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c010486a:	00 
c010486b:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104872:	e8 34 c4 ff ff       	call   c0100cab <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104877:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010487e:	e8 95 f4 ff ff       	call   c0103d18 <alloc_pages>
c0104883:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104886:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010488b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104892:	00 
c0104893:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010489a:	00 
c010489b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010489e:	89 54 24 04          	mov    %edx,0x4(%esp)
c01048a2:	89 04 24             	mov    %eax,(%esp)
c01048a5:	e8 e3 fd ff ff       	call   c010468d <page_insert>
c01048aa:	85 c0                	test   %eax,%eax
c01048ac:	74 24                	je     c01048d2 <check_pgdir+0x111>
c01048ae:	c7 44 24 0c 40 6c 10 	movl   $0xc0106c40,0xc(%esp)
c01048b5:	c0 
c01048b6:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c01048bd:	c0 
c01048be:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c01048c5:	00 
c01048c6:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c01048cd:	e8 d9 c3 ff ff       	call   c0100cab <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01048d2:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01048d7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048de:	00 
c01048df:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01048e6:	00 
c01048e7:	89 04 24             	mov    %eax,(%esp)
c01048ea:	e8 68 fb ff ff       	call   c0104457 <get_pte>
c01048ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01048f6:	75 24                	jne    c010491c <check_pgdir+0x15b>
c01048f8:	c7 44 24 0c 6c 6c 10 	movl   $0xc0106c6c,0xc(%esp)
c01048ff:	c0 
c0104900:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104907:	c0 
c0104908:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
c010490f:	00 
c0104910:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104917:	e8 8f c3 ff ff       	call   c0100cab <__panic>
    assert(pa2page(*ptep) == p1);
c010491c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010491f:	8b 00                	mov    (%eax),%eax
c0104921:	89 04 24             	mov    %eax,(%esp)
c0104924:	e8 09 f1 ff ff       	call   c0103a32 <pa2page>
c0104929:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010492c:	74 24                	je     c0104952 <check_pgdir+0x191>
c010492e:	c7 44 24 0c 99 6c 10 	movl   $0xc0106c99,0xc(%esp)
c0104935:	c0 
c0104936:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c010493d:	c0 
c010493e:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c0104945:	00 
c0104946:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c010494d:	e8 59 c3 ff ff       	call   c0100cab <__panic>
    assert(page_ref(p1) == 1);
c0104952:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104955:	89 04 24             	mov    %eax,(%esp)
c0104958:	e8 b6 f1 ff ff       	call   c0103b13 <page_ref>
c010495d:	83 f8 01             	cmp    $0x1,%eax
c0104960:	74 24                	je     c0104986 <check_pgdir+0x1c5>
c0104962:	c7 44 24 0c ae 6c 10 	movl   $0xc0106cae,0xc(%esp)
c0104969:	c0 
c010496a:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104971:	c0 
c0104972:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104979:	00 
c010497a:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104981:	e8 25 c3 ff ff       	call   c0100cab <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104986:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010498b:	8b 00                	mov    (%eax),%eax
c010498d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104992:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104995:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104998:	c1 e8 0c             	shr    $0xc,%eax
c010499b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010499e:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01049a3:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01049a6:	72 23                	jb     c01049cb <check_pgdir+0x20a>
c01049a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01049af:	c7 44 24 08 7c 6a 10 	movl   $0xc0106a7c,0x8(%esp)
c01049b6:	c0 
c01049b7:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c01049be:	00 
c01049bf:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c01049c6:	e8 e0 c2 ff ff       	call   c0100cab <__panic>
c01049cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01049ce:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01049d3:	83 c0 04             	add    $0x4,%eax
c01049d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01049d9:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01049de:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049e5:	00 
c01049e6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01049ed:	00 
c01049ee:	89 04 24             	mov    %eax,(%esp)
c01049f1:	e8 61 fa ff ff       	call   c0104457 <get_pte>
c01049f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01049f9:	74 24                	je     c0104a1f <check_pgdir+0x25e>
c01049fb:	c7 44 24 0c c0 6c 10 	movl   $0xc0106cc0,0xc(%esp)
c0104a02:	c0 
c0104a03:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104a0a:	c0 
c0104a0b:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104a12:	00 
c0104a13:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104a1a:	e8 8c c2 ff ff       	call   c0100cab <__panic>

    p2 = alloc_page();
c0104a1f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a26:	e8 ed f2 ff ff       	call   c0103d18 <alloc_pages>
c0104a2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104a2e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a33:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104a3a:	00 
c0104a3b:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104a42:	00 
c0104a43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104a46:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a4a:	89 04 24             	mov    %eax,(%esp)
c0104a4d:	e8 3b fc ff ff       	call   c010468d <page_insert>
c0104a52:	85 c0                	test   %eax,%eax
c0104a54:	74 24                	je     c0104a7a <check_pgdir+0x2b9>
c0104a56:	c7 44 24 0c e8 6c 10 	movl   $0xc0106ce8,0xc(%esp)
c0104a5d:	c0 
c0104a5e:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104a65:	c0 
c0104a66:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0104a6d:	00 
c0104a6e:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104a75:	e8 31 c2 ff ff       	call   c0100cab <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104a7a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a7f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a86:	00 
c0104a87:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a8e:	00 
c0104a8f:	89 04 24             	mov    %eax,(%esp)
c0104a92:	e8 c0 f9 ff ff       	call   c0104457 <get_pte>
c0104a97:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a9a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a9e:	75 24                	jne    c0104ac4 <check_pgdir+0x303>
c0104aa0:	c7 44 24 0c 20 6d 10 	movl   $0xc0106d20,0xc(%esp)
c0104aa7:	c0 
c0104aa8:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104aaf:	c0 
c0104ab0:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104ab7:	00 
c0104ab8:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104abf:	e8 e7 c1 ff ff       	call   c0100cab <__panic>
    assert(*ptep & PTE_U);
c0104ac4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ac7:	8b 00                	mov    (%eax),%eax
c0104ac9:	83 e0 04             	and    $0x4,%eax
c0104acc:	85 c0                	test   %eax,%eax
c0104ace:	75 24                	jne    c0104af4 <check_pgdir+0x333>
c0104ad0:	c7 44 24 0c 50 6d 10 	movl   $0xc0106d50,0xc(%esp)
c0104ad7:	c0 
c0104ad8:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104adf:	c0 
c0104ae0:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104ae7:	00 
c0104ae8:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104aef:	e8 b7 c1 ff ff       	call   c0100cab <__panic>
    assert(*ptep & PTE_W);
c0104af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104af7:	8b 00                	mov    (%eax),%eax
c0104af9:	83 e0 02             	and    $0x2,%eax
c0104afc:	85 c0                	test   %eax,%eax
c0104afe:	75 24                	jne    c0104b24 <check_pgdir+0x363>
c0104b00:	c7 44 24 0c 5e 6d 10 	movl   $0xc0106d5e,0xc(%esp)
c0104b07:	c0 
c0104b08:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104b0f:	c0 
c0104b10:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104b17:	00 
c0104b18:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104b1f:	e8 87 c1 ff ff       	call   c0100cab <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104b24:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b29:	8b 00                	mov    (%eax),%eax
c0104b2b:	83 e0 04             	and    $0x4,%eax
c0104b2e:	85 c0                	test   %eax,%eax
c0104b30:	75 24                	jne    c0104b56 <check_pgdir+0x395>
c0104b32:	c7 44 24 0c 6c 6d 10 	movl   $0xc0106d6c,0xc(%esp)
c0104b39:	c0 
c0104b3a:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104b41:	c0 
c0104b42:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104b49:	00 
c0104b4a:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104b51:	e8 55 c1 ff ff       	call   c0100cab <__panic>
    assert(page_ref(p2) == 1);
c0104b56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b59:	89 04 24             	mov    %eax,(%esp)
c0104b5c:	e8 b2 ef ff ff       	call   c0103b13 <page_ref>
c0104b61:	83 f8 01             	cmp    $0x1,%eax
c0104b64:	74 24                	je     c0104b8a <check_pgdir+0x3c9>
c0104b66:	c7 44 24 0c 82 6d 10 	movl   $0xc0106d82,0xc(%esp)
c0104b6d:	c0 
c0104b6e:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104b75:	c0 
c0104b76:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0104b7d:	00 
c0104b7e:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104b85:	e8 21 c1 ff ff       	call   c0100cab <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104b8a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b8f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104b96:	00 
c0104b97:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104b9e:	00 
c0104b9f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104ba2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ba6:	89 04 24             	mov    %eax,(%esp)
c0104ba9:	e8 df fa ff ff       	call   c010468d <page_insert>
c0104bae:	85 c0                	test   %eax,%eax
c0104bb0:	74 24                	je     c0104bd6 <check_pgdir+0x415>
c0104bb2:	c7 44 24 0c 94 6d 10 	movl   $0xc0106d94,0xc(%esp)
c0104bb9:	c0 
c0104bba:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104bc1:	c0 
c0104bc2:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
c0104bc9:	00 
c0104bca:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104bd1:	e8 d5 c0 ff ff       	call   c0100cab <__panic>
    assert(page_ref(p1) == 2);
c0104bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bd9:	89 04 24             	mov    %eax,(%esp)
c0104bdc:	e8 32 ef ff ff       	call   c0103b13 <page_ref>
c0104be1:	83 f8 02             	cmp    $0x2,%eax
c0104be4:	74 24                	je     c0104c0a <check_pgdir+0x449>
c0104be6:	c7 44 24 0c c0 6d 10 	movl   $0xc0106dc0,0xc(%esp)
c0104bed:	c0 
c0104bee:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104bf5:	c0 
c0104bf6:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104bfd:	00 
c0104bfe:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104c05:	e8 a1 c0 ff ff       	call   c0100cab <__panic>
    assert(page_ref(p2) == 0);
c0104c0a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c0d:	89 04 24             	mov    %eax,(%esp)
c0104c10:	e8 fe ee ff ff       	call   c0103b13 <page_ref>
c0104c15:	85 c0                	test   %eax,%eax
c0104c17:	74 24                	je     c0104c3d <check_pgdir+0x47c>
c0104c19:	c7 44 24 0c d2 6d 10 	movl   $0xc0106dd2,0xc(%esp)
c0104c20:	c0 
c0104c21:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104c28:	c0 
c0104c29:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104c30:	00 
c0104c31:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104c38:	e8 6e c0 ff ff       	call   c0100cab <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104c3d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c42:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c49:	00 
c0104c4a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c51:	00 
c0104c52:	89 04 24             	mov    %eax,(%esp)
c0104c55:	e8 fd f7 ff ff       	call   c0104457 <get_pte>
c0104c5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c5d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c61:	75 24                	jne    c0104c87 <check_pgdir+0x4c6>
c0104c63:	c7 44 24 0c 20 6d 10 	movl   $0xc0106d20,0xc(%esp)
c0104c6a:	c0 
c0104c6b:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104c72:	c0 
c0104c73:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0104c7a:	00 
c0104c7b:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104c82:	e8 24 c0 ff ff       	call   c0100cab <__panic>
    assert(pa2page(*ptep) == p1);
c0104c87:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c8a:	8b 00                	mov    (%eax),%eax
c0104c8c:	89 04 24             	mov    %eax,(%esp)
c0104c8f:	e8 9e ed ff ff       	call   c0103a32 <pa2page>
c0104c94:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104c97:	74 24                	je     c0104cbd <check_pgdir+0x4fc>
c0104c99:	c7 44 24 0c 99 6c 10 	movl   $0xc0106c99,0xc(%esp)
c0104ca0:	c0 
c0104ca1:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104ca8:	c0 
c0104ca9:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0104cb0:	00 
c0104cb1:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104cb8:	e8 ee bf ff ff       	call   c0100cab <__panic>
    assert((*ptep & PTE_U) == 0);
c0104cbd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cc0:	8b 00                	mov    (%eax),%eax
c0104cc2:	83 e0 04             	and    $0x4,%eax
c0104cc5:	85 c0                	test   %eax,%eax
c0104cc7:	74 24                	je     c0104ced <check_pgdir+0x52c>
c0104cc9:	c7 44 24 0c e4 6d 10 	movl   $0xc0106de4,0xc(%esp)
c0104cd0:	c0 
c0104cd1:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104cd8:	c0 
c0104cd9:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104ce0:	00 
c0104ce1:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104ce8:	e8 be bf ff ff       	call   c0100cab <__panic>

    page_remove(boot_pgdir, 0x0);
c0104ced:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104cf2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104cf9:	00 
c0104cfa:	89 04 24             	mov    %eax,(%esp)
c0104cfd:	e8 47 f9 ff ff       	call   c0104649 <page_remove>
    assert(page_ref(p1) == 1);
c0104d02:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d05:	89 04 24             	mov    %eax,(%esp)
c0104d08:	e8 06 ee ff ff       	call   c0103b13 <page_ref>
c0104d0d:	83 f8 01             	cmp    $0x1,%eax
c0104d10:	74 24                	je     c0104d36 <check_pgdir+0x575>
c0104d12:	c7 44 24 0c ae 6c 10 	movl   $0xc0106cae,0xc(%esp)
c0104d19:	c0 
c0104d1a:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104d21:	c0 
c0104d22:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0104d29:	00 
c0104d2a:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104d31:	e8 75 bf ff ff       	call   c0100cab <__panic>
    assert(page_ref(p2) == 0);
c0104d36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d39:	89 04 24             	mov    %eax,(%esp)
c0104d3c:	e8 d2 ed ff ff       	call   c0103b13 <page_ref>
c0104d41:	85 c0                	test   %eax,%eax
c0104d43:	74 24                	je     c0104d69 <check_pgdir+0x5a8>
c0104d45:	c7 44 24 0c d2 6d 10 	movl   $0xc0106dd2,0xc(%esp)
c0104d4c:	c0 
c0104d4d:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104d54:	c0 
c0104d55:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0104d5c:	00 
c0104d5d:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104d64:	e8 42 bf ff ff       	call   c0100cab <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104d69:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d6e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104d75:	00 
c0104d76:	89 04 24             	mov    %eax,(%esp)
c0104d79:	e8 cb f8 ff ff       	call   c0104649 <page_remove>
    assert(page_ref(p1) == 0);
c0104d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d81:	89 04 24             	mov    %eax,(%esp)
c0104d84:	e8 8a ed ff ff       	call   c0103b13 <page_ref>
c0104d89:	85 c0                	test   %eax,%eax
c0104d8b:	74 24                	je     c0104db1 <check_pgdir+0x5f0>
c0104d8d:	c7 44 24 0c f9 6d 10 	movl   $0xc0106df9,0xc(%esp)
c0104d94:	c0 
c0104d95:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104d9c:	c0 
c0104d9d:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0104da4:	00 
c0104da5:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104dac:	e8 fa be ff ff       	call   c0100cab <__panic>
    assert(page_ref(p2) == 0);
c0104db1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104db4:	89 04 24             	mov    %eax,(%esp)
c0104db7:	e8 57 ed ff ff       	call   c0103b13 <page_ref>
c0104dbc:	85 c0                	test   %eax,%eax
c0104dbe:	74 24                	je     c0104de4 <check_pgdir+0x623>
c0104dc0:	c7 44 24 0c d2 6d 10 	movl   $0xc0106dd2,0xc(%esp)
c0104dc7:	c0 
c0104dc8:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104dcf:	c0 
c0104dd0:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104dd7:	00 
c0104dd8:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104ddf:	e8 c7 be ff ff       	call   c0100cab <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0104de4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104de9:	8b 00                	mov    (%eax),%eax
c0104deb:	89 04 24             	mov    %eax,(%esp)
c0104dee:	e8 3f ec ff ff       	call   c0103a32 <pa2page>
c0104df3:	89 04 24             	mov    %eax,(%esp)
c0104df6:	e8 18 ed ff ff       	call   c0103b13 <page_ref>
c0104dfb:	83 f8 01             	cmp    $0x1,%eax
c0104dfe:	74 24                	je     c0104e24 <check_pgdir+0x663>
c0104e00:	c7 44 24 0c 0c 6e 10 	movl   $0xc0106e0c,0xc(%esp)
c0104e07:	c0 
c0104e08:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104e0f:	c0 
c0104e10:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c0104e17:	00 
c0104e18:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104e1f:	e8 87 be ff ff       	call   c0100cab <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0104e24:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e29:	8b 00                	mov    (%eax),%eax
c0104e2b:	89 04 24             	mov    %eax,(%esp)
c0104e2e:	e8 ff eb ff ff       	call   c0103a32 <pa2page>
c0104e33:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e3a:	00 
c0104e3b:	89 04 24             	mov    %eax,(%esp)
c0104e3e:	e8 0d ef ff ff       	call   c0103d50 <free_pages>
    boot_pgdir[0] = 0;
c0104e43:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e48:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104e4e:	c7 04 24 32 6e 10 c0 	movl   $0xc0106e32,(%esp)
c0104e55:	e8 e2 b4 ff ff       	call   c010033c <cprintf>
}
c0104e5a:	c9                   	leave  
c0104e5b:	c3                   	ret    

c0104e5c <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104e5c:	55                   	push   %ebp
c0104e5d:	89 e5                	mov    %esp,%ebp
c0104e5f:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104e62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104e69:	e9 ca 00 00 00       	jmp    c0104f38 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e71:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e74:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e77:	c1 e8 0c             	shr    $0xc,%eax
c0104e7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e7d:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104e82:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104e85:	72 23                	jb     c0104eaa <check_boot_pgdir+0x4e>
c0104e87:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e8a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e8e:	c7 44 24 08 7c 6a 10 	movl   $0xc0106a7c,0x8(%esp)
c0104e95:	c0 
c0104e96:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0104e9d:	00 
c0104e9e:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104ea5:	e8 01 be ff ff       	call   c0100cab <__panic>
c0104eaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ead:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104eb2:	89 c2                	mov    %eax,%edx
c0104eb4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104eb9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104ec0:	00 
c0104ec1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ec5:	89 04 24             	mov    %eax,(%esp)
c0104ec8:	e8 8a f5 ff ff       	call   c0104457 <get_pte>
c0104ecd:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104ed0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104ed4:	75 24                	jne    c0104efa <check_boot_pgdir+0x9e>
c0104ed6:	c7 44 24 0c 4c 6e 10 	movl   $0xc0106e4c,0xc(%esp)
c0104edd:	c0 
c0104ede:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104ee5:	c0 
c0104ee6:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0104eed:	00 
c0104eee:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104ef5:	e8 b1 bd ff ff       	call   c0100cab <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104efa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104efd:	8b 00                	mov    (%eax),%eax
c0104eff:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f04:	89 c2                	mov    %eax,%edx
c0104f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f09:	39 c2                	cmp    %eax,%edx
c0104f0b:	74 24                	je     c0104f31 <check_boot_pgdir+0xd5>
c0104f0d:	c7 44 24 0c 89 6e 10 	movl   $0xc0106e89,0xc(%esp)
c0104f14:	c0 
c0104f15:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104f1c:	c0 
c0104f1d:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0104f24:	00 
c0104f25:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104f2c:	e8 7a bd ff ff       	call   c0100cab <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104f31:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104f38:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104f3b:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104f40:	39 c2                	cmp    %eax,%edx
c0104f42:	0f 82 26 ff ff ff    	jb     c0104e6e <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104f48:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f4d:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104f52:	8b 00                	mov    (%eax),%eax
c0104f54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f59:	89 c2                	mov    %eax,%edx
c0104f5b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f60:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f63:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104f6a:	77 23                	ja     c0104f8f <check_boot_pgdir+0x133>
c0104f6c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f6f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f73:	c7 44 24 08 20 6b 10 	movl   $0xc0106b20,0x8(%esp)
c0104f7a:	c0 
c0104f7b:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0104f82:	00 
c0104f83:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104f8a:	e8 1c bd ff ff       	call   c0100cab <__panic>
c0104f8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f92:	05 00 00 00 40       	add    $0x40000000,%eax
c0104f97:	39 c2                	cmp    %eax,%edx
c0104f99:	74 24                	je     c0104fbf <check_boot_pgdir+0x163>
c0104f9b:	c7 44 24 0c a0 6e 10 	movl   $0xc0106ea0,0xc(%esp)
c0104fa2:	c0 
c0104fa3:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104faa:	c0 
c0104fab:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0104fb2:	00 
c0104fb3:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104fba:	e8 ec bc ff ff       	call   c0100cab <__panic>

    assert(boot_pgdir[0] == 0);
c0104fbf:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104fc4:	8b 00                	mov    (%eax),%eax
c0104fc6:	85 c0                	test   %eax,%eax
c0104fc8:	74 24                	je     c0104fee <check_boot_pgdir+0x192>
c0104fca:	c7 44 24 0c d4 6e 10 	movl   $0xc0106ed4,0xc(%esp)
c0104fd1:	c0 
c0104fd2:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0104fd9:	c0 
c0104fda:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0104fe1:	00 
c0104fe2:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0104fe9:	e8 bd bc ff ff       	call   c0100cab <__panic>

    struct Page *p;
    p = alloc_page();
c0104fee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104ff5:	e8 1e ed ff ff       	call   c0103d18 <alloc_pages>
c0104ffa:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104ffd:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105002:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105009:	00 
c010500a:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105011:	00 
c0105012:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105015:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105019:	89 04 24             	mov    %eax,(%esp)
c010501c:	e8 6c f6 ff ff       	call   c010468d <page_insert>
c0105021:	85 c0                	test   %eax,%eax
c0105023:	74 24                	je     c0105049 <check_boot_pgdir+0x1ed>
c0105025:	c7 44 24 0c e8 6e 10 	movl   $0xc0106ee8,0xc(%esp)
c010502c:	c0 
c010502d:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0105034:	c0 
c0105035:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c010503c:	00 
c010503d:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0105044:	e8 62 bc ff ff       	call   c0100cab <__panic>
    assert(page_ref(p) == 1);
c0105049:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010504c:	89 04 24             	mov    %eax,(%esp)
c010504f:	e8 bf ea ff ff       	call   c0103b13 <page_ref>
c0105054:	83 f8 01             	cmp    $0x1,%eax
c0105057:	74 24                	je     c010507d <check_boot_pgdir+0x221>
c0105059:	c7 44 24 0c 16 6f 10 	movl   $0xc0106f16,0xc(%esp)
c0105060:	c0 
c0105061:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0105068:	c0 
c0105069:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c0105070:	00 
c0105071:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0105078:	e8 2e bc ff ff       	call   c0100cab <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c010507d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0105082:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105089:	00 
c010508a:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105091:	00 
c0105092:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105095:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105099:	89 04 24             	mov    %eax,(%esp)
c010509c:	e8 ec f5 ff ff       	call   c010468d <page_insert>
c01050a1:	85 c0                	test   %eax,%eax
c01050a3:	74 24                	je     c01050c9 <check_boot_pgdir+0x26d>
c01050a5:	c7 44 24 0c 28 6f 10 	movl   $0xc0106f28,0xc(%esp)
c01050ac:	c0 
c01050ad:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c01050b4:	c0 
c01050b5:	c7 44 24 04 3e 02 00 	movl   $0x23e,0x4(%esp)
c01050bc:	00 
c01050bd:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c01050c4:	e8 e2 bb ff ff       	call   c0100cab <__panic>
    assert(page_ref(p) == 2);
c01050c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050cc:	89 04 24             	mov    %eax,(%esp)
c01050cf:	e8 3f ea ff ff       	call   c0103b13 <page_ref>
c01050d4:	83 f8 02             	cmp    $0x2,%eax
c01050d7:	74 24                	je     c01050fd <check_boot_pgdir+0x2a1>
c01050d9:	c7 44 24 0c 5f 6f 10 	movl   $0xc0106f5f,0xc(%esp)
c01050e0:	c0 
c01050e1:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c01050e8:	c0 
c01050e9:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c01050f0:	00 
c01050f1:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c01050f8:	e8 ae bb ff ff       	call   c0100cab <__panic>

    const char *str = "ucore: Hello world!!";
c01050fd:	c7 45 dc 70 6f 10 c0 	movl   $0xc0106f70,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105104:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105107:	89 44 24 04          	mov    %eax,0x4(%esp)
c010510b:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105112:	e8 1e 0a 00 00       	call   c0105b35 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105117:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c010511e:	00 
c010511f:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105126:	e8 83 0a 00 00       	call   c0105bae <strcmp>
c010512b:	85 c0                	test   %eax,%eax
c010512d:	74 24                	je     c0105153 <check_boot_pgdir+0x2f7>
c010512f:	c7 44 24 0c 88 6f 10 	movl   $0xc0106f88,0xc(%esp)
c0105136:	c0 
c0105137:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c010513e:	c0 
c010513f:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c0105146:	00 
c0105147:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c010514e:	e8 58 bb ff ff       	call   c0100cab <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105153:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105156:	89 04 24             	mov    %eax,(%esp)
c0105159:	e8 23 e9 ff ff       	call   c0103a81 <page2kva>
c010515e:	05 00 01 00 00       	add    $0x100,%eax
c0105163:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105166:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010516d:	e8 6b 09 00 00       	call   c0105add <strlen>
c0105172:	85 c0                	test   %eax,%eax
c0105174:	74 24                	je     c010519a <check_boot_pgdir+0x33e>
c0105176:	c7 44 24 0c c0 6f 10 	movl   $0xc0106fc0,0xc(%esp)
c010517d:	c0 
c010517e:	c7 44 24 08 69 6b 10 	movl   $0xc0106b69,0x8(%esp)
c0105185:	c0 
c0105186:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c010518d:	00 
c010518e:	c7 04 24 44 6b 10 c0 	movl   $0xc0106b44,(%esp)
c0105195:	e8 11 bb ff ff       	call   c0100cab <__panic>

    free_page(p);
c010519a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051a1:	00 
c01051a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01051a5:	89 04 24             	mov    %eax,(%esp)
c01051a8:	e8 a3 eb ff ff       	call   c0103d50 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c01051ad:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01051b2:	8b 00                	mov    (%eax),%eax
c01051b4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01051b9:	89 04 24             	mov    %eax,(%esp)
c01051bc:	e8 71 e8 ff ff       	call   c0103a32 <pa2page>
c01051c1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051c8:	00 
c01051c9:	89 04 24             	mov    %eax,(%esp)
c01051cc:	e8 7f eb ff ff       	call   c0103d50 <free_pages>
    boot_pgdir[0] = 0;
c01051d1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01051d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01051dc:	c7 04 24 e4 6f 10 c0 	movl   $0xc0106fe4,(%esp)
c01051e3:	e8 54 b1 ff ff       	call   c010033c <cprintf>
}
c01051e8:	c9                   	leave  
c01051e9:	c3                   	ret    

c01051ea <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01051ea:	55                   	push   %ebp
c01051eb:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01051ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01051f0:	83 e0 04             	and    $0x4,%eax
c01051f3:	85 c0                	test   %eax,%eax
c01051f5:	74 07                	je     c01051fe <perm2str+0x14>
c01051f7:	b8 75 00 00 00       	mov    $0x75,%eax
c01051fc:	eb 05                	jmp    c0105203 <perm2str+0x19>
c01051fe:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105203:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c0105208:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c010520f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105212:	83 e0 02             	and    $0x2,%eax
c0105215:	85 c0                	test   %eax,%eax
c0105217:	74 07                	je     c0105220 <perm2str+0x36>
c0105219:	b8 77 00 00 00       	mov    $0x77,%eax
c010521e:	eb 05                	jmp    c0105225 <perm2str+0x3b>
c0105220:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105225:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c010522a:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c0105231:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0105236:	5d                   	pop    %ebp
c0105237:	c3                   	ret    

c0105238 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105238:	55                   	push   %ebp
c0105239:	89 e5                	mov    %esp,%ebp
c010523b:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010523e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105241:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105244:	72 0a                	jb     c0105250 <get_pgtable_items+0x18>
        return 0;
c0105246:	b8 00 00 00 00       	mov    $0x0,%eax
c010524b:	e9 9c 00 00 00       	jmp    c01052ec <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105250:	eb 04                	jmp    c0105256 <get_pgtable_items+0x1e>
        start ++;
c0105252:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105256:	8b 45 10             	mov    0x10(%ebp),%eax
c0105259:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010525c:	73 18                	jae    c0105276 <get_pgtable_items+0x3e>
c010525e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105261:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105268:	8b 45 14             	mov    0x14(%ebp),%eax
c010526b:	01 d0                	add    %edx,%eax
c010526d:	8b 00                	mov    (%eax),%eax
c010526f:	83 e0 01             	and    $0x1,%eax
c0105272:	85 c0                	test   %eax,%eax
c0105274:	74 dc                	je     c0105252 <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105276:	8b 45 10             	mov    0x10(%ebp),%eax
c0105279:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010527c:	73 69                	jae    c01052e7 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c010527e:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105282:	74 08                	je     c010528c <get_pgtable_items+0x54>
            *left_store = start;
c0105284:	8b 45 18             	mov    0x18(%ebp),%eax
c0105287:	8b 55 10             	mov    0x10(%ebp),%edx
c010528a:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010528c:	8b 45 10             	mov    0x10(%ebp),%eax
c010528f:	8d 50 01             	lea    0x1(%eax),%edx
c0105292:	89 55 10             	mov    %edx,0x10(%ebp)
c0105295:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010529c:	8b 45 14             	mov    0x14(%ebp),%eax
c010529f:	01 d0                	add    %edx,%eax
c01052a1:	8b 00                	mov    (%eax),%eax
c01052a3:	83 e0 07             	and    $0x7,%eax
c01052a6:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c01052a9:	eb 04                	jmp    c01052af <get_pgtable_items+0x77>
            start ++;
c01052ab:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c01052af:	8b 45 10             	mov    0x10(%ebp),%eax
c01052b2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01052b5:	73 1d                	jae    c01052d4 <get_pgtable_items+0x9c>
c01052b7:	8b 45 10             	mov    0x10(%ebp),%eax
c01052ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01052c1:	8b 45 14             	mov    0x14(%ebp),%eax
c01052c4:	01 d0                	add    %edx,%eax
c01052c6:	8b 00                	mov    (%eax),%eax
c01052c8:	83 e0 07             	and    $0x7,%eax
c01052cb:	89 c2                	mov    %eax,%edx
c01052cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052d0:	39 c2                	cmp    %eax,%edx
c01052d2:	74 d7                	je     c01052ab <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01052d4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01052d8:	74 08                	je     c01052e2 <get_pgtable_items+0xaa>
            *right_store = start;
c01052da:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01052dd:	8b 55 10             	mov    0x10(%ebp),%edx
c01052e0:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01052e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052e5:	eb 05                	jmp    c01052ec <get_pgtable_items+0xb4>
    }
    return 0;
c01052e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01052ec:	c9                   	leave  
c01052ed:	c3                   	ret    

c01052ee <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01052ee:	55                   	push   %ebp
c01052ef:	89 e5                	mov    %esp,%ebp
c01052f1:	57                   	push   %edi
c01052f2:	56                   	push   %esi
c01052f3:	53                   	push   %ebx
c01052f4:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01052f7:	c7 04 24 04 70 10 c0 	movl   $0xc0107004,(%esp)
c01052fe:	e8 39 b0 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c0105303:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010530a:	e9 fa 00 00 00       	jmp    c0105409 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010530f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105312:	89 04 24             	mov    %eax,(%esp)
c0105315:	e8 d0 fe ff ff       	call   c01051ea <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010531a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010531d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105320:	29 d1                	sub    %edx,%ecx
c0105322:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105324:	89 d6                	mov    %edx,%esi
c0105326:	c1 e6 16             	shl    $0x16,%esi
c0105329:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010532c:	89 d3                	mov    %edx,%ebx
c010532e:	c1 e3 16             	shl    $0x16,%ebx
c0105331:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105334:	89 d1                	mov    %edx,%ecx
c0105336:	c1 e1 16             	shl    $0x16,%ecx
c0105339:	8b 7d dc             	mov    -0x24(%ebp),%edi
c010533c:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010533f:	29 d7                	sub    %edx,%edi
c0105341:	89 fa                	mov    %edi,%edx
c0105343:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105347:	89 74 24 10          	mov    %esi,0x10(%esp)
c010534b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010534f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105353:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105357:	c7 04 24 35 70 10 c0 	movl   $0xc0107035,(%esp)
c010535e:	e8 d9 af ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105363:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105366:	c1 e0 0a             	shl    $0xa,%eax
c0105369:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010536c:	eb 54                	jmp    c01053c2 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010536e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105371:	89 04 24             	mov    %eax,(%esp)
c0105374:	e8 71 fe ff ff       	call   c01051ea <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105379:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010537c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010537f:	29 d1                	sub    %edx,%ecx
c0105381:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105383:	89 d6                	mov    %edx,%esi
c0105385:	c1 e6 0c             	shl    $0xc,%esi
c0105388:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010538b:	89 d3                	mov    %edx,%ebx
c010538d:	c1 e3 0c             	shl    $0xc,%ebx
c0105390:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105393:	c1 e2 0c             	shl    $0xc,%edx
c0105396:	89 d1                	mov    %edx,%ecx
c0105398:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c010539b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010539e:	29 d7                	sub    %edx,%edi
c01053a0:	89 fa                	mov    %edi,%edx
c01053a2:	89 44 24 14          	mov    %eax,0x14(%esp)
c01053a6:	89 74 24 10          	mov    %esi,0x10(%esp)
c01053aa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01053ae:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01053b2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01053b6:	c7 04 24 54 70 10 c0 	movl   $0xc0107054,(%esp)
c01053bd:	e8 7a af ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01053c2:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c01053c7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01053ca:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01053cd:	89 ce                	mov    %ecx,%esi
c01053cf:	c1 e6 0a             	shl    $0xa,%esi
c01053d2:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01053d5:	89 cb                	mov    %ecx,%ebx
c01053d7:	c1 e3 0a             	shl    $0xa,%ebx
c01053da:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01053dd:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01053e1:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01053e4:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01053e8:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01053ec:	89 44 24 08          	mov    %eax,0x8(%esp)
c01053f0:	89 74 24 04          	mov    %esi,0x4(%esp)
c01053f4:	89 1c 24             	mov    %ebx,(%esp)
c01053f7:	e8 3c fe ff ff       	call   c0105238 <get_pgtable_items>
c01053fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105403:	0f 85 65 ff ff ff    	jne    c010536e <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105409:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c010540e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105411:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105414:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105418:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c010541b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010541f:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105423:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105427:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c010542e:	00 
c010542f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105436:	e8 fd fd ff ff       	call   c0105238 <get_pgtable_items>
c010543b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010543e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105442:	0f 85 c7 fe ff ff    	jne    c010530f <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105448:	c7 04 24 78 70 10 c0 	movl   $0xc0107078,(%esp)
c010544f:	e8 e8 ae ff ff       	call   c010033c <cprintf>
}
c0105454:	83 c4 4c             	add    $0x4c,%esp
c0105457:	5b                   	pop    %ebx
c0105458:	5e                   	pop    %esi
c0105459:	5f                   	pop    %edi
c010545a:	5d                   	pop    %ebp
c010545b:	c3                   	ret    

c010545c <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010545c:	55                   	push   %ebp
c010545d:	89 e5                	mov    %esp,%ebp
c010545f:	83 ec 58             	sub    $0x58,%esp
c0105462:	8b 45 10             	mov    0x10(%ebp),%eax
c0105465:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105468:	8b 45 14             	mov    0x14(%ebp),%eax
c010546b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010546e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105471:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105474:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105477:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010547a:	8b 45 18             	mov    0x18(%ebp),%eax
c010547d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105480:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105483:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105486:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105489:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010548c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010548f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105492:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105496:	74 1c                	je     c01054b4 <printnum+0x58>
c0105498:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010549b:	ba 00 00 00 00       	mov    $0x0,%edx
c01054a0:	f7 75 e4             	divl   -0x1c(%ebp)
c01054a3:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01054a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054a9:	ba 00 00 00 00       	mov    $0x0,%edx
c01054ae:	f7 75 e4             	divl   -0x1c(%ebp)
c01054b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054ba:	f7 75 e4             	divl   -0x1c(%ebp)
c01054bd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01054c0:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01054c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01054c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01054cc:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01054cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01054d2:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01054d5:	8b 45 18             	mov    0x18(%ebp),%eax
c01054d8:	ba 00 00 00 00       	mov    $0x0,%edx
c01054dd:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054e0:	77 56                	ja     c0105538 <printnum+0xdc>
c01054e2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054e5:	72 05                	jb     c01054ec <printnum+0x90>
c01054e7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01054ea:	77 4c                	ja     c0105538 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01054ec:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01054ef:	8d 50 ff             	lea    -0x1(%eax),%edx
c01054f2:	8b 45 20             	mov    0x20(%ebp),%eax
c01054f5:	89 44 24 18          	mov    %eax,0x18(%esp)
c01054f9:	89 54 24 14          	mov    %edx,0x14(%esp)
c01054fd:	8b 45 18             	mov    0x18(%ebp),%eax
c0105500:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105504:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105507:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010550a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010550e:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105512:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105515:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105519:	8b 45 08             	mov    0x8(%ebp),%eax
c010551c:	89 04 24             	mov    %eax,(%esp)
c010551f:	e8 38 ff ff ff       	call   c010545c <printnum>
c0105524:	eb 1c                	jmp    c0105542 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105526:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105529:	89 44 24 04          	mov    %eax,0x4(%esp)
c010552d:	8b 45 20             	mov    0x20(%ebp),%eax
c0105530:	89 04 24             	mov    %eax,(%esp)
c0105533:	8b 45 08             	mov    0x8(%ebp),%eax
c0105536:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0105538:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010553c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105540:	7f e4                	jg     c0105526 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105542:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105545:	05 2c 71 10 c0       	add    $0xc010712c,%eax
c010554a:	0f b6 00             	movzbl (%eax),%eax
c010554d:	0f be c0             	movsbl %al,%eax
c0105550:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105553:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105557:	89 04 24             	mov    %eax,(%esp)
c010555a:	8b 45 08             	mov    0x8(%ebp),%eax
c010555d:	ff d0                	call   *%eax
}
c010555f:	c9                   	leave  
c0105560:	c3                   	ret    

c0105561 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105561:	55                   	push   %ebp
c0105562:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105564:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105568:	7e 14                	jle    c010557e <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010556a:	8b 45 08             	mov    0x8(%ebp),%eax
c010556d:	8b 00                	mov    (%eax),%eax
c010556f:	8d 48 08             	lea    0x8(%eax),%ecx
c0105572:	8b 55 08             	mov    0x8(%ebp),%edx
c0105575:	89 0a                	mov    %ecx,(%edx)
c0105577:	8b 50 04             	mov    0x4(%eax),%edx
c010557a:	8b 00                	mov    (%eax),%eax
c010557c:	eb 30                	jmp    c01055ae <getuint+0x4d>
    }
    else if (lflag) {
c010557e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105582:	74 16                	je     c010559a <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105584:	8b 45 08             	mov    0x8(%ebp),%eax
c0105587:	8b 00                	mov    (%eax),%eax
c0105589:	8d 48 04             	lea    0x4(%eax),%ecx
c010558c:	8b 55 08             	mov    0x8(%ebp),%edx
c010558f:	89 0a                	mov    %ecx,(%edx)
c0105591:	8b 00                	mov    (%eax),%eax
c0105593:	ba 00 00 00 00       	mov    $0x0,%edx
c0105598:	eb 14                	jmp    c01055ae <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010559a:	8b 45 08             	mov    0x8(%ebp),%eax
c010559d:	8b 00                	mov    (%eax),%eax
c010559f:	8d 48 04             	lea    0x4(%eax),%ecx
c01055a2:	8b 55 08             	mov    0x8(%ebp),%edx
c01055a5:	89 0a                	mov    %ecx,(%edx)
c01055a7:	8b 00                	mov    (%eax),%eax
c01055a9:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01055ae:	5d                   	pop    %ebp
c01055af:	c3                   	ret    

c01055b0 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01055b0:	55                   	push   %ebp
c01055b1:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01055b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01055b7:	7e 14                	jle    c01055cd <getint+0x1d>
        return va_arg(*ap, long long);
c01055b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01055bc:	8b 00                	mov    (%eax),%eax
c01055be:	8d 48 08             	lea    0x8(%eax),%ecx
c01055c1:	8b 55 08             	mov    0x8(%ebp),%edx
c01055c4:	89 0a                	mov    %ecx,(%edx)
c01055c6:	8b 50 04             	mov    0x4(%eax),%edx
c01055c9:	8b 00                	mov    (%eax),%eax
c01055cb:	eb 28                	jmp    c01055f5 <getint+0x45>
    }
    else if (lflag) {
c01055cd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01055d1:	74 12                	je     c01055e5 <getint+0x35>
        return va_arg(*ap, long);
c01055d3:	8b 45 08             	mov    0x8(%ebp),%eax
c01055d6:	8b 00                	mov    (%eax),%eax
c01055d8:	8d 48 04             	lea    0x4(%eax),%ecx
c01055db:	8b 55 08             	mov    0x8(%ebp),%edx
c01055de:	89 0a                	mov    %ecx,(%edx)
c01055e0:	8b 00                	mov    (%eax),%eax
c01055e2:	99                   	cltd   
c01055e3:	eb 10                	jmp    c01055f5 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01055e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01055e8:	8b 00                	mov    (%eax),%eax
c01055ea:	8d 48 04             	lea    0x4(%eax),%ecx
c01055ed:	8b 55 08             	mov    0x8(%ebp),%edx
c01055f0:	89 0a                	mov    %ecx,(%edx)
c01055f2:	8b 00                	mov    (%eax),%eax
c01055f4:	99                   	cltd   
    }
}
c01055f5:	5d                   	pop    %ebp
c01055f6:	c3                   	ret    

c01055f7 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01055f7:	55                   	push   %ebp
c01055f8:	89 e5                	mov    %esp,%ebp
c01055fa:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01055fd:	8d 45 14             	lea    0x14(%ebp),%eax
c0105600:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105603:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105606:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010560a:	8b 45 10             	mov    0x10(%ebp),%eax
c010560d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105611:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105614:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105618:	8b 45 08             	mov    0x8(%ebp),%eax
c010561b:	89 04 24             	mov    %eax,(%esp)
c010561e:	e8 02 00 00 00       	call   c0105625 <vprintfmt>
    va_end(ap);
}
c0105623:	c9                   	leave  
c0105624:	c3                   	ret    

c0105625 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105625:	55                   	push   %ebp
c0105626:	89 e5                	mov    %esp,%ebp
c0105628:	56                   	push   %esi
c0105629:	53                   	push   %ebx
c010562a:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010562d:	eb 18                	jmp    c0105647 <vprintfmt+0x22>
            if (ch == '\0') {
c010562f:	85 db                	test   %ebx,%ebx
c0105631:	75 05                	jne    c0105638 <vprintfmt+0x13>
                return;
c0105633:	e9 d1 03 00 00       	jmp    c0105a09 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0105638:	8b 45 0c             	mov    0xc(%ebp),%eax
c010563b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010563f:	89 1c 24             	mov    %ebx,(%esp)
c0105642:	8b 45 08             	mov    0x8(%ebp),%eax
c0105645:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105647:	8b 45 10             	mov    0x10(%ebp),%eax
c010564a:	8d 50 01             	lea    0x1(%eax),%edx
c010564d:	89 55 10             	mov    %edx,0x10(%ebp)
c0105650:	0f b6 00             	movzbl (%eax),%eax
c0105653:	0f b6 d8             	movzbl %al,%ebx
c0105656:	83 fb 25             	cmp    $0x25,%ebx
c0105659:	75 d4                	jne    c010562f <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010565b:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010565f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105666:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105669:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010566c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105673:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105676:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105679:	8b 45 10             	mov    0x10(%ebp),%eax
c010567c:	8d 50 01             	lea    0x1(%eax),%edx
c010567f:	89 55 10             	mov    %edx,0x10(%ebp)
c0105682:	0f b6 00             	movzbl (%eax),%eax
c0105685:	0f b6 d8             	movzbl %al,%ebx
c0105688:	8d 43 dd             	lea    -0x23(%ebx),%eax
c010568b:	83 f8 55             	cmp    $0x55,%eax
c010568e:	0f 87 44 03 00 00    	ja     c01059d8 <vprintfmt+0x3b3>
c0105694:	8b 04 85 50 71 10 c0 	mov    -0x3fef8eb0(,%eax,4),%eax
c010569b:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010569d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01056a1:	eb d6                	jmp    c0105679 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01056a3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01056a7:	eb d0                	jmp    c0105679 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01056a9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01056b0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01056b3:	89 d0                	mov    %edx,%eax
c01056b5:	c1 e0 02             	shl    $0x2,%eax
c01056b8:	01 d0                	add    %edx,%eax
c01056ba:	01 c0                	add    %eax,%eax
c01056bc:	01 d8                	add    %ebx,%eax
c01056be:	83 e8 30             	sub    $0x30,%eax
c01056c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01056c4:	8b 45 10             	mov    0x10(%ebp),%eax
c01056c7:	0f b6 00             	movzbl (%eax),%eax
c01056ca:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01056cd:	83 fb 2f             	cmp    $0x2f,%ebx
c01056d0:	7e 0b                	jle    c01056dd <vprintfmt+0xb8>
c01056d2:	83 fb 39             	cmp    $0x39,%ebx
c01056d5:	7f 06                	jg     c01056dd <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01056d7:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01056db:	eb d3                	jmp    c01056b0 <vprintfmt+0x8b>
            goto process_precision;
c01056dd:	eb 33                	jmp    c0105712 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01056df:	8b 45 14             	mov    0x14(%ebp),%eax
c01056e2:	8d 50 04             	lea    0x4(%eax),%edx
c01056e5:	89 55 14             	mov    %edx,0x14(%ebp)
c01056e8:	8b 00                	mov    (%eax),%eax
c01056ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01056ed:	eb 23                	jmp    c0105712 <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01056ef:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056f3:	79 0c                	jns    c0105701 <vprintfmt+0xdc>
                width = 0;
c01056f5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01056fc:	e9 78 ff ff ff       	jmp    c0105679 <vprintfmt+0x54>
c0105701:	e9 73 ff ff ff       	jmp    c0105679 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c0105706:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010570d:	e9 67 ff ff ff       	jmp    c0105679 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c0105712:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105716:	79 12                	jns    c010572a <vprintfmt+0x105>
                width = precision, precision = -1;
c0105718:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010571b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010571e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105725:	e9 4f ff ff ff       	jmp    c0105679 <vprintfmt+0x54>
c010572a:	e9 4a ff ff ff       	jmp    c0105679 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010572f:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105733:	e9 41 ff ff ff       	jmp    c0105679 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105738:	8b 45 14             	mov    0x14(%ebp),%eax
c010573b:	8d 50 04             	lea    0x4(%eax),%edx
c010573e:	89 55 14             	mov    %edx,0x14(%ebp)
c0105741:	8b 00                	mov    (%eax),%eax
c0105743:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105746:	89 54 24 04          	mov    %edx,0x4(%esp)
c010574a:	89 04 24             	mov    %eax,(%esp)
c010574d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105750:	ff d0                	call   *%eax
            break;
c0105752:	e9 ac 02 00 00       	jmp    c0105a03 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105757:	8b 45 14             	mov    0x14(%ebp),%eax
c010575a:	8d 50 04             	lea    0x4(%eax),%edx
c010575d:	89 55 14             	mov    %edx,0x14(%ebp)
c0105760:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105762:	85 db                	test   %ebx,%ebx
c0105764:	79 02                	jns    c0105768 <vprintfmt+0x143>
                err = -err;
c0105766:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105768:	83 fb 06             	cmp    $0x6,%ebx
c010576b:	7f 0b                	jg     c0105778 <vprintfmt+0x153>
c010576d:	8b 34 9d 10 71 10 c0 	mov    -0x3fef8ef0(,%ebx,4),%esi
c0105774:	85 f6                	test   %esi,%esi
c0105776:	75 23                	jne    c010579b <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0105778:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010577c:	c7 44 24 08 3d 71 10 	movl   $0xc010713d,0x8(%esp)
c0105783:	c0 
c0105784:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105787:	89 44 24 04          	mov    %eax,0x4(%esp)
c010578b:	8b 45 08             	mov    0x8(%ebp),%eax
c010578e:	89 04 24             	mov    %eax,(%esp)
c0105791:	e8 61 fe ff ff       	call   c01055f7 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105796:	e9 68 02 00 00       	jmp    c0105a03 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010579b:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010579f:	c7 44 24 08 46 71 10 	movl   $0xc0107146,0x8(%esp)
c01057a6:	c0 
c01057a7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01057b1:	89 04 24             	mov    %eax,(%esp)
c01057b4:	e8 3e fe ff ff       	call   c01055f7 <printfmt>
            }
            break;
c01057b9:	e9 45 02 00 00       	jmp    c0105a03 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01057be:	8b 45 14             	mov    0x14(%ebp),%eax
c01057c1:	8d 50 04             	lea    0x4(%eax),%edx
c01057c4:	89 55 14             	mov    %edx,0x14(%ebp)
c01057c7:	8b 30                	mov    (%eax),%esi
c01057c9:	85 f6                	test   %esi,%esi
c01057cb:	75 05                	jne    c01057d2 <vprintfmt+0x1ad>
                p = "(null)";
c01057cd:	be 49 71 10 c0       	mov    $0xc0107149,%esi
            }
            if (width > 0 && padc != '-') {
c01057d2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057d6:	7e 3e                	jle    c0105816 <vprintfmt+0x1f1>
c01057d8:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01057dc:	74 38                	je     c0105816 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057de:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01057e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057e8:	89 34 24             	mov    %esi,(%esp)
c01057eb:	e8 15 03 00 00       	call   c0105b05 <strnlen>
c01057f0:	29 c3                	sub    %eax,%ebx
c01057f2:	89 d8                	mov    %ebx,%eax
c01057f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057f7:	eb 17                	jmp    c0105810 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01057f9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01057fd:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105800:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105804:	89 04 24             	mov    %eax,(%esp)
c0105807:	8b 45 08             	mov    0x8(%ebp),%eax
c010580a:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c010580c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105810:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105814:	7f e3                	jg     c01057f9 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105816:	eb 38                	jmp    c0105850 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105818:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010581c:	74 1f                	je     c010583d <vprintfmt+0x218>
c010581e:	83 fb 1f             	cmp    $0x1f,%ebx
c0105821:	7e 05                	jle    c0105828 <vprintfmt+0x203>
c0105823:	83 fb 7e             	cmp    $0x7e,%ebx
c0105826:	7e 15                	jle    c010583d <vprintfmt+0x218>
                    putch('?', putdat);
c0105828:	8b 45 0c             	mov    0xc(%ebp),%eax
c010582b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010582f:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105836:	8b 45 08             	mov    0x8(%ebp),%eax
c0105839:	ff d0                	call   *%eax
c010583b:	eb 0f                	jmp    c010584c <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c010583d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105840:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105844:	89 1c 24             	mov    %ebx,(%esp)
c0105847:	8b 45 08             	mov    0x8(%ebp),%eax
c010584a:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010584c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105850:	89 f0                	mov    %esi,%eax
c0105852:	8d 70 01             	lea    0x1(%eax),%esi
c0105855:	0f b6 00             	movzbl (%eax),%eax
c0105858:	0f be d8             	movsbl %al,%ebx
c010585b:	85 db                	test   %ebx,%ebx
c010585d:	74 10                	je     c010586f <vprintfmt+0x24a>
c010585f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105863:	78 b3                	js     c0105818 <vprintfmt+0x1f3>
c0105865:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105869:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010586d:	79 a9                	jns    c0105818 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010586f:	eb 17                	jmp    c0105888 <vprintfmt+0x263>
                putch(' ', putdat);
c0105871:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105874:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105878:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010587f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105882:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105884:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105888:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010588c:	7f e3                	jg     c0105871 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c010588e:	e9 70 01 00 00       	jmp    c0105a03 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105893:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105896:	89 44 24 04          	mov    %eax,0x4(%esp)
c010589a:	8d 45 14             	lea    0x14(%ebp),%eax
c010589d:	89 04 24             	mov    %eax,(%esp)
c01058a0:	e8 0b fd ff ff       	call   c01055b0 <getint>
c01058a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01058ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058b1:	85 d2                	test   %edx,%edx
c01058b3:	79 26                	jns    c01058db <vprintfmt+0x2b6>
                putch('-', putdat);
c01058b5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058b8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058bc:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01058c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01058c6:	ff d0                	call   *%eax
                num = -(long long)num;
c01058c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058ce:	f7 d8                	neg    %eax
c01058d0:	83 d2 00             	adc    $0x0,%edx
c01058d3:	f7 da                	neg    %edx
c01058d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01058db:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058e2:	e9 a8 00 00 00       	jmp    c010598f <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01058e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058ea:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058ee:	8d 45 14             	lea    0x14(%ebp),%eax
c01058f1:	89 04 24             	mov    %eax,(%esp)
c01058f4:	e8 68 fc ff ff       	call   c0105561 <getuint>
c01058f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058fc:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01058ff:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105906:	e9 84 00 00 00       	jmp    c010598f <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010590b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010590e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105912:	8d 45 14             	lea    0x14(%ebp),%eax
c0105915:	89 04 24             	mov    %eax,(%esp)
c0105918:	e8 44 fc ff ff       	call   c0105561 <getuint>
c010591d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105920:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105923:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010592a:	eb 63                	jmp    c010598f <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c010592c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010592f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105933:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010593a:	8b 45 08             	mov    0x8(%ebp),%eax
c010593d:	ff d0                	call   *%eax
            putch('x', putdat);
c010593f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105942:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105946:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010594d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105950:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105952:	8b 45 14             	mov    0x14(%ebp),%eax
c0105955:	8d 50 04             	lea    0x4(%eax),%edx
c0105958:	89 55 14             	mov    %edx,0x14(%ebp)
c010595b:	8b 00                	mov    (%eax),%eax
c010595d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105960:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105967:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010596e:	eb 1f                	jmp    c010598f <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105970:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105973:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105977:	8d 45 14             	lea    0x14(%ebp),%eax
c010597a:	89 04 24             	mov    %eax,(%esp)
c010597d:	e8 df fb ff ff       	call   c0105561 <getuint>
c0105982:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105985:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105988:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010598f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105993:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105996:	89 54 24 18          	mov    %edx,0x18(%esp)
c010599a:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010599d:	89 54 24 14          	mov    %edx,0x14(%esp)
c01059a1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01059a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01059a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01059ab:	89 44 24 08          	mov    %eax,0x8(%esp)
c01059af:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01059b3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059b6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01059bd:	89 04 24             	mov    %eax,(%esp)
c01059c0:	e8 97 fa ff ff       	call   c010545c <printnum>
            break;
c01059c5:	eb 3c                	jmp    c0105a03 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01059c7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ca:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059ce:	89 1c 24             	mov    %ebx,(%esp)
c01059d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01059d4:	ff d0                	call   *%eax
            break;
c01059d6:	eb 2b                	jmp    c0105a03 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01059d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059db:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059df:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01059e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01059e9:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01059eb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059ef:	eb 04                	jmp    c01059f5 <vprintfmt+0x3d0>
c01059f1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059f5:	8b 45 10             	mov    0x10(%ebp),%eax
c01059f8:	83 e8 01             	sub    $0x1,%eax
c01059fb:	0f b6 00             	movzbl (%eax),%eax
c01059fe:	3c 25                	cmp    $0x25,%al
c0105a00:	75 ef                	jne    c01059f1 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c0105a02:	90                   	nop
        }
    }
c0105a03:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105a04:	e9 3e fc ff ff       	jmp    c0105647 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105a09:	83 c4 40             	add    $0x40,%esp
c0105a0c:	5b                   	pop    %ebx
c0105a0d:	5e                   	pop    %esi
c0105a0e:	5d                   	pop    %ebp
c0105a0f:	c3                   	ret    

c0105a10 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105a10:	55                   	push   %ebp
c0105a11:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105a13:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a16:	8b 40 08             	mov    0x8(%eax),%eax
c0105a19:	8d 50 01             	lea    0x1(%eax),%edx
c0105a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a1f:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105a22:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a25:	8b 10                	mov    (%eax),%edx
c0105a27:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a2a:	8b 40 04             	mov    0x4(%eax),%eax
c0105a2d:	39 c2                	cmp    %eax,%edx
c0105a2f:	73 12                	jae    c0105a43 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105a31:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a34:	8b 00                	mov    (%eax),%eax
c0105a36:	8d 48 01             	lea    0x1(%eax),%ecx
c0105a39:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a3c:	89 0a                	mov    %ecx,(%edx)
c0105a3e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a41:	88 10                	mov    %dl,(%eax)
    }
}
c0105a43:	5d                   	pop    %ebp
c0105a44:	c3                   	ret    

c0105a45 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105a45:	55                   	push   %ebp
c0105a46:	89 e5                	mov    %esp,%ebp
c0105a48:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105a4b:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105a51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a54:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a58:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a5b:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a5f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a62:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a66:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a69:	89 04 24             	mov    %eax,(%esp)
c0105a6c:	e8 08 00 00 00       	call   c0105a79 <vsnprintf>
c0105a71:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a77:	c9                   	leave  
c0105a78:	c3                   	ret    

c0105a79 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105a79:	55                   	push   %ebp
c0105a7a:	89 e5                	mov    %esp,%ebp
c0105a7c:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105a7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a82:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a85:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a88:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a8e:	01 d0                	add    %edx,%eax
c0105a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105a9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105a9e:	74 0a                	je     c0105aaa <vsnprintf+0x31>
c0105aa0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105aa3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105aa6:	39 c2                	cmp    %eax,%edx
c0105aa8:	76 07                	jbe    c0105ab1 <vsnprintf+0x38>
        return -E_INVAL;
c0105aaa:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105aaf:	eb 2a                	jmp    c0105adb <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105ab1:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ab4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105ab8:	8b 45 10             	mov    0x10(%ebp),%eax
c0105abb:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105abf:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ac6:	c7 04 24 10 5a 10 c0 	movl   $0xc0105a10,(%esp)
c0105acd:	e8 53 fb ff ff       	call   c0105625 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105ad2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ad5:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105ad8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105adb:	c9                   	leave  
c0105adc:	c3                   	ret    

c0105add <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105add:	55                   	push   %ebp
c0105ade:	89 e5                	mov    %esp,%ebp
c0105ae0:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105ae3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105aea:	eb 04                	jmp    c0105af0 <strlen+0x13>
        cnt ++;
c0105aec:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105af0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105af3:	8d 50 01             	lea    0x1(%eax),%edx
c0105af6:	89 55 08             	mov    %edx,0x8(%ebp)
c0105af9:	0f b6 00             	movzbl (%eax),%eax
c0105afc:	84 c0                	test   %al,%al
c0105afe:	75 ec                	jne    c0105aec <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b03:	c9                   	leave  
c0105b04:	c3                   	ret    

c0105b05 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105b05:	55                   	push   %ebp
c0105b06:	89 e5                	mov    %esp,%ebp
c0105b08:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105b0b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105b12:	eb 04                	jmp    c0105b18 <strnlen+0x13>
        cnt ++;
c0105b14:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105b18:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b1b:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105b1e:	73 10                	jae    c0105b30 <strnlen+0x2b>
c0105b20:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b23:	8d 50 01             	lea    0x1(%eax),%edx
c0105b26:	89 55 08             	mov    %edx,0x8(%ebp)
c0105b29:	0f b6 00             	movzbl (%eax),%eax
c0105b2c:	84 c0                	test   %al,%al
c0105b2e:	75 e4                	jne    c0105b14 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105b30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b33:	c9                   	leave  
c0105b34:	c3                   	ret    

c0105b35 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105b35:	55                   	push   %ebp
c0105b36:	89 e5                	mov    %esp,%ebp
c0105b38:	57                   	push   %edi
c0105b39:	56                   	push   %esi
c0105b3a:	83 ec 20             	sub    $0x20,%esp
c0105b3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b40:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b43:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b46:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105b49:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105b4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b4f:	89 d1                	mov    %edx,%ecx
c0105b51:	89 c2                	mov    %eax,%edx
c0105b53:	89 ce                	mov    %ecx,%esi
c0105b55:	89 d7                	mov    %edx,%edi
c0105b57:	ac                   	lods   %ds:(%esi),%al
c0105b58:	aa                   	stos   %al,%es:(%edi)
c0105b59:	84 c0                	test   %al,%al
c0105b5b:	75 fa                	jne    c0105b57 <strcpy+0x22>
c0105b5d:	89 fa                	mov    %edi,%edx
c0105b5f:	89 f1                	mov    %esi,%ecx
c0105b61:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105b64:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105b67:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105b6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105b6d:	83 c4 20             	add    $0x20,%esp
c0105b70:	5e                   	pop    %esi
c0105b71:	5f                   	pop    %edi
c0105b72:	5d                   	pop    %ebp
c0105b73:	c3                   	ret    

c0105b74 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105b74:	55                   	push   %ebp
c0105b75:	89 e5                	mov    %esp,%ebp
c0105b77:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105b7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105b80:	eb 21                	jmp    c0105ba3 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105b82:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b85:	0f b6 10             	movzbl (%eax),%edx
c0105b88:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b8b:	88 10                	mov    %dl,(%eax)
c0105b8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b90:	0f b6 00             	movzbl (%eax),%eax
c0105b93:	84 c0                	test   %al,%al
c0105b95:	74 04                	je     c0105b9b <strncpy+0x27>
            src ++;
c0105b97:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105b9b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105b9f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105ba3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ba7:	75 d9                	jne    c0105b82 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105ba9:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105bac:	c9                   	leave  
c0105bad:	c3                   	ret    

c0105bae <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105bae:	55                   	push   %ebp
c0105baf:	89 e5                	mov    %esp,%ebp
c0105bb1:	57                   	push   %edi
c0105bb2:	56                   	push   %esi
c0105bb3:	83 ec 20             	sub    $0x20,%esp
c0105bb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105bbc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105bc2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105bc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bc8:	89 d1                	mov    %edx,%ecx
c0105bca:	89 c2                	mov    %eax,%edx
c0105bcc:	89 ce                	mov    %ecx,%esi
c0105bce:	89 d7                	mov    %edx,%edi
c0105bd0:	ac                   	lods   %ds:(%esi),%al
c0105bd1:	ae                   	scas   %es:(%edi),%al
c0105bd2:	75 08                	jne    c0105bdc <strcmp+0x2e>
c0105bd4:	84 c0                	test   %al,%al
c0105bd6:	75 f8                	jne    c0105bd0 <strcmp+0x22>
c0105bd8:	31 c0                	xor    %eax,%eax
c0105bda:	eb 04                	jmp    c0105be0 <strcmp+0x32>
c0105bdc:	19 c0                	sbb    %eax,%eax
c0105bde:	0c 01                	or     $0x1,%al
c0105be0:	89 fa                	mov    %edi,%edx
c0105be2:	89 f1                	mov    %esi,%ecx
c0105be4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105be7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105bea:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105bed:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105bf0:	83 c4 20             	add    $0x20,%esp
c0105bf3:	5e                   	pop    %esi
c0105bf4:	5f                   	pop    %edi
c0105bf5:	5d                   	pop    %ebp
c0105bf6:	c3                   	ret    

c0105bf7 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105bf7:	55                   	push   %ebp
c0105bf8:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105bfa:	eb 0c                	jmp    c0105c08 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105bfc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105c00:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105c04:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105c08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c0c:	74 1a                	je     c0105c28 <strncmp+0x31>
c0105c0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c11:	0f b6 00             	movzbl (%eax),%eax
c0105c14:	84 c0                	test   %al,%al
c0105c16:	74 10                	je     c0105c28 <strncmp+0x31>
c0105c18:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c1b:	0f b6 10             	movzbl (%eax),%edx
c0105c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c21:	0f b6 00             	movzbl (%eax),%eax
c0105c24:	38 c2                	cmp    %al,%dl
c0105c26:	74 d4                	je     c0105bfc <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105c28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105c2c:	74 18                	je     c0105c46 <strncmp+0x4f>
c0105c2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c31:	0f b6 00             	movzbl (%eax),%eax
c0105c34:	0f b6 d0             	movzbl %al,%edx
c0105c37:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c3a:	0f b6 00             	movzbl (%eax),%eax
c0105c3d:	0f b6 c0             	movzbl %al,%eax
c0105c40:	29 c2                	sub    %eax,%edx
c0105c42:	89 d0                	mov    %edx,%eax
c0105c44:	eb 05                	jmp    c0105c4b <strncmp+0x54>
c0105c46:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c4b:	5d                   	pop    %ebp
c0105c4c:	c3                   	ret    

c0105c4d <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105c4d:	55                   	push   %ebp
c0105c4e:	89 e5                	mov    %esp,%ebp
c0105c50:	83 ec 04             	sub    $0x4,%esp
c0105c53:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c56:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c59:	eb 14                	jmp    c0105c6f <strchr+0x22>
        if (*s == c) {
c0105c5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5e:	0f b6 00             	movzbl (%eax),%eax
c0105c61:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105c64:	75 05                	jne    c0105c6b <strchr+0x1e>
            return (char *)s;
c0105c66:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c69:	eb 13                	jmp    c0105c7e <strchr+0x31>
        }
        s ++;
c0105c6b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105c6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c72:	0f b6 00             	movzbl (%eax),%eax
c0105c75:	84 c0                	test   %al,%al
c0105c77:	75 e2                	jne    c0105c5b <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105c79:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c7e:	c9                   	leave  
c0105c7f:	c3                   	ret    

c0105c80 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105c80:	55                   	push   %ebp
c0105c81:	89 e5                	mov    %esp,%ebp
c0105c83:	83 ec 04             	sub    $0x4,%esp
c0105c86:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c89:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c8c:	eb 11                	jmp    c0105c9f <strfind+0x1f>
        if (*s == c) {
c0105c8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c91:	0f b6 00             	movzbl (%eax),%eax
c0105c94:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105c97:	75 02                	jne    c0105c9b <strfind+0x1b>
            break;
c0105c99:	eb 0e                	jmp    c0105ca9 <strfind+0x29>
        }
        s ++;
c0105c9b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105c9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca2:	0f b6 00             	movzbl (%eax),%eax
c0105ca5:	84 c0                	test   %al,%al
c0105ca7:	75 e5                	jne    c0105c8e <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105ca9:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105cac:	c9                   	leave  
c0105cad:	c3                   	ret    

c0105cae <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105cae:	55                   	push   %ebp
c0105caf:	89 e5                	mov    %esp,%ebp
c0105cb1:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105cb4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105cbb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105cc2:	eb 04                	jmp    c0105cc8 <strtol+0x1a>
        s ++;
c0105cc4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105cc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ccb:	0f b6 00             	movzbl (%eax),%eax
c0105cce:	3c 20                	cmp    $0x20,%al
c0105cd0:	74 f2                	je     c0105cc4 <strtol+0x16>
c0105cd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cd5:	0f b6 00             	movzbl (%eax),%eax
c0105cd8:	3c 09                	cmp    $0x9,%al
c0105cda:	74 e8                	je     c0105cc4 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105cdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cdf:	0f b6 00             	movzbl (%eax),%eax
c0105ce2:	3c 2b                	cmp    $0x2b,%al
c0105ce4:	75 06                	jne    c0105cec <strtol+0x3e>
        s ++;
c0105ce6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105cea:	eb 15                	jmp    c0105d01 <strtol+0x53>
    }
    else if (*s == '-') {
c0105cec:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cef:	0f b6 00             	movzbl (%eax),%eax
c0105cf2:	3c 2d                	cmp    $0x2d,%al
c0105cf4:	75 0b                	jne    c0105d01 <strtol+0x53>
        s ++, neg = 1;
c0105cf6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105cfa:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105d01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d05:	74 06                	je     c0105d0d <strtol+0x5f>
c0105d07:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105d0b:	75 24                	jne    c0105d31 <strtol+0x83>
c0105d0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d10:	0f b6 00             	movzbl (%eax),%eax
c0105d13:	3c 30                	cmp    $0x30,%al
c0105d15:	75 1a                	jne    c0105d31 <strtol+0x83>
c0105d17:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d1a:	83 c0 01             	add    $0x1,%eax
c0105d1d:	0f b6 00             	movzbl (%eax),%eax
c0105d20:	3c 78                	cmp    $0x78,%al
c0105d22:	75 0d                	jne    c0105d31 <strtol+0x83>
        s += 2, base = 16;
c0105d24:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105d28:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105d2f:	eb 2a                	jmp    c0105d5b <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105d31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d35:	75 17                	jne    c0105d4e <strtol+0xa0>
c0105d37:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d3a:	0f b6 00             	movzbl (%eax),%eax
c0105d3d:	3c 30                	cmp    $0x30,%al
c0105d3f:	75 0d                	jne    c0105d4e <strtol+0xa0>
        s ++, base = 8;
c0105d41:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d45:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105d4c:	eb 0d                	jmp    c0105d5b <strtol+0xad>
    }
    else if (base == 0) {
c0105d4e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d52:	75 07                	jne    c0105d5b <strtol+0xad>
        base = 10;
c0105d54:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105d5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d5e:	0f b6 00             	movzbl (%eax),%eax
c0105d61:	3c 2f                	cmp    $0x2f,%al
c0105d63:	7e 1b                	jle    c0105d80 <strtol+0xd2>
c0105d65:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d68:	0f b6 00             	movzbl (%eax),%eax
c0105d6b:	3c 39                	cmp    $0x39,%al
c0105d6d:	7f 11                	jg     c0105d80 <strtol+0xd2>
            dig = *s - '0';
c0105d6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d72:	0f b6 00             	movzbl (%eax),%eax
c0105d75:	0f be c0             	movsbl %al,%eax
c0105d78:	83 e8 30             	sub    $0x30,%eax
c0105d7b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d7e:	eb 48                	jmp    c0105dc8 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105d80:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d83:	0f b6 00             	movzbl (%eax),%eax
c0105d86:	3c 60                	cmp    $0x60,%al
c0105d88:	7e 1b                	jle    c0105da5 <strtol+0xf7>
c0105d8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d8d:	0f b6 00             	movzbl (%eax),%eax
c0105d90:	3c 7a                	cmp    $0x7a,%al
c0105d92:	7f 11                	jg     c0105da5 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105d94:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d97:	0f b6 00             	movzbl (%eax),%eax
c0105d9a:	0f be c0             	movsbl %al,%eax
c0105d9d:	83 e8 57             	sub    $0x57,%eax
c0105da0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105da3:	eb 23                	jmp    c0105dc8 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105da5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105da8:	0f b6 00             	movzbl (%eax),%eax
c0105dab:	3c 40                	cmp    $0x40,%al
c0105dad:	7e 3d                	jle    c0105dec <strtol+0x13e>
c0105daf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105db2:	0f b6 00             	movzbl (%eax),%eax
c0105db5:	3c 5a                	cmp    $0x5a,%al
c0105db7:	7f 33                	jg     c0105dec <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105db9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dbc:	0f b6 00             	movzbl (%eax),%eax
c0105dbf:	0f be c0             	movsbl %al,%eax
c0105dc2:	83 e8 37             	sub    $0x37,%eax
c0105dc5:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105dcb:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105dce:	7c 02                	jl     c0105dd2 <strtol+0x124>
            break;
c0105dd0:	eb 1a                	jmp    c0105dec <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105dd2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105dd6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105dd9:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105ddd:	89 c2                	mov    %eax,%edx
c0105ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105de2:	01 d0                	add    %edx,%eax
c0105de4:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105de7:	e9 6f ff ff ff       	jmp    c0105d5b <strtol+0xad>

    if (endptr) {
c0105dec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105df0:	74 08                	je     c0105dfa <strtol+0x14c>
        *endptr = (char *) s;
c0105df2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105df5:	8b 55 08             	mov    0x8(%ebp),%edx
c0105df8:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105dfa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105dfe:	74 07                	je     c0105e07 <strtol+0x159>
c0105e00:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105e03:	f7 d8                	neg    %eax
c0105e05:	eb 03                	jmp    c0105e0a <strtol+0x15c>
c0105e07:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105e0a:	c9                   	leave  
c0105e0b:	c3                   	ret    

c0105e0c <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105e0c:	55                   	push   %ebp
c0105e0d:	89 e5                	mov    %esp,%ebp
c0105e0f:	57                   	push   %edi
c0105e10:	83 ec 24             	sub    $0x24,%esp
c0105e13:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e16:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105e19:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105e1d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e20:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105e23:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105e26:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e29:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105e2c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105e2f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105e33:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105e36:	89 d7                	mov    %edx,%edi
c0105e38:	f3 aa                	rep stos %al,%es:(%edi)
c0105e3a:	89 fa                	mov    %edi,%edx
c0105e3c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105e3f:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105e42:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105e45:	83 c4 24             	add    $0x24,%esp
c0105e48:	5f                   	pop    %edi
c0105e49:	5d                   	pop    %ebp
c0105e4a:	c3                   	ret    

c0105e4b <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105e4b:	55                   	push   %ebp
c0105e4c:	89 e5                	mov    %esp,%ebp
c0105e4e:	57                   	push   %edi
c0105e4f:	56                   	push   %esi
c0105e50:	53                   	push   %ebx
c0105e51:	83 ec 30             	sub    $0x30,%esp
c0105e54:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e57:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e5a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e60:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e63:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105e66:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e69:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105e6c:	73 42                	jae    c0105eb0 <memmove+0x65>
c0105e6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e71:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e74:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e77:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105e7a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e7d:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e80:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e83:	c1 e8 02             	shr    $0x2,%eax
c0105e86:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105e88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105e8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e8e:	89 d7                	mov    %edx,%edi
c0105e90:	89 c6                	mov    %eax,%esi
c0105e92:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e94:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e97:	83 e1 03             	and    $0x3,%ecx
c0105e9a:	74 02                	je     c0105e9e <memmove+0x53>
c0105e9c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e9e:	89 f0                	mov    %esi,%eax
c0105ea0:	89 fa                	mov    %edi,%edx
c0105ea2:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105ea5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105ea8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105eab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105eae:	eb 36                	jmp    c0105ee6 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105eb0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105eb3:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105eb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105eb9:	01 c2                	add    %eax,%edx
c0105ebb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ebe:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105ec1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ec4:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105ec7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105eca:	89 c1                	mov    %eax,%ecx
c0105ecc:	89 d8                	mov    %ebx,%eax
c0105ece:	89 d6                	mov    %edx,%esi
c0105ed0:	89 c7                	mov    %eax,%edi
c0105ed2:	fd                   	std    
c0105ed3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105ed5:	fc                   	cld    
c0105ed6:	89 f8                	mov    %edi,%eax
c0105ed8:	89 f2                	mov    %esi,%edx
c0105eda:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105edd:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105ee0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105ee6:	83 c4 30             	add    $0x30,%esp
c0105ee9:	5b                   	pop    %ebx
c0105eea:	5e                   	pop    %esi
c0105eeb:	5f                   	pop    %edi
c0105eec:	5d                   	pop    %ebp
c0105eed:	c3                   	ret    

c0105eee <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105eee:	55                   	push   %ebp
c0105eef:	89 e5                	mov    %esp,%ebp
c0105ef1:	57                   	push   %edi
c0105ef2:	56                   	push   %esi
c0105ef3:	83 ec 20             	sub    $0x20,%esp
c0105ef6:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105efc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105eff:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f02:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f05:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105f08:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105f0b:	c1 e8 02             	shr    $0x2,%eax
c0105f0e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105f10:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f16:	89 d7                	mov    %edx,%edi
c0105f18:	89 c6                	mov    %eax,%esi
c0105f1a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105f1c:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105f1f:	83 e1 03             	and    $0x3,%ecx
c0105f22:	74 02                	je     c0105f26 <memcpy+0x38>
c0105f24:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105f26:	89 f0                	mov    %esi,%eax
c0105f28:	89 fa                	mov    %edi,%edx
c0105f2a:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105f2d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105f30:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105f36:	83 c4 20             	add    $0x20,%esp
c0105f39:	5e                   	pop    %esi
c0105f3a:	5f                   	pop    %edi
c0105f3b:	5d                   	pop    %ebp
c0105f3c:	c3                   	ret    

c0105f3d <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105f3d:	55                   	push   %ebp
c0105f3e:	89 e5                	mov    %esp,%ebp
c0105f40:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105f43:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f46:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105f49:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105f4f:	eb 30                	jmp    c0105f81 <memcmp+0x44>
        if (*s1 != *s2) {
c0105f51:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f54:	0f b6 10             	movzbl (%eax),%edx
c0105f57:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f5a:	0f b6 00             	movzbl (%eax),%eax
c0105f5d:	38 c2                	cmp    %al,%dl
c0105f5f:	74 18                	je     c0105f79 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105f61:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f64:	0f b6 00             	movzbl (%eax),%eax
c0105f67:	0f b6 d0             	movzbl %al,%edx
c0105f6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f6d:	0f b6 00             	movzbl (%eax),%eax
c0105f70:	0f b6 c0             	movzbl %al,%eax
c0105f73:	29 c2                	sub    %eax,%edx
c0105f75:	89 d0                	mov    %edx,%eax
c0105f77:	eb 1a                	jmp    c0105f93 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105f79:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105f7d:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105f81:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f84:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105f87:	89 55 10             	mov    %edx,0x10(%ebp)
c0105f8a:	85 c0                	test   %eax,%eax
c0105f8c:	75 c3                	jne    c0105f51 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105f8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f93:	c9                   	leave  
c0105f94:	c3                   	ret    
