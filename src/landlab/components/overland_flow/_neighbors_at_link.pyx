cimport cython

# https://cython.readthedocs.io/en/stable/src/userguide/fusedtypes.html
ctypedef fused id_t:
    cython.integral
    long long


@cython.boundscheck(False)
def neighbors_at_link(
    const id_t [:] links,
    shape,
    id_t [:, :] out,
):
    cdef int stride
    cdef int n_links
    cdef int link
    cdef int i
    cdef bint is_top, is_bottom, is_left, is_right

    stride = 2 * shape[1] - 1
    n_links = (shape[0] - 1) * shape[1] + shape[0] * (shape[1] - 1)

    for i in range(links.shape[0]):
        link = links[i]

        is_top = link > (n_links - stride)
        is_bottom = link < stride
        is_left = link % stride == 0 or (link + shape[1]) % stride == 0
        is_right = (link - (shape[1] - 2)) % stride == 0 or (link + 1) % stride == 0

        if not is_right:
            out[i, 0] = link + 1

        if not is_top:
            out[i, 1] = link + stride

        if not is_left:
            out[i, 2] = link - 1

        if not is_bottom:
            out[i, 3] = link - stride
