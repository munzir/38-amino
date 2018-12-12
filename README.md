# 38-amino

Amino is package of basic utilities for robotics software.  It
includes mathematical and linear algebra routines, memory management,
and time-handling.  Design goals are easy integration, efficiency, and
simplicity.

## Dependencies

- autconf
- autoconf-archive
- blas / lapack
- maxima
- gfortran

On Debian/Ubuntu:

    sudo apt install autoconf autoconf-archive libblas-dev liblapack-dev libtool maxima

For libgfortran, install the latest lib and lib-dev packages. For Ubuntu 18.04, I have `libgfortran5` and `libgfortran-8-dev` packages. Do an apt search

    sudo apt search libgfortran
    
and scroll through the list to see which ones are the latest for your distro and install them.

## Installation

We need to modify two system files "/usr/share/aclocal/ax_tls.m4" and "/usr/include/stdc-predef.h". But before you do so, please make a copy of these files, lest you make a mistake and are not able to revert back.

For the file "/usr/share/aclocal/ax_tls.m4", replace the line:

    [m4_ifnblank([$2],[$2])])
 
with:

    m4_ifnblank([$2],[$2]))
    
Basically, we just removed a pair of square brackets.

For the file "/usr/include/stdc-predef.h", just get rid of all the comments and blank lines.

Finally, follow these instructions for installing the library:

    git clone https://github.gatech.edu/WholeBodyControlAttempt1/38-amino
    cd 38-amino
    git checkout krang
    git pull origin krang
    sudo autoreconf -i
    sudo ./configure
    sudo make
    sudo make install


## Old Readme

************
* OVERVIEW *
************

Amino is package of basic utilities for robotics software.  It
includes mathematical and linear algebra routines, memory management,
and time-handling.  Design goals are easy integration, efficiency, and
simplicity.

****************
* DEPENDENCIES *
****************

- BLAS / LAPACK
- Maxima (build-time dependency only)

On Debian/Ubuntu:

`sudo apt-get install libblas3gf libblas-dev liblapack3gf liblapack-dev maxima`

****************
* INSTALLATION *
****************

./configure && make && make install

See the INSTALL file for details.
