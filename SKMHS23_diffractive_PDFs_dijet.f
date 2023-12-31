
!
! Determination of diffractive PDFs from a global QCD analysis of inclusive diffractive DIS and dijet cross-section measurements at HERA
! Maral Salajegheh, Hamzeh Khanpour, Ulf-G. Meißner, Hadi Hashamipour, Maryam Soleymaninia
!                               e-Print: arXiv:2301.10284 [hep-ph];	Phys.Rev.D 107 (2023) 9, 094038
!


! An example Code for SKMHS23 diffractive PDFs (dijet)
!  
! --    Compile with:
! --    gfortran SKMHS23_diffractive_PDFs_dijet.f -L /usr/local/lib -lLHAPDF
! ---------------------------------------


       program SKMHS23_diffractive_PDFs_dijet   

       implicit none
       integer nset, nmem, imem, MaxNumSets, nx, i, ix
       double precision x(1000), q2, q, xf(-6:6), xs(0:100),
     +       xf0, xfp, xfm, xfs, correlation, xminimum, xmaximum
       logical lMonteCarlo, lSymmetric
       
       character*10 lhaversion
       
       data Q2/10.0D0/,  nset/1.D0/

  !-- Get the LHAPDF version number.
       call getlhapdfversion(lhaversion)
       write(6,*) "LHAPDF Version = ", lhaversion

  !-- Get the maximum number of concurrent PDF sets.
       call GetMaxNumSets(MaxNumSets)
       write(6,*) "MaxNumSets = ", MaxNumSets
       write(6,*)
       

  !-- Test three PDF sets that have different uncertainty calculations.      
   
        call InitPDFSetByNameM(nset,"SKMHS23_NLO_dijet")
    
       call numberPDFM(nset,nmem)
       
       write(6,*) "PDF set = ", nset
        write(6,*) "Number of PDF members = ", nmem

c     !-- Check if Monte Carlo PDF set (NNPDF) or if
c     !-- should compute symmetric errors (Alekhin).

       call GetPDFUncTypeM(nset,lMonteCarlo,lSymmetric)
       write(6,*) "lMonteCarlo = ", lMonteCarlo
       write(6,*) "lSymmetric = ", lSymmetric
       write(6,*)
       

       nx = 1000
       xminimum = 0.0001D0
       xmaximum = 0.9999D0
       DO ix = 1, nx
         x(ix) = 10.D0**(log10(xminimum) + (ix-1.D0)/(nx-1.D0)*
     -        (log10(xmaximum) - log10(xminimum)))
       end Do

       Q = SQRT(Q2)
       
       do i = 1, nx
       xf0 = 0.D0 ! central value
       xfp = 0.D0 ! positive uncertainty
       xfm = 0.D0 ! negative uncertainty
       xfs = 0.D0 ! symmetrised uncertainty


       do imem = 0, nmem
        call InitPDFM(nset,imem)
        call evolvePDFM(nset,x(i),q,xf)

         xs(imem) = xf(0)
        
       end do
       
       open (10, file='xg-SKMHS23-NLO-Q2-10GeV2_dijet.dat')
       

       call GetPDFuncertaintyM(nset,xs,xf0,xfp,xfm,xfs)
      
       write(10,*) x(i),  xf0, xfs
 
       write(*,*)  x(i),  xf0, xfs
      

       end do

       stop
       end program SKMHS23_diffractive_PDFs_dijet
