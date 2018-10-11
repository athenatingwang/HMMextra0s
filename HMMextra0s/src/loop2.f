      subroutine loop2(m, T, phi, pRS, gamma, logbet, lscale, tmp)
c     second loop (backward eqns) 
      implicit none
      integer i, j, m, T
      double precision phi(m), sumphi, lscale, lscalearr(T-1)
      double precision pRS(T,m), gamma(m,m), logbet(T,m)
      double precision tmp(m)
c     the above array occurs in the subroutine call for
c     memory allocation reasons in non gfortran compilers
c     its contents are purely internal to this subroutine
      do i = T-1,1,-1
          do j = 1,m
              phi(j) = phi(j)*pRS(i+1, j)
          enddo
          call multi2(m, gamma, phi, tmp)
          sumphi=0.0
          do j = 1,m
              logbet(i,j) = phi(j)
              sumphi = sumphi + phi(j)
          enddo
          do j = 1,m
              phi(j) = phi(j)/sumphi
          enddo
          lscalearr(i) = lscale
          lscale = lscale + dlog(sumphi)
      enddo

c     Separate this loop to invert loop nest order and enable
c     vectorisation of inner loop
      do j = 1,m
          do i = 1,T-1
              logbet(i,j) = dlog(logbet(i,j)) + lscalearr(i)
          enddo
          logbet(T,j) = 0.0d0
      enddo
      end

      subroutine multi2(m, a, b, c)
c     a is (m*m) matrix
c     b is column vector
c     b is replaced by the matrix product of a*b
      implicit none
      integer m, j, k
      double precision a(m, m), b(m), c(m)
      do j = 1,m
          c(j) = 0
          do k = 1,m
              c(j) = c(j) + a(j, k)*b(k)
          enddo
      enddo
      do j = 1,m
          b(j) = c(j)
      enddo
      end


