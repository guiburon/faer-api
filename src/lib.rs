use faer::modules::core::mul::matmul;
use faer::{mat, Parallelism};
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
        mat::from_raw_parts_mut::<f64>(
            a_ptr,
            nrows as usize,
            ncols as usize,
            row_stride as isize,
            col_stride as isize,
        )
    };

    a.fill_zero();
}

#[no_mangle]
pub unsafe extern "C" fn mult(
    c_ptr: *mut f64,
    c_nrows: u64,
    c_ncols: u64,
    c_row_stride: u64,
    c_col_stride: u64,
    a_ptr: *const f64,
    a_nrows: u64,
    a_ncols: u64,
    a_row_stride: u64,
    a_col_stride: u64,
    b_ptr: *const f64,
    b_nrows: u64,
    b_ncols: u64,
    b_row_stride: u64,
    b_col_stride: u64,
    nthreads: u32,
) {
    assert!(!c_ptr.is_null());
    assert!(!a_ptr.is_null());
    assert!(!b_ptr.is_null());

    let c = unsafe {
        mat::from_raw_parts_mut::<f64>(
            c_ptr,
            c_nrows as usize,
            c_ncols as usize,
            c_row_stride as isize,
            c_col_stride as isize,
        )
    };

    let a = unsafe {
        mat::from_raw_parts::<f64>(
            a_ptr,
            a_nrows as usize,
            a_ncols as usize,
            a_row_stride as isize,
            a_col_stride as isize,
        )
    };

    let b = unsafe {
        mat::from_raw_parts::<f64>(
            b_ptr,
            b_nrows as usize,
            b_ncols as usize,
            b_row_stride as isize,
            b_col_stride as isize,
        )
    };

    matmul(c, a, b, None, 1.0, Parallelism::Rayon(nthreads as usize));
}
