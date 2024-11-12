--!nolint TableOperations

local ffi = require("@lune/ffi")

export type lightningcss = lightningcss_pub & lightningcss_private

export type lightningcss_pub = {}
export type lightningcss_private = {
	_lib: ffi.LibData,
	_minify: ffi.CallableData,
}

local lightningcss = {} :: lightningcss
lightningcss.__index = lightningcss

local minify_result = ffi.c.struct({
	-- len
	ffi.i32,
	-- ptr
	ffi.c.char:ptr(),
	-- err
	ffi.u8,
})

function lightningcss.new(lib_path: string): lightningcss
	local self = setmetatable({}, lightningcss)
	self._lib = ffi.open(lib_path)
	self._minify = ffi.c.fn({ ffi.u8:ptr(), ffi.i32 }, minify_result):callable(self._lib:find("minify"))
	return self
end

function lightningcss:minify(code: string): string
	local result = ffi.box(minify_result.size)
	local source = ffi.box(#code):writeString(code)
	self._minify(result, source:ref():ref(), ffi.i32:box(#code):ref())
	local result_table = minify_result:readData(result)
	local result_string = result_table[2]:readString(result_table[1])
	ffi.free(result_table[2])
	if result_table[3] == 1 then
		error(result_string)
	end
	return result_string
end

return lightningcss :: { new: (lib_path: string) -> lightningcss }
