      SUBROUTINE SSORT(X,Y,N,KFLAG)
C***BEGIN PROLOGUE  SSORT
C***DATE WRITTEN   761101   (YYMMDD)
C***REVISION DATE  820801   (YYMMDD)
C***CATEGORY NO.  N6A2B1
C***KEYWORDS  QUICKSORT,SINGLETON QUICKSORT,SORT,SORTING
C***AUTHOR  JONES, R. E., (SNLA)
C           WISNIEWSKI, J. A., (SNLA)
C***PURPOSE  SSORT sorts array X and optionally makes the same
C            interchanges in array Y.  The array X may be sorted in
C            increasing order or decreasing order.  A slightly modified
C            QUICKSORT algorithm is used.
C***DESCRIPTION
C
C     Written by Rondall E. Jones
C     Modified by John A. Wisniewski to use the Singleton quicksort
C     algorithm.  Date 18 November 1976.
C
C     Abstract
C         SSORT sorts array X and optionally makes the same
C         interchanges in array Y.  The array X may be sorted in
C         increasing order or decreasing order.  A slightly modified
C         quicksort algorithm is used.
C
C     Reference
C         Singleton, R. C., Algorithm 347, An Efficient Algorithm for
C         Sorting with Minimal Storage, CACM,12(3),1969,185-7.
C
C     Description of Parameters
C         X - array of values to be sorted   (usually abscissas)
C         Y - array to be (optionally) carried along
C         N - number of values in array X to be sorted
C         KFLAG - control parameter
C             =2  means sort X in increasing order and carry Y along.
C             =1  means sort X in increasing order (ignoring Y)
C             =-1 means sort X in decreasing order (ignoring Y)
C             =-2 means sort X in decreasing order and carry Y along.
C***REFERENCES  SINGLETON,R.C., ALGORITHM 347, AN EFFICIENT ALGORITHM
C                 FOR SORTING WITH MINIMAL STORAGE, CACM,12(3),1969,
C                 185-7.
C***ROUTINES CALLED  XERROR
C***END PROLOGUE  SSORT
      DIMENSION X(N),Y(N),IL(21),IU(21)
C***FIRST EXECUTABLE STATEMENT  SSORT
      NN = N
      IF (NN.GE.1) GO TO 10
      CALL XERROR ( 'SSORT- THE NUMBER OF VALUES TO BE SORTED WAS NOT PO
     1SITIVE.',58,1,1)
      RETURN
   10 KK = IABS(KFLAG)
      IF ((KK.EQ.1).OR.(KK.EQ.2)) GO TO 15
      CALL XERROR ( 'SSORT- THE SORT CONTROL PARAMETER, K, WAS NOT 2, 1,
     1 -1, OR -2.',62,2,1)
      RETURN
C
C ALTER ARRAY X TO GET DECREASING ORDER IF NEEDED
C
   15 IF (KFLAG.GE.1) GO TO 30
      DO 20 I=1,NN
   20 X(I) = -X(I)
   30 GO TO (100,200),KK
C
C SORT X ONLY
C
  100 CONTINUE
      M=1
      I=1
      J=NN
      R=.375
  110 IF (I .EQ. J) GO TO 155
  115 IF (R .GT. .5898437) GO TO 120
      R=R+3.90625E-2
      GO TO 125
  120 R=R-.21875
  125 K=I
C                                  SELECT A CENTRAL ELEMENT OF THE
C                                  ARRAY AND SAVE IT IN LOCATION T
      IJ = I + IFIX (FLOAT (J-I) * R)
      T=X(IJ)
C                                  IF FIRST ELEMENT OF ARRAY IS GREATER
C                                  THAN T, INTERCHANGE WITH T
      IF (X(I) .LE. T) GO TO 130
      X(IJ)=X(I)
      X(I)=T
      T=X(IJ)
  130 L=J
C                                  IF LAST ELEMENT OF ARRAY IS LESS THAN
C                                  T, INTERCHANGE WITH T
      IF (X(J) .GE. T) GO TO 140
      X(IJ)=X(J)
      X(J)=T
      T=X(IJ)
C                                  IF FIRST ELEMENT OF ARRAY IS GREATER
C                                  THAN T, INTERCHANGE WITH T
      IF (X(I) .LE. T) GO TO 140
      X(IJ)=X(I)
      X(I)=T
      T=X(IJ)
      GO TO 140
  135 TT=X(L)
      X(L)=X(K)
      X(K)=TT
C                                  FIND AN ELEMENT IN THE SECOND HALF OF
C                                  THE ARRAY WHICH IS SMALLER THAN T
  140 L=L-1
      IF (X(L) .GT. T) GO TO 140
C                                  FIND AN ELEMENT IN THE FIRST HALF OF
C                                  THE ARRAY WHICH IS GREATER THAN T
  145 K=K+1
      IF (X(K) .LT. T) GO TO 145
C                                  INTERCHANGE THESE ELEMENTS
      IF (K .LE. L) GO TO 135
C                                  SAVE UPPER AND LOWER SUBSCRIPTS OF
C                                  THE ARRAY YET TO BE SORTED
      IF (L-I .LE. J-K) GO TO 150
      IL(M)=I
      IU(M)=L
      I=K
      M=M+1
      GO TO 160
  150 IL(M)=K
      IU(M)=J
      J=L
      M=M+1
      GO TO 160
C                                  BEGIN AGAIN ON ANOTHER PORTION OF
C                                  THE UNSORTED ARRAY
  155 M=M-1
      IF (M .EQ. 0) GO TO 300
      I=IL(M)
      J=IU(M)
  160 IF (J-I .GE. 1) GO TO 125
      IF (I .EQ. 1) GO TO 110
      I=I-1
  165 I=I+1
      IF (I .EQ. J) GO TO 155
      T=X(I+1)
      IF (X(I) .LE. T) GO TO 165
      K=I
  170 X(K+1)=X(K)
      K=K-1
      IF (T .LT. X(K)) GO TO 170
      X(K+1)=T
      GO TO 165
C
C SORT X AND CARRY Y ALONG
C
  200 CONTINUE
      M=1
      I=1
      J=NN
      R=.375
  210 IF (I .EQ. J) GO TO 255
  215 IF (R .GT. .5898437) GO TO 220
      R=R+3.90625E-2
      GO TO 225
  220 R=R-.21875
  225 K=I
C                                  SELECT A CENTRAL ELEMENT OF THE
C                                  ARRAY AND SAVE IT IN LOCATION T
      IJ = I + IFIX (FLOAT (J-I) *R)
      T=X(IJ)
      TY= Y(IJ)
C                                  IF FIRST ELEMENT OF ARRAY IS GREATER
C                                  THAN T, INTERCHANGE WITH T
      IF (X(I) .LE. T) GO TO 230
      X(IJ)=X(I)
      X(I)=T
      T=X(IJ)
       Y(IJ)= Y(I)
       Y(I)=TY
      TY= Y(IJ)
  230 L=J
C                                  IF LAST ELEMENT OF ARRAY IS LESS THAN
C                                  T, INTERCHANGE WITH T
      IF (X(J) .GE. T) GO TO 240
      X(IJ)=X(J)
      X(J)=T
      T=X(IJ)
       Y(IJ)= Y(J)
       Y(J)=TY
      TY= Y(IJ)
C                                  IF FIRST ELEMENT OF ARRAY IS GREATER
C                                  THAN T, INTERCHANGE WITH T
      IF (X(I) .LE. T) GO TO 240
      X(IJ)=X(I)
      X(I)=T
      T=X(IJ)
       Y(IJ)= Y(I)
       Y(I)=TY
      TY= Y(IJ)
      GO TO 240
  235 TT=X(L)
      X(L)=X(K)
      X(K)=TT
      TTY= Y(L)
       Y(L)= Y(K)
       Y(K)=TTY
C                                  FIND AN ELEMENT IN THE SECOND HALF OF
C                                  THE ARRAY WHICH IS SMALLER THAN T
  240 L=L-1
      IF (X(L) .GT. T) GO TO 240
C                                  FIND AN ELEMENT IN THE FIRST HALF OF
C                                  THE ARRAY WHICH IS GREATER THAN T
  245 K=K+1
      IF (X(K) .LT. T) GO TO 245
C                                  INTERCHANGE THESE ELEMENTS
      IF (K .LE. L) GO TO 235
C                                  SAVE UPPER AND LOWER SUBSCRIPTS OF
C                                  THE ARRAY YET TO BE SORTED
      IF (L-I .LE. J-K) GO TO 250
      IL(M)=I
      IU(M)=L
      I=K
      M=M+1
      GO TO 260
  250 IL(M)=K
      IU(M)=J
      J=L
      M=M+1
      GO TO 260
C                                  BEGIN AGAIN ON ANOTHER PORTION OF
C                                  THE UNSORTED ARRAY
  255 M=M-1
      IF (M .EQ. 0) GO TO 300
      I=IL(M)
      J=IU(M)
  260 IF (J-I .GE. 1) GO TO 225
      IF (I .EQ. 1) GO TO 210
      I=I-1
  265 I=I+1
      IF (I .EQ. J) GO TO 255
      T=X(I+1)
      TY= Y(I+1)
      IF (X(I) .LE. T) GO TO 265
      K=I
  270 X(K+1)=X(K)
       Y(K+1)= Y(K)
      K=K-1
      IF (T .LT. X(K)) GO TO 270
      X(K+1)=T
       Y(K+1)=TY
      GO TO 265
C
C CLEAN UP
C
  300 IF (KFLAG.GE.1) RETURN
      DO 310 I=1,NN
  310 X(I) = -X(I)
      RETURN
      END
      SUBROUTINE XERROR(MESSG,NMESSG,NERR,LEVEL)
C***BEGIN PROLOGUE  XERROR
C***DATE WRITTEN   790801   (YYMMDD)
C***REVISION DATE  820801   (YYMMDD)
C***CATEGORY NO.  R3C
C***KEYWORDS  ERROR,XERROR PACKAGE
C***AUTHOR  JONES, R. E., (SNLA)
C***PURPOSE  Processes an error (diagnostic) message.
C***DESCRIPTION
C     Abstract
C        XERROR processes a diagnostic message, in a manner
C        determined by the value of LEVEL and the current value
C        of the library error control flag, KONTRL.
C        (See subroutine XSETF for details.)
C
C     Description of Parameters
C      --Input--
C        MESSG - the Hollerith message to be processed, containing
C                no more than 72 characters.
C        NMESSG- the actual number of characters in MESSG.
C        NERR  - the error number associated with this message.
C                NERR must not be zero.
C        LEVEL - error category.
C                =2 means this is an unconditionally fatal error.
C                =1 means this is a recoverable error.  (I.e., it is
C                   non-fatal if XSETF has been appropriately called.)
C                =0 means this is a warning message only.
C                =-1 means this is a warning message which is to be
C                   printed at most once, regardless of how many
C                   times this call is executed.
C
C     Examples
C        CALL XERROR('SMOOTH -- NUM WAS ZERO.',23,1,2)
C        CALL XERROR('INTEG  -- LESS THAN FULL ACCURACY ACHIEVED.',
C                    43,2,1)
C        CALL XERROR('ROOTER -- ACTUAL ZERO OF F FOUND BEFORE INTERVAL F
C    1ULLY COLLAPSED.',65,3,0)
C        CALL XERROR('EXP    -- UNDERFLOWS BEING SET TO ZERO.',39,1,-1)
C
C     Latest revision ---  19 MAR 1980
C     Written by Ron Jones, with SLATEC Common Math Library Subcommittee
C***REFERENCES  JONES R.E., KAHANER D.K., "XERROR, THE SLATEC ERROR-
C                 HANDLING PACKAGE", SAND82-0800, SANDIA LABORATORIES,
C                 1982.
C***ROUTINES CALLED  XERRWV
C***END PROLOGUE  XERROR
      CHARACTER*(*) MESSG
C***FIRST EXECUTABLE STATEMENT  XERROR
******CALL XERRWV(MESSG,NMESSG,NERR,LEVEL,0,0,0,0,0.,0.)
      write(6,'(a,a)') 'XERROR: ',messg(1:nmessg)
      if     (level.eq.2) then
        stop
      elseif (level.eq.1) then
        stop
      endif
      RETURN
      END
