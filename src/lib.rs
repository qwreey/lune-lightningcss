#![allow(clippy::missing_safety_doc)]
use core::str;
use lightningcss::stylesheet::{MinifyOptions, ParserOptions, PrinterOptions, StyleSheet};
use std::{fmt::Display, slice};

#[repr(C)]
pub struct MinifyResult {
    len: i32,
    ptr: *const u8,
    err: bool,
}

fn create_err(err: impl Display) -> MinifyResult {
    let err = format!("{err}").leak();
    MinifyResult{len:err.len() as i32,ptr:err.as_ptr(), err:true}
}

#[no_mangle]
pub unsafe extern "C" fn minify(ptr: *const u8, len: i32) -> MinifyResult {
    let parsed = StyleSheet::parse(
        str::from_utf8_unchecked(slice::from_raw_parts(ptr, len as usize)),
        ParserOptions::default(),
    );
    match parsed {
        Ok(mut stylesheet) => {
            if let Err(err) = stylesheet.minify(MinifyOptions::default()) {
                return create_err(err);
            }
            match stylesheet.to_css(PrinterOptions{ minify: true, ..Default::default() }) {
                Ok(result) => {
                    let result_string = result.code.leak();
                    MinifyResult {
                        len: result_string.len() as i32,
                        ptr: result_string.as_ptr(),
                        err: false,
                    }
                }
                Err(err) => create_err(err),
            }
        },
        Err(err) => create_err(err),
    }
}
