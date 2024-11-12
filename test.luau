local lightningcss = require("./")
    .new("./target/release/liblune_lightningcss.so")

local result = lightningcss:minify([[
    body > .asdf {
        background-color: rgb(123, 89, 231);
    }
]])

print(result)
