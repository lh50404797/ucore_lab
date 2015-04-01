
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 60 11 00 	lgdtl  0x116018
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
c010001e:	bc 00 60 11 c0       	mov    $0xc0116000,%esp
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
c0100030:	ba 68 79 11 c0       	mov    $0xc0117968,%edx
c0100035:	b8 36 6a 11 c0       	mov    $0xc0116a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 6a 11 c0 	movl   $0xc0116a36,(%esp)
c0100051:	e8 be 59 00 00       	call   c0105a14 <memset>

    cons_init();                // init the console
c0100056:	e8 b7 14 00 00       	call   c0101512 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 a0 5b 10 c0 	movl   $0xc0105ba0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 bc 5b 10 c0 	movl   $0xc0105bbc,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 3b 40 00 00       	call   c01040bf <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 f2 15 00 00       	call   c010167b <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 44 17 00 00       	call   c01017d2 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 35 0c 00 00       	call   c0100cc8 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 51 15 00 00       	call   c01015e9 <intr_enable>
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
c01000b7:	e8 3e 0b 00 00       	call   c0100bfa <mon_backtrace>
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
c0100148:	a1 40 6a 11 c0       	mov    0xc0116a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 c1 5b 10 c0 	movl   $0xc0105bc1,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 6a 11 c0       	mov    0xc0116a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 cf 5b 10 c0 	movl   $0xc0105bcf,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 6a 11 c0       	mov    0xc0116a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 dd 5b 10 c0 	movl   $0xc0105bdd,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 6a 11 c0       	mov    0xc0116a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 eb 5b 10 c0 	movl   $0xc0105beb,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 6a 11 c0       	mov    0xc0116a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 f9 5b 10 c0 	movl   $0xc0105bf9,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 6a 11 c0       	mov    0xc0116a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 6a 11 c0       	mov    %eax,0xc0116a40
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
c0100205:	c7 04 24 08 5c 10 c0 	movl   $0xc0105c08,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 28 5c 10 c0 	movl   $0xc0105c28,(%esp)
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
c0100246:	c7 04 24 47 5c 10 c0 	movl   $0xc0105c47,(%esp)
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
c0100294:	88 90 60 6a 11 c0    	mov    %dl,-0x3fee95a0(%eax)
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
c01002d3:	05 60 6a 11 c0       	add    $0xc0116a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 6a 11 c0       	mov    $0xc0116a60,%eax
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
c01002f5:	e8 44 12 00 00       	call   c010153e <cons_putc>
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
c0100332:	e8 f6 4e 00 00       	call   c010522d <vprintfmt>
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
c010036e:	e8 cb 11 00 00       	call   c010153e <cons_putc>
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
c01003ca:	e8 ab 11 00 00       	call   c010157a <cons_getc>
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
c010053c:	c7 00 4c 5c 10 c0    	movl   $0xc0105c4c,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 4c 5c 10 c0 	movl   $0xc0105c4c,0x8(%eax)
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
c0100573:	c7 45 f4 60 6e 10 c0 	movl   $0xc0106e60,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 e8 15 11 c0 	movl   $0xc01115e8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec e9 15 11 c0 	movl   $0xc01115e9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 e3 3f 11 c0 	movl   $0xc0113fe3,-0x18(%ebp)

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
c01006e7:	e8 9c 51 00 00       	call   c0105888 <strfind>
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
c0100876:	c7 04 24 56 5c 10 c0 	movl   $0xc0105c56,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 6f 5c 10 c0 	movl   $0xc0105c6f,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 9d 5b 10 	movl   $0xc0105b9d,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 87 5c 10 c0 	movl   $0xc0105c87,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 6a 11 	movl   $0xc0116a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 9f 5c 10 c0 	movl   $0xc0105c9f,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 68 79 11 	movl   $0xc0117968,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 b7 5c 10 c0 	movl   $0xc0105cb7,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 68 79 11 c0       	mov    $0xc0117968,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 d0 5c 10 c0 	movl   $0xc0105cd0,(%esp)
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
c010092c:	c7 04 24 fa 5c 10 c0 	movl   $0xc0105cfa,(%esp)
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
c010099b:	c7 04 24 16 5d 10 c0 	movl   $0xc0105d16,(%esp)
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
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
}
c01009bd:	5d                   	pop    %ebp
c01009be:	c3                   	ret    

c01009bf <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c01009bf:	55                   	push   %ebp
c01009c0:	89 e5                	mov    %esp,%ebp
c01009c2:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c01009c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c01009cc:	eb 0c                	jmp    c01009da <parse+0x1b>
            *buf ++ = '\0';
c01009ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01009d1:	8d 50 01             	lea    0x1(%eax),%edx
c01009d4:	89 55 08             	mov    %edx,0x8(%ebp)
c01009d7:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c01009da:	8b 45 08             	mov    0x8(%ebp),%eax
c01009dd:	0f b6 00             	movzbl (%eax),%eax
c01009e0:	84 c0                	test   %al,%al
c01009e2:	74 1d                	je     c0100a01 <parse+0x42>
c01009e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01009e7:	0f b6 00             	movzbl (%eax),%eax
c01009ea:	0f be c0             	movsbl %al,%eax
c01009ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f1:	c7 04 24 a8 5d 10 c0 	movl   $0xc0105da8,(%esp)
c01009f8:	e8 58 4e 00 00       	call   c0105855 <strchr>
c01009fd:	85 c0                	test   %eax,%eax
c01009ff:	75 cd                	jne    c01009ce <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100a01:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a04:	0f b6 00             	movzbl (%eax),%eax
c0100a07:	84 c0                	test   %al,%al
c0100a09:	75 02                	jne    c0100a0d <parse+0x4e>
            break;
c0100a0b:	eb 67                	jmp    c0100a74 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100a0d:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100a11:	75 14                	jne    c0100a27 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100a13:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100a1a:	00 
c0100a1b:	c7 04 24 ad 5d 10 c0 	movl   $0xc0105dad,(%esp)
c0100a22:	e8 15 f9 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a2a:	8d 50 01             	lea    0x1(%eax),%edx
c0100a2d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100a30:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a37:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100a3a:	01 c2                	add    %eax,%edx
c0100a3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a3f:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100a41:	eb 04                	jmp    c0100a47 <parse+0x88>
            buf ++;
c0100a43:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100a47:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a4a:	0f b6 00             	movzbl (%eax),%eax
c0100a4d:	84 c0                	test   %al,%al
c0100a4f:	74 1d                	je     c0100a6e <parse+0xaf>
c0100a51:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a54:	0f b6 00             	movzbl (%eax),%eax
c0100a57:	0f be c0             	movsbl %al,%eax
c0100a5a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a5e:	c7 04 24 a8 5d 10 c0 	movl   $0xc0105da8,(%esp)
c0100a65:	e8 eb 4d 00 00       	call   c0105855 <strchr>
c0100a6a:	85 c0                	test   %eax,%eax
c0100a6c:	74 d5                	je     c0100a43 <parse+0x84>
            buf ++;
        }
    }
c0100a6e:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a6f:	e9 66 ff ff ff       	jmp    c01009da <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100a77:	c9                   	leave  
c0100a78:	c3                   	ret    

c0100a79 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100a79:	55                   	push   %ebp
c0100a7a:	89 e5                	mov    %esp,%ebp
c0100a7c:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100a7f:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100a82:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a86:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a89:	89 04 24             	mov    %eax,(%esp)
c0100a8c:	e8 2e ff ff ff       	call   c01009bf <parse>
c0100a91:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100a94:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100a98:	75 0a                	jne    c0100aa4 <runcmd+0x2b>
        return 0;
c0100a9a:	b8 00 00 00 00       	mov    $0x0,%eax
c0100a9f:	e9 85 00 00 00       	jmp    c0100b29 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100aa4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100aab:	eb 5c                	jmp    c0100b09 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100aad:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100ab0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ab3:	89 d0                	mov    %edx,%eax
c0100ab5:	01 c0                	add    %eax,%eax
c0100ab7:	01 d0                	add    %edx,%eax
c0100ab9:	c1 e0 02             	shl    $0x2,%eax
c0100abc:	05 20 60 11 c0       	add    $0xc0116020,%eax
c0100ac1:	8b 00                	mov    (%eax),%eax
c0100ac3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100ac7:	89 04 24             	mov    %eax,(%esp)
c0100aca:	e8 e7 4c 00 00       	call   c01057b6 <strcmp>
c0100acf:	85 c0                	test   %eax,%eax
c0100ad1:	75 32                	jne    c0100b05 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100ad3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100ad6:	89 d0                	mov    %edx,%eax
c0100ad8:	01 c0                	add    %eax,%eax
c0100ada:	01 d0                	add    %edx,%eax
c0100adc:	c1 e0 02             	shl    $0x2,%eax
c0100adf:	05 20 60 11 c0       	add    $0xc0116020,%eax
c0100ae4:	8b 40 08             	mov    0x8(%eax),%eax
c0100ae7:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100aea:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100aed:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100af0:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100af4:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100af7:	83 c2 04             	add    $0x4,%edx
c0100afa:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100afe:	89 0c 24             	mov    %ecx,(%esp)
c0100b01:	ff d0                	call   *%eax
c0100b03:	eb 24                	jmp    c0100b29 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b05:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100b09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b0c:	83 f8 02             	cmp    $0x2,%eax
c0100b0f:	76 9c                	jbe    c0100aad <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100b11:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100b14:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b18:	c7 04 24 cb 5d 10 c0 	movl   $0xc0105dcb,(%esp)
c0100b1f:	e8 18 f8 ff ff       	call   c010033c <cprintf>
    return 0;
c0100b24:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100b29:	c9                   	leave  
c0100b2a:	c3                   	ret    

c0100b2b <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100b2b:	55                   	push   %ebp
c0100b2c:	89 e5                	mov    %esp,%ebp
c0100b2e:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100b31:	c7 04 24 e4 5d 10 c0 	movl   $0xc0105de4,(%esp)
c0100b38:	e8 ff f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100b3d:	c7 04 24 0c 5e 10 c0 	movl   $0xc0105e0c,(%esp)
c0100b44:	e8 f3 f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100b49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100b4d:	74 0b                	je     c0100b5a <kmonitor+0x2f>
        print_trapframe(tf);
c0100b4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b52:	89 04 24             	mov    %eax,(%esp)
c0100b55:	e8 c4 0c 00 00       	call   c010181e <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100b5a:	c7 04 24 31 5e 10 c0 	movl   $0xc0105e31,(%esp)
c0100b61:	e8 cd f6 ff ff       	call   c0100233 <readline>
c0100b66:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100b69:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b6d:	74 18                	je     c0100b87 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100b6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b79:	89 04 24             	mov    %eax,(%esp)
c0100b7c:	e8 f8 fe ff ff       	call   c0100a79 <runcmd>
c0100b81:	85 c0                	test   %eax,%eax
c0100b83:	79 02                	jns    c0100b87 <kmonitor+0x5c>
                break;
c0100b85:	eb 02                	jmp    c0100b89 <kmonitor+0x5e>
            }
        }
    }
c0100b87:	eb d1                	jmp    c0100b5a <kmonitor+0x2f>
}
c0100b89:	c9                   	leave  
c0100b8a:	c3                   	ret    

c0100b8b <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100b8b:	55                   	push   %ebp
c0100b8c:	89 e5                	mov    %esp,%ebp
c0100b8e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b98:	eb 3f                	jmp    c0100bd9 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100b9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b9d:	89 d0                	mov    %edx,%eax
c0100b9f:	01 c0                	add    %eax,%eax
c0100ba1:	01 d0                	add    %edx,%eax
c0100ba3:	c1 e0 02             	shl    $0x2,%eax
c0100ba6:	05 20 60 11 c0       	add    $0xc0116020,%eax
c0100bab:	8b 48 04             	mov    0x4(%eax),%ecx
c0100bae:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100bb1:	89 d0                	mov    %edx,%eax
c0100bb3:	01 c0                	add    %eax,%eax
c0100bb5:	01 d0                	add    %edx,%eax
c0100bb7:	c1 e0 02             	shl    $0x2,%eax
c0100bba:	05 20 60 11 c0       	add    $0xc0116020,%eax
c0100bbf:	8b 00                	mov    (%eax),%eax
c0100bc1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100bc5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bc9:	c7 04 24 35 5e 10 c0 	movl   $0xc0105e35,(%esp)
c0100bd0:	e8 67 f7 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bd5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bdc:	83 f8 02             	cmp    $0x2,%eax
c0100bdf:	76 b9                	jbe    c0100b9a <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100be1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100be6:	c9                   	leave  
c0100be7:	c3                   	ret    

c0100be8 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100be8:	55                   	push   %ebp
c0100be9:	89 e5                	mov    %esp,%ebp
c0100beb:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100bee:	e8 7d fc ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100bf3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bf8:	c9                   	leave  
c0100bf9:	c3                   	ret    

c0100bfa <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100bfa:	55                   	push   %ebp
c0100bfb:	89 e5                	mov    %esp,%ebp
c0100bfd:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100c00:	e8 b5 fd ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100c05:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c0a:	c9                   	leave  
c0100c0b:	c3                   	ret    

c0100c0c <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100c0c:	55                   	push   %ebp
c0100c0d:	89 e5                	mov    %esp,%ebp
c0100c0f:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100c12:	a1 60 6e 11 c0       	mov    0xc0116e60,%eax
c0100c17:	85 c0                	test   %eax,%eax
c0100c19:	74 02                	je     c0100c1d <__panic+0x11>
        goto panic_dead;
c0100c1b:	eb 48                	jmp    c0100c65 <__panic+0x59>
    }
    is_panic = 1;
c0100c1d:	c7 05 60 6e 11 c0 01 	movl   $0x1,0xc0116e60
c0100c24:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100c27:	8d 45 14             	lea    0x14(%ebp),%eax
c0100c2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c30:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100c34:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c3b:	c7 04 24 3e 5e 10 c0 	movl   $0xc0105e3e,(%esp)
c0100c42:	e8 f5 f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c4a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c4e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100c51:	89 04 24             	mov    %eax,(%esp)
c0100c54:	e8 b0 f6 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100c59:	c7 04 24 5a 5e 10 c0 	movl   $0xc0105e5a,(%esp)
c0100c60:	e8 d7 f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100c65:	e8 85 09 00 00       	call   c01015ef <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100c6a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100c71:	e8 b5 fe ff ff       	call   c0100b2b <kmonitor>
    }
c0100c76:	eb f2                	jmp    c0100c6a <__panic+0x5e>

c0100c78 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100c78:	55                   	push   %ebp
c0100c79:	89 e5                	mov    %esp,%ebp
c0100c7b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100c7e:	8d 45 14             	lea    0x14(%ebp),%eax
c0100c81:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100c84:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c87:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100c8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c8e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c92:	c7 04 24 5c 5e 10 c0 	movl   $0xc0105e5c,(%esp)
c0100c99:	e8 9e f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ca1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ca5:	8b 45 10             	mov    0x10(%ebp),%eax
c0100ca8:	89 04 24             	mov    %eax,(%esp)
c0100cab:	e8 59 f6 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100cb0:	c7 04 24 5a 5e 10 c0 	movl   $0xc0105e5a,(%esp)
c0100cb7:	e8 80 f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100cbc:	c9                   	leave  
c0100cbd:	c3                   	ret    

c0100cbe <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100cbe:	55                   	push   %ebp
c0100cbf:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100cc1:	a1 60 6e 11 c0       	mov    0xc0116e60,%eax
}
c0100cc6:	5d                   	pop    %ebp
c0100cc7:	c3                   	ret    

c0100cc8 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100cc8:	55                   	push   %ebp
c0100cc9:	89 e5                	mov    %esp,%ebp
c0100ccb:	83 ec 28             	sub    $0x28,%esp
c0100cce:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100cd4:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100cd8:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100cdc:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100ce0:	ee                   	out    %al,(%dx)
c0100ce1:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100ce7:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100ceb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100cef:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100cf3:	ee                   	out    %al,(%dx)
c0100cf4:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100cfa:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100cfe:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100d02:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100d06:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100d07:	c7 05 4c 79 11 c0 00 	movl   $0x0,0xc011794c
c0100d0e:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100d11:	c7 04 24 7a 5e 10 c0 	movl   $0xc0105e7a,(%esp)
c0100d18:	e8 1f f6 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100d1d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d24:	e8 24 09 00 00       	call   c010164d <pic_enable>
}
c0100d29:	c9                   	leave  
c0100d2a:	c3                   	ret    

c0100d2b <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100d2b:	55                   	push   %ebp
c0100d2c:	89 e5                	mov    %esp,%ebp
c0100d2e:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100d31:	9c                   	pushf  
c0100d32:	58                   	pop    %eax
c0100d33:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100d36:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100d39:	25 00 02 00 00       	and    $0x200,%eax
c0100d3e:	85 c0                	test   %eax,%eax
c0100d40:	74 0c                	je     c0100d4e <__intr_save+0x23>
        intr_disable();
c0100d42:	e8 a8 08 00 00       	call   c01015ef <intr_disable>
        return 1;
c0100d47:	b8 01 00 00 00       	mov    $0x1,%eax
c0100d4c:	eb 05                	jmp    c0100d53 <__intr_save+0x28>
    }
    return 0;
c0100d4e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d53:	c9                   	leave  
c0100d54:	c3                   	ret    

c0100d55 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100d55:	55                   	push   %ebp
c0100d56:	89 e5                	mov    %esp,%ebp
c0100d58:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100d5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100d5f:	74 05                	je     c0100d66 <__intr_restore+0x11>
        intr_enable();
c0100d61:	e8 83 08 00 00       	call   c01015e9 <intr_enable>
    }
}
c0100d66:	c9                   	leave  
c0100d67:	c3                   	ret    

c0100d68 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100d68:	55                   	push   %ebp
c0100d69:	89 e5                	mov    %esp,%ebp
c0100d6b:	83 ec 10             	sub    $0x10,%esp
c0100d6e:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100d74:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100d78:	89 c2                	mov    %eax,%edx
c0100d7a:	ec                   	in     (%dx),%al
c0100d7b:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100d7e:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100d84:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100d88:	89 c2                	mov    %eax,%edx
c0100d8a:	ec                   	in     (%dx),%al
c0100d8b:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100d8e:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100d94:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100d98:	89 c2                	mov    %eax,%edx
c0100d9a:	ec                   	in     (%dx),%al
c0100d9b:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100d9e:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100da4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100da8:	89 c2                	mov    %eax,%edx
c0100daa:	ec                   	in     (%dx),%al
c0100dab:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100dae:	c9                   	leave  
c0100daf:	c3                   	ret    

c0100db0 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100db0:	55                   	push   %ebp
c0100db1:	89 e5                	mov    %esp,%ebp
c0100db3:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100db6:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100dbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dc0:	0f b7 00             	movzwl (%eax),%eax
c0100dc3:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100dc7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dca:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100dcf:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100dd2:	0f b7 00             	movzwl (%eax),%eax
c0100dd5:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100dd9:	74 12                	je     c0100ded <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ddb:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100de2:	66 c7 05 86 6e 11 c0 	movw   $0x3b4,0xc0116e86
c0100de9:	b4 03 
c0100deb:	eb 13                	jmp    c0100e00 <cga_init+0x50>
    } else {
        *cp = was;
c0100ded:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100df0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100df4:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100df7:	66 c7 05 86 6e 11 c0 	movw   $0x3d4,0xc0116e86
c0100dfe:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100e00:	0f b7 05 86 6e 11 c0 	movzwl 0xc0116e86,%eax
c0100e07:	0f b7 c0             	movzwl %ax,%eax
c0100e0a:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100e0e:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e12:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100e16:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e1a:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100e1b:	0f b7 05 86 6e 11 c0 	movzwl 0xc0116e86,%eax
c0100e22:	83 c0 01             	add    $0x1,%eax
c0100e25:	0f b7 c0             	movzwl %ax,%eax
c0100e28:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e2c:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100e30:	89 c2                	mov    %eax,%edx
c0100e32:	ec                   	in     (%dx),%al
c0100e33:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100e36:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100e3a:	0f b6 c0             	movzbl %al,%eax
c0100e3d:	c1 e0 08             	shl    $0x8,%eax
c0100e40:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100e43:	0f b7 05 86 6e 11 c0 	movzwl 0xc0116e86,%eax
c0100e4a:	0f b7 c0             	movzwl %ax,%eax
c0100e4d:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100e51:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e55:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100e59:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e5d:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100e5e:	0f b7 05 86 6e 11 c0 	movzwl 0xc0116e86,%eax
c0100e65:	83 c0 01             	add    $0x1,%eax
c0100e68:	0f b7 c0             	movzwl %ax,%eax
c0100e6b:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e6f:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100e73:	89 c2                	mov    %eax,%edx
c0100e75:	ec                   	in     (%dx),%al
c0100e76:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100e79:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100e7d:	0f b6 c0             	movzbl %al,%eax
c0100e80:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100e83:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e86:	a3 80 6e 11 c0       	mov    %eax,0xc0116e80
    crt_pos = pos;
c0100e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e8e:	66 a3 84 6e 11 c0    	mov    %ax,0xc0116e84
}
c0100e94:	c9                   	leave  
c0100e95:	c3                   	ret    

c0100e96 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100e96:	55                   	push   %ebp
c0100e97:	89 e5                	mov    %esp,%ebp
c0100e99:	83 ec 48             	sub    $0x48,%esp
c0100e9c:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100ea2:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ea6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100eaa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100eae:	ee                   	out    %al,(%dx)
c0100eaf:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100eb5:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100eb9:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ebd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ec1:	ee                   	out    %al,(%dx)
c0100ec2:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100ec8:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100ecc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ed0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100ed4:	ee                   	out    %al,(%dx)
c0100ed5:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100edb:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100edf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100ee3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100ee7:	ee                   	out    %al,(%dx)
c0100ee8:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100eee:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100ef2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100ef6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100efa:	ee                   	out    %al,(%dx)
c0100efb:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100f01:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100f05:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100f09:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100f0d:	ee                   	out    %al,(%dx)
c0100f0e:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100f14:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100f18:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f1c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100f20:	ee                   	out    %al,(%dx)
c0100f21:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f27:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100f2b:	89 c2                	mov    %eax,%edx
c0100f2d:	ec                   	in     (%dx),%al
c0100f2e:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100f31:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100f35:	3c ff                	cmp    $0xff,%al
c0100f37:	0f 95 c0             	setne  %al
c0100f3a:	0f b6 c0             	movzbl %al,%eax
c0100f3d:	a3 88 6e 11 c0       	mov    %eax,0xc0116e88
c0100f42:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f48:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c0100f4c:	89 c2                	mov    %eax,%edx
c0100f4e:	ec                   	in     (%dx),%al
c0100f4f:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0100f52:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0100f58:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c0100f5c:	89 c2                	mov    %eax,%edx
c0100f5e:	ec                   	in     (%dx),%al
c0100f5f:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0100f62:	a1 88 6e 11 c0       	mov    0xc0116e88,%eax
c0100f67:	85 c0                	test   %eax,%eax
c0100f69:	74 0c                	je     c0100f77 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0100f6b:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0100f72:	e8 d6 06 00 00       	call   c010164d <pic_enable>
    }
}
c0100f77:	c9                   	leave  
c0100f78:	c3                   	ret    

c0100f79 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0100f79:	55                   	push   %ebp
c0100f7a:	89 e5                	mov    %esp,%ebp
c0100f7c:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0100f7f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0100f86:	eb 09                	jmp    c0100f91 <lpt_putc_sub+0x18>
        delay();
c0100f88:	e8 db fd ff ff       	call   c0100d68 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0100f8d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0100f91:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0100f97:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100f9b:	89 c2                	mov    %eax,%edx
c0100f9d:	ec                   	in     (%dx),%al
c0100f9e:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0100fa1:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0100fa5:	84 c0                	test   %al,%al
c0100fa7:	78 09                	js     c0100fb2 <lpt_putc_sub+0x39>
c0100fa9:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0100fb0:	7e d6                	jle    c0100f88 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0100fb2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100fb5:	0f b6 c0             	movzbl %al,%eax
c0100fb8:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c0100fbe:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fc1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100fc5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100fc9:	ee                   	out    %al,(%dx)
c0100fca:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0100fd0:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0100fd4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fd8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fdc:	ee                   	out    %al,(%dx)
c0100fdd:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c0100fe3:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c0100fe7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100feb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fef:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0100ff0:	c9                   	leave  
c0100ff1:	c3                   	ret    

c0100ff2 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0100ff2:	55                   	push   %ebp
c0100ff3:	89 e5                	mov    %esp,%ebp
c0100ff5:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0100ff8:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0100ffc:	74 0d                	je     c010100b <lpt_putc+0x19>
        lpt_putc_sub(c);
c0100ffe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101001:	89 04 24             	mov    %eax,(%esp)
c0101004:	e8 70 ff ff ff       	call   c0100f79 <lpt_putc_sub>
c0101009:	eb 24                	jmp    c010102f <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c010100b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101012:	e8 62 ff ff ff       	call   c0100f79 <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101017:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010101e:	e8 56 ff ff ff       	call   c0100f79 <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101023:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010102a:	e8 4a ff ff ff       	call   c0100f79 <lpt_putc_sub>
    }
}
c010102f:	c9                   	leave  
c0101030:	c3                   	ret    

c0101031 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101031:	55                   	push   %ebp
c0101032:	89 e5                	mov    %esp,%ebp
c0101034:	53                   	push   %ebx
c0101035:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101038:	8b 45 08             	mov    0x8(%ebp),%eax
c010103b:	b0 00                	mov    $0x0,%al
c010103d:	85 c0                	test   %eax,%eax
c010103f:	75 07                	jne    c0101048 <cga_putc+0x17>
        c |= 0x0700;
c0101041:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101048:	8b 45 08             	mov    0x8(%ebp),%eax
c010104b:	0f b6 c0             	movzbl %al,%eax
c010104e:	83 f8 0a             	cmp    $0xa,%eax
c0101051:	74 4c                	je     c010109f <cga_putc+0x6e>
c0101053:	83 f8 0d             	cmp    $0xd,%eax
c0101056:	74 57                	je     c01010af <cga_putc+0x7e>
c0101058:	83 f8 08             	cmp    $0x8,%eax
c010105b:	0f 85 88 00 00 00    	jne    c01010e9 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101061:	0f b7 05 84 6e 11 c0 	movzwl 0xc0116e84,%eax
c0101068:	66 85 c0             	test   %ax,%ax
c010106b:	74 30                	je     c010109d <cga_putc+0x6c>
            crt_pos --;
c010106d:	0f b7 05 84 6e 11 c0 	movzwl 0xc0116e84,%eax
c0101074:	83 e8 01             	sub    $0x1,%eax
c0101077:	66 a3 84 6e 11 c0    	mov    %ax,0xc0116e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010107d:	a1 80 6e 11 c0       	mov    0xc0116e80,%eax
c0101082:	0f b7 15 84 6e 11 c0 	movzwl 0xc0116e84,%edx
c0101089:	0f b7 d2             	movzwl %dx,%edx
c010108c:	01 d2                	add    %edx,%edx
c010108e:	01 c2                	add    %eax,%edx
c0101090:	8b 45 08             	mov    0x8(%ebp),%eax
c0101093:	b0 00                	mov    $0x0,%al
c0101095:	83 c8 20             	or     $0x20,%eax
c0101098:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010109b:	eb 72                	jmp    c010110f <cga_putc+0xde>
c010109d:	eb 70                	jmp    c010110f <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c010109f:	0f b7 05 84 6e 11 c0 	movzwl 0xc0116e84,%eax
c01010a6:	83 c0 50             	add    $0x50,%eax
c01010a9:	66 a3 84 6e 11 c0    	mov    %ax,0xc0116e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01010af:	0f b7 1d 84 6e 11 c0 	movzwl 0xc0116e84,%ebx
c01010b6:	0f b7 0d 84 6e 11 c0 	movzwl 0xc0116e84,%ecx
c01010bd:	0f b7 c1             	movzwl %cx,%eax
c01010c0:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01010c6:	c1 e8 10             	shr    $0x10,%eax
c01010c9:	89 c2                	mov    %eax,%edx
c01010cb:	66 c1 ea 06          	shr    $0x6,%dx
c01010cf:	89 d0                	mov    %edx,%eax
c01010d1:	c1 e0 02             	shl    $0x2,%eax
c01010d4:	01 d0                	add    %edx,%eax
c01010d6:	c1 e0 04             	shl    $0x4,%eax
c01010d9:	29 c1                	sub    %eax,%ecx
c01010db:	89 ca                	mov    %ecx,%edx
c01010dd:	89 d8                	mov    %ebx,%eax
c01010df:	29 d0                	sub    %edx,%eax
c01010e1:	66 a3 84 6e 11 c0    	mov    %ax,0xc0116e84
        break;
c01010e7:	eb 26                	jmp    c010110f <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01010e9:	8b 0d 80 6e 11 c0    	mov    0xc0116e80,%ecx
c01010ef:	0f b7 05 84 6e 11 c0 	movzwl 0xc0116e84,%eax
c01010f6:	8d 50 01             	lea    0x1(%eax),%edx
c01010f9:	66 89 15 84 6e 11 c0 	mov    %dx,0xc0116e84
c0101100:	0f b7 c0             	movzwl %ax,%eax
c0101103:	01 c0                	add    %eax,%eax
c0101105:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c0101108:	8b 45 08             	mov    0x8(%ebp),%eax
c010110b:	66 89 02             	mov    %ax,(%edx)
        break;
c010110e:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c010110f:	0f b7 05 84 6e 11 c0 	movzwl 0xc0116e84,%eax
c0101116:	66 3d cf 07          	cmp    $0x7cf,%ax
c010111a:	76 5b                	jbe    c0101177 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c010111c:	a1 80 6e 11 c0       	mov    0xc0116e80,%eax
c0101121:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101127:	a1 80 6e 11 c0       	mov    0xc0116e80,%eax
c010112c:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101133:	00 
c0101134:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101138:	89 04 24             	mov    %eax,(%esp)
c010113b:	e8 13 49 00 00       	call   c0105a53 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101140:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101147:	eb 15                	jmp    c010115e <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c0101149:	a1 80 6e 11 c0       	mov    0xc0116e80,%eax
c010114e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101151:	01 d2                	add    %edx,%edx
c0101153:	01 d0                	add    %edx,%eax
c0101155:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010115a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010115e:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101165:	7e e2                	jle    c0101149 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101167:	0f b7 05 84 6e 11 c0 	movzwl 0xc0116e84,%eax
c010116e:	83 e8 50             	sub    $0x50,%eax
c0101171:	66 a3 84 6e 11 c0    	mov    %ax,0xc0116e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101177:	0f b7 05 86 6e 11 c0 	movzwl 0xc0116e86,%eax
c010117e:	0f b7 c0             	movzwl %ax,%eax
c0101181:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101185:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c0101189:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010118d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101191:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101192:	0f b7 05 84 6e 11 c0 	movzwl 0xc0116e84,%eax
c0101199:	66 c1 e8 08          	shr    $0x8,%ax
c010119d:	0f b6 c0             	movzbl %al,%eax
c01011a0:	0f b7 15 86 6e 11 c0 	movzwl 0xc0116e86,%edx
c01011a7:	83 c2 01             	add    $0x1,%edx
c01011aa:	0f b7 d2             	movzwl %dx,%edx
c01011ad:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c01011b1:	88 45 ed             	mov    %al,-0x13(%ebp)
c01011b4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01011b8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01011bc:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01011bd:	0f b7 05 86 6e 11 c0 	movzwl 0xc0116e86,%eax
c01011c4:	0f b7 c0             	movzwl %ax,%eax
c01011c7:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01011cb:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01011cf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01011d3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01011d7:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01011d8:	0f b7 05 84 6e 11 c0 	movzwl 0xc0116e84,%eax
c01011df:	0f b6 c0             	movzbl %al,%eax
c01011e2:	0f b7 15 86 6e 11 c0 	movzwl 0xc0116e86,%edx
c01011e9:	83 c2 01             	add    $0x1,%edx
c01011ec:	0f b7 d2             	movzwl %dx,%edx
c01011ef:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01011f3:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01011f6:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01011fa:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01011fe:	ee                   	out    %al,(%dx)
}
c01011ff:	83 c4 34             	add    $0x34,%esp
c0101202:	5b                   	pop    %ebx
c0101203:	5d                   	pop    %ebp
c0101204:	c3                   	ret    

c0101205 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101205:	55                   	push   %ebp
c0101206:	89 e5                	mov    %esp,%ebp
c0101208:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010120b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101212:	eb 09                	jmp    c010121d <serial_putc_sub+0x18>
        delay();
c0101214:	e8 4f fb ff ff       	call   c0100d68 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101219:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010121d:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101223:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101227:	89 c2                	mov    %eax,%edx
c0101229:	ec                   	in     (%dx),%al
c010122a:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010122d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101231:	0f b6 c0             	movzbl %al,%eax
c0101234:	83 e0 20             	and    $0x20,%eax
c0101237:	85 c0                	test   %eax,%eax
c0101239:	75 09                	jne    c0101244 <serial_putc_sub+0x3f>
c010123b:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101242:	7e d0                	jle    c0101214 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101244:	8b 45 08             	mov    0x8(%ebp),%eax
c0101247:	0f b6 c0             	movzbl %al,%eax
c010124a:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101250:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101253:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101257:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010125b:	ee                   	out    %al,(%dx)
}
c010125c:	c9                   	leave  
c010125d:	c3                   	ret    

c010125e <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010125e:	55                   	push   %ebp
c010125f:	89 e5                	mov    %esp,%ebp
c0101261:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101264:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101268:	74 0d                	je     c0101277 <serial_putc+0x19>
        serial_putc_sub(c);
c010126a:	8b 45 08             	mov    0x8(%ebp),%eax
c010126d:	89 04 24             	mov    %eax,(%esp)
c0101270:	e8 90 ff ff ff       	call   c0101205 <serial_putc_sub>
c0101275:	eb 24                	jmp    c010129b <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101277:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010127e:	e8 82 ff ff ff       	call   c0101205 <serial_putc_sub>
        serial_putc_sub(' ');
c0101283:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010128a:	e8 76 ff ff ff       	call   c0101205 <serial_putc_sub>
        serial_putc_sub('\b');
c010128f:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101296:	e8 6a ff ff ff       	call   c0101205 <serial_putc_sub>
    }
}
c010129b:	c9                   	leave  
c010129c:	c3                   	ret    

c010129d <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010129d:	55                   	push   %ebp
c010129e:	89 e5                	mov    %esp,%ebp
c01012a0:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01012a3:	eb 33                	jmp    c01012d8 <cons_intr+0x3b>
        if (c != 0) {
c01012a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01012a9:	74 2d                	je     c01012d8 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c01012ab:	a1 a4 70 11 c0       	mov    0xc01170a4,%eax
c01012b0:	8d 50 01             	lea    0x1(%eax),%edx
c01012b3:	89 15 a4 70 11 c0    	mov    %edx,0xc01170a4
c01012b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01012bc:	88 90 a0 6e 11 c0    	mov    %dl,-0x3fee9160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c01012c2:	a1 a4 70 11 c0       	mov    0xc01170a4,%eax
c01012c7:	3d 00 02 00 00       	cmp    $0x200,%eax
c01012cc:	75 0a                	jne    c01012d8 <cons_intr+0x3b>
                cons.wpos = 0;
c01012ce:	c7 05 a4 70 11 c0 00 	movl   $0x0,0xc01170a4
c01012d5:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01012d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01012db:	ff d0                	call   *%eax
c01012dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01012e0:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01012e4:	75 bf                	jne    c01012a5 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01012e6:	c9                   	leave  
c01012e7:	c3                   	ret    

c01012e8 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01012e8:	55                   	push   %ebp
c01012e9:	89 e5                	mov    %esp,%ebp
c01012eb:	83 ec 10             	sub    $0x10,%esp
c01012ee:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012f4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012f8:	89 c2                	mov    %eax,%edx
c01012fa:	ec                   	in     (%dx),%al
c01012fb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012fe:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101302:	0f b6 c0             	movzbl %al,%eax
c0101305:	83 e0 01             	and    $0x1,%eax
c0101308:	85 c0                	test   %eax,%eax
c010130a:	75 07                	jne    c0101313 <serial_proc_data+0x2b>
        return -1;
c010130c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101311:	eb 2a                	jmp    c010133d <serial_proc_data+0x55>
c0101313:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101319:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010131d:	89 c2                	mov    %eax,%edx
c010131f:	ec                   	in     (%dx),%al
c0101320:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c0101323:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101327:	0f b6 c0             	movzbl %al,%eax
c010132a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c010132d:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c0101331:	75 07                	jne    c010133a <serial_proc_data+0x52>
        c = '\b';
c0101333:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c010133a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010133d:	c9                   	leave  
c010133e:	c3                   	ret    

c010133f <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c010133f:	55                   	push   %ebp
c0101340:	89 e5                	mov    %esp,%ebp
c0101342:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101345:	a1 88 6e 11 c0       	mov    0xc0116e88,%eax
c010134a:	85 c0                	test   %eax,%eax
c010134c:	74 0c                	je     c010135a <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010134e:	c7 04 24 e8 12 10 c0 	movl   $0xc01012e8,(%esp)
c0101355:	e8 43 ff ff ff       	call   c010129d <cons_intr>
    }
}
c010135a:	c9                   	leave  
c010135b:	c3                   	ret    

c010135c <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010135c:	55                   	push   %ebp
c010135d:	89 e5                	mov    %esp,%ebp
c010135f:	83 ec 38             	sub    $0x38,%esp
c0101362:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101368:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010136c:	89 c2                	mov    %eax,%edx
c010136e:	ec                   	in     (%dx),%al
c010136f:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101372:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101376:	0f b6 c0             	movzbl %al,%eax
c0101379:	83 e0 01             	and    $0x1,%eax
c010137c:	85 c0                	test   %eax,%eax
c010137e:	75 0a                	jne    c010138a <kbd_proc_data+0x2e>
        return -1;
c0101380:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101385:	e9 59 01 00 00       	jmp    c01014e3 <kbd_proc_data+0x187>
c010138a:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101390:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101394:	89 c2                	mov    %eax,%edx
c0101396:	ec                   	in     (%dx),%al
c0101397:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010139a:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010139e:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01013a1:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c01013a5:	75 17                	jne    c01013be <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c01013a7:	a1 a8 70 11 c0       	mov    0xc01170a8,%eax
c01013ac:	83 c8 40             	or     $0x40,%eax
c01013af:	a3 a8 70 11 c0       	mov    %eax,0xc01170a8
        return 0;
c01013b4:	b8 00 00 00 00       	mov    $0x0,%eax
c01013b9:	e9 25 01 00 00       	jmp    c01014e3 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c01013be:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013c2:	84 c0                	test   %al,%al
c01013c4:	79 47                	jns    c010140d <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c01013c6:	a1 a8 70 11 c0       	mov    0xc01170a8,%eax
c01013cb:	83 e0 40             	and    $0x40,%eax
c01013ce:	85 c0                	test   %eax,%eax
c01013d0:	75 09                	jne    c01013db <kbd_proc_data+0x7f>
c01013d2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013d6:	83 e0 7f             	and    $0x7f,%eax
c01013d9:	eb 04                	jmp    c01013df <kbd_proc_data+0x83>
c01013db:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013df:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01013e2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01013e6:	0f b6 80 60 60 11 c0 	movzbl -0x3fee9fa0(%eax),%eax
c01013ed:	83 c8 40             	or     $0x40,%eax
c01013f0:	0f b6 c0             	movzbl %al,%eax
c01013f3:	f7 d0                	not    %eax
c01013f5:	89 c2                	mov    %eax,%edx
c01013f7:	a1 a8 70 11 c0       	mov    0xc01170a8,%eax
c01013fc:	21 d0                	and    %edx,%eax
c01013fe:	a3 a8 70 11 c0       	mov    %eax,0xc01170a8
        return 0;
c0101403:	b8 00 00 00 00       	mov    $0x0,%eax
c0101408:	e9 d6 00 00 00       	jmp    c01014e3 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c010140d:	a1 a8 70 11 c0       	mov    0xc01170a8,%eax
c0101412:	83 e0 40             	and    $0x40,%eax
c0101415:	85 c0                	test   %eax,%eax
c0101417:	74 11                	je     c010142a <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101419:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c010141d:	a1 a8 70 11 c0       	mov    0xc01170a8,%eax
c0101422:	83 e0 bf             	and    $0xffffffbf,%eax
c0101425:	a3 a8 70 11 c0       	mov    %eax,0xc01170a8
    }

    shift |= shiftcode[data];
c010142a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010142e:	0f b6 80 60 60 11 c0 	movzbl -0x3fee9fa0(%eax),%eax
c0101435:	0f b6 d0             	movzbl %al,%edx
c0101438:	a1 a8 70 11 c0       	mov    0xc01170a8,%eax
c010143d:	09 d0                	or     %edx,%eax
c010143f:	a3 a8 70 11 c0       	mov    %eax,0xc01170a8
    shift ^= togglecode[data];
c0101444:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101448:	0f b6 80 60 61 11 c0 	movzbl -0x3fee9ea0(%eax),%eax
c010144f:	0f b6 d0             	movzbl %al,%edx
c0101452:	a1 a8 70 11 c0       	mov    0xc01170a8,%eax
c0101457:	31 d0                	xor    %edx,%eax
c0101459:	a3 a8 70 11 c0       	mov    %eax,0xc01170a8

    c = charcode[shift & (CTL | SHIFT)][data];
c010145e:	a1 a8 70 11 c0       	mov    0xc01170a8,%eax
c0101463:	83 e0 03             	and    $0x3,%eax
c0101466:	8b 14 85 60 65 11 c0 	mov    -0x3fee9aa0(,%eax,4),%edx
c010146d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101471:	01 d0                	add    %edx,%eax
c0101473:	0f b6 00             	movzbl (%eax),%eax
c0101476:	0f b6 c0             	movzbl %al,%eax
c0101479:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010147c:	a1 a8 70 11 c0       	mov    0xc01170a8,%eax
c0101481:	83 e0 08             	and    $0x8,%eax
c0101484:	85 c0                	test   %eax,%eax
c0101486:	74 22                	je     c01014aa <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101488:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010148c:	7e 0c                	jle    c010149a <kbd_proc_data+0x13e>
c010148e:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101492:	7f 06                	jg     c010149a <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101494:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101498:	eb 10                	jmp    c01014aa <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010149a:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010149e:	7e 0a                	jle    c01014aa <kbd_proc_data+0x14e>
c01014a0:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c01014a4:	7f 04                	jg     c01014aa <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c01014a6:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c01014aa:	a1 a8 70 11 c0       	mov    0xc01170a8,%eax
c01014af:	f7 d0                	not    %eax
c01014b1:	83 e0 06             	and    $0x6,%eax
c01014b4:	85 c0                	test   %eax,%eax
c01014b6:	75 28                	jne    c01014e0 <kbd_proc_data+0x184>
c01014b8:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c01014bf:	75 1f                	jne    c01014e0 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c01014c1:	c7 04 24 95 5e 10 c0 	movl   $0xc0105e95,(%esp)
c01014c8:	e8 6f ee ff ff       	call   c010033c <cprintf>
c01014cd:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c01014d3:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01014d7:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c01014db:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01014df:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01014e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01014e3:	c9                   	leave  
c01014e4:	c3                   	ret    

c01014e5 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01014e5:	55                   	push   %ebp
c01014e6:	89 e5                	mov    %esp,%ebp
c01014e8:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01014eb:	c7 04 24 5c 13 10 c0 	movl   $0xc010135c,(%esp)
c01014f2:	e8 a6 fd ff ff       	call   c010129d <cons_intr>
}
c01014f7:	c9                   	leave  
c01014f8:	c3                   	ret    

c01014f9 <kbd_init>:

static void
kbd_init(void) {
c01014f9:	55                   	push   %ebp
c01014fa:	89 e5                	mov    %esp,%ebp
c01014fc:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01014ff:	e8 e1 ff ff ff       	call   c01014e5 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101504:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010150b:	e8 3d 01 00 00       	call   c010164d <pic_enable>
}
c0101510:	c9                   	leave  
c0101511:	c3                   	ret    

c0101512 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101512:	55                   	push   %ebp
c0101513:	89 e5                	mov    %esp,%ebp
c0101515:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101518:	e8 93 f8 ff ff       	call   c0100db0 <cga_init>
    serial_init();
c010151d:	e8 74 f9 ff ff       	call   c0100e96 <serial_init>
    kbd_init();
c0101522:	e8 d2 ff ff ff       	call   c01014f9 <kbd_init>
    if (!serial_exists) {
c0101527:	a1 88 6e 11 c0       	mov    0xc0116e88,%eax
c010152c:	85 c0                	test   %eax,%eax
c010152e:	75 0c                	jne    c010153c <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101530:	c7 04 24 a1 5e 10 c0 	movl   $0xc0105ea1,(%esp)
c0101537:	e8 00 ee ff ff       	call   c010033c <cprintf>
    }
}
c010153c:	c9                   	leave  
c010153d:	c3                   	ret    

c010153e <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c010153e:	55                   	push   %ebp
c010153f:	89 e5                	mov    %esp,%ebp
c0101541:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101544:	e8 e2 f7 ff ff       	call   c0100d2b <__intr_save>
c0101549:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010154c:	8b 45 08             	mov    0x8(%ebp),%eax
c010154f:	89 04 24             	mov    %eax,(%esp)
c0101552:	e8 9b fa ff ff       	call   c0100ff2 <lpt_putc>
        cga_putc(c);
c0101557:	8b 45 08             	mov    0x8(%ebp),%eax
c010155a:	89 04 24             	mov    %eax,(%esp)
c010155d:	e8 cf fa ff ff       	call   c0101031 <cga_putc>
        serial_putc(c);
c0101562:	8b 45 08             	mov    0x8(%ebp),%eax
c0101565:	89 04 24             	mov    %eax,(%esp)
c0101568:	e8 f1 fc ff ff       	call   c010125e <serial_putc>
    }
    local_intr_restore(intr_flag);
c010156d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101570:	89 04 24             	mov    %eax,(%esp)
c0101573:	e8 dd f7 ff ff       	call   c0100d55 <__intr_restore>
}
c0101578:	c9                   	leave  
c0101579:	c3                   	ret    

c010157a <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010157a:	55                   	push   %ebp
c010157b:	89 e5                	mov    %esp,%ebp
c010157d:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101580:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101587:	e8 9f f7 ff ff       	call   c0100d2b <__intr_save>
c010158c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010158f:	e8 ab fd ff ff       	call   c010133f <serial_intr>
        kbd_intr();
c0101594:	e8 4c ff ff ff       	call   c01014e5 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101599:	8b 15 a0 70 11 c0    	mov    0xc01170a0,%edx
c010159f:	a1 a4 70 11 c0       	mov    0xc01170a4,%eax
c01015a4:	39 c2                	cmp    %eax,%edx
c01015a6:	74 31                	je     c01015d9 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c01015a8:	a1 a0 70 11 c0       	mov    0xc01170a0,%eax
c01015ad:	8d 50 01             	lea    0x1(%eax),%edx
c01015b0:	89 15 a0 70 11 c0    	mov    %edx,0xc01170a0
c01015b6:	0f b6 80 a0 6e 11 c0 	movzbl -0x3fee9160(%eax),%eax
c01015bd:	0f b6 c0             	movzbl %al,%eax
c01015c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c01015c3:	a1 a0 70 11 c0       	mov    0xc01170a0,%eax
c01015c8:	3d 00 02 00 00       	cmp    $0x200,%eax
c01015cd:	75 0a                	jne    c01015d9 <cons_getc+0x5f>
                cons.rpos = 0;
c01015cf:	c7 05 a0 70 11 c0 00 	movl   $0x0,0xc01170a0
c01015d6:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c01015d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01015dc:	89 04 24             	mov    %eax,(%esp)
c01015df:	e8 71 f7 ff ff       	call   c0100d55 <__intr_restore>
    return c;
c01015e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015e7:	c9                   	leave  
c01015e8:	c3                   	ret    

c01015e9 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01015e9:	55                   	push   %ebp
c01015ea:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01015ec:	fb                   	sti    
    sti();
}
c01015ed:	5d                   	pop    %ebp
c01015ee:	c3                   	ret    

c01015ef <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01015ef:	55                   	push   %ebp
c01015f0:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01015f2:	fa                   	cli    
    cli();
}
c01015f3:	5d                   	pop    %ebp
c01015f4:	c3                   	ret    

c01015f5 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01015f5:	55                   	push   %ebp
c01015f6:	89 e5                	mov    %esp,%ebp
c01015f8:	83 ec 14             	sub    $0x14,%esp
c01015fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01015fe:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101602:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101606:	66 a3 70 65 11 c0    	mov    %ax,0xc0116570
    if (did_init) {
c010160c:	a1 ac 70 11 c0       	mov    0xc01170ac,%eax
c0101611:	85 c0                	test   %eax,%eax
c0101613:	74 36                	je     c010164b <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101615:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101619:	0f b6 c0             	movzbl %al,%eax
c010161c:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101622:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101625:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101629:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010162d:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c010162e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101632:	66 c1 e8 08          	shr    $0x8,%ax
c0101636:	0f b6 c0             	movzbl %al,%eax
c0101639:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010163f:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101642:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101646:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010164a:	ee                   	out    %al,(%dx)
    }
}
c010164b:	c9                   	leave  
c010164c:	c3                   	ret    

c010164d <pic_enable>:

void
pic_enable(unsigned int irq) {
c010164d:	55                   	push   %ebp
c010164e:	89 e5                	mov    %esp,%ebp
c0101650:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101653:	8b 45 08             	mov    0x8(%ebp),%eax
c0101656:	ba 01 00 00 00       	mov    $0x1,%edx
c010165b:	89 c1                	mov    %eax,%ecx
c010165d:	d3 e2                	shl    %cl,%edx
c010165f:	89 d0                	mov    %edx,%eax
c0101661:	f7 d0                	not    %eax
c0101663:	89 c2                	mov    %eax,%edx
c0101665:	0f b7 05 70 65 11 c0 	movzwl 0xc0116570,%eax
c010166c:	21 d0                	and    %edx,%eax
c010166e:	0f b7 c0             	movzwl %ax,%eax
c0101671:	89 04 24             	mov    %eax,(%esp)
c0101674:	e8 7c ff ff ff       	call   c01015f5 <pic_setmask>
}
c0101679:	c9                   	leave  
c010167a:	c3                   	ret    

c010167b <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010167b:	55                   	push   %ebp
c010167c:	89 e5                	mov    %esp,%ebp
c010167e:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101681:	c7 05 ac 70 11 c0 01 	movl   $0x1,0xc01170ac
c0101688:	00 00 00 
c010168b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101691:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101695:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101699:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010169d:	ee                   	out    %al,(%dx)
c010169e:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01016a4:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c01016a8:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016ac:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01016b0:	ee                   	out    %al,(%dx)
c01016b1:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01016b7:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c01016bb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01016bf:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01016c3:	ee                   	out    %al,(%dx)
c01016c4:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c01016ca:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c01016ce:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01016d2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01016d6:	ee                   	out    %al,(%dx)
c01016d7:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01016dd:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01016e1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01016e5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01016e9:	ee                   	out    %al,(%dx)
c01016ea:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01016f0:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01016f4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01016f8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01016fc:	ee                   	out    %al,(%dx)
c01016fd:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0101703:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0101707:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010170b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010170f:	ee                   	out    %al,(%dx)
c0101710:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0101716:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c010171a:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010171e:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101722:	ee                   	out    %al,(%dx)
c0101723:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0101729:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c010172d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101731:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101735:	ee                   	out    %al,(%dx)
c0101736:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c010173c:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101740:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101744:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101748:	ee                   	out    %al,(%dx)
c0101749:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010174f:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101753:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101757:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010175b:	ee                   	out    %al,(%dx)
c010175c:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101762:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101766:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010176a:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010176e:	ee                   	out    %al,(%dx)
c010176f:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101775:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0101779:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010177d:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101781:	ee                   	out    %al,(%dx)
c0101782:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101788:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c010178c:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101790:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101794:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101795:	0f b7 05 70 65 11 c0 	movzwl 0xc0116570,%eax
c010179c:	66 83 f8 ff          	cmp    $0xffff,%ax
c01017a0:	74 12                	je     c01017b4 <pic_init+0x139>
        pic_setmask(irq_mask);
c01017a2:	0f b7 05 70 65 11 c0 	movzwl 0xc0116570,%eax
c01017a9:	0f b7 c0             	movzwl %ax,%eax
c01017ac:	89 04 24             	mov    %eax,(%esp)
c01017af:	e8 41 fe ff ff       	call   c01015f5 <pic_setmask>
    }
}
c01017b4:	c9                   	leave  
c01017b5:	c3                   	ret    

c01017b6 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01017b6:	55                   	push   %ebp
c01017b7:	89 e5                	mov    %esp,%ebp
c01017b9:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01017bc:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01017c3:	00 
c01017c4:	c7 04 24 c0 5e 10 c0 	movl   $0xc0105ec0,(%esp)
c01017cb:	e8 6c eb ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c01017d0:	c9                   	leave  
c01017d1:	c3                   	ret    

c01017d2 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01017d2:	55                   	push   %ebp
c01017d3:	89 e5                	mov    %esp,%ebp
      *     Can you see idt[256] in this file? Yes, it's IDT! you can use SETGATE macro to setup each item of IDT
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
}
c01017d5:	5d                   	pop    %ebp
c01017d6:	c3                   	ret    

c01017d7 <trapname>:

static const char *
trapname(int trapno) {
c01017d7:	55                   	push   %ebp
c01017d8:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01017da:	8b 45 08             	mov    0x8(%ebp),%eax
c01017dd:	83 f8 13             	cmp    $0x13,%eax
c01017e0:	77 0c                	ja     c01017ee <trapname+0x17>
        return excnames[trapno];
c01017e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01017e5:	8b 04 85 20 62 10 c0 	mov    -0x3fef9de0(,%eax,4),%eax
c01017ec:	eb 18                	jmp    c0101806 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01017ee:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01017f2:	7e 0d                	jle    c0101801 <trapname+0x2a>
c01017f4:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01017f8:	7f 07                	jg     c0101801 <trapname+0x2a>
        return "Hardware Interrupt";
c01017fa:	b8 ca 5e 10 c0       	mov    $0xc0105eca,%eax
c01017ff:	eb 05                	jmp    c0101806 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101801:	b8 dd 5e 10 c0       	mov    $0xc0105edd,%eax
}
c0101806:	5d                   	pop    %ebp
c0101807:	c3                   	ret    

c0101808 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101808:	55                   	push   %ebp
c0101809:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c010180b:	8b 45 08             	mov    0x8(%ebp),%eax
c010180e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101812:	66 83 f8 08          	cmp    $0x8,%ax
c0101816:	0f 94 c0             	sete   %al
c0101819:	0f b6 c0             	movzbl %al,%eax
}
c010181c:	5d                   	pop    %ebp
c010181d:	c3                   	ret    

c010181e <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c010181e:	55                   	push   %ebp
c010181f:	89 e5                	mov    %esp,%ebp
c0101821:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101824:	8b 45 08             	mov    0x8(%ebp),%eax
c0101827:	89 44 24 04          	mov    %eax,0x4(%esp)
c010182b:	c7 04 24 1e 5f 10 c0 	movl   $0xc0105f1e,(%esp)
c0101832:	e8 05 eb ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c0101837:	8b 45 08             	mov    0x8(%ebp),%eax
c010183a:	89 04 24             	mov    %eax,(%esp)
c010183d:	e8 a1 01 00 00       	call   c01019e3 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101842:	8b 45 08             	mov    0x8(%ebp),%eax
c0101845:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101849:	0f b7 c0             	movzwl %ax,%eax
c010184c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101850:	c7 04 24 2f 5f 10 c0 	movl   $0xc0105f2f,(%esp)
c0101857:	e8 e0 ea ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c010185c:	8b 45 08             	mov    0x8(%ebp),%eax
c010185f:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101863:	0f b7 c0             	movzwl %ax,%eax
c0101866:	89 44 24 04          	mov    %eax,0x4(%esp)
c010186a:	c7 04 24 42 5f 10 c0 	movl   $0xc0105f42,(%esp)
c0101871:	e8 c6 ea ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101876:	8b 45 08             	mov    0x8(%ebp),%eax
c0101879:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c010187d:	0f b7 c0             	movzwl %ax,%eax
c0101880:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101884:	c7 04 24 55 5f 10 c0 	movl   $0xc0105f55,(%esp)
c010188b:	e8 ac ea ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101890:	8b 45 08             	mov    0x8(%ebp),%eax
c0101893:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101897:	0f b7 c0             	movzwl %ax,%eax
c010189a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010189e:	c7 04 24 68 5f 10 c0 	movl   $0xc0105f68,(%esp)
c01018a5:	e8 92 ea ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c01018aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01018ad:	8b 40 30             	mov    0x30(%eax),%eax
c01018b0:	89 04 24             	mov    %eax,(%esp)
c01018b3:	e8 1f ff ff ff       	call   c01017d7 <trapname>
c01018b8:	8b 55 08             	mov    0x8(%ebp),%edx
c01018bb:	8b 52 30             	mov    0x30(%edx),%edx
c01018be:	89 44 24 08          	mov    %eax,0x8(%esp)
c01018c2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01018c6:	c7 04 24 7b 5f 10 c0 	movl   $0xc0105f7b,(%esp)
c01018cd:	e8 6a ea ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c01018d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01018d5:	8b 40 34             	mov    0x34(%eax),%eax
c01018d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01018dc:	c7 04 24 8d 5f 10 c0 	movl   $0xc0105f8d,(%esp)
c01018e3:	e8 54 ea ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c01018e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01018eb:	8b 40 38             	mov    0x38(%eax),%eax
c01018ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01018f2:	c7 04 24 9c 5f 10 c0 	movl   $0xc0105f9c,(%esp)
c01018f9:	e8 3e ea ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c01018fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101901:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101905:	0f b7 c0             	movzwl %ax,%eax
c0101908:	89 44 24 04          	mov    %eax,0x4(%esp)
c010190c:	c7 04 24 ab 5f 10 c0 	movl   $0xc0105fab,(%esp)
c0101913:	e8 24 ea ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101918:	8b 45 08             	mov    0x8(%ebp),%eax
c010191b:	8b 40 40             	mov    0x40(%eax),%eax
c010191e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101922:	c7 04 24 be 5f 10 c0 	movl   $0xc0105fbe,(%esp)
c0101929:	e8 0e ea ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c010192e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101935:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c010193c:	eb 3e                	jmp    c010197c <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c010193e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101941:	8b 50 40             	mov    0x40(%eax),%edx
c0101944:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101947:	21 d0                	and    %edx,%eax
c0101949:	85 c0                	test   %eax,%eax
c010194b:	74 28                	je     c0101975 <print_trapframe+0x157>
c010194d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101950:	8b 04 85 a0 65 11 c0 	mov    -0x3fee9a60(,%eax,4),%eax
c0101957:	85 c0                	test   %eax,%eax
c0101959:	74 1a                	je     c0101975 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c010195b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010195e:	8b 04 85 a0 65 11 c0 	mov    -0x3fee9a60(,%eax,4),%eax
c0101965:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101969:	c7 04 24 cd 5f 10 c0 	movl   $0xc0105fcd,(%esp)
c0101970:	e8 c7 e9 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101975:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101979:	d1 65 f0             	shll   -0x10(%ebp)
c010197c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010197f:	83 f8 17             	cmp    $0x17,%eax
c0101982:	76 ba                	jbe    c010193e <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101984:	8b 45 08             	mov    0x8(%ebp),%eax
c0101987:	8b 40 40             	mov    0x40(%eax),%eax
c010198a:	25 00 30 00 00       	and    $0x3000,%eax
c010198f:	c1 e8 0c             	shr    $0xc,%eax
c0101992:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101996:	c7 04 24 d1 5f 10 c0 	movl   $0xc0105fd1,(%esp)
c010199d:	e8 9a e9 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c01019a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01019a5:	89 04 24             	mov    %eax,(%esp)
c01019a8:	e8 5b fe ff ff       	call   c0101808 <trap_in_kernel>
c01019ad:	85 c0                	test   %eax,%eax
c01019af:	75 30                	jne    c01019e1 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c01019b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01019b4:	8b 40 44             	mov    0x44(%eax),%eax
c01019b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019bb:	c7 04 24 da 5f 10 c0 	movl   $0xc0105fda,(%esp)
c01019c2:	e8 75 e9 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c01019c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01019ca:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c01019ce:	0f b7 c0             	movzwl %ax,%eax
c01019d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019d5:	c7 04 24 e9 5f 10 c0 	movl   $0xc0105fe9,(%esp)
c01019dc:	e8 5b e9 ff ff       	call   c010033c <cprintf>
    }
}
c01019e1:	c9                   	leave  
c01019e2:	c3                   	ret    

c01019e3 <print_regs>:

void
print_regs(struct pushregs *regs) {
c01019e3:	55                   	push   %ebp
c01019e4:	89 e5                	mov    %esp,%ebp
c01019e6:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c01019e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01019ec:	8b 00                	mov    (%eax),%eax
c01019ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01019f2:	c7 04 24 fc 5f 10 c0 	movl   $0xc0105ffc,(%esp)
c01019f9:	e8 3e e9 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c01019fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a01:	8b 40 04             	mov    0x4(%eax),%eax
c0101a04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a08:	c7 04 24 0b 60 10 c0 	movl   $0xc010600b,(%esp)
c0101a0f:	e8 28 e9 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101a14:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a17:	8b 40 08             	mov    0x8(%eax),%eax
c0101a1a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a1e:	c7 04 24 1a 60 10 c0 	movl   $0xc010601a,(%esp)
c0101a25:	e8 12 e9 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101a2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a2d:	8b 40 0c             	mov    0xc(%eax),%eax
c0101a30:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a34:	c7 04 24 29 60 10 c0 	movl   $0xc0106029,(%esp)
c0101a3b:	e8 fc e8 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101a40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a43:	8b 40 10             	mov    0x10(%eax),%eax
c0101a46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a4a:	c7 04 24 38 60 10 c0 	movl   $0xc0106038,(%esp)
c0101a51:	e8 e6 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101a56:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a59:	8b 40 14             	mov    0x14(%eax),%eax
c0101a5c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a60:	c7 04 24 47 60 10 c0 	movl   $0xc0106047,(%esp)
c0101a67:	e8 d0 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101a6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a6f:	8b 40 18             	mov    0x18(%eax),%eax
c0101a72:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a76:	c7 04 24 56 60 10 c0 	movl   $0xc0106056,(%esp)
c0101a7d:	e8 ba e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101a82:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a85:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101a88:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a8c:	c7 04 24 65 60 10 c0 	movl   $0xc0106065,(%esp)
c0101a93:	e8 a4 e8 ff ff       	call   c010033c <cprintf>
}
c0101a98:	c9                   	leave  
c0101a99:	c3                   	ret    

c0101a9a <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101a9a:	55                   	push   %ebp
c0101a9b:	89 e5                	mov    %esp,%ebp
c0101a9d:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101aa0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa3:	8b 40 30             	mov    0x30(%eax),%eax
c0101aa6:	83 f8 2f             	cmp    $0x2f,%eax
c0101aa9:	77 1e                	ja     c0101ac9 <trap_dispatch+0x2f>
c0101aab:	83 f8 2e             	cmp    $0x2e,%eax
c0101aae:	0f 83 bf 00 00 00    	jae    c0101b73 <trap_dispatch+0xd9>
c0101ab4:	83 f8 21             	cmp    $0x21,%eax
c0101ab7:	74 40                	je     c0101af9 <trap_dispatch+0x5f>
c0101ab9:	83 f8 24             	cmp    $0x24,%eax
c0101abc:	74 15                	je     c0101ad3 <trap_dispatch+0x39>
c0101abe:	83 f8 20             	cmp    $0x20,%eax
c0101ac1:	0f 84 af 00 00 00    	je     c0101b76 <trap_dispatch+0xdc>
c0101ac7:	eb 72                	jmp    c0101b3b <trap_dispatch+0xa1>
c0101ac9:	83 e8 78             	sub    $0x78,%eax
c0101acc:	83 f8 01             	cmp    $0x1,%eax
c0101acf:	77 6a                	ja     c0101b3b <trap_dispatch+0xa1>
c0101ad1:	eb 4c                	jmp    c0101b1f <trap_dispatch+0x85>
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101ad3:	e8 a2 fa ff ff       	call   c010157a <cons_getc>
c0101ad8:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101adb:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101adf:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101ae3:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aeb:	c7 04 24 74 60 10 c0 	movl   $0xc0106074,(%esp)
c0101af2:	e8 45 e8 ff ff       	call   c010033c <cprintf>
        break;
c0101af7:	eb 7e                	jmp    c0101b77 <trap_dispatch+0xdd>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101af9:	e8 7c fa ff ff       	call   c010157a <cons_getc>
c0101afe:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101b01:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101b05:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101b09:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101b0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b11:	c7 04 24 86 60 10 c0 	movl   $0xc0106086,(%esp)
c0101b18:	e8 1f e8 ff ff       	call   c010033c <cprintf>
        break;
c0101b1d:	eb 58                	jmp    c0101b77 <trap_dispatch+0xdd>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101b1f:	c7 44 24 08 95 60 10 	movl   $0xc0106095,0x8(%esp)
c0101b26:	c0 
c0101b27:	c7 44 24 04 a2 00 00 	movl   $0xa2,0x4(%esp)
c0101b2e:	00 
c0101b2f:	c7 04 24 a5 60 10 c0 	movl   $0xc01060a5,(%esp)
c0101b36:	e8 d1 f0 ff ff       	call   c0100c0c <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101b3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b3e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b42:	0f b7 c0             	movzwl %ax,%eax
c0101b45:	83 e0 03             	and    $0x3,%eax
c0101b48:	85 c0                	test   %eax,%eax
c0101b4a:	75 2b                	jne    c0101b77 <trap_dispatch+0xdd>
            print_trapframe(tf);
c0101b4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4f:	89 04 24             	mov    %eax,(%esp)
c0101b52:	e8 c7 fc ff ff       	call   c010181e <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101b57:	c7 44 24 08 b6 60 10 	movl   $0xc01060b6,0x8(%esp)
c0101b5e:	c0 
c0101b5f:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0101b66:	00 
c0101b67:	c7 04 24 a5 60 10 c0 	movl   $0xc01060a5,(%esp)
c0101b6e:	e8 99 f0 ff ff       	call   c0100c0c <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101b73:	90                   	nop
c0101b74:	eb 01                	jmp    c0101b77 <trap_dispatch+0xdd>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        break;
c0101b76:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101b77:	c9                   	leave  
c0101b78:	c3                   	ret    

c0101b79 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101b79:	55                   	push   %ebp
c0101b7a:	89 e5                	mov    %esp,%ebp
c0101b7c:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101b7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b82:	89 04 24             	mov    %eax,(%esp)
c0101b85:	e8 10 ff ff ff       	call   c0101a9a <trap_dispatch>
}
c0101b8a:	c9                   	leave  
c0101b8b:	c3                   	ret    

c0101b8c <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101b8c:	1e                   	push   %ds
    pushl %es
c0101b8d:	06                   	push   %es
    pushl %fs
c0101b8e:	0f a0                	push   %fs
    pushl %gs
c0101b90:	0f a8                	push   %gs
    pushal
c0101b92:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101b93:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101b98:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101b9a:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101b9c:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101b9d:	e8 d7 ff ff ff       	call   c0101b79 <trap>

    # pop the pushed stack pointer
    popl %esp
c0101ba2:	5c                   	pop    %esp

c0101ba3 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101ba3:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101ba4:	0f a9                	pop    %gs
    popl %fs
c0101ba6:	0f a1                	pop    %fs
    popl %es
c0101ba8:	07                   	pop    %es
    popl %ds
c0101ba9:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101baa:	83 c4 08             	add    $0x8,%esp
    iret
c0101bad:	cf                   	iret   

c0101bae <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101bae:	6a 00                	push   $0x0
  pushl $0
c0101bb0:	6a 00                	push   $0x0
  jmp __alltraps
c0101bb2:	e9 d5 ff ff ff       	jmp    c0101b8c <__alltraps>

c0101bb7 <vector1>:
.globl vector1
vector1:
  pushl $0
c0101bb7:	6a 00                	push   $0x0
  pushl $1
c0101bb9:	6a 01                	push   $0x1
  jmp __alltraps
c0101bbb:	e9 cc ff ff ff       	jmp    c0101b8c <__alltraps>

c0101bc0 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101bc0:	6a 00                	push   $0x0
  pushl $2
c0101bc2:	6a 02                	push   $0x2
  jmp __alltraps
c0101bc4:	e9 c3 ff ff ff       	jmp    c0101b8c <__alltraps>

c0101bc9 <vector3>:
.globl vector3
vector3:
  pushl $0
c0101bc9:	6a 00                	push   $0x0
  pushl $3
c0101bcb:	6a 03                	push   $0x3
  jmp __alltraps
c0101bcd:	e9 ba ff ff ff       	jmp    c0101b8c <__alltraps>

c0101bd2 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101bd2:	6a 00                	push   $0x0
  pushl $4
c0101bd4:	6a 04                	push   $0x4
  jmp __alltraps
c0101bd6:	e9 b1 ff ff ff       	jmp    c0101b8c <__alltraps>

c0101bdb <vector5>:
.globl vector5
vector5:
  pushl $0
c0101bdb:	6a 00                	push   $0x0
  pushl $5
c0101bdd:	6a 05                	push   $0x5
  jmp __alltraps
c0101bdf:	e9 a8 ff ff ff       	jmp    c0101b8c <__alltraps>

c0101be4 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101be4:	6a 00                	push   $0x0
  pushl $6
c0101be6:	6a 06                	push   $0x6
  jmp __alltraps
c0101be8:	e9 9f ff ff ff       	jmp    c0101b8c <__alltraps>

c0101bed <vector7>:
.globl vector7
vector7:
  pushl $0
c0101bed:	6a 00                	push   $0x0
  pushl $7
c0101bef:	6a 07                	push   $0x7
  jmp __alltraps
c0101bf1:	e9 96 ff ff ff       	jmp    c0101b8c <__alltraps>

c0101bf6 <vector8>:
.globl vector8
vector8:
  pushl $8
c0101bf6:	6a 08                	push   $0x8
  jmp __alltraps
c0101bf8:	e9 8f ff ff ff       	jmp    c0101b8c <__alltraps>

c0101bfd <vector9>:
.globl vector9
vector9:
  pushl $9
c0101bfd:	6a 09                	push   $0x9
  jmp __alltraps
c0101bff:	e9 88 ff ff ff       	jmp    c0101b8c <__alltraps>

c0101c04 <vector10>:
.globl vector10
vector10:
  pushl $10
c0101c04:	6a 0a                	push   $0xa
  jmp __alltraps
c0101c06:	e9 81 ff ff ff       	jmp    c0101b8c <__alltraps>

c0101c0b <vector11>:
.globl vector11
vector11:
  pushl $11
c0101c0b:	6a 0b                	push   $0xb
  jmp __alltraps
c0101c0d:	e9 7a ff ff ff       	jmp    c0101b8c <__alltraps>

c0101c12 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101c12:	6a 0c                	push   $0xc
  jmp __alltraps
c0101c14:	e9 73 ff ff ff       	jmp    c0101b8c <__alltraps>

c0101c19 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101c19:	6a 0d                	push   $0xd
  jmp __alltraps
c0101c1b:	e9 6c ff ff ff       	jmp    c0101b8c <__alltraps>

c0101c20 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101c20:	6a 0e                	push   $0xe
  jmp __alltraps
c0101c22:	e9 65 ff ff ff       	jmp    c0101b8c <__alltraps>

c0101c27 <vector15>:
.globl vector15
vector15:
  pushl $0
c0101c27:	6a 00                	push   $0x0
  pushl $15
c0101c29:	6a 0f                	push   $0xf
  jmp __alltraps
c0101c2b:	e9 5c ff ff ff       	jmp    c0101b8c <__alltraps>

c0101c30 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101c30:	6a 00                	push   $0x0
  pushl $16
c0101c32:	6a 10                	push   $0x10
  jmp __alltraps
c0101c34:	e9 53 ff ff ff       	jmp    c0101b8c <__alltraps>

c0101c39 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101c39:	6a 11                	push   $0x11
  jmp __alltraps
c0101c3b:	e9 4c ff ff ff       	jmp    c0101b8c <__alltraps>

c0101c40 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101c40:	6a 00                	push   $0x0
  pushl $18
c0101c42:	6a 12                	push   $0x12
  jmp __alltraps
c0101c44:	e9 43 ff ff ff       	jmp    c0101b8c <__alltraps>

c0101c49 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101c49:	6a 00                	push   $0x0
  pushl $19
c0101c4b:	6a 13                	push   $0x13
  jmp __alltraps
c0101c4d:	e9 3a ff ff ff       	jmp    c0101b8c <__alltraps>

c0101c52 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101c52:	6a 00                	push   $0x0
  pushl $20
c0101c54:	6a 14                	push   $0x14
  jmp __alltraps
c0101c56:	e9 31 ff ff ff       	jmp    c0101b8c <__alltraps>

c0101c5b <vector21>:
.globl vector21
vector21:
  pushl $0
c0101c5b:	6a 00                	push   $0x0
  pushl $21
c0101c5d:	6a 15                	push   $0x15
  jmp __alltraps
c0101c5f:	e9 28 ff ff ff       	jmp    c0101b8c <__alltraps>

c0101c64 <vector22>:
.globl vector22
vector22:
  pushl $0
c0101c64:	6a 00                	push   $0x0
  pushl $22
c0101c66:	6a 16                	push   $0x16
  jmp __alltraps
c0101c68:	e9 1f ff ff ff       	jmp    c0101b8c <__alltraps>

c0101c6d <vector23>:
.globl vector23
vector23:
  pushl $0
c0101c6d:	6a 00                	push   $0x0
  pushl $23
c0101c6f:	6a 17                	push   $0x17
  jmp __alltraps
c0101c71:	e9 16 ff ff ff       	jmp    c0101b8c <__alltraps>

c0101c76 <vector24>:
.globl vector24
vector24:
  pushl $0
c0101c76:	6a 00                	push   $0x0
  pushl $24
c0101c78:	6a 18                	push   $0x18
  jmp __alltraps
c0101c7a:	e9 0d ff ff ff       	jmp    c0101b8c <__alltraps>

c0101c7f <vector25>:
.globl vector25
vector25:
  pushl $0
c0101c7f:	6a 00                	push   $0x0
  pushl $25
c0101c81:	6a 19                	push   $0x19
  jmp __alltraps
c0101c83:	e9 04 ff ff ff       	jmp    c0101b8c <__alltraps>

c0101c88 <vector26>:
.globl vector26
vector26:
  pushl $0
c0101c88:	6a 00                	push   $0x0
  pushl $26
c0101c8a:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101c8c:	e9 fb fe ff ff       	jmp    c0101b8c <__alltraps>

c0101c91 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101c91:	6a 00                	push   $0x0
  pushl $27
c0101c93:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101c95:	e9 f2 fe ff ff       	jmp    c0101b8c <__alltraps>

c0101c9a <vector28>:
.globl vector28
vector28:
  pushl $0
c0101c9a:	6a 00                	push   $0x0
  pushl $28
c0101c9c:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101c9e:	e9 e9 fe ff ff       	jmp    c0101b8c <__alltraps>

c0101ca3 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101ca3:	6a 00                	push   $0x0
  pushl $29
c0101ca5:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101ca7:	e9 e0 fe ff ff       	jmp    c0101b8c <__alltraps>

c0101cac <vector30>:
.globl vector30
vector30:
  pushl $0
c0101cac:	6a 00                	push   $0x0
  pushl $30
c0101cae:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101cb0:	e9 d7 fe ff ff       	jmp    c0101b8c <__alltraps>

c0101cb5 <vector31>:
.globl vector31
vector31:
  pushl $0
c0101cb5:	6a 00                	push   $0x0
  pushl $31
c0101cb7:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101cb9:	e9 ce fe ff ff       	jmp    c0101b8c <__alltraps>

c0101cbe <vector32>:
.globl vector32
vector32:
  pushl $0
c0101cbe:	6a 00                	push   $0x0
  pushl $32
c0101cc0:	6a 20                	push   $0x20
  jmp __alltraps
c0101cc2:	e9 c5 fe ff ff       	jmp    c0101b8c <__alltraps>

c0101cc7 <vector33>:
.globl vector33
vector33:
  pushl $0
c0101cc7:	6a 00                	push   $0x0
  pushl $33
c0101cc9:	6a 21                	push   $0x21
  jmp __alltraps
c0101ccb:	e9 bc fe ff ff       	jmp    c0101b8c <__alltraps>

c0101cd0 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101cd0:	6a 00                	push   $0x0
  pushl $34
c0101cd2:	6a 22                	push   $0x22
  jmp __alltraps
c0101cd4:	e9 b3 fe ff ff       	jmp    c0101b8c <__alltraps>

c0101cd9 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101cd9:	6a 00                	push   $0x0
  pushl $35
c0101cdb:	6a 23                	push   $0x23
  jmp __alltraps
c0101cdd:	e9 aa fe ff ff       	jmp    c0101b8c <__alltraps>

c0101ce2 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101ce2:	6a 00                	push   $0x0
  pushl $36
c0101ce4:	6a 24                	push   $0x24
  jmp __alltraps
c0101ce6:	e9 a1 fe ff ff       	jmp    c0101b8c <__alltraps>

c0101ceb <vector37>:
.globl vector37
vector37:
  pushl $0
c0101ceb:	6a 00                	push   $0x0
  pushl $37
c0101ced:	6a 25                	push   $0x25
  jmp __alltraps
c0101cef:	e9 98 fe ff ff       	jmp    c0101b8c <__alltraps>

c0101cf4 <vector38>:
.globl vector38
vector38:
  pushl $0
c0101cf4:	6a 00                	push   $0x0
  pushl $38
c0101cf6:	6a 26                	push   $0x26
  jmp __alltraps
c0101cf8:	e9 8f fe ff ff       	jmp    c0101b8c <__alltraps>

c0101cfd <vector39>:
.globl vector39
vector39:
  pushl $0
c0101cfd:	6a 00                	push   $0x0
  pushl $39
c0101cff:	6a 27                	push   $0x27
  jmp __alltraps
c0101d01:	e9 86 fe ff ff       	jmp    c0101b8c <__alltraps>

c0101d06 <vector40>:
.globl vector40
vector40:
  pushl $0
c0101d06:	6a 00                	push   $0x0
  pushl $40
c0101d08:	6a 28                	push   $0x28
  jmp __alltraps
c0101d0a:	e9 7d fe ff ff       	jmp    c0101b8c <__alltraps>

c0101d0f <vector41>:
.globl vector41
vector41:
  pushl $0
c0101d0f:	6a 00                	push   $0x0
  pushl $41
c0101d11:	6a 29                	push   $0x29
  jmp __alltraps
c0101d13:	e9 74 fe ff ff       	jmp    c0101b8c <__alltraps>

c0101d18 <vector42>:
.globl vector42
vector42:
  pushl $0
c0101d18:	6a 00                	push   $0x0
  pushl $42
c0101d1a:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101d1c:	e9 6b fe ff ff       	jmp    c0101b8c <__alltraps>

c0101d21 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101d21:	6a 00                	push   $0x0
  pushl $43
c0101d23:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101d25:	e9 62 fe ff ff       	jmp    c0101b8c <__alltraps>

c0101d2a <vector44>:
.globl vector44
vector44:
  pushl $0
c0101d2a:	6a 00                	push   $0x0
  pushl $44
c0101d2c:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101d2e:	e9 59 fe ff ff       	jmp    c0101b8c <__alltraps>

c0101d33 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101d33:	6a 00                	push   $0x0
  pushl $45
c0101d35:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101d37:	e9 50 fe ff ff       	jmp    c0101b8c <__alltraps>

c0101d3c <vector46>:
.globl vector46
vector46:
  pushl $0
c0101d3c:	6a 00                	push   $0x0
  pushl $46
c0101d3e:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101d40:	e9 47 fe ff ff       	jmp    c0101b8c <__alltraps>

c0101d45 <vector47>:
.globl vector47
vector47:
  pushl $0
c0101d45:	6a 00                	push   $0x0
  pushl $47
c0101d47:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101d49:	e9 3e fe ff ff       	jmp    c0101b8c <__alltraps>

c0101d4e <vector48>:
.globl vector48
vector48:
  pushl $0
c0101d4e:	6a 00                	push   $0x0
  pushl $48
c0101d50:	6a 30                	push   $0x30
  jmp __alltraps
c0101d52:	e9 35 fe ff ff       	jmp    c0101b8c <__alltraps>

c0101d57 <vector49>:
.globl vector49
vector49:
  pushl $0
c0101d57:	6a 00                	push   $0x0
  pushl $49
c0101d59:	6a 31                	push   $0x31
  jmp __alltraps
c0101d5b:	e9 2c fe ff ff       	jmp    c0101b8c <__alltraps>

c0101d60 <vector50>:
.globl vector50
vector50:
  pushl $0
c0101d60:	6a 00                	push   $0x0
  pushl $50
c0101d62:	6a 32                	push   $0x32
  jmp __alltraps
c0101d64:	e9 23 fe ff ff       	jmp    c0101b8c <__alltraps>

c0101d69 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101d69:	6a 00                	push   $0x0
  pushl $51
c0101d6b:	6a 33                	push   $0x33
  jmp __alltraps
c0101d6d:	e9 1a fe ff ff       	jmp    c0101b8c <__alltraps>

c0101d72 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101d72:	6a 00                	push   $0x0
  pushl $52
c0101d74:	6a 34                	push   $0x34
  jmp __alltraps
c0101d76:	e9 11 fe ff ff       	jmp    c0101b8c <__alltraps>

c0101d7b <vector53>:
.globl vector53
vector53:
  pushl $0
c0101d7b:	6a 00                	push   $0x0
  pushl $53
c0101d7d:	6a 35                	push   $0x35
  jmp __alltraps
c0101d7f:	e9 08 fe ff ff       	jmp    c0101b8c <__alltraps>

c0101d84 <vector54>:
.globl vector54
vector54:
  pushl $0
c0101d84:	6a 00                	push   $0x0
  pushl $54
c0101d86:	6a 36                	push   $0x36
  jmp __alltraps
c0101d88:	e9 ff fd ff ff       	jmp    c0101b8c <__alltraps>

c0101d8d <vector55>:
.globl vector55
vector55:
  pushl $0
c0101d8d:	6a 00                	push   $0x0
  pushl $55
c0101d8f:	6a 37                	push   $0x37
  jmp __alltraps
c0101d91:	e9 f6 fd ff ff       	jmp    c0101b8c <__alltraps>

c0101d96 <vector56>:
.globl vector56
vector56:
  pushl $0
c0101d96:	6a 00                	push   $0x0
  pushl $56
c0101d98:	6a 38                	push   $0x38
  jmp __alltraps
c0101d9a:	e9 ed fd ff ff       	jmp    c0101b8c <__alltraps>

c0101d9f <vector57>:
.globl vector57
vector57:
  pushl $0
c0101d9f:	6a 00                	push   $0x0
  pushl $57
c0101da1:	6a 39                	push   $0x39
  jmp __alltraps
c0101da3:	e9 e4 fd ff ff       	jmp    c0101b8c <__alltraps>

c0101da8 <vector58>:
.globl vector58
vector58:
  pushl $0
c0101da8:	6a 00                	push   $0x0
  pushl $58
c0101daa:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101dac:	e9 db fd ff ff       	jmp    c0101b8c <__alltraps>

c0101db1 <vector59>:
.globl vector59
vector59:
  pushl $0
c0101db1:	6a 00                	push   $0x0
  pushl $59
c0101db3:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101db5:	e9 d2 fd ff ff       	jmp    c0101b8c <__alltraps>

c0101dba <vector60>:
.globl vector60
vector60:
  pushl $0
c0101dba:	6a 00                	push   $0x0
  pushl $60
c0101dbc:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101dbe:	e9 c9 fd ff ff       	jmp    c0101b8c <__alltraps>

c0101dc3 <vector61>:
.globl vector61
vector61:
  pushl $0
c0101dc3:	6a 00                	push   $0x0
  pushl $61
c0101dc5:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101dc7:	e9 c0 fd ff ff       	jmp    c0101b8c <__alltraps>

c0101dcc <vector62>:
.globl vector62
vector62:
  pushl $0
c0101dcc:	6a 00                	push   $0x0
  pushl $62
c0101dce:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101dd0:	e9 b7 fd ff ff       	jmp    c0101b8c <__alltraps>

c0101dd5 <vector63>:
.globl vector63
vector63:
  pushl $0
c0101dd5:	6a 00                	push   $0x0
  pushl $63
c0101dd7:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101dd9:	e9 ae fd ff ff       	jmp    c0101b8c <__alltraps>

c0101dde <vector64>:
.globl vector64
vector64:
  pushl $0
c0101dde:	6a 00                	push   $0x0
  pushl $64
c0101de0:	6a 40                	push   $0x40
  jmp __alltraps
c0101de2:	e9 a5 fd ff ff       	jmp    c0101b8c <__alltraps>

c0101de7 <vector65>:
.globl vector65
vector65:
  pushl $0
c0101de7:	6a 00                	push   $0x0
  pushl $65
c0101de9:	6a 41                	push   $0x41
  jmp __alltraps
c0101deb:	e9 9c fd ff ff       	jmp    c0101b8c <__alltraps>

c0101df0 <vector66>:
.globl vector66
vector66:
  pushl $0
c0101df0:	6a 00                	push   $0x0
  pushl $66
c0101df2:	6a 42                	push   $0x42
  jmp __alltraps
c0101df4:	e9 93 fd ff ff       	jmp    c0101b8c <__alltraps>

c0101df9 <vector67>:
.globl vector67
vector67:
  pushl $0
c0101df9:	6a 00                	push   $0x0
  pushl $67
c0101dfb:	6a 43                	push   $0x43
  jmp __alltraps
c0101dfd:	e9 8a fd ff ff       	jmp    c0101b8c <__alltraps>

c0101e02 <vector68>:
.globl vector68
vector68:
  pushl $0
c0101e02:	6a 00                	push   $0x0
  pushl $68
c0101e04:	6a 44                	push   $0x44
  jmp __alltraps
c0101e06:	e9 81 fd ff ff       	jmp    c0101b8c <__alltraps>

c0101e0b <vector69>:
.globl vector69
vector69:
  pushl $0
c0101e0b:	6a 00                	push   $0x0
  pushl $69
c0101e0d:	6a 45                	push   $0x45
  jmp __alltraps
c0101e0f:	e9 78 fd ff ff       	jmp    c0101b8c <__alltraps>

c0101e14 <vector70>:
.globl vector70
vector70:
  pushl $0
c0101e14:	6a 00                	push   $0x0
  pushl $70
c0101e16:	6a 46                	push   $0x46
  jmp __alltraps
c0101e18:	e9 6f fd ff ff       	jmp    c0101b8c <__alltraps>

c0101e1d <vector71>:
.globl vector71
vector71:
  pushl $0
c0101e1d:	6a 00                	push   $0x0
  pushl $71
c0101e1f:	6a 47                	push   $0x47
  jmp __alltraps
c0101e21:	e9 66 fd ff ff       	jmp    c0101b8c <__alltraps>

c0101e26 <vector72>:
.globl vector72
vector72:
  pushl $0
c0101e26:	6a 00                	push   $0x0
  pushl $72
c0101e28:	6a 48                	push   $0x48
  jmp __alltraps
c0101e2a:	e9 5d fd ff ff       	jmp    c0101b8c <__alltraps>

c0101e2f <vector73>:
.globl vector73
vector73:
  pushl $0
c0101e2f:	6a 00                	push   $0x0
  pushl $73
c0101e31:	6a 49                	push   $0x49
  jmp __alltraps
c0101e33:	e9 54 fd ff ff       	jmp    c0101b8c <__alltraps>

c0101e38 <vector74>:
.globl vector74
vector74:
  pushl $0
c0101e38:	6a 00                	push   $0x0
  pushl $74
c0101e3a:	6a 4a                	push   $0x4a
  jmp __alltraps
c0101e3c:	e9 4b fd ff ff       	jmp    c0101b8c <__alltraps>

c0101e41 <vector75>:
.globl vector75
vector75:
  pushl $0
c0101e41:	6a 00                	push   $0x0
  pushl $75
c0101e43:	6a 4b                	push   $0x4b
  jmp __alltraps
c0101e45:	e9 42 fd ff ff       	jmp    c0101b8c <__alltraps>

c0101e4a <vector76>:
.globl vector76
vector76:
  pushl $0
c0101e4a:	6a 00                	push   $0x0
  pushl $76
c0101e4c:	6a 4c                	push   $0x4c
  jmp __alltraps
c0101e4e:	e9 39 fd ff ff       	jmp    c0101b8c <__alltraps>

c0101e53 <vector77>:
.globl vector77
vector77:
  pushl $0
c0101e53:	6a 00                	push   $0x0
  pushl $77
c0101e55:	6a 4d                	push   $0x4d
  jmp __alltraps
c0101e57:	e9 30 fd ff ff       	jmp    c0101b8c <__alltraps>

c0101e5c <vector78>:
.globl vector78
vector78:
  pushl $0
c0101e5c:	6a 00                	push   $0x0
  pushl $78
c0101e5e:	6a 4e                	push   $0x4e
  jmp __alltraps
c0101e60:	e9 27 fd ff ff       	jmp    c0101b8c <__alltraps>

c0101e65 <vector79>:
.globl vector79
vector79:
  pushl $0
c0101e65:	6a 00                	push   $0x0
  pushl $79
c0101e67:	6a 4f                	push   $0x4f
  jmp __alltraps
c0101e69:	e9 1e fd ff ff       	jmp    c0101b8c <__alltraps>

c0101e6e <vector80>:
.globl vector80
vector80:
  pushl $0
c0101e6e:	6a 00                	push   $0x0
  pushl $80
c0101e70:	6a 50                	push   $0x50
  jmp __alltraps
c0101e72:	e9 15 fd ff ff       	jmp    c0101b8c <__alltraps>

c0101e77 <vector81>:
.globl vector81
vector81:
  pushl $0
c0101e77:	6a 00                	push   $0x0
  pushl $81
c0101e79:	6a 51                	push   $0x51
  jmp __alltraps
c0101e7b:	e9 0c fd ff ff       	jmp    c0101b8c <__alltraps>

c0101e80 <vector82>:
.globl vector82
vector82:
  pushl $0
c0101e80:	6a 00                	push   $0x0
  pushl $82
c0101e82:	6a 52                	push   $0x52
  jmp __alltraps
c0101e84:	e9 03 fd ff ff       	jmp    c0101b8c <__alltraps>

c0101e89 <vector83>:
.globl vector83
vector83:
  pushl $0
c0101e89:	6a 00                	push   $0x0
  pushl $83
c0101e8b:	6a 53                	push   $0x53
  jmp __alltraps
c0101e8d:	e9 fa fc ff ff       	jmp    c0101b8c <__alltraps>

c0101e92 <vector84>:
.globl vector84
vector84:
  pushl $0
c0101e92:	6a 00                	push   $0x0
  pushl $84
c0101e94:	6a 54                	push   $0x54
  jmp __alltraps
c0101e96:	e9 f1 fc ff ff       	jmp    c0101b8c <__alltraps>

c0101e9b <vector85>:
.globl vector85
vector85:
  pushl $0
c0101e9b:	6a 00                	push   $0x0
  pushl $85
c0101e9d:	6a 55                	push   $0x55
  jmp __alltraps
c0101e9f:	e9 e8 fc ff ff       	jmp    c0101b8c <__alltraps>

c0101ea4 <vector86>:
.globl vector86
vector86:
  pushl $0
c0101ea4:	6a 00                	push   $0x0
  pushl $86
c0101ea6:	6a 56                	push   $0x56
  jmp __alltraps
c0101ea8:	e9 df fc ff ff       	jmp    c0101b8c <__alltraps>

c0101ead <vector87>:
.globl vector87
vector87:
  pushl $0
c0101ead:	6a 00                	push   $0x0
  pushl $87
c0101eaf:	6a 57                	push   $0x57
  jmp __alltraps
c0101eb1:	e9 d6 fc ff ff       	jmp    c0101b8c <__alltraps>

c0101eb6 <vector88>:
.globl vector88
vector88:
  pushl $0
c0101eb6:	6a 00                	push   $0x0
  pushl $88
c0101eb8:	6a 58                	push   $0x58
  jmp __alltraps
c0101eba:	e9 cd fc ff ff       	jmp    c0101b8c <__alltraps>

c0101ebf <vector89>:
.globl vector89
vector89:
  pushl $0
c0101ebf:	6a 00                	push   $0x0
  pushl $89
c0101ec1:	6a 59                	push   $0x59
  jmp __alltraps
c0101ec3:	e9 c4 fc ff ff       	jmp    c0101b8c <__alltraps>

c0101ec8 <vector90>:
.globl vector90
vector90:
  pushl $0
c0101ec8:	6a 00                	push   $0x0
  pushl $90
c0101eca:	6a 5a                	push   $0x5a
  jmp __alltraps
c0101ecc:	e9 bb fc ff ff       	jmp    c0101b8c <__alltraps>

c0101ed1 <vector91>:
.globl vector91
vector91:
  pushl $0
c0101ed1:	6a 00                	push   $0x0
  pushl $91
c0101ed3:	6a 5b                	push   $0x5b
  jmp __alltraps
c0101ed5:	e9 b2 fc ff ff       	jmp    c0101b8c <__alltraps>

c0101eda <vector92>:
.globl vector92
vector92:
  pushl $0
c0101eda:	6a 00                	push   $0x0
  pushl $92
c0101edc:	6a 5c                	push   $0x5c
  jmp __alltraps
c0101ede:	e9 a9 fc ff ff       	jmp    c0101b8c <__alltraps>

c0101ee3 <vector93>:
.globl vector93
vector93:
  pushl $0
c0101ee3:	6a 00                	push   $0x0
  pushl $93
c0101ee5:	6a 5d                	push   $0x5d
  jmp __alltraps
c0101ee7:	e9 a0 fc ff ff       	jmp    c0101b8c <__alltraps>

c0101eec <vector94>:
.globl vector94
vector94:
  pushl $0
c0101eec:	6a 00                	push   $0x0
  pushl $94
c0101eee:	6a 5e                	push   $0x5e
  jmp __alltraps
c0101ef0:	e9 97 fc ff ff       	jmp    c0101b8c <__alltraps>

c0101ef5 <vector95>:
.globl vector95
vector95:
  pushl $0
c0101ef5:	6a 00                	push   $0x0
  pushl $95
c0101ef7:	6a 5f                	push   $0x5f
  jmp __alltraps
c0101ef9:	e9 8e fc ff ff       	jmp    c0101b8c <__alltraps>

c0101efe <vector96>:
.globl vector96
vector96:
  pushl $0
c0101efe:	6a 00                	push   $0x0
  pushl $96
c0101f00:	6a 60                	push   $0x60
  jmp __alltraps
c0101f02:	e9 85 fc ff ff       	jmp    c0101b8c <__alltraps>

c0101f07 <vector97>:
.globl vector97
vector97:
  pushl $0
c0101f07:	6a 00                	push   $0x0
  pushl $97
c0101f09:	6a 61                	push   $0x61
  jmp __alltraps
c0101f0b:	e9 7c fc ff ff       	jmp    c0101b8c <__alltraps>

c0101f10 <vector98>:
.globl vector98
vector98:
  pushl $0
c0101f10:	6a 00                	push   $0x0
  pushl $98
c0101f12:	6a 62                	push   $0x62
  jmp __alltraps
c0101f14:	e9 73 fc ff ff       	jmp    c0101b8c <__alltraps>

c0101f19 <vector99>:
.globl vector99
vector99:
  pushl $0
c0101f19:	6a 00                	push   $0x0
  pushl $99
c0101f1b:	6a 63                	push   $0x63
  jmp __alltraps
c0101f1d:	e9 6a fc ff ff       	jmp    c0101b8c <__alltraps>

c0101f22 <vector100>:
.globl vector100
vector100:
  pushl $0
c0101f22:	6a 00                	push   $0x0
  pushl $100
c0101f24:	6a 64                	push   $0x64
  jmp __alltraps
c0101f26:	e9 61 fc ff ff       	jmp    c0101b8c <__alltraps>

c0101f2b <vector101>:
.globl vector101
vector101:
  pushl $0
c0101f2b:	6a 00                	push   $0x0
  pushl $101
c0101f2d:	6a 65                	push   $0x65
  jmp __alltraps
c0101f2f:	e9 58 fc ff ff       	jmp    c0101b8c <__alltraps>

c0101f34 <vector102>:
.globl vector102
vector102:
  pushl $0
c0101f34:	6a 00                	push   $0x0
  pushl $102
c0101f36:	6a 66                	push   $0x66
  jmp __alltraps
c0101f38:	e9 4f fc ff ff       	jmp    c0101b8c <__alltraps>

c0101f3d <vector103>:
.globl vector103
vector103:
  pushl $0
c0101f3d:	6a 00                	push   $0x0
  pushl $103
c0101f3f:	6a 67                	push   $0x67
  jmp __alltraps
c0101f41:	e9 46 fc ff ff       	jmp    c0101b8c <__alltraps>

c0101f46 <vector104>:
.globl vector104
vector104:
  pushl $0
c0101f46:	6a 00                	push   $0x0
  pushl $104
c0101f48:	6a 68                	push   $0x68
  jmp __alltraps
c0101f4a:	e9 3d fc ff ff       	jmp    c0101b8c <__alltraps>

c0101f4f <vector105>:
.globl vector105
vector105:
  pushl $0
c0101f4f:	6a 00                	push   $0x0
  pushl $105
c0101f51:	6a 69                	push   $0x69
  jmp __alltraps
c0101f53:	e9 34 fc ff ff       	jmp    c0101b8c <__alltraps>

c0101f58 <vector106>:
.globl vector106
vector106:
  pushl $0
c0101f58:	6a 00                	push   $0x0
  pushl $106
c0101f5a:	6a 6a                	push   $0x6a
  jmp __alltraps
c0101f5c:	e9 2b fc ff ff       	jmp    c0101b8c <__alltraps>

c0101f61 <vector107>:
.globl vector107
vector107:
  pushl $0
c0101f61:	6a 00                	push   $0x0
  pushl $107
c0101f63:	6a 6b                	push   $0x6b
  jmp __alltraps
c0101f65:	e9 22 fc ff ff       	jmp    c0101b8c <__alltraps>

c0101f6a <vector108>:
.globl vector108
vector108:
  pushl $0
c0101f6a:	6a 00                	push   $0x0
  pushl $108
c0101f6c:	6a 6c                	push   $0x6c
  jmp __alltraps
c0101f6e:	e9 19 fc ff ff       	jmp    c0101b8c <__alltraps>

c0101f73 <vector109>:
.globl vector109
vector109:
  pushl $0
c0101f73:	6a 00                	push   $0x0
  pushl $109
c0101f75:	6a 6d                	push   $0x6d
  jmp __alltraps
c0101f77:	e9 10 fc ff ff       	jmp    c0101b8c <__alltraps>

c0101f7c <vector110>:
.globl vector110
vector110:
  pushl $0
c0101f7c:	6a 00                	push   $0x0
  pushl $110
c0101f7e:	6a 6e                	push   $0x6e
  jmp __alltraps
c0101f80:	e9 07 fc ff ff       	jmp    c0101b8c <__alltraps>

c0101f85 <vector111>:
.globl vector111
vector111:
  pushl $0
c0101f85:	6a 00                	push   $0x0
  pushl $111
c0101f87:	6a 6f                	push   $0x6f
  jmp __alltraps
c0101f89:	e9 fe fb ff ff       	jmp    c0101b8c <__alltraps>

c0101f8e <vector112>:
.globl vector112
vector112:
  pushl $0
c0101f8e:	6a 00                	push   $0x0
  pushl $112
c0101f90:	6a 70                	push   $0x70
  jmp __alltraps
c0101f92:	e9 f5 fb ff ff       	jmp    c0101b8c <__alltraps>

c0101f97 <vector113>:
.globl vector113
vector113:
  pushl $0
c0101f97:	6a 00                	push   $0x0
  pushl $113
c0101f99:	6a 71                	push   $0x71
  jmp __alltraps
c0101f9b:	e9 ec fb ff ff       	jmp    c0101b8c <__alltraps>

c0101fa0 <vector114>:
.globl vector114
vector114:
  pushl $0
c0101fa0:	6a 00                	push   $0x0
  pushl $114
c0101fa2:	6a 72                	push   $0x72
  jmp __alltraps
c0101fa4:	e9 e3 fb ff ff       	jmp    c0101b8c <__alltraps>

c0101fa9 <vector115>:
.globl vector115
vector115:
  pushl $0
c0101fa9:	6a 00                	push   $0x0
  pushl $115
c0101fab:	6a 73                	push   $0x73
  jmp __alltraps
c0101fad:	e9 da fb ff ff       	jmp    c0101b8c <__alltraps>

c0101fb2 <vector116>:
.globl vector116
vector116:
  pushl $0
c0101fb2:	6a 00                	push   $0x0
  pushl $116
c0101fb4:	6a 74                	push   $0x74
  jmp __alltraps
c0101fb6:	e9 d1 fb ff ff       	jmp    c0101b8c <__alltraps>

c0101fbb <vector117>:
.globl vector117
vector117:
  pushl $0
c0101fbb:	6a 00                	push   $0x0
  pushl $117
c0101fbd:	6a 75                	push   $0x75
  jmp __alltraps
c0101fbf:	e9 c8 fb ff ff       	jmp    c0101b8c <__alltraps>

c0101fc4 <vector118>:
.globl vector118
vector118:
  pushl $0
c0101fc4:	6a 00                	push   $0x0
  pushl $118
c0101fc6:	6a 76                	push   $0x76
  jmp __alltraps
c0101fc8:	e9 bf fb ff ff       	jmp    c0101b8c <__alltraps>

c0101fcd <vector119>:
.globl vector119
vector119:
  pushl $0
c0101fcd:	6a 00                	push   $0x0
  pushl $119
c0101fcf:	6a 77                	push   $0x77
  jmp __alltraps
c0101fd1:	e9 b6 fb ff ff       	jmp    c0101b8c <__alltraps>

c0101fd6 <vector120>:
.globl vector120
vector120:
  pushl $0
c0101fd6:	6a 00                	push   $0x0
  pushl $120
c0101fd8:	6a 78                	push   $0x78
  jmp __alltraps
c0101fda:	e9 ad fb ff ff       	jmp    c0101b8c <__alltraps>

c0101fdf <vector121>:
.globl vector121
vector121:
  pushl $0
c0101fdf:	6a 00                	push   $0x0
  pushl $121
c0101fe1:	6a 79                	push   $0x79
  jmp __alltraps
c0101fe3:	e9 a4 fb ff ff       	jmp    c0101b8c <__alltraps>

c0101fe8 <vector122>:
.globl vector122
vector122:
  pushl $0
c0101fe8:	6a 00                	push   $0x0
  pushl $122
c0101fea:	6a 7a                	push   $0x7a
  jmp __alltraps
c0101fec:	e9 9b fb ff ff       	jmp    c0101b8c <__alltraps>

c0101ff1 <vector123>:
.globl vector123
vector123:
  pushl $0
c0101ff1:	6a 00                	push   $0x0
  pushl $123
c0101ff3:	6a 7b                	push   $0x7b
  jmp __alltraps
c0101ff5:	e9 92 fb ff ff       	jmp    c0101b8c <__alltraps>

c0101ffa <vector124>:
.globl vector124
vector124:
  pushl $0
c0101ffa:	6a 00                	push   $0x0
  pushl $124
c0101ffc:	6a 7c                	push   $0x7c
  jmp __alltraps
c0101ffe:	e9 89 fb ff ff       	jmp    c0101b8c <__alltraps>

c0102003 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102003:	6a 00                	push   $0x0
  pushl $125
c0102005:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102007:	e9 80 fb ff ff       	jmp    c0101b8c <__alltraps>

c010200c <vector126>:
.globl vector126
vector126:
  pushl $0
c010200c:	6a 00                	push   $0x0
  pushl $126
c010200e:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102010:	e9 77 fb ff ff       	jmp    c0101b8c <__alltraps>

c0102015 <vector127>:
.globl vector127
vector127:
  pushl $0
c0102015:	6a 00                	push   $0x0
  pushl $127
c0102017:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102019:	e9 6e fb ff ff       	jmp    c0101b8c <__alltraps>

c010201e <vector128>:
.globl vector128
vector128:
  pushl $0
c010201e:	6a 00                	push   $0x0
  pushl $128
c0102020:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102025:	e9 62 fb ff ff       	jmp    c0101b8c <__alltraps>

c010202a <vector129>:
.globl vector129
vector129:
  pushl $0
c010202a:	6a 00                	push   $0x0
  pushl $129
c010202c:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102031:	e9 56 fb ff ff       	jmp    c0101b8c <__alltraps>

c0102036 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102036:	6a 00                	push   $0x0
  pushl $130
c0102038:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c010203d:	e9 4a fb ff ff       	jmp    c0101b8c <__alltraps>

c0102042 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102042:	6a 00                	push   $0x0
  pushl $131
c0102044:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102049:	e9 3e fb ff ff       	jmp    c0101b8c <__alltraps>

c010204e <vector132>:
.globl vector132
vector132:
  pushl $0
c010204e:	6a 00                	push   $0x0
  pushl $132
c0102050:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102055:	e9 32 fb ff ff       	jmp    c0101b8c <__alltraps>

c010205a <vector133>:
.globl vector133
vector133:
  pushl $0
c010205a:	6a 00                	push   $0x0
  pushl $133
c010205c:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102061:	e9 26 fb ff ff       	jmp    c0101b8c <__alltraps>

c0102066 <vector134>:
.globl vector134
vector134:
  pushl $0
c0102066:	6a 00                	push   $0x0
  pushl $134
c0102068:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c010206d:	e9 1a fb ff ff       	jmp    c0101b8c <__alltraps>

c0102072 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102072:	6a 00                	push   $0x0
  pushl $135
c0102074:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102079:	e9 0e fb ff ff       	jmp    c0101b8c <__alltraps>

c010207e <vector136>:
.globl vector136
vector136:
  pushl $0
c010207e:	6a 00                	push   $0x0
  pushl $136
c0102080:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102085:	e9 02 fb ff ff       	jmp    c0101b8c <__alltraps>

c010208a <vector137>:
.globl vector137
vector137:
  pushl $0
c010208a:	6a 00                	push   $0x0
  pushl $137
c010208c:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102091:	e9 f6 fa ff ff       	jmp    c0101b8c <__alltraps>

c0102096 <vector138>:
.globl vector138
vector138:
  pushl $0
c0102096:	6a 00                	push   $0x0
  pushl $138
c0102098:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c010209d:	e9 ea fa ff ff       	jmp    c0101b8c <__alltraps>

c01020a2 <vector139>:
.globl vector139
vector139:
  pushl $0
c01020a2:	6a 00                	push   $0x0
  pushl $139
c01020a4:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01020a9:	e9 de fa ff ff       	jmp    c0101b8c <__alltraps>

c01020ae <vector140>:
.globl vector140
vector140:
  pushl $0
c01020ae:	6a 00                	push   $0x0
  pushl $140
c01020b0:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01020b5:	e9 d2 fa ff ff       	jmp    c0101b8c <__alltraps>

c01020ba <vector141>:
.globl vector141
vector141:
  pushl $0
c01020ba:	6a 00                	push   $0x0
  pushl $141
c01020bc:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01020c1:	e9 c6 fa ff ff       	jmp    c0101b8c <__alltraps>

c01020c6 <vector142>:
.globl vector142
vector142:
  pushl $0
c01020c6:	6a 00                	push   $0x0
  pushl $142
c01020c8:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01020cd:	e9 ba fa ff ff       	jmp    c0101b8c <__alltraps>

c01020d2 <vector143>:
.globl vector143
vector143:
  pushl $0
c01020d2:	6a 00                	push   $0x0
  pushl $143
c01020d4:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01020d9:	e9 ae fa ff ff       	jmp    c0101b8c <__alltraps>

c01020de <vector144>:
.globl vector144
vector144:
  pushl $0
c01020de:	6a 00                	push   $0x0
  pushl $144
c01020e0:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01020e5:	e9 a2 fa ff ff       	jmp    c0101b8c <__alltraps>

c01020ea <vector145>:
.globl vector145
vector145:
  pushl $0
c01020ea:	6a 00                	push   $0x0
  pushl $145
c01020ec:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01020f1:	e9 96 fa ff ff       	jmp    c0101b8c <__alltraps>

c01020f6 <vector146>:
.globl vector146
vector146:
  pushl $0
c01020f6:	6a 00                	push   $0x0
  pushl $146
c01020f8:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01020fd:	e9 8a fa ff ff       	jmp    c0101b8c <__alltraps>

c0102102 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102102:	6a 00                	push   $0x0
  pushl $147
c0102104:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102109:	e9 7e fa ff ff       	jmp    c0101b8c <__alltraps>

c010210e <vector148>:
.globl vector148
vector148:
  pushl $0
c010210e:	6a 00                	push   $0x0
  pushl $148
c0102110:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102115:	e9 72 fa ff ff       	jmp    c0101b8c <__alltraps>

c010211a <vector149>:
.globl vector149
vector149:
  pushl $0
c010211a:	6a 00                	push   $0x0
  pushl $149
c010211c:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102121:	e9 66 fa ff ff       	jmp    c0101b8c <__alltraps>

c0102126 <vector150>:
.globl vector150
vector150:
  pushl $0
c0102126:	6a 00                	push   $0x0
  pushl $150
c0102128:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c010212d:	e9 5a fa ff ff       	jmp    c0101b8c <__alltraps>

c0102132 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102132:	6a 00                	push   $0x0
  pushl $151
c0102134:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102139:	e9 4e fa ff ff       	jmp    c0101b8c <__alltraps>

c010213e <vector152>:
.globl vector152
vector152:
  pushl $0
c010213e:	6a 00                	push   $0x0
  pushl $152
c0102140:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102145:	e9 42 fa ff ff       	jmp    c0101b8c <__alltraps>

c010214a <vector153>:
.globl vector153
vector153:
  pushl $0
c010214a:	6a 00                	push   $0x0
  pushl $153
c010214c:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102151:	e9 36 fa ff ff       	jmp    c0101b8c <__alltraps>

c0102156 <vector154>:
.globl vector154
vector154:
  pushl $0
c0102156:	6a 00                	push   $0x0
  pushl $154
c0102158:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c010215d:	e9 2a fa ff ff       	jmp    c0101b8c <__alltraps>

c0102162 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102162:	6a 00                	push   $0x0
  pushl $155
c0102164:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102169:	e9 1e fa ff ff       	jmp    c0101b8c <__alltraps>

c010216e <vector156>:
.globl vector156
vector156:
  pushl $0
c010216e:	6a 00                	push   $0x0
  pushl $156
c0102170:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102175:	e9 12 fa ff ff       	jmp    c0101b8c <__alltraps>

c010217a <vector157>:
.globl vector157
vector157:
  pushl $0
c010217a:	6a 00                	push   $0x0
  pushl $157
c010217c:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102181:	e9 06 fa ff ff       	jmp    c0101b8c <__alltraps>

c0102186 <vector158>:
.globl vector158
vector158:
  pushl $0
c0102186:	6a 00                	push   $0x0
  pushl $158
c0102188:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c010218d:	e9 fa f9 ff ff       	jmp    c0101b8c <__alltraps>

c0102192 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102192:	6a 00                	push   $0x0
  pushl $159
c0102194:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102199:	e9 ee f9 ff ff       	jmp    c0101b8c <__alltraps>

c010219e <vector160>:
.globl vector160
vector160:
  pushl $0
c010219e:	6a 00                	push   $0x0
  pushl $160
c01021a0:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01021a5:	e9 e2 f9 ff ff       	jmp    c0101b8c <__alltraps>

c01021aa <vector161>:
.globl vector161
vector161:
  pushl $0
c01021aa:	6a 00                	push   $0x0
  pushl $161
c01021ac:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01021b1:	e9 d6 f9 ff ff       	jmp    c0101b8c <__alltraps>

c01021b6 <vector162>:
.globl vector162
vector162:
  pushl $0
c01021b6:	6a 00                	push   $0x0
  pushl $162
c01021b8:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01021bd:	e9 ca f9 ff ff       	jmp    c0101b8c <__alltraps>

c01021c2 <vector163>:
.globl vector163
vector163:
  pushl $0
c01021c2:	6a 00                	push   $0x0
  pushl $163
c01021c4:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01021c9:	e9 be f9 ff ff       	jmp    c0101b8c <__alltraps>

c01021ce <vector164>:
.globl vector164
vector164:
  pushl $0
c01021ce:	6a 00                	push   $0x0
  pushl $164
c01021d0:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01021d5:	e9 b2 f9 ff ff       	jmp    c0101b8c <__alltraps>

c01021da <vector165>:
.globl vector165
vector165:
  pushl $0
c01021da:	6a 00                	push   $0x0
  pushl $165
c01021dc:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01021e1:	e9 a6 f9 ff ff       	jmp    c0101b8c <__alltraps>

c01021e6 <vector166>:
.globl vector166
vector166:
  pushl $0
c01021e6:	6a 00                	push   $0x0
  pushl $166
c01021e8:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01021ed:	e9 9a f9 ff ff       	jmp    c0101b8c <__alltraps>

c01021f2 <vector167>:
.globl vector167
vector167:
  pushl $0
c01021f2:	6a 00                	push   $0x0
  pushl $167
c01021f4:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01021f9:	e9 8e f9 ff ff       	jmp    c0101b8c <__alltraps>

c01021fe <vector168>:
.globl vector168
vector168:
  pushl $0
c01021fe:	6a 00                	push   $0x0
  pushl $168
c0102200:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102205:	e9 82 f9 ff ff       	jmp    c0101b8c <__alltraps>

c010220a <vector169>:
.globl vector169
vector169:
  pushl $0
c010220a:	6a 00                	push   $0x0
  pushl $169
c010220c:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102211:	e9 76 f9 ff ff       	jmp    c0101b8c <__alltraps>

c0102216 <vector170>:
.globl vector170
vector170:
  pushl $0
c0102216:	6a 00                	push   $0x0
  pushl $170
c0102218:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c010221d:	e9 6a f9 ff ff       	jmp    c0101b8c <__alltraps>

c0102222 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102222:	6a 00                	push   $0x0
  pushl $171
c0102224:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102229:	e9 5e f9 ff ff       	jmp    c0101b8c <__alltraps>

c010222e <vector172>:
.globl vector172
vector172:
  pushl $0
c010222e:	6a 00                	push   $0x0
  pushl $172
c0102230:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102235:	e9 52 f9 ff ff       	jmp    c0101b8c <__alltraps>

c010223a <vector173>:
.globl vector173
vector173:
  pushl $0
c010223a:	6a 00                	push   $0x0
  pushl $173
c010223c:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102241:	e9 46 f9 ff ff       	jmp    c0101b8c <__alltraps>

c0102246 <vector174>:
.globl vector174
vector174:
  pushl $0
c0102246:	6a 00                	push   $0x0
  pushl $174
c0102248:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c010224d:	e9 3a f9 ff ff       	jmp    c0101b8c <__alltraps>

c0102252 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102252:	6a 00                	push   $0x0
  pushl $175
c0102254:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102259:	e9 2e f9 ff ff       	jmp    c0101b8c <__alltraps>

c010225e <vector176>:
.globl vector176
vector176:
  pushl $0
c010225e:	6a 00                	push   $0x0
  pushl $176
c0102260:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102265:	e9 22 f9 ff ff       	jmp    c0101b8c <__alltraps>

c010226a <vector177>:
.globl vector177
vector177:
  pushl $0
c010226a:	6a 00                	push   $0x0
  pushl $177
c010226c:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102271:	e9 16 f9 ff ff       	jmp    c0101b8c <__alltraps>

c0102276 <vector178>:
.globl vector178
vector178:
  pushl $0
c0102276:	6a 00                	push   $0x0
  pushl $178
c0102278:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c010227d:	e9 0a f9 ff ff       	jmp    c0101b8c <__alltraps>

c0102282 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102282:	6a 00                	push   $0x0
  pushl $179
c0102284:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102289:	e9 fe f8 ff ff       	jmp    c0101b8c <__alltraps>

c010228e <vector180>:
.globl vector180
vector180:
  pushl $0
c010228e:	6a 00                	push   $0x0
  pushl $180
c0102290:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102295:	e9 f2 f8 ff ff       	jmp    c0101b8c <__alltraps>

c010229a <vector181>:
.globl vector181
vector181:
  pushl $0
c010229a:	6a 00                	push   $0x0
  pushl $181
c010229c:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01022a1:	e9 e6 f8 ff ff       	jmp    c0101b8c <__alltraps>

c01022a6 <vector182>:
.globl vector182
vector182:
  pushl $0
c01022a6:	6a 00                	push   $0x0
  pushl $182
c01022a8:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01022ad:	e9 da f8 ff ff       	jmp    c0101b8c <__alltraps>

c01022b2 <vector183>:
.globl vector183
vector183:
  pushl $0
c01022b2:	6a 00                	push   $0x0
  pushl $183
c01022b4:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01022b9:	e9 ce f8 ff ff       	jmp    c0101b8c <__alltraps>

c01022be <vector184>:
.globl vector184
vector184:
  pushl $0
c01022be:	6a 00                	push   $0x0
  pushl $184
c01022c0:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01022c5:	e9 c2 f8 ff ff       	jmp    c0101b8c <__alltraps>

c01022ca <vector185>:
.globl vector185
vector185:
  pushl $0
c01022ca:	6a 00                	push   $0x0
  pushl $185
c01022cc:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01022d1:	e9 b6 f8 ff ff       	jmp    c0101b8c <__alltraps>

c01022d6 <vector186>:
.globl vector186
vector186:
  pushl $0
c01022d6:	6a 00                	push   $0x0
  pushl $186
c01022d8:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01022dd:	e9 aa f8 ff ff       	jmp    c0101b8c <__alltraps>

c01022e2 <vector187>:
.globl vector187
vector187:
  pushl $0
c01022e2:	6a 00                	push   $0x0
  pushl $187
c01022e4:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01022e9:	e9 9e f8 ff ff       	jmp    c0101b8c <__alltraps>

c01022ee <vector188>:
.globl vector188
vector188:
  pushl $0
c01022ee:	6a 00                	push   $0x0
  pushl $188
c01022f0:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01022f5:	e9 92 f8 ff ff       	jmp    c0101b8c <__alltraps>

c01022fa <vector189>:
.globl vector189
vector189:
  pushl $0
c01022fa:	6a 00                	push   $0x0
  pushl $189
c01022fc:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102301:	e9 86 f8 ff ff       	jmp    c0101b8c <__alltraps>

c0102306 <vector190>:
.globl vector190
vector190:
  pushl $0
c0102306:	6a 00                	push   $0x0
  pushl $190
c0102308:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c010230d:	e9 7a f8 ff ff       	jmp    c0101b8c <__alltraps>

c0102312 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102312:	6a 00                	push   $0x0
  pushl $191
c0102314:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c0102319:	e9 6e f8 ff ff       	jmp    c0101b8c <__alltraps>

c010231e <vector192>:
.globl vector192
vector192:
  pushl $0
c010231e:	6a 00                	push   $0x0
  pushl $192
c0102320:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c0102325:	e9 62 f8 ff ff       	jmp    c0101b8c <__alltraps>

c010232a <vector193>:
.globl vector193
vector193:
  pushl $0
c010232a:	6a 00                	push   $0x0
  pushl $193
c010232c:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102331:	e9 56 f8 ff ff       	jmp    c0101b8c <__alltraps>

c0102336 <vector194>:
.globl vector194
vector194:
  pushl $0
c0102336:	6a 00                	push   $0x0
  pushl $194
c0102338:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c010233d:	e9 4a f8 ff ff       	jmp    c0101b8c <__alltraps>

c0102342 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102342:	6a 00                	push   $0x0
  pushl $195
c0102344:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102349:	e9 3e f8 ff ff       	jmp    c0101b8c <__alltraps>

c010234e <vector196>:
.globl vector196
vector196:
  pushl $0
c010234e:	6a 00                	push   $0x0
  pushl $196
c0102350:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c0102355:	e9 32 f8 ff ff       	jmp    c0101b8c <__alltraps>

c010235a <vector197>:
.globl vector197
vector197:
  pushl $0
c010235a:	6a 00                	push   $0x0
  pushl $197
c010235c:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102361:	e9 26 f8 ff ff       	jmp    c0101b8c <__alltraps>

c0102366 <vector198>:
.globl vector198
vector198:
  pushl $0
c0102366:	6a 00                	push   $0x0
  pushl $198
c0102368:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c010236d:	e9 1a f8 ff ff       	jmp    c0101b8c <__alltraps>

c0102372 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102372:	6a 00                	push   $0x0
  pushl $199
c0102374:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102379:	e9 0e f8 ff ff       	jmp    c0101b8c <__alltraps>

c010237e <vector200>:
.globl vector200
vector200:
  pushl $0
c010237e:	6a 00                	push   $0x0
  pushl $200
c0102380:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c0102385:	e9 02 f8 ff ff       	jmp    c0101b8c <__alltraps>

c010238a <vector201>:
.globl vector201
vector201:
  pushl $0
c010238a:	6a 00                	push   $0x0
  pushl $201
c010238c:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102391:	e9 f6 f7 ff ff       	jmp    c0101b8c <__alltraps>

c0102396 <vector202>:
.globl vector202
vector202:
  pushl $0
c0102396:	6a 00                	push   $0x0
  pushl $202
c0102398:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c010239d:	e9 ea f7 ff ff       	jmp    c0101b8c <__alltraps>

c01023a2 <vector203>:
.globl vector203
vector203:
  pushl $0
c01023a2:	6a 00                	push   $0x0
  pushl $203
c01023a4:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01023a9:	e9 de f7 ff ff       	jmp    c0101b8c <__alltraps>

c01023ae <vector204>:
.globl vector204
vector204:
  pushl $0
c01023ae:	6a 00                	push   $0x0
  pushl $204
c01023b0:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01023b5:	e9 d2 f7 ff ff       	jmp    c0101b8c <__alltraps>

c01023ba <vector205>:
.globl vector205
vector205:
  pushl $0
c01023ba:	6a 00                	push   $0x0
  pushl $205
c01023bc:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01023c1:	e9 c6 f7 ff ff       	jmp    c0101b8c <__alltraps>

c01023c6 <vector206>:
.globl vector206
vector206:
  pushl $0
c01023c6:	6a 00                	push   $0x0
  pushl $206
c01023c8:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01023cd:	e9 ba f7 ff ff       	jmp    c0101b8c <__alltraps>

c01023d2 <vector207>:
.globl vector207
vector207:
  pushl $0
c01023d2:	6a 00                	push   $0x0
  pushl $207
c01023d4:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01023d9:	e9 ae f7 ff ff       	jmp    c0101b8c <__alltraps>

c01023de <vector208>:
.globl vector208
vector208:
  pushl $0
c01023de:	6a 00                	push   $0x0
  pushl $208
c01023e0:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01023e5:	e9 a2 f7 ff ff       	jmp    c0101b8c <__alltraps>

c01023ea <vector209>:
.globl vector209
vector209:
  pushl $0
c01023ea:	6a 00                	push   $0x0
  pushl $209
c01023ec:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01023f1:	e9 96 f7 ff ff       	jmp    c0101b8c <__alltraps>

c01023f6 <vector210>:
.globl vector210
vector210:
  pushl $0
c01023f6:	6a 00                	push   $0x0
  pushl $210
c01023f8:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01023fd:	e9 8a f7 ff ff       	jmp    c0101b8c <__alltraps>

c0102402 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102402:	6a 00                	push   $0x0
  pushl $211
c0102404:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c0102409:	e9 7e f7 ff ff       	jmp    c0101b8c <__alltraps>

c010240e <vector212>:
.globl vector212
vector212:
  pushl $0
c010240e:	6a 00                	push   $0x0
  pushl $212
c0102410:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c0102415:	e9 72 f7 ff ff       	jmp    c0101b8c <__alltraps>

c010241a <vector213>:
.globl vector213
vector213:
  pushl $0
c010241a:	6a 00                	push   $0x0
  pushl $213
c010241c:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102421:	e9 66 f7 ff ff       	jmp    c0101b8c <__alltraps>

c0102426 <vector214>:
.globl vector214
vector214:
  pushl $0
c0102426:	6a 00                	push   $0x0
  pushl $214
c0102428:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c010242d:	e9 5a f7 ff ff       	jmp    c0101b8c <__alltraps>

c0102432 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102432:	6a 00                	push   $0x0
  pushl $215
c0102434:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102439:	e9 4e f7 ff ff       	jmp    c0101b8c <__alltraps>

c010243e <vector216>:
.globl vector216
vector216:
  pushl $0
c010243e:	6a 00                	push   $0x0
  pushl $216
c0102440:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c0102445:	e9 42 f7 ff ff       	jmp    c0101b8c <__alltraps>

c010244a <vector217>:
.globl vector217
vector217:
  pushl $0
c010244a:	6a 00                	push   $0x0
  pushl $217
c010244c:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102451:	e9 36 f7 ff ff       	jmp    c0101b8c <__alltraps>

c0102456 <vector218>:
.globl vector218
vector218:
  pushl $0
c0102456:	6a 00                	push   $0x0
  pushl $218
c0102458:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c010245d:	e9 2a f7 ff ff       	jmp    c0101b8c <__alltraps>

c0102462 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102462:	6a 00                	push   $0x0
  pushl $219
c0102464:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102469:	e9 1e f7 ff ff       	jmp    c0101b8c <__alltraps>

c010246e <vector220>:
.globl vector220
vector220:
  pushl $0
c010246e:	6a 00                	push   $0x0
  pushl $220
c0102470:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c0102475:	e9 12 f7 ff ff       	jmp    c0101b8c <__alltraps>

c010247a <vector221>:
.globl vector221
vector221:
  pushl $0
c010247a:	6a 00                	push   $0x0
  pushl $221
c010247c:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102481:	e9 06 f7 ff ff       	jmp    c0101b8c <__alltraps>

c0102486 <vector222>:
.globl vector222
vector222:
  pushl $0
c0102486:	6a 00                	push   $0x0
  pushl $222
c0102488:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c010248d:	e9 fa f6 ff ff       	jmp    c0101b8c <__alltraps>

c0102492 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102492:	6a 00                	push   $0x0
  pushl $223
c0102494:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102499:	e9 ee f6 ff ff       	jmp    c0101b8c <__alltraps>

c010249e <vector224>:
.globl vector224
vector224:
  pushl $0
c010249e:	6a 00                	push   $0x0
  pushl $224
c01024a0:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01024a5:	e9 e2 f6 ff ff       	jmp    c0101b8c <__alltraps>

c01024aa <vector225>:
.globl vector225
vector225:
  pushl $0
c01024aa:	6a 00                	push   $0x0
  pushl $225
c01024ac:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01024b1:	e9 d6 f6 ff ff       	jmp    c0101b8c <__alltraps>

c01024b6 <vector226>:
.globl vector226
vector226:
  pushl $0
c01024b6:	6a 00                	push   $0x0
  pushl $226
c01024b8:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01024bd:	e9 ca f6 ff ff       	jmp    c0101b8c <__alltraps>

c01024c2 <vector227>:
.globl vector227
vector227:
  pushl $0
c01024c2:	6a 00                	push   $0x0
  pushl $227
c01024c4:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01024c9:	e9 be f6 ff ff       	jmp    c0101b8c <__alltraps>

c01024ce <vector228>:
.globl vector228
vector228:
  pushl $0
c01024ce:	6a 00                	push   $0x0
  pushl $228
c01024d0:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01024d5:	e9 b2 f6 ff ff       	jmp    c0101b8c <__alltraps>

c01024da <vector229>:
.globl vector229
vector229:
  pushl $0
c01024da:	6a 00                	push   $0x0
  pushl $229
c01024dc:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01024e1:	e9 a6 f6 ff ff       	jmp    c0101b8c <__alltraps>

c01024e6 <vector230>:
.globl vector230
vector230:
  pushl $0
c01024e6:	6a 00                	push   $0x0
  pushl $230
c01024e8:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01024ed:	e9 9a f6 ff ff       	jmp    c0101b8c <__alltraps>

c01024f2 <vector231>:
.globl vector231
vector231:
  pushl $0
c01024f2:	6a 00                	push   $0x0
  pushl $231
c01024f4:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01024f9:	e9 8e f6 ff ff       	jmp    c0101b8c <__alltraps>

c01024fe <vector232>:
.globl vector232
vector232:
  pushl $0
c01024fe:	6a 00                	push   $0x0
  pushl $232
c0102500:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c0102505:	e9 82 f6 ff ff       	jmp    c0101b8c <__alltraps>

c010250a <vector233>:
.globl vector233
vector233:
  pushl $0
c010250a:	6a 00                	push   $0x0
  pushl $233
c010250c:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102511:	e9 76 f6 ff ff       	jmp    c0101b8c <__alltraps>

c0102516 <vector234>:
.globl vector234
vector234:
  pushl $0
c0102516:	6a 00                	push   $0x0
  pushl $234
c0102518:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c010251d:	e9 6a f6 ff ff       	jmp    c0101b8c <__alltraps>

c0102522 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102522:	6a 00                	push   $0x0
  pushl $235
c0102524:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102529:	e9 5e f6 ff ff       	jmp    c0101b8c <__alltraps>

c010252e <vector236>:
.globl vector236
vector236:
  pushl $0
c010252e:	6a 00                	push   $0x0
  pushl $236
c0102530:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c0102535:	e9 52 f6 ff ff       	jmp    c0101b8c <__alltraps>

c010253a <vector237>:
.globl vector237
vector237:
  pushl $0
c010253a:	6a 00                	push   $0x0
  pushl $237
c010253c:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102541:	e9 46 f6 ff ff       	jmp    c0101b8c <__alltraps>

c0102546 <vector238>:
.globl vector238
vector238:
  pushl $0
c0102546:	6a 00                	push   $0x0
  pushl $238
c0102548:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c010254d:	e9 3a f6 ff ff       	jmp    c0101b8c <__alltraps>

c0102552 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102552:	6a 00                	push   $0x0
  pushl $239
c0102554:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102559:	e9 2e f6 ff ff       	jmp    c0101b8c <__alltraps>

c010255e <vector240>:
.globl vector240
vector240:
  pushl $0
c010255e:	6a 00                	push   $0x0
  pushl $240
c0102560:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c0102565:	e9 22 f6 ff ff       	jmp    c0101b8c <__alltraps>

c010256a <vector241>:
.globl vector241
vector241:
  pushl $0
c010256a:	6a 00                	push   $0x0
  pushl $241
c010256c:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102571:	e9 16 f6 ff ff       	jmp    c0101b8c <__alltraps>

c0102576 <vector242>:
.globl vector242
vector242:
  pushl $0
c0102576:	6a 00                	push   $0x0
  pushl $242
c0102578:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c010257d:	e9 0a f6 ff ff       	jmp    c0101b8c <__alltraps>

c0102582 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102582:	6a 00                	push   $0x0
  pushl $243
c0102584:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102589:	e9 fe f5 ff ff       	jmp    c0101b8c <__alltraps>

c010258e <vector244>:
.globl vector244
vector244:
  pushl $0
c010258e:	6a 00                	push   $0x0
  pushl $244
c0102590:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c0102595:	e9 f2 f5 ff ff       	jmp    c0101b8c <__alltraps>

c010259a <vector245>:
.globl vector245
vector245:
  pushl $0
c010259a:	6a 00                	push   $0x0
  pushl $245
c010259c:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01025a1:	e9 e6 f5 ff ff       	jmp    c0101b8c <__alltraps>

c01025a6 <vector246>:
.globl vector246
vector246:
  pushl $0
c01025a6:	6a 00                	push   $0x0
  pushl $246
c01025a8:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01025ad:	e9 da f5 ff ff       	jmp    c0101b8c <__alltraps>

c01025b2 <vector247>:
.globl vector247
vector247:
  pushl $0
c01025b2:	6a 00                	push   $0x0
  pushl $247
c01025b4:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01025b9:	e9 ce f5 ff ff       	jmp    c0101b8c <__alltraps>

c01025be <vector248>:
.globl vector248
vector248:
  pushl $0
c01025be:	6a 00                	push   $0x0
  pushl $248
c01025c0:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01025c5:	e9 c2 f5 ff ff       	jmp    c0101b8c <__alltraps>

c01025ca <vector249>:
.globl vector249
vector249:
  pushl $0
c01025ca:	6a 00                	push   $0x0
  pushl $249
c01025cc:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01025d1:	e9 b6 f5 ff ff       	jmp    c0101b8c <__alltraps>

c01025d6 <vector250>:
.globl vector250
vector250:
  pushl $0
c01025d6:	6a 00                	push   $0x0
  pushl $250
c01025d8:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01025dd:	e9 aa f5 ff ff       	jmp    c0101b8c <__alltraps>

c01025e2 <vector251>:
.globl vector251
vector251:
  pushl $0
c01025e2:	6a 00                	push   $0x0
  pushl $251
c01025e4:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01025e9:	e9 9e f5 ff ff       	jmp    c0101b8c <__alltraps>

c01025ee <vector252>:
.globl vector252
vector252:
  pushl $0
c01025ee:	6a 00                	push   $0x0
  pushl $252
c01025f0:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01025f5:	e9 92 f5 ff ff       	jmp    c0101b8c <__alltraps>

c01025fa <vector253>:
.globl vector253
vector253:
  pushl $0
c01025fa:	6a 00                	push   $0x0
  pushl $253
c01025fc:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102601:	e9 86 f5 ff ff       	jmp    c0101b8c <__alltraps>

c0102606 <vector254>:
.globl vector254
vector254:
  pushl $0
c0102606:	6a 00                	push   $0x0
  pushl $254
c0102608:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c010260d:	e9 7a f5 ff ff       	jmp    c0101b8c <__alltraps>

c0102612 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102612:	6a 00                	push   $0x0
  pushl $255
c0102614:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c0102619:	e9 6e f5 ff ff       	jmp    c0101b8c <__alltraps>

c010261e <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010261e:	55                   	push   %ebp
c010261f:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102621:	8b 55 08             	mov    0x8(%ebp),%edx
c0102624:	a1 64 79 11 c0       	mov    0xc0117964,%eax
c0102629:	29 c2                	sub    %eax,%edx
c010262b:	89 d0                	mov    %edx,%eax
c010262d:	c1 f8 02             	sar    $0x2,%eax
c0102630:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0102636:	5d                   	pop    %ebp
c0102637:	c3                   	ret    

c0102638 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102638:	55                   	push   %ebp
c0102639:	89 e5                	mov    %esp,%ebp
c010263b:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010263e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102641:	89 04 24             	mov    %eax,(%esp)
c0102644:	e8 d5 ff ff ff       	call   c010261e <page2ppn>
c0102649:	c1 e0 0c             	shl    $0xc,%eax
}
c010264c:	c9                   	leave  
c010264d:	c3                   	ret    

c010264e <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c010264e:	55                   	push   %ebp
c010264f:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102651:	8b 45 08             	mov    0x8(%ebp),%eax
c0102654:	8b 00                	mov    (%eax),%eax
}
c0102656:	5d                   	pop    %ebp
c0102657:	c3                   	ret    

c0102658 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102658:	55                   	push   %ebp
c0102659:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010265b:	8b 45 08             	mov    0x8(%ebp),%eax
c010265e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102661:	89 10                	mov    %edx,(%eax)
}
c0102663:	5d                   	pop    %ebp
c0102664:	c3                   	ret    

c0102665 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0102665:	55                   	push   %ebp
c0102666:	89 e5                	mov    %esp,%ebp
c0102668:	83 ec 10             	sub    $0x10,%esp
c010266b:	c7 45 fc 50 79 11 c0 	movl   $0xc0117950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102672:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102675:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102678:	89 50 04             	mov    %edx,0x4(%eax)
c010267b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010267e:	8b 50 04             	mov    0x4(%eax),%edx
c0102681:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102684:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0102686:	c7 05 58 79 11 c0 00 	movl   $0x0,0xc0117958
c010268d:	00 00 00 
}
c0102690:	c9                   	leave  
c0102691:	c3                   	ret    

c0102692 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0102692:	55                   	push   %ebp
c0102693:	89 e5                	mov    %esp,%ebp
c0102695:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c0102698:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010269c:	75 24                	jne    c01026c2 <default_init_memmap+0x30>
c010269e:	c7 44 24 0c 70 62 10 	movl   $0xc0106270,0xc(%esp)
c01026a5:	c0 
c01026a6:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c01026ad:	c0 
c01026ae:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c01026b5:	00 
c01026b6:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01026bd:	e8 4a e5 ff ff       	call   c0100c0c <__panic>
    struct Page *p = base;
c01026c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01026c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01026c8:	eb 7d                	jmp    c0102747 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c01026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01026cd:	83 c0 04             	add    $0x4,%eax
c01026d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01026d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01026da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01026dd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01026e0:	0f a3 10             	bt     %edx,(%eax)
c01026e3:	19 c0                	sbb    %eax,%eax
c01026e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01026e8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01026ec:	0f 95 c0             	setne  %al
c01026ef:	0f b6 c0             	movzbl %al,%eax
c01026f2:	85 c0                	test   %eax,%eax
c01026f4:	75 24                	jne    c010271a <default_init_memmap+0x88>
c01026f6:	c7 44 24 0c a1 62 10 	movl   $0xc01062a1,0xc(%esp)
c01026fd:	c0 
c01026fe:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102705:	c0 
c0102706:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c010270d:	00 
c010270e:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102715:	e8 f2 e4 ff ff       	call   c0100c0c <__panic>
        p->flags = p->property = 0;
c010271a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010271d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0102724:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102727:	8b 50 08             	mov    0x8(%eax),%edx
c010272a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010272d:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c0102730:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102737:	00 
c0102738:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010273b:	89 04 24             	mov    %eax,(%esp)
c010273e:	e8 15 ff ff ff       	call   c0102658 <set_page_ref>

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102743:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102747:	8b 55 0c             	mov    0xc(%ebp),%edx
c010274a:	89 d0                	mov    %edx,%eax
c010274c:	c1 e0 02             	shl    $0x2,%eax
c010274f:	01 d0                	add    %edx,%eax
c0102751:	c1 e0 02             	shl    $0x2,%eax
c0102754:	89 c2                	mov    %eax,%edx
c0102756:	8b 45 08             	mov    0x8(%ebp),%eax
c0102759:	01 d0                	add    %edx,%eax
c010275b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010275e:	0f 85 66 ff ff ff    	jne    c01026ca <default_init_memmap+0x38>
        assert(PageReserved(p));
        p->flags = p->property = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102764:	8b 45 08             	mov    0x8(%ebp),%eax
c0102767:	8b 55 0c             	mov    0xc(%ebp),%edx
c010276a:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010276d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102770:	83 c0 04             	add    $0x4,%eax
c0102773:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c010277a:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010277d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102780:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102783:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0102786:	8b 15 58 79 11 c0    	mov    0xc0117958,%edx
c010278c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010278f:	01 d0                	add    %edx,%eax
c0102791:	a3 58 79 11 c0       	mov    %eax,0xc0117958
    list_add(&free_list, &(base->page_link));
c0102796:	8b 45 08             	mov    0x8(%ebp),%eax
c0102799:	83 c0 0c             	add    $0xc,%eax
c010279c:	c7 45 dc 50 79 11 c0 	movl   $0xc0117950,-0x24(%ebp)
c01027a3:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01027a6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01027a9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01027ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01027af:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01027b2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01027b5:	8b 40 04             	mov    0x4(%eax),%eax
c01027b8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01027bb:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01027be:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01027c1:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01027c4:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01027c7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01027ca:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01027cd:	89 10                	mov    %edx,(%eax)
c01027cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01027d2:	8b 10                	mov    (%eax),%edx
c01027d4:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01027d7:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01027da:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01027dd:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01027e0:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01027e3:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01027e6:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01027e9:	89 10                	mov    %edx,(%eax)
}
c01027eb:	c9                   	leave  
c01027ec:	c3                   	ret    

c01027ed <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01027ed:	55                   	push   %ebp
c01027ee:	89 e5                	mov    %esp,%ebp
c01027f0:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01027f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01027f7:	75 24                	jne    c010281d <default_alloc_pages+0x30>
c01027f9:	c7 44 24 0c 70 62 10 	movl   $0xc0106270,0xc(%esp)
c0102800:	c0 
c0102801:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102808:	c0 
c0102809:	c7 44 24 04 55 00 00 	movl   $0x55,0x4(%esp)
c0102810:	00 
c0102811:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102818:	e8 ef e3 ff ff       	call   c0100c0c <__panic>
    if (n > nr_free) {
c010281d:	a1 58 79 11 c0       	mov    0xc0117958,%eax
c0102822:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102825:	73 0a                	jae    c0102831 <default_alloc_pages+0x44>
        return NULL;
c0102827:	b8 00 00 00 00       	mov    $0x0,%eax
c010282c:	e9 2a 01 00 00       	jmp    c010295b <default_alloc_pages+0x16e>
    }
    struct Page *page = NULL;
c0102831:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102838:	c7 45 f0 50 79 11 c0 	movl   $0xc0117950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010283f:	eb 1c                	jmp    c010285d <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102841:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102844:	83 e8 0c             	sub    $0xc,%eax
c0102847:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c010284a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010284d:	8b 40 08             	mov    0x8(%eax),%eax
c0102850:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102853:	72 08                	jb     c010285d <default_alloc_pages+0x70>
            page = p;
c0102855:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102858:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c010285b:	eb 18                	jmp    c0102875 <default_alloc_pages+0x88>
c010285d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102860:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102863:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102866:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102869:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010286c:	81 7d f0 50 79 11 c0 	cmpl   $0xc0117950,-0x10(%ebp)
c0102873:	75 cc                	jne    c0102841 <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0102875:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102879:	0f 84 d9 00 00 00    	je     c0102958 <default_alloc_pages+0x16b>
        list_del(&(page->page_link));
c010287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102882:	83 c0 0c             	add    $0xc,%eax
c0102885:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102888:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010288b:	8b 40 04             	mov    0x4(%eax),%eax
c010288e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102891:	8b 12                	mov    (%edx),%edx
c0102893:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0102896:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102899:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010289c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010289f:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01028a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01028a5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01028a8:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c01028aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028ad:	8b 40 08             	mov    0x8(%eax),%eax
c01028b0:	3b 45 08             	cmp    0x8(%ebp),%eax
c01028b3:	76 7d                	jbe    c0102932 <default_alloc_pages+0x145>
            struct Page *p = page + n;
c01028b5:	8b 55 08             	mov    0x8(%ebp),%edx
c01028b8:	89 d0                	mov    %edx,%eax
c01028ba:	c1 e0 02             	shl    $0x2,%eax
c01028bd:	01 d0                	add    %edx,%eax
c01028bf:	c1 e0 02             	shl    $0x2,%eax
c01028c2:	89 c2                	mov    %eax,%edx
c01028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028c7:	01 d0                	add    %edx,%eax
c01028c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c01028cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028cf:	8b 40 08             	mov    0x8(%eax),%eax
c01028d2:	2b 45 08             	sub    0x8(%ebp),%eax
c01028d5:	89 c2                	mov    %eax,%edx
c01028d7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01028da:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
c01028dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01028e0:	83 c0 0c             	add    $0xc,%eax
c01028e3:	c7 45 d4 50 79 11 c0 	movl   $0xc0117950,-0x2c(%ebp)
c01028ea:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01028ed:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01028f0:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01028f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01028f6:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01028f9:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01028fc:	8b 40 04             	mov    0x4(%eax),%eax
c01028ff:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102902:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102905:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102908:	89 55 c0             	mov    %edx,-0x40(%ebp)
c010290b:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c010290e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102911:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102914:	89 10                	mov    %edx,(%eax)
c0102916:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102919:	8b 10                	mov    (%eax),%edx
c010291b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010291e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102921:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102924:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102927:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010292a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010292d:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102930:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
c0102932:	a1 58 79 11 c0       	mov    0xc0117958,%eax
c0102937:	2b 45 08             	sub    0x8(%ebp),%eax
c010293a:	a3 58 79 11 c0       	mov    %eax,0xc0117958
        ClearPageProperty(page);
c010293f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102942:	83 c0 04             	add    $0x4,%eax
c0102945:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c010294c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010294f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102952:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102955:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0102958:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010295b:	c9                   	leave  
c010295c:	c3                   	ret    

c010295d <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c010295d:	55                   	push   %ebp
c010295e:	89 e5                	mov    %esp,%ebp
c0102960:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0102966:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010296a:	75 24                	jne    c0102990 <default_free_pages+0x33>
c010296c:	c7 44 24 0c 70 62 10 	movl   $0xc0106270,0xc(%esp)
c0102973:	c0 
c0102974:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c010297b:	c0 
c010297c:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0102983:	00 
c0102984:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c010298b:	e8 7c e2 ff ff       	call   c0100c0c <__panic>
    struct Page *p = base;
c0102990:	8b 45 08             	mov    0x8(%ebp),%eax
c0102993:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102996:	e9 9d 00 00 00       	jmp    c0102a38 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c010299b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010299e:	83 c0 04             	add    $0x4,%eax
c01029a1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01029a8:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01029ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01029ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01029b1:	0f a3 10             	bt     %edx,(%eax)
c01029b4:	19 c0                	sbb    %eax,%eax
c01029b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c01029b9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01029bd:	0f 95 c0             	setne  %al
c01029c0:	0f b6 c0             	movzbl %al,%eax
c01029c3:	85 c0                	test   %eax,%eax
c01029c5:	75 2c                	jne    c01029f3 <default_free_pages+0x96>
c01029c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029ca:	83 c0 04             	add    $0x4,%eax
c01029cd:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01029d4:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01029d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01029da:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01029dd:	0f a3 10             	bt     %edx,(%eax)
c01029e0:	19 c0                	sbb    %eax,%eax
c01029e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c01029e5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01029e9:	0f 95 c0             	setne  %al
c01029ec:	0f b6 c0             	movzbl %al,%eax
c01029ef:	85 c0                	test   %eax,%eax
c01029f1:	74 24                	je     c0102a17 <default_free_pages+0xba>
c01029f3:	c7 44 24 0c b4 62 10 	movl   $0xc01062b4,0xc(%esp)
c01029fa:	c0 
c01029fb:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102a02:	c0 
c0102a03:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0102a0a:	00 
c0102a0b:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102a12:	e8 f5 e1 ff ff       	call   c0100c0c <__panic>
        p->flags = 0;
c0102a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102a21:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102a28:	00 
c0102a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a2c:	89 04 24             	mov    %eax,(%esp)
c0102a2f:	e8 24 fc ff ff       	call   c0102658 <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102a34:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102a38:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a3b:	89 d0                	mov    %edx,%eax
c0102a3d:	c1 e0 02             	shl    $0x2,%eax
c0102a40:	01 d0                	add    %edx,%eax
c0102a42:	c1 e0 02             	shl    $0x2,%eax
c0102a45:	89 c2                	mov    %eax,%edx
c0102a47:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a4a:	01 d0                	add    %edx,%eax
c0102a4c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102a4f:	0f 85 46 ff ff ff    	jne    c010299b <default_free_pages+0x3e>
        assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102a55:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a58:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a5b:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c0102a5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a61:	83 c0 04             	add    $0x4,%eax
c0102a64:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0102a6b:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102a6e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102a71:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a74:	0f ab 10             	bts    %edx,(%eax)
c0102a77:	c7 45 cc 50 79 11 c0 	movl   $0xc0117950,-0x34(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102a7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a81:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0102a84:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102a87:	e9 08 01 00 00       	jmp    c0102b94 <default_free_pages+0x237>
        p = le2page(le, page_link);
c0102a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a8f:	83 e8 0c             	sub    $0xc,%eax
c0102a92:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102a98:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102a9b:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102a9e:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0102aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c0102aa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aa7:	8b 50 08             	mov    0x8(%eax),%edx
c0102aaa:	89 d0                	mov    %edx,%eax
c0102aac:	c1 e0 02             	shl    $0x2,%eax
c0102aaf:	01 d0                	add    %edx,%eax
c0102ab1:	c1 e0 02             	shl    $0x2,%eax
c0102ab4:	89 c2                	mov    %eax,%edx
c0102ab6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ab9:	01 d0                	add    %edx,%eax
c0102abb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102abe:	75 5a                	jne    c0102b1a <default_free_pages+0x1bd>
            base->property += p->property;
c0102ac0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ac3:	8b 50 08             	mov    0x8(%eax),%edx
c0102ac6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ac9:	8b 40 08             	mov    0x8(%eax),%eax
c0102acc:	01 c2                	add    %eax,%edx
c0102ace:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ad1:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c0102ad4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ad7:	83 c0 04             	add    $0x4,%eax
c0102ada:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102ae1:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102ae4:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102ae7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102aea:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c0102aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102af0:	83 c0 0c             	add    $0xc,%eax
c0102af3:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102af6:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102af9:	8b 40 04             	mov    0x4(%eax),%eax
c0102afc:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102aff:	8b 12                	mov    (%edx),%edx
c0102b01:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102b04:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b07:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102b0a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102b0d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b10:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102b13:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102b16:	89 10                	mov    %edx,(%eax)
c0102b18:	eb 7a                	jmp    c0102b94 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c0102b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b1d:	8b 50 08             	mov    0x8(%eax),%edx
c0102b20:	89 d0                	mov    %edx,%eax
c0102b22:	c1 e0 02             	shl    $0x2,%eax
c0102b25:	01 d0                	add    %edx,%eax
c0102b27:	c1 e0 02             	shl    $0x2,%eax
c0102b2a:	89 c2                	mov    %eax,%edx
c0102b2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b2f:	01 d0                	add    %edx,%eax
c0102b31:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b34:	75 5e                	jne    c0102b94 <default_free_pages+0x237>
            p->property += base->property;
c0102b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b39:	8b 50 08             	mov    0x8(%eax),%edx
c0102b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b3f:	8b 40 08             	mov    0x8(%eax),%eax
c0102b42:	01 c2                	add    %eax,%edx
c0102b44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b47:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c0102b4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b4d:	83 c0 04             	add    $0x4,%eax
c0102b50:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0102b57:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0102b5a:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102b5d:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102b60:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0102b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b66:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0102b69:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b6c:	83 c0 0c             	add    $0xc,%eax
c0102b6f:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102b72:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102b75:	8b 40 04             	mov    0x4(%eax),%eax
c0102b78:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102b7b:	8b 12                	mov    (%edx),%edx
c0102b7d:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102b80:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b83:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102b86:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102b89:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b8c:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102b8f:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102b92:	89 10                	mov    %edx,(%eax)
        set_page_ref(p, 0);
    }
    base->property = n;
    SetPageProperty(base);
    list_entry_t *le = list_next(&free_list);
    while (le != &free_list) {
c0102b94:	81 7d f0 50 79 11 c0 	cmpl   $0xc0117950,-0x10(%ebp)
c0102b9b:	0f 85 eb fe ff ff    	jne    c0102a8c <default_free_pages+0x12f>
            ClearPageProperty(base);
            base = p;
            list_del(&(p->page_link));
        }
    }
    nr_free += n;
c0102ba1:	8b 15 58 79 11 c0    	mov    0xc0117958,%edx
c0102ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102baa:	01 d0                	add    %edx,%eax
c0102bac:	a3 58 79 11 c0       	mov    %eax,0xc0117958
    list_add(&free_list, &(base->page_link));
c0102bb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102bb4:	83 c0 0c             	add    $0xc,%eax
c0102bb7:	c7 45 9c 50 79 11 c0 	movl   $0xc0117950,-0x64(%ebp)
c0102bbe:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102bc1:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0102bc4:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0102bc7:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102bca:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102bcd:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102bd0:	8b 40 04             	mov    0x4(%eax),%eax
c0102bd3:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102bd6:	89 55 8c             	mov    %edx,-0x74(%ebp)
c0102bd9:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102bdc:	89 55 88             	mov    %edx,-0x78(%ebp)
c0102bdf:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102be2:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102be5:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102be8:	89 10                	mov    %edx,(%eax)
c0102bea:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0102bed:	8b 10                	mov    (%eax),%edx
c0102bef:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102bf2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102bf5:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102bf8:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102bfb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102bfe:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0102c01:	8b 55 88             	mov    -0x78(%ebp),%edx
c0102c04:	89 10                	mov    %edx,(%eax)
}
c0102c06:	c9                   	leave  
c0102c07:	c3                   	ret    

c0102c08 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102c08:	55                   	push   %ebp
c0102c09:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102c0b:	a1 58 79 11 c0       	mov    0xc0117958,%eax
}
c0102c10:	5d                   	pop    %ebp
c0102c11:	c3                   	ret    

c0102c12 <basic_check>:

static void
basic_check(void) {
c0102c12:	55                   	push   %ebp
c0102c13:	89 e5                	mov    %esp,%ebp
c0102c15:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102c18:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c22:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102c25:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c28:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102c2b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102c32:	e8 78 0e 00 00       	call   c0103aaf <alloc_pages>
c0102c37:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102c3a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102c3e:	75 24                	jne    c0102c64 <basic_check+0x52>
c0102c40:	c7 44 24 0c d9 62 10 	movl   $0xc01062d9,0xc(%esp)
c0102c47:	c0 
c0102c48:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102c4f:	c0 
c0102c50:	c7 44 24 04 97 00 00 	movl   $0x97,0x4(%esp)
c0102c57:	00 
c0102c58:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102c5f:	e8 a8 df ff ff       	call   c0100c0c <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102c64:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102c6b:	e8 3f 0e 00 00       	call   c0103aaf <alloc_pages>
c0102c70:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102c73:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102c77:	75 24                	jne    c0102c9d <basic_check+0x8b>
c0102c79:	c7 44 24 0c f5 62 10 	movl   $0xc01062f5,0xc(%esp)
c0102c80:	c0 
c0102c81:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102c88:	c0 
c0102c89:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0102c90:	00 
c0102c91:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102c98:	e8 6f df ff ff       	call   c0100c0c <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102c9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ca4:	e8 06 0e 00 00       	call   c0103aaf <alloc_pages>
c0102ca9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102cac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102cb0:	75 24                	jne    c0102cd6 <basic_check+0xc4>
c0102cb2:	c7 44 24 0c 11 63 10 	movl   $0xc0106311,0xc(%esp)
c0102cb9:	c0 
c0102cba:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102cc1:	c0 
c0102cc2:	c7 44 24 04 99 00 00 	movl   $0x99,0x4(%esp)
c0102cc9:	00 
c0102cca:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102cd1:	e8 36 df ff ff       	call   c0100c0c <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102cd6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102cd9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102cdc:	74 10                	je     c0102cee <basic_check+0xdc>
c0102cde:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ce1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ce4:	74 08                	je     c0102cee <basic_check+0xdc>
c0102ce6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ce9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102cec:	75 24                	jne    c0102d12 <basic_check+0x100>
c0102cee:	c7 44 24 0c 30 63 10 	movl   $0xc0106330,0xc(%esp)
c0102cf5:	c0 
c0102cf6:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102cfd:	c0 
c0102cfe:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
c0102d05:	00 
c0102d06:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102d0d:	e8 fa de ff ff       	call   c0100c0c <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102d12:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102d15:	89 04 24             	mov    %eax,(%esp)
c0102d18:	e8 31 f9 ff ff       	call   c010264e <page_ref>
c0102d1d:	85 c0                	test   %eax,%eax
c0102d1f:	75 1e                	jne    c0102d3f <basic_check+0x12d>
c0102d21:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d24:	89 04 24             	mov    %eax,(%esp)
c0102d27:	e8 22 f9 ff ff       	call   c010264e <page_ref>
c0102d2c:	85 c0                	test   %eax,%eax
c0102d2e:	75 0f                	jne    c0102d3f <basic_check+0x12d>
c0102d30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d33:	89 04 24             	mov    %eax,(%esp)
c0102d36:	e8 13 f9 ff ff       	call   c010264e <page_ref>
c0102d3b:	85 c0                	test   %eax,%eax
c0102d3d:	74 24                	je     c0102d63 <basic_check+0x151>
c0102d3f:	c7 44 24 0c 54 63 10 	movl   $0xc0106354,0xc(%esp)
c0102d46:	c0 
c0102d47:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102d4e:	c0 
c0102d4f:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0102d56:	00 
c0102d57:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102d5e:	e8 a9 de ff ff       	call   c0100c0c <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102d63:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102d66:	89 04 24             	mov    %eax,(%esp)
c0102d69:	e8 ca f8 ff ff       	call   c0102638 <page2pa>
c0102d6e:	8b 15 c0 78 11 c0    	mov    0xc01178c0,%edx
c0102d74:	c1 e2 0c             	shl    $0xc,%edx
c0102d77:	39 d0                	cmp    %edx,%eax
c0102d79:	72 24                	jb     c0102d9f <basic_check+0x18d>
c0102d7b:	c7 44 24 0c 90 63 10 	movl   $0xc0106390,0xc(%esp)
c0102d82:	c0 
c0102d83:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102d8a:	c0 
c0102d8b:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0102d92:	00 
c0102d93:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102d9a:	e8 6d de ff ff       	call   c0100c0c <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102da2:	89 04 24             	mov    %eax,(%esp)
c0102da5:	e8 8e f8 ff ff       	call   c0102638 <page2pa>
c0102daa:	8b 15 c0 78 11 c0    	mov    0xc01178c0,%edx
c0102db0:	c1 e2 0c             	shl    $0xc,%edx
c0102db3:	39 d0                	cmp    %edx,%eax
c0102db5:	72 24                	jb     c0102ddb <basic_check+0x1c9>
c0102db7:	c7 44 24 0c ad 63 10 	movl   $0xc01063ad,0xc(%esp)
c0102dbe:	c0 
c0102dbf:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102dc6:	c0 
c0102dc7:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0102dce:	00 
c0102dcf:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102dd6:	e8 31 de ff ff       	call   c0100c0c <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0102ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dde:	89 04 24             	mov    %eax,(%esp)
c0102de1:	e8 52 f8 ff ff       	call   c0102638 <page2pa>
c0102de6:	8b 15 c0 78 11 c0    	mov    0xc01178c0,%edx
c0102dec:	c1 e2 0c             	shl    $0xc,%edx
c0102def:	39 d0                	cmp    %edx,%eax
c0102df1:	72 24                	jb     c0102e17 <basic_check+0x205>
c0102df3:	c7 44 24 0c ca 63 10 	movl   $0xc01063ca,0xc(%esp)
c0102dfa:	c0 
c0102dfb:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102e02:	c0 
c0102e03:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0102e0a:	00 
c0102e0b:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102e12:	e8 f5 dd ff ff       	call   c0100c0c <__panic>

    list_entry_t free_list_store = free_list;
c0102e17:	a1 50 79 11 c0       	mov    0xc0117950,%eax
c0102e1c:	8b 15 54 79 11 c0    	mov    0xc0117954,%edx
c0102e22:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102e25:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102e28:	c7 45 e0 50 79 11 c0 	movl   $0xc0117950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102e2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102e32:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102e35:	89 50 04             	mov    %edx,0x4(%eax)
c0102e38:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102e3b:	8b 50 04             	mov    0x4(%eax),%edx
c0102e3e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102e41:	89 10                	mov    %edx,(%eax)
c0102e43:	c7 45 dc 50 79 11 c0 	movl   $0xc0117950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0102e4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102e4d:	8b 40 04             	mov    0x4(%eax),%eax
c0102e50:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102e53:	0f 94 c0             	sete   %al
c0102e56:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0102e59:	85 c0                	test   %eax,%eax
c0102e5b:	75 24                	jne    c0102e81 <basic_check+0x26f>
c0102e5d:	c7 44 24 0c e7 63 10 	movl   $0xc01063e7,0xc(%esp)
c0102e64:	c0 
c0102e65:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102e6c:	c0 
c0102e6d:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
c0102e74:	00 
c0102e75:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102e7c:	e8 8b dd ff ff       	call   c0100c0c <__panic>

    unsigned int nr_free_store = nr_free;
c0102e81:	a1 58 79 11 c0       	mov    0xc0117958,%eax
c0102e86:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0102e89:	c7 05 58 79 11 c0 00 	movl   $0x0,0xc0117958
c0102e90:	00 00 00 

    assert(alloc_page() == NULL);
c0102e93:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e9a:	e8 10 0c 00 00       	call   c0103aaf <alloc_pages>
c0102e9f:	85 c0                	test   %eax,%eax
c0102ea1:	74 24                	je     c0102ec7 <basic_check+0x2b5>
c0102ea3:	c7 44 24 0c fe 63 10 	movl   $0xc01063fe,0xc(%esp)
c0102eaa:	c0 
c0102eab:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102eb2:	c0 
c0102eb3:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c0102eba:	00 
c0102ebb:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102ec2:	e8 45 dd ff ff       	call   c0100c0c <__panic>

    free_page(p0);
c0102ec7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0102ece:	00 
c0102ecf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ed2:	89 04 24             	mov    %eax,(%esp)
c0102ed5:	e8 0d 0c 00 00       	call   c0103ae7 <free_pages>
    free_page(p1);
c0102eda:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0102ee1:	00 
c0102ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ee5:	89 04 24             	mov    %eax,(%esp)
c0102ee8:	e8 fa 0b 00 00       	call   c0103ae7 <free_pages>
    free_page(p2);
c0102eed:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0102ef4:	00 
c0102ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ef8:	89 04 24             	mov    %eax,(%esp)
c0102efb:	e8 e7 0b 00 00       	call   c0103ae7 <free_pages>
    assert(nr_free == 3);
c0102f00:	a1 58 79 11 c0       	mov    0xc0117958,%eax
c0102f05:	83 f8 03             	cmp    $0x3,%eax
c0102f08:	74 24                	je     c0102f2e <basic_check+0x31c>
c0102f0a:	c7 44 24 0c 13 64 10 	movl   $0xc0106413,0xc(%esp)
c0102f11:	c0 
c0102f12:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102f19:	c0 
c0102f1a:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0102f21:	00 
c0102f22:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102f29:	e8 de dc ff ff       	call   c0100c0c <__panic>

    assert((p0 = alloc_page()) != NULL);
c0102f2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f35:	e8 75 0b 00 00       	call   c0103aaf <alloc_pages>
c0102f3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102f3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102f41:	75 24                	jne    c0102f67 <basic_check+0x355>
c0102f43:	c7 44 24 0c d9 62 10 	movl   $0xc01062d9,0xc(%esp)
c0102f4a:	c0 
c0102f4b:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102f52:	c0 
c0102f53:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c0102f5a:	00 
c0102f5b:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102f62:	e8 a5 dc ff ff       	call   c0100c0c <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102f67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102f6e:	e8 3c 0b 00 00       	call   c0103aaf <alloc_pages>
c0102f73:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102f76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102f7a:	75 24                	jne    c0102fa0 <basic_check+0x38e>
c0102f7c:	c7 44 24 0c f5 62 10 	movl   $0xc01062f5,0xc(%esp)
c0102f83:	c0 
c0102f84:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102f8b:	c0 
c0102f8c:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0102f93:	00 
c0102f94:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102f9b:	e8 6c dc ff ff       	call   c0100c0c <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102fa0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102fa7:	e8 03 0b 00 00       	call   c0103aaf <alloc_pages>
c0102fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102faf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102fb3:	75 24                	jne    c0102fd9 <basic_check+0x3c7>
c0102fb5:	c7 44 24 0c 11 63 10 	movl   $0xc0106311,0xc(%esp)
c0102fbc:	c0 
c0102fbd:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102fc4:	c0 
c0102fc5:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0102fcc:	00 
c0102fcd:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0102fd4:	e8 33 dc ff ff       	call   c0100c0c <__panic>

    assert(alloc_page() == NULL);
c0102fd9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102fe0:	e8 ca 0a 00 00       	call   c0103aaf <alloc_pages>
c0102fe5:	85 c0                	test   %eax,%eax
c0102fe7:	74 24                	je     c010300d <basic_check+0x3fb>
c0102fe9:	c7 44 24 0c fe 63 10 	movl   $0xc01063fe,0xc(%esp)
c0102ff0:	c0 
c0102ff1:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0102ff8:	c0 
c0102ff9:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c0103000:	00 
c0103001:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0103008:	e8 ff db ff ff       	call   c0100c0c <__panic>

    free_page(p0);
c010300d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103014:	00 
c0103015:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103018:	89 04 24             	mov    %eax,(%esp)
c010301b:	e8 c7 0a 00 00       	call   c0103ae7 <free_pages>
c0103020:	c7 45 d8 50 79 11 c0 	movl   $0xc0117950,-0x28(%ebp)
c0103027:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010302a:	8b 40 04             	mov    0x4(%eax),%eax
c010302d:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103030:	0f 94 c0             	sete   %al
c0103033:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103036:	85 c0                	test   %eax,%eax
c0103038:	74 24                	je     c010305e <basic_check+0x44c>
c010303a:	c7 44 24 0c 20 64 10 	movl   $0xc0106420,0xc(%esp)
c0103041:	c0 
c0103042:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0103049:	c0 
c010304a:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0103051:	00 
c0103052:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0103059:	e8 ae db ff ff       	call   c0100c0c <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c010305e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103065:	e8 45 0a 00 00       	call   c0103aaf <alloc_pages>
c010306a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010306d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103070:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103073:	74 24                	je     c0103099 <basic_check+0x487>
c0103075:	c7 44 24 0c 38 64 10 	movl   $0xc0106438,0xc(%esp)
c010307c:	c0 
c010307d:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0103084:	c0 
c0103085:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c010308c:	00 
c010308d:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0103094:	e8 73 db ff ff       	call   c0100c0c <__panic>
    assert(alloc_page() == NULL);
c0103099:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030a0:	e8 0a 0a 00 00       	call   c0103aaf <alloc_pages>
c01030a5:	85 c0                	test   %eax,%eax
c01030a7:	74 24                	je     c01030cd <basic_check+0x4bb>
c01030a9:	c7 44 24 0c fe 63 10 	movl   $0xc01063fe,0xc(%esp)
c01030b0:	c0 
c01030b1:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c01030b8:	c0 
c01030b9:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c01030c0:	00 
c01030c1:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01030c8:	e8 3f db ff ff       	call   c0100c0c <__panic>

    assert(nr_free == 0);
c01030cd:	a1 58 79 11 c0       	mov    0xc0117958,%eax
c01030d2:	85 c0                	test   %eax,%eax
c01030d4:	74 24                	je     c01030fa <basic_check+0x4e8>
c01030d6:	c7 44 24 0c 51 64 10 	movl   $0xc0106451,0xc(%esp)
c01030dd:	c0 
c01030de:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c01030e5:	c0 
c01030e6:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c01030ed:	00 
c01030ee:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01030f5:	e8 12 db ff ff       	call   c0100c0c <__panic>
    free_list = free_list_store;
c01030fa:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01030fd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103100:	a3 50 79 11 c0       	mov    %eax,0xc0117950
c0103105:	89 15 54 79 11 c0    	mov    %edx,0xc0117954
    nr_free = nr_free_store;
c010310b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010310e:	a3 58 79 11 c0       	mov    %eax,0xc0117958

    free_page(p);
c0103113:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010311a:	00 
c010311b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010311e:	89 04 24             	mov    %eax,(%esp)
c0103121:	e8 c1 09 00 00       	call   c0103ae7 <free_pages>
    free_page(p1);
c0103126:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010312d:	00 
c010312e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103131:	89 04 24             	mov    %eax,(%esp)
c0103134:	e8 ae 09 00 00       	call   c0103ae7 <free_pages>
    free_page(p2);
c0103139:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103140:	00 
c0103141:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103144:	89 04 24             	mov    %eax,(%esp)
c0103147:	e8 9b 09 00 00       	call   c0103ae7 <free_pages>
}
c010314c:	c9                   	leave  
c010314d:	c3                   	ret    

c010314e <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c010314e:	55                   	push   %ebp
c010314f:	89 e5                	mov    %esp,%ebp
c0103151:	53                   	push   %ebx
c0103152:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103158:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010315f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103166:	c7 45 ec 50 79 11 c0 	movl   $0xc0117950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010316d:	eb 6b                	jmp    c01031da <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c010316f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103172:	83 e8 0c             	sub    $0xc,%eax
c0103175:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103178:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010317b:	83 c0 04             	add    $0x4,%eax
c010317e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103185:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103188:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010318b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010318e:	0f a3 10             	bt     %edx,(%eax)
c0103191:	19 c0                	sbb    %eax,%eax
c0103193:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103196:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010319a:	0f 95 c0             	setne  %al
c010319d:	0f b6 c0             	movzbl %al,%eax
c01031a0:	85 c0                	test   %eax,%eax
c01031a2:	75 24                	jne    c01031c8 <default_check+0x7a>
c01031a4:	c7 44 24 0c 5e 64 10 	movl   $0xc010645e,0xc(%esp)
c01031ab:	c0 
c01031ac:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c01031b3:	c0 
c01031b4:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c01031bb:	00 
c01031bc:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01031c3:	e8 44 da ff ff       	call   c0100c0c <__panic>
        count ++, total += p->property;
c01031c8:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01031cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01031cf:	8b 50 08             	mov    0x8(%eax),%edx
c01031d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031d5:	01 d0                	add    %edx,%eax
c01031d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01031da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031dd:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01031e0:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01031e3:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01031e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01031e9:	81 7d ec 50 79 11 c0 	cmpl   $0xc0117950,-0x14(%ebp)
c01031f0:	0f 85 79 ff ff ff    	jne    c010316f <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01031f6:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01031f9:	e8 1b 09 00 00       	call   c0103b19 <nr_free_pages>
c01031fe:	39 c3                	cmp    %eax,%ebx
c0103200:	74 24                	je     c0103226 <default_check+0xd8>
c0103202:	c7 44 24 0c 6e 64 10 	movl   $0xc010646e,0xc(%esp)
c0103209:	c0 
c010320a:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0103211:	c0 
c0103212:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0103219:	00 
c010321a:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0103221:	e8 e6 d9 ff ff       	call   c0100c0c <__panic>

    basic_check();
c0103226:	e8 e7 f9 ff ff       	call   c0102c12 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010322b:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103232:	e8 78 08 00 00       	call   c0103aaf <alloc_pages>
c0103237:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c010323a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010323e:	75 24                	jne    c0103264 <default_check+0x116>
c0103240:	c7 44 24 0c 87 64 10 	movl   $0xc0106487,0xc(%esp)
c0103247:	c0 
c0103248:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c010324f:	c0 
c0103250:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0103257:	00 
c0103258:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c010325f:	e8 a8 d9 ff ff       	call   c0100c0c <__panic>
    assert(!PageProperty(p0));
c0103264:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103267:	83 c0 04             	add    $0x4,%eax
c010326a:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103271:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103274:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103277:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010327a:	0f a3 10             	bt     %edx,(%eax)
c010327d:	19 c0                	sbb    %eax,%eax
c010327f:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103282:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103286:	0f 95 c0             	setne  %al
c0103289:	0f b6 c0             	movzbl %al,%eax
c010328c:	85 c0                	test   %eax,%eax
c010328e:	74 24                	je     c01032b4 <default_check+0x166>
c0103290:	c7 44 24 0c 92 64 10 	movl   $0xc0106492,0xc(%esp)
c0103297:	c0 
c0103298:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c010329f:	c0 
c01032a0:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c01032a7:	00 
c01032a8:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01032af:	e8 58 d9 ff ff       	call   c0100c0c <__panic>

    list_entry_t free_list_store = free_list;
c01032b4:	a1 50 79 11 c0       	mov    0xc0117950,%eax
c01032b9:	8b 15 54 79 11 c0    	mov    0xc0117954,%edx
c01032bf:	89 45 80             	mov    %eax,-0x80(%ebp)
c01032c2:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01032c5:	c7 45 b4 50 79 11 c0 	movl   $0xc0117950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01032cc:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01032cf:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01032d2:	89 50 04             	mov    %edx,0x4(%eax)
c01032d5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01032d8:	8b 50 04             	mov    0x4(%eax),%edx
c01032db:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01032de:	89 10                	mov    %edx,(%eax)
c01032e0:	c7 45 b0 50 79 11 c0 	movl   $0xc0117950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01032e7:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01032ea:	8b 40 04             	mov    0x4(%eax),%eax
c01032ed:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c01032f0:	0f 94 c0             	sete   %al
c01032f3:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01032f6:	85 c0                	test   %eax,%eax
c01032f8:	75 24                	jne    c010331e <default_check+0x1d0>
c01032fa:	c7 44 24 0c e7 63 10 	movl   $0xc01063e7,0xc(%esp)
c0103301:	c0 
c0103302:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0103309:	c0 
c010330a:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103311:	00 
c0103312:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0103319:	e8 ee d8 ff ff       	call   c0100c0c <__panic>
    assert(alloc_page() == NULL);
c010331e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103325:	e8 85 07 00 00       	call   c0103aaf <alloc_pages>
c010332a:	85 c0                	test   %eax,%eax
c010332c:	74 24                	je     c0103352 <default_check+0x204>
c010332e:	c7 44 24 0c fe 63 10 	movl   $0xc01063fe,0xc(%esp)
c0103335:	c0 
c0103336:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c010333d:	c0 
c010333e:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0103345:	00 
c0103346:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c010334d:	e8 ba d8 ff ff       	call   c0100c0c <__panic>

    unsigned int nr_free_store = nr_free;
c0103352:	a1 58 79 11 c0       	mov    0xc0117958,%eax
c0103357:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c010335a:	c7 05 58 79 11 c0 00 	movl   $0x0,0xc0117958
c0103361:	00 00 00 

    free_pages(p0 + 2, 3);
c0103364:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103367:	83 c0 28             	add    $0x28,%eax
c010336a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103371:	00 
c0103372:	89 04 24             	mov    %eax,(%esp)
c0103375:	e8 6d 07 00 00       	call   c0103ae7 <free_pages>
    assert(alloc_pages(4) == NULL);
c010337a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103381:	e8 29 07 00 00       	call   c0103aaf <alloc_pages>
c0103386:	85 c0                	test   %eax,%eax
c0103388:	74 24                	je     c01033ae <default_check+0x260>
c010338a:	c7 44 24 0c a4 64 10 	movl   $0xc01064a4,0xc(%esp)
c0103391:	c0 
c0103392:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0103399:	c0 
c010339a:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c01033a1:	00 
c01033a2:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01033a9:	e8 5e d8 ff ff       	call   c0100c0c <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01033ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033b1:	83 c0 28             	add    $0x28,%eax
c01033b4:	83 c0 04             	add    $0x4,%eax
c01033b7:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01033be:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01033c1:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01033c4:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01033c7:	0f a3 10             	bt     %edx,(%eax)
c01033ca:	19 c0                	sbb    %eax,%eax
c01033cc:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01033cf:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01033d3:	0f 95 c0             	setne  %al
c01033d6:	0f b6 c0             	movzbl %al,%eax
c01033d9:	85 c0                	test   %eax,%eax
c01033db:	74 0e                	je     c01033eb <default_check+0x29d>
c01033dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01033e0:	83 c0 28             	add    $0x28,%eax
c01033e3:	8b 40 08             	mov    0x8(%eax),%eax
c01033e6:	83 f8 03             	cmp    $0x3,%eax
c01033e9:	74 24                	je     c010340f <default_check+0x2c1>
c01033eb:	c7 44 24 0c bc 64 10 	movl   $0xc01064bc,0xc(%esp)
c01033f2:	c0 
c01033f3:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c01033fa:	c0 
c01033fb:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c0103402:	00 
c0103403:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c010340a:	e8 fd d7 ff ff       	call   c0100c0c <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010340f:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103416:	e8 94 06 00 00       	call   c0103aaf <alloc_pages>
c010341b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010341e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103422:	75 24                	jne    c0103448 <default_check+0x2fa>
c0103424:	c7 44 24 0c e8 64 10 	movl   $0xc01064e8,0xc(%esp)
c010342b:	c0 
c010342c:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0103433:	c0 
c0103434:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c010343b:	00 
c010343c:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0103443:	e8 c4 d7 ff ff       	call   c0100c0c <__panic>
    assert(alloc_page() == NULL);
c0103448:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010344f:	e8 5b 06 00 00       	call   c0103aaf <alloc_pages>
c0103454:	85 c0                	test   %eax,%eax
c0103456:	74 24                	je     c010347c <default_check+0x32e>
c0103458:	c7 44 24 0c fe 63 10 	movl   $0xc01063fe,0xc(%esp)
c010345f:	c0 
c0103460:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0103467:	c0 
c0103468:	c7 44 24 04 e5 00 00 	movl   $0xe5,0x4(%esp)
c010346f:	00 
c0103470:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0103477:	e8 90 d7 ff ff       	call   c0100c0c <__panic>
    assert(p0 + 2 == p1);
c010347c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010347f:	83 c0 28             	add    $0x28,%eax
c0103482:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103485:	74 24                	je     c01034ab <default_check+0x35d>
c0103487:	c7 44 24 0c 06 65 10 	movl   $0xc0106506,0xc(%esp)
c010348e:	c0 
c010348f:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0103496:	c0 
c0103497:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c010349e:	00 
c010349f:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01034a6:	e8 61 d7 ff ff       	call   c0100c0c <__panic>

    p2 = p0 + 1;
c01034ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034ae:	83 c0 14             	add    $0x14,%eax
c01034b1:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01034b4:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01034bb:	00 
c01034bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034bf:	89 04 24             	mov    %eax,(%esp)
c01034c2:	e8 20 06 00 00       	call   c0103ae7 <free_pages>
    free_pages(p1, 3);
c01034c7:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01034ce:	00 
c01034cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01034d2:	89 04 24             	mov    %eax,(%esp)
c01034d5:	e8 0d 06 00 00       	call   c0103ae7 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01034da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01034dd:	83 c0 04             	add    $0x4,%eax
c01034e0:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01034e7:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01034ea:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01034ed:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01034f0:	0f a3 10             	bt     %edx,(%eax)
c01034f3:	19 c0                	sbb    %eax,%eax
c01034f5:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01034f8:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01034fc:	0f 95 c0             	setne  %al
c01034ff:	0f b6 c0             	movzbl %al,%eax
c0103502:	85 c0                	test   %eax,%eax
c0103504:	74 0b                	je     c0103511 <default_check+0x3c3>
c0103506:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103509:	8b 40 08             	mov    0x8(%eax),%eax
c010350c:	83 f8 01             	cmp    $0x1,%eax
c010350f:	74 24                	je     c0103535 <default_check+0x3e7>
c0103511:	c7 44 24 0c 14 65 10 	movl   $0xc0106514,0xc(%esp)
c0103518:	c0 
c0103519:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0103520:	c0 
c0103521:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c0103528:	00 
c0103529:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0103530:	e8 d7 d6 ff ff       	call   c0100c0c <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103535:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103538:	83 c0 04             	add    $0x4,%eax
c010353b:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103542:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103545:	8b 45 90             	mov    -0x70(%ebp),%eax
c0103548:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010354b:	0f a3 10             	bt     %edx,(%eax)
c010354e:	19 c0                	sbb    %eax,%eax
c0103550:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103553:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c0103557:	0f 95 c0             	setne  %al
c010355a:	0f b6 c0             	movzbl %al,%eax
c010355d:	85 c0                	test   %eax,%eax
c010355f:	74 0b                	je     c010356c <default_check+0x41e>
c0103561:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103564:	8b 40 08             	mov    0x8(%eax),%eax
c0103567:	83 f8 03             	cmp    $0x3,%eax
c010356a:	74 24                	je     c0103590 <default_check+0x442>
c010356c:	c7 44 24 0c 3c 65 10 	movl   $0xc010653c,0xc(%esp)
c0103573:	c0 
c0103574:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c010357b:	c0 
c010357c:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0103583:	00 
c0103584:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c010358b:	e8 7c d6 ff ff       	call   c0100c0c <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0103590:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103597:	e8 13 05 00 00       	call   c0103aaf <alloc_pages>
c010359c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010359f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01035a2:	83 e8 14             	sub    $0x14,%eax
c01035a5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01035a8:	74 24                	je     c01035ce <default_check+0x480>
c01035aa:	c7 44 24 0c 62 65 10 	movl   $0xc0106562,0xc(%esp)
c01035b1:	c0 
c01035b2:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c01035b9:	c0 
c01035ba:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c01035c1:	00 
c01035c2:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01035c9:	e8 3e d6 ff ff       	call   c0100c0c <__panic>
    free_page(p0);
c01035ce:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01035d5:	00 
c01035d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035d9:	89 04 24             	mov    %eax,(%esp)
c01035dc:	e8 06 05 00 00       	call   c0103ae7 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01035e1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01035e8:	e8 c2 04 00 00       	call   c0103aaf <alloc_pages>
c01035ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01035f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01035f3:	83 c0 14             	add    $0x14,%eax
c01035f6:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01035f9:	74 24                	je     c010361f <default_check+0x4d1>
c01035fb:	c7 44 24 0c 80 65 10 	movl   $0xc0106580,0xc(%esp)
c0103602:	c0 
c0103603:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c010360a:	c0 
c010360b:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0103612:	00 
c0103613:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c010361a:	e8 ed d5 ff ff       	call   c0100c0c <__panic>

    free_pages(p0, 2);
c010361f:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103626:	00 
c0103627:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010362a:	89 04 24             	mov    %eax,(%esp)
c010362d:	e8 b5 04 00 00       	call   c0103ae7 <free_pages>
    free_page(p2);
c0103632:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103639:	00 
c010363a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010363d:	89 04 24             	mov    %eax,(%esp)
c0103640:	e8 a2 04 00 00       	call   c0103ae7 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103645:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010364c:	e8 5e 04 00 00       	call   c0103aaf <alloc_pages>
c0103651:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103654:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103658:	75 24                	jne    c010367e <default_check+0x530>
c010365a:	c7 44 24 0c a0 65 10 	movl   $0xc01065a0,0xc(%esp)
c0103661:	c0 
c0103662:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0103669:	c0 
c010366a:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0103671:	00 
c0103672:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0103679:	e8 8e d5 ff ff       	call   c0100c0c <__panic>
    assert(alloc_page() == NULL);
c010367e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103685:	e8 25 04 00 00       	call   c0103aaf <alloc_pages>
c010368a:	85 c0                	test   %eax,%eax
c010368c:	74 24                	je     c01036b2 <default_check+0x564>
c010368e:	c7 44 24 0c fe 63 10 	movl   $0xc01063fe,0xc(%esp)
c0103695:	c0 
c0103696:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c010369d:	c0 
c010369e:	c7 44 24 04 f6 00 00 	movl   $0xf6,0x4(%esp)
c01036a5:	00 
c01036a6:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01036ad:	e8 5a d5 ff ff       	call   c0100c0c <__panic>

    assert(nr_free == 0);
c01036b2:	a1 58 79 11 c0       	mov    0xc0117958,%eax
c01036b7:	85 c0                	test   %eax,%eax
c01036b9:	74 24                	je     c01036df <default_check+0x591>
c01036bb:	c7 44 24 0c 51 64 10 	movl   $0xc0106451,0xc(%esp)
c01036c2:	c0 
c01036c3:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c01036ca:	c0 
c01036cb:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01036d2:	00 
c01036d3:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c01036da:	e8 2d d5 ff ff       	call   c0100c0c <__panic>
    nr_free = nr_free_store;
c01036df:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01036e2:	a3 58 79 11 c0       	mov    %eax,0xc0117958

    free_list = free_list_store;
c01036e7:	8b 45 80             	mov    -0x80(%ebp),%eax
c01036ea:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01036ed:	a3 50 79 11 c0       	mov    %eax,0xc0117950
c01036f2:	89 15 54 79 11 c0    	mov    %edx,0xc0117954
    free_pages(p0, 5);
c01036f8:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c01036ff:	00 
c0103700:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103703:	89 04 24             	mov    %eax,(%esp)
c0103706:	e8 dc 03 00 00       	call   c0103ae7 <free_pages>

    le = &free_list;
c010370b:	c7 45 ec 50 79 11 c0 	movl   $0xc0117950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103712:	eb 1d                	jmp    c0103731 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103714:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103717:	83 e8 0c             	sub    $0xc,%eax
c010371a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c010371d:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103721:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103724:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103727:	8b 40 08             	mov    0x8(%eax),%eax
c010372a:	29 c2                	sub    %eax,%edx
c010372c:	89 d0                	mov    %edx,%eax
c010372e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103731:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103734:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103737:	8b 45 88             	mov    -0x78(%ebp),%eax
c010373a:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c010373d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103740:	81 7d ec 50 79 11 c0 	cmpl   $0xc0117950,-0x14(%ebp)
c0103747:	75 cb                	jne    c0103714 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103749:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010374d:	74 24                	je     c0103773 <default_check+0x625>
c010374f:	c7 44 24 0c be 65 10 	movl   $0xc01065be,0xc(%esp)
c0103756:	c0 
c0103757:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c010375e:	c0 
c010375f:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0103766:	00 
c0103767:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c010376e:	e8 99 d4 ff ff       	call   c0100c0c <__panic>
    assert(total == 0);
c0103773:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103777:	74 24                	je     c010379d <default_check+0x64f>
c0103779:	c7 44 24 0c c9 65 10 	movl   $0xc01065c9,0xc(%esp)
c0103780:	c0 
c0103781:	c7 44 24 08 76 62 10 	movl   $0xc0106276,0x8(%esp)
c0103788:	c0 
c0103789:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0103790:	00 
c0103791:	c7 04 24 8b 62 10 c0 	movl   $0xc010628b,(%esp)
c0103798:	e8 6f d4 ff ff       	call   c0100c0c <__panic>
}
c010379d:	81 c4 94 00 00 00    	add    $0x94,%esp
c01037a3:	5b                   	pop    %ebx
c01037a4:	5d                   	pop    %ebp
c01037a5:	c3                   	ret    

c01037a6 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01037a6:	55                   	push   %ebp
c01037a7:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01037a9:	8b 55 08             	mov    0x8(%ebp),%edx
c01037ac:	a1 64 79 11 c0       	mov    0xc0117964,%eax
c01037b1:	29 c2                	sub    %eax,%edx
c01037b3:	89 d0                	mov    %edx,%eax
c01037b5:	c1 f8 02             	sar    $0x2,%eax
c01037b8:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01037be:	5d                   	pop    %ebp
c01037bf:	c3                   	ret    

c01037c0 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01037c0:	55                   	push   %ebp
c01037c1:	89 e5                	mov    %esp,%ebp
c01037c3:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01037c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01037c9:	89 04 24             	mov    %eax,(%esp)
c01037cc:	e8 d5 ff ff ff       	call   c01037a6 <page2ppn>
c01037d1:	c1 e0 0c             	shl    $0xc,%eax
}
c01037d4:	c9                   	leave  
c01037d5:	c3                   	ret    

c01037d6 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01037d6:	55                   	push   %ebp
c01037d7:	89 e5                	mov    %esp,%ebp
c01037d9:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01037dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01037df:	c1 e8 0c             	shr    $0xc,%eax
c01037e2:	89 c2                	mov    %eax,%edx
c01037e4:	a1 c0 78 11 c0       	mov    0xc01178c0,%eax
c01037e9:	39 c2                	cmp    %eax,%edx
c01037eb:	72 1c                	jb     c0103809 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01037ed:	c7 44 24 08 04 66 10 	movl   $0xc0106604,0x8(%esp)
c01037f4:	c0 
c01037f5:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c01037fc:	00 
c01037fd:	c7 04 24 23 66 10 c0 	movl   $0xc0106623,(%esp)
c0103804:	e8 03 d4 ff ff       	call   c0100c0c <__panic>
    }
    return &pages[PPN(pa)];
c0103809:	8b 0d 64 79 11 c0    	mov    0xc0117964,%ecx
c010380f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103812:	c1 e8 0c             	shr    $0xc,%eax
c0103815:	89 c2                	mov    %eax,%edx
c0103817:	89 d0                	mov    %edx,%eax
c0103819:	c1 e0 02             	shl    $0x2,%eax
c010381c:	01 d0                	add    %edx,%eax
c010381e:	c1 e0 02             	shl    $0x2,%eax
c0103821:	01 c8                	add    %ecx,%eax
}
c0103823:	c9                   	leave  
c0103824:	c3                   	ret    

c0103825 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103825:	55                   	push   %ebp
c0103826:	89 e5                	mov    %esp,%ebp
c0103828:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010382b:	8b 45 08             	mov    0x8(%ebp),%eax
c010382e:	89 04 24             	mov    %eax,(%esp)
c0103831:	e8 8a ff ff ff       	call   c01037c0 <page2pa>
c0103836:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103839:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010383c:	c1 e8 0c             	shr    $0xc,%eax
c010383f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103842:	a1 c0 78 11 c0       	mov    0xc01178c0,%eax
c0103847:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010384a:	72 23                	jb     c010386f <page2kva+0x4a>
c010384c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010384f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103853:	c7 44 24 08 34 66 10 	movl   $0xc0106634,0x8(%esp)
c010385a:	c0 
c010385b:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103862:	00 
c0103863:	c7 04 24 23 66 10 c0 	movl   $0xc0106623,(%esp)
c010386a:	e8 9d d3 ff ff       	call   c0100c0c <__panic>
c010386f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103872:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103877:	c9                   	leave  
c0103878:	c3                   	ret    

c0103879 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103879:	55                   	push   %ebp
c010387a:	89 e5                	mov    %esp,%ebp
c010387c:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c010387f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103882:	83 e0 01             	and    $0x1,%eax
c0103885:	85 c0                	test   %eax,%eax
c0103887:	75 1c                	jne    c01038a5 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103889:	c7 44 24 08 58 66 10 	movl   $0xc0106658,0x8(%esp)
c0103890:	c0 
c0103891:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103898:	00 
c0103899:	c7 04 24 23 66 10 c0 	movl   $0xc0106623,(%esp)
c01038a0:	e8 67 d3 ff ff       	call   c0100c0c <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c01038a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01038a8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01038ad:	89 04 24             	mov    %eax,(%esp)
c01038b0:	e8 21 ff ff ff       	call   c01037d6 <pa2page>
}
c01038b5:	c9                   	leave  
c01038b6:	c3                   	ret    

c01038b7 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01038b7:	55                   	push   %ebp
c01038b8:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01038ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01038bd:	8b 00                	mov    (%eax),%eax
}
c01038bf:	5d                   	pop    %ebp
c01038c0:	c3                   	ret    

c01038c1 <page_ref_inc>:
set_page_ref(struct Page *page, int val) {
    page->ref = val;
}

static inline int
page_ref_inc(struct Page *page) {
c01038c1:	55                   	push   %ebp
c01038c2:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c01038c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01038c7:	8b 00                	mov    (%eax),%eax
c01038c9:	8d 50 01             	lea    0x1(%eax),%edx
c01038cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01038cf:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01038d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01038d4:	8b 00                	mov    (%eax),%eax
}
c01038d6:	5d                   	pop    %ebp
c01038d7:	c3                   	ret    

c01038d8 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c01038d8:	55                   	push   %ebp
c01038d9:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c01038db:	8b 45 08             	mov    0x8(%ebp),%eax
c01038de:	8b 00                	mov    (%eax),%eax
c01038e0:	8d 50 ff             	lea    -0x1(%eax),%edx
c01038e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01038e6:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01038e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01038eb:	8b 00                	mov    (%eax),%eax
}
c01038ed:	5d                   	pop    %ebp
c01038ee:	c3                   	ret    

c01038ef <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01038ef:	55                   	push   %ebp
c01038f0:	89 e5                	mov    %esp,%ebp
c01038f2:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01038f5:	9c                   	pushf  
c01038f6:	58                   	pop    %eax
c01038f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c01038fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01038fd:	25 00 02 00 00       	and    $0x200,%eax
c0103902:	85 c0                	test   %eax,%eax
c0103904:	74 0c                	je     c0103912 <__intr_save+0x23>
        intr_disable();
c0103906:	e8 e4 dc ff ff       	call   c01015ef <intr_disable>
        return 1;
c010390b:	b8 01 00 00 00       	mov    $0x1,%eax
c0103910:	eb 05                	jmp    c0103917 <__intr_save+0x28>
    }
    return 0;
c0103912:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103917:	c9                   	leave  
c0103918:	c3                   	ret    

c0103919 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103919:	55                   	push   %ebp
c010391a:	89 e5                	mov    %esp,%ebp
c010391c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010391f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103923:	74 05                	je     c010392a <__intr_restore+0x11>
        intr_enable();
c0103925:	e8 bf dc ff ff       	call   c01015e9 <intr_enable>
    }
}
c010392a:	c9                   	leave  
c010392b:	c3                   	ret    

c010392c <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c010392c:	55                   	push   %ebp
c010392d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c010392f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103932:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103935:	b8 23 00 00 00       	mov    $0x23,%eax
c010393a:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c010393c:	b8 23 00 00 00       	mov    $0x23,%eax
c0103941:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103943:	b8 10 00 00 00       	mov    $0x10,%eax
c0103948:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c010394a:	b8 10 00 00 00       	mov    $0x10,%eax
c010394f:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103951:	b8 10 00 00 00       	mov    $0x10,%eax
c0103956:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103958:	ea 5f 39 10 c0 08 00 	ljmp   $0x8,$0xc010395f
}
c010395f:	5d                   	pop    %ebp
c0103960:	c3                   	ret    

c0103961 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103961:	55                   	push   %ebp
c0103962:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103964:	8b 45 08             	mov    0x8(%ebp),%eax
c0103967:	a3 e4 78 11 c0       	mov    %eax,0xc01178e4
}
c010396c:	5d                   	pop    %ebp
c010396d:	c3                   	ret    

c010396e <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c010396e:	55                   	push   %ebp
c010396f:	89 e5                	mov    %esp,%ebp
c0103971:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103974:	b8 00 60 11 c0       	mov    $0xc0116000,%eax
c0103979:	89 04 24             	mov    %eax,(%esp)
c010397c:	e8 e0 ff ff ff       	call   c0103961 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103981:	66 c7 05 e8 78 11 c0 	movw   $0x10,0xc01178e8
c0103988:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c010398a:	66 c7 05 28 6a 11 c0 	movw   $0x68,0xc0116a28
c0103991:	68 00 
c0103993:	b8 e0 78 11 c0       	mov    $0xc01178e0,%eax
c0103998:	66 a3 2a 6a 11 c0    	mov    %ax,0xc0116a2a
c010399e:	b8 e0 78 11 c0       	mov    $0xc01178e0,%eax
c01039a3:	c1 e8 10             	shr    $0x10,%eax
c01039a6:	a2 2c 6a 11 c0       	mov    %al,0xc0116a2c
c01039ab:	0f b6 05 2d 6a 11 c0 	movzbl 0xc0116a2d,%eax
c01039b2:	83 e0 f0             	and    $0xfffffff0,%eax
c01039b5:	83 c8 09             	or     $0x9,%eax
c01039b8:	a2 2d 6a 11 c0       	mov    %al,0xc0116a2d
c01039bd:	0f b6 05 2d 6a 11 c0 	movzbl 0xc0116a2d,%eax
c01039c4:	83 e0 ef             	and    $0xffffffef,%eax
c01039c7:	a2 2d 6a 11 c0       	mov    %al,0xc0116a2d
c01039cc:	0f b6 05 2d 6a 11 c0 	movzbl 0xc0116a2d,%eax
c01039d3:	83 e0 9f             	and    $0xffffff9f,%eax
c01039d6:	a2 2d 6a 11 c0       	mov    %al,0xc0116a2d
c01039db:	0f b6 05 2d 6a 11 c0 	movzbl 0xc0116a2d,%eax
c01039e2:	83 c8 80             	or     $0xffffff80,%eax
c01039e5:	a2 2d 6a 11 c0       	mov    %al,0xc0116a2d
c01039ea:	0f b6 05 2e 6a 11 c0 	movzbl 0xc0116a2e,%eax
c01039f1:	83 e0 f0             	and    $0xfffffff0,%eax
c01039f4:	a2 2e 6a 11 c0       	mov    %al,0xc0116a2e
c01039f9:	0f b6 05 2e 6a 11 c0 	movzbl 0xc0116a2e,%eax
c0103a00:	83 e0 ef             	and    $0xffffffef,%eax
c0103a03:	a2 2e 6a 11 c0       	mov    %al,0xc0116a2e
c0103a08:	0f b6 05 2e 6a 11 c0 	movzbl 0xc0116a2e,%eax
c0103a0f:	83 e0 df             	and    $0xffffffdf,%eax
c0103a12:	a2 2e 6a 11 c0       	mov    %al,0xc0116a2e
c0103a17:	0f b6 05 2e 6a 11 c0 	movzbl 0xc0116a2e,%eax
c0103a1e:	83 c8 40             	or     $0x40,%eax
c0103a21:	a2 2e 6a 11 c0       	mov    %al,0xc0116a2e
c0103a26:	0f b6 05 2e 6a 11 c0 	movzbl 0xc0116a2e,%eax
c0103a2d:	83 e0 7f             	and    $0x7f,%eax
c0103a30:	a2 2e 6a 11 c0       	mov    %al,0xc0116a2e
c0103a35:	b8 e0 78 11 c0       	mov    $0xc01178e0,%eax
c0103a3a:	c1 e8 18             	shr    $0x18,%eax
c0103a3d:	a2 2f 6a 11 c0       	mov    %al,0xc0116a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103a42:	c7 04 24 30 6a 11 c0 	movl   $0xc0116a30,(%esp)
c0103a49:	e8 de fe ff ff       	call   c010392c <lgdt>
c0103a4e:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103a54:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103a58:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103a5b:	c9                   	leave  
c0103a5c:	c3                   	ret    

c0103a5d <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103a5d:	55                   	push   %ebp
c0103a5e:	89 e5                	mov    %esp,%ebp
c0103a60:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103a63:	c7 05 5c 79 11 c0 e8 	movl   $0xc01065e8,0xc011795c
c0103a6a:	65 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103a6d:	a1 5c 79 11 c0       	mov    0xc011795c,%eax
c0103a72:	8b 00                	mov    (%eax),%eax
c0103a74:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103a78:	c7 04 24 84 66 10 c0 	movl   $0xc0106684,(%esp)
c0103a7f:	e8 b8 c8 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103a84:	a1 5c 79 11 c0       	mov    0xc011795c,%eax
c0103a89:	8b 40 04             	mov    0x4(%eax),%eax
c0103a8c:	ff d0                	call   *%eax
}
c0103a8e:	c9                   	leave  
c0103a8f:	c3                   	ret    

c0103a90 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103a90:	55                   	push   %ebp
c0103a91:	89 e5                	mov    %esp,%ebp
c0103a93:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103a96:	a1 5c 79 11 c0       	mov    0xc011795c,%eax
c0103a9b:	8b 40 08             	mov    0x8(%eax),%eax
c0103a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103aa1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103aa5:	8b 55 08             	mov    0x8(%ebp),%edx
c0103aa8:	89 14 24             	mov    %edx,(%esp)
c0103aab:	ff d0                	call   *%eax
}
c0103aad:	c9                   	leave  
c0103aae:	c3                   	ret    

c0103aaf <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103aaf:	55                   	push   %ebp
c0103ab0:	89 e5                	mov    %esp,%ebp
c0103ab2:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103ab5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103abc:	e8 2e fe ff ff       	call   c01038ef <__intr_save>
c0103ac1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103ac4:	a1 5c 79 11 c0       	mov    0xc011795c,%eax
c0103ac9:	8b 40 0c             	mov    0xc(%eax),%eax
c0103acc:	8b 55 08             	mov    0x8(%ebp),%edx
c0103acf:	89 14 24             	mov    %edx,(%esp)
c0103ad2:	ff d0                	call   *%eax
c0103ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ada:	89 04 24             	mov    %eax,(%esp)
c0103add:	e8 37 fe ff ff       	call   c0103919 <__intr_restore>
    return page;
c0103ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103ae5:	c9                   	leave  
c0103ae6:	c3                   	ret    

c0103ae7 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103ae7:	55                   	push   %ebp
c0103ae8:	89 e5                	mov    %esp,%ebp
c0103aea:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103aed:	e8 fd fd ff ff       	call   c01038ef <__intr_save>
c0103af2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103af5:	a1 5c 79 11 c0       	mov    0xc011795c,%eax
c0103afa:	8b 40 10             	mov    0x10(%eax),%eax
c0103afd:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103b00:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103b04:	8b 55 08             	mov    0x8(%ebp),%edx
c0103b07:	89 14 24             	mov    %edx,(%esp)
c0103b0a:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103b0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b0f:	89 04 24             	mov    %eax,(%esp)
c0103b12:	e8 02 fe ff ff       	call   c0103919 <__intr_restore>
}
c0103b17:	c9                   	leave  
c0103b18:	c3                   	ret    

c0103b19 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103b19:	55                   	push   %ebp
c0103b1a:	89 e5                	mov    %esp,%ebp
c0103b1c:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103b1f:	e8 cb fd ff ff       	call   c01038ef <__intr_save>
c0103b24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103b27:	a1 5c 79 11 c0       	mov    0xc011795c,%eax
c0103b2c:	8b 40 14             	mov    0x14(%eax),%eax
c0103b2f:	ff d0                	call   *%eax
c0103b31:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b37:	89 04 24             	mov    %eax,(%esp)
c0103b3a:	e8 da fd ff ff       	call   c0103919 <__intr_restore>
    return ret;
c0103b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103b42:	c9                   	leave  
c0103b43:	c3                   	ret    

c0103b44 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103b44:	55                   	push   %ebp
c0103b45:	89 e5                	mov    %esp,%ebp
c0103b47:	57                   	push   %edi
c0103b48:	56                   	push   %esi
c0103b49:	53                   	push   %ebx
c0103b4a:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103b50:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103b57:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103b5e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103b65:	c7 04 24 9b 66 10 c0 	movl   $0xc010669b,(%esp)
c0103b6c:	e8 cb c7 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103b71:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103b78:	e9 15 01 00 00       	jmp    c0103c92 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103b7d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103b80:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103b83:	89 d0                	mov    %edx,%eax
c0103b85:	c1 e0 02             	shl    $0x2,%eax
c0103b88:	01 d0                	add    %edx,%eax
c0103b8a:	c1 e0 02             	shl    $0x2,%eax
c0103b8d:	01 c8                	add    %ecx,%eax
c0103b8f:	8b 50 08             	mov    0x8(%eax),%edx
c0103b92:	8b 40 04             	mov    0x4(%eax),%eax
c0103b95:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103b98:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103b9b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103b9e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103ba1:	89 d0                	mov    %edx,%eax
c0103ba3:	c1 e0 02             	shl    $0x2,%eax
c0103ba6:	01 d0                	add    %edx,%eax
c0103ba8:	c1 e0 02             	shl    $0x2,%eax
c0103bab:	01 c8                	add    %ecx,%eax
c0103bad:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103bb0:	8b 58 10             	mov    0x10(%eax),%ebx
c0103bb3:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103bb6:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103bb9:	01 c8                	add    %ecx,%eax
c0103bbb:	11 da                	adc    %ebx,%edx
c0103bbd:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103bc0:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103bc3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103bc6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103bc9:	89 d0                	mov    %edx,%eax
c0103bcb:	c1 e0 02             	shl    $0x2,%eax
c0103bce:	01 d0                	add    %edx,%eax
c0103bd0:	c1 e0 02             	shl    $0x2,%eax
c0103bd3:	01 c8                	add    %ecx,%eax
c0103bd5:	83 c0 14             	add    $0x14,%eax
c0103bd8:	8b 00                	mov    (%eax),%eax
c0103bda:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103be0:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103be3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103be6:	83 c0 ff             	add    $0xffffffff,%eax
c0103be9:	83 d2 ff             	adc    $0xffffffff,%edx
c0103bec:	89 c6                	mov    %eax,%esi
c0103bee:	89 d7                	mov    %edx,%edi
c0103bf0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103bf3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103bf6:	89 d0                	mov    %edx,%eax
c0103bf8:	c1 e0 02             	shl    $0x2,%eax
c0103bfb:	01 d0                	add    %edx,%eax
c0103bfd:	c1 e0 02             	shl    $0x2,%eax
c0103c00:	01 c8                	add    %ecx,%eax
c0103c02:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103c05:	8b 58 10             	mov    0x10(%eax),%ebx
c0103c08:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103c0e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103c12:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103c16:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103c1a:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103c1d:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103c20:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103c24:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103c28:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103c2c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103c30:	c7 04 24 a8 66 10 c0 	movl   $0xc01066a8,(%esp)
c0103c37:	e8 00 c7 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103c3c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103c3f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103c42:	89 d0                	mov    %edx,%eax
c0103c44:	c1 e0 02             	shl    $0x2,%eax
c0103c47:	01 d0                	add    %edx,%eax
c0103c49:	c1 e0 02             	shl    $0x2,%eax
c0103c4c:	01 c8                	add    %ecx,%eax
c0103c4e:	83 c0 14             	add    $0x14,%eax
c0103c51:	8b 00                	mov    (%eax),%eax
c0103c53:	83 f8 01             	cmp    $0x1,%eax
c0103c56:	75 36                	jne    c0103c8e <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103c58:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103c5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103c5e:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103c61:	77 2b                	ja     c0103c8e <page_init+0x14a>
c0103c63:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103c66:	72 05                	jb     c0103c6d <page_init+0x129>
c0103c68:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103c6b:	73 21                	jae    c0103c8e <page_init+0x14a>
c0103c6d:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103c71:	77 1b                	ja     c0103c8e <page_init+0x14a>
c0103c73:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103c77:	72 09                	jb     c0103c82 <page_init+0x13e>
c0103c79:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103c80:	77 0c                	ja     c0103c8e <page_init+0x14a>
                maxpa = end;
c0103c82:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103c85:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103c88:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103c8b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103c8e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103c92:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103c95:	8b 00                	mov    (%eax),%eax
c0103c97:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103c9a:	0f 8f dd fe ff ff    	jg     c0103b7d <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103ca0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103ca4:	72 1d                	jb     c0103cc3 <page_init+0x17f>
c0103ca6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103caa:	77 09                	ja     c0103cb5 <page_init+0x171>
c0103cac:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103cb3:	76 0e                	jbe    c0103cc3 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103cb5:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103cbc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103cc3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103cc6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103cc9:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103ccd:	c1 ea 0c             	shr    $0xc,%edx
c0103cd0:	a3 c0 78 11 c0       	mov    %eax,0xc01178c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103cd5:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103cdc:	b8 68 79 11 c0       	mov    $0xc0117968,%eax
c0103ce1:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103ce4:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103ce7:	01 d0                	add    %edx,%eax
c0103ce9:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103cec:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103cef:	ba 00 00 00 00       	mov    $0x0,%edx
c0103cf4:	f7 75 ac             	divl   -0x54(%ebp)
c0103cf7:	89 d0                	mov    %edx,%eax
c0103cf9:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103cfc:	29 c2                	sub    %eax,%edx
c0103cfe:	89 d0                	mov    %edx,%eax
c0103d00:	a3 64 79 11 c0       	mov    %eax,0xc0117964

    for (i = 0; i < npage; i ++) {
c0103d05:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103d0c:	eb 2f                	jmp    c0103d3d <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103d0e:	8b 0d 64 79 11 c0    	mov    0xc0117964,%ecx
c0103d14:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d17:	89 d0                	mov    %edx,%eax
c0103d19:	c1 e0 02             	shl    $0x2,%eax
c0103d1c:	01 d0                	add    %edx,%eax
c0103d1e:	c1 e0 02             	shl    $0x2,%eax
c0103d21:	01 c8                	add    %ecx,%eax
c0103d23:	83 c0 04             	add    $0x4,%eax
c0103d26:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103d2d:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103d30:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103d33:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103d36:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103d39:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103d3d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d40:	a1 c0 78 11 c0       	mov    0xc01178c0,%eax
c0103d45:	39 c2                	cmp    %eax,%edx
c0103d47:	72 c5                	jb     c0103d0e <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103d49:	8b 15 c0 78 11 c0    	mov    0xc01178c0,%edx
c0103d4f:	89 d0                	mov    %edx,%eax
c0103d51:	c1 e0 02             	shl    $0x2,%eax
c0103d54:	01 d0                	add    %edx,%eax
c0103d56:	c1 e0 02             	shl    $0x2,%eax
c0103d59:	89 c2                	mov    %eax,%edx
c0103d5b:	a1 64 79 11 c0       	mov    0xc0117964,%eax
c0103d60:	01 d0                	add    %edx,%eax
c0103d62:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103d65:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103d6c:	77 23                	ja     c0103d91 <page_init+0x24d>
c0103d6e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103d71:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103d75:	c7 44 24 08 d8 66 10 	movl   $0xc01066d8,0x8(%esp)
c0103d7c:	c0 
c0103d7d:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103d84:	00 
c0103d85:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0103d8c:	e8 7b ce ff ff       	call   c0100c0c <__panic>
c0103d91:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103d94:	05 00 00 00 40       	add    $0x40000000,%eax
c0103d99:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103d9c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103da3:	e9 74 01 00 00       	jmp    c0103f1c <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103da8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dab:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dae:	89 d0                	mov    %edx,%eax
c0103db0:	c1 e0 02             	shl    $0x2,%eax
c0103db3:	01 d0                	add    %edx,%eax
c0103db5:	c1 e0 02             	shl    $0x2,%eax
c0103db8:	01 c8                	add    %ecx,%eax
c0103dba:	8b 50 08             	mov    0x8(%eax),%edx
c0103dbd:	8b 40 04             	mov    0x4(%eax),%eax
c0103dc0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103dc3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103dc6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dc9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dcc:	89 d0                	mov    %edx,%eax
c0103dce:	c1 e0 02             	shl    $0x2,%eax
c0103dd1:	01 d0                	add    %edx,%eax
c0103dd3:	c1 e0 02             	shl    $0x2,%eax
c0103dd6:	01 c8                	add    %ecx,%eax
c0103dd8:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103ddb:	8b 58 10             	mov    0x10(%eax),%ebx
c0103dde:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103de1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103de4:	01 c8                	add    %ecx,%eax
c0103de6:	11 da                	adc    %ebx,%edx
c0103de8:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103deb:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103dee:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103df1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103df4:	89 d0                	mov    %edx,%eax
c0103df6:	c1 e0 02             	shl    $0x2,%eax
c0103df9:	01 d0                	add    %edx,%eax
c0103dfb:	c1 e0 02             	shl    $0x2,%eax
c0103dfe:	01 c8                	add    %ecx,%eax
c0103e00:	83 c0 14             	add    $0x14,%eax
c0103e03:	8b 00                	mov    (%eax),%eax
c0103e05:	83 f8 01             	cmp    $0x1,%eax
c0103e08:	0f 85 0a 01 00 00    	jne    c0103f18 <page_init+0x3d4>
            if (begin < freemem) {
c0103e0e:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103e11:	ba 00 00 00 00       	mov    $0x0,%edx
c0103e16:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103e19:	72 17                	jb     c0103e32 <page_init+0x2ee>
c0103e1b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0103e1e:	77 05                	ja     c0103e25 <page_init+0x2e1>
c0103e20:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0103e23:	76 0d                	jbe    c0103e32 <page_init+0x2ee>
                begin = freemem;
c0103e25:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0103e28:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103e2b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0103e32:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103e36:	72 1d                	jb     c0103e55 <page_init+0x311>
c0103e38:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0103e3c:	77 09                	ja     c0103e47 <page_init+0x303>
c0103e3e:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0103e45:	76 0e                	jbe    c0103e55 <page_init+0x311>
                end = KMEMSIZE;
c0103e47:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0103e4e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0103e55:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103e58:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103e5b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103e5e:	0f 87 b4 00 00 00    	ja     c0103f18 <page_init+0x3d4>
c0103e64:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103e67:	72 09                	jb     c0103e72 <page_init+0x32e>
c0103e69:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103e6c:	0f 83 a6 00 00 00    	jae    c0103f18 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0103e72:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0103e79:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103e7c:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103e7f:	01 d0                	add    %edx,%eax
c0103e81:	83 e8 01             	sub    $0x1,%eax
c0103e84:	89 45 98             	mov    %eax,-0x68(%ebp)
c0103e87:	8b 45 98             	mov    -0x68(%ebp),%eax
c0103e8a:	ba 00 00 00 00       	mov    $0x0,%edx
c0103e8f:	f7 75 9c             	divl   -0x64(%ebp)
c0103e92:	89 d0                	mov    %edx,%eax
c0103e94:	8b 55 98             	mov    -0x68(%ebp),%edx
c0103e97:	29 c2                	sub    %eax,%edx
c0103e99:	89 d0                	mov    %edx,%eax
c0103e9b:	ba 00 00 00 00       	mov    $0x0,%edx
c0103ea0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103ea3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0103ea6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103ea9:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0103eac:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0103eaf:	ba 00 00 00 00       	mov    $0x0,%edx
c0103eb4:	89 c7                	mov    %eax,%edi
c0103eb6:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c0103ebc:	89 7d 80             	mov    %edi,-0x80(%ebp)
c0103ebf:	89 d0                	mov    %edx,%eax
c0103ec1:	83 e0 00             	and    $0x0,%eax
c0103ec4:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0103ec7:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103eca:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103ecd:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103ed0:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0103ed3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103ed6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103ed9:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103edc:	77 3a                	ja     c0103f18 <page_init+0x3d4>
c0103ede:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0103ee1:	72 05                	jb     c0103ee8 <page_init+0x3a4>
c0103ee3:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0103ee6:	73 30                	jae    c0103f18 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0103ee8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0103eeb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0103eee:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103ef1:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103ef4:	29 c8                	sub    %ecx,%eax
c0103ef6:	19 da                	sbb    %ebx,%edx
c0103ef8:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103efc:	c1 ea 0c             	shr    $0xc,%edx
c0103eff:	89 c3                	mov    %eax,%ebx
c0103f01:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103f04:	89 04 24             	mov    %eax,(%esp)
c0103f07:	e8 ca f8 ff ff       	call   c01037d6 <pa2page>
c0103f0c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0103f10:	89 04 24             	mov    %eax,(%esp)
c0103f13:	e8 78 fb ff ff       	call   c0103a90 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0103f18:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f1c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103f1f:	8b 00                	mov    (%eax),%eax
c0103f21:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103f24:	0f 8f 7e fe ff ff    	jg     c0103da8 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0103f2a:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0103f30:	5b                   	pop    %ebx
c0103f31:	5e                   	pop    %esi
c0103f32:	5f                   	pop    %edi
c0103f33:	5d                   	pop    %ebp
c0103f34:	c3                   	ret    

c0103f35 <enable_paging>:

static void
enable_paging(void) {
c0103f35:	55                   	push   %ebp
c0103f36:	89 e5                	mov    %esp,%ebp
c0103f38:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0103f3b:	a1 60 79 11 c0       	mov    0xc0117960,%eax
c0103f40:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0103f43:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0103f46:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0103f49:	0f 20 c0             	mov    %cr0,%eax
c0103f4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c0103f4f:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0103f52:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0103f55:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0103f5c:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0103f60:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103f63:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0103f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f69:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0103f6c:	c9                   	leave  
c0103f6d:	c3                   	ret    

c0103f6e <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0103f6e:	55                   	push   %ebp
c0103f6f:	89 e5                	mov    %esp,%ebp
c0103f71:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0103f74:	8b 45 14             	mov    0x14(%ebp),%eax
c0103f77:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103f7a:	31 d0                	xor    %edx,%eax
c0103f7c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103f81:	85 c0                	test   %eax,%eax
c0103f83:	74 24                	je     c0103fa9 <boot_map_segment+0x3b>
c0103f85:	c7 44 24 0c 0a 67 10 	movl   $0xc010670a,0xc(%esp)
c0103f8c:	c0 
c0103f8d:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0103f94:	c0 
c0103f95:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0103f9c:	00 
c0103f9d:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0103fa4:	e8 63 cc ff ff       	call   c0100c0c <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0103fa9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0103fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103fb3:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103fb8:	89 c2                	mov    %eax,%edx
c0103fba:	8b 45 10             	mov    0x10(%ebp),%eax
c0103fbd:	01 c2                	add    %eax,%edx
c0103fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103fc2:	01 d0                	add    %edx,%eax
c0103fc4:	83 e8 01             	sub    $0x1,%eax
c0103fc7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103fca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103fcd:	ba 00 00 00 00       	mov    $0x0,%edx
c0103fd2:	f7 75 f0             	divl   -0x10(%ebp)
c0103fd5:	89 d0                	mov    %edx,%eax
c0103fd7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103fda:	29 c2                	sub    %eax,%edx
c0103fdc:	89 d0                	mov    %edx,%eax
c0103fde:	c1 e8 0c             	shr    $0xc,%eax
c0103fe1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0103fe4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103fe7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103fea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103fed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103ff2:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0103ff5:	8b 45 14             	mov    0x14(%ebp),%eax
c0103ff8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103ffb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ffe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104003:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104006:	eb 6b                	jmp    c0104073 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104008:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010400f:	00 
c0104010:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104013:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104017:	8b 45 08             	mov    0x8(%ebp),%eax
c010401a:	89 04 24             	mov    %eax,(%esp)
c010401d:	e8 cc 01 00 00       	call   c01041ee <get_pte>
c0104022:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104025:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104029:	75 24                	jne    c010404f <boot_map_segment+0xe1>
c010402b:	c7 44 24 0c 36 67 10 	movl   $0xc0106736,0xc(%esp)
c0104032:	c0 
c0104033:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c010403a:	c0 
c010403b:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0104042:	00 
c0104043:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c010404a:	e8 bd cb ff ff       	call   c0100c0c <__panic>
        *ptep = pa | PTE_P | perm;
c010404f:	8b 45 18             	mov    0x18(%ebp),%eax
c0104052:	8b 55 14             	mov    0x14(%ebp),%edx
c0104055:	09 d0                	or     %edx,%eax
c0104057:	83 c8 01             	or     $0x1,%eax
c010405a:	89 c2                	mov    %eax,%edx
c010405c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010405f:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104061:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104065:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010406c:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104073:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104077:	75 8f                	jne    c0104008 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104079:	c9                   	leave  
c010407a:	c3                   	ret    

c010407b <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010407b:	55                   	push   %ebp
c010407c:	89 e5                	mov    %esp,%ebp
c010407e:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104081:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104088:	e8 22 fa ff ff       	call   c0103aaf <alloc_pages>
c010408d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104090:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104094:	75 1c                	jne    c01040b2 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104096:	c7 44 24 08 43 67 10 	movl   $0xc0106743,0x8(%esp)
c010409d:	c0 
c010409e:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01040a5:	00 
c01040a6:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c01040ad:	e8 5a cb ff ff       	call   c0100c0c <__panic>
    }
    return page2kva(p);
c01040b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01040b5:	89 04 24             	mov    %eax,(%esp)
c01040b8:	e8 68 f7 ff ff       	call   c0103825 <page2kva>
}
c01040bd:	c9                   	leave  
c01040be:	c3                   	ret    

c01040bf <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01040bf:	55                   	push   %ebp
c01040c0:	89 e5                	mov    %esp,%ebp
c01040c2:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01040c5:	e8 93 f9 ff ff       	call   c0103a5d <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01040ca:	e8 75 fa ff ff       	call   c0103b44 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01040cf:	e8 d7 02 00 00       	call   c01043ab <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01040d4:	e8 a2 ff ff ff       	call   c010407b <boot_alloc_page>
c01040d9:	a3 c4 78 11 c0       	mov    %eax,0xc01178c4
    memset(boot_pgdir, 0, PGSIZE);
c01040de:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c01040e3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01040ea:	00 
c01040eb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01040f2:	00 
c01040f3:	89 04 24             	mov    %eax,(%esp)
c01040f6:	e8 19 19 00 00       	call   c0105a14 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c01040fb:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104100:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104103:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010410a:	77 23                	ja     c010412f <pmm_init+0x70>
c010410c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010410f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104113:	c7 44 24 08 d8 66 10 	movl   $0xc01066d8,0x8(%esp)
c010411a:	c0 
c010411b:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0104122:	00 
c0104123:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c010412a:	e8 dd ca ff ff       	call   c0100c0c <__panic>
c010412f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104132:	05 00 00 00 40       	add    $0x40000000,%eax
c0104137:	a3 60 79 11 c0       	mov    %eax,0xc0117960

    check_pgdir();
c010413c:	e8 88 02 00 00       	call   c01043c9 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104141:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104146:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c010414c:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104151:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104154:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010415b:	77 23                	ja     c0104180 <pmm_init+0xc1>
c010415d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104160:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104164:	c7 44 24 08 d8 66 10 	movl   $0xc01066d8,0x8(%esp)
c010416b:	c0 
c010416c:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0104173:	00 
c0104174:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c010417b:	e8 8c ca ff ff       	call   c0100c0c <__panic>
c0104180:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104183:	05 00 00 00 40       	add    $0x40000000,%eax
c0104188:	83 c8 03             	or     $0x3,%eax
c010418b:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010418d:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104192:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104199:	00 
c010419a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01041a1:	00 
c01041a2:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01041a9:	38 
c01041aa:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01041b1:	c0 
c01041b2:	89 04 24             	mov    %eax,(%esp)
c01041b5:	e8 b4 fd ff ff       	call   c0103f6e <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01041ba:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c01041bf:	8b 15 c4 78 11 c0    	mov    0xc01178c4,%edx
c01041c5:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c01041cb:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01041cd:	e8 63 fd ff ff       	call   c0103f35 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01041d2:	e8 97 f7 ff ff       	call   c010396e <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01041d7:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c01041dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01041e2:	e8 7d 08 00 00       	call   c0104a64 <check_boot_pgdir>

    print_pgdir();
c01041e7:	e8 0a 0d 00 00       	call   c0104ef6 <print_pgdir>

}
c01041ec:	c9                   	leave  
c01041ed:	c3                   	ret    

c01041ee <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01041ee:	55                   	push   %ebp
c01041ef:	89 e5                	mov    %esp,%ebp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
}
c01041f1:	5d                   	pop    %ebp
c01041f2:	c3                   	ret    

c01041f3 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01041f3:	55                   	push   %ebp
c01041f4:	89 e5                	mov    %esp,%ebp
c01041f6:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01041f9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104200:	00 
c0104201:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104204:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104208:	8b 45 08             	mov    0x8(%ebp),%eax
c010420b:	89 04 24             	mov    %eax,(%esp)
c010420e:	e8 db ff ff ff       	call   c01041ee <get_pte>
c0104213:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104216:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010421a:	74 08                	je     c0104224 <get_page+0x31>
        *ptep_store = ptep;
c010421c:	8b 45 10             	mov    0x10(%ebp),%eax
c010421f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104222:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104224:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104228:	74 1b                	je     c0104245 <get_page+0x52>
c010422a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010422d:	8b 00                	mov    (%eax),%eax
c010422f:	83 e0 01             	and    $0x1,%eax
c0104232:	85 c0                	test   %eax,%eax
c0104234:	74 0f                	je     c0104245 <get_page+0x52>
        return pa2page(*ptep);
c0104236:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104239:	8b 00                	mov    (%eax),%eax
c010423b:	89 04 24             	mov    %eax,(%esp)
c010423e:	e8 93 f5 ff ff       	call   c01037d6 <pa2page>
c0104243:	eb 05                	jmp    c010424a <get_page+0x57>
    }
    return NULL;
c0104245:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010424a:	c9                   	leave  
c010424b:	c3                   	ret    

c010424c <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010424c:	55                   	push   %ebp
c010424d:	89 e5                	mov    %esp,%ebp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
}
c010424f:	5d                   	pop    %ebp
c0104250:	c3                   	ret    

c0104251 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104251:	55                   	push   %ebp
c0104252:	89 e5                	mov    %esp,%ebp
c0104254:	83 ec 1c             	sub    $0x1c,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104257:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010425e:	00 
c010425f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104262:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104266:	8b 45 08             	mov    0x8(%ebp),%eax
c0104269:	89 04 24             	mov    %eax,(%esp)
c010426c:	e8 7d ff ff ff       	call   c01041ee <get_pte>
c0104271:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (ptep != NULL) {
c0104274:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0104278:	74 19                	je     c0104293 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010427a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010427d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104281:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104284:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104288:	8b 45 08             	mov    0x8(%ebp),%eax
c010428b:	89 04 24             	mov    %eax,(%esp)
c010428e:	e8 b9 ff ff ff       	call   c010424c <page_remove_pte>
    }
}
c0104293:	c9                   	leave  
c0104294:	c3                   	ret    

c0104295 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0104295:	55                   	push   %ebp
c0104296:	89 e5                	mov    %esp,%ebp
c0104298:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c010429b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01042a2:	00 
c01042a3:	8b 45 10             	mov    0x10(%ebp),%eax
c01042a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01042aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01042ad:	89 04 24             	mov    %eax,(%esp)
c01042b0:	e8 39 ff ff ff       	call   c01041ee <get_pte>
c01042b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01042b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042bc:	75 0a                	jne    c01042c8 <page_insert+0x33>
        return -E_NO_MEM;
c01042be:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01042c3:	e9 84 00 00 00       	jmp    c010434c <page_insert+0xb7>
    }
    page_ref_inc(page);
c01042c8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042cb:	89 04 24             	mov    %eax,(%esp)
c01042ce:	e8 ee f5 ff ff       	call   c01038c1 <page_ref_inc>
    if (*ptep & PTE_P) {
c01042d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042d6:	8b 00                	mov    (%eax),%eax
c01042d8:	83 e0 01             	and    $0x1,%eax
c01042db:	85 c0                	test   %eax,%eax
c01042dd:	74 3e                	je     c010431d <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01042df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042e2:	8b 00                	mov    (%eax),%eax
c01042e4:	89 04 24             	mov    %eax,(%esp)
c01042e7:	e8 8d f5 ff ff       	call   c0103879 <pte2page>
c01042ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01042ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01042f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01042f5:	75 0d                	jne    c0104304 <page_insert+0x6f>
            page_ref_dec(page);
c01042f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01042fa:	89 04 24             	mov    %eax,(%esp)
c01042fd:	e8 d6 f5 ff ff       	call   c01038d8 <page_ref_dec>
c0104302:	eb 19                	jmp    c010431d <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104304:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104307:	89 44 24 08          	mov    %eax,0x8(%esp)
c010430b:	8b 45 10             	mov    0x10(%ebp),%eax
c010430e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104312:	8b 45 08             	mov    0x8(%ebp),%eax
c0104315:	89 04 24             	mov    %eax,(%esp)
c0104318:	e8 2f ff ff ff       	call   c010424c <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010431d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104320:	89 04 24             	mov    %eax,(%esp)
c0104323:	e8 98 f4 ff ff       	call   c01037c0 <page2pa>
c0104328:	0b 45 14             	or     0x14(%ebp),%eax
c010432b:	83 c8 01             	or     $0x1,%eax
c010432e:	89 c2                	mov    %eax,%edx
c0104330:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104333:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104335:	8b 45 10             	mov    0x10(%ebp),%eax
c0104338:	89 44 24 04          	mov    %eax,0x4(%esp)
c010433c:	8b 45 08             	mov    0x8(%ebp),%eax
c010433f:	89 04 24             	mov    %eax,(%esp)
c0104342:	e8 07 00 00 00       	call   c010434e <tlb_invalidate>
    return 0;
c0104347:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010434c:	c9                   	leave  
c010434d:	c3                   	ret    

c010434e <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010434e:	55                   	push   %ebp
c010434f:	89 e5                	mov    %esp,%ebp
c0104351:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0104354:	0f 20 d8             	mov    %cr3,%eax
c0104357:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c010435a:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c010435d:	89 c2                	mov    %eax,%edx
c010435f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104362:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104365:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010436c:	77 23                	ja     c0104391 <tlb_invalidate+0x43>
c010436e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104371:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104375:	c7 44 24 08 d8 66 10 	movl   $0xc01066d8,0x8(%esp)
c010437c:	c0 
c010437d:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
c0104384:	00 
c0104385:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c010438c:	e8 7b c8 ff ff       	call   c0100c0c <__panic>
c0104391:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104394:	05 00 00 00 40       	add    $0x40000000,%eax
c0104399:	39 c2                	cmp    %eax,%edx
c010439b:	75 0c                	jne    c01043a9 <tlb_invalidate+0x5b>
        invlpg((void *)la);
c010439d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01043a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c01043a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043a6:	0f 01 38             	invlpg (%eax)
    }
}
c01043a9:	c9                   	leave  
c01043aa:	c3                   	ret    

c01043ab <check_alloc_page>:

static void
check_alloc_page(void) {
c01043ab:	55                   	push   %ebp
c01043ac:	89 e5                	mov    %esp,%ebp
c01043ae:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01043b1:	a1 5c 79 11 c0       	mov    0xc011795c,%eax
c01043b6:	8b 40 18             	mov    0x18(%eax),%eax
c01043b9:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01043bb:	c7 04 24 5c 67 10 c0 	movl   $0xc010675c,(%esp)
c01043c2:	e8 75 bf ff ff       	call   c010033c <cprintf>
}
c01043c7:	c9                   	leave  
c01043c8:	c3                   	ret    

c01043c9 <check_pgdir>:

static void
check_pgdir(void) {
c01043c9:	55                   	push   %ebp
c01043ca:	89 e5                	mov    %esp,%ebp
c01043cc:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01043cf:	a1 c0 78 11 c0       	mov    0xc01178c0,%eax
c01043d4:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01043d9:	76 24                	jbe    c01043ff <check_pgdir+0x36>
c01043db:	c7 44 24 0c 7b 67 10 	movl   $0xc010677b,0xc(%esp)
c01043e2:	c0 
c01043e3:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c01043ea:	c0 
c01043eb:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c01043f2:	00 
c01043f3:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c01043fa:	e8 0d c8 ff ff       	call   c0100c0c <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01043ff:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104404:	85 c0                	test   %eax,%eax
c0104406:	74 0e                	je     c0104416 <check_pgdir+0x4d>
c0104408:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c010440d:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104412:	85 c0                	test   %eax,%eax
c0104414:	74 24                	je     c010443a <check_pgdir+0x71>
c0104416:	c7 44 24 0c 98 67 10 	movl   $0xc0106798,0xc(%esp)
c010441d:	c0 
c010441e:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0104425:	c0 
c0104426:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c010442d:	00 
c010442e:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104435:	e8 d2 c7 ff ff       	call   c0100c0c <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010443a:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c010443f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104446:	00 
c0104447:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010444e:	00 
c010444f:	89 04 24             	mov    %eax,(%esp)
c0104452:	e8 9c fd ff ff       	call   c01041f3 <get_page>
c0104457:	85 c0                	test   %eax,%eax
c0104459:	74 24                	je     c010447f <check_pgdir+0xb6>
c010445b:	c7 44 24 0c d0 67 10 	movl   $0xc01067d0,0xc(%esp)
c0104462:	c0 
c0104463:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c010446a:	c0 
c010446b:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
c0104472:	00 
c0104473:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c010447a:	e8 8d c7 ff ff       	call   c0100c0c <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010447f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104486:	e8 24 f6 ff ff       	call   c0103aaf <alloc_pages>
c010448b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010448e:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104493:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010449a:	00 
c010449b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01044a2:	00 
c01044a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01044a6:	89 54 24 04          	mov    %edx,0x4(%esp)
c01044aa:	89 04 24             	mov    %eax,(%esp)
c01044ad:	e8 e3 fd ff ff       	call   c0104295 <page_insert>
c01044b2:	85 c0                	test   %eax,%eax
c01044b4:	74 24                	je     c01044da <check_pgdir+0x111>
c01044b6:	c7 44 24 0c f8 67 10 	movl   $0xc01067f8,0xc(%esp)
c01044bd:	c0 
c01044be:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c01044c5:	c0 
c01044c6:	c7 44 24 04 eb 01 00 	movl   $0x1eb,0x4(%esp)
c01044cd:	00 
c01044ce:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c01044d5:	e8 32 c7 ff ff       	call   c0100c0c <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01044da:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c01044df:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01044e6:	00 
c01044e7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01044ee:	00 
c01044ef:	89 04 24             	mov    %eax,(%esp)
c01044f2:	e8 f7 fc ff ff       	call   c01041ee <get_pte>
c01044f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01044fa:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01044fe:	75 24                	jne    c0104524 <check_pgdir+0x15b>
c0104500:	c7 44 24 0c 24 68 10 	movl   $0xc0106824,0xc(%esp)
c0104507:	c0 
c0104508:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c010450f:	c0 
c0104510:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c0104517:	00 
c0104518:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c010451f:	e8 e8 c6 ff ff       	call   c0100c0c <__panic>
    assert(pa2page(*ptep) == p1);
c0104524:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104527:	8b 00                	mov    (%eax),%eax
c0104529:	89 04 24             	mov    %eax,(%esp)
c010452c:	e8 a5 f2 ff ff       	call   c01037d6 <pa2page>
c0104531:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104534:	74 24                	je     c010455a <check_pgdir+0x191>
c0104536:	c7 44 24 0c 51 68 10 	movl   $0xc0106851,0xc(%esp)
c010453d:	c0 
c010453e:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0104545:	c0 
c0104546:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c010454d:	00 
c010454e:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104555:	e8 b2 c6 ff ff       	call   c0100c0c <__panic>
    assert(page_ref(p1) == 1);
c010455a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010455d:	89 04 24             	mov    %eax,(%esp)
c0104560:	e8 52 f3 ff ff       	call   c01038b7 <page_ref>
c0104565:	83 f8 01             	cmp    $0x1,%eax
c0104568:	74 24                	je     c010458e <check_pgdir+0x1c5>
c010456a:	c7 44 24 0c 66 68 10 	movl   $0xc0106866,0xc(%esp)
c0104571:	c0 
c0104572:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0104579:	c0 
c010457a:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c0104581:	00 
c0104582:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104589:	e8 7e c6 ff ff       	call   c0100c0c <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010458e:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104593:	8b 00                	mov    (%eax),%eax
c0104595:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010459a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010459d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045a0:	c1 e8 0c             	shr    $0xc,%eax
c01045a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01045a6:	a1 c0 78 11 c0       	mov    0xc01178c0,%eax
c01045ab:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01045ae:	72 23                	jb     c01045d3 <check_pgdir+0x20a>
c01045b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01045b7:	c7 44 24 08 34 66 10 	movl   $0xc0106634,0x8(%esp)
c01045be:	c0 
c01045bf:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
c01045c6:	00 
c01045c7:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c01045ce:	e8 39 c6 ff ff       	call   c0100c0c <__panic>
c01045d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01045d6:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01045db:	83 c0 04             	add    $0x4,%eax
c01045de:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01045e1:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c01045e6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01045ed:	00 
c01045ee:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01045f5:	00 
c01045f6:	89 04 24             	mov    %eax,(%esp)
c01045f9:	e8 f0 fb ff ff       	call   c01041ee <get_pte>
c01045fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104601:	74 24                	je     c0104627 <check_pgdir+0x25e>
c0104603:	c7 44 24 0c 78 68 10 	movl   $0xc0106878,0xc(%esp)
c010460a:	c0 
c010460b:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0104612:	c0 
c0104613:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c010461a:	00 
c010461b:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104622:	e8 e5 c5 ff ff       	call   c0100c0c <__panic>

    p2 = alloc_page();
c0104627:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010462e:	e8 7c f4 ff ff       	call   c0103aaf <alloc_pages>
c0104633:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104636:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c010463b:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104642:	00 
c0104643:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010464a:	00 
c010464b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010464e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104652:	89 04 24             	mov    %eax,(%esp)
c0104655:	e8 3b fc ff ff       	call   c0104295 <page_insert>
c010465a:	85 c0                	test   %eax,%eax
c010465c:	74 24                	je     c0104682 <check_pgdir+0x2b9>
c010465e:	c7 44 24 0c a0 68 10 	movl   $0xc01068a0,0xc(%esp)
c0104665:	c0 
c0104666:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c010466d:	c0 
c010466e:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0104675:	00 
c0104676:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c010467d:	e8 8a c5 ff ff       	call   c0100c0c <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104682:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104687:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010468e:	00 
c010468f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104696:	00 
c0104697:	89 04 24             	mov    %eax,(%esp)
c010469a:	e8 4f fb ff ff       	call   c01041ee <get_pte>
c010469f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01046a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01046a6:	75 24                	jne    c01046cc <check_pgdir+0x303>
c01046a8:	c7 44 24 0c d8 68 10 	movl   $0xc01068d8,0xc(%esp)
c01046af:	c0 
c01046b0:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c01046b7:	c0 
c01046b8:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c01046bf:	00 
c01046c0:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c01046c7:	e8 40 c5 ff ff       	call   c0100c0c <__panic>
    assert(*ptep & PTE_U);
c01046cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046cf:	8b 00                	mov    (%eax),%eax
c01046d1:	83 e0 04             	and    $0x4,%eax
c01046d4:	85 c0                	test   %eax,%eax
c01046d6:	75 24                	jne    c01046fc <check_pgdir+0x333>
c01046d8:	c7 44 24 0c 08 69 10 	movl   $0xc0106908,0xc(%esp)
c01046df:	c0 
c01046e0:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c01046e7:	c0 
c01046e8:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c01046ef:	00 
c01046f0:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c01046f7:	e8 10 c5 ff ff       	call   c0100c0c <__panic>
    assert(*ptep & PTE_W);
c01046fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046ff:	8b 00                	mov    (%eax),%eax
c0104701:	83 e0 02             	and    $0x2,%eax
c0104704:	85 c0                	test   %eax,%eax
c0104706:	75 24                	jne    c010472c <check_pgdir+0x363>
c0104708:	c7 44 24 0c 16 69 10 	movl   $0xc0106916,0xc(%esp)
c010470f:	c0 
c0104710:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0104717:	c0 
c0104718:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c010471f:	00 
c0104720:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104727:	e8 e0 c4 ff ff       	call   c0100c0c <__panic>
    assert(boot_pgdir[0] & PTE_U);
c010472c:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104731:	8b 00                	mov    (%eax),%eax
c0104733:	83 e0 04             	and    $0x4,%eax
c0104736:	85 c0                	test   %eax,%eax
c0104738:	75 24                	jne    c010475e <check_pgdir+0x395>
c010473a:	c7 44 24 0c 24 69 10 	movl   $0xc0106924,0xc(%esp)
c0104741:	c0 
c0104742:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0104749:	c0 
c010474a:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0104751:	00 
c0104752:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104759:	e8 ae c4 ff ff       	call   c0100c0c <__panic>
    assert(page_ref(p2) == 1);
c010475e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104761:	89 04 24             	mov    %eax,(%esp)
c0104764:	e8 4e f1 ff ff       	call   c01038b7 <page_ref>
c0104769:	83 f8 01             	cmp    $0x1,%eax
c010476c:	74 24                	je     c0104792 <check_pgdir+0x3c9>
c010476e:	c7 44 24 0c 3a 69 10 	movl   $0xc010693a,0xc(%esp)
c0104775:	c0 
c0104776:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c010477d:	c0 
c010477e:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0104785:	00 
c0104786:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c010478d:	e8 7a c4 ff ff       	call   c0100c0c <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104792:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104797:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010479e:	00 
c010479f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01047a6:	00 
c01047a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01047aa:	89 54 24 04          	mov    %edx,0x4(%esp)
c01047ae:	89 04 24             	mov    %eax,(%esp)
c01047b1:	e8 df fa ff ff       	call   c0104295 <page_insert>
c01047b6:	85 c0                	test   %eax,%eax
c01047b8:	74 24                	je     c01047de <check_pgdir+0x415>
c01047ba:	c7 44 24 0c 4c 69 10 	movl   $0xc010694c,0xc(%esp)
c01047c1:	c0 
c01047c2:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c01047c9:	c0 
c01047ca:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c01047d1:	00 
c01047d2:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c01047d9:	e8 2e c4 ff ff       	call   c0100c0c <__panic>
    assert(page_ref(p1) == 2);
c01047de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047e1:	89 04 24             	mov    %eax,(%esp)
c01047e4:	e8 ce f0 ff ff       	call   c01038b7 <page_ref>
c01047e9:	83 f8 02             	cmp    $0x2,%eax
c01047ec:	74 24                	je     c0104812 <check_pgdir+0x449>
c01047ee:	c7 44 24 0c 78 69 10 	movl   $0xc0106978,0xc(%esp)
c01047f5:	c0 
c01047f6:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c01047fd:	c0 
c01047fe:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
c0104805:	00 
c0104806:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c010480d:	e8 fa c3 ff ff       	call   c0100c0c <__panic>
    assert(page_ref(p2) == 0);
c0104812:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104815:	89 04 24             	mov    %eax,(%esp)
c0104818:	e8 9a f0 ff ff       	call   c01038b7 <page_ref>
c010481d:	85 c0                	test   %eax,%eax
c010481f:	74 24                	je     c0104845 <check_pgdir+0x47c>
c0104821:	c7 44 24 0c 8a 69 10 	movl   $0xc010698a,0xc(%esp)
c0104828:	c0 
c0104829:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0104830:	c0 
c0104831:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0104838:	00 
c0104839:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104840:	e8 c7 c3 ff ff       	call   c0100c0c <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104845:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c010484a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104851:	00 
c0104852:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104859:	00 
c010485a:	89 04 24             	mov    %eax,(%esp)
c010485d:	e8 8c f9 ff ff       	call   c01041ee <get_pte>
c0104862:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104865:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104869:	75 24                	jne    c010488f <check_pgdir+0x4c6>
c010486b:	c7 44 24 0c d8 68 10 	movl   $0xc01068d8,0xc(%esp)
c0104872:	c0 
c0104873:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c010487a:	c0 
c010487b:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0104882:	00 
c0104883:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c010488a:	e8 7d c3 ff ff       	call   c0100c0c <__panic>
    assert(pa2page(*ptep) == p1);
c010488f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104892:	8b 00                	mov    (%eax),%eax
c0104894:	89 04 24             	mov    %eax,(%esp)
c0104897:	e8 3a ef ff ff       	call   c01037d6 <pa2page>
c010489c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010489f:	74 24                	je     c01048c5 <check_pgdir+0x4fc>
c01048a1:	c7 44 24 0c 51 68 10 	movl   $0xc0106851,0xc(%esp)
c01048a8:	c0 
c01048a9:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c01048b0:	c0 
c01048b1:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
c01048b8:	00 
c01048b9:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c01048c0:	e8 47 c3 ff ff       	call   c0100c0c <__panic>
    assert((*ptep & PTE_U) == 0);
c01048c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048c8:	8b 00                	mov    (%eax),%eax
c01048ca:	83 e0 04             	and    $0x4,%eax
c01048cd:	85 c0                	test   %eax,%eax
c01048cf:	74 24                	je     c01048f5 <check_pgdir+0x52c>
c01048d1:	c7 44 24 0c 9c 69 10 	movl   $0xc010699c,0xc(%esp)
c01048d8:	c0 
c01048d9:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c01048e0:	c0 
c01048e1:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c01048e8:	00 
c01048e9:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c01048f0:	e8 17 c3 ff ff       	call   c0100c0c <__panic>

    page_remove(boot_pgdir, 0x0);
c01048f5:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c01048fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104901:	00 
c0104902:	89 04 24             	mov    %eax,(%esp)
c0104905:	e8 47 f9 ff ff       	call   c0104251 <page_remove>
    assert(page_ref(p1) == 1);
c010490a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010490d:	89 04 24             	mov    %eax,(%esp)
c0104910:	e8 a2 ef ff ff       	call   c01038b7 <page_ref>
c0104915:	83 f8 01             	cmp    $0x1,%eax
c0104918:	74 24                	je     c010493e <check_pgdir+0x575>
c010491a:	c7 44 24 0c 66 68 10 	movl   $0xc0106866,0xc(%esp)
c0104921:	c0 
c0104922:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0104929:	c0 
c010492a:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
c0104931:	00 
c0104932:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104939:	e8 ce c2 ff ff       	call   c0100c0c <__panic>
    assert(page_ref(p2) == 0);
c010493e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104941:	89 04 24             	mov    %eax,(%esp)
c0104944:	e8 6e ef ff ff       	call   c01038b7 <page_ref>
c0104949:	85 c0                	test   %eax,%eax
c010494b:	74 24                	je     c0104971 <check_pgdir+0x5a8>
c010494d:	c7 44 24 0c 8a 69 10 	movl   $0xc010698a,0xc(%esp)
c0104954:	c0 
c0104955:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c010495c:	c0 
c010495d:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0104964:	00 
c0104965:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c010496c:	e8 9b c2 ff ff       	call   c0100c0c <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104971:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104976:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010497d:	00 
c010497e:	89 04 24             	mov    %eax,(%esp)
c0104981:	e8 cb f8 ff ff       	call   c0104251 <page_remove>
    assert(page_ref(p1) == 0);
c0104986:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104989:	89 04 24             	mov    %eax,(%esp)
c010498c:	e8 26 ef ff ff       	call   c01038b7 <page_ref>
c0104991:	85 c0                	test   %eax,%eax
c0104993:	74 24                	je     c01049b9 <check_pgdir+0x5f0>
c0104995:	c7 44 24 0c b1 69 10 	movl   $0xc01069b1,0xc(%esp)
c010499c:	c0 
c010499d:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c01049a4:	c0 
c01049a5:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
c01049ac:	00 
c01049ad:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c01049b4:	e8 53 c2 ff ff       	call   c0100c0c <__panic>
    assert(page_ref(p2) == 0);
c01049b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01049bc:	89 04 24             	mov    %eax,(%esp)
c01049bf:	e8 f3 ee ff ff       	call   c01038b7 <page_ref>
c01049c4:	85 c0                	test   %eax,%eax
c01049c6:	74 24                	je     c01049ec <check_pgdir+0x623>
c01049c8:	c7 44 24 0c 8a 69 10 	movl   $0xc010698a,0xc(%esp)
c01049cf:	c0 
c01049d0:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c01049d7:	c0 
c01049d8:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c01049df:	00 
c01049e0:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c01049e7:	e8 20 c2 ff ff       	call   c0100c0c <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c01049ec:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c01049f1:	8b 00                	mov    (%eax),%eax
c01049f3:	89 04 24             	mov    %eax,(%esp)
c01049f6:	e8 db ed ff ff       	call   c01037d6 <pa2page>
c01049fb:	89 04 24             	mov    %eax,(%esp)
c01049fe:	e8 b4 ee ff ff       	call   c01038b7 <page_ref>
c0104a03:	83 f8 01             	cmp    $0x1,%eax
c0104a06:	74 24                	je     c0104a2c <check_pgdir+0x663>
c0104a08:	c7 44 24 0c c4 69 10 	movl   $0xc01069c4,0xc(%esp)
c0104a0f:	c0 
c0104a10:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0104a17:	c0 
c0104a18:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104a1f:	00 
c0104a20:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104a27:	e8 e0 c1 ff ff       	call   c0100c0c <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0104a2c:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104a31:	8b 00                	mov    (%eax),%eax
c0104a33:	89 04 24             	mov    %eax,(%esp)
c0104a36:	e8 9b ed ff ff       	call   c01037d6 <pa2page>
c0104a3b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104a42:	00 
c0104a43:	89 04 24             	mov    %eax,(%esp)
c0104a46:	e8 9c f0 ff ff       	call   c0103ae7 <free_pages>
    boot_pgdir[0] = 0;
c0104a4b:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104a50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104a56:	c7 04 24 ea 69 10 c0 	movl   $0xc01069ea,(%esp)
c0104a5d:	e8 da b8 ff ff       	call   c010033c <cprintf>
}
c0104a62:	c9                   	leave  
c0104a63:	c3                   	ret    

c0104a64 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104a64:	55                   	push   %ebp
c0104a65:	89 e5                	mov    %esp,%ebp
c0104a67:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104a6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104a71:	e9 ca 00 00 00       	jmp    c0104b40 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104a76:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a79:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a7f:	c1 e8 0c             	shr    $0xc,%eax
c0104a82:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104a85:	a1 c0 78 11 c0       	mov    0xc01178c0,%eax
c0104a8a:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104a8d:	72 23                	jb     c0104ab2 <check_boot_pgdir+0x4e>
c0104a8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a92:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104a96:	c7 44 24 08 34 66 10 	movl   $0xc0106634,0x8(%esp)
c0104a9d:	c0 
c0104a9e:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104aa5:	00 
c0104aa6:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104aad:	e8 5a c1 ff ff       	call   c0100c0c <__panic>
c0104ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ab5:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104aba:	89 c2                	mov    %eax,%edx
c0104abc:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104ac1:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104ac8:	00 
c0104ac9:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104acd:	89 04 24             	mov    %eax,(%esp)
c0104ad0:	e8 19 f7 ff ff       	call   c01041ee <get_pte>
c0104ad5:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104ad8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104adc:	75 24                	jne    c0104b02 <check_boot_pgdir+0x9e>
c0104ade:	c7 44 24 0c 04 6a 10 	movl   $0xc0106a04,0xc(%esp)
c0104ae5:	c0 
c0104ae6:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0104aed:	c0 
c0104aee:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0104af5:	00 
c0104af6:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104afd:	e8 0a c1 ff ff       	call   c0100c0c <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104b02:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104b05:	8b 00                	mov    (%eax),%eax
c0104b07:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b0c:	89 c2                	mov    %eax,%edx
c0104b0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b11:	39 c2                	cmp    %eax,%edx
c0104b13:	74 24                	je     c0104b39 <check_boot_pgdir+0xd5>
c0104b15:	c7 44 24 0c 41 6a 10 	movl   $0xc0106a41,0xc(%esp)
c0104b1c:	c0 
c0104b1d:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0104b24:	c0 
c0104b25:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104b2c:	00 
c0104b2d:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104b34:	e8 d3 c0 ff ff       	call   c0100c0c <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104b39:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104b40:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104b43:	a1 c0 78 11 c0       	mov    0xc01178c0,%eax
c0104b48:	39 c2                	cmp    %eax,%edx
c0104b4a:	0f 82 26 ff ff ff    	jb     c0104a76 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104b50:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104b55:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104b5a:	8b 00                	mov    (%eax),%eax
c0104b5c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104b61:	89 c2                	mov    %eax,%edx
c0104b63:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104b68:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104b6b:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104b72:	77 23                	ja     c0104b97 <check_boot_pgdir+0x133>
c0104b74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b77:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104b7b:	c7 44 24 08 d8 66 10 	movl   $0xc01066d8,0x8(%esp)
c0104b82:	c0 
c0104b83:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104b8a:	00 
c0104b8b:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104b92:	e8 75 c0 ff ff       	call   c0100c0c <__panic>
c0104b97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b9a:	05 00 00 00 40       	add    $0x40000000,%eax
c0104b9f:	39 c2                	cmp    %eax,%edx
c0104ba1:	74 24                	je     c0104bc7 <check_boot_pgdir+0x163>
c0104ba3:	c7 44 24 0c 58 6a 10 	movl   $0xc0106a58,0xc(%esp)
c0104baa:	c0 
c0104bab:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0104bb2:	c0 
c0104bb3:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c0104bba:	00 
c0104bbb:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104bc2:	e8 45 c0 ff ff       	call   c0100c0c <__panic>

    assert(boot_pgdir[0] == 0);
c0104bc7:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104bcc:	8b 00                	mov    (%eax),%eax
c0104bce:	85 c0                	test   %eax,%eax
c0104bd0:	74 24                	je     c0104bf6 <check_boot_pgdir+0x192>
c0104bd2:	c7 44 24 0c 8c 6a 10 	movl   $0xc0106a8c,0xc(%esp)
c0104bd9:	c0 
c0104bda:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0104be1:	c0 
c0104be2:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104be9:	00 
c0104bea:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104bf1:	e8 16 c0 ff ff       	call   c0100c0c <__panic>

    struct Page *p;
    p = alloc_page();
c0104bf6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104bfd:	e8 ad ee ff ff       	call   c0103aaf <alloc_pages>
c0104c02:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104c05:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104c0a:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104c11:	00 
c0104c12:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104c19:	00 
c0104c1a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104c1d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104c21:	89 04 24             	mov    %eax,(%esp)
c0104c24:	e8 6c f6 ff ff       	call   c0104295 <page_insert>
c0104c29:	85 c0                	test   %eax,%eax
c0104c2b:	74 24                	je     c0104c51 <check_boot_pgdir+0x1ed>
c0104c2d:	c7 44 24 0c a0 6a 10 	movl   $0xc0106aa0,0xc(%esp)
c0104c34:	c0 
c0104c35:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0104c3c:	c0 
c0104c3d:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0104c44:	00 
c0104c45:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104c4c:	e8 bb bf ff ff       	call   c0100c0c <__panic>
    assert(page_ref(p) == 1);
c0104c51:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104c54:	89 04 24             	mov    %eax,(%esp)
c0104c57:	e8 5b ec ff ff       	call   c01038b7 <page_ref>
c0104c5c:	83 f8 01             	cmp    $0x1,%eax
c0104c5f:	74 24                	je     c0104c85 <check_boot_pgdir+0x221>
c0104c61:	c7 44 24 0c ce 6a 10 	movl   $0xc0106ace,0xc(%esp)
c0104c68:	c0 
c0104c69:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0104c70:	c0 
c0104c71:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
c0104c78:	00 
c0104c79:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104c80:	e8 87 bf ff ff       	call   c0100c0c <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0104c85:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104c8a:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104c91:	00 
c0104c92:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0104c99:	00 
c0104c9a:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104c9d:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ca1:	89 04 24             	mov    %eax,(%esp)
c0104ca4:	e8 ec f5 ff ff       	call   c0104295 <page_insert>
c0104ca9:	85 c0                	test   %eax,%eax
c0104cab:	74 24                	je     c0104cd1 <check_boot_pgdir+0x26d>
c0104cad:	c7 44 24 0c e0 6a 10 	movl   $0xc0106ae0,0xc(%esp)
c0104cb4:	c0 
c0104cb5:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0104cbc:	c0 
c0104cbd:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
c0104cc4:	00 
c0104cc5:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104ccc:	e8 3b bf ff ff       	call   c0100c0c <__panic>
    assert(page_ref(p) == 2);
c0104cd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104cd4:	89 04 24             	mov    %eax,(%esp)
c0104cd7:	e8 db eb ff ff       	call   c01038b7 <page_ref>
c0104cdc:	83 f8 02             	cmp    $0x2,%eax
c0104cdf:	74 24                	je     c0104d05 <check_boot_pgdir+0x2a1>
c0104ce1:	c7 44 24 0c 17 6b 10 	movl   $0xc0106b17,0xc(%esp)
c0104ce8:	c0 
c0104ce9:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0104cf0:	c0 
c0104cf1:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0104cf8:	00 
c0104cf9:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104d00:	e8 07 bf ff ff       	call   c0100c0c <__panic>

    const char *str = "ucore: Hello world!!";
c0104d05:	c7 45 dc 28 6b 10 c0 	movl   $0xc0106b28,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0104d0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104d0f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104d13:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104d1a:	e8 1e 0a 00 00       	call   c010573d <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0104d1f:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0104d26:	00 
c0104d27:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104d2e:	e8 83 0a 00 00       	call   c01057b6 <strcmp>
c0104d33:	85 c0                	test   %eax,%eax
c0104d35:	74 24                	je     c0104d5b <check_boot_pgdir+0x2f7>
c0104d37:	c7 44 24 0c 40 6b 10 	movl   $0xc0106b40,0xc(%esp)
c0104d3e:	c0 
c0104d3f:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0104d46:	c0 
c0104d47:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0104d4e:	00 
c0104d4f:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104d56:	e8 b1 be ff ff       	call   c0100c0c <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0104d5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d5e:	89 04 24             	mov    %eax,(%esp)
c0104d61:	e8 bf ea ff ff       	call   c0103825 <page2kva>
c0104d66:	05 00 01 00 00       	add    $0x100,%eax
c0104d6b:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0104d6e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0104d75:	e8 6b 09 00 00       	call   c01056e5 <strlen>
c0104d7a:	85 c0                	test   %eax,%eax
c0104d7c:	74 24                	je     c0104da2 <check_boot_pgdir+0x33e>
c0104d7e:	c7 44 24 0c 78 6b 10 	movl   $0xc0106b78,0xc(%esp)
c0104d85:	c0 
c0104d86:	c7 44 24 08 21 67 10 	movl   $0xc0106721,0x8(%esp)
c0104d8d:	c0 
c0104d8e:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0104d95:	00 
c0104d96:	c7 04 24 fc 66 10 c0 	movl   $0xc01066fc,(%esp)
c0104d9d:	e8 6a be ff ff       	call   c0100c0c <__panic>

    free_page(p);
c0104da2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104da9:	00 
c0104daa:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104dad:	89 04 24             	mov    %eax,(%esp)
c0104db0:	e8 32 ed ff ff       	call   c0103ae7 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c0104db5:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104dba:	8b 00                	mov    (%eax),%eax
c0104dbc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104dc1:	89 04 24             	mov    %eax,(%esp)
c0104dc4:	e8 0d ea ff ff       	call   c01037d6 <pa2page>
c0104dc9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104dd0:	00 
c0104dd1:	89 04 24             	mov    %eax,(%esp)
c0104dd4:	e8 0e ed ff ff       	call   c0103ae7 <free_pages>
    boot_pgdir[0] = 0;
c0104dd9:	a1 c4 78 11 c0       	mov    0xc01178c4,%eax
c0104dde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0104de4:	c7 04 24 9c 6b 10 c0 	movl   $0xc0106b9c,(%esp)
c0104deb:	e8 4c b5 ff ff       	call   c010033c <cprintf>
}
c0104df0:	c9                   	leave  
c0104df1:	c3                   	ret    

c0104df2 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0104df2:	55                   	push   %ebp
c0104df3:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0104df5:	8b 45 08             	mov    0x8(%ebp),%eax
c0104df8:	83 e0 04             	and    $0x4,%eax
c0104dfb:	85 c0                	test   %eax,%eax
c0104dfd:	74 07                	je     c0104e06 <perm2str+0x14>
c0104dff:	b8 75 00 00 00       	mov    $0x75,%eax
c0104e04:	eb 05                	jmp    c0104e0b <perm2str+0x19>
c0104e06:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0104e0b:	a2 48 79 11 c0       	mov    %al,0xc0117948
    str[1] = 'r';
c0104e10:	c6 05 49 79 11 c0 72 	movb   $0x72,0xc0117949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0104e17:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e1a:	83 e0 02             	and    $0x2,%eax
c0104e1d:	85 c0                	test   %eax,%eax
c0104e1f:	74 07                	je     c0104e28 <perm2str+0x36>
c0104e21:	b8 77 00 00 00       	mov    $0x77,%eax
c0104e26:	eb 05                	jmp    c0104e2d <perm2str+0x3b>
c0104e28:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0104e2d:	a2 4a 79 11 c0       	mov    %al,0xc011794a
    str[3] = '\0';
c0104e32:	c6 05 4b 79 11 c0 00 	movb   $0x0,0xc011794b
    return str;
c0104e39:	b8 48 79 11 c0       	mov    $0xc0117948,%eax
}
c0104e3e:	5d                   	pop    %ebp
c0104e3f:	c3                   	ret    

c0104e40 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0104e40:	55                   	push   %ebp
c0104e41:	89 e5                	mov    %esp,%ebp
c0104e43:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0104e46:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e49:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104e4c:	72 0a                	jb     c0104e58 <get_pgtable_items+0x18>
        return 0;
c0104e4e:	b8 00 00 00 00       	mov    $0x0,%eax
c0104e53:	e9 9c 00 00 00       	jmp    c0104ef4 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c0104e58:	eb 04                	jmp    c0104e5e <get_pgtable_items+0x1e>
        start ++;
c0104e5a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0104e5e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e61:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104e64:	73 18                	jae    c0104e7e <get_pgtable_items+0x3e>
c0104e66:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e69:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104e70:	8b 45 14             	mov    0x14(%ebp),%eax
c0104e73:	01 d0                	add    %edx,%eax
c0104e75:	8b 00                	mov    (%eax),%eax
c0104e77:	83 e0 01             	and    $0x1,%eax
c0104e7a:	85 c0                	test   %eax,%eax
c0104e7c:	74 dc                	je     c0104e5a <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0104e7e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e81:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104e84:	73 69                	jae    c0104eef <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c0104e86:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0104e8a:	74 08                	je     c0104e94 <get_pgtable_items+0x54>
            *left_store = start;
c0104e8c:	8b 45 18             	mov    0x18(%ebp),%eax
c0104e8f:	8b 55 10             	mov    0x10(%ebp),%edx
c0104e92:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0104e94:	8b 45 10             	mov    0x10(%ebp),%eax
c0104e97:	8d 50 01             	lea    0x1(%eax),%edx
c0104e9a:	89 55 10             	mov    %edx,0x10(%ebp)
c0104e9d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104ea4:	8b 45 14             	mov    0x14(%ebp),%eax
c0104ea7:	01 d0                	add    %edx,%eax
c0104ea9:	8b 00                	mov    (%eax),%eax
c0104eab:	83 e0 07             	and    $0x7,%eax
c0104eae:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104eb1:	eb 04                	jmp    c0104eb7 <get_pgtable_items+0x77>
            start ++;
c0104eb3:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104eb7:	8b 45 10             	mov    0x10(%ebp),%eax
c0104eba:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104ebd:	73 1d                	jae    c0104edc <get_pgtable_items+0x9c>
c0104ebf:	8b 45 10             	mov    0x10(%ebp),%eax
c0104ec2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104ec9:	8b 45 14             	mov    0x14(%ebp),%eax
c0104ecc:	01 d0                	add    %edx,%eax
c0104ece:	8b 00                	mov    (%eax),%eax
c0104ed0:	83 e0 07             	and    $0x7,%eax
c0104ed3:	89 c2                	mov    %eax,%edx
c0104ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104ed8:	39 c2                	cmp    %eax,%edx
c0104eda:	74 d7                	je     c0104eb3 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c0104edc:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0104ee0:	74 08                	je     c0104eea <get_pgtable_items+0xaa>
            *right_store = start;
c0104ee2:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0104ee5:	8b 55 10             	mov    0x10(%ebp),%edx
c0104ee8:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0104eea:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104eed:	eb 05                	jmp    c0104ef4 <get_pgtable_items+0xb4>
    }
    return 0;
c0104eef:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104ef4:	c9                   	leave  
c0104ef5:	c3                   	ret    

c0104ef6 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0104ef6:	55                   	push   %ebp
c0104ef7:	89 e5                	mov    %esp,%ebp
c0104ef9:	57                   	push   %edi
c0104efa:	56                   	push   %esi
c0104efb:	53                   	push   %ebx
c0104efc:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0104eff:	c7 04 24 bc 6b 10 c0 	movl   $0xc0106bbc,(%esp)
c0104f06:	e8 31 b4 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c0104f0b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0104f12:	e9 fa 00 00 00       	jmp    c0105011 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104f17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f1a:	89 04 24             	mov    %eax,(%esp)
c0104f1d:	e8 d0 fe ff ff       	call   c0104df2 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0104f22:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0104f25:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104f28:	29 d1                	sub    %edx,%ecx
c0104f2a:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0104f2c:	89 d6                	mov    %edx,%esi
c0104f2e:	c1 e6 16             	shl    $0x16,%esi
c0104f31:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104f34:	89 d3                	mov    %edx,%ebx
c0104f36:	c1 e3 16             	shl    $0x16,%ebx
c0104f39:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104f3c:	89 d1                	mov    %edx,%ecx
c0104f3e:	c1 e1 16             	shl    $0x16,%ecx
c0104f41:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0104f44:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104f47:	29 d7                	sub    %edx,%edi
c0104f49:	89 fa                	mov    %edi,%edx
c0104f4b:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104f4f:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104f53:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104f57:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0104f5b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f5f:	c7 04 24 ed 6b 10 c0 	movl   $0xc0106bed,(%esp)
c0104f66:	e8 d1 b3 ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0104f6b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104f6e:	c1 e0 0a             	shl    $0xa,%eax
c0104f71:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104f74:	eb 54                	jmp    c0104fca <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104f76:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f79:	89 04 24             	mov    %eax,(%esp)
c0104f7c:	e8 71 fe ff ff       	call   c0104df2 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104f81:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0104f84:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104f87:	29 d1                	sub    %edx,%ecx
c0104f89:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104f8b:	89 d6                	mov    %edx,%esi
c0104f8d:	c1 e6 0c             	shl    $0xc,%esi
c0104f90:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104f93:	89 d3                	mov    %edx,%ebx
c0104f95:	c1 e3 0c             	shl    $0xc,%ebx
c0104f98:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104f9b:	c1 e2 0c             	shl    $0xc,%edx
c0104f9e:	89 d1                	mov    %edx,%ecx
c0104fa0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0104fa3:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104fa6:	29 d7                	sub    %edx,%edi
c0104fa8:	89 fa                	mov    %edi,%edx
c0104faa:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104fae:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104fb2:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0104fb6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0104fba:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104fbe:	c7 04 24 0c 6c 10 c0 	movl   $0xc0106c0c,(%esp)
c0104fc5:	e8 72 b3 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104fca:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0104fcf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104fd2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0104fd5:	89 ce                	mov    %ecx,%esi
c0104fd7:	c1 e6 0a             	shl    $0xa,%esi
c0104fda:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0104fdd:	89 cb                	mov    %ecx,%ebx
c0104fdf:	c1 e3 0a             	shl    $0xa,%ebx
c0104fe2:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0104fe5:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0104fe9:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0104fec:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0104ff0:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0104ff4:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104ff8:	89 74 24 04          	mov    %esi,0x4(%esp)
c0104ffc:	89 1c 24             	mov    %ebx,(%esp)
c0104fff:	e8 3c fe ff ff       	call   c0104e40 <get_pgtable_items>
c0105004:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105007:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010500b:	0f 85 65 ff ff ff    	jne    c0104f76 <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105011:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c0105016:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105019:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c010501c:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105020:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105023:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105027:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010502b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010502f:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105036:	00 
c0105037:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010503e:	e8 fd fd ff ff       	call   c0104e40 <get_pgtable_items>
c0105043:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105046:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010504a:	0f 85 c7 fe ff ff    	jne    c0104f17 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105050:	c7 04 24 30 6c 10 c0 	movl   $0xc0106c30,(%esp)
c0105057:	e8 e0 b2 ff ff       	call   c010033c <cprintf>
}
c010505c:	83 c4 4c             	add    $0x4c,%esp
c010505f:	5b                   	pop    %ebx
c0105060:	5e                   	pop    %esi
c0105061:	5f                   	pop    %edi
c0105062:	5d                   	pop    %ebp
c0105063:	c3                   	ret    

c0105064 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105064:	55                   	push   %ebp
c0105065:	89 e5                	mov    %esp,%ebp
c0105067:	83 ec 58             	sub    $0x58,%esp
c010506a:	8b 45 10             	mov    0x10(%ebp),%eax
c010506d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105070:	8b 45 14             	mov    0x14(%ebp),%eax
c0105073:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c0105076:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105079:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010507c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010507f:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105082:	8b 45 18             	mov    0x18(%ebp),%eax
c0105085:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105088:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010508b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010508e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105091:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105094:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105097:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010509a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010509e:	74 1c                	je     c01050bc <printnum+0x58>
c01050a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050a3:	ba 00 00 00 00       	mov    $0x0,%edx
c01050a8:	f7 75 e4             	divl   -0x1c(%ebp)
c01050ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01050ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050b1:	ba 00 00 00 00       	mov    $0x0,%edx
c01050b6:	f7 75 e4             	divl   -0x1c(%ebp)
c01050b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01050bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01050c2:	f7 75 e4             	divl   -0x1c(%ebp)
c01050c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01050c8:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01050cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050ce:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01050d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01050d4:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01050d7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050da:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01050dd:	8b 45 18             	mov    0x18(%ebp),%eax
c01050e0:	ba 00 00 00 00       	mov    $0x0,%edx
c01050e5:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01050e8:	77 56                	ja     c0105140 <printnum+0xdc>
c01050ea:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01050ed:	72 05                	jb     c01050f4 <printnum+0x90>
c01050ef:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01050f2:	77 4c                	ja     c0105140 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01050f4:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01050f7:	8d 50 ff             	lea    -0x1(%eax),%edx
c01050fa:	8b 45 20             	mov    0x20(%ebp),%eax
c01050fd:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105101:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105105:	8b 45 18             	mov    0x18(%ebp),%eax
c0105108:	89 44 24 10          	mov    %eax,0x10(%esp)
c010510c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010510f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105112:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105116:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010511a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010511d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105121:	8b 45 08             	mov    0x8(%ebp),%eax
c0105124:	89 04 24             	mov    %eax,(%esp)
c0105127:	e8 38 ff ff ff       	call   c0105064 <printnum>
c010512c:	eb 1c                	jmp    c010514a <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010512e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105131:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105135:	8b 45 20             	mov    0x20(%ebp),%eax
c0105138:	89 04 24             	mov    %eax,(%esp)
c010513b:	8b 45 08             	mov    0x8(%ebp),%eax
c010513e:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0105140:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105144:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105148:	7f e4                	jg     c010512e <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010514a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010514d:	05 e4 6c 10 c0       	add    $0xc0106ce4,%eax
c0105152:	0f b6 00             	movzbl (%eax),%eax
c0105155:	0f be c0             	movsbl %al,%eax
c0105158:	8b 55 0c             	mov    0xc(%ebp),%edx
c010515b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010515f:	89 04 24             	mov    %eax,(%esp)
c0105162:	8b 45 08             	mov    0x8(%ebp),%eax
c0105165:	ff d0                	call   *%eax
}
c0105167:	c9                   	leave  
c0105168:	c3                   	ret    

c0105169 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105169:	55                   	push   %ebp
c010516a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010516c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105170:	7e 14                	jle    c0105186 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105172:	8b 45 08             	mov    0x8(%ebp),%eax
c0105175:	8b 00                	mov    (%eax),%eax
c0105177:	8d 48 08             	lea    0x8(%eax),%ecx
c010517a:	8b 55 08             	mov    0x8(%ebp),%edx
c010517d:	89 0a                	mov    %ecx,(%edx)
c010517f:	8b 50 04             	mov    0x4(%eax),%edx
c0105182:	8b 00                	mov    (%eax),%eax
c0105184:	eb 30                	jmp    c01051b6 <getuint+0x4d>
    }
    else if (lflag) {
c0105186:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010518a:	74 16                	je     c01051a2 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010518c:	8b 45 08             	mov    0x8(%ebp),%eax
c010518f:	8b 00                	mov    (%eax),%eax
c0105191:	8d 48 04             	lea    0x4(%eax),%ecx
c0105194:	8b 55 08             	mov    0x8(%ebp),%edx
c0105197:	89 0a                	mov    %ecx,(%edx)
c0105199:	8b 00                	mov    (%eax),%eax
c010519b:	ba 00 00 00 00       	mov    $0x0,%edx
c01051a0:	eb 14                	jmp    c01051b6 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01051a2:	8b 45 08             	mov    0x8(%ebp),%eax
c01051a5:	8b 00                	mov    (%eax),%eax
c01051a7:	8d 48 04             	lea    0x4(%eax),%ecx
c01051aa:	8b 55 08             	mov    0x8(%ebp),%edx
c01051ad:	89 0a                	mov    %ecx,(%edx)
c01051af:	8b 00                	mov    (%eax),%eax
c01051b1:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01051b6:	5d                   	pop    %ebp
c01051b7:	c3                   	ret    

c01051b8 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01051b8:	55                   	push   %ebp
c01051b9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01051bb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01051bf:	7e 14                	jle    c01051d5 <getint+0x1d>
        return va_arg(*ap, long long);
c01051c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01051c4:	8b 00                	mov    (%eax),%eax
c01051c6:	8d 48 08             	lea    0x8(%eax),%ecx
c01051c9:	8b 55 08             	mov    0x8(%ebp),%edx
c01051cc:	89 0a                	mov    %ecx,(%edx)
c01051ce:	8b 50 04             	mov    0x4(%eax),%edx
c01051d1:	8b 00                	mov    (%eax),%eax
c01051d3:	eb 28                	jmp    c01051fd <getint+0x45>
    }
    else if (lflag) {
c01051d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01051d9:	74 12                	je     c01051ed <getint+0x35>
        return va_arg(*ap, long);
c01051db:	8b 45 08             	mov    0x8(%ebp),%eax
c01051de:	8b 00                	mov    (%eax),%eax
c01051e0:	8d 48 04             	lea    0x4(%eax),%ecx
c01051e3:	8b 55 08             	mov    0x8(%ebp),%edx
c01051e6:	89 0a                	mov    %ecx,(%edx)
c01051e8:	8b 00                	mov    (%eax),%eax
c01051ea:	99                   	cltd   
c01051eb:	eb 10                	jmp    c01051fd <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01051ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01051f0:	8b 00                	mov    (%eax),%eax
c01051f2:	8d 48 04             	lea    0x4(%eax),%ecx
c01051f5:	8b 55 08             	mov    0x8(%ebp),%edx
c01051f8:	89 0a                	mov    %ecx,(%edx)
c01051fa:	8b 00                	mov    (%eax),%eax
c01051fc:	99                   	cltd   
    }
}
c01051fd:	5d                   	pop    %ebp
c01051fe:	c3                   	ret    

c01051ff <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01051ff:	55                   	push   %ebp
c0105200:	89 e5                	mov    %esp,%ebp
c0105202:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105205:	8d 45 14             	lea    0x14(%ebp),%eax
c0105208:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c010520b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010520e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105212:	8b 45 10             	mov    0x10(%ebp),%eax
c0105215:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105219:	8b 45 0c             	mov    0xc(%ebp),%eax
c010521c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105220:	8b 45 08             	mov    0x8(%ebp),%eax
c0105223:	89 04 24             	mov    %eax,(%esp)
c0105226:	e8 02 00 00 00       	call   c010522d <vprintfmt>
    va_end(ap);
}
c010522b:	c9                   	leave  
c010522c:	c3                   	ret    

c010522d <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010522d:	55                   	push   %ebp
c010522e:	89 e5                	mov    %esp,%ebp
c0105230:	56                   	push   %esi
c0105231:	53                   	push   %ebx
c0105232:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105235:	eb 18                	jmp    c010524f <vprintfmt+0x22>
            if (ch == '\0') {
c0105237:	85 db                	test   %ebx,%ebx
c0105239:	75 05                	jne    c0105240 <vprintfmt+0x13>
                return;
c010523b:	e9 d1 03 00 00       	jmp    c0105611 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0105240:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105243:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105247:	89 1c 24             	mov    %ebx,(%esp)
c010524a:	8b 45 08             	mov    0x8(%ebp),%eax
c010524d:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010524f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105252:	8d 50 01             	lea    0x1(%eax),%edx
c0105255:	89 55 10             	mov    %edx,0x10(%ebp)
c0105258:	0f b6 00             	movzbl (%eax),%eax
c010525b:	0f b6 d8             	movzbl %al,%ebx
c010525e:	83 fb 25             	cmp    $0x25,%ebx
c0105261:	75 d4                	jne    c0105237 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105263:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105267:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010526e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105271:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105274:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010527b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010527e:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105281:	8b 45 10             	mov    0x10(%ebp),%eax
c0105284:	8d 50 01             	lea    0x1(%eax),%edx
c0105287:	89 55 10             	mov    %edx,0x10(%ebp)
c010528a:	0f b6 00             	movzbl (%eax),%eax
c010528d:	0f b6 d8             	movzbl %al,%ebx
c0105290:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105293:	83 f8 55             	cmp    $0x55,%eax
c0105296:	0f 87 44 03 00 00    	ja     c01055e0 <vprintfmt+0x3b3>
c010529c:	8b 04 85 08 6d 10 c0 	mov    -0x3fef92f8(,%eax,4),%eax
c01052a3:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c01052a5:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c01052a9:	eb d6                	jmp    c0105281 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c01052ab:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c01052af:	eb d0                	jmp    c0105281 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01052b1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c01052b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01052bb:	89 d0                	mov    %edx,%eax
c01052bd:	c1 e0 02             	shl    $0x2,%eax
c01052c0:	01 d0                	add    %edx,%eax
c01052c2:	01 c0                	add    %eax,%eax
c01052c4:	01 d8                	add    %ebx,%eax
c01052c6:	83 e8 30             	sub    $0x30,%eax
c01052c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c01052cc:	8b 45 10             	mov    0x10(%ebp),%eax
c01052cf:	0f b6 00             	movzbl (%eax),%eax
c01052d2:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c01052d5:	83 fb 2f             	cmp    $0x2f,%ebx
c01052d8:	7e 0b                	jle    c01052e5 <vprintfmt+0xb8>
c01052da:	83 fb 39             	cmp    $0x39,%ebx
c01052dd:	7f 06                	jg     c01052e5 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01052df:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01052e3:	eb d3                	jmp    c01052b8 <vprintfmt+0x8b>
            goto process_precision;
c01052e5:	eb 33                	jmp    c010531a <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01052e7:	8b 45 14             	mov    0x14(%ebp),%eax
c01052ea:	8d 50 04             	lea    0x4(%eax),%edx
c01052ed:	89 55 14             	mov    %edx,0x14(%ebp)
c01052f0:	8b 00                	mov    (%eax),%eax
c01052f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01052f5:	eb 23                	jmp    c010531a <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01052f7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01052fb:	79 0c                	jns    c0105309 <vprintfmt+0xdc>
                width = 0;
c01052fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105304:	e9 78 ff ff ff       	jmp    c0105281 <vprintfmt+0x54>
c0105309:	e9 73 ff ff ff       	jmp    c0105281 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c010530e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105315:	e9 67 ff ff ff       	jmp    c0105281 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c010531a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010531e:	79 12                	jns    c0105332 <vprintfmt+0x105>
                width = precision, precision = -1;
c0105320:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105323:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105326:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010532d:	e9 4f ff ff ff       	jmp    c0105281 <vprintfmt+0x54>
c0105332:	e9 4a ff ff ff       	jmp    c0105281 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105337:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010533b:	e9 41 ff ff ff       	jmp    c0105281 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105340:	8b 45 14             	mov    0x14(%ebp),%eax
c0105343:	8d 50 04             	lea    0x4(%eax),%edx
c0105346:	89 55 14             	mov    %edx,0x14(%ebp)
c0105349:	8b 00                	mov    (%eax),%eax
c010534b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010534e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105352:	89 04 24             	mov    %eax,(%esp)
c0105355:	8b 45 08             	mov    0x8(%ebp),%eax
c0105358:	ff d0                	call   *%eax
            break;
c010535a:	e9 ac 02 00 00       	jmp    c010560b <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010535f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105362:	8d 50 04             	lea    0x4(%eax),%edx
c0105365:	89 55 14             	mov    %edx,0x14(%ebp)
c0105368:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010536a:	85 db                	test   %ebx,%ebx
c010536c:	79 02                	jns    c0105370 <vprintfmt+0x143>
                err = -err;
c010536e:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105370:	83 fb 06             	cmp    $0x6,%ebx
c0105373:	7f 0b                	jg     c0105380 <vprintfmt+0x153>
c0105375:	8b 34 9d c8 6c 10 c0 	mov    -0x3fef9338(,%ebx,4),%esi
c010537c:	85 f6                	test   %esi,%esi
c010537e:	75 23                	jne    c01053a3 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0105380:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105384:	c7 44 24 08 f5 6c 10 	movl   $0xc0106cf5,0x8(%esp)
c010538b:	c0 
c010538c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010538f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105393:	8b 45 08             	mov    0x8(%ebp),%eax
c0105396:	89 04 24             	mov    %eax,(%esp)
c0105399:	e8 61 fe ff ff       	call   c01051ff <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010539e:	e9 68 02 00 00       	jmp    c010560b <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c01053a3:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01053a7:	c7 44 24 08 fe 6c 10 	movl   $0xc0106cfe,0x8(%esp)
c01053ae:	c0 
c01053af:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053b2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01053b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01053b9:	89 04 24             	mov    %eax,(%esp)
c01053bc:	e8 3e fe ff ff       	call   c01051ff <printfmt>
            }
            break;
c01053c1:	e9 45 02 00 00       	jmp    c010560b <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c01053c6:	8b 45 14             	mov    0x14(%ebp),%eax
c01053c9:	8d 50 04             	lea    0x4(%eax),%edx
c01053cc:	89 55 14             	mov    %edx,0x14(%ebp)
c01053cf:	8b 30                	mov    (%eax),%esi
c01053d1:	85 f6                	test   %esi,%esi
c01053d3:	75 05                	jne    c01053da <vprintfmt+0x1ad>
                p = "(null)";
c01053d5:	be 01 6d 10 c0       	mov    $0xc0106d01,%esi
            }
            if (width > 0 && padc != '-') {
c01053da:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01053de:	7e 3e                	jle    c010541e <vprintfmt+0x1f1>
c01053e0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01053e4:	74 38                	je     c010541e <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01053e6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01053e9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01053ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01053f0:	89 34 24             	mov    %esi,(%esp)
c01053f3:	e8 15 03 00 00       	call   c010570d <strnlen>
c01053f8:	29 c3                	sub    %eax,%ebx
c01053fa:	89 d8                	mov    %ebx,%eax
c01053fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01053ff:	eb 17                	jmp    c0105418 <vprintfmt+0x1eb>
                    putch(padc, putdat);
c0105401:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105405:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105408:	89 54 24 04          	mov    %edx,0x4(%esp)
c010540c:	89 04 24             	mov    %eax,(%esp)
c010540f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105412:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105414:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105418:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010541c:	7f e3                	jg     c0105401 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010541e:	eb 38                	jmp    c0105458 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105420:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105424:	74 1f                	je     c0105445 <vprintfmt+0x218>
c0105426:	83 fb 1f             	cmp    $0x1f,%ebx
c0105429:	7e 05                	jle    c0105430 <vprintfmt+0x203>
c010542b:	83 fb 7e             	cmp    $0x7e,%ebx
c010542e:	7e 15                	jle    c0105445 <vprintfmt+0x218>
                    putch('?', putdat);
c0105430:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105433:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105437:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010543e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105441:	ff d0                	call   *%eax
c0105443:	eb 0f                	jmp    c0105454 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c0105445:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105448:	89 44 24 04          	mov    %eax,0x4(%esp)
c010544c:	89 1c 24             	mov    %ebx,(%esp)
c010544f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105452:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105454:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105458:	89 f0                	mov    %esi,%eax
c010545a:	8d 70 01             	lea    0x1(%eax),%esi
c010545d:	0f b6 00             	movzbl (%eax),%eax
c0105460:	0f be d8             	movsbl %al,%ebx
c0105463:	85 db                	test   %ebx,%ebx
c0105465:	74 10                	je     c0105477 <vprintfmt+0x24a>
c0105467:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010546b:	78 b3                	js     c0105420 <vprintfmt+0x1f3>
c010546d:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105471:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105475:	79 a9                	jns    c0105420 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105477:	eb 17                	jmp    c0105490 <vprintfmt+0x263>
                putch(' ', putdat);
c0105479:	8b 45 0c             	mov    0xc(%ebp),%eax
c010547c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105480:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105487:	8b 45 08             	mov    0x8(%ebp),%eax
c010548a:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010548c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105490:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105494:	7f e3                	jg     c0105479 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c0105496:	e9 70 01 00 00       	jmp    c010560b <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010549b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010549e:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054a2:	8d 45 14             	lea    0x14(%ebp),%eax
c01054a5:	89 04 24             	mov    %eax,(%esp)
c01054a8:	e8 0b fd ff ff       	call   c01051b8 <getint>
c01054ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054b0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c01054b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054b9:	85 d2                	test   %edx,%edx
c01054bb:	79 26                	jns    c01054e3 <vprintfmt+0x2b6>
                putch('-', putdat);
c01054bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054c4:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c01054cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01054ce:	ff d0                	call   *%eax
                num = -(long long)num;
c01054d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054d6:	f7 d8                	neg    %eax
c01054d8:	83 d2 00             	adc    $0x0,%edx
c01054db:	f7 da                	neg    %edx
c01054dd:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01054e0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01054e3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01054ea:	e9 a8 00 00 00       	jmp    c0105597 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01054ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01054f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054f6:	8d 45 14             	lea    0x14(%ebp),%eax
c01054f9:	89 04 24             	mov    %eax,(%esp)
c01054fc:	e8 68 fc ff ff       	call   c0105169 <getuint>
c0105501:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105504:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105507:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010550e:	e9 84 00 00 00       	jmp    c0105597 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105513:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105516:	89 44 24 04          	mov    %eax,0x4(%esp)
c010551a:	8d 45 14             	lea    0x14(%ebp),%eax
c010551d:	89 04 24             	mov    %eax,(%esp)
c0105520:	e8 44 fc ff ff       	call   c0105169 <getuint>
c0105525:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105528:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010552b:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105532:	eb 63                	jmp    c0105597 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c0105534:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105537:	89 44 24 04          	mov    %eax,0x4(%esp)
c010553b:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105542:	8b 45 08             	mov    0x8(%ebp),%eax
c0105545:	ff d0                	call   *%eax
            putch('x', putdat);
c0105547:	8b 45 0c             	mov    0xc(%ebp),%eax
c010554a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010554e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105555:	8b 45 08             	mov    0x8(%ebp),%eax
c0105558:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010555a:	8b 45 14             	mov    0x14(%ebp),%eax
c010555d:	8d 50 04             	lea    0x4(%eax),%edx
c0105560:	89 55 14             	mov    %edx,0x14(%ebp)
c0105563:	8b 00                	mov    (%eax),%eax
c0105565:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105568:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010556f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105576:	eb 1f                	jmp    c0105597 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105578:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010557b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010557f:	8d 45 14             	lea    0x14(%ebp),%eax
c0105582:	89 04 24             	mov    %eax,(%esp)
c0105585:	e8 df fb ff ff       	call   c0105169 <getuint>
c010558a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010558d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105590:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105597:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010559b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010559e:	89 54 24 18          	mov    %edx,0x18(%esp)
c01055a2:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01055a5:	89 54 24 14          	mov    %edx,0x14(%esp)
c01055a9:	89 44 24 10          	mov    %eax,0x10(%esp)
c01055ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01055b3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01055b7:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01055bb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055be:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c5:	89 04 24             	mov    %eax,(%esp)
c01055c8:	e8 97 fa ff ff       	call   c0105064 <printnum>
            break;
c01055cd:	eb 3c                	jmp    c010560b <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c01055cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055d6:	89 1c 24             	mov    %ebx,(%esp)
c01055d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01055dc:	ff d0                	call   *%eax
            break;
c01055de:	eb 2b                	jmp    c010560b <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01055e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055e7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01055ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01055f1:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01055f3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01055f7:	eb 04                	jmp    c01055fd <vprintfmt+0x3d0>
c01055f9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01055fd:	8b 45 10             	mov    0x10(%ebp),%eax
c0105600:	83 e8 01             	sub    $0x1,%eax
c0105603:	0f b6 00             	movzbl (%eax),%eax
c0105606:	3c 25                	cmp    $0x25,%al
c0105608:	75 ef                	jne    c01055f9 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c010560a:	90                   	nop
        }
    }
c010560b:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010560c:	e9 3e fc ff ff       	jmp    c010524f <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105611:	83 c4 40             	add    $0x40,%esp
c0105614:	5b                   	pop    %ebx
c0105615:	5e                   	pop    %esi
c0105616:	5d                   	pop    %ebp
c0105617:	c3                   	ret    

c0105618 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105618:	55                   	push   %ebp
c0105619:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010561b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010561e:	8b 40 08             	mov    0x8(%eax),%eax
c0105621:	8d 50 01             	lea    0x1(%eax),%edx
c0105624:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105627:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010562a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010562d:	8b 10                	mov    (%eax),%edx
c010562f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105632:	8b 40 04             	mov    0x4(%eax),%eax
c0105635:	39 c2                	cmp    %eax,%edx
c0105637:	73 12                	jae    c010564b <sprintputch+0x33>
        *b->buf ++ = ch;
c0105639:	8b 45 0c             	mov    0xc(%ebp),%eax
c010563c:	8b 00                	mov    (%eax),%eax
c010563e:	8d 48 01             	lea    0x1(%eax),%ecx
c0105641:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105644:	89 0a                	mov    %ecx,(%edx)
c0105646:	8b 55 08             	mov    0x8(%ebp),%edx
c0105649:	88 10                	mov    %dl,(%eax)
    }
}
c010564b:	5d                   	pop    %ebp
c010564c:	c3                   	ret    

c010564d <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010564d:	55                   	push   %ebp
c010564e:	89 e5                	mov    %esp,%ebp
c0105650:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105653:	8d 45 14             	lea    0x14(%ebp),%eax
c0105656:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105659:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010565c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105660:	8b 45 10             	mov    0x10(%ebp),%eax
c0105663:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105667:	8b 45 0c             	mov    0xc(%ebp),%eax
c010566a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010566e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105671:	89 04 24             	mov    %eax,(%esp)
c0105674:	e8 08 00 00 00       	call   c0105681 <vsnprintf>
c0105679:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010567c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010567f:	c9                   	leave  
c0105680:	c3                   	ret    

c0105681 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105681:	55                   	push   %ebp
c0105682:	89 e5                	mov    %esp,%ebp
c0105684:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105687:	8b 45 08             	mov    0x8(%ebp),%eax
c010568a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010568d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105690:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105693:	8b 45 08             	mov    0x8(%ebp),%eax
c0105696:	01 d0                	add    %edx,%eax
c0105698:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010569b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c01056a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01056a6:	74 0a                	je     c01056b2 <vsnprintf+0x31>
c01056a8:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01056ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01056ae:	39 c2                	cmp    %eax,%edx
c01056b0:	76 07                	jbe    c01056b9 <vsnprintf+0x38>
        return -E_INVAL;
c01056b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c01056b7:	eb 2a                	jmp    c01056e3 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c01056b9:	8b 45 14             	mov    0x14(%ebp),%eax
c01056bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01056c0:	8b 45 10             	mov    0x10(%ebp),%eax
c01056c3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01056c7:	8d 45 ec             	lea    -0x14(%ebp),%eax
c01056ca:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056ce:	c7 04 24 18 56 10 c0 	movl   $0xc0105618,(%esp)
c01056d5:	e8 53 fb ff ff       	call   c010522d <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c01056da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01056dd:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c01056e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01056e3:	c9                   	leave  
c01056e4:	c3                   	ret    

c01056e5 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01056e5:	55                   	push   %ebp
c01056e6:	89 e5                	mov    %esp,%ebp
c01056e8:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01056eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01056f2:	eb 04                	jmp    c01056f8 <strlen+0x13>
        cnt ++;
c01056f4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c01056f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01056fb:	8d 50 01             	lea    0x1(%eax),%edx
c01056fe:	89 55 08             	mov    %edx,0x8(%ebp)
c0105701:	0f b6 00             	movzbl (%eax),%eax
c0105704:	84 c0                	test   %al,%al
c0105706:	75 ec                	jne    c01056f4 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105708:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010570b:	c9                   	leave  
c010570c:	c3                   	ret    

c010570d <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010570d:	55                   	push   %ebp
c010570e:	89 e5                	mov    %esp,%ebp
c0105710:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105713:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010571a:	eb 04                	jmp    c0105720 <strnlen+0x13>
        cnt ++;
c010571c:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105720:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105723:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105726:	73 10                	jae    c0105738 <strnlen+0x2b>
c0105728:	8b 45 08             	mov    0x8(%ebp),%eax
c010572b:	8d 50 01             	lea    0x1(%eax),%edx
c010572e:	89 55 08             	mov    %edx,0x8(%ebp)
c0105731:	0f b6 00             	movzbl (%eax),%eax
c0105734:	84 c0                	test   %al,%al
c0105736:	75 e4                	jne    c010571c <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105738:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010573b:	c9                   	leave  
c010573c:	c3                   	ret    

c010573d <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010573d:	55                   	push   %ebp
c010573e:	89 e5                	mov    %esp,%ebp
c0105740:	57                   	push   %edi
c0105741:	56                   	push   %esi
c0105742:	83 ec 20             	sub    $0x20,%esp
c0105745:	8b 45 08             	mov    0x8(%ebp),%eax
c0105748:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010574b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010574e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105751:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105754:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105757:	89 d1                	mov    %edx,%ecx
c0105759:	89 c2                	mov    %eax,%edx
c010575b:	89 ce                	mov    %ecx,%esi
c010575d:	89 d7                	mov    %edx,%edi
c010575f:	ac                   	lods   %ds:(%esi),%al
c0105760:	aa                   	stos   %al,%es:(%edi)
c0105761:	84 c0                	test   %al,%al
c0105763:	75 fa                	jne    c010575f <strcpy+0x22>
c0105765:	89 fa                	mov    %edi,%edx
c0105767:	89 f1                	mov    %esi,%ecx
c0105769:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c010576c:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010576f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105772:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105775:	83 c4 20             	add    $0x20,%esp
c0105778:	5e                   	pop    %esi
c0105779:	5f                   	pop    %edi
c010577a:	5d                   	pop    %ebp
c010577b:	c3                   	ret    

c010577c <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010577c:	55                   	push   %ebp
c010577d:	89 e5                	mov    %esp,%ebp
c010577f:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105782:	8b 45 08             	mov    0x8(%ebp),%eax
c0105785:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105788:	eb 21                	jmp    c01057ab <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c010578a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010578d:	0f b6 10             	movzbl (%eax),%edx
c0105790:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105793:	88 10                	mov    %dl,(%eax)
c0105795:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105798:	0f b6 00             	movzbl (%eax),%eax
c010579b:	84 c0                	test   %al,%al
c010579d:	74 04                	je     c01057a3 <strncpy+0x27>
            src ++;
c010579f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c01057a3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01057a7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c01057ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01057af:	75 d9                	jne    c010578a <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c01057b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01057b4:	c9                   	leave  
c01057b5:	c3                   	ret    

c01057b6 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01057b6:	55                   	push   %ebp
c01057b7:	89 e5                	mov    %esp,%ebp
c01057b9:	57                   	push   %edi
c01057ba:	56                   	push   %esi
c01057bb:	83 ec 20             	sub    $0x20,%esp
c01057be:	8b 45 08             	mov    0x8(%ebp),%eax
c01057c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01057c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c01057ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057d0:	89 d1                	mov    %edx,%ecx
c01057d2:	89 c2                	mov    %eax,%edx
c01057d4:	89 ce                	mov    %ecx,%esi
c01057d6:	89 d7                	mov    %edx,%edi
c01057d8:	ac                   	lods   %ds:(%esi),%al
c01057d9:	ae                   	scas   %es:(%edi),%al
c01057da:	75 08                	jne    c01057e4 <strcmp+0x2e>
c01057dc:	84 c0                	test   %al,%al
c01057de:	75 f8                	jne    c01057d8 <strcmp+0x22>
c01057e0:	31 c0                	xor    %eax,%eax
c01057e2:	eb 04                	jmp    c01057e8 <strcmp+0x32>
c01057e4:	19 c0                	sbb    %eax,%eax
c01057e6:	0c 01                	or     $0x1,%al
c01057e8:	89 fa                	mov    %edi,%edx
c01057ea:	89 f1                	mov    %esi,%ecx
c01057ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01057ef:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01057f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c01057f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01057f8:	83 c4 20             	add    $0x20,%esp
c01057fb:	5e                   	pop    %esi
c01057fc:	5f                   	pop    %edi
c01057fd:	5d                   	pop    %ebp
c01057fe:	c3                   	ret    

c01057ff <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01057ff:	55                   	push   %ebp
c0105800:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105802:	eb 0c                	jmp    c0105810 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105804:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105808:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010580c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105810:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105814:	74 1a                	je     c0105830 <strncmp+0x31>
c0105816:	8b 45 08             	mov    0x8(%ebp),%eax
c0105819:	0f b6 00             	movzbl (%eax),%eax
c010581c:	84 c0                	test   %al,%al
c010581e:	74 10                	je     c0105830 <strncmp+0x31>
c0105820:	8b 45 08             	mov    0x8(%ebp),%eax
c0105823:	0f b6 10             	movzbl (%eax),%edx
c0105826:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105829:	0f b6 00             	movzbl (%eax),%eax
c010582c:	38 c2                	cmp    %al,%dl
c010582e:	74 d4                	je     c0105804 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105830:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105834:	74 18                	je     c010584e <strncmp+0x4f>
c0105836:	8b 45 08             	mov    0x8(%ebp),%eax
c0105839:	0f b6 00             	movzbl (%eax),%eax
c010583c:	0f b6 d0             	movzbl %al,%edx
c010583f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105842:	0f b6 00             	movzbl (%eax),%eax
c0105845:	0f b6 c0             	movzbl %al,%eax
c0105848:	29 c2                	sub    %eax,%edx
c010584a:	89 d0                	mov    %edx,%eax
c010584c:	eb 05                	jmp    c0105853 <strncmp+0x54>
c010584e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105853:	5d                   	pop    %ebp
c0105854:	c3                   	ret    

c0105855 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105855:	55                   	push   %ebp
c0105856:	89 e5                	mov    %esp,%ebp
c0105858:	83 ec 04             	sub    $0x4,%esp
c010585b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010585e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105861:	eb 14                	jmp    c0105877 <strchr+0x22>
        if (*s == c) {
c0105863:	8b 45 08             	mov    0x8(%ebp),%eax
c0105866:	0f b6 00             	movzbl (%eax),%eax
c0105869:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010586c:	75 05                	jne    c0105873 <strchr+0x1e>
            return (char *)s;
c010586e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105871:	eb 13                	jmp    c0105886 <strchr+0x31>
        }
        s ++;
c0105873:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105877:	8b 45 08             	mov    0x8(%ebp),%eax
c010587a:	0f b6 00             	movzbl (%eax),%eax
c010587d:	84 c0                	test   %al,%al
c010587f:	75 e2                	jne    c0105863 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105881:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105886:	c9                   	leave  
c0105887:	c3                   	ret    

c0105888 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105888:	55                   	push   %ebp
c0105889:	89 e5                	mov    %esp,%ebp
c010588b:	83 ec 04             	sub    $0x4,%esp
c010588e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105891:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105894:	eb 11                	jmp    c01058a7 <strfind+0x1f>
        if (*s == c) {
c0105896:	8b 45 08             	mov    0x8(%ebp),%eax
c0105899:	0f b6 00             	movzbl (%eax),%eax
c010589c:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010589f:	75 02                	jne    c01058a3 <strfind+0x1b>
            break;
c01058a1:	eb 0e                	jmp    c01058b1 <strfind+0x29>
        }
        s ++;
c01058a3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c01058a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01058aa:	0f b6 00             	movzbl (%eax),%eax
c01058ad:	84 c0                	test   %al,%al
c01058af:	75 e5                	jne    c0105896 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c01058b1:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01058b4:	c9                   	leave  
c01058b5:	c3                   	ret    

c01058b6 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01058b6:	55                   	push   %ebp
c01058b7:	89 e5                	mov    %esp,%ebp
c01058b9:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01058bc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01058c3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01058ca:	eb 04                	jmp    c01058d0 <strtol+0x1a>
        s ++;
c01058cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01058d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01058d3:	0f b6 00             	movzbl (%eax),%eax
c01058d6:	3c 20                	cmp    $0x20,%al
c01058d8:	74 f2                	je     c01058cc <strtol+0x16>
c01058da:	8b 45 08             	mov    0x8(%ebp),%eax
c01058dd:	0f b6 00             	movzbl (%eax),%eax
c01058e0:	3c 09                	cmp    $0x9,%al
c01058e2:	74 e8                	je     c01058cc <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c01058e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01058e7:	0f b6 00             	movzbl (%eax),%eax
c01058ea:	3c 2b                	cmp    $0x2b,%al
c01058ec:	75 06                	jne    c01058f4 <strtol+0x3e>
        s ++;
c01058ee:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01058f2:	eb 15                	jmp    c0105909 <strtol+0x53>
    }
    else if (*s == '-') {
c01058f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01058f7:	0f b6 00             	movzbl (%eax),%eax
c01058fa:	3c 2d                	cmp    $0x2d,%al
c01058fc:	75 0b                	jne    c0105909 <strtol+0x53>
        s ++, neg = 1;
c01058fe:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105902:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105909:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010590d:	74 06                	je     c0105915 <strtol+0x5f>
c010590f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105913:	75 24                	jne    c0105939 <strtol+0x83>
c0105915:	8b 45 08             	mov    0x8(%ebp),%eax
c0105918:	0f b6 00             	movzbl (%eax),%eax
c010591b:	3c 30                	cmp    $0x30,%al
c010591d:	75 1a                	jne    c0105939 <strtol+0x83>
c010591f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105922:	83 c0 01             	add    $0x1,%eax
c0105925:	0f b6 00             	movzbl (%eax),%eax
c0105928:	3c 78                	cmp    $0x78,%al
c010592a:	75 0d                	jne    c0105939 <strtol+0x83>
        s += 2, base = 16;
c010592c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105930:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105937:	eb 2a                	jmp    c0105963 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105939:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010593d:	75 17                	jne    c0105956 <strtol+0xa0>
c010593f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105942:	0f b6 00             	movzbl (%eax),%eax
c0105945:	3c 30                	cmp    $0x30,%al
c0105947:	75 0d                	jne    c0105956 <strtol+0xa0>
        s ++, base = 8;
c0105949:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010594d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105954:	eb 0d                	jmp    c0105963 <strtol+0xad>
    }
    else if (base == 0) {
c0105956:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010595a:	75 07                	jne    c0105963 <strtol+0xad>
        base = 10;
c010595c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105963:	8b 45 08             	mov    0x8(%ebp),%eax
c0105966:	0f b6 00             	movzbl (%eax),%eax
c0105969:	3c 2f                	cmp    $0x2f,%al
c010596b:	7e 1b                	jle    c0105988 <strtol+0xd2>
c010596d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105970:	0f b6 00             	movzbl (%eax),%eax
c0105973:	3c 39                	cmp    $0x39,%al
c0105975:	7f 11                	jg     c0105988 <strtol+0xd2>
            dig = *s - '0';
c0105977:	8b 45 08             	mov    0x8(%ebp),%eax
c010597a:	0f b6 00             	movzbl (%eax),%eax
c010597d:	0f be c0             	movsbl %al,%eax
c0105980:	83 e8 30             	sub    $0x30,%eax
c0105983:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105986:	eb 48                	jmp    c01059d0 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105988:	8b 45 08             	mov    0x8(%ebp),%eax
c010598b:	0f b6 00             	movzbl (%eax),%eax
c010598e:	3c 60                	cmp    $0x60,%al
c0105990:	7e 1b                	jle    c01059ad <strtol+0xf7>
c0105992:	8b 45 08             	mov    0x8(%ebp),%eax
c0105995:	0f b6 00             	movzbl (%eax),%eax
c0105998:	3c 7a                	cmp    $0x7a,%al
c010599a:	7f 11                	jg     c01059ad <strtol+0xf7>
            dig = *s - 'a' + 10;
c010599c:	8b 45 08             	mov    0x8(%ebp),%eax
c010599f:	0f b6 00             	movzbl (%eax),%eax
c01059a2:	0f be c0             	movsbl %al,%eax
c01059a5:	83 e8 57             	sub    $0x57,%eax
c01059a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01059ab:	eb 23                	jmp    c01059d0 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c01059ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b0:	0f b6 00             	movzbl (%eax),%eax
c01059b3:	3c 40                	cmp    $0x40,%al
c01059b5:	7e 3d                	jle    c01059f4 <strtol+0x13e>
c01059b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01059ba:	0f b6 00             	movzbl (%eax),%eax
c01059bd:	3c 5a                	cmp    $0x5a,%al
c01059bf:	7f 33                	jg     c01059f4 <strtol+0x13e>
            dig = *s - 'A' + 10;
c01059c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01059c4:	0f b6 00             	movzbl (%eax),%eax
c01059c7:	0f be c0             	movsbl %al,%eax
c01059ca:	83 e8 37             	sub    $0x37,%eax
c01059cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01059d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059d3:	3b 45 10             	cmp    0x10(%ebp),%eax
c01059d6:	7c 02                	jl     c01059da <strtol+0x124>
            break;
c01059d8:	eb 1a                	jmp    c01059f4 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c01059da:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01059de:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01059e1:	0f af 45 10          	imul   0x10(%ebp),%eax
c01059e5:	89 c2                	mov    %eax,%edx
c01059e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059ea:	01 d0                	add    %edx,%eax
c01059ec:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c01059ef:	e9 6f ff ff ff       	jmp    c0105963 <strtol+0xad>

    if (endptr) {
c01059f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01059f8:	74 08                	je     c0105a02 <strtol+0x14c>
        *endptr = (char *) s;
c01059fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059fd:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a00:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105a02:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105a06:	74 07                	je     c0105a0f <strtol+0x159>
c0105a08:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105a0b:	f7 d8                	neg    %eax
c0105a0d:	eb 03                	jmp    c0105a12 <strtol+0x15c>
c0105a0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105a12:	c9                   	leave  
c0105a13:	c3                   	ret    

c0105a14 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105a14:	55                   	push   %ebp
c0105a15:	89 e5                	mov    %esp,%ebp
c0105a17:	57                   	push   %edi
c0105a18:	83 ec 24             	sub    $0x24,%esp
c0105a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a1e:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105a21:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105a25:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a28:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105a2b:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105a2e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a31:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105a34:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105a37:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105a3b:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105a3e:	89 d7                	mov    %edx,%edi
c0105a40:	f3 aa                	rep stos %al,%es:(%edi)
c0105a42:	89 fa                	mov    %edi,%edx
c0105a44:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105a47:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105a4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105a4d:	83 c4 24             	add    $0x24,%esp
c0105a50:	5f                   	pop    %edi
c0105a51:	5d                   	pop    %ebp
c0105a52:	c3                   	ret    

c0105a53 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105a53:	55                   	push   %ebp
c0105a54:	89 e5                	mov    %esp,%ebp
c0105a56:	57                   	push   %edi
c0105a57:	56                   	push   %esi
c0105a58:	53                   	push   %ebx
c0105a59:	83 ec 30             	sub    $0x30,%esp
c0105a5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a62:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a65:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a68:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a6b:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a71:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105a74:	73 42                	jae    c0105ab8 <memmove+0x65>
c0105a76:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a79:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105a7c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105a7f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105a82:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a85:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105a88:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105a8b:	c1 e8 02             	shr    $0x2,%eax
c0105a8e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105a90:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105a93:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105a96:	89 d7                	mov    %edx,%edi
c0105a98:	89 c6                	mov    %eax,%esi
c0105a9a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105a9c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105a9f:	83 e1 03             	and    $0x3,%ecx
c0105aa2:	74 02                	je     c0105aa6 <memmove+0x53>
c0105aa4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105aa6:	89 f0                	mov    %esi,%eax
c0105aa8:	89 fa                	mov    %edi,%edx
c0105aaa:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105aad:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105ab0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105ab3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ab6:	eb 36                	jmp    c0105aee <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105ab8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105abb:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105abe:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ac1:	01 c2                	add    %eax,%edx
c0105ac3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ac6:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105ac9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105acc:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105acf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105ad2:	89 c1                	mov    %eax,%ecx
c0105ad4:	89 d8                	mov    %ebx,%eax
c0105ad6:	89 d6                	mov    %edx,%esi
c0105ad8:	89 c7                	mov    %eax,%edi
c0105ada:	fd                   	std    
c0105adb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105add:	fc                   	cld    
c0105ade:	89 f8                	mov    %edi,%eax
c0105ae0:	89 f2                	mov    %esi,%edx
c0105ae2:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105ae5:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105ae8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105aee:	83 c4 30             	add    $0x30,%esp
c0105af1:	5b                   	pop    %ebx
c0105af2:	5e                   	pop    %esi
c0105af3:	5f                   	pop    %edi
c0105af4:	5d                   	pop    %ebp
c0105af5:	c3                   	ret    

c0105af6 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105af6:	55                   	push   %ebp
c0105af7:	89 e5                	mov    %esp,%ebp
c0105af9:	57                   	push   %edi
c0105afa:	56                   	push   %esi
c0105afb:	83 ec 20             	sub    $0x20,%esp
c0105afe:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b01:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b07:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b0a:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b0d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105b10:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105b13:	c1 e8 02             	shr    $0x2,%eax
c0105b16:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105b18:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b1e:	89 d7                	mov    %edx,%edi
c0105b20:	89 c6                	mov    %eax,%esi
c0105b22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105b24:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105b27:	83 e1 03             	and    $0x3,%ecx
c0105b2a:	74 02                	je     c0105b2e <memcpy+0x38>
c0105b2c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105b2e:	89 f0                	mov    %esi,%eax
c0105b30:	89 fa                	mov    %edi,%edx
c0105b32:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105b35:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105b38:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105b3e:	83 c4 20             	add    $0x20,%esp
c0105b41:	5e                   	pop    %esi
c0105b42:	5f                   	pop    %edi
c0105b43:	5d                   	pop    %ebp
c0105b44:	c3                   	ret    

c0105b45 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105b45:	55                   	push   %ebp
c0105b46:	89 e5                	mov    %esp,%ebp
c0105b48:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105b4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105b51:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b54:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105b57:	eb 30                	jmp    c0105b89 <memcmp+0x44>
        if (*s1 != *s2) {
c0105b59:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b5c:	0f b6 10             	movzbl (%eax),%edx
c0105b5f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105b62:	0f b6 00             	movzbl (%eax),%eax
c0105b65:	38 c2                	cmp    %al,%dl
c0105b67:	74 18                	je     c0105b81 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105b69:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b6c:	0f b6 00             	movzbl (%eax),%eax
c0105b6f:	0f b6 d0             	movzbl %al,%edx
c0105b72:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105b75:	0f b6 00             	movzbl (%eax),%eax
c0105b78:	0f b6 c0             	movzbl %al,%eax
c0105b7b:	29 c2                	sub    %eax,%edx
c0105b7d:	89 d0                	mov    %edx,%eax
c0105b7f:	eb 1a                	jmp    c0105b9b <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105b81:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105b85:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105b89:	8b 45 10             	mov    0x10(%ebp),%eax
c0105b8c:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105b8f:	89 55 10             	mov    %edx,0x10(%ebp)
c0105b92:	85 c0                	test   %eax,%eax
c0105b94:	75 c3                	jne    c0105b59 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105b96:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105b9b:	c9                   	leave  
c0105b9c:	c3                   	ret    
