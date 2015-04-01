
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 15 33 00 00       	call   103341 <memset>

    cons_init();                // init the console
  10002c:	e8 19 15 00 00       	call   10154a <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 e0 34 10 00 	movl   $0x1034e0,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 fc 34 10 00 	movl   $0x1034fc,(%esp)
  100046:	e8 c7 02 00 00       	call   100312 <cprintf>

    print_kerninfo();
  10004b:	e8 f6 07 00 00       	call   100846 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 2d 29 00 00       	call   102987 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 2e 16 00 00       	call   10168d <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 a6 17 00 00       	call   10180a <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 d4 0c 00 00       	call   100d3d <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 8d 15 00 00       	call   1015fb <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 dd 0b 00 00       	call   100c6f <mon_backtrace>
}
  100092:	c9                   	leave  
  100093:	c3                   	ret    

00100094 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100094:	55                   	push   %ebp
  100095:	89 e5                	mov    %esp,%ebp
  100097:	53                   	push   %ebx
  100098:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  10009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a1:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b3:	89 04 24             	mov    %eax,(%esp)
  1000b6:	e8 b5 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bb:	83 c4 14             	add    $0x14,%esp
  1000be:	5b                   	pop    %ebx
  1000bf:	5d                   	pop    %ebp
  1000c0:	c3                   	ret    

001000c1 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1000ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 04 24             	mov    %eax,(%esp)
  1000d4:	e8 bb ff ff ff       	call   100094 <grade_backtrace1>
}
  1000d9:	c9                   	leave  
  1000da:	c3                   	ret    

001000db <grade_backtrace>:

void
grade_backtrace(void) {
  1000db:	55                   	push   %ebp
  1000dc:	89 e5                	mov    %esp,%ebp
  1000de:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e1:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e6:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000ed:	ff 
  1000ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000f9:	e8 c3 ff ff ff       	call   1000c1 <grade_backtrace0>
}
  1000fe:	c9                   	leave  
  1000ff:	c3                   	ret    

00100100 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100100:	55                   	push   %ebp
  100101:	89 e5                	mov    %esp,%ebp
  100103:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100106:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100109:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10010f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100112:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100116:	0f b7 c0             	movzwl %ax,%eax
  100119:	83 e0 03             	and    $0x3,%eax
  10011c:	89 c2                	mov    %eax,%edx
  10011e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100123:	89 54 24 08          	mov    %edx,0x8(%esp)
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 01 35 10 00 	movl   $0x103501,(%esp)
  100132:	e8 db 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 0f 35 10 00 	movl   $0x10350f,(%esp)
  100152:	e8 bb 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 1d 35 10 00 	movl   $0x10351d,(%esp)
  100172:	e8 9b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 2b 35 10 00 	movl   $0x10352b,(%esp)
  100192:	e8 7b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 39 35 10 00 	movl   $0x103539,(%esp)
  1001b2:	e8 5b 01 00 00       	call   100312 <cprintf>
    round ++;
  1001b7:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001bc:	83 c0 01             	add    $0x1,%eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	c9                   	leave  
  1001c5:	c3                   	ret    

001001c6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c6:	55                   	push   %ebp
  1001c7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001c9:	5d                   	pop    %ebp
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ce:	5d                   	pop    %ebp
  1001cf:	c3                   	ret    

001001d0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
  1001d3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d6:	e8 25 ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001db:	c7 04 24 48 35 10 00 	movl   $0x103548,(%esp)
  1001e2:	e8 2b 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 68 35 10 00 	movl   $0x103568,(%esp)
  1001f8:	e8 15 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_kernel();
  1001fd:	e8 c9 ff ff ff       	call   1001cb <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100202:	e8 f9 fe ff ff       	call   100100 <lab1_print_cur_status>
}
  100207:	c9                   	leave  
  100208:	c3                   	ret    

00100209 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100209:	55                   	push   %ebp
  10020a:	89 e5                	mov    %esp,%ebp
  10020c:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10020f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100213:	74 13                	je     100228 <readline+0x1f>
        cprintf("%s", prompt);
  100215:	8b 45 08             	mov    0x8(%ebp),%eax
  100218:	89 44 24 04          	mov    %eax,0x4(%esp)
  10021c:	c7 04 24 87 35 10 00 	movl   $0x103587,(%esp)
  100223:	e8 ea 00 00 00       	call   100312 <cprintf>
    }
    int i = 0, c;
  100228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10022f:	e8 66 01 00 00       	call   10039a <getchar>
  100234:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10023b:	79 07                	jns    100244 <readline+0x3b>
            return NULL;
  10023d:	b8 00 00 00 00       	mov    $0x0,%eax
  100242:	eb 79                	jmp    1002bd <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100244:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100248:	7e 28                	jle    100272 <readline+0x69>
  10024a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100251:	7f 1f                	jg     100272 <readline+0x69>
            cputchar(c);
  100253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100256:	89 04 24             	mov    %eax,(%esp)
  100259:	e8 da 00 00 00       	call   100338 <cputchar>
            buf[i ++] = c;
  10025e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100261:	8d 50 01             	lea    0x1(%eax),%edx
  100264:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100267:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10026a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100270:	eb 46                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100272:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100276:	75 17                	jne    10028f <readline+0x86>
  100278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10027c:	7e 11                	jle    10028f <readline+0x86>
            cputchar(c);
  10027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100281:	89 04 24             	mov    %eax,(%esp)
  100284:	e8 af 00 00 00       	call   100338 <cputchar>
            i --;
  100289:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10028d:	eb 29                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10028f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100293:	74 06                	je     10029b <readline+0x92>
  100295:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100299:	75 1d                	jne    1002b8 <readline+0xaf>
            cputchar(c);
  10029b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029e:	89 04 24             	mov    %eax,(%esp)
  1002a1:	e8 92 00 00 00       	call   100338 <cputchar>
            buf[i] = '\0';
  1002a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002a9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002ae:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002b6:	eb 05                	jmp    1002bd <readline+0xb4>
        }
    }
  1002b8:	e9 72 ff ff ff       	jmp    10022f <readline+0x26>
}
  1002bd:	c9                   	leave  
  1002be:	c3                   	ret    

001002bf <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002bf:	55                   	push   %ebp
  1002c0:	89 e5                	mov    %esp,%ebp
  1002c2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 a6 12 00 00       	call   101576 <cons_putc>
    (*cnt) ++;
  1002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d3:	8b 00                	mov    (%eax),%eax
  1002d5:	8d 50 01             	lea    0x1(%eax),%edx
  1002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002db:	89 10                	mov    %edx,(%eax)
}
  1002dd:	c9                   	leave  
  1002de:	c3                   	ret    

001002df <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002df:	55                   	push   %ebp
  1002e0:	89 e5                	mov    %esp,%ebp
  1002e2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100301:	c7 04 24 bf 02 10 00 	movl   $0x1002bf,(%esp)
  100308:	e8 4d 28 00 00       	call   102b5a <vprintfmt>
    return cnt;
  10030d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100310:	c9                   	leave  
  100311:	c3                   	ret    

00100312 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100312:	55                   	push   %ebp
  100313:	89 e5                	mov    %esp,%ebp
  100315:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100318:	8d 45 0c             	lea    0xc(%ebp),%eax
  10031b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10031e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100321:	89 44 24 04          	mov    %eax,0x4(%esp)
  100325:	8b 45 08             	mov    0x8(%ebp),%eax
  100328:	89 04 24             	mov    %eax,(%esp)
  10032b:	e8 af ff ff ff       	call   1002df <vcprintf>
  100330:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100333:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100336:	c9                   	leave  
  100337:	c3                   	ret    

00100338 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100338:	55                   	push   %ebp
  100339:	89 e5                	mov    %esp,%ebp
  10033b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10033e:	8b 45 08             	mov    0x8(%ebp),%eax
  100341:	89 04 24             	mov    %eax,(%esp)
  100344:	e8 2d 12 00 00       	call   101576 <cons_putc>
}
  100349:	c9                   	leave  
  10034a:	c3                   	ret    

0010034b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100351:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100358:	eb 13                	jmp    10036d <cputs+0x22>
        cputch(c, &cnt);
  10035a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10035e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100361:	89 54 24 04          	mov    %edx,0x4(%esp)
  100365:	89 04 24             	mov    %eax,(%esp)
  100368:	e8 52 ff ff ff       	call   1002bf <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10036d:	8b 45 08             	mov    0x8(%ebp),%eax
  100370:	8d 50 01             	lea    0x1(%eax),%edx
  100373:	89 55 08             	mov    %edx,0x8(%ebp)
  100376:	0f b6 00             	movzbl (%eax),%eax
  100379:	88 45 f7             	mov    %al,-0x9(%ebp)
  10037c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100380:	75 d8                	jne    10035a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100382:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100385:	89 44 24 04          	mov    %eax,0x4(%esp)
  100389:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100390:	e8 2a ff ff ff       	call   1002bf <cputch>
    return cnt;
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100398:	c9                   	leave  
  100399:	c3                   	ret    

0010039a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10039a:	55                   	push   %ebp
  10039b:	89 e5                	mov    %esp,%ebp
  10039d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003a0:	e8 fa 11 00 00       	call   10159f <cons_getc>
  1003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ac:	74 f2                	je     1003a0 <getchar+0x6>
        /* do nothing */;
    return c;
  1003ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003bc:	8b 00                	mov    (%eax),%eax
  1003be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003c4:	8b 00                	mov    (%eax),%eax
  1003c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003d0:	e9 d2 00 00 00       	jmp    1004a7 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003db:	01 d0                	add    %edx,%eax
  1003dd:	89 c2                	mov    %eax,%edx
  1003df:	c1 ea 1f             	shr    $0x1f,%edx
  1003e2:	01 d0                	add    %edx,%eax
  1003e4:	d1 f8                	sar    %eax
  1003e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003ec:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ef:	eb 04                	jmp    1003f5 <stab_binsearch+0x42>
            m --;
  1003f1:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1003fb:	7c 1f                	jl     10041c <stab_binsearch+0x69>
  1003fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100400:	89 d0                	mov    %edx,%eax
  100402:	01 c0                	add    %eax,%eax
  100404:	01 d0                	add    %edx,%eax
  100406:	c1 e0 02             	shl    $0x2,%eax
  100409:	89 c2                	mov    %eax,%edx
  10040b:	8b 45 08             	mov    0x8(%ebp),%eax
  10040e:	01 d0                	add    %edx,%eax
  100410:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100414:	0f b6 c0             	movzbl %al,%eax
  100417:	3b 45 14             	cmp    0x14(%ebp),%eax
  10041a:	75 d5                	jne    1003f1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100422:	7d 0b                	jge    10042f <stab_binsearch+0x7c>
            l = true_m + 1;
  100424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100427:	83 c0 01             	add    $0x1,%eax
  10042a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10042d:	eb 78                	jmp    1004a7 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10042f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100439:	89 d0                	mov    %edx,%eax
  10043b:	01 c0                	add    %eax,%eax
  10043d:	01 d0                	add    %edx,%eax
  10043f:	c1 e0 02             	shl    $0x2,%eax
  100442:	89 c2                	mov    %eax,%edx
  100444:	8b 45 08             	mov    0x8(%ebp),%eax
  100447:	01 d0                	add    %edx,%eax
  100449:	8b 40 08             	mov    0x8(%eax),%eax
  10044c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10044f:	73 13                	jae    100464 <stab_binsearch+0xb1>
            *region_left = m;
  100451:	8b 45 0c             	mov    0xc(%ebp),%eax
  100454:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100457:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045c:	83 c0 01             	add    $0x1,%eax
  10045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100462:	eb 43                	jmp    1004a7 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100467:	89 d0                	mov    %edx,%eax
  100469:	01 c0                	add    %eax,%eax
  10046b:	01 d0                	add    %edx,%eax
  10046d:	c1 e0 02             	shl    $0x2,%eax
  100470:	89 c2                	mov    %eax,%edx
  100472:	8b 45 08             	mov    0x8(%ebp),%eax
  100475:	01 d0                	add    %edx,%eax
  100477:	8b 40 08             	mov    0x8(%eax),%eax
  10047a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10047d:	76 16                	jbe    100495 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10047f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100482:	8d 50 ff             	lea    -0x1(%eax),%edx
  100485:	8b 45 10             	mov    0x10(%ebp),%eax
  100488:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10048d:	83 e8 01             	sub    $0x1,%eax
  100490:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100493:	eb 12                	jmp    1004a7 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100495:	8b 45 0c             	mov    0xc(%ebp),%eax
  100498:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049b:	89 10                	mov    %edx,(%eax)
            l = m;
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a3:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004ad:	0f 8e 22 ff ff ff    	jle    1003d5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004b7:	75 0f                	jne    1004c8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bc:	8b 00                	mov    (%eax),%eax
  1004be:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c4:	89 10                	mov    %edx,(%eax)
  1004c6:	eb 3f                	jmp    100507 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004cb:	8b 00                	mov    (%eax),%eax
  1004cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004d0:	eb 04                	jmp    1004d6 <stab_binsearch+0x123>
  1004d2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d9:	8b 00                	mov    (%eax),%eax
  1004db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004de:	7d 1f                	jge    1004ff <stab_binsearch+0x14c>
  1004e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e3:	89 d0                	mov    %edx,%eax
  1004e5:	01 c0                	add    %eax,%eax
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	c1 e0 02             	shl    $0x2,%eax
  1004ec:	89 c2                	mov    %eax,%edx
  1004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f1:	01 d0                	add    %edx,%eax
  1004f3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f7:	0f b6 c0             	movzbl %al,%eax
  1004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004fd:	75 d3                	jne    1004d2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100505:	89 10                	mov    %edx,(%eax)
    }
}
  100507:	c9                   	leave  
  100508:	c3                   	ret    

00100509 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100509:	55                   	push   %ebp
  10050a:	89 e5                	mov    %esp,%ebp
  10050c:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100512:	c7 00 8c 35 10 00    	movl   $0x10358c,(%eax)
    info->eip_line = 0;
  100518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100522:	8b 45 0c             	mov    0xc(%ebp),%eax
  100525:	c7 40 08 8c 35 10 00 	movl   $0x10358c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100536:	8b 45 0c             	mov    0xc(%ebp),%eax
  100539:	8b 55 08             	mov    0x8(%ebp),%edx
  10053c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10053f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100542:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100549:	c7 45 f4 0c 3e 10 00 	movl   $0x103e0c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100550:	c7 45 f0 10 b5 10 00 	movl   $0x10b510,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100557:	c7 45 ec 11 b5 10 00 	movl   $0x10b511,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055e:	c7 45 e8 f1 d4 10 00 	movl   $0x10d4f1,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100568:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10056b:	76 0d                	jbe    10057a <debuginfo_eip+0x71>
  10056d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100570:	83 e8 01             	sub    $0x1,%eax
  100573:	0f b6 00             	movzbl (%eax),%eax
  100576:	84 c0                	test   %al,%al
  100578:	74 0a                	je     100584 <debuginfo_eip+0x7b>
        return -1;
  10057a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10057f:	e9 c0 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100584:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100591:	29 c2                	sub    %eax,%edx
  100593:	89 d0                	mov    %edx,%eax
  100595:	c1 f8 02             	sar    $0x2,%eax
  100598:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10059e:	83 e8 01             	sub    $0x1,%eax
  1005a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005ab:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005b2:	00 
  1005b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c4:	89 04 24             	mov    %eax,(%esp)
  1005c7:	e8 e7 fd ff ff       	call   1003b3 <stab_binsearch>
    if (lfile == 0)
  1005cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005cf:	85 c0                	test   %eax,%eax
  1005d1:	75 0a                	jne    1005dd <debuginfo_eip+0xd4>
        return -1;
  1005d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005d8:	e9 67 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f0:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1005f7:	00 
  1005f8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100602:	89 44 24 04          	mov    %eax,0x4(%esp)
  100606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100609:	89 04 24             	mov    %eax,(%esp)
  10060c:	e8 a2 fd ff ff       	call   1003b3 <stab_binsearch>

    if (lfun <= rfun) {
  100611:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100614:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100617:	39 c2                	cmp    %eax,%edx
  100619:	7f 7c                	jg     100697 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10061b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10061e:	89 c2                	mov    %eax,%edx
  100620:	89 d0                	mov    %edx,%eax
  100622:	01 c0                	add    %eax,%eax
  100624:	01 d0                	add    %edx,%eax
  100626:	c1 e0 02             	shl    $0x2,%eax
  100629:	89 c2                	mov    %eax,%edx
  10062b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10062e:	01 d0                	add    %edx,%eax
  100630:	8b 10                	mov    (%eax),%edx
  100632:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100638:	29 c1                	sub    %eax,%ecx
  10063a:	89 c8                	mov    %ecx,%eax
  10063c:	39 c2                	cmp    %eax,%edx
  10063e:	73 22                	jae    100662 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100643:	89 c2                	mov    %eax,%edx
  100645:	89 d0                	mov    %edx,%eax
  100647:	01 c0                	add    %eax,%eax
  100649:	01 d0                	add    %edx,%eax
  10064b:	c1 e0 02             	shl    $0x2,%eax
  10064e:	89 c2                	mov    %eax,%edx
  100650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100653:	01 d0                	add    %edx,%eax
  100655:	8b 10                	mov    (%eax),%edx
  100657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10065a:	01 c2                	add    %eax,%edx
  10065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100662:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100665:	89 c2                	mov    %eax,%edx
  100667:	89 d0                	mov    %edx,%eax
  100669:	01 c0                	add    %eax,%eax
  10066b:	01 d0                	add    %edx,%eax
  10066d:	c1 e0 02             	shl    $0x2,%eax
  100670:	89 c2                	mov    %eax,%edx
  100672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100675:	01 d0                	add    %edx,%eax
  100677:	8b 50 08             	mov    0x8(%eax),%edx
  10067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	8b 40 10             	mov    0x10(%eax),%eax
  100686:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100689:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10068f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100692:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100695:	eb 15                	jmp    1006ac <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100697:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069a:	8b 55 08             	mov    0x8(%ebp),%edx
  10069d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006af:	8b 40 08             	mov    0x8(%eax),%eax
  1006b2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006b9:	00 
  1006ba:	89 04 24             	mov    %eax,(%esp)
  1006bd:	e8 f3 2a 00 00       	call   1031b5 <strfind>
  1006c2:	89 c2                	mov    %eax,%edx
  1006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c7:	8b 40 08             	mov    0x8(%eax),%eax
  1006ca:	29 c2                	sub    %eax,%edx
  1006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cf:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006d9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e0:	00 
  1006e1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f2:	89 04 24             	mov    %eax,(%esp)
  1006f5:	e8 b9 fc ff ff       	call   1003b3 <stab_binsearch>
    if (lline <= rline) {
  1006fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100700:	39 c2                	cmp    %eax,%edx
  100702:	7f 24                	jg     100728 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100704:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100707:	89 c2                	mov    %eax,%edx
  100709:	89 d0                	mov    %edx,%eax
  10070b:	01 c0                	add    %eax,%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	c1 e0 02             	shl    $0x2,%eax
  100712:	89 c2                	mov    %eax,%edx
  100714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100717:	01 d0                	add    %edx,%eax
  100719:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10071d:	0f b7 d0             	movzwl %ax,%edx
  100720:	8b 45 0c             	mov    0xc(%ebp),%eax
  100723:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100726:	eb 13                	jmp    10073b <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10072d:	e9 12 01 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100735:	83 e8 01             	sub    $0x1,%eax
  100738:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10073e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100741:	39 c2                	cmp    %eax,%edx
  100743:	7c 56                	jl     10079b <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	89 d0                	mov    %edx,%eax
  10074c:	01 c0                	add    %eax,%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	c1 e0 02             	shl    $0x2,%eax
  100753:	89 c2                	mov    %eax,%edx
  100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100758:	01 d0                	add    %edx,%eax
  10075a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10075e:	3c 84                	cmp    $0x84,%al
  100760:	74 39                	je     10079b <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100762:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100765:	89 c2                	mov    %eax,%edx
  100767:	89 d0                	mov    %edx,%eax
  100769:	01 c0                	add    %eax,%eax
  10076b:	01 d0                	add    %edx,%eax
  10076d:	c1 e0 02             	shl    $0x2,%eax
  100770:	89 c2                	mov    %eax,%edx
  100772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077b:	3c 64                	cmp    $0x64,%al
  10077d:	75 b3                	jne    100732 <debuginfo_eip+0x229>
  10077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100782:	89 c2                	mov    %eax,%edx
  100784:	89 d0                	mov    %edx,%eax
  100786:	01 c0                	add    %eax,%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	c1 e0 02             	shl    $0x2,%eax
  10078d:	89 c2                	mov    %eax,%edx
  10078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100792:	01 d0                	add    %edx,%eax
  100794:	8b 40 08             	mov    0x8(%eax),%eax
  100797:	85 c0                	test   %eax,%eax
  100799:	74 97                	je     100732 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10079b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10079e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a1:	39 c2                	cmp    %eax,%edx
  1007a3:	7c 46                	jl     1007eb <debuginfo_eip+0x2e2>
  1007a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007a8:	89 c2                	mov    %eax,%edx
  1007aa:	89 d0                	mov    %edx,%eax
  1007ac:	01 c0                	add    %eax,%eax
  1007ae:	01 d0                	add    %edx,%eax
  1007b0:	c1 e0 02             	shl    $0x2,%eax
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	8b 10                	mov    (%eax),%edx
  1007bc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007c2:	29 c1                	sub    %eax,%ecx
  1007c4:	89 c8                	mov    %ecx,%eax
  1007c6:	39 c2                	cmp    %eax,%edx
  1007c8:	73 21                	jae    1007eb <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007cd:	89 c2                	mov    %eax,%edx
  1007cf:	89 d0                	mov    %edx,%eax
  1007d1:	01 c0                	add    %eax,%eax
  1007d3:	01 d0                	add    %edx,%eax
  1007d5:	c1 e0 02             	shl    $0x2,%eax
  1007d8:	89 c2                	mov    %eax,%edx
  1007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dd:	01 d0                	add    %edx,%eax
  1007df:	8b 10                	mov    (%eax),%edx
  1007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e4:	01 c2                	add    %eax,%edx
  1007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f1:	39 c2                	cmp    %eax,%edx
  1007f3:	7d 4a                	jge    10083f <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1007f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007f8:	83 c0 01             	add    $0x1,%eax
  1007fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007fe:	eb 18                	jmp    100818 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100800:	8b 45 0c             	mov    0xc(%ebp),%eax
  100803:	8b 40 14             	mov    0x14(%eax),%eax
  100806:	8d 50 01             	lea    0x1(%eax),%edx
  100809:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10080f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100812:	83 c0 01             	add    $0x1,%eax
  100815:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100818:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10081e:	39 c2                	cmp    %eax,%edx
  100820:	7d 1d                	jge    10083f <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100825:	89 c2                	mov    %eax,%edx
  100827:	89 d0                	mov    %edx,%eax
  100829:	01 c0                	add    %eax,%eax
  10082b:	01 d0                	add    %edx,%eax
  10082d:	c1 e0 02             	shl    $0x2,%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100835:	01 d0                	add    %edx,%eax
  100837:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10083b:	3c a0                	cmp    $0xa0,%al
  10083d:	74 c1                	je     100800 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10083f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100844:	c9                   	leave  
  100845:	c3                   	ret    

00100846 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100846:	55                   	push   %ebp
  100847:	89 e5                	mov    %esp,%ebp
  100849:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10084c:	c7 04 24 96 35 10 00 	movl   $0x103596,(%esp)
  100853:	e8 ba fa ff ff       	call   100312 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100858:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085f:	00 
  100860:	c7 04 24 af 35 10 00 	movl   $0x1035af,(%esp)
  100867:	e8 a6 fa ff ff       	call   100312 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10086c:	c7 44 24 04 ca 34 10 	movl   $0x1034ca,0x4(%esp)
  100873:	00 
  100874:	c7 04 24 c7 35 10 00 	movl   $0x1035c7,(%esp)
  10087b:	e8 92 fa ff ff       	call   100312 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100880:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100887:	00 
  100888:	c7 04 24 df 35 10 00 	movl   $0x1035df,(%esp)
  10088f:	e8 7e fa ff ff       	call   100312 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100894:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  10089b:	00 
  10089c:	c7 04 24 f7 35 10 00 	movl   $0x1035f7,(%esp)
  1008a3:	e8 6a fa ff ff       	call   100312 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008a8:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  1008ad:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008b3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008b8:	29 c2                	sub    %eax,%edx
  1008ba:	89 d0                	mov    %edx,%eax
  1008bc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c2:	85 c0                	test   %eax,%eax
  1008c4:	0f 48 c2             	cmovs  %edx,%eax
  1008c7:	c1 f8 0a             	sar    $0xa,%eax
  1008ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ce:	c7 04 24 10 36 10 00 	movl   $0x103610,(%esp)
  1008d5:	e8 38 fa ff ff       	call   100312 <cprintf>
}
  1008da:	c9                   	leave  
  1008db:	c3                   	ret    

001008dc <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008dc:	55                   	push   %ebp
  1008dd:	89 e5                	mov    %esp,%ebp
  1008df:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ef:	89 04 24             	mov    %eax,(%esp)
  1008f2:	e8 12 fc ff ff       	call   100509 <debuginfo_eip>
  1008f7:	85 c0                	test   %eax,%eax
  1008f9:	74 15                	je     100910 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1008fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100902:	c7 04 24 3a 36 10 00 	movl   $0x10363a,(%esp)
  100909:	e8 04 fa ff ff       	call   100312 <cprintf>
  10090e:	eb 6d                	jmp    10097d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100917:	eb 1c                	jmp    100935 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100919:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10091c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10091f:	01 d0                	add    %edx,%eax
  100921:	0f b6 00             	movzbl (%eax),%eax
  100924:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10092a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10092d:	01 ca                	add    %ecx,%edx
  10092f:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100931:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100938:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10093b:	7f dc                	jg     100919 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10093d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10094b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10094e:	8b 55 08             	mov    0x8(%ebp),%edx
  100951:	89 d1                	mov    %edx,%ecx
  100953:	29 c1                	sub    %eax,%ecx
  100955:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100958:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10095b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10095f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100965:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100969:	89 54 24 08          	mov    %edx,0x8(%esp)
  10096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100971:	c7 04 24 56 36 10 00 	movl   $0x103656,(%esp)
  100978:	e8 95 f9 ff ff       	call   100312 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10097d:	c9                   	leave  
  10097e:	c3                   	ret    

0010097f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10097f:	55                   	push   %ebp
  100980:	89 e5                	mov    %esp,%ebp
  100982:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100985:	8b 45 04             	mov    0x4(%ebp),%eax
  100988:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10098b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10098e:	c9                   	leave  
  10098f:	c3                   	ret    

00100990 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100990:	55                   	push   %ebp
  100991:	89 e5                	mov    %esp,%ebp
  100993:	53                   	push   %ebx
  100994:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100997:	89 e8                	mov    %ebp,%eax
  100999:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
  10099c:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp(),eip=read_eip(),i=0;
  10099f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1009a2:	e8 d8 ff ff ff       	call   10097f <read_eip>
  1009a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1009aa:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
    for(; i<STACKFRAME_DEPTH && ebp != 0; i++){
  1009b1:	eb 6f                	jmp    100a22 <print_stackframe+0x92>
        cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n", ebp, eip,
            ((uint32_t *)ebp)[2],((uint32_t *)ebp)[3],((uint32_t *)ebp)[4],((uint32_t *)ebp)[5]);
  1009b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009b6:	83 c0 14             	add    $0x14,%eax
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp(),eip=read_eip(),i=0;
    for(; i<STACKFRAME_DEPTH && ebp != 0; i++){
        cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n", ebp, eip,
  1009b9:	8b 18                	mov    (%eax),%ebx
            ((uint32_t *)ebp)[2],((uint32_t *)ebp)[3],((uint32_t *)ebp)[4],((uint32_t *)ebp)[5]);
  1009bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009be:	83 c0 10             	add    $0x10,%eax
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp(),eip=read_eip(),i=0;
    for(; i<STACKFRAME_DEPTH && ebp != 0; i++){
        cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n", ebp, eip,
  1009c1:	8b 08                	mov    (%eax),%ecx
            ((uint32_t *)ebp)[2],((uint32_t *)ebp)[3],((uint32_t *)ebp)[4],((uint32_t *)ebp)[5]);
  1009c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009c6:	83 c0 0c             	add    $0xc,%eax
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp(),eip=read_eip(),i=0;
    for(; i<STACKFRAME_DEPTH && ebp != 0; i++){
        cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n", ebp, eip,
  1009c9:	8b 10                	mov    (%eax),%edx
            ((uint32_t *)ebp)[2],((uint32_t *)ebp)[3],((uint32_t *)ebp)[4],((uint32_t *)ebp)[5]);
  1009cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ce:	83 c0 08             	add    $0x8,%eax
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp(),eip=read_eip(),i=0;
    for(; i<STACKFRAME_DEPTH && ebp != 0; i++){
        cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n", ebp, eip,
  1009d1:	8b 00                	mov    (%eax),%eax
  1009d3:	89 5c 24 18          	mov    %ebx,0x18(%esp)
  1009d7:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1009db:	89 54 24 10          	mov    %edx,0x10(%esp)
  1009df:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1009e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f1:	c7 04 24 68 36 10 00 	movl   $0x103668,(%esp)
  1009f8:	e8 15 f9 ff ff       	call   100312 <cprintf>
            ((uint32_t *)ebp)[2],((uint32_t *)ebp)[3],((uint32_t *)ebp)[4],((uint32_t *)ebp)[5]);
        print_debuginfo(eip - 1);
  1009fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a00:	83 e8 01             	sub    $0x1,%eax
  100a03:	89 04 24             	mov    %eax,(%esp)
  100a06:	e8 d1 fe ff ff       	call   1008dc <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a0e:	83 c0 04             	add    $0x4,%eax
  100a11:	8b 00                	mov    (%eax),%eax
  100a13:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100a16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a19:	8b 00                	mov    (%eax),%eax
  100a1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp(),eip=read_eip(),i=0;
    for(; i<STACKFRAME_DEPTH && ebp != 0; i++){
  100a1e:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a22:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a26:	77 06                	ja     100a2e <print_stackframe+0x9e>
  100a28:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a2c:	75 85                	jne    1009b3 <print_stackframe+0x23>
            ((uint32_t *)ebp)[2],((uint32_t *)ebp)[3],((uint32_t *)ebp)[4],((uint32_t *)ebp)[5]);
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
  100a2e:	83 c4 34             	add    $0x34,%esp
  100a31:	5b                   	pop    %ebx
  100a32:	5d                   	pop    %ebp
  100a33:	c3                   	ret    

00100a34 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a34:	55                   	push   %ebp
  100a35:	89 e5                	mov    %esp,%ebp
  100a37:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a3a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a41:	eb 0c                	jmp    100a4f <parse+0x1b>
            *buf ++ = '\0';
  100a43:	8b 45 08             	mov    0x8(%ebp),%eax
  100a46:	8d 50 01             	lea    0x1(%eax),%edx
  100a49:	89 55 08             	mov    %edx,0x8(%ebp)
  100a4c:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a52:	0f b6 00             	movzbl (%eax),%eax
  100a55:	84 c0                	test   %al,%al
  100a57:	74 1d                	je     100a76 <parse+0x42>
  100a59:	8b 45 08             	mov    0x8(%ebp),%eax
  100a5c:	0f b6 00             	movzbl (%eax),%eax
  100a5f:	0f be c0             	movsbl %al,%eax
  100a62:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a66:	c7 04 24 20 37 10 00 	movl   $0x103720,(%esp)
  100a6d:	e8 10 27 00 00       	call   103182 <strchr>
  100a72:	85 c0                	test   %eax,%eax
  100a74:	75 cd                	jne    100a43 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a76:	8b 45 08             	mov    0x8(%ebp),%eax
  100a79:	0f b6 00             	movzbl (%eax),%eax
  100a7c:	84 c0                	test   %al,%al
  100a7e:	75 02                	jne    100a82 <parse+0x4e>
            break;
  100a80:	eb 67                	jmp    100ae9 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100a82:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100a86:	75 14                	jne    100a9c <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100a88:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100a8f:	00 
  100a90:	c7 04 24 25 37 10 00 	movl   $0x103725,(%esp)
  100a97:	e8 76 f8 ff ff       	call   100312 <cprintf>
        }
        argv[argc ++] = buf;
  100a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a9f:	8d 50 01             	lea    0x1(%eax),%edx
  100aa2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100aa5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100aac:	8b 45 0c             	mov    0xc(%ebp),%eax
  100aaf:	01 c2                	add    %eax,%edx
  100ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  100ab4:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ab6:	eb 04                	jmp    100abc <parse+0x88>
            buf ++;
  100ab8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100abc:	8b 45 08             	mov    0x8(%ebp),%eax
  100abf:	0f b6 00             	movzbl (%eax),%eax
  100ac2:	84 c0                	test   %al,%al
  100ac4:	74 1d                	je     100ae3 <parse+0xaf>
  100ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac9:	0f b6 00             	movzbl (%eax),%eax
  100acc:	0f be c0             	movsbl %al,%eax
  100acf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ad3:	c7 04 24 20 37 10 00 	movl   $0x103720,(%esp)
  100ada:	e8 a3 26 00 00       	call   103182 <strchr>
  100adf:	85 c0                	test   %eax,%eax
  100ae1:	74 d5                	je     100ab8 <parse+0x84>
            buf ++;
        }
    }
  100ae3:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ae4:	e9 66 ff ff ff       	jmp    100a4f <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100aec:	c9                   	leave  
  100aed:	c3                   	ret    

00100aee <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100aee:	55                   	push   %ebp
  100aef:	89 e5                	mov    %esp,%ebp
  100af1:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100af4:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100af7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100afb:	8b 45 08             	mov    0x8(%ebp),%eax
  100afe:	89 04 24             	mov    %eax,(%esp)
  100b01:	e8 2e ff ff ff       	call   100a34 <parse>
  100b06:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b09:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b0d:	75 0a                	jne    100b19 <runcmd+0x2b>
        return 0;
  100b0f:	b8 00 00 00 00       	mov    $0x0,%eax
  100b14:	e9 85 00 00 00       	jmp    100b9e <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b19:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b20:	eb 5c                	jmp    100b7e <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b22:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b28:	89 d0                	mov    %edx,%eax
  100b2a:	01 c0                	add    %eax,%eax
  100b2c:	01 d0                	add    %edx,%eax
  100b2e:	c1 e0 02             	shl    $0x2,%eax
  100b31:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b36:	8b 00                	mov    (%eax),%eax
  100b38:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b3c:	89 04 24             	mov    %eax,(%esp)
  100b3f:	e8 9f 25 00 00       	call   1030e3 <strcmp>
  100b44:	85 c0                	test   %eax,%eax
  100b46:	75 32                	jne    100b7a <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b4b:	89 d0                	mov    %edx,%eax
  100b4d:	01 c0                	add    %eax,%eax
  100b4f:	01 d0                	add    %edx,%eax
  100b51:	c1 e0 02             	shl    $0x2,%eax
  100b54:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b59:	8b 40 08             	mov    0x8(%eax),%eax
  100b5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b5f:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b62:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b69:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b6c:	83 c2 04             	add    $0x4,%edx
  100b6f:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b73:	89 0c 24             	mov    %ecx,(%esp)
  100b76:	ff d0                	call   *%eax
  100b78:	eb 24                	jmp    100b9e <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b7a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b81:	83 f8 02             	cmp    $0x2,%eax
  100b84:	76 9c                	jbe    100b22 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100b86:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100b89:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b8d:	c7 04 24 43 37 10 00 	movl   $0x103743,(%esp)
  100b94:	e8 79 f7 ff ff       	call   100312 <cprintf>
    return 0;
  100b99:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100b9e:	c9                   	leave  
  100b9f:	c3                   	ret    

00100ba0 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100ba0:	55                   	push   %ebp
  100ba1:	89 e5                	mov    %esp,%ebp
  100ba3:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100ba6:	c7 04 24 5c 37 10 00 	movl   $0x10375c,(%esp)
  100bad:	e8 60 f7 ff ff       	call   100312 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bb2:	c7 04 24 84 37 10 00 	movl   $0x103784,(%esp)
  100bb9:	e8 54 f7 ff ff       	call   100312 <cprintf>

    if (tf != NULL) {
  100bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bc2:	74 0b                	je     100bcf <kmonitor+0x2f>
        print_trapframe(tf);
  100bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  100bc7:	89 04 24             	mov    %eax,(%esp)
  100bca:	e8 41 0e 00 00       	call   101a10 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bcf:	c7 04 24 a9 37 10 00 	movl   $0x1037a9,(%esp)
  100bd6:	e8 2e f6 ff ff       	call   100209 <readline>
  100bdb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100bde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100be2:	74 18                	je     100bfc <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100be4:	8b 45 08             	mov    0x8(%ebp),%eax
  100be7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100beb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bee:	89 04 24             	mov    %eax,(%esp)
  100bf1:	e8 f8 fe ff ff       	call   100aee <runcmd>
  100bf6:	85 c0                	test   %eax,%eax
  100bf8:	79 02                	jns    100bfc <kmonitor+0x5c>
                break;
  100bfa:	eb 02                	jmp    100bfe <kmonitor+0x5e>
            }
        }
    }
  100bfc:	eb d1                	jmp    100bcf <kmonitor+0x2f>
}
  100bfe:	c9                   	leave  
  100bff:	c3                   	ret    

00100c00 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c00:	55                   	push   %ebp
  100c01:	89 e5                	mov    %esp,%ebp
  100c03:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c06:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c0d:	eb 3f                	jmp    100c4e <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c0f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c12:	89 d0                	mov    %edx,%eax
  100c14:	01 c0                	add    %eax,%eax
  100c16:	01 d0                	add    %edx,%eax
  100c18:	c1 e0 02             	shl    $0x2,%eax
  100c1b:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c20:	8b 48 04             	mov    0x4(%eax),%ecx
  100c23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c26:	89 d0                	mov    %edx,%eax
  100c28:	01 c0                	add    %eax,%eax
  100c2a:	01 d0                	add    %edx,%eax
  100c2c:	c1 e0 02             	shl    $0x2,%eax
  100c2f:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c34:	8b 00                	mov    (%eax),%eax
  100c36:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c3e:	c7 04 24 ad 37 10 00 	movl   $0x1037ad,(%esp)
  100c45:	e8 c8 f6 ff ff       	call   100312 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c4a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c51:	83 f8 02             	cmp    $0x2,%eax
  100c54:	76 b9                	jbe    100c0f <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c5b:	c9                   	leave  
  100c5c:	c3                   	ret    

00100c5d <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c5d:	55                   	push   %ebp
  100c5e:	89 e5                	mov    %esp,%ebp
  100c60:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c63:	e8 de fb ff ff       	call   100846 <print_kerninfo>
    return 0;
  100c68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c6d:	c9                   	leave  
  100c6e:	c3                   	ret    

00100c6f <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c6f:	55                   	push   %ebp
  100c70:	89 e5                	mov    %esp,%ebp
  100c72:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c75:	e8 16 fd ff ff       	call   100990 <print_stackframe>
    return 0;
  100c7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c7f:	c9                   	leave  
  100c80:	c3                   	ret    

00100c81 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100c81:	55                   	push   %ebp
  100c82:	89 e5                	mov    %esp,%ebp
  100c84:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100c87:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100c8c:	85 c0                	test   %eax,%eax
  100c8e:	74 02                	je     100c92 <__panic+0x11>
        goto panic_dead;
  100c90:	eb 48                	jmp    100cda <__panic+0x59>
    }
    is_panic = 1;
  100c92:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100c99:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100c9c:	8d 45 14             	lea    0x14(%ebp),%eax
  100c9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100ca2:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ca5:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  100cac:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cb0:	c7 04 24 b6 37 10 00 	movl   $0x1037b6,(%esp)
  100cb7:	e8 56 f6 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100cbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cc3:	8b 45 10             	mov    0x10(%ebp),%eax
  100cc6:	89 04 24             	mov    %eax,(%esp)
  100cc9:	e8 11 f6 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100cce:	c7 04 24 d2 37 10 00 	movl   $0x1037d2,(%esp)
  100cd5:	e8 38 f6 ff ff       	call   100312 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100cda:	e8 22 09 00 00       	call   101601 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100cdf:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100ce6:	e8 b5 fe ff ff       	call   100ba0 <kmonitor>
    }
  100ceb:	eb f2                	jmp    100cdf <__panic+0x5e>

00100ced <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100ced:	55                   	push   %ebp
  100cee:	89 e5                	mov    %esp,%ebp
  100cf0:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100cf3:	8d 45 14             	lea    0x14(%ebp),%eax
  100cf6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100cf9:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cfc:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d00:	8b 45 08             	mov    0x8(%ebp),%eax
  100d03:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d07:	c7 04 24 d4 37 10 00 	movl   $0x1037d4,(%esp)
  100d0e:	e8 ff f5 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100d13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d16:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d1a:	8b 45 10             	mov    0x10(%ebp),%eax
  100d1d:	89 04 24             	mov    %eax,(%esp)
  100d20:	e8 ba f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100d25:	c7 04 24 d2 37 10 00 	movl   $0x1037d2,(%esp)
  100d2c:	e8 e1 f5 ff ff       	call   100312 <cprintf>
    va_end(ap);
}
  100d31:	c9                   	leave  
  100d32:	c3                   	ret    

00100d33 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d33:	55                   	push   %ebp
  100d34:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d36:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d3b:	5d                   	pop    %ebp
  100d3c:	c3                   	ret    

00100d3d <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d3d:	55                   	push   %ebp
  100d3e:	89 e5                	mov    %esp,%ebp
  100d40:	83 ec 28             	sub    $0x28,%esp
  100d43:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d49:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d4d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d51:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d55:	ee                   	out    %al,(%dx)
  100d56:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d5c:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d60:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d64:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d68:	ee                   	out    %al,(%dx)
  100d69:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d6f:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d73:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d77:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d7b:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d7c:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100d83:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d86:	c7 04 24 f2 37 10 00 	movl   $0x1037f2,(%esp)
  100d8d:	e8 80 f5 ff ff       	call   100312 <cprintf>
    pic_enable(IRQ_TIMER);
  100d92:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d99:	e8 c1 08 00 00       	call   10165f <pic_enable>
}
  100d9e:	c9                   	leave  
  100d9f:	c3                   	ret    

00100da0 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100da0:	55                   	push   %ebp
  100da1:	89 e5                	mov    %esp,%ebp
  100da3:	83 ec 10             	sub    $0x10,%esp
  100da6:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dac:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100db0:	89 c2                	mov    %eax,%edx
  100db2:	ec                   	in     (%dx),%al
  100db3:	88 45 fd             	mov    %al,-0x3(%ebp)
  100db6:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dbc:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dc0:	89 c2                	mov    %eax,%edx
  100dc2:	ec                   	in     (%dx),%al
  100dc3:	88 45 f9             	mov    %al,-0x7(%ebp)
  100dc6:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dcc:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100dd0:	89 c2                	mov    %eax,%edx
  100dd2:	ec                   	in     (%dx),%al
  100dd3:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dd6:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100ddc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100de0:	89 c2                	mov    %eax,%edx
  100de2:	ec                   	in     (%dx),%al
  100de3:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100de6:	c9                   	leave  
  100de7:	c3                   	ret    

00100de8 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100de8:	55                   	push   %ebp
  100de9:	89 e5                	mov    %esp,%ebp
  100deb:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100dee:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100df5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100df8:	0f b7 00             	movzwl (%eax),%eax
  100dfb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100dff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e02:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e0a:	0f b7 00             	movzwl (%eax),%eax
  100e0d:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e11:	74 12                	je     100e25 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e13:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e1a:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e21:	b4 03 
  100e23:	eb 13                	jmp    100e38 <cga_init+0x50>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e28:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e2c:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e2f:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e36:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e38:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e3f:	0f b7 c0             	movzwl %ax,%eax
  100e42:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e46:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e4a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e4e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e52:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e53:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e5a:	83 c0 01             	add    $0x1,%eax
  100e5d:	0f b7 c0             	movzwl %ax,%eax
  100e60:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e64:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e68:	89 c2                	mov    %eax,%edx
  100e6a:	ec                   	in     (%dx),%al
  100e6b:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e6e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e72:	0f b6 c0             	movzbl %al,%eax
  100e75:	c1 e0 08             	shl    $0x8,%eax
  100e78:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e7b:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e82:	0f b7 c0             	movzwl %ax,%eax
  100e85:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100e89:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e8d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e91:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e95:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100e96:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e9d:	83 c0 01             	add    $0x1,%eax
  100ea0:	0f b7 c0             	movzwl %ax,%eax
  100ea3:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ea7:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100eab:	89 c2                	mov    %eax,%edx
  100ead:	ec                   	in     (%dx),%al
  100eae:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100eb1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100eb5:	0f b6 c0             	movzbl %al,%eax
  100eb8:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100ebb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ebe:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ec6:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ecc:	c9                   	leave  
  100ecd:	c3                   	ret    

00100ece <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ece:	55                   	push   %ebp
  100ecf:	89 e5                	mov    %esp,%ebp
  100ed1:	83 ec 48             	sub    $0x48,%esp
  100ed4:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100eda:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ede:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100ee2:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100ee6:	ee                   	out    %al,(%dx)
  100ee7:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100eed:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100ef1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ef5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100ef9:	ee                   	out    %al,(%dx)
  100efa:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f00:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f04:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f08:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f0c:	ee                   	out    %al,(%dx)
  100f0d:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f13:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f17:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f1b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f1f:	ee                   	out    %al,(%dx)
  100f20:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f26:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f2a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f2e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f32:	ee                   	out    %al,(%dx)
  100f33:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f39:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f3d:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f41:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f45:	ee                   	out    %al,(%dx)
  100f46:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f4c:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f50:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f54:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f58:	ee                   	out    %al,(%dx)
  100f59:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f5f:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f63:	89 c2                	mov    %eax,%edx
  100f65:	ec                   	in     (%dx),%al
  100f66:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f69:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f6d:	3c ff                	cmp    $0xff,%al
  100f6f:	0f 95 c0             	setne  %al
  100f72:	0f b6 c0             	movzbl %al,%eax
  100f75:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f7a:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f80:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100f84:	89 c2                	mov    %eax,%edx
  100f86:	ec                   	in     (%dx),%al
  100f87:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100f8a:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100f90:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100f94:	89 c2                	mov    %eax,%edx
  100f96:	ec                   	in     (%dx),%al
  100f97:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100f9a:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100f9f:	85 c0                	test   %eax,%eax
  100fa1:	74 0c                	je     100faf <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fa3:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100faa:	e8 b0 06 00 00       	call   10165f <pic_enable>
    }
}
  100faf:	c9                   	leave  
  100fb0:	c3                   	ret    

00100fb1 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fb1:	55                   	push   %ebp
  100fb2:	89 e5                	mov    %esp,%ebp
  100fb4:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fb7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fbe:	eb 09                	jmp    100fc9 <lpt_putc_sub+0x18>
        delay();
  100fc0:	e8 db fd ff ff       	call   100da0 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fc5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100fc9:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fcf:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fd3:	89 c2                	mov    %eax,%edx
  100fd5:	ec                   	in     (%dx),%al
  100fd6:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fd9:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100fdd:	84 c0                	test   %al,%al
  100fdf:	78 09                	js     100fea <lpt_putc_sub+0x39>
  100fe1:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fe8:	7e d6                	jle    100fc0 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  100fea:	8b 45 08             	mov    0x8(%ebp),%eax
  100fed:	0f b6 c0             	movzbl %al,%eax
  100ff0:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  100ff6:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ff9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100ffd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101001:	ee                   	out    %al,(%dx)
  101002:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101008:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10100c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101010:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101014:	ee                   	out    %al,(%dx)
  101015:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  10101b:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  10101f:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101023:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101027:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101028:	c9                   	leave  
  101029:	c3                   	ret    

0010102a <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10102a:	55                   	push   %ebp
  10102b:	89 e5                	mov    %esp,%ebp
  10102d:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101030:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101034:	74 0d                	je     101043 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101036:	8b 45 08             	mov    0x8(%ebp),%eax
  101039:	89 04 24             	mov    %eax,(%esp)
  10103c:	e8 70 ff ff ff       	call   100fb1 <lpt_putc_sub>
  101041:	eb 24                	jmp    101067 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101043:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10104a:	e8 62 ff ff ff       	call   100fb1 <lpt_putc_sub>
        lpt_putc_sub(' ');
  10104f:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101056:	e8 56 ff ff ff       	call   100fb1 <lpt_putc_sub>
        lpt_putc_sub('\b');
  10105b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101062:	e8 4a ff ff ff       	call   100fb1 <lpt_putc_sub>
    }
}
  101067:	c9                   	leave  
  101068:	c3                   	ret    

00101069 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101069:	55                   	push   %ebp
  10106a:	89 e5                	mov    %esp,%ebp
  10106c:	53                   	push   %ebx
  10106d:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101070:	8b 45 08             	mov    0x8(%ebp),%eax
  101073:	b0 00                	mov    $0x0,%al
  101075:	85 c0                	test   %eax,%eax
  101077:	75 07                	jne    101080 <cga_putc+0x17>
        c |= 0x0700;
  101079:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101080:	8b 45 08             	mov    0x8(%ebp),%eax
  101083:	0f b6 c0             	movzbl %al,%eax
  101086:	83 f8 0a             	cmp    $0xa,%eax
  101089:	74 4c                	je     1010d7 <cga_putc+0x6e>
  10108b:	83 f8 0d             	cmp    $0xd,%eax
  10108e:	74 57                	je     1010e7 <cga_putc+0x7e>
  101090:	83 f8 08             	cmp    $0x8,%eax
  101093:	0f 85 88 00 00 00    	jne    101121 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101099:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010a0:	66 85 c0             	test   %ax,%ax
  1010a3:	74 30                	je     1010d5 <cga_putc+0x6c>
            crt_pos --;
  1010a5:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010ac:	83 e8 01             	sub    $0x1,%eax
  1010af:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010b5:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010ba:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010c1:	0f b7 d2             	movzwl %dx,%edx
  1010c4:	01 d2                	add    %edx,%edx
  1010c6:	01 c2                	add    %eax,%edx
  1010c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1010cb:	b0 00                	mov    $0x0,%al
  1010cd:	83 c8 20             	or     $0x20,%eax
  1010d0:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010d3:	eb 72                	jmp    101147 <cga_putc+0xde>
  1010d5:	eb 70                	jmp    101147 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  1010d7:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010de:	83 c0 50             	add    $0x50,%eax
  1010e1:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010e7:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  1010ee:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  1010f5:	0f b7 c1             	movzwl %cx,%eax
  1010f8:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1010fe:	c1 e8 10             	shr    $0x10,%eax
  101101:	89 c2                	mov    %eax,%edx
  101103:	66 c1 ea 06          	shr    $0x6,%dx
  101107:	89 d0                	mov    %edx,%eax
  101109:	c1 e0 02             	shl    $0x2,%eax
  10110c:	01 d0                	add    %edx,%eax
  10110e:	c1 e0 04             	shl    $0x4,%eax
  101111:	29 c1                	sub    %eax,%ecx
  101113:	89 ca                	mov    %ecx,%edx
  101115:	89 d8                	mov    %ebx,%eax
  101117:	29 d0                	sub    %edx,%eax
  101119:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10111f:	eb 26                	jmp    101147 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101121:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101127:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10112e:	8d 50 01             	lea    0x1(%eax),%edx
  101131:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101138:	0f b7 c0             	movzwl %ax,%eax
  10113b:	01 c0                	add    %eax,%eax
  10113d:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101140:	8b 45 08             	mov    0x8(%ebp),%eax
  101143:	66 89 02             	mov    %ax,(%edx)
        break;
  101146:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101147:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10114e:	66 3d cf 07          	cmp    $0x7cf,%ax
  101152:	76 5b                	jbe    1011af <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101154:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101159:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10115f:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101164:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10116b:	00 
  10116c:	89 54 24 04          	mov    %edx,0x4(%esp)
  101170:	89 04 24             	mov    %eax,(%esp)
  101173:	e8 08 22 00 00       	call   103380 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101178:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10117f:	eb 15                	jmp    101196 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  101181:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101186:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101189:	01 d2                	add    %edx,%edx
  10118b:	01 d0                	add    %edx,%eax
  10118d:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101192:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101196:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  10119d:	7e e2                	jle    101181 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10119f:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011a6:	83 e8 50             	sub    $0x50,%eax
  1011a9:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011af:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011b6:	0f b7 c0             	movzwl %ax,%eax
  1011b9:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011bd:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011c1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011c5:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011c9:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011ca:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011d1:	66 c1 e8 08          	shr    $0x8,%ax
  1011d5:	0f b6 c0             	movzbl %al,%eax
  1011d8:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011df:	83 c2 01             	add    $0x1,%edx
  1011e2:	0f b7 d2             	movzwl %dx,%edx
  1011e5:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  1011e9:	88 45 ed             	mov    %al,-0x13(%ebp)
  1011ec:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1011f0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1011f4:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1011f5:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011fc:	0f b7 c0             	movzwl %ax,%eax
  1011ff:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101203:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101207:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10120b:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10120f:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101210:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101217:	0f b6 c0             	movzbl %al,%eax
  10121a:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101221:	83 c2 01             	add    $0x1,%edx
  101224:	0f b7 d2             	movzwl %dx,%edx
  101227:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  10122b:	88 45 e5             	mov    %al,-0x1b(%ebp)
  10122e:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101232:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101236:	ee                   	out    %al,(%dx)
}
  101237:	83 c4 34             	add    $0x34,%esp
  10123a:	5b                   	pop    %ebx
  10123b:	5d                   	pop    %ebp
  10123c:	c3                   	ret    

0010123d <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10123d:	55                   	push   %ebp
  10123e:	89 e5                	mov    %esp,%ebp
  101240:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101243:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10124a:	eb 09                	jmp    101255 <serial_putc_sub+0x18>
        delay();
  10124c:	e8 4f fb ff ff       	call   100da0 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101251:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101255:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10125b:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10125f:	89 c2                	mov    %eax,%edx
  101261:	ec                   	in     (%dx),%al
  101262:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101265:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101269:	0f b6 c0             	movzbl %al,%eax
  10126c:	83 e0 20             	and    $0x20,%eax
  10126f:	85 c0                	test   %eax,%eax
  101271:	75 09                	jne    10127c <serial_putc_sub+0x3f>
  101273:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10127a:	7e d0                	jle    10124c <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  10127c:	8b 45 08             	mov    0x8(%ebp),%eax
  10127f:	0f b6 c0             	movzbl %al,%eax
  101282:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101288:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10128b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10128f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101293:	ee                   	out    %al,(%dx)
}
  101294:	c9                   	leave  
  101295:	c3                   	ret    

00101296 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101296:	55                   	push   %ebp
  101297:	89 e5                	mov    %esp,%ebp
  101299:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10129c:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012a0:	74 0d                	je     1012af <serial_putc+0x19>
        serial_putc_sub(c);
  1012a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1012a5:	89 04 24             	mov    %eax,(%esp)
  1012a8:	e8 90 ff ff ff       	call   10123d <serial_putc_sub>
  1012ad:	eb 24                	jmp    1012d3 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012af:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012b6:	e8 82 ff ff ff       	call   10123d <serial_putc_sub>
        serial_putc_sub(' ');
  1012bb:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012c2:	e8 76 ff ff ff       	call   10123d <serial_putc_sub>
        serial_putc_sub('\b');
  1012c7:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012ce:	e8 6a ff ff ff       	call   10123d <serial_putc_sub>
    }
}
  1012d3:	c9                   	leave  
  1012d4:	c3                   	ret    

001012d5 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012d5:	55                   	push   %ebp
  1012d6:	89 e5                	mov    %esp,%ebp
  1012d8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012db:	eb 33                	jmp    101310 <cons_intr+0x3b>
        if (c != 0) {
  1012dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012e1:	74 2d                	je     101310 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012e3:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012e8:	8d 50 01             	lea    0x1(%eax),%edx
  1012eb:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  1012f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012f4:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1012fa:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012ff:	3d 00 02 00 00       	cmp    $0x200,%eax
  101304:	75 0a                	jne    101310 <cons_intr+0x3b>
                cons.wpos = 0;
  101306:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10130d:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101310:	8b 45 08             	mov    0x8(%ebp),%eax
  101313:	ff d0                	call   *%eax
  101315:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101318:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10131c:	75 bf                	jne    1012dd <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  10131e:	c9                   	leave  
  10131f:	c3                   	ret    

00101320 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101320:	55                   	push   %ebp
  101321:	89 e5                	mov    %esp,%ebp
  101323:	83 ec 10             	sub    $0x10,%esp
  101326:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10132c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101330:	89 c2                	mov    %eax,%edx
  101332:	ec                   	in     (%dx),%al
  101333:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101336:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10133a:	0f b6 c0             	movzbl %al,%eax
  10133d:	83 e0 01             	and    $0x1,%eax
  101340:	85 c0                	test   %eax,%eax
  101342:	75 07                	jne    10134b <serial_proc_data+0x2b>
        return -1;
  101344:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101349:	eb 2a                	jmp    101375 <serial_proc_data+0x55>
  10134b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101351:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101355:	89 c2                	mov    %eax,%edx
  101357:	ec                   	in     (%dx),%al
  101358:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10135b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  10135f:	0f b6 c0             	movzbl %al,%eax
  101362:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101365:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101369:	75 07                	jne    101372 <serial_proc_data+0x52>
        c = '\b';
  10136b:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101372:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101375:	c9                   	leave  
  101376:	c3                   	ret    

00101377 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101377:	55                   	push   %ebp
  101378:	89 e5                	mov    %esp,%ebp
  10137a:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10137d:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101382:	85 c0                	test   %eax,%eax
  101384:	74 0c                	je     101392 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101386:	c7 04 24 20 13 10 00 	movl   $0x101320,(%esp)
  10138d:	e8 43 ff ff ff       	call   1012d5 <cons_intr>
    }
}
  101392:	c9                   	leave  
  101393:	c3                   	ret    

00101394 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101394:	55                   	push   %ebp
  101395:	89 e5                	mov    %esp,%ebp
  101397:	83 ec 38             	sub    $0x38,%esp
  10139a:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013a0:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013a4:	89 c2                	mov    %eax,%edx
  1013a6:	ec                   	in     (%dx),%al
  1013a7:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013aa:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013ae:	0f b6 c0             	movzbl %al,%eax
  1013b1:	83 e0 01             	and    $0x1,%eax
  1013b4:	85 c0                	test   %eax,%eax
  1013b6:	75 0a                	jne    1013c2 <kbd_proc_data+0x2e>
        return -1;
  1013b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013bd:	e9 59 01 00 00       	jmp    10151b <kbd_proc_data+0x187>
  1013c2:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013c8:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013cc:	89 c2                	mov    %eax,%edx
  1013ce:	ec                   	in     (%dx),%al
  1013cf:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013d2:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013d6:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013d9:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013dd:	75 17                	jne    1013f6 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  1013df:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013e4:	83 c8 40             	or     $0x40,%eax
  1013e7:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1013ec:	b8 00 00 00 00       	mov    $0x0,%eax
  1013f1:	e9 25 01 00 00       	jmp    10151b <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  1013f6:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1013fa:	84 c0                	test   %al,%al
  1013fc:	79 47                	jns    101445 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1013fe:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101403:	83 e0 40             	and    $0x40,%eax
  101406:	85 c0                	test   %eax,%eax
  101408:	75 09                	jne    101413 <kbd_proc_data+0x7f>
  10140a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10140e:	83 e0 7f             	and    $0x7f,%eax
  101411:	eb 04                	jmp    101417 <kbd_proc_data+0x83>
  101413:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101417:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10141a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10141e:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101425:	83 c8 40             	or     $0x40,%eax
  101428:	0f b6 c0             	movzbl %al,%eax
  10142b:	f7 d0                	not    %eax
  10142d:	89 c2                	mov    %eax,%edx
  10142f:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101434:	21 d0                	and    %edx,%eax
  101436:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  10143b:	b8 00 00 00 00       	mov    $0x0,%eax
  101440:	e9 d6 00 00 00       	jmp    10151b <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101445:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10144a:	83 e0 40             	and    $0x40,%eax
  10144d:	85 c0                	test   %eax,%eax
  10144f:	74 11                	je     101462 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101451:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101455:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10145a:	83 e0 bf             	and    $0xffffffbf,%eax
  10145d:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101462:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101466:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10146d:	0f b6 d0             	movzbl %al,%edx
  101470:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101475:	09 d0                	or     %edx,%eax
  101477:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  10147c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101480:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  101487:	0f b6 d0             	movzbl %al,%edx
  10148a:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10148f:	31 d0                	xor    %edx,%eax
  101491:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  101496:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10149b:	83 e0 03             	and    $0x3,%eax
  10149e:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014a5:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a9:	01 d0                	add    %edx,%eax
  1014ab:	0f b6 00             	movzbl (%eax),%eax
  1014ae:	0f b6 c0             	movzbl %al,%eax
  1014b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014b4:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b9:	83 e0 08             	and    $0x8,%eax
  1014bc:	85 c0                	test   %eax,%eax
  1014be:	74 22                	je     1014e2 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014c0:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014c4:	7e 0c                	jle    1014d2 <kbd_proc_data+0x13e>
  1014c6:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014ca:	7f 06                	jg     1014d2 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014cc:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014d0:	eb 10                	jmp    1014e2 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014d2:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014d6:	7e 0a                	jle    1014e2 <kbd_proc_data+0x14e>
  1014d8:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014dc:	7f 04                	jg     1014e2 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1014de:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014e2:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014e7:	f7 d0                	not    %eax
  1014e9:	83 e0 06             	and    $0x6,%eax
  1014ec:	85 c0                	test   %eax,%eax
  1014ee:	75 28                	jne    101518 <kbd_proc_data+0x184>
  1014f0:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1014f7:	75 1f                	jne    101518 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  1014f9:	c7 04 24 0d 38 10 00 	movl   $0x10380d,(%esp)
  101500:	e8 0d ee ff ff       	call   100312 <cprintf>
  101505:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10150b:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10150f:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101513:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101517:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101518:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10151b:	c9                   	leave  
  10151c:	c3                   	ret    

0010151d <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10151d:	55                   	push   %ebp
  10151e:	89 e5                	mov    %esp,%ebp
  101520:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101523:	c7 04 24 94 13 10 00 	movl   $0x101394,(%esp)
  10152a:	e8 a6 fd ff ff       	call   1012d5 <cons_intr>
}
  10152f:	c9                   	leave  
  101530:	c3                   	ret    

00101531 <kbd_init>:

static void
kbd_init(void) {
  101531:	55                   	push   %ebp
  101532:	89 e5                	mov    %esp,%ebp
  101534:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101537:	e8 e1 ff ff ff       	call   10151d <kbd_intr>
    pic_enable(IRQ_KBD);
  10153c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101543:	e8 17 01 00 00       	call   10165f <pic_enable>
}
  101548:	c9                   	leave  
  101549:	c3                   	ret    

0010154a <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10154a:	55                   	push   %ebp
  10154b:	89 e5                	mov    %esp,%ebp
  10154d:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101550:	e8 93 f8 ff ff       	call   100de8 <cga_init>
    serial_init();
  101555:	e8 74 f9 ff ff       	call   100ece <serial_init>
    kbd_init();
  10155a:	e8 d2 ff ff ff       	call   101531 <kbd_init>
    if (!serial_exists) {
  10155f:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101564:	85 c0                	test   %eax,%eax
  101566:	75 0c                	jne    101574 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101568:	c7 04 24 19 38 10 00 	movl   $0x103819,(%esp)
  10156f:	e8 9e ed ff ff       	call   100312 <cprintf>
    }
}
  101574:	c9                   	leave  
  101575:	c3                   	ret    

00101576 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101576:	55                   	push   %ebp
  101577:	89 e5                	mov    %esp,%ebp
  101579:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  10157c:	8b 45 08             	mov    0x8(%ebp),%eax
  10157f:	89 04 24             	mov    %eax,(%esp)
  101582:	e8 a3 fa ff ff       	call   10102a <lpt_putc>
    cga_putc(c);
  101587:	8b 45 08             	mov    0x8(%ebp),%eax
  10158a:	89 04 24             	mov    %eax,(%esp)
  10158d:	e8 d7 fa ff ff       	call   101069 <cga_putc>
    serial_putc(c);
  101592:	8b 45 08             	mov    0x8(%ebp),%eax
  101595:	89 04 24             	mov    %eax,(%esp)
  101598:	e8 f9 fc ff ff       	call   101296 <serial_putc>
}
  10159d:	c9                   	leave  
  10159e:	c3                   	ret    

0010159f <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10159f:	55                   	push   %ebp
  1015a0:	89 e5                	mov    %esp,%ebp
  1015a2:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015a5:	e8 cd fd ff ff       	call   101377 <serial_intr>
    kbd_intr();
  1015aa:	e8 6e ff ff ff       	call   10151d <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015af:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015b5:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015ba:	39 c2                	cmp    %eax,%edx
  1015bc:	74 36                	je     1015f4 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015be:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015c3:	8d 50 01             	lea    0x1(%eax),%edx
  1015c6:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015cc:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015d3:	0f b6 c0             	movzbl %al,%eax
  1015d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015d9:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015de:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015e3:	75 0a                	jne    1015ef <cons_getc+0x50>
            cons.rpos = 0;
  1015e5:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  1015ec:	00 00 00 
        }
        return c;
  1015ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1015f2:	eb 05                	jmp    1015f9 <cons_getc+0x5a>
    }
    return 0;
  1015f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1015f9:	c9                   	leave  
  1015fa:	c3                   	ret    

001015fb <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1015fb:	55                   	push   %ebp
  1015fc:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1015fe:	fb                   	sti    
    sti();
}
  1015ff:	5d                   	pop    %ebp
  101600:	c3                   	ret    

00101601 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101601:	55                   	push   %ebp
  101602:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101604:	fa                   	cli    
    cli();
}
  101605:	5d                   	pop    %ebp
  101606:	c3                   	ret    

00101607 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101607:	55                   	push   %ebp
  101608:	89 e5                	mov    %esp,%ebp
  10160a:	83 ec 14             	sub    $0x14,%esp
  10160d:	8b 45 08             	mov    0x8(%ebp),%eax
  101610:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101614:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101618:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  10161e:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101623:	85 c0                	test   %eax,%eax
  101625:	74 36                	je     10165d <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101627:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10162b:	0f b6 c0             	movzbl %al,%eax
  10162e:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101634:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101637:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10163b:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10163f:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101640:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101644:	66 c1 e8 08          	shr    $0x8,%ax
  101648:	0f b6 c0             	movzbl %al,%eax
  10164b:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101651:	88 45 f9             	mov    %al,-0x7(%ebp)
  101654:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101658:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10165c:	ee                   	out    %al,(%dx)
    }
}
  10165d:	c9                   	leave  
  10165e:	c3                   	ret    

0010165f <pic_enable>:

void
pic_enable(unsigned int irq) {
  10165f:	55                   	push   %ebp
  101660:	89 e5                	mov    %esp,%ebp
  101662:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101665:	8b 45 08             	mov    0x8(%ebp),%eax
  101668:	ba 01 00 00 00       	mov    $0x1,%edx
  10166d:	89 c1                	mov    %eax,%ecx
  10166f:	d3 e2                	shl    %cl,%edx
  101671:	89 d0                	mov    %edx,%eax
  101673:	f7 d0                	not    %eax
  101675:	89 c2                	mov    %eax,%edx
  101677:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  10167e:	21 d0                	and    %edx,%eax
  101680:	0f b7 c0             	movzwl %ax,%eax
  101683:	89 04 24             	mov    %eax,(%esp)
  101686:	e8 7c ff ff ff       	call   101607 <pic_setmask>
}
  10168b:	c9                   	leave  
  10168c:	c3                   	ret    

0010168d <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10168d:	55                   	push   %ebp
  10168e:	89 e5                	mov    %esp,%ebp
  101690:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101693:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  10169a:	00 00 00 
  10169d:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016a3:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016a7:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016ab:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016af:	ee                   	out    %al,(%dx)
  1016b0:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016b6:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016ba:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016be:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016c2:	ee                   	out    %al,(%dx)
  1016c3:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016c9:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016cd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016d1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016d5:	ee                   	out    %al,(%dx)
  1016d6:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1016dc:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  1016e0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1016e4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1016e8:	ee                   	out    %al,(%dx)
  1016e9:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  1016ef:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1016f3:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1016f7:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1016fb:	ee                   	out    %al,(%dx)
  1016fc:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101702:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101706:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10170a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10170e:	ee                   	out    %al,(%dx)
  10170f:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101715:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101719:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10171d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101721:	ee                   	out    %al,(%dx)
  101722:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101728:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  10172c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101730:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101734:	ee                   	out    %al,(%dx)
  101735:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  10173b:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10173f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101743:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101747:	ee                   	out    %al,(%dx)
  101748:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10174e:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101752:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101756:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10175a:	ee                   	out    %al,(%dx)
  10175b:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101761:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101765:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101769:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10176d:	ee                   	out    %al,(%dx)
  10176e:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101774:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101778:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10177c:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101780:	ee                   	out    %al,(%dx)
  101781:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101787:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10178b:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10178f:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101793:	ee                   	out    %al,(%dx)
  101794:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  10179a:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  10179e:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017a2:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017a6:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017a7:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017ae:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017b2:	74 12                	je     1017c6 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017b4:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017bb:	0f b7 c0             	movzwl %ax,%eax
  1017be:	89 04 24             	mov    %eax,(%esp)
  1017c1:	e8 41 fe ff ff       	call   101607 <pic_setmask>
    }
}
  1017c6:	c9                   	leave  
  1017c7:	c3                   	ret    

001017c8 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017c8:	55                   	push   %ebp
  1017c9:	89 e5                	mov    %esp,%ebp
  1017cb:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017ce:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017d5:	00 
  1017d6:	c7 04 24 40 38 10 00 	movl   $0x103840,(%esp)
  1017dd:	e8 30 eb ff ff       	call   100312 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1017e2:	c7 04 24 4a 38 10 00 	movl   $0x10384a,(%esp)
  1017e9:	e8 24 eb ff ff       	call   100312 <cprintf>
    panic("EOT: kernel seems ok.");
  1017ee:	c7 44 24 08 58 38 10 	movl   $0x103858,0x8(%esp)
  1017f5:	00 
  1017f6:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
  1017fd:	00 
  1017fe:	c7 04 24 6e 38 10 00 	movl   $0x10386e,(%esp)
  101805:	e8 77 f4 ff ff       	call   100c81 <__panic>

0010180a <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10180a:	55                   	push   %ebp
  10180b:	89 e5                	mov    %esp,%ebp
  10180d:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for(i=0; i < 256 ; i++){
  101810:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101817:	e9 91 01 00 00       	jmp    1019ad <idt_init+0x1a3>
        if(i != T_SWITCH_TOK){
  10181c:	83 7d fc 79          	cmpl   $0x79,-0x4(%ebp)
  101820:	0f 84 c4 00 00 00    	je     1018ea <idt_init+0xe0>
           SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL); 
  101826:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101829:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101830:	89 c2                	mov    %eax,%edx
  101832:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101835:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  10183c:	00 
  10183d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101840:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101847:	00 08 00 
  10184a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10184d:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101854:	00 
  101855:	83 e2 e0             	and    $0xffffffe0,%edx
  101858:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10185f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101862:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101869:	00 
  10186a:	83 e2 1f             	and    $0x1f,%edx
  10186d:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101874:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101877:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10187e:	00 
  10187f:	83 e2 f0             	and    $0xfffffff0,%edx
  101882:	83 ca 0e             	or     $0xe,%edx
  101885:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10188c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10188f:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101896:	00 
  101897:	83 e2 ef             	and    $0xffffffef,%edx
  10189a:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018a1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018a4:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018ab:	00 
  1018ac:	83 e2 9f             	and    $0xffffff9f,%edx
  1018af:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018b6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b9:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018c0:	00 
  1018c1:	83 ca 80             	or     $0xffffff80,%edx
  1018c4:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ce:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018d5:	c1 e8 10             	shr    $0x10,%eax
  1018d8:	89 c2                	mov    %eax,%edx
  1018da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018dd:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018e4:	00 
  1018e5:	e9 bf 00 00 00       	jmp    1019a9 <idt_init+0x19f>
        } else{
            SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_USER);
  1018ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ed:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018f4:	89 c2                	mov    %eax,%edx
  1018f6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f9:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101900:	00 
  101901:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101904:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  10190b:	00 08 00 
  10190e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101911:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101918:	00 
  101919:	83 e2 e0             	and    $0xffffffe0,%edx
  10191c:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101923:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101926:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10192d:	00 
  10192e:	83 e2 1f             	and    $0x1f,%edx
  101931:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101938:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193b:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101942:	00 
  101943:	83 e2 f0             	and    $0xfffffff0,%edx
  101946:	83 ca 0e             	or     $0xe,%edx
  101949:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101950:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101953:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10195a:	00 
  10195b:	83 e2 ef             	and    $0xffffffef,%edx
  10195e:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101965:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101968:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10196f:	00 
  101970:	83 ca 60             	or     $0x60,%edx
  101973:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10197a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10197d:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101984:	00 
  101985:	83 ca 80             	or     $0xffffff80,%edx
  101988:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10198f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101992:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101999:	c1 e8 10             	shr    $0x10,%eax
  10199c:	89 c2                	mov    %eax,%edx
  10199e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019a1:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1019a8:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for(i=0; i < 256 ; i++){
  1019a9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1019ad:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1019b4:	0f 8e 62 fe ff ff    	jle    10181c <idt_init+0x12>
  1019ba:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  1019c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019c4:	0f 01 18             	lidtl  (%eax)
            SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_USER);
        }

    }
    lidt(&idt_pd);
}
  1019c7:	c9                   	leave  
  1019c8:	c3                   	ret    

001019c9 <trapname>:

static const char *
trapname(int trapno) {
  1019c9:	55                   	push   %ebp
  1019ca:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1019cf:	83 f8 13             	cmp    $0x13,%eax
  1019d2:	77 0c                	ja     1019e0 <trapname+0x17>
        return excnames[trapno];
  1019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1019d7:	8b 04 85 c0 3b 10 00 	mov    0x103bc0(,%eax,4),%eax
  1019de:	eb 18                	jmp    1019f8 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019e0:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019e4:	7e 0d                	jle    1019f3 <trapname+0x2a>
  1019e6:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019ea:	7f 07                	jg     1019f3 <trapname+0x2a>
        return "Hardware Interrupt";
  1019ec:	b8 7f 38 10 00       	mov    $0x10387f,%eax
  1019f1:	eb 05                	jmp    1019f8 <trapname+0x2f>
    }
    return "(unknown trap)";
  1019f3:	b8 92 38 10 00       	mov    $0x103892,%eax
}
  1019f8:	5d                   	pop    %ebp
  1019f9:	c3                   	ret    

001019fa <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019fa:	55                   	push   %ebp
  1019fb:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019fd:	8b 45 08             	mov    0x8(%ebp),%eax
  101a00:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a04:	66 83 f8 08          	cmp    $0x8,%ax
  101a08:	0f 94 c0             	sete   %al
  101a0b:	0f b6 c0             	movzbl %al,%eax
}
  101a0e:	5d                   	pop    %ebp
  101a0f:	c3                   	ret    

00101a10 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a10:	55                   	push   %ebp
  101a11:	89 e5                	mov    %esp,%ebp
  101a13:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a16:	8b 45 08             	mov    0x8(%ebp),%eax
  101a19:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a1d:	c7 04 24 d3 38 10 00 	movl   $0x1038d3,(%esp)
  101a24:	e8 e9 e8 ff ff       	call   100312 <cprintf>
    print_regs(&tf->tf_regs);
  101a29:	8b 45 08             	mov    0x8(%ebp),%eax
  101a2c:	89 04 24             	mov    %eax,(%esp)
  101a2f:	e8 a1 01 00 00       	call   101bd5 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a34:	8b 45 08             	mov    0x8(%ebp),%eax
  101a37:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a3b:	0f b7 c0             	movzwl %ax,%eax
  101a3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a42:	c7 04 24 e4 38 10 00 	movl   $0x1038e4,(%esp)
  101a49:	e8 c4 e8 ff ff       	call   100312 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a51:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a55:	0f b7 c0             	movzwl %ax,%eax
  101a58:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a5c:	c7 04 24 f7 38 10 00 	movl   $0x1038f7,(%esp)
  101a63:	e8 aa e8 ff ff       	call   100312 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a68:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6b:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a6f:	0f b7 c0             	movzwl %ax,%eax
  101a72:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a76:	c7 04 24 0a 39 10 00 	movl   $0x10390a,(%esp)
  101a7d:	e8 90 e8 ff ff       	call   100312 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a82:	8b 45 08             	mov    0x8(%ebp),%eax
  101a85:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a89:	0f b7 c0             	movzwl %ax,%eax
  101a8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a90:	c7 04 24 1d 39 10 00 	movl   $0x10391d,(%esp)
  101a97:	e8 76 e8 ff ff       	call   100312 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9f:	8b 40 30             	mov    0x30(%eax),%eax
  101aa2:	89 04 24             	mov    %eax,(%esp)
  101aa5:	e8 1f ff ff ff       	call   1019c9 <trapname>
  101aaa:	8b 55 08             	mov    0x8(%ebp),%edx
  101aad:	8b 52 30             	mov    0x30(%edx),%edx
  101ab0:	89 44 24 08          	mov    %eax,0x8(%esp)
  101ab4:	89 54 24 04          	mov    %edx,0x4(%esp)
  101ab8:	c7 04 24 30 39 10 00 	movl   $0x103930,(%esp)
  101abf:	e8 4e e8 ff ff       	call   100312 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac7:	8b 40 34             	mov    0x34(%eax),%eax
  101aca:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ace:	c7 04 24 42 39 10 00 	movl   $0x103942,(%esp)
  101ad5:	e8 38 e8 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ada:	8b 45 08             	mov    0x8(%ebp),%eax
  101add:	8b 40 38             	mov    0x38(%eax),%eax
  101ae0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae4:	c7 04 24 51 39 10 00 	movl   $0x103951,(%esp)
  101aeb:	e8 22 e8 ff ff       	call   100312 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101af0:	8b 45 08             	mov    0x8(%ebp),%eax
  101af3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101af7:	0f b7 c0             	movzwl %ax,%eax
  101afa:	89 44 24 04          	mov    %eax,0x4(%esp)
  101afe:	c7 04 24 60 39 10 00 	movl   $0x103960,(%esp)
  101b05:	e8 08 e8 ff ff       	call   100312 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0d:	8b 40 40             	mov    0x40(%eax),%eax
  101b10:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b14:	c7 04 24 73 39 10 00 	movl   $0x103973,(%esp)
  101b1b:	e8 f2 e7 ff ff       	call   100312 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b20:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b27:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b2e:	eb 3e                	jmp    101b6e <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b30:	8b 45 08             	mov    0x8(%ebp),%eax
  101b33:	8b 50 40             	mov    0x40(%eax),%edx
  101b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b39:	21 d0                	and    %edx,%eax
  101b3b:	85 c0                	test   %eax,%eax
  101b3d:	74 28                	je     101b67 <print_trapframe+0x157>
  101b3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b42:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b49:	85 c0                	test   %eax,%eax
  101b4b:	74 1a                	je     101b67 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b50:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5b:	c7 04 24 82 39 10 00 	movl   $0x103982,(%esp)
  101b62:	e8 ab e7 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b67:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b6b:	d1 65 f0             	shll   -0x10(%ebp)
  101b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b71:	83 f8 17             	cmp    $0x17,%eax
  101b74:	76 ba                	jbe    101b30 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b76:	8b 45 08             	mov    0x8(%ebp),%eax
  101b79:	8b 40 40             	mov    0x40(%eax),%eax
  101b7c:	25 00 30 00 00       	and    $0x3000,%eax
  101b81:	c1 e8 0c             	shr    $0xc,%eax
  101b84:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b88:	c7 04 24 86 39 10 00 	movl   $0x103986,(%esp)
  101b8f:	e8 7e e7 ff ff       	call   100312 <cprintf>

    if (!trap_in_kernel(tf)) {
  101b94:	8b 45 08             	mov    0x8(%ebp),%eax
  101b97:	89 04 24             	mov    %eax,(%esp)
  101b9a:	e8 5b fe ff ff       	call   1019fa <trap_in_kernel>
  101b9f:	85 c0                	test   %eax,%eax
  101ba1:	75 30                	jne    101bd3 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba6:	8b 40 44             	mov    0x44(%eax),%eax
  101ba9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bad:	c7 04 24 8f 39 10 00 	movl   $0x10398f,(%esp)
  101bb4:	e8 59 e7 ff ff       	call   100312 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbc:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bc0:	0f b7 c0             	movzwl %ax,%eax
  101bc3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc7:	c7 04 24 9e 39 10 00 	movl   $0x10399e,(%esp)
  101bce:	e8 3f e7 ff ff       	call   100312 <cprintf>
    }
}
  101bd3:	c9                   	leave  
  101bd4:	c3                   	ret    

00101bd5 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101bd5:	55                   	push   %ebp
  101bd6:	89 e5                	mov    %esp,%ebp
  101bd8:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bde:	8b 00                	mov    (%eax),%eax
  101be0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be4:	c7 04 24 b1 39 10 00 	movl   $0x1039b1,(%esp)
  101beb:	e8 22 e7 ff ff       	call   100312 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf3:	8b 40 04             	mov    0x4(%eax),%eax
  101bf6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfa:	c7 04 24 c0 39 10 00 	movl   $0x1039c0,(%esp)
  101c01:	e8 0c e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c06:	8b 45 08             	mov    0x8(%ebp),%eax
  101c09:	8b 40 08             	mov    0x8(%eax),%eax
  101c0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c10:	c7 04 24 cf 39 10 00 	movl   $0x1039cf,(%esp)
  101c17:	e8 f6 e6 ff ff       	call   100312 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1f:	8b 40 0c             	mov    0xc(%eax),%eax
  101c22:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c26:	c7 04 24 de 39 10 00 	movl   $0x1039de,(%esp)
  101c2d:	e8 e0 e6 ff ff       	call   100312 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c32:	8b 45 08             	mov    0x8(%ebp),%eax
  101c35:	8b 40 10             	mov    0x10(%eax),%eax
  101c38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3c:	c7 04 24 ed 39 10 00 	movl   $0x1039ed,(%esp)
  101c43:	e8 ca e6 ff ff       	call   100312 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c48:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4b:	8b 40 14             	mov    0x14(%eax),%eax
  101c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c52:	c7 04 24 fc 39 10 00 	movl   $0x1039fc,(%esp)
  101c59:	e8 b4 e6 ff ff       	call   100312 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c61:	8b 40 18             	mov    0x18(%eax),%eax
  101c64:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c68:	c7 04 24 0b 3a 10 00 	movl   $0x103a0b,(%esp)
  101c6f:	e8 9e e6 ff ff       	call   100312 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c74:	8b 45 08             	mov    0x8(%ebp),%eax
  101c77:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c7e:	c7 04 24 1a 3a 10 00 	movl   $0x103a1a,(%esp)
  101c85:	e8 88 e6 ff ff       	call   100312 <cprintf>
}
  101c8a:	c9                   	leave  
  101c8b:	c3                   	ret    

00101c8c <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c8c:	55                   	push   %ebp
  101c8d:	89 e5                	mov    %esp,%ebp
  101c8f:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c92:	8b 45 08             	mov    0x8(%ebp),%eax
  101c95:	8b 40 30             	mov    0x30(%eax),%eax
  101c98:	83 f8 2f             	cmp    $0x2f,%eax
  101c9b:	77 21                	ja     101cbe <trap_dispatch+0x32>
  101c9d:	83 f8 2e             	cmp    $0x2e,%eax
  101ca0:	0f 83 04 01 00 00    	jae    101daa <trap_dispatch+0x11e>
  101ca6:	83 f8 21             	cmp    $0x21,%eax
  101ca9:	0f 84 81 00 00 00    	je     101d30 <trap_dispatch+0xa4>
  101caf:	83 f8 24             	cmp    $0x24,%eax
  101cb2:	74 56                	je     101d0a <trap_dispatch+0x7e>
  101cb4:	83 f8 20             	cmp    $0x20,%eax
  101cb7:	74 16                	je     101ccf <trap_dispatch+0x43>
  101cb9:	e9 b4 00 00 00       	jmp    101d72 <trap_dispatch+0xe6>
  101cbe:	83 e8 78             	sub    $0x78,%eax
  101cc1:	83 f8 01             	cmp    $0x1,%eax
  101cc4:	0f 87 a8 00 00 00    	ja     101d72 <trap_dispatch+0xe6>
  101cca:	e9 87 00 00 00       	jmp    101d56 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101ccf:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101cd4:	83 c0 01             	add    $0x1,%eax
  101cd7:	a3 08 f9 10 00       	mov    %eax,0x10f908
        if (ticks % TICK_NUM == 0) {
  101cdc:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101ce2:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101ce7:	89 c8                	mov    %ecx,%eax
  101ce9:	f7 e2                	mul    %edx
  101ceb:	89 d0                	mov    %edx,%eax
  101ced:	c1 e8 05             	shr    $0x5,%eax
  101cf0:	6b c0 64             	imul   $0x64,%eax,%eax
  101cf3:	29 c1                	sub    %eax,%ecx
  101cf5:	89 c8                	mov    %ecx,%eax
  101cf7:	85 c0                	test   %eax,%eax
  101cf9:	75 0a                	jne    101d05 <trap_dispatch+0x79>
            print_ticks();
  101cfb:	e8 c8 fa ff ff       	call   1017c8 <print_ticks>
        }
        break;
  101d00:	e9 a6 00 00 00       	jmp    101dab <trap_dispatch+0x11f>
  101d05:	e9 a1 00 00 00       	jmp    101dab <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d0a:	e8 90 f8 ff ff       	call   10159f <cons_getc>
  101d0f:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d12:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d16:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d1a:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d22:	c7 04 24 29 3a 10 00 	movl   $0x103a29,(%esp)
  101d29:	e8 e4 e5 ff ff       	call   100312 <cprintf>
        break;
  101d2e:	eb 7b                	jmp    101dab <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d30:	e8 6a f8 ff ff       	call   10159f <cons_getc>
  101d35:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d38:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d3c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d40:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d44:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d48:	c7 04 24 3b 3a 10 00 	movl   $0x103a3b,(%esp)
  101d4f:	e8 be e5 ff ff       	call   100312 <cprintf>
        break;
  101d54:	eb 55                	jmp    101dab <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d56:	c7 44 24 08 4a 3a 10 	movl   $0x103a4a,0x8(%esp)
  101d5d:	00 
  101d5e:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
  101d65:	00 
  101d66:	c7 04 24 6e 38 10 00 	movl   $0x10386e,(%esp)
  101d6d:	e8 0f ef ff ff       	call   100c81 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d72:	8b 45 08             	mov    0x8(%ebp),%eax
  101d75:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d79:	0f b7 c0             	movzwl %ax,%eax
  101d7c:	83 e0 03             	and    $0x3,%eax
  101d7f:	85 c0                	test   %eax,%eax
  101d81:	75 28                	jne    101dab <trap_dispatch+0x11f>
            print_trapframe(tf);
  101d83:	8b 45 08             	mov    0x8(%ebp),%eax
  101d86:	89 04 24             	mov    %eax,(%esp)
  101d89:	e8 82 fc ff ff       	call   101a10 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d8e:	c7 44 24 08 5a 3a 10 	movl   $0x103a5a,0x8(%esp)
  101d95:	00 
  101d96:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  101d9d:	00 
  101d9e:	c7 04 24 6e 38 10 00 	movl   $0x10386e,(%esp)
  101da5:	e8 d7 ee ff ff       	call   100c81 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101daa:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101dab:	c9                   	leave  
  101dac:	c3                   	ret    

00101dad <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101dad:	55                   	push   %ebp
  101dae:	89 e5                	mov    %esp,%ebp
  101db0:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101db3:	8b 45 08             	mov    0x8(%ebp),%eax
  101db6:	89 04 24             	mov    %eax,(%esp)
  101db9:	e8 ce fe ff ff       	call   101c8c <trap_dispatch>
}
  101dbe:	c9                   	leave  
  101dbf:	c3                   	ret    

00101dc0 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101dc0:	1e                   	push   %ds
    pushl %es
  101dc1:	06                   	push   %es
    pushl %fs
  101dc2:	0f a0                	push   %fs
    pushl %gs
  101dc4:	0f a8                	push   %gs
    pushal
  101dc6:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101dc7:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101dcc:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101dce:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101dd0:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101dd1:	e8 d7 ff ff ff       	call   101dad <trap>

    # pop the pushed stack pointer
    popl %esp
  101dd6:	5c                   	pop    %esp

00101dd7 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101dd7:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101dd8:	0f a9                	pop    %gs
    popl %fs
  101dda:	0f a1                	pop    %fs
    popl %es
  101ddc:	07                   	pop    %es
    popl %ds
  101ddd:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101dde:	83 c4 08             	add    $0x8,%esp
    iret
  101de1:	cf                   	iret   

00101de2 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101de2:	6a 00                	push   $0x0
  pushl $0
  101de4:	6a 00                	push   $0x0
  jmp __alltraps
  101de6:	e9 d5 ff ff ff       	jmp    101dc0 <__alltraps>

00101deb <vector1>:
.globl vector1
vector1:
  pushl $0
  101deb:	6a 00                	push   $0x0
  pushl $1
  101ded:	6a 01                	push   $0x1
  jmp __alltraps
  101def:	e9 cc ff ff ff       	jmp    101dc0 <__alltraps>

00101df4 <vector2>:
.globl vector2
vector2:
  pushl $0
  101df4:	6a 00                	push   $0x0
  pushl $2
  101df6:	6a 02                	push   $0x2
  jmp __alltraps
  101df8:	e9 c3 ff ff ff       	jmp    101dc0 <__alltraps>

00101dfd <vector3>:
.globl vector3
vector3:
  pushl $0
  101dfd:	6a 00                	push   $0x0
  pushl $3
  101dff:	6a 03                	push   $0x3
  jmp __alltraps
  101e01:	e9 ba ff ff ff       	jmp    101dc0 <__alltraps>

00101e06 <vector4>:
.globl vector4
vector4:
  pushl $0
  101e06:	6a 00                	push   $0x0
  pushl $4
  101e08:	6a 04                	push   $0x4
  jmp __alltraps
  101e0a:	e9 b1 ff ff ff       	jmp    101dc0 <__alltraps>

00101e0f <vector5>:
.globl vector5
vector5:
  pushl $0
  101e0f:	6a 00                	push   $0x0
  pushl $5
  101e11:	6a 05                	push   $0x5
  jmp __alltraps
  101e13:	e9 a8 ff ff ff       	jmp    101dc0 <__alltraps>

00101e18 <vector6>:
.globl vector6
vector6:
  pushl $0
  101e18:	6a 00                	push   $0x0
  pushl $6
  101e1a:	6a 06                	push   $0x6
  jmp __alltraps
  101e1c:	e9 9f ff ff ff       	jmp    101dc0 <__alltraps>

00101e21 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e21:	6a 00                	push   $0x0
  pushl $7
  101e23:	6a 07                	push   $0x7
  jmp __alltraps
  101e25:	e9 96 ff ff ff       	jmp    101dc0 <__alltraps>

00101e2a <vector8>:
.globl vector8
vector8:
  pushl $8
  101e2a:	6a 08                	push   $0x8
  jmp __alltraps
  101e2c:	e9 8f ff ff ff       	jmp    101dc0 <__alltraps>

00101e31 <vector9>:
.globl vector9
vector9:
  pushl $9
  101e31:	6a 09                	push   $0x9
  jmp __alltraps
  101e33:	e9 88 ff ff ff       	jmp    101dc0 <__alltraps>

00101e38 <vector10>:
.globl vector10
vector10:
  pushl $10
  101e38:	6a 0a                	push   $0xa
  jmp __alltraps
  101e3a:	e9 81 ff ff ff       	jmp    101dc0 <__alltraps>

00101e3f <vector11>:
.globl vector11
vector11:
  pushl $11
  101e3f:	6a 0b                	push   $0xb
  jmp __alltraps
  101e41:	e9 7a ff ff ff       	jmp    101dc0 <__alltraps>

00101e46 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e46:	6a 0c                	push   $0xc
  jmp __alltraps
  101e48:	e9 73 ff ff ff       	jmp    101dc0 <__alltraps>

00101e4d <vector13>:
.globl vector13
vector13:
  pushl $13
  101e4d:	6a 0d                	push   $0xd
  jmp __alltraps
  101e4f:	e9 6c ff ff ff       	jmp    101dc0 <__alltraps>

00101e54 <vector14>:
.globl vector14
vector14:
  pushl $14
  101e54:	6a 0e                	push   $0xe
  jmp __alltraps
  101e56:	e9 65 ff ff ff       	jmp    101dc0 <__alltraps>

00101e5b <vector15>:
.globl vector15
vector15:
  pushl $0
  101e5b:	6a 00                	push   $0x0
  pushl $15
  101e5d:	6a 0f                	push   $0xf
  jmp __alltraps
  101e5f:	e9 5c ff ff ff       	jmp    101dc0 <__alltraps>

00101e64 <vector16>:
.globl vector16
vector16:
  pushl $0
  101e64:	6a 00                	push   $0x0
  pushl $16
  101e66:	6a 10                	push   $0x10
  jmp __alltraps
  101e68:	e9 53 ff ff ff       	jmp    101dc0 <__alltraps>

00101e6d <vector17>:
.globl vector17
vector17:
  pushl $17
  101e6d:	6a 11                	push   $0x11
  jmp __alltraps
  101e6f:	e9 4c ff ff ff       	jmp    101dc0 <__alltraps>

00101e74 <vector18>:
.globl vector18
vector18:
  pushl $0
  101e74:	6a 00                	push   $0x0
  pushl $18
  101e76:	6a 12                	push   $0x12
  jmp __alltraps
  101e78:	e9 43 ff ff ff       	jmp    101dc0 <__alltraps>

00101e7d <vector19>:
.globl vector19
vector19:
  pushl $0
  101e7d:	6a 00                	push   $0x0
  pushl $19
  101e7f:	6a 13                	push   $0x13
  jmp __alltraps
  101e81:	e9 3a ff ff ff       	jmp    101dc0 <__alltraps>

00101e86 <vector20>:
.globl vector20
vector20:
  pushl $0
  101e86:	6a 00                	push   $0x0
  pushl $20
  101e88:	6a 14                	push   $0x14
  jmp __alltraps
  101e8a:	e9 31 ff ff ff       	jmp    101dc0 <__alltraps>

00101e8f <vector21>:
.globl vector21
vector21:
  pushl $0
  101e8f:	6a 00                	push   $0x0
  pushl $21
  101e91:	6a 15                	push   $0x15
  jmp __alltraps
  101e93:	e9 28 ff ff ff       	jmp    101dc0 <__alltraps>

00101e98 <vector22>:
.globl vector22
vector22:
  pushl $0
  101e98:	6a 00                	push   $0x0
  pushl $22
  101e9a:	6a 16                	push   $0x16
  jmp __alltraps
  101e9c:	e9 1f ff ff ff       	jmp    101dc0 <__alltraps>

00101ea1 <vector23>:
.globl vector23
vector23:
  pushl $0
  101ea1:	6a 00                	push   $0x0
  pushl $23
  101ea3:	6a 17                	push   $0x17
  jmp __alltraps
  101ea5:	e9 16 ff ff ff       	jmp    101dc0 <__alltraps>

00101eaa <vector24>:
.globl vector24
vector24:
  pushl $0
  101eaa:	6a 00                	push   $0x0
  pushl $24
  101eac:	6a 18                	push   $0x18
  jmp __alltraps
  101eae:	e9 0d ff ff ff       	jmp    101dc0 <__alltraps>

00101eb3 <vector25>:
.globl vector25
vector25:
  pushl $0
  101eb3:	6a 00                	push   $0x0
  pushl $25
  101eb5:	6a 19                	push   $0x19
  jmp __alltraps
  101eb7:	e9 04 ff ff ff       	jmp    101dc0 <__alltraps>

00101ebc <vector26>:
.globl vector26
vector26:
  pushl $0
  101ebc:	6a 00                	push   $0x0
  pushl $26
  101ebe:	6a 1a                	push   $0x1a
  jmp __alltraps
  101ec0:	e9 fb fe ff ff       	jmp    101dc0 <__alltraps>

00101ec5 <vector27>:
.globl vector27
vector27:
  pushl $0
  101ec5:	6a 00                	push   $0x0
  pushl $27
  101ec7:	6a 1b                	push   $0x1b
  jmp __alltraps
  101ec9:	e9 f2 fe ff ff       	jmp    101dc0 <__alltraps>

00101ece <vector28>:
.globl vector28
vector28:
  pushl $0
  101ece:	6a 00                	push   $0x0
  pushl $28
  101ed0:	6a 1c                	push   $0x1c
  jmp __alltraps
  101ed2:	e9 e9 fe ff ff       	jmp    101dc0 <__alltraps>

00101ed7 <vector29>:
.globl vector29
vector29:
  pushl $0
  101ed7:	6a 00                	push   $0x0
  pushl $29
  101ed9:	6a 1d                	push   $0x1d
  jmp __alltraps
  101edb:	e9 e0 fe ff ff       	jmp    101dc0 <__alltraps>

00101ee0 <vector30>:
.globl vector30
vector30:
  pushl $0
  101ee0:	6a 00                	push   $0x0
  pushl $30
  101ee2:	6a 1e                	push   $0x1e
  jmp __alltraps
  101ee4:	e9 d7 fe ff ff       	jmp    101dc0 <__alltraps>

00101ee9 <vector31>:
.globl vector31
vector31:
  pushl $0
  101ee9:	6a 00                	push   $0x0
  pushl $31
  101eeb:	6a 1f                	push   $0x1f
  jmp __alltraps
  101eed:	e9 ce fe ff ff       	jmp    101dc0 <__alltraps>

00101ef2 <vector32>:
.globl vector32
vector32:
  pushl $0
  101ef2:	6a 00                	push   $0x0
  pushl $32
  101ef4:	6a 20                	push   $0x20
  jmp __alltraps
  101ef6:	e9 c5 fe ff ff       	jmp    101dc0 <__alltraps>

00101efb <vector33>:
.globl vector33
vector33:
  pushl $0
  101efb:	6a 00                	push   $0x0
  pushl $33
  101efd:	6a 21                	push   $0x21
  jmp __alltraps
  101eff:	e9 bc fe ff ff       	jmp    101dc0 <__alltraps>

00101f04 <vector34>:
.globl vector34
vector34:
  pushl $0
  101f04:	6a 00                	push   $0x0
  pushl $34
  101f06:	6a 22                	push   $0x22
  jmp __alltraps
  101f08:	e9 b3 fe ff ff       	jmp    101dc0 <__alltraps>

00101f0d <vector35>:
.globl vector35
vector35:
  pushl $0
  101f0d:	6a 00                	push   $0x0
  pushl $35
  101f0f:	6a 23                	push   $0x23
  jmp __alltraps
  101f11:	e9 aa fe ff ff       	jmp    101dc0 <__alltraps>

00101f16 <vector36>:
.globl vector36
vector36:
  pushl $0
  101f16:	6a 00                	push   $0x0
  pushl $36
  101f18:	6a 24                	push   $0x24
  jmp __alltraps
  101f1a:	e9 a1 fe ff ff       	jmp    101dc0 <__alltraps>

00101f1f <vector37>:
.globl vector37
vector37:
  pushl $0
  101f1f:	6a 00                	push   $0x0
  pushl $37
  101f21:	6a 25                	push   $0x25
  jmp __alltraps
  101f23:	e9 98 fe ff ff       	jmp    101dc0 <__alltraps>

00101f28 <vector38>:
.globl vector38
vector38:
  pushl $0
  101f28:	6a 00                	push   $0x0
  pushl $38
  101f2a:	6a 26                	push   $0x26
  jmp __alltraps
  101f2c:	e9 8f fe ff ff       	jmp    101dc0 <__alltraps>

00101f31 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f31:	6a 00                	push   $0x0
  pushl $39
  101f33:	6a 27                	push   $0x27
  jmp __alltraps
  101f35:	e9 86 fe ff ff       	jmp    101dc0 <__alltraps>

00101f3a <vector40>:
.globl vector40
vector40:
  pushl $0
  101f3a:	6a 00                	push   $0x0
  pushl $40
  101f3c:	6a 28                	push   $0x28
  jmp __alltraps
  101f3e:	e9 7d fe ff ff       	jmp    101dc0 <__alltraps>

00101f43 <vector41>:
.globl vector41
vector41:
  pushl $0
  101f43:	6a 00                	push   $0x0
  pushl $41
  101f45:	6a 29                	push   $0x29
  jmp __alltraps
  101f47:	e9 74 fe ff ff       	jmp    101dc0 <__alltraps>

00101f4c <vector42>:
.globl vector42
vector42:
  pushl $0
  101f4c:	6a 00                	push   $0x0
  pushl $42
  101f4e:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f50:	e9 6b fe ff ff       	jmp    101dc0 <__alltraps>

00101f55 <vector43>:
.globl vector43
vector43:
  pushl $0
  101f55:	6a 00                	push   $0x0
  pushl $43
  101f57:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f59:	e9 62 fe ff ff       	jmp    101dc0 <__alltraps>

00101f5e <vector44>:
.globl vector44
vector44:
  pushl $0
  101f5e:	6a 00                	push   $0x0
  pushl $44
  101f60:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f62:	e9 59 fe ff ff       	jmp    101dc0 <__alltraps>

00101f67 <vector45>:
.globl vector45
vector45:
  pushl $0
  101f67:	6a 00                	push   $0x0
  pushl $45
  101f69:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f6b:	e9 50 fe ff ff       	jmp    101dc0 <__alltraps>

00101f70 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f70:	6a 00                	push   $0x0
  pushl $46
  101f72:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f74:	e9 47 fe ff ff       	jmp    101dc0 <__alltraps>

00101f79 <vector47>:
.globl vector47
vector47:
  pushl $0
  101f79:	6a 00                	push   $0x0
  pushl $47
  101f7b:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f7d:	e9 3e fe ff ff       	jmp    101dc0 <__alltraps>

00101f82 <vector48>:
.globl vector48
vector48:
  pushl $0
  101f82:	6a 00                	push   $0x0
  pushl $48
  101f84:	6a 30                	push   $0x30
  jmp __alltraps
  101f86:	e9 35 fe ff ff       	jmp    101dc0 <__alltraps>

00101f8b <vector49>:
.globl vector49
vector49:
  pushl $0
  101f8b:	6a 00                	push   $0x0
  pushl $49
  101f8d:	6a 31                	push   $0x31
  jmp __alltraps
  101f8f:	e9 2c fe ff ff       	jmp    101dc0 <__alltraps>

00101f94 <vector50>:
.globl vector50
vector50:
  pushl $0
  101f94:	6a 00                	push   $0x0
  pushl $50
  101f96:	6a 32                	push   $0x32
  jmp __alltraps
  101f98:	e9 23 fe ff ff       	jmp    101dc0 <__alltraps>

00101f9d <vector51>:
.globl vector51
vector51:
  pushl $0
  101f9d:	6a 00                	push   $0x0
  pushl $51
  101f9f:	6a 33                	push   $0x33
  jmp __alltraps
  101fa1:	e9 1a fe ff ff       	jmp    101dc0 <__alltraps>

00101fa6 <vector52>:
.globl vector52
vector52:
  pushl $0
  101fa6:	6a 00                	push   $0x0
  pushl $52
  101fa8:	6a 34                	push   $0x34
  jmp __alltraps
  101faa:	e9 11 fe ff ff       	jmp    101dc0 <__alltraps>

00101faf <vector53>:
.globl vector53
vector53:
  pushl $0
  101faf:	6a 00                	push   $0x0
  pushl $53
  101fb1:	6a 35                	push   $0x35
  jmp __alltraps
  101fb3:	e9 08 fe ff ff       	jmp    101dc0 <__alltraps>

00101fb8 <vector54>:
.globl vector54
vector54:
  pushl $0
  101fb8:	6a 00                	push   $0x0
  pushl $54
  101fba:	6a 36                	push   $0x36
  jmp __alltraps
  101fbc:	e9 ff fd ff ff       	jmp    101dc0 <__alltraps>

00101fc1 <vector55>:
.globl vector55
vector55:
  pushl $0
  101fc1:	6a 00                	push   $0x0
  pushl $55
  101fc3:	6a 37                	push   $0x37
  jmp __alltraps
  101fc5:	e9 f6 fd ff ff       	jmp    101dc0 <__alltraps>

00101fca <vector56>:
.globl vector56
vector56:
  pushl $0
  101fca:	6a 00                	push   $0x0
  pushl $56
  101fcc:	6a 38                	push   $0x38
  jmp __alltraps
  101fce:	e9 ed fd ff ff       	jmp    101dc0 <__alltraps>

00101fd3 <vector57>:
.globl vector57
vector57:
  pushl $0
  101fd3:	6a 00                	push   $0x0
  pushl $57
  101fd5:	6a 39                	push   $0x39
  jmp __alltraps
  101fd7:	e9 e4 fd ff ff       	jmp    101dc0 <__alltraps>

00101fdc <vector58>:
.globl vector58
vector58:
  pushl $0
  101fdc:	6a 00                	push   $0x0
  pushl $58
  101fde:	6a 3a                	push   $0x3a
  jmp __alltraps
  101fe0:	e9 db fd ff ff       	jmp    101dc0 <__alltraps>

00101fe5 <vector59>:
.globl vector59
vector59:
  pushl $0
  101fe5:	6a 00                	push   $0x0
  pushl $59
  101fe7:	6a 3b                	push   $0x3b
  jmp __alltraps
  101fe9:	e9 d2 fd ff ff       	jmp    101dc0 <__alltraps>

00101fee <vector60>:
.globl vector60
vector60:
  pushl $0
  101fee:	6a 00                	push   $0x0
  pushl $60
  101ff0:	6a 3c                	push   $0x3c
  jmp __alltraps
  101ff2:	e9 c9 fd ff ff       	jmp    101dc0 <__alltraps>

00101ff7 <vector61>:
.globl vector61
vector61:
  pushl $0
  101ff7:	6a 00                	push   $0x0
  pushl $61
  101ff9:	6a 3d                	push   $0x3d
  jmp __alltraps
  101ffb:	e9 c0 fd ff ff       	jmp    101dc0 <__alltraps>

00102000 <vector62>:
.globl vector62
vector62:
  pushl $0
  102000:	6a 00                	push   $0x0
  pushl $62
  102002:	6a 3e                	push   $0x3e
  jmp __alltraps
  102004:	e9 b7 fd ff ff       	jmp    101dc0 <__alltraps>

00102009 <vector63>:
.globl vector63
vector63:
  pushl $0
  102009:	6a 00                	push   $0x0
  pushl $63
  10200b:	6a 3f                	push   $0x3f
  jmp __alltraps
  10200d:	e9 ae fd ff ff       	jmp    101dc0 <__alltraps>

00102012 <vector64>:
.globl vector64
vector64:
  pushl $0
  102012:	6a 00                	push   $0x0
  pushl $64
  102014:	6a 40                	push   $0x40
  jmp __alltraps
  102016:	e9 a5 fd ff ff       	jmp    101dc0 <__alltraps>

0010201b <vector65>:
.globl vector65
vector65:
  pushl $0
  10201b:	6a 00                	push   $0x0
  pushl $65
  10201d:	6a 41                	push   $0x41
  jmp __alltraps
  10201f:	e9 9c fd ff ff       	jmp    101dc0 <__alltraps>

00102024 <vector66>:
.globl vector66
vector66:
  pushl $0
  102024:	6a 00                	push   $0x0
  pushl $66
  102026:	6a 42                	push   $0x42
  jmp __alltraps
  102028:	e9 93 fd ff ff       	jmp    101dc0 <__alltraps>

0010202d <vector67>:
.globl vector67
vector67:
  pushl $0
  10202d:	6a 00                	push   $0x0
  pushl $67
  10202f:	6a 43                	push   $0x43
  jmp __alltraps
  102031:	e9 8a fd ff ff       	jmp    101dc0 <__alltraps>

00102036 <vector68>:
.globl vector68
vector68:
  pushl $0
  102036:	6a 00                	push   $0x0
  pushl $68
  102038:	6a 44                	push   $0x44
  jmp __alltraps
  10203a:	e9 81 fd ff ff       	jmp    101dc0 <__alltraps>

0010203f <vector69>:
.globl vector69
vector69:
  pushl $0
  10203f:	6a 00                	push   $0x0
  pushl $69
  102041:	6a 45                	push   $0x45
  jmp __alltraps
  102043:	e9 78 fd ff ff       	jmp    101dc0 <__alltraps>

00102048 <vector70>:
.globl vector70
vector70:
  pushl $0
  102048:	6a 00                	push   $0x0
  pushl $70
  10204a:	6a 46                	push   $0x46
  jmp __alltraps
  10204c:	e9 6f fd ff ff       	jmp    101dc0 <__alltraps>

00102051 <vector71>:
.globl vector71
vector71:
  pushl $0
  102051:	6a 00                	push   $0x0
  pushl $71
  102053:	6a 47                	push   $0x47
  jmp __alltraps
  102055:	e9 66 fd ff ff       	jmp    101dc0 <__alltraps>

0010205a <vector72>:
.globl vector72
vector72:
  pushl $0
  10205a:	6a 00                	push   $0x0
  pushl $72
  10205c:	6a 48                	push   $0x48
  jmp __alltraps
  10205e:	e9 5d fd ff ff       	jmp    101dc0 <__alltraps>

00102063 <vector73>:
.globl vector73
vector73:
  pushl $0
  102063:	6a 00                	push   $0x0
  pushl $73
  102065:	6a 49                	push   $0x49
  jmp __alltraps
  102067:	e9 54 fd ff ff       	jmp    101dc0 <__alltraps>

0010206c <vector74>:
.globl vector74
vector74:
  pushl $0
  10206c:	6a 00                	push   $0x0
  pushl $74
  10206e:	6a 4a                	push   $0x4a
  jmp __alltraps
  102070:	e9 4b fd ff ff       	jmp    101dc0 <__alltraps>

00102075 <vector75>:
.globl vector75
vector75:
  pushl $0
  102075:	6a 00                	push   $0x0
  pushl $75
  102077:	6a 4b                	push   $0x4b
  jmp __alltraps
  102079:	e9 42 fd ff ff       	jmp    101dc0 <__alltraps>

0010207e <vector76>:
.globl vector76
vector76:
  pushl $0
  10207e:	6a 00                	push   $0x0
  pushl $76
  102080:	6a 4c                	push   $0x4c
  jmp __alltraps
  102082:	e9 39 fd ff ff       	jmp    101dc0 <__alltraps>

00102087 <vector77>:
.globl vector77
vector77:
  pushl $0
  102087:	6a 00                	push   $0x0
  pushl $77
  102089:	6a 4d                	push   $0x4d
  jmp __alltraps
  10208b:	e9 30 fd ff ff       	jmp    101dc0 <__alltraps>

00102090 <vector78>:
.globl vector78
vector78:
  pushl $0
  102090:	6a 00                	push   $0x0
  pushl $78
  102092:	6a 4e                	push   $0x4e
  jmp __alltraps
  102094:	e9 27 fd ff ff       	jmp    101dc0 <__alltraps>

00102099 <vector79>:
.globl vector79
vector79:
  pushl $0
  102099:	6a 00                	push   $0x0
  pushl $79
  10209b:	6a 4f                	push   $0x4f
  jmp __alltraps
  10209d:	e9 1e fd ff ff       	jmp    101dc0 <__alltraps>

001020a2 <vector80>:
.globl vector80
vector80:
  pushl $0
  1020a2:	6a 00                	push   $0x0
  pushl $80
  1020a4:	6a 50                	push   $0x50
  jmp __alltraps
  1020a6:	e9 15 fd ff ff       	jmp    101dc0 <__alltraps>

001020ab <vector81>:
.globl vector81
vector81:
  pushl $0
  1020ab:	6a 00                	push   $0x0
  pushl $81
  1020ad:	6a 51                	push   $0x51
  jmp __alltraps
  1020af:	e9 0c fd ff ff       	jmp    101dc0 <__alltraps>

001020b4 <vector82>:
.globl vector82
vector82:
  pushl $0
  1020b4:	6a 00                	push   $0x0
  pushl $82
  1020b6:	6a 52                	push   $0x52
  jmp __alltraps
  1020b8:	e9 03 fd ff ff       	jmp    101dc0 <__alltraps>

001020bd <vector83>:
.globl vector83
vector83:
  pushl $0
  1020bd:	6a 00                	push   $0x0
  pushl $83
  1020bf:	6a 53                	push   $0x53
  jmp __alltraps
  1020c1:	e9 fa fc ff ff       	jmp    101dc0 <__alltraps>

001020c6 <vector84>:
.globl vector84
vector84:
  pushl $0
  1020c6:	6a 00                	push   $0x0
  pushl $84
  1020c8:	6a 54                	push   $0x54
  jmp __alltraps
  1020ca:	e9 f1 fc ff ff       	jmp    101dc0 <__alltraps>

001020cf <vector85>:
.globl vector85
vector85:
  pushl $0
  1020cf:	6a 00                	push   $0x0
  pushl $85
  1020d1:	6a 55                	push   $0x55
  jmp __alltraps
  1020d3:	e9 e8 fc ff ff       	jmp    101dc0 <__alltraps>

001020d8 <vector86>:
.globl vector86
vector86:
  pushl $0
  1020d8:	6a 00                	push   $0x0
  pushl $86
  1020da:	6a 56                	push   $0x56
  jmp __alltraps
  1020dc:	e9 df fc ff ff       	jmp    101dc0 <__alltraps>

001020e1 <vector87>:
.globl vector87
vector87:
  pushl $0
  1020e1:	6a 00                	push   $0x0
  pushl $87
  1020e3:	6a 57                	push   $0x57
  jmp __alltraps
  1020e5:	e9 d6 fc ff ff       	jmp    101dc0 <__alltraps>

001020ea <vector88>:
.globl vector88
vector88:
  pushl $0
  1020ea:	6a 00                	push   $0x0
  pushl $88
  1020ec:	6a 58                	push   $0x58
  jmp __alltraps
  1020ee:	e9 cd fc ff ff       	jmp    101dc0 <__alltraps>

001020f3 <vector89>:
.globl vector89
vector89:
  pushl $0
  1020f3:	6a 00                	push   $0x0
  pushl $89
  1020f5:	6a 59                	push   $0x59
  jmp __alltraps
  1020f7:	e9 c4 fc ff ff       	jmp    101dc0 <__alltraps>

001020fc <vector90>:
.globl vector90
vector90:
  pushl $0
  1020fc:	6a 00                	push   $0x0
  pushl $90
  1020fe:	6a 5a                	push   $0x5a
  jmp __alltraps
  102100:	e9 bb fc ff ff       	jmp    101dc0 <__alltraps>

00102105 <vector91>:
.globl vector91
vector91:
  pushl $0
  102105:	6a 00                	push   $0x0
  pushl $91
  102107:	6a 5b                	push   $0x5b
  jmp __alltraps
  102109:	e9 b2 fc ff ff       	jmp    101dc0 <__alltraps>

0010210e <vector92>:
.globl vector92
vector92:
  pushl $0
  10210e:	6a 00                	push   $0x0
  pushl $92
  102110:	6a 5c                	push   $0x5c
  jmp __alltraps
  102112:	e9 a9 fc ff ff       	jmp    101dc0 <__alltraps>

00102117 <vector93>:
.globl vector93
vector93:
  pushl $0
  102117:	6a 00                	push   $0x0
  pushl $93
  102119:	6a 5d                	push   $0x5d
  jmp __alltraps
  10211b:	e9 a0 fc ff ff       	jmp    101dc0 <__alltraps>

00102120 <vector94>:
.globl vector94
vector94:
  pushl $0
  102120:	6a 00                	push   $0x0
  pushl $94
  102122:	6a 5e                	push   $0x5e
  jmp __alltraps
  102124:	e9 97 fc ff ff       	jmp    101dc0 <__alltraps>

00102129 <vector95>:
.globl vector95
vector95:
  pushl $0
  102129:	6a 00                	push   $0x0
  pushl $95
  10212b:	6a 5f                	push   $0x5f
  jmp __alltraps
  10212d:	e9 8e fc ff ff       	jmp    101dc0 <__alltraps>

00102132 <vector96>:
.globl vector96
vector96:
  pushl $0
  102132:	6a 00                	push   $0x0
  pushl $96
  102134:	6a 60                	push   $0x60
  jmp __alltraps
  102136:	e9 85 fc ff ff       	jmp    101dc0 <__alltraps>

0010213b <vector97>:
.globl vector97
vector97:
  pushl $0
  10213b:	6a 00                	push   $0x0
  pushl $97
  10213d:	6a 61                	push   $0x61
  jmp __alltraps
  10213f:	e9 7c fc ff ff       	jmp    101dc0 <__alltraps>

00102144 <vector98>:
.globl vector98
vector98:
  pushl $0
  102144:	6a 00                	push   $0x0
  pushl $98
  102146:	6a 62                	push   $0x62
  jmp __alltraps
  102148:	e9 73 fc ff ff       	jmp    101dc0 <__alltraps>

0010214d <vector99>:
.globl vector99
vector99:
  pushl $0
  10214d:	6a 00                	push   $0x0
  pushl $99
  10214f:	6a 63                	push   $0x63
  jmp __alltraps
  102151:	e9 6a fc ff ff       	jmp    101dc0 <__alltraps>

00102156 <vector100>:
.globl vector100
vector100:
  pushl $0
  102156:	6a 00                	push   $0x0
  pushl $100
  102158:	6a 64                	push   $0x64
  jmp __alltraps
  10215a:	e9 61 fc ff ff       	jmp    101dc0 <__alltraps>

0010215f <vector101>:
.globl vector101
vector101:
  pushl $0
  10215f:	6a 00                	push   $0x0
  pushl $101
  102161:	6a 65                	push   $0x65
  jmp __alltraps
  102163:	e9 58 fc ff ff       	jmp    101dc0 <__alltraps>

00102168 <vector102>:
.globl vector102
vector102:
  pushl $0
  102168:	6a 00                	push   $0x0
  pushl $102
  10216a:	6a 66                	push   $0x66
  jmp __alltraps
  10216c:	e9 4f fc ff ff       	jmp    101dc0 <__alltraps>

00102171 <vector103>:
.globl vector103
vector103:
  pushl $0
  102171:	6a 00                	push   $0x0
  pushl $103
  102173:	6a 67                	push   $0x67
  jmp __alltraps
  102175:	e9 46 fc ff ff       	jmp    101dc0 <__alltraps>

0010217a <vector104>:
.globl vector104
vector104:
  pushl $0
  10217a:	6a 00                	push   $0x0
  pushl $104
  10217c:	6a 68                	push   $0x68
  jmp __alltraps
  10217e:	e9 3d fc ff ff       	jmp    101dc0 <__alltraps>

00102183 <vector105>:
.globl vector105
vector105:
  pushl $0
  102183:	6a 00                	push   $0x0
  pushl $105
  102185:	6a 69                	push   $0x69
  jmp __alltraps
  102187:	e9 34 fc ff ff       	jmp    101dc0 <__alltraps>

0010218c <vector106>:
.globl vector106
vector106:
  pushl $0
  10218c:	6a 00                	push   $0x0
  pushl $106
  10218e:	6a 6a                	push   $0x6a
  jmp __alltraps
  102190:	e9 2b fc ff ff       	jmp    101dc0 <__alltraps>

00102195 <vector107>:
.globl vector107
vector107:
  pushl $0
  102195:	6a 00                	push   $0x0
  pushl $107
  102197:	6a 6b                	push   $0x6b
  jmp __alltraps
  102199:	e9 22 fc ff ff       	jmp    101dc0 <__alltraps>

0010219e <vector108>:
.globl vector108
vector108:
  pushl $0
  10219e:	6a 00                	push   $0x0
  pushl $108
  1021a0:	6a 6c                	push   $0x6c
  jmp __alltraps
  1021a2:	e9 19 fc ff ff       	jmp    101dc0 <__alltraps>

001021a7 <vector109>:
.globl vector109
vector109:
  pushl $0
  1021a7:	6a 00                	push   $0x0
  pushl $109
  1021a9:	6a 6d                	push   $0x6d
  jmp __alltraps
  1021ab:	e9 10 fc ff ff       	jmp    101dc0 <__alltraps>

001021b0 <vector110>:
.globl vector110
vector110:
  pushl $0
  1021b0:	6a 00                	push   $0x0
  pushl $110
  1021b2:	6a 6e                	push   $0x6e
  jmp __alltraps
  1021b4:	e9 07 fc ff ff       	jmp    101dc0 <__alltraps>

001021b9 <vector111>:
.globl vector111
vector111:
  pushl $0
  1021b9:	6a 00                	push   $0x0
  pushl $111
  1021bb:	6a 6f                	push   $0x6f
  jmp __alltraps
  1021bd:	e9 fe fb ff ff       	jmp    101dc0 <__alltraps>

001021c2 <vector112>:
.globl vector112
vector112:
  pushl $0
  1021c2:	6a 00                	push   $0x0
  pushl $112
  1021c4:	6a 70                	push   $0x70
  jmp __alltraps
  1021c6:	e9 f5 fb ff ff       	jmp    101dc0 <__alltraps>

001021cb <vector113>:
.globl vector113
vector113:
  pushl $0
  1021cb:	6a 00                	push   $0x0
  pushl $113
  1021cd:	6a 71                	push   $0x71
  jmp __alltraps
  1021cf:	e9 ec fb ff ff       	jmp    101dc0 <__alltraps>

001021d4 <vector114>:
.globl vector114
vector114:
  pushl $0
  1021d4:	6a 00                	push   $0x0
  pushl $114
  1021d6:	6a 72                	push   $0x72
  jmp __alltraps
  1021d8:	e9 e3 fb ff ff       	jmp    101dc0 <__alltraps>

001021dd <vector115>:
.globl vector115
vector115:
  pushl $0
  1021dd:	6a 00                	push   $0x0
  pushl $115
  1021df:	6a 73                	push   $0x73
  jmp __alltraps
  1021e1:	e9 da fb ff ff       	jmp    101dc0 <__alltraps>

001021e6 <vector116>:
.globl vector116
vector116:
  pushl $0
  1021e6:	6a 00                	push   $0x0
  pushl $116
  1021e8:	6a 74                	push   $0x74
  jmp __alltraps
  1021ea:	e9 d1 fb ff ff       	jmp    101dc0 <__alltraps>

001021ef <vector117>:
.globl vector117
vector117:
  pushl $0
  1021ef:	6a 00                	push   $0x0
  pushl $117
  1021f1:	6a 75                	push   $0x75
  jmp __alltraps
  1021f3:	e9 c8 fb ff ff       	jmp    101dc0 <__alltraps>

001021f8 <vector118>:
.globl vector118
vector118:
  pushl $0
  1021f8:	6a 00                	push   $0x0
  pushl $118
  1021fa:	6a 76                	push   $0x76
  jmp __alltraps
  1021fc:	e9 bf fb ff ff       	jmp    101dc0 <__alltraps>

00102201 <vector119>:
.globl vector119
vector119:
  pushl $0
  102201:	6a 00                	push   $0x0
  pushl $119
  102203:	6a 77                	push   $0x77
  jmp __alltraps
  102205:	e9 b6 fb ff ff       	jmp    101dc0 <__alltraps>

0010220a <vector120>:
.globl vector120
vector120:
  pushl $0
  10220a:	6a 00                	push   $0x0
  pushl $120
  10220c:	6a 78                	push   $0x78
  jmp __alltraps
  10220e:	e9 ad fb ff ff       	jmp    101dc0 <__alltraps>

00102213 <vector121>:
.globl vector121
vector121:
  pushl $0
  102213:	6a 00                	push   $0x0
  pushl $121
  102215:	6a 79                	push   $0x79
  jmp __alltraps
  102217:	e9 a4 fb ff ff       	jmp    101dc0 <__alltraps>

0010221c <vector122>:
.globl vector122
vector122:
  pushl $0
  10221c:	6a 00                	push   $0x0
  pushl $122
  10221e:	6a 7a                	push   $0x7a
  jmp __alltraps
  102220:	e9 9b fb ff ff       	jmp    101dc0 <__alltraps>

00102225 <vector123>:
.globl vector123
vector123:
  pushl $0
  102225:	6a 00                	push   $0x0
  pushl $123
  102227:	6a 7b                	push   $0x7b
  jmp __alltraps
  102229:	e9 92 fb ff ff       	jmp    101dc0 <__alltraps>

0010222e <vector124>:
.globl vector124
vector124:
  pushl $0
  10222e:	6a 00                	push   $0x0
  pushl $124
  102230:	6a 7c                	push   $0x7c
  jmp __alltraps
  102232:	e9 89 fb ff ff       	jmp    101dc0 <__alltraps>

00102237 <vector125>:
.globl vector125
vector125:
  pushl $0
  102237:	6a 00                	push   $0x0
  pushl $125
  102239:	6a 7d                	push   $0x7d
  jmp __alltraps
  10223b:	e9 80 fb ff ff       	jmp    101dc0 <__alltraps>

00102240 <vector126>:
.globl vector126
vector126:
  pushl $0
  102240:	6a 00                	push   $0x0
  pushl $126
  102242:	6a 7e                	push   $0x7e
  jmp __alltraps
  102244:	e9 77 fb ff ff       	jmp    101dc0 <__alltraps>

00102249 <vector127>:
.globl vector127
vector127:
  pushl $0
  102249:	6a 00                	push   $0x0
  pushl $127
  10224b:	6a 7f                	push   $0x7f
  jmp __alltraps
  10224d:	e9 6e fb ff ff       	jmp    101dc0 <__alltraps>

00102252 <vector128>:
.globl vector128
vector128:
  pushl $0
  102252:	6a 00                	push   $0x0
  pushl $128
  102254:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  102259:	e9 62 fb ff ff       	jmp    101dc0 <__alltraps>

0010225e <vector129>:
.globl vector129
vector129:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $129
  102260:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102265:	e9 56 fb ff ff       	jmp    101dc0 <__alltraps>

0010226a <vector130>:
.globl vector130
vector130:
  pushl $0
  10226a:	6a 00                	push   $0x0
  pushl $130
  10226c:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102271:	e9 4a fb ff ff       	jmp    101dc0 <__alltraps>

00102276 <vector131>:
.globl vector131
vector131:
  pushl $0
  102276:	6a 00                	push   $0x0
  pushl $131
  102278:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10227d:	e9 3e fb ff ff       	jmp    101dc0 <__alltraps>

00102282 <vector132>:
.globl vector132
vector132:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $132
  102284:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  102289:	e9 32 fb ff ff       	jmp    101dc0 <__alltraps>

0010228e <vector133>:
.globl vector133
vector133:
  pushl $0
  10228e:	6a 00                	push   $0x0
  pushl $133
  102290:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102295:	e9 26 fb ff ff       	jmp    101dc0 <__alltraps>

0010229a <vector134>:
.globl vector134
vector134:
  pushl $0
  10229a:	6a 00                	push   $0x0
  pushl $134
  10229c:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1022a1:	e9 1a fb ff ff       	jmp    101dc0 <__alltraps>

001022a6 <vector135>:
.globl vector135
vector135:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $135
  1022a8:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1022ad:	e9 0e fb ff ff       	jmp    101dc0 <__alltraps>

001022b2 <vector136>:
.globl vector136
vector136:
  pushl $0
  1022b2:	6a 00                	push   $0x0
  pushl $136
  1022b4:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1022b9:	e9 02 fb ff ff       	jmp    101dc0 <__alltraps>

001022be <vector137>:
.globl vector137
vector137:
  pushl $0
  1022be:	6a 00                	push   $0x0
  pushl $137
  1022c0:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  1022c5:	e9 f6 fa ff ff       	jmp    101dc0 <__alltraps>

001022ca <vector138>:
.globl vector138
vector138:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $138
  1022cc:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1022d1:	e9 ea fa ff ff       	jmp    101dc0 <__alltraps>

001022d6 <vector139>:
.globl vector139
vector139:
  pushl $0
  1022d6:	6a 00                	push   $0x0
  pushl $139
  1022d8:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1022dd:	e9 de fa ff ff       	jmp    101dc0 <__alltraps>

001022e2 <vector140>:
.globl vector140
vector140:
  pushl $0
  1022e2:	6a 00                	push   $0x0
  pushl $140
  1022e4:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1022e9:	e9 d2 fa ff ff       	jmp    101dc0 <__alltraps>

001022ee <vector141>:
.globl vector141
vector141:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $141
  1022f0:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1022f5:	e9 c6 fa ff ff       	jmp    101dc0 <__alltraps>

001022fa <vector142>:
.globl vector142
vector142:
  pushl $0
  1022fa:	6a 00                	push   $0x0
  pushl $142
  1022fc:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102301:	e9 ba fa ff ff       	jmp    101dc0 <__alltraps>

00102306 <vector143>:
.globl vector143
vector143:
  pushl $0
  102306:	6a 00                	push   $0x0
  pushl $143
  102308:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10230d:	e9 ae fa ff ff       	jmp    101dc0 <__alltraps>

00102312 <vector144>:
.globl vector144
vector144:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $144
  102314:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102319:	e9 a2 fa ff ff       	jmp    101dc0 <__alltraps>

0010231e <vector145>:
.globl vector145
vector145:
  pushl $0
  10231e:	6a 00                	push   $0x0
  pushl $145
  102320:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102325:	e9 96 fa ff ff       	jmp    101dc0 <__alltraps>

0010232a <vector146>:
.globl vector146
vector146:
  pushl $0
  10232a:	6a 00                	push   $0x0
  pushl $146
  10232c:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102331:	e9 8a fa ff ff       	jmp    101dc0 <__alltraps>

00102336 <vector147>:
.globl vector147
vector147:
  pushl $0
  102336:	6a 00                	push   $0x0
  pushl $147
  102338:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10233d:	e9 7e fa ff ff       	jmp    101dc0 <__alltraps>

00102342 <vector148>:
.globl vector148
vector148:
  pushl $0
  102342:	6a 00                	push   $0x0
  pushl $148
  102344:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  102349:	e9 72 fa ff ff       	jmp    101dc0 <__alltraps>

0010234e <vector149>:
.globl vector149
vector149:
  pushl $0
  10234e:	6a 00                	push   $0x0
  pushl $149
  102350:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102355:	e9 66 fa ff ff       	jmp    101dc0 <__alltraps>

0010235a <vector150>:
.globl vector150
vector150:
  pushl $0
  10235a:	6a 00                	push   $0x0
  pushl $150
  10235c:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102361:	e9 5a fa ff ff       	jmp    101dc0 <__alltraps>

00102366 <vector151>:
.globl vector151
vector151:
  pushl $0
  102366:	6a 00                	push   $0x0
  pushl $151
  102368:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10236d:	e9 4e fa ff ff       	jmp    101dc0 <__alltraps>

00102372 <vector152>:
.globl vector152
vector152:
  pushl $0
  102372:	6a 00                	push   $0x0
  pushl $152
  102374:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  102379:	e9 42 fa ff ff       	jmp    101dc0 <__alltraps>

0010237e <vector153>:
.globl vector153
vector153:
  pushl $0
  10237e:	6a 00                	push   $0x0
  pushl $153
  102380:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102385:	e9 36 fa ff ff       	jmp    101dc0 <__alltraps>

0010238a <vector154>:
.globl vector154
vector154:
  pushl $0
  10238a:	6a 00                	push   $0x0
  pushl $154
  10238c:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102391:	e9 2a fa ff ff       	jmp    101dc0 <__alltraps>

00102396 <vector155>:
.globl vector155
vector155:
  pushl $0
  102396:	6a 00                	push   $0x0
  pushl $155
  102398:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10239d:	e9 1e fa ff ff       	jmp    101dc0 <__alltraps>

001023a2 <vector156>:
.globl vector156
vector156:
  pushl $0
  1023a2:	6a 00                	push   $0x0
  pushl $156
  1023a4:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1023a9:	e9 12 fa ff ff       	jmp    101dc0 <__alltraps>

001023ae <vector157>:
.globl vector157
vector157:
  pushl $0
  1023ae:	6a 00                	push   $0x0
  pushl $157
  1023b0:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1023b5:	e9 06 fa ff ff       	jmp    101dc0 <__alltraps>

001023ba <vector158>:
.globl vector158
vector158:
  pushl $0
  1023ba:	6a 00                	push   $0x0
  pushl $158
  1023bc:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  1023c1:	e9 fa f9 ff ff       	jmp    101dc0 <__alltraps>

001023c6 <vector159>:
.globl vector159
vector159:
  pushl $0
  1023c6:	6a 00                	push   $0x0
  pushl $159
  1023c8:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1023cd:	e9 ee f9 ff ff       	jmp    101dc0 <__alltraps>

001023d2 <vector160>:
.globl vector160
vector160:
  pushl $0
  1023d2:	6a 00                	push   $0x0
  pushl $160
  1023d4:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1023d9:	e9 e2 f9 ff ff       	jmp    101dc0 <__alltraps>

001023de <vector161>:
.globl vector161
vector161:
  pushl $0
  1023de:	6a 00                	push   $0x0
  pushl $161
  1023e0:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1023e5:	e9 d6 f9 ff ff       	jmp    101dc0 <__alltraps>

001023ea <vector162>:
.globl vector162
vector162:
  pushl $0
  1023ea:	6a 00                	push   $0x0
  pushl $162
  1023ec:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1023f1:	e9 ca f9 ff ff       	jmp    101dc0 <__alltraps>

001023f6 <vector163>:
.globl vector163
vector163:
  pushl $0
  1023f6:	6a 00                	push   $0x0
  pushl $163
  1023f8:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023fd:	e9 be f9 ff ff       	jmp    101dc0 <__alltraps>

00102402 <vector164>:
.globl vector164
vector164:
  pushl $0
  102402:	6a 00                	push   $0x0
  pushl $164
  102404:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102409:	e9 b2 f9 ff ff       	jmp    101dc0 <__alltraps>

0010240e <vector165>:
.globl vector165
vector165:
  pushl $0
  10240e:	6a 00                	push   $0x0
  pushl $165
  102410:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102415:	e9 a6 f9 ff ff       	jmp    101dc0 <__alltraps>

0010241a <vector166>:
.globl vector166
vector166:
  pushl $0
  10241a:	6a 00                	push   $0x0
  pushl $166
  10241c:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102421:	e9 9a f9 ff ff       	jmp    101dc0 <__alltraps>

00102426 <vector167>:
.globl vector167
vector167:
  pushl $0
  102426:	6a 00                	push   $0x0
  pushl $167
  102428:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10242d:	e9 8e f9 ff ff       	jmp    101dc0 <__alltraps>

00102432 <vector168>:
.globl vector168
vector168:
  pushl $0
  102432:	6a 00                	push   $0x0
  pushl $168
  102434:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102439:	e9 82 f9 ff ff       	jmp    101dc0 <__alltraps>

0010243e <vector169>:
.globl vector169
vector169:
  pushl $0
  10243e:	6a 00                	push   $0x0
  pushl $169
  102440:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102445:	e9 76 f9 ff ff       	jmp    101dc0 <__alltraps>

0010244a <vector170>:
.globl vector170
vector170:
  pushl $0
  10244a:	6a 00                	push   $0x0
  pushl $170
  10244c:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102451:	e9 6a f9 ff ff       	jmp    101dc0 <__alltraps>

00102456 <vector171>:
.globl vector171
vector171:
  pushl $0
  102456:	6a 00                	push   $0x0
  pushl $171
  102458:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10245d:	e9 5e f9 ff ff       	jmp    101dc0 <__alltraps>

00102462 <vector172>:
.globl vector172
vector172:
  pushl $0
  102462:	6a 00                	push   $0x0
  pushl $172
  102464:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  102469:	e9 52 f9 ff ff       	jmp    101dc0 <__alltraps>

0010246e <vector173>:
.globl vector173
vector173:
  pushl $0
  10246e:	6a 00                	push   $0x0
  pushl $173
  102470:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102475:	e9 46 f9 ff ff       	jmp    101dc0 <__alltraps>

0010247a <vector174>:
.globl vector174
vector174:
  pushl $0
  10247a:	6a 00                	push   $0x0
  pushl $174
  10247c:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102481:	e9 3a f9 ff ff       	jmp    101dc0 <__alltraps>

00102486 <vector175>:
.globl vector175
vector175:
  pushl $0
  102486:	6a 00                	push   $0x0
  pushl $175
  102488:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10248d:	e9 2e f9 ff ff       	jmp    101dc0 <__alltraps>

00102492 <vector176>:
.globl vector176
vector176:
  pushl $0
  102492:	6a 00                	push   $0x0
  pushl $176
  102494:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  102499:	e9 22 f9 ff ff       	jmp    101dc0 <__alltraps>

0010249e <vector177>:
.globl vector177
vector177:
  pushl $0
  10249e:	6a 00                	push   $0x0
  pushl $177
  1024a0:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1024a5:	e9 16 f9 ff ff       	jmp    101dc0 <__alltraps>

001024aa <vector178>:
.globl vector178
vector178:
  pushl $0
  1024aa:	6a 00                	push   $0x0
  pushl $178
  1024ac:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1024b1:	e9 0a f9 ff ff       	jmp    101dc0 <__alltraps>

001024b6 <vector179>:
.globl vector179
vector179:
  pushl $0
  1024b6:	6a 00                	push   $0x0
  pushl $179
  1024b8:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1024bd:	e9 fe f8 ff ff       	jmp    101dc0 <__alltraps>

001024c2 <vector180>:
.globl vector180
vector180:
  pushl $0
  1024c2:	6a 00                	push   $0x0
  pushl $180
  1024c4:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  1024c9:	e9 f2 f8 ff ff       	jmp    101dc0 <__alltraps>

001024ce <vector181>:
.globl vector181
vector181:
  pushl $0
  1024ce:	6a 00                	push   $0x0
  pushl $181
  1024d0:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1024d5:	e9 e6 f8 ff ff       	jmp    101dc0 <__alltraps>

001024da <vector182>:
.globl vector182
vector182:
  pushl $0
  1024da:	6a 00                	push   $0x0
  pushl $182
  1024dc:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1024e1:	e9 da f8 ff ff       	jmp    101dc0 <__alltraps>

001024e6 <vector183>:
.globl vector183
vector183:
  pushl $0
  1024e6:	6a 00                	push   $0x0
  pushl $183
  1024e8:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1024ed:	e9 ce f8 ff ff       	jmp    101dc0 <__alltraps>

001024f2 <vector184>:
.globl vector184
vector184:
  pushl $0
  1024f2:	6a 00                	push   $0x0
  pushl $184
  1024f4:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024f9:	e9 c2 f8 ff ff       	jmp    101dc0 <__alltraps>

001024fe <vector185>:
.globl vector185
vector185:
  pushl $0
  1024fe:	6a 00                	push   $0x0
  pushl $185
  102500:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102505:	e9 b6 f8 ff ff       	jmp    101dc0 <__alltraps>

0010250a <vector186>:
.globl vector186
vector186:
  pushl $0
  10250a:	6a 00                	push   $0x0
  pushl $186
  10250c:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102511:	e9 aa f8 ff ff       	jmp    101dc0 <__alltraps>

00102516 <vector187>:
.globl vector187
vector187:
  pushl $0
  102516:	6a 00                	push   $0x0
  pushl $187
  102518:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10251d:	e9 9e f8 ff ff       	jmp    101dc0 <__alltraps>

00102522 <vector188>:
.globl vector188
vector188:
  pushl $0
  102522:	6a 00                	push   $0x0
  pushl $188
  102524:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102529:	e9 92 f8 ff ff       	jmp    101dc0 <__alltraps>

0010252e <vector189>:
.globl vector189
vector189:
  pushl $0
  10252e:	6a 00                	push   $0x0
  pushl $189
  102530:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102535:	e9 86 f8 ff ff       	jmp    101dc0 <__alltraps>

0010253a <vector190>:
.globl vector190
vector190:
  pushl $0
  10253a:	6a 00                	push   $0x0
  pushl $190
  10253c:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102541:	e9 7a f8 ff ff       	jmp    101dc0 <__alltraps>

00102546 <vector191>:
.globl vector191
vector191:
  pushl $0
  102546:	6a 00                	push   $0x0
  pushl $191
  102548:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10254d:	e9 6e f8 ff ff       	jmp    101dc0 <__alltraps>

00102552 <vector192>:
.globl vector192
vector192:
  pushl $0
  102552:	6a 00                	push   $0x0
  pushl $192
  102554:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  102559:	e9 62 f8 ff ff       	jmp    101dc0 <__alltraps>

0010255e <vector193>:
.globl vector193
vector193:
  pushl $0
  10255e:	6a 00                	push   $0x0
  pushl $193
  102560:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102565:	e9 56 f8 ff ff       	jmp    101dc0 <__alltraps>

0010256a <vector194>:
.globl vector194
vector194:
  pushl $0
  10256a:	6a 00                	push   $0x0
  pushl $194
  10256c:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102571:	e9 4a f8 ff ff       	jmp    101dc0 <__alltraps>

00102576 <vector195>:
.globl vector195
vector195:
  pushl $0
  102576:	6a 00                	push   $0x0
  pushl $195
  102578:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10257d:	e9 3e f8 ff ff       	jmp    101dc0 <__alltraps>

00102582 <vector196>:
.globl vector196
vector196:
  pushl $0
  102582:	6a 00                	push   $0x0
  pushl $196
  102584:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  102589:	e9 32 f8 ff ff       	jmp    101dc0 <__alltraps>

0010258e <vector197>:
.globl vector197
vector197:
  pushl $0
  10258e:	6a 00                	push   $0x0
  pushl $197
  102590:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102595:	e9 26 f8 ff ff       	jmp    101dc0 <__alltraps>

0010259a <vector198>:
.globl vector198
vector198:
  pushl $0
  10259a:	6a 00                	push   $0x0
  pushl $198
  10259c:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1025a1:	e9 1a f8 ff ff       	jmp    101dc0 <__alltraps>

001025a6 <vector199>:
.globl vector199
vector199:
  pushl $0
  1025a6:	6a 00                	push   $0x0
  pushl $199
  1025a8:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1025ad:	e9 0e f8 ff ff       	jmp    101dc0 <__alltraps>

001025b2 <vector200>:
.globl vector200
vector200:
  pushl $0
  1025b2:	6a 00                	push   $0x0
  pushl $200
  1025b4:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1025b9:	e9 02 f8 ff ff       	jmp    101dc0 <__alltraps>

001025be <vector201>:
.globl vector201
vector201:
  pushl $0
  1025be:	6a 00                	push   $0x0
  pushl $201
  1025c0:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  1025c5:	e9 f6 f7 ff ff       	jmp    101dc0 <__alltraps>

001025ca <vector202>:
.globl vector202
vector202:
  pushl $0
  1025ca:	6a 00                	push   $0x0
  pushl $202
  1025cc:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1025d1:	e9 ea f7 ff ff       	jmp    101dc0 <__alltraps>

001025d6 <vector203>:
.globl vector203
vector203:
  pushl $0
  1025d6:	6a 00                	push   $0x0
  pushl $203
  1025d8:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1025dd:	e9 de f7 ff ff       	jmp    101dc0 <__alltraps>

001025e2 <vector204>:
.globl vector204
vector204:
  pushl $0
  1025e2:	6a 00                	push   $0x0
  pushl $204
  1025e4:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1025e9:	e9 d2 f7 ff ff       	jmp    101dc0 <__alltraps>

001025ee <vector205>:
.globl vector205
vector205:
  pushl $0
  1025ee:	6a 00                	push   $0x0
  pushl $205
  1025f0:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1025f5:	e9 c6 f7 ff ff       	jmp    101dc0 <__alltraps>

001025fa <vector206>:
.globl vector206
vector206:
  pushl $0
  1025fa:	6a 00                	push   $0x0
  pushl $206
  1025fc:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102601:	e9 ba f7 ff ff       	jmp    101dc0 <__alltraps>

00102606 <vector207>:
.globl vector207
vector207:
  pushl $0
  102606:	6a 00                	push   $0x0
  pushl $207
  102608:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10260d:	e9 ae f7 ff ff       	jmp    101dc0 <__alltraps>

00102612 <vector208>:
.globl vector208
vector208:
  pushl $0
  102612:	6a 00                	push   $0x0
  pushl $208
  102614:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102619:	e9 a2 f7 ff ff       	jmp    101dc0 <__alltraps>

0010261e <vector209>:
.globl vector209
vector209:
  pushl $0
  10261e:	6a 00                	push   $0x0
  pushl $209
  102620:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102625:	e9 96 f7 ff ff       	jmp    101dc0 <__alltraps>

0010262a <vector210>:
.globl vector210
vector210:
  pushl $0
  10262a:	6a 00                	push   $0x0
  pushl $210
  10262c:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102631:	e9 8a f7 ff ff       	jmp    101dc0 <__alltraps>

00102636 <vector211>:
.globl vector211
vector211:
  pushl $0
  102636:	6a 00                	push   $0x0
  pushl $211
  102638:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10263d:	e9 7e f7 ff ff       	jmp    101dc0 <__alltraps>

00102642 <vector212>:
.globl vector212
vector212:
  pushl $0
  102642:	6a 00                	push   $0x0
  pushl $212
  102644:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  102649:	e9 72 f7 ff ff       	jmp    101dc0 <__alltraps>

0010264e <vector213>:
.globl vector213
vector213:
  pushl $0
  10264e:	6a 00                	push   $0x0
  pushl $213
  102650:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102655:	e9 66 f7 ff ff       	jmp    101dc0 <__alltraps>

0010265a <vector214>:
.globl vector214
vector214:
  pushl $0
  10265a:	6a 00                	push   $0x0
  pushl $214
  10265c:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102661:	e9 5a f7 ff ff       	jmp    101dc0 <__alltraps>

00102666 <vector215>:
.globl vector215
vector215:
  pushl $0
  102666:	6a 00                	push   $0x0
  pushl $215
  102668:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10266d:	e9 4e f7 ff ff       	jmp    101dc0 <__alltraps>

00102672 <vector216>:
.globl vector216
vector216:
  pushl $0
  102672:	6a 00                	push   $0x0
  pushl $216
  102674:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  102679:	e9 42 f7 ff ff       	jmp    101dc0 <__alltraps>

0010267e <vector217>:
.globl vector217
vector217:
  pushl $0
  10267e:	6a 00                	push   $0x0
  pushl $217
  102680:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102685:	e9 36 f7 ff ff       	jmp    101dc0 <__alltraps>

0010268a <vector218>:
.globl vector218
vector218:
  pushl $0
  10268a:	6a 00                	push   $0x0
  pushl $218
  10268c:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102691:	e9 2a f7 ff ff       	jmp    101dc0 <__alltraps>

00102696 <vector219>:
.globl vector219
vector219:
  pushl $0
  102696:	6a 00                	push   $0x0
  pushl $219
  102698:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10269d:	e9 1e f7 ff ff       	jmp    101dc0 <__alltraps>

001026a2 <vector220>:
.globl vector220
vector220:
  pushl $0
  1026a2:	6a 00                	push   $0x0
  pushl $220
  1026a4:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1026a9:	e9 12 f7 ff ff       	jmp    101dc0 <__alltraps>

001026ae <vector221>:
.globl vector221
vector221:
  pushl $0
  1026ae:	6a 00                	push   $0x0
  pushl $221
  1026b0:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1026b5:	e9 06 f7 ff ff       	jmp    101dc0 <__alltraps>

001026ba <vector222>:
.globl vector222
vector222:
  pushl $0
  1026ba:	6a 00                	push   $0x0
  pushl $222
  1026bc:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  1026c1:	e9 fa f6 ff ff       	jmp    101dc0 <__alltraps>

001026c6 <vector223>:
.globl vector223
vector223:
  pushl $0
  1026c6:	6a 00                	push   $0x0
  pushl $223
  1026c8:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1026cd:	e9 ee f6 ff ff       	jmp    101dc0 <__alltraps>

001026d2 <vector224>:
.globl vector224
vector224:
  pushl $0
  1026d2:	6a 00                	push   $0x0
  pushl $224
  1026d4:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1026d9:	e9 e2 f6 ff ff       	jmp    101dc0 <__alltraps>

001026de <vector225>:
.globl vector225
vector225:
  pushl $0
  1026de:	6a 00                	push   $0x0
  pushl $225
  1026e0:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1026e5:	e9 d6 f6 ff ff       	jmp    101dc0 <__alltraps>

001026ea <vector226>:
.globl vector226
vector226:
  pushl $0
  1026ea:	6a 00                	push   $0x0
  pushl $226
  1026ec:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1026f1:	e9 ca f6 ff ff       	jmp    101dc0 <__alltraps>

001026f6 <vector227>:
.globl vector227
vector227:
  pushl $0
  1026f6:	6a 00                	push   $0x0
  pushl $227
  1026f8:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026fd:	e9 be f6 ff ff       	jmp    101dc0 <__alltraps>

00102702 <vector228>:
.globl vector228
vector228:
  pushl $0
  102702:	6a 00                	push   $0x0
  pushl $228
  102704:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102709:	e9 b2 f6 ff ff       	jmp    101dc0 <__alltraps>

0010270e <vector229>:
.globl vector229
vector229:
  pushl $0
  10270e:	6a 00                	push   $0x0
  pushl $229
  102710:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102715:	e9 a6 f6 ff ff       	jmp    101dc0 <__alltraps>

0010271a <vector230>:
.globl vector230
vector230:
  pushl $0
  10271a:	6a 00                	push   $0x0
  pushl $230
  10271c:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102721:	e9 9a f6 ff ff       	jmp    101dc0 <__alltraps>

00102726 <vector231>:
.globl vector231
vector231:
  pushl $0
  102726:	6a 00                	push   $0x0
  pushl $231
  102728:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10272d:	e9 8e f6 ff ff       	jmp    101dc0 <__alltraps>

00102732 <vector232>:
.globl vector232
vector232:
  pushl $0
  102732:	6a 00                	push   $0x0
  pushl $232
  102734:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102739:	e9 82 f6 ff ff       	jmp    101dc0 <__alltraps>

0010273e <vector233>:
.globl vector233
vector233:
  pushl $0
  10273e:	6a 00                	push   $0x0
  pushl $233
  102740:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102745:	e9 76 f6 ff ff       	jmp    101dc0 <__alltraps>

0010274a <vector234>:
.globl vector234
vector234:
  pushl $0
  10274a:	6a 00                	push   $0x0
  pushl $234
  10274c:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102751:	e9 6a f6 ff ff       	jmp    101dc0 <__alltraps>

00102756 <vector235>:
.globl vector235
vector235:
  pushl $0
  102756:	6a 00                	push   $0x0
  pushl $235
  102758:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10275d:	e9 5e f6 ff ff       	jmp    101dc0 <__alltraps>

00102762 <vector236>:
.globl vector236
vector236:
  pushl $0
  102762:	6a 00                	push   $0x0
  pushl $236
  102764:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  102769:	e9 52 f6 ff ff       	jmp    101dc0 <__alltraps>

0010276e <vector237>:
.globl vector237
vector237:
  pushl $0
  10276e:	6a 00                	push   $0x0
  pushl $237
  102770:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102775:	e9 46 f6 ff ff       	jmp    101dc0 <__alltraps>

0010277a <vector238>:
.globl vector238
vector238:
  pushl $0
  10277a:	6a 00                	push   $0x0
  pushl $238
  10277c:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102781:	e9 3a f6 ff ff       	jmp    101dc0 <__alltraps>

00102786 <vector239>:
.globl vector239
vector239:
  pushl $0
  102786:	6a 00                	push   $0x0
  pushl $239
  102788:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10278d:	e9 2e f6 ff ff       	jmp    101dc0 <__alltraps>

00102792 <vector240>:
.globl vector240
vector240:
  pushl $0
  102792:	6a 00                	push   $0x0
  pushl $240
  102794:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  102799:	e9 22 f6 ff ff       	jmp    101dc0 <__alltraps>

0010279e <vector241>:
.globl vector241
vector241:
  pushl $0
  10279e:	6a 00                	push   $0x0
  pushl $241
  1027a0:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1027a5:	e9 16 f6 ff ff       	jmp    101dc0 <__alltraps>

001027aa <vector242>:
.globl vector242
vector242:
  pushl $0
  1027aa:	6a 00                	push   $0x0
  pushl $242
  1027ac:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1027b1:	e9 0a f6 ff ff       	jmp    101dc0 <__alltraps>

001027b6 <vector243>:
.globl vector243
vector243:
  pushl $0
  1027b6:	6a 00                	push   $0x0
  pushl $243
  1027b8:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1027bd:	e9 fe f5 ff ff       	jmp    101dc0 <__alltraps>

001027c2 <vector244>:
.globl vector244
vector244:
  pushl $0
  1027c2:	6a 00                	push   $0x0
  pushl $244
  1027c4:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  1027c9:	e9 f2 f5 ff ff       	jmp    101dc0 <__alltraps>

001027ce <vector245>:
.globl vector245
vector245:
  pushl $0
  1027ce:	6a 00                	push   $0x0
  pushl $245
  1027d0:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1027d5:	e9 e6 f5 ff ff       	jmp    101dc0 <__alltraps>

001027da <vector246>:
.globl vector246
vector246:
  pushl $0
  1027da:	6a 00                	push   $0x0
  pushl $246
  1027dc:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1027e1:	e9 da f5 ff ff       	jmp    101dc0 <__alltraps>

001027e6 <vector247>:
.globl vector247
vector247:
  pushl $0
  1027e6:	6a 00                	push   $0x0
  pushl $247
  1027e8:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1027ed:	e9 ce f5 ff ff       	jmp    101dc0 <__alltraps>

001027f2 <vector248>:
.globl vector248
vector248:
  pushl $0
  1027f2:	6a 00                	push   $0x0
  pushl $248
  1027f4:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027f9:	e9 c2 f5 ff ff       	jmp    101dc0 <__alltraps>

001027fe <vector249>:
.globl vector249
vector249:
  pushl $0
  1027fe:	6a 00                	push   $0x0
  pushl $249
  102800:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102805:	e9 b6 f5 ff ff       	jmp    101dc0 <__alltraps>

0010280a <vector250>:
.globl vector250
vector250:
  pushl $0
  10280a:	6a 00                	push   $0x0
  pushl $250
  10280c:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102811:	e9 aa f5 ff ff       	jmp    101dc0 <__alltraps>

00102816 <vector251>:
.globl vector251
vector251:
  pushl $0
  102816:	6a 00                	push   $0x0
  pushl $251
  102818:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10281d:	e9 9e f5 ff ff       	jmp    101dc0 <__alltraps>

00102822 <vector252>:
.globl vector252
vector252:
  pushl $0
  102822:	6a 00                	push   $0x0
  pushl $252
  102824:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102829:	e9 92 f5 ff ff       	jmp    101dc0 <__alltraps>

0010282e <vector253>:
.globl vector253
vector253:
  pushl $0
  10282e:	6a 00                	push   $0x0
  pushl $253
  102830:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102835:	e9 86 f5 ff ff       	jmp    101dc0 <__alltraps>

0010283a <vector254>:
.globl vector254
vector254:
  pushl $0
  10283a:	6a 00                	push   $0x0
  pushl $254
  10283c:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102841:	e9 7a f5 ff ff       	jmp    101dc0 <__alltraps>

00102846 <vector255>:
.globl vector255
vector255:
  pushl $0
  102846:	6a 00                	push   $0x0
  pushl $255
  102848:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10284d:	e9 6e f5 ff ff       	jmp    101dc0 <__alltraps>

00102852 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102852:	55                   	push   %ebp
  102853:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102855:	8b 45 08             	mov    0x8(%ebp),%eax
  102858:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  10285b:	b8 23 00 00 00       	mov    $0x23,%eax
  102860:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102862:	b8 23 00 00 00       	mov    $0x23,%eax
  102867:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102869:	b8 10 00 00 00       	mov    $0x10,%eax
  10286e:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102870:	b8 10 00 00 00       	mov    $0x10,%eax
  102875:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102877:	b8 10 00 00 00       	mov    $0x10,%eax
  10287c:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  10287e:	ea 85 28 10 00 08 00 	ljmp   $0x8,$0x102885
}
  102885:	5d                   	pop    %ebp
  102886:	c3                   	ret    

00102887 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102887:	55                   	push   %ebp
  102888:	89 e5                	mov    %esp,%ebp
  10288a:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  10288d:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  102892:	05 00 04 00 00       	add    $0x400,%eax
  102897:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  10289c:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  1028a3:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  1028a5:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  1028ac:	68 00 
  1028ae:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1028b3:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  1028b9:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  1028be:	c1 e8 10             	shr    $0x10,%eax
  1028c1:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  1028c6:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028cd:	83 e0 f0             	and    $0xfffffff0,%eax
  1028d0:	83 c8 09             	or     $0x9,%eax
  1028d3:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028d8:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028df:	83 c8 10             	or     $0x10,%eax
  1028e2:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028e7:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028ee:	83 e0 9f             	and    $0xffffff9f,%eax
  1028f1:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028f6:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028fd:	83 c8 80             	or     $0xffffff80,%eax
  102900:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102905:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10290c:	83 e0 f0             	and    $0xfffffff0,%eax
  10290f:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102914:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10291b:	83 e0 ef             	and    $0xffffffef,%eax
  10291e:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102923:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  10292a:	83 e0 df             	and    $0xffffffdf,%eax
  10292d:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102932:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102939:	83 c8 40             	or     $0x40,%eax
  10293c:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102941:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102948:	83 e0 7f             	and    $0x7f,%eax
  10294b:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102950:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102955:	c1 e8 18             	shr    $0x18,%eax
  102958:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  10295d:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102964:	83 e0 ef             	and    $0xffffffef,%eax
  102967:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  10296c:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102973:	e8 da fe ff ff       	call   102852 <lgdt>
  102978:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  10297e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102982:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102985:	c9                   	leave  
  102986:	c3                   	ret    

00102987 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102987:	55                   	push   %ebp
  102988:	89 e5                	mov    %esp,%ebp
    gdt_init();
  10298a:	e8 f8 fe ff ff       	call   102887 <gdt_init>
}
  10298f:	5d                   	pop    %ebp
  102990:	c3                   	ret    

00102991 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102991:	55                   	push   %ebp
  102992:	89 e5                	mov    %esp,%ebp
  102994:	83 ec 58             	sub    $0x58,%esp
  102997:	8b 45 10             	mov    0x10(%ebp),%eax
  10299a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10299d:	8b 45 14             	mov    0x14(%ebp),%eax
  1029a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1029a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1029a6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1029a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1029ac:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1029af:	8b 45 18             	mov    0x18(%ebp),%eax
  1029b2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1029b5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1029b8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1029bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1029be:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1029c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1029c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1029cb:	74 1c                	je     1029e9 <printnum+0x58>
  1029cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029d0:	ba 00 00 00 00       	mov    $0x0,%edx
  1029d5:	f7 75 e4             	divl   -0x1c(%ebp)
  1029d8:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1029db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1029de:	ba 00 00 00 00       	mov    $0x0,%edx
  1029e3:	f7 75 e4             	divl   -0x1c(%ebp)
  1029e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1029e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1029ef:	f7 75 e4             	divl   -0x1c(%ebp)
  1029f2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1029f5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1029f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102a01:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102a04:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102a07:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102a0a:	8b 45 18             	mov    0x18(%ebp),%eax
  102a0d:	ba 00 00 00 00       	mov    $0x0,%edx
  102a12:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102a15:	77 56                	ja     102a6d <printnum+0xdc>
  102a17:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102a1a:	72 05                	jb     102a21 <printnum+0x90>
  102a1c:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102a1f:	77 4c                	ja     102a6d <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102a21:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102a24:	8d 50 ff             	lea    -0x1(%eax),%edx
  102a27:	8b 45 20             	mov    0x20(%ebp),%eax
  102a2a:	89 44 24 18          	mov    %eax,0x18(%esp)
  102a2e:	89 54 24 14          	mov    %edx,0x14(%esp)
  102a32:	8b 45 18             	mov    0x18(%ebp),%eax
  102a35:	89 44 24 10          	mov    %eax,0x10(%esp)
  102a39:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102a3c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102a3f:	89 44 24 08          	mov    %eax,0x8(%esp)
  102a43:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102a47:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a51:	89 04 24             	mov    %eax,(%esp)
  102a54:	e8 38 ff ff ff       	call   102991 <printnum>
  102a59:	eb 1c                	jmp    102a77 <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102a5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a62:	8b 45 20             	mov    0x20(%ebp),%eax
  102a65:	89 04 24             	mov    %eax,(%esp)
  102a68:	8b 45 08             	mov    0x8(%ebp),%eax
  102a6b:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102a6d:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102a71:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102a75:	7f e4                	jg     102a5b <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102a77:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a7a:	05 90 3c 10 00       	add    $0x103c90,%eax
  102a7f:	0f b6 00             	movzbl (%eax),%eax
  102a82:	0f be c0             	movsbl %al,%eax
  102a85:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a88:	89 54 24 04          	mov    %edx,0x4(%esp)
  102a8c:	89 04 24             	mov    %eax,(%esp)
  102a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a92:	ff d0                	call   *%eax
}
  102a94:	c9                   	leave  
  102a95:	c3                   	ret    

00102a96 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102a96:	55                   	push   %ebp
  102a97:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a99:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a9d:	7e 14                	jle    102ab3 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa2:	8b 00                	mov    (%eax),%eax
  102aa4:	8d 48 08             	lea    0x8(%eax),%ecx
  102aa7:	8b 55 08             	mov    0x8(%ebp),%edx
  102aaa:	89 0a                	mov    %ecx,(%edx)
  102aac:	8b 50 04             	mov    0x4(%eax),%edx
  102aaf:	8b 00                	mov    (%eax),%eax
  102ab1:	eb 30                	jmp    102ae3 <getuint+0x4d>
    }
    else if (lflag) {
  102ab3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102ab7:	74 16                	je     102acf <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  102abc:	8b 00                	mov    (%eax),%eax
  102abe:	8d 48 04             	lea    0x4(%eax),%ecx
  102ac1:	8b 55 08             	mov    0x8(%ebp),%edx
  102ac4:	89 0a                	mov    %ecx,(%edx)
  102ac6:	8b 00                	mov    (%eax),%eax
  102ac8:	ba 00 00 00 00       	mov    $0x0,%edx
  102acd:	eb 14                	jmp    102ae3 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102acf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad2:	8b 00                	mov    (%eax),%eax
  102ad4:	8d 48 04             	lea    0x4(%eax),%ecx
  102ad7:	8b 55 08             	mov    0x8(%ebp),%edx
  102ada:	89 0a                	mov    %ecx,(%edx)
  102adc:	8b 00                	mov    (%eax),%eax
  102ade:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102ae3:	5d                   	pop    %ebp
  102ae4:	c3                   	ret    

00102ae5 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102ae5:	55                   	push   %ebp
  102ae6:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102ae8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102aec:	7e 14                	jle    102b02 <getint+0x1d>
        return va_arg(*ap, long long);
  102aee:	8b 45 08             	mov    0x8(%ebp),%eax
  102af1:	8b 00                	mov    (%eax),%eax
  102af3:	8d 48 08             	lea    0x8(%eax),%ecx
  102af6:	8b 55 08             	mov    0x8(%ebp),%edx
  102af9:	89 0a                	mov    %ecx,(%edx)
  102afb:	8b 50 04             	mov    0x4(%eax),%edx
  102afe:	8b 00                	mov    (%eax),%eax
  102b00:	eb 28                	jmp    102b2a <getint+0x45>
    }
    else if (lflag) {
  102b02:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102b06:	74 12                	je     102b1a <getint+0x35>
        return va_arg(*ap, long);
  102b08:	8b 45 08             	mov    0x8(%ebp),%eax
  102b0b:	8b 00                	mov    (%eax),%eax
  102b0d:	8d 48 04             	lea    0x4(%eax),%ecx
  102b10:	8b 55 08             	mov    0x8(%ebp),%edx
  102b13:	89 0a                	mov    %ecx,(%edx)
  102b15:	8b 00                	mov    (%eax),%eax
  102b17:	99                   	cltd   
  102b18:	eb 10                	jmp    102b2a <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  102b1d:	8b 00                	mov    (%eax),%eax
  102b1f:	8d 48 04             	lea    0x4(%eax),%ecx
  102b22:	8b 55 08             	mov    0x8(%ebp),%edx
  102b25:	89 0a                	mov    %ecx,(%edx)
  102b27:	8b 00                	mov    (%eax),%eax
  102b29:	99                   	cltd   
    }
}
  102b2a:	5d                   	pop    %ebp
  102b2b:	c3                   	ret    

00102b2c <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102b2c:	55                   	push   %ebp
  102b2d:	89 e5                	mov    %esp,%ebp
  102b2f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102b32:	8d 45 14             	lea    0x14(%ebp),%eax
  102b35:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102b38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102b3f:	8b 45 10             	mov    0x10(%ebp),%eax
  102b42:	89 44 24 08          	mov    %eax,0x8(%esp)
  102b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b49:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b50:	89 04 24             	mov    %eax,(%esp)
  102b53:	e8 02 00 00 00       	call   102b5a <vprintfmt>
    va_end(ap);
}
  102b58:	c9                   	leave  
  102b59:	c3                   	ret    

00102b5a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102b5a:	55                   	push   %ebp
  102b5b:	89 e5                	mov    %esp,%ebp
  102b5d:	56                   	push   %esi
  102b5e:	53                   	push   %ebx
  102b5f:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b62:	eb 18                	jmp    102b7c <vprintfmt+0x22>
            if (ch == '\0') {
  102b64:	85 db                	test   %ebx,%ebx
  102b66:	75 05                	jne    102b6d <vprintfmt+0x13>
                return;
  102b68:	e9 d1 03 00 00       	jmp    102f3e <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b70:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b74:	89 1c 24             	mov    %ebx,(%esp)
  102b77:	8b 45 08             	mov    0x8(%ebp),%eax
  102b7a:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b7c:	8b 45 10             	mov    0x10(%ebp),%eax
  102b7f:	8d 50 01             	lea    0x1(%eax),%edx
  102b82:	89 55 10             	mov    %edx,0x10(%ebp)
  102b85:	0f b6 00             	movzbl (%eax),%eax
  102b88:	0f b6 d8             	movzbl %al,%ebx
  102b8b:	83 fb 25             	cmp    $0x25,%ebx
  102b8e:	75 d4                	jne    102b64 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102b90:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102b94:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102b9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102ba1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102ba8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102bab:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102bae:	8b 45 10             	mov    0x10(%ebp),%eax
  102bb1:	8d 50 01             	lea    0x1(%eax),%edx
  102bb4:	89 55 10             	mov    %edx,0x10(%ebp)
  102bb7:	0f b6 00             	movzbl (%eax),%eax
  102bba:	0f b6 d8             	movzbl %al,%ebx
  102bbd:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102bc0:	83 f8 55             	cmp    $0x55,%eax
  102bc3:	0f 87 44 03 00 00    	ja     102f0d <vprintfmt+0x3b3>
  102bc9:	8b 04 85 b4 3c 10 00 	mov    0x103cb4(,%eax,4),%eax
  102bd0:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102bd2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102bd6:	eb d6                	jmp    102bae <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102bd8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102bdc:	eb d0                	jmp    102bae <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102bde:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102be5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102be8:	89 d0                	mov    %edx,%eax
  102bea:	c1 e0 02             	shl    $0x2,%eax
  102bed:	01 d0                	add    %edx,%eax
  102bef:	01 c0                	add    %eax,%eax
  102bf1:	01 d8                	add    %ebx,%eax
  102bf3:	83 e8 30             	sub    $0x30,%eax
  102bf6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102bf9:	8b 45 10             	mov    0x10(%ebp),%eax
  102bfc:	0f b6 00             	movzbl (%eax),%eax
  102bff:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102c02:	83 fb 2f             	cmp    $0x2f,%ebx
  102c05:	7e 0b                	jle    102c12 <vprintfmt+0xb8>
  102c07:	83 fb 39             	cmp    $0x39,%ebx
  102c0a:	7f 06                	jg     102c12 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102c0c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102c10:	eb d3                	jmp    102be5 <vprintfmt+0x8b>
            goto process_precision;
  102c12:	eb 33                	jmp    102c47 <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102c14:	8b 45 14             	mov    0x14(%ebp),%eax
  102c17:	8d 50 04             	lea    0x4(%eax),%edx
  102c1a:	89 55 14             	mov    %edx,0x14(%ebp)
  102c1d:	8b 00                	mov    (%eax),%eax
  102c1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102c22:	eb 23                	jmp    102c47 <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102c24:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c28:	79 0c                	jns    102c36 <vprintfmt+0xdc>
                width = 0;
  102c2a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102c31:	e9 78 ff ff ff       	jmp    102bae <vprintfmt+0x54>
  102c36:	e9 73 ff ff ff       	jmp    102bae <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102c3b:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102c42:	e9 67 ff ff ff       	jmp    102bae <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102c47:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c4b:	79 12                	jns    102c5f <vprintfmt+0x105>
                width = precision, precision = -1;
  102c4d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c50:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c53:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102c5a:	e9 4f ff ff ff       	jmp    102bae <vprintfmt+0x54>
  102c5f:	e9 4a ff ff ff       	jmp    102bae <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102c64:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102c68:	e9 41 ff ff ff       	jmp    102bae <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102c6d:	8b 45 14             	mov    0x14(%ebp),%eax
  102c70:	8d 50 04             	lea    0x4(%eax),%edx
  102c73:	89 55 14             	mov    %edx,0x14(%ebp)
  102c76:	8b 00                	mov    (%eax),%eax
  102c78:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c7b:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c7f:	89 04 24             	mov    %eax,(%esp)
  102c82:	8b 45 08             	mov    0x8(%ebp),%eax
  102c85:	ff d0                	call   *%eax
            break;
  102c87:	e9 ac 02 00 00       	jmp    102f38 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102c8c:	8b 45 14             	mov    0x14(%ebp),%eax
  102c8f:	8d 50 04             	lea    0x4(%eax),%edx
  102c92:	89 55 14             	mov    %edx,0x14(%ebp)
  102c95:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102c97:	85 db                	test   %ebx,%ebx
  102c99:	79 02                	jns    102c9d <vprintfmt+0x143>
                err = -err;
  102c9b:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102c9d:	83 fb 06             	cmp    $0x6,%ebx
  102ca0:	7f 0b                	jg     102cad <vprintfmt+0x153>
  102ca2:	8b 34 9d 74 3c 10 00 	mov    0x103c74(,%ebx,4),%esi
  102ca9:	85 f6                	test   %esi,%esi
  102cab:	75 23                	jne    102cd0 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102cad:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102cb1:	c7 44 24 08 a1 3c 10 	movl   $0x103ca1,0x8(%esp)
  102cb8:	00 
  102cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc3:	89 04 24             	mov    %eax,(%esp)
  102cc6:	e8 61 fe ff ff       	call   102b2c <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102ccb:	e9 68 02 00 00       	jmp    102f38 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102cd0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102cd4:	c7 44 24 08 aa 3c 10 	movl   $0x103caa,0x8(%esp)
  102cdb:	00 
  102cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce6:	89 04 24             	mov    %eax,(%esp)
  102ce9:	e8 3e fe ff ff       	call   102b2c <printfmt>
            }
            break;
  102cee:	e9 45 02 00 00       	jmp    102f38 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102cf3:	8b 45 14             	mov    0x14(%ebp),%eax
  102cf6:	8d 50 04             	lea    0x4(%eax),%edx
  102cf9:	89 55 14             	mov    %edx,0x14(%ebp)
  102cfc:	8b 30                	mov    (%eax),%esi
  102cfe:	85 f6                	test   %esi,%esi
  102d00:	75 05                	jne    102d07 <vprintfmt+0x1ad>
                p = "(null)";
  102d02:	be ad 3c 10 00       	mov    $0x103cad,%esi
            }
            if (width > 0 && padc != '-') {
  102d07:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d0b:	7e 3e                	jle    102d4b <vprintfmt+0x1f1>
  102d0d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102d11:	74 38                	je     102d4b <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102d13:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102d16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d19:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d1d:	89 34 24             	mov    %esi,(%esp)
  102d20:	e8 15 03 00 00       	call   10303a <strnlen>
  102d25:	29 c3                	sub    %eax,%ebx
  102d27:	89 d8                	mov    %ebx,%eax
  102d29:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102d2c:	eb 17                	jmp    102d45 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102d2e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102d32:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d35:	89 54 24 04          	mov    %edx,0x4(%esp)
  102d39:	89 04 24             	mov    %eax,(%esp)
  102d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d3f:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102d41:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d45:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d49:	7f e3                	jg     102d2e <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d4b:	eb 38                	jmp    102d85 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102d4d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102d51:	74 1f                	je     102d72 <vprintfmt+0x218>
  102d53:	83 fb 1f             	cmp    $0x1f,%ebx
  102d56:	7e 05                	jle    102d5d <vprintfmt+0x203>
  102d58:	83 fb 7e             	cmp    $0x7e,%ebx
  102d5b:	7e 15                	jle    102d72 <vprintfmt+0x218>
                    putch('?', putdat);
  102d5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d60:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d64:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d6e:	ff d0                	call   *%eax
  102d70:	eb 0f                	jmp    102d81 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d75:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d79:	89 1c 24             	mov    %ebx,(%esp)
  102d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d7f:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d81:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d85:	89 f0                	mov    %esi,%eax
  102d87:	8d 70 01             	lea    0x1(%eax),%esi
  102d8a:	0f b6 00             	movzbl (%eax),%eax
  102d8d:	0f be d8             	movsbl %al,%ebx
  102d90:	85 db                	test   %ebx,%ebx
  102d92:	74 10                	je     102da4 <vprintfmt+0x24a>
  102d94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d98:	78 b3                	js     102d4d <vprintfmt+0x1f3>
  102d9a:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102d9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102da2:	79 a9                	jns    102d4d <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102da4:	eb 17                	jmp    102dbd <vprintfmt+0x263>
                putch(' ', putdat);
  102da6:	8b 45 0c             	mov    0xc(%ebp),%eax
  102da9:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dad:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102db4:	8b 45 08             	mov    0x8(%ebp),%eax
  102db7:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102db9:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102dbd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102dc1:	7f e3                	jg     102da6 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102dc3:	e9 70 01 00 00       	jmp    102f38 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102dc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102dcb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dcf:	8d 45 14             	lea    0x14(%ebp),%eax
  102dd2:	89 04 24             	mov    %eax,(%esp)
  102dd5:	e8 0b fd ff ff       	call   102ae5 <getint>
  102dda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ddd:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102de0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102de3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102de6:	85 d2                	test   %edx,%edx
  102de8:	79 26                	jns    102e10 <vprintfmt+0x2b6>
                putch('-', putdat);
  102dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ded:	89 44 24 04          	mov    %eax,0x4(%esp)
  102df1:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102df8:	8b 45 08             	mov    0x8(%ebp),%eax
  102dfb:	ff d0                	call   *%eax
                num = -(long long)num;
  102dfd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e03:	f7 d8                	neg    %eax
  102e05:	83 d2 00             	adc    $0x0,%edx
  102e08:	f7 da                	neg    %edx
  102e0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102e10:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102e17:	e9 a8 00 00 00       	jmp    102ec4 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102e1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e23:	8d 45 14             	lea    0x14(%ebp),%eax
  102e26:	89 04 24             	mov    %eax,(%esp)
  102e29:	e8 68 fc ff ff       	call   102a96 <getuint>
  102e2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e31:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102e34:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102e3b:	e9 84 00 00 00       	jmp    102ec4 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102e40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e43:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e47:	8d 45 14             	lea    0x14(%ebp),%eax
  102e4a:	89 04 24             	mov    %eax,(%esp)
  102e4d:	e8 44 fc ff ff       	call   102a96 <getuint>
  102e52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e55:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102e58:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102e5f:	eb 63                	jmp    102ec4 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102e61:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e64:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e68:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  102e72:	ff d0                	call   *%eax
            putch('x', putdat);
  102e74:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e77:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e7b:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102e82:	8b 45 08             	mov    0x8(%ebp),%eax
  102e85:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102e87:	8b 45 14             	mov    0x14(%ebp),%eax
  102e8a:	8d 50 04             	lea    0x4(%eax),%edx
  102e8d:	89 55 14             	mov    %edx,0x14(%ebp)
  102e90:	8b 00                	mov    (%eax),%eax
  102e92:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102e9c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102ea3:	eb 1f                	jmp    102ec4 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102ea5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102ea8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eac:	8d 45 14             	lea    0x14(%ebp),%eax
  102eaf:	89 04 24             	mov    %eax,(%esp)
  102eb2:	e8 df fb ff ff       	call   102a96 <getuint>
  102eb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102eba:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102ebd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102ec4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102ec8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ecb:	89 54 24 18          	mov    %edx,0x18(%esp)
  102ecf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102ed2:	89 54 24 14          	mov    %edx,0x14(%esp)
  102ed6:	89 44 24 10          	mov    %eax,0x10(%esp)
  102eda:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102edd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102ee0:	89 44 24 08          	mov    %eax,0x8(%esp)
  102ee4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102ee8:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eeb:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eef:	8b 45 08             	mov    0x8(%ebp),%eax
  102ef2:	89 04 24             	mov    %eax,(%esp)
  102ef5:	e8 97 fa ff ff       	call   102991 <printnum>
            break;
  102efa:	eb 3c                	jmp    102f38 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102efc:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eff:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f03:	89 1c 24             	mov    %ebx,(%esp)
  102f06:	8b 45 08             	mov    0x8(%ebp),%eax
  102f09:	ff d0                	call   *%eax
            break;
  102f0b:	eb 2b                	jmp    102f38 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102f0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f10:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f14:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102f1b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f1e:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102f20:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102f24:	eb 04                	jmp    102f2a <vprintfmt+0x3d0>
  102f26:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102f2a:	8b 45 10             	mov    0x10(%ebp),%eax
  102f2d:	83 e8 01             	sub    $0x1,%eax
  102f30:	0f b6 00             	movzbl (%eax),%eax
  102f33:	3c 25                	cmp    $0x25,%al
  102f35:	75 ef                	jne    102f26 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  102f37:	90                   	nop
        }
    }
  102f38:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102f39:	e9 3e fc ff ff       	jmp    102b7c <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  102f3e:	83 c4 40             	add    $0x40,%esp
  102f41:	5b                   	pop    %ebx
  102f42:	5e                   	pop    %esi
  102f43:	5d                   	pop    %ebp
  102f44:	c3                   	ret    

00102f45 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102f45:	55                   	push   %ebp
  102f46:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102f48:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f4b:	8b 40 08             	mov    0x8(%eax),%eax
  102f4e:	8d 50 01             	lea    0x1(%eax),%edx
  102f51:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f54:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102f57:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f5a:	8b 10                	mov    (%eax),%edx
  102f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f5f:	8b 40 04             	mov    0x4(%eax),%eax
  102f62:	39 c2                	cmp    %eax,%edx
  102f64:	73 12                	jae    102f78 <sprintputch+0x33>
        *b->buf ++ = ch;
  102f66:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f69:	8b 00                	mov    (%eax),%eax
  102f6b:	8d 48 01             	lea    0x1(%eax),%ecx
  102f6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f71:	89 0a                	mov    %ecx,(%edx)
  102f73:	8b 55 08             	mov    0x8(%ebp),%edx
  102f76:	88 10                	mov    %dl,(%eax)
    }
}
  102f78:	5d                   	pop    %ebp
  102f79:	c3                   	ret    

00102f7a <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102f7a:	55                   	push   %ebp
  102f7b:	89 e5                	mov    %esp,%ebp
  102f7d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102f80:	8d 45 14             	lea    0x14(%ebp),%eax
  102f83:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102f86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f89:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  102f90:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f94:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f97:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f9e:	89 04 24             	mov    %eax,(%esp)
  102fa1:	e8 08 00 00 00       	call   102fae <vsnprintf>
  102fa6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102fac:	c9                   	leave  
  102fad:	c3                   	ret    

00102fae <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102fae:	55                   	push   %ebp
  102faf:	89 e5                	mov    %esp,%ebp
  102fb1:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  102fb7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102fba:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fbd:	8d 50 ff             	lea    -0x1(%eax),%edx
  102fc0:	8b 45 08             	mov    0x8(%ebp),%eax
  102fc3:	01 d0                	add    %edx,%eax
  102fc5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fc8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102fcf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102fd3:	74 0a                	je     102fdf <vsnprintf+0x31>
  102fd5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fdb:	39 c2                	cmp    %eax,%edx
  102fdd:	76 07                	jbe    102fe6 <vsnprintf+0x38>
        return -E_INVAL;
  102fdf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102fe4:	eb 2a                	jmp    103010 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102fe6:	8b 45 14             	mov    0x14(%ebp),%eax
  102fe9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102fed:	8b 45 10             	mov    0x10(%ebp),%eax
  102ff0:	89 44 24 08          	mov    %eax,0x8(%esp)
  102ff4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102ff7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ffb:	c7 04 24 45 2f 10 00 	movl   $0x102f45,(%esp)
  103002:	e8 53 fb ff ff       	call   102b5a <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  103007:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10300a:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10300d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103010:	c9                   	leave  
  103011:	c3                   	ret    

00103012 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  103012:	55                   	push   %ebp
  103013:	89 e5                	mov    %esp,%ebp
  103015:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  103018:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  10301f:	eb 04                	jmp    103025 <strlen+0x13>
        cnt ++;
  103021:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  103025:	8b 45 08             	mov    0x8(%ebp),%eax
  103028:	8d 50 01             	lea    0x1(%eax),%edx
  10302b:	89 55 08             	mov    %edx,0x8(%ebp)
  10302e:	0f b6 00             	movzbl (%eax),%eax
  103031:	84 c0                	test   %al,%al
  103033:	75 ec                	jne    103021 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  103035:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103038:	c9                   	leave  
  103039:	c3                   	ret    

0010303a <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  10303a:	55                   	push   %ebp
  10303b:	89 e5                	mov    %esp,%ebp
  10303d:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  103040:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  103047:	eb 04                	jmp    10304d <strnlen+0x13>
        cnt ++;
  103049:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  10304d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103050:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103053:	73 10                	jae    103065 <strnlen+0x2b>
  103055:	8b 45 08             	mov    0x8(%ebp),%eax
  103058:	8d 50 01             	lea    0x1(%eax),%edx
  10305b:	89 55 08             	mov    %edx,0x8(%ebp)
  10305e:	0f b6 00             	movzbl (%eax),%eax
  103061:	84 c0                	test   %al,%al
  103063:	75 e4                	jne    103049 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  103065:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  103068:	c9                   	leave  
  103069:	c3                   	ret    

0010306a <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10306a:	55                   	push   %ebp
  10306b:	89 e5                	mov    %esp,%ebp
  10306d:	57                   	push   %edi
  10306e:	56                   	push   %esi
  10306f:	83 ec 20             	sub    $0x20,%esp
  103072:	8b 45 08             	mov    0x8(%ebp),%eax
  103075:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103078:	8b 45 0c             	mov    0xc(%ebp),%eax
  10307b:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10307e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103084:	89 d1                	mov    %edx,%ecx
  103086:	89 c2                	mov    %eax,%edx
  103088:	89 ce                	mov    %ecx,%esi
  10308a:	89 d7                	mov    %edx,%edi
  10308c:	ac                   	lods   %ds:(%esi),%al
  10308d:	aa                   	stos   %al,%es:(%edi)
  10308e:	84 c0                	test   %al,%al
  103090:	75 fa                	jne    10308c <strcpy+0x22>
  103092:	89 fa                	mov    %edi,%edx
  103094:	89 f1                	mov    %esi,%ecx
  103096:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103099:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10309c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  10309f:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  1030a2:	83 c4 20             	add    $0x20,%esp
  1030a5:	5e                   	pop    %esi
  1030a6:	5f                   	pop    %edi
  1030a7:	5d                   	pop    %ebp
  1030a8:	c3                   	ret    

001030a9 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  1030a9:	55                   	push   %ebp
  1030aa:	89 e5                	mov    %esp,%ebp
  1030ac:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  1030af:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  1030b5:	eb 21                	jmp    1030d8 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  1030b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030ba:	0f b6 10             	movzbl (%eax),%edx
  1030bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030c0:	88 10                	mov    %dl,(%eax)
  1030c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030c5:	0f b6 00             	movzbl (%eax),%eax
  1030c8:	84 c0                	test   %al,%al
  1030ca:	74 04                	je     1030d0 <strncpy+0x27>
            src ++;
  1030cc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  1030d0:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1030d4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  1030d8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030dc:	75 d9                	jne    1030b7 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  1030de:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1030e1:	c9                   	leave  
  1030e2:	c3                   	ret    

001030e3 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1030e3:	55                   	push   %ebp
  1030e4:	89 e5                	mov    %esp,%ebp
  1030e6:	57                   	push   %edi
  1030e7:	56                   	push   %esi
  1030e8:	83 ec 20             	sub    $0x20,%esp
  1030eb:	8b 45 08             	mov    0x8(%ebp),%eax
  1030ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1030f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030fd:	89 d1                	mov    %edx,%ecx
  1030ff:	89 c2                	mov    %eax,%edx
  103101:	89 ce                	mov    %ecx,%esi
  103103:	89 d7                	mov    %edx,%edi
  103105:	ac                   	lods   %ds:(%esi),%al
  103106:	ae                   	scas   %es:(%edi),%al
  103107:	75 08                	jne    103111 <strcmp+0x2e>
  103109:	84 c0                	test   %al,%al
  10310b:	75 f8                	jne    103105 <strcmp+0x22>
  10310d:	31 c0                	xor    %eax,%eax
  10310f:	eb 04                	jmp    103115 <strcmp+0x32>
  103111:	19 c0                	sbb    %eax,%eax
  103113:	0c 01                	or     $0x1,%al
  103115:	89 fa                	mov    %edi,%edx
  103117:	89 f1                	mov    %esi,%ecx
  103119:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10311c:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  10311f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  103122:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  103125:	83 c4 20             	add    $0x20,%esp
  103128:	5e                   	pop    %esi
  103129:	5f                   	pop    %edi
  10312a:	5d                   	pop    %ebp
  10312b:	c3                   	ret    

0010312c <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  10312c:	55                   	push   %ebp
  10312d:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10312f:	eb 0c                	jmp    10313d <strncmp+0x11>
        n --, s1 ++, s2 ++;
  103131:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  103135:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  103139:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  10313d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103141:	74 1a                	je     10315d <strncmp+0x31>
  103143:	8b 45 08             	mov    0x8(%ebp),%eax
  103146:	0f b6 00             	movzbl (%eax),%eax
  103149:	84 c0                	test   %al,%al
  10314b:	74 10                	je     10315d <strncmp+0x31>
  10314d:	8b 45 08             	mov    0x8(%ebp),%eax
  103150:	0f b6 10             	movzbl (%eax),%edx
  103153:	8b 45 0c             	mov    0xc(%ebp),%eax
  103156:	0f b6 00             	movzbl (%eax),%eax
  103159:	38 c2                	cmp    %al,%dl
  10315b:	74 d4                	je     103131 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  10315d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103161:	74 18                	je     10317b <strncmp+0x4f>
  103163:	8b 45 08             	mov    0x8(%ebp),%eax
  103166:	0f b6 00             	movzbl (%eax),%eax
  103169:	0f b6 d0             	movzbl %al,%edx
  10316c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10316f:	0f b6 00             	movzbl (%eax),%eax
  103172:	0f b6 c0             	movzbl %al,%eax
  103175:	29 c2                	sub    %eax,%edx
  103177:	89 d0                	mov    %edx,%eax
  103179:	eb 05                	jmp    103180 <strncmp+0x54>
  10317b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103180:	5d                   	pop    %ebp
  103181:	c3                   	ret    

00103182 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103182:	55                   	push   %ebp
  103183:	89 e5                	mov    %esp,%ebp
  103185:	83 ec 04             	sub    $0x4,%esp
  103188:	8b 45 0c             	mov    0xc(%ebp),%eax
  10318b:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10318e:	eb 14                	jmp    1031a4 <strchr+0x22>
        if (*s == c) {
  103190:	8b 45 08             	mov    0x8(%ebp),%eax
  103193:	0f b6 00             	movzbl (%eax),%eax
  103196:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103199:	75 05                	jne    1031a0 <strchr+0x1e>
            return (char *)s;
  10319b:	8b 45 08             	mov    0x8(%ebp),%eax
  10319e:	eb 13                	jmp    1031b3 <strchr+0x31>
        }
        s ++;
  1031a0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  1031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1031a7:	0f b6 00             	movzbl (%eax),%eax
  1031aa:	84 c0                	test   %al,%al
  1031ac:	75 e2                	jne    103190 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  1031ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1031b3:	c9                   	leave  
  1031b4:	c3                   	ret    

001031b5 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  1031b5:	55                   	push   %ebp
  1031b6:	89 e5                	mov    %esp,%ebp
  1031b8:	83 ec 04             	sub    $0x4,%esp
  1031bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1031be:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  1031c1:	eb 11                	jmp    1031d4 <strfind+0x1f>
        if (*s == c) {
  1031c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1031c6:	0f b6 00             	movzbl (%eax),%eax
  1031c9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  1031cc:	75 02                	jne    1031d0 <strfind+0x1b>
            break;
  1031ce:	eb 0e                	jmp    1031de <strfind+0x29>
        }
        s ++;
  1031d0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  1031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d7:	0f b6 00             	movzbl (%eax),%eax
  1031da:	84 c0                	test   %al,%al
  1031dc:	75 e5                	jne    1031c3 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  1031de:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1031e1:	c9                   	leave  
  1031e2:	c3                   	ret    

001031e3 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1031e3:	55                   	push   %ebp
  1031e4:	89 e5                	mov    %esp,%ebp
  1031e6:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1031e9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1031f0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1031f7:	eb 04                	jmp    1031fd <strtol+0x1a>
        s ++;
  1031f9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1031fd:	8b 45 08             	mov    0x8(%ebp),%eax
  103200:	0f b6 00             	movzbl (%eax),%eax
  103203:	3c 20                	cmp    $0x20,%al
  103205:	74 f2                	je     1031f9 <strtol+0x16>
  103207:	8b 45 08             	mov    0x8(%ebp),%eax
  10320a:	0f b6 00             	movzbl (%eax),%eax
  10320d:	3c 09                	cmp    $0x9,%al
  10320f:	74 e8                	je     1031f9 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  103211:	8b 45 08             	mov    0x8(%ebp),%eax
  103214:	0f b6 00             	movzbl (%eax),%eax
  103217:	3c 2b                	cmp    $0x2b,%al
  103219:	75 06                	jne    103221 <strtol+0x3e>
        s ++;
  10321b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10321f:	eb 15                	jmp    103236 <strtol+0x53>
    }
    else if (*s == '-') {
  103221:	8b 45 08             	mov    0x8(%ebp),%eax
  103224:	0f b6 00             	movzbl (%eax),%eax
  103227:	3c 2d                	cmp    $0x2d,%al
  103229:	75 0b                	jne    103236 <strtol+0x53>
        s ++, neg = 1;
  10322b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10322f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  103236:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10323a:	74 06                	je     103242 <strtol+0x5f>
  10323c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  103240:	75 24                	jne    103266 <strtol+0x83>
  103242:	8b 45 08             	mov    0x8(%ebp),%eax
  103245:	0f b6 00             	movzbl (%eax),%eax
  103248:	3c 30                	cmp    $0x30,%al
  10324a:	75 1a                	jne    103266 <strtol+0x83>
  10324c:	8b 45 08             	mov    0x8(%ebp),%eax
  10324f:	83 c0 01             	add    $0x1,%eax
  103252:	0f b6 00             	movzbl (%eax),%eax
  103255:	3c 78                	cmp    $0x78,%al
  103257:	75 0d                	jne    103266 <strtol+0x83>
        s += 2, base = 16;
  103259:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  10325d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  103264:	eb 2a                	jmp    103290 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  103266:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10326a:	75 17                	jne    103283 <strtol+0xa0>
  10326c:	8b 45 08             	mov    0x8(%ebp),%eax
  10326f:	0f b6 00             	movzbl (%eax),%eax
  103272:	3c 30                	cmp    $0x30,%al
  103274:	75 0d                	jne    103283 <strtol+0xa0>
        s ++, base = 8;
  103276:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10327a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103281:	eb 0d                	jmp    103290 <strtol+0xad>
    }
    else if (base == 0) {
  103283:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103287:	75 07                	jne    103290 <strtol+0xad>
        base = 10;
  103289:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103290:	8b 45 08             	mov    0x8(%ebp),%eax
  103293:	0f b6 00             	movzbl (%eax),%eax
  103296:	3c 2f                	cmp    $0x2f,%al
  103298:	7e 1b                	jle    1032b5 <strtol+0xd2>
  10329a:	8b 45 08             	mov    0x8(%ebp),%eax
  10329d:	0f b6 00             	movzbl (%eax),%eax
  1032a0:	3c 39                	cmp    $0x39,%al
  1032a2:	7f 11                	jg     1032b5 <strtol+0xd2>
            dig = *s - '0';
  1032a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a7:	0f b6 00             	movzbl (%eax),%eax
  1032aa:	0f be c0             	movsbl %al,%eax
  1032ad:	83 e8 30             	sub    $0x30,%eax
  1032b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1032b3:	eb 48                	jmp    1032fd <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  1032b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1032b8:	0f b6 00             	movzbl (%eax),%eax
  1032bb:	3c 60                	cmp    $0x60,%al
  1032bd:	7e 1b                	jle    1032da <strtol+0xf7>
  1032bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1032c2:	0f b6 00             	movzbl (%eax),%eax
  1032c5:	3c 7a                	cmp    $0x7a,%al
  1032c7:	7f 11                	jg     1032da <strtol+0xf7>
            dig = *s - 'a' + 10;
  1032c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1032cc:	0f b6 00             	movzbl (%eax),%eax
  1032cf:	0f be c0             	movsbl %al,%eax
  1032d2:	83 e8 57             	sub    $0x57,%eax
  1032d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1032d8:	eb 23                	jmp    1032fd <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  1032da:	8b 45 08             	mov    0x8(%ebp),%eax
  1032dd:	0f b6 00             	movzbl (%eax),%eax
  1032e0:	3c 40                	cmp    $0x40,%al
  1032e2:	7e 3d                	jle    103321 <strtol+0x13e>
  1032e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1032e7:	0f b6 00             	movzbl (%eax),%eax
  1032ea:	3c 5a                	cmp    $0x5a,%al
  1032ec:	7f 33                	jg     103321 <strtol+0x13e>
            dig = *s - 'A' + 10;
  1032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1032f1:	0f b6 00             	movzbl (%eax),%eax
  1032f4:	0f be c0             	movsbl %al,%eax
  1032f7:	83 e8 37             	sub    $0x37,%eax
  1032fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1032fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103300:	3b 45 10             	cmp    0x10(%ebp),%eax
  103303:	7c 02                	jl     103307 <strtol+0x124>
            break;
  103305:	eb 1a                	jmp    103321 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  103307:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10330b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10330e:	0f af 45 10          	imul   0x10(%ebp),%eax
  103312:	89 c2                	mov    %eax,%edx
  103314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103317:	01 d0                	add    %edx,%eax
  103319:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  10331c:	e9 6f ff ff ff       	jmp    103290 <strtol+0xad>

    if (endptr) {
  103321:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  103325:	74 08                	je     10332f <strtol+0x14c>
        *endptr = (char *) s;
  103327:	8b 45 0c             	mov    0xc(%ebp),%eax
  10332a:	8b 55 08             	mov    0x8(%ebp),%edx
  10332d:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  10332f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  103333:	74 07                	je     10333c <strtol+0x159>
  103335:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103338:	f7 d8                	neg    %eax
  10333a:	eb 03                	jmp    10333f <strtol+0x15c>
  10333c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10333f:	c9                   	leave  
  103340:	c3                   	ret    

00103341 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  103341:	55                   	push   %ebp
  103342:	89 e5                	mov    %esp,%ebp
  103344:	57                   	push   %edi
  103345:	83 ec 24             	sub    $0x24,%esp
  103348:	8b 45 0c             	mov    0xc(%ebp),%eax
  10334b:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10334e:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  103352:	8b 55 08             	mov    0x8(%ebp),%edx
  103355:	89 55 f8             	mov    %edx,-0x8(%ebp)
  103358:	88 45 f7             	mov    %al,-0x9(%ebp)
  10335b:	8b 45 10             	mov    0x10(%ebp),%eax
  10335e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103361:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  103364:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  103368:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10336b:	89 d7                	mov    %edx,%edi
  10336d:	f3 aa                	rep stos %al,%es:(%edi)
  10336f:	89 fa                	mov    %edi,%edx
  103371:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103374:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  103377:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10337a:	83 c4 24             	add    $0x24,%esp
  10337d:	5f                   	pop    %edi
  10337e:	5d                   	pop    %ebp
  10337f:	c3                   	ret    

00103380 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103380:	55                   	push   %ebp
  103381:	89 e5                	mov    %esp,%ebp
  103383:	57                   	push   %edi
  103384:	56                   	push   %esi
  103385:	53                   	push   %ebx
  103386:	83 ec 30             	sub    $0x30,%esp
  103389:	8b 45 08             	mov    0x8(%ebp),%eax
  10338c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10338f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103392:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103395:	8b 45 10             	mov    0x10(%ebp),%eax
  103398:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10339b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10339e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1033a1:	73 42                	jae    1033e5 <memmove+0x65>
  1033a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1033a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033ac:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1033af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1033b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1033b8:	c1 e8 02             	shr    $0x2,%eax
  1033bb:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1033bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1033c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033c3:	89 d7                	mov    %edx,%edi
  1033c5:	89 c6                	mov    %eax,%esi
  1033c7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1033c9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1033cc:	83 e1 03             	and    $0x3,%ecx
  1033cf:	74 02                	je     1033d3 <memmove+0x53>
  1033d1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033d3:	89 f0                	mov    %esi,%eax
  1033d5:	89 fa                	mov    %edi,%edx
  1033d7:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  1033da:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1033dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  1033e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1033e3:	eb 36                	jmp    10341b <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1033e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1033eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033ee:	01 c2                	add    %eax,%edx
  1033f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033f3:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1033f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033f9:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1033fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033ff:	89 c1                	mov    %eax,%ecx
  103401:	89 d8                	mov    %ebx,%eax
  103403:	89 d6                	mov    %edx,%esi
  103405:	89 c7                	mov    %eax,%edi
  103407:	fd                   	std    
  103408:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10340a:	fc                   	cld    
  10340b:	89 f8                	mov    %edi,%eax
  10340d:	89 f2                	mov    %esi,%edx
  10340f:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103412:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103415:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  103418:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10341b:	83 c4 30             	add    $0x30,%esp
  10341e:	5b                   	pop    %ebx
  10341f:	5e                   	pop    %esi
  103420:	5f                   	pop    %edi
  103421:	5d                   	pop    %ebp
  103422:	c3                   	ret    

00103423 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  103423:	55                   	push   %ebp
  103424:	89 e5                	mov    %esp,%ebp
  103426:	57                   	push   %edi
  103427:	56                   	push   %esi
  103428:	83 ec 20             	sub    $0x20,%esp
  10342b:	8b 45 08             	mov    0x8(%ebp),%eax
  10342e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103431:	8b 45 0c             	mov    0xc(%ebp),%eax
  103434:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103437:	8b 45 10             	mov    0x10(%ebp),%eax
  10343a:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10343d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103440:	c1 e8 02             	shr    $0x2,%eax
  103443:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103445:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10344b:	89 d7                	mov    %edx,%edi
  10344d:	89 c6                	mov    %eax,%esi
  10344f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103451:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103454:	83 e1 03             	and    $0x3,%ecx
  103457:	74 02                	je     10345b <memcpy+0x38>
  103459:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10345b:	89 f0                	mov    %esi,%eax
  10345d:	89 fa                	mov    %edi,%edx
  10345f:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103462:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  103465:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103468:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10346b:	83 c4 20             	add    $0x20,%esp
  10346e:	5e                   	pop    %esi
  10346f:	5f                   	pop    %edi
  103470:	5d                   	pop    %ebp
  103471:	c3                   	ret    

00103472 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103472:	55                   	push   %ebp
  103473:	89 e5                	mov    %esp,%ebp
  103475:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103478:	8b 45 08             	mov    0x8(%ebp),%eax
  10347b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10347e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103481:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103484:	eb 30                	jmp    1034b6 <memcmp+0x44>
        if (*s1 != *s2) {
  103486:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103489:	0f b6 10             	movzbl (%eax),%edx
  10348c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10348f:	0f b6 00             	movzbl (%eax),%eax
  103492:	38 c2                	cmp    %al,%dl
  103494:	74 18                	je     1034ae <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103496:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103499:	0f b6 00             	movzbl (%eax),%eax
  10349c:	0f b6 d0             	movzbl %al,%edx
  10349f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1034a2:	0f b6 00             	movzbl (%eax),%eax
  1034a5:	0f b6 c0             	movzbl %al,%eax
  1034a8:	29 c2                	sub    %eax,%edx
  1034aa:	89 d0                	mov    %edx,%eax
  1034ac:	eb 1a                	jmp    1034c8 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  1034ae:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1034b2:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  1034b6:	8b 45 10             	mov    0x10(%ebp),%eax
  1034b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1034bc:	89 55 10             	mov    %edx,0x10(%ebp)
  1034bf:	85 c0                	test   %eax,%eax
  1034c1:	75 c3                	jne    103486 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  1034c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1034c8:	c9                   	leave  
  1034c9:	c3                   	ret    
