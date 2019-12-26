#!/bin/sh

#mine branch features:
# bdwgc support
# fix voidptr print
# simple not fetch makefile

# builtin_bdwgc.v
# git checkout mine vlib/builtin/builtin_bdwgc.v

# run about 10s
files=$(find -type f | grep "\.v"| grep -v "cfns\.v"| grep -v bdwgc)
for f in $files; do
    echo "$f"
    # break
    sed -i 's/C.free/free3/g' "$f"
    sed -i 's/C.malloc/malloc3/g' "$f"
    sed -i 's/C.realloc/realloc3/g' "$f"
    sed -i 's/C.calloc/calloc3/g' "$f"

done

# add gc_init() to v generated main()
sed -i 's/  init();/  gc_init(); init();/g' "vlib/compiler/main.v"
# _STR use raw malloc, replace it
sed -i 's/byte\* buf = malloc(len);/byte\* buf = malloc3(len);/g' "vlib/compiler/main.v"
# memdup in gen_c.v:518
sed -i 's/)memdup(/)memdup3(/g' 'vlib/compiler/gen_c.v'

