#!/bin/bash

BASE_DIR="build-html5/cl_dll"

find "$BASE_DIR" -name '*.o' | while IFS= read -r obj_file; do
    js_file="${obj_file%.o}.js"
    
    # Compile .o file to .js using Emscripten
    emcc -o "$js_file" "$obj_file" -s WASM=0
    echo "Compiled $obj_file to $js_file"
done
