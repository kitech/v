
https://kitech.github.io/v/

### Vlang dialect, with features highlight:

* c99 embed block, `c99 { int foo = 42; }`
* auto capture closure/anonymous variables
* `@[importc]` no body func/method support
* func/method missing feature
* VLA array support, `arr := [lenvar]string{}`
* extend builtin type method on non-local module
* `const _ = foo()` support, ensure foo() called
* log.{info,warn,error,debug} with file:line default
* add \_\_VCMOD\_\_ C define when compile module .c file
* relax module scope global variables,
* relax camelCase func/method name
* relax mut, with all mut
* relax unsafe usage
* relax nil usage
* complie rust .rs to .o support

Latest repo [v-rlx-0.5.0-6c46fdd6a](https://github.com/kitech/v/tree/v-rlx-0.5.0-6c46fdd6a)
