module os

//

// FnWalkContextCB is used to define the callback functions, passed to os.walk_context
pub type FnWalkExitCB = fn (voidptr, string) bool

// walk_with_context traverses the given directory `path`.
// For each encountered file *and* directory, it will call your `fcb` callback,
// passing it the arbitrary `context` in its first parameter,
// and the path to the file in its second parameter.
// Note: walk_with_context can be called even for deeply nested folders,
// since it does not recurse, but processes them iteratively.
// For listing only one level deep, see: `os.ls`
pub fn walk_with_exit(path string, context voidptr, fcb FnWalkExitCB) {
	if path == '' {
		return
	}
	if !is_dir(path) {
		return
	}
	mut remaining := []string{cap: 1000}
	clean_path := path.trim_right(path_separator)
	$if windows {
		remaining << clean_path.replace('/', '\\')
	} $else {
		remaining << clean_path
	}
	mut loops := 0
	for remaining.len > 0 {
		loops++
		cpath := remaining.pop()
		// call `fcb` for everything, but the initial folder:
		if loops > 1 {
			cok := fcb(context, cpath)
			if !cok { break }
		}
		pkind := kind_of_existing_path(cpath)
		if pkind.is_link || !pkind.is_dir {
			continue
		}
		mut files := ls(cpath) or { continue }
		for idx := files.len - 1; idx >= 0; idx-- {
			remaining << cpath + path_separator + files[idx]
		}
	}
}
