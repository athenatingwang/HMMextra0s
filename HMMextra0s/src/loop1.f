      subroutine loop1(m, T, phi, pRS, gamma, logalp, lscale, tmp)
c     first loop (forward eqns)
      implicit none
      integer i, j, m, T
      double precision phi(m), sumphi, lscale, lscalearr(T)
      double precision pRS(T,m), gamma(m,m), logalp(T,m)
      double precision tmp(m)
c     the above array occurs in the subroutine call for
c     memory allocation reasons in non gfortran compilers
c     its contents are purely internal to this subroutine
      lscale = 0.0d0
      do i = 1,T
          if (i .gt. 1) call multi1(m, phi, gamma, tmp)
          sumphi=0.0d0
          do j = 1,m
              phi(j) = phi(j)*pRS(i, j)
              sumphi = sumphi + phi(j)
          enddo
          do j = 1,m
              phi(j) = phi(j)/sumphi
              logalp(i,j) = phi(j)
          enddo
          lscale = lscale + dlog(sumphi)
          lscalearr(i) = lscale
      enddo

c     Separate this loop to invert loop nest order and enable
c     vectorisation of inner loop
      do j = 1,m
          do i = 1,T
              logalp(i,j) = dlog(logalp(i,j)) + lscalearr(i)
          enddo
      enddo
      end

      subroutine multi1(m, a, b, c)
c     a is row vector
c     b is (m*m) matrix
c     a is replaced by the matrix product of a*b
      implicit none
      integer m, j, k
      double precision a(m), b(m, m), c(m)
      do j = 1,m
          c(j) = 0
          do k = 1,m
              c(j) = c(j) + a(k)*b(k, j)
          enddo
      enddo
      do j = 1,m
          a(j) = c(j)
      enddo
      end


