module builtin

#flag -lgc
#flag -DGC_THREADS -DREDIRECT_MALLOC=Gmalloc3 -DIGNORE_FREE
#include "gc.h"
// #flag -I/home/me/oss/src/cxrt/bdwgc/include
// #flag -L/home/me/oss/src/cxrt/bdwgc/.libs

fn C.GC_free(voidptr)
fn C.GC_malloc(int) byteptr
fn C.GC_malloc_uncollectable(int) voidptr
fn C.GC_realloc(byteptr, int) byteptr
fn C.GC_init()
fn C.GC_deinit()
fn C.GC_enable()
fn C.GC_disable()
fn C.GC_is_visible() int
fn C.GC_dump()
fn C.GC_dump_named(byteptr)
fn C.GC_is_disabled() int
fn C.GC_is_init_called() int
fn C.GC_allow_register_threads()
fn C.GC_thread_is_registered() int
fn C.GC_register_my_thread(stkbase voidptr) int
fn C.GC_unregister_my_thread() int
fn C.GC_set_free_space_divisor(int)
fn C.GC_set_dont_precollect(int)
fn C.GC_set_dont_expand(int)
fn C.GC_gcollect()
fn C.GC_is_heap_ptr(voidptr) int
fn C.GC_size(voidptr) int
fn C.GC_strdup(byteptr) byteptr
fn C.GC_strndup(byteptr, int) byteptr
fn C.GC_call_with_alloc_lock(fnptr voidptr, cbval voidptr) voidptr
// >= libgc 8.0.4
fn C.GC_get_my_stackbottom(stkbase voidptr) /*handle*/ voidptr
fn C.GC_set_stackbottom(handle voidptr, stkbase voidptr)
// >= libgc 8.2.0
fn C.GC_alloc_lock()
fn C.GC_alloc_unlock()


// compiler complain implicit declaration of function ‘voidptr_str’
pub fn voidptr_str(ptr voidptr) string { return ptr_str(ptr) }

pub fn mallocraw(n int) voidptr { return C.malloc(n) }

pub fn realloc3(ptr voidptr, n int) voidptr {
	return C.GC_realloc(ptr, n)
}
pub fn malloc3(n int) byteptr {
	if false {
		panic('malloc3')
	}
	return C.GC_malloc(n)
}
pub fn calloc3(n int, sz int) byteptr {
	if false {
		memcpy(voidptr(1), voidptr(2), 100)
	}
	return C.GC_malloc(n*sz)
}
pub fn free3(ptr voidptr) {
	// GC_free(ptr)
	GC_free(ptr)
}
pub fn malloc_uncollectable(n int) voidptr {
	return C.GC_malloc_uncollectable(n)
}
pub fn memdup3(ptr voidptr, sz int) voidptr {
	newptr := malloc3(sz)
	C.memcpy(newptr, ptr, sz)
	return newptr
}

// call at vlib/compiler/main.v:gen_main_start
pub fn gc_init() {
	C.GC_set_free_space_divisor(30) // default 3
	C.GC_set_dont_precollect(1)
	C.GC_set_dont_expand(1)
	inited := C.GC_is_init_called()
	// println('gc_init $inited')
	if inited == 0 { C.GC_init() }
	C.GC_allow_register_threads()
}
pub fn gc_deinit() {
	inited := C.GC_is_init_called()
	if inited == 1 { C.GC_deinit() }
}
pub fn gc_enable() { C.GC_enable() }
pub fn gc_disable() { C.GC_disable() }
pub fn gc_enabled() bool { return C.GC_is_disabled()==0 }
pub fn gc_is_visible(ptr voidptr) bool { return C.GC_is_visible(ptr) == 1 }
pub fn gc_thread_is_registed() bool { return C.GC_thread_is_registered() == 1 }
pub fn gc_register_mythread(stkbase &StackBase) bool { return C.GC_register_my_thread(stkbase) == 1 }
pub fn gc_unregister_mythread() bool { return C.GC_unregister_my_thread() == 1 }
pub fn gc_dump() { C.GC_dump() }
pub fn gc_dump_named(name string) { C.GC_dump_named(name.str) }

pub fn gc_collect() { C.GC_gcollect() }
pub fn gc_is_heap_ptr(ptr voidptr) bool { return C.GC_is_heap_ptr(ptr) == 1 }
pub fn gc_size(ptr voidptr) int { return C.GC_size(ptr) }
pub fn gc_strdup(ptr byteptr) byteptr { return C.GC_strdup(ptr) }
pub fn gc_strndup(ptr byteptr, n int) byteptr { return C.GC_strndup(ptr, n) }

pub fn gc_call_withlock(fnptr fn(voidptr) voidptr, cbval voidptr) voidptr {
	rv := C.GC_call_with_alloc_lock(fnptr, cbval)
	return rv
}

// >= libgc 8.0.4
pub struct StackBase {
mut:
	mem_base voidptr
	reg_base voidptr // conditional field
}
pub fn gc_get_my_stackbottom(stkbase &StackBase) voidptr {
	mut thhandle := voidptr(0)
	thhandle = C.GC_get_my_stackbottom(stkbase)
	return thhandle
}
pub fn gc_set_stackbottom(handle voidptr, stkbase &StackBase) {
	C.GC_set_stackbottom(handle, stkbase)
}
// >= libgc 8.2
pub fn gc_lock() {
	// C.GC_alloc_lock()
	1+2
}
pub fn gc_unlock() {
	// C.GC_alloc_unlock()
	2+3
}

///// check some default values
fn C.GC_get_all_interior_pointers() int
fn C.GC_get_finalize_on_demand() int
fn C.GC_get_await_finalize_proc() voidptr
fn C.GC_get_bytes_since_gc() int
fn C.GC_get_dont_expand() int
fn C.GC_get_dont_precollect() int
fn C.GC_get_free_space_divisor() int
fn C.GC_get_full_freq() int
fn C.GC_get_full_gc_total_time() int
fn C.GC_get_gc_no() int
fn C.GC_get_heap_size() int
fn C.GC_get_memory_use() int
fn C.GC_get_version() int
fn C.GC_get_total_bytes() int
fn C.GC_get_parallel() int

/////

pub struct Gcstats1 {
mut:
	// vars map[string]int
	vars []string
	useit_ int
}

pub fn gc_dump_vars() {
	gcstats := gc_get_stats(1)
	/*
	for name, val in gcstats.vars {
		println('gcvar $name=$val')
	}
    */
	for kv in gcstats.vars {
		println(kv)
	}
}
pub fn gc_get_stats(dival int) &Gcstats1 {
	// assert dival > 0
	mut vars := map[string]int

	// big change rate
	vars['01 bytes_since_gc'] = C.GC_get_bytes_since_gc()/dival
	vars['02 memory_use'] = C.GC_get_memory_use()/dival
	vars['03 total_bytes'] = C.GC_get_total_bytes()/dival
	vars['04 gc_no'] = C.GC_get_gc_no()
	vars['05 heap_size'] = C.GC_get_heap_size()/dival

	vars['06 all_interior_pointers'] = C.GC_get_all_interior_pointers()
	vars['07 finalize_on_demand'] = C.GC_get_finalize_on_demand()
	vars['08 await_finalize_proc'] = C.GC_get_await_finalize_proc()
	vars['09 dont_expand'] = C.GC_get_dont_expand()
	vars['10 dont_precollect'] = C.GC_get_dont_precollect()
	vars['11 free_space_divisor'] = C.GC_get_free_space_divisor()
	vars['12 full_freq'] = C.GC_get_full_freq()
	vars['13 full_gc_total_time'] = C.GC_get_full_gc_total_time()
	vars['14 version'] = C.GC_get_version()
	vars['16 parrallel'] = C.GC_get_parallel()
	version := C.GC_get_version()
	major := version >> 16
	minor := (version << 16 ) >> 24
	patch := (version << 24) >> 24
	// vars['16 version str'] = major.str()+'.'+minor.str()+'.'+patch.str()

	mut gcstats := &Gcstats1{}
	for name, val in vars {
		gcstats.vars << 'gcvar $name=$val'
	}
	gcstats.vars << 'gcvar 15 version str ' + major.str()+'.'+minor.str()+'.'+patch.str()
	return gcstats
}
