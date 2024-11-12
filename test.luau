local lightningcss = require("./")
    .new(require("@lune/process").args[1] or "./target/release/liblune_lightningcss.so")

local result = lightningcss:minify([[
    body > .asdf {
        background-color: rgb(123, 89, 231);
    }
]])

print(result) -- body>.asdf{background-color:#7b59e7}
