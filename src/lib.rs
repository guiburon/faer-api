use std::usize;

#[no_mangle]
pub unsafe extern "C" fn make_zero(
    a_ptr: *mut f64,
    nrows: u64,
    ncols: u64,
    row_stride: u64,
    col_stride: u64,
) {
    assert!(!a_ptr.is_null());

    let mut a = unsafe {
        faer::mat::from_raw_parts_mut::<f64>(
            a_ptr,
            nrows as usize,
            ncols as usize,
            row_stride as isize,
            col_stride as isize,
        )
    };

    a.fill_zero();
}
