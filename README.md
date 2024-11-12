# lune-lightningcss

Simple [lightningcss](https://github.com/parcel-bundler/lightningcss) wrapper for lune runtime, with ffi edge feature.

## Example usage

Run `cargo build --profile=release` first to get shared object.

```luau
local lightningcss = require("./")
    .new("./target/release/liblune_lightningcss.so")

local result = lightningcss:minify([[
    body > .asdf {
        background-color: rgb(123, 89, 231);
    }
]])

print(result)
```

## TODO

Parse/Minify/Print option supports
