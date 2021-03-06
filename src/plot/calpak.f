      subroutine numbe2(x,y,size,rn,angl,nsf)
c
c     Coded by S.Hori (Jan., 1991)
c
      character*22 text
      if(nsf.lt.0) then
        write(text(1:13),'(f13.1)') rn
        do 1 k=1,11
          if(text(k:k).ne.' ') then
            nf=11-k+1
            call number(x,y,size,rn,angl,-nf)
            return
          endif
 1      continue
        return
      elseif(nsf.gt.0) then
        if(nsf.gt.9) nsf=9
        write(text(1:22),'(f22.10)') rn
        do 2 k=1,11
          if(text(k:k).ne.' ') then
            nf=10*(nsf+1+(11-k+1))+nsf
            call number(x,y,size,rn,angl,nf)
            return
          endif
 2      continue
      else
        return
      endif
      return
      end
c
      subroutine circl2(x,y,r,i1,i2)
c
c     Coded by S.Hori (Jan., 1991)
c
      parameter(rd=1.7453292e-3)
      call plot(x,y,3)
      if(i2.lt.i1.or.i2.eq.0) then
        call circle(r,0)
      else
        x1=x+r*cos(real(i1)*rd)
        y1=y+r*sin(real(i1)*rd)
        call plot(x1,y1,3)
        do 1 i=i1+1,i2
          a=real(i)*rd
          x2=x+r*cos(a)
          y2=y+r*sin(a)
          call plot(x2,y2,2)
 1      continue
      endif
      call plot(x,y,3)
      return
      end
c
      subroutine axis(x,y,laray,nchar,axlen,angle,firstv,deltav)
c
c     produces an axis with annotated divisions and centered label
c      x,y    : coordinates of starting point of axis, in inches
c      laray  : axis title.
c      nchar  : number of characters in title.
c      axlen  : floating point axis length in inches.
c      angle  : angle of axis from the x-direction, in degrees.
c      firstv : scale value at the first tic mark.
c      deltav : change in scale between tic marks one inch apart
c
      dimension laray(1)
      character mlabel*4
      data mlabel/'*10 '/
      kn=nchar
      a=1.
      size=1.
c
c     the unit system is metric
c
      size=2.54
c
c     check for valid x,y axis starting point
c
      xlow=-32767.
      xhigh=32767.
      ylow=xlow
      yhigh=xhigh
      xstart=x
      ystart=y
      if(xstart.lt.xlow) xstart=xlow
      if(xstart.gt.xhigh) xstart=xhigh
      if(ystart.lt.ylow) ystart=ylow
      if(ystart.gt.yhigh) ystart=yhigh
c
c     check for valid axis length
c
      axl=axlen
c
c     if axis length is less than 2. default to 2.
c
      if(axl.lt.2.) axl=2.
      if(axl.gt.32767.) axl=32767.
c
c     create modulo 360 angle
c
      ang=angle-(aint(angle/360.)*360.)
c
c     Which side of the line should tick marks and labeling appear ?
c
      if (kn) 10,20,20
   10 a=-a
      kn=-kn
   20 ex=0.
      adx=abs(deltav)
      if(adx) 30,70,30
   30 if(adx-99.) 60,40,40
   40 adx=adx/10.
      ex=ex+1.
      go to 30
   50 adx=adx*10.
      ex=ex-1.
   60 if (adx-0.01) 50,70,70
   70 xval=firstv*10.**(-ex)
      adx=deltav*10.**(-ex)
c
c     Is the angle 0, 90 180 or 270 degrees ?
c
      if(ang.eq.0.) go to 80
      if(ang.eq.90.) go to 90
      if(ang.eq.180.) go to 100
      if(ang.eq.270.) go to 110
c
c     calculate the sin/cos for the angle
c
      sth=ang*.017453294
      cth=cos(sth)
      sth=sin(sth)
      go to 120
c
c     We don't want the sin/cos values to be calculated for
c     0,90,180 or 270 degrees due to errors which occur in
c     precision.  We will set them here.
c
   80 sth=0.
      cth=1.
      go to 120
   90 sth=1.
      cth=0.
      go to 120
  100 sth=0.
      cth=-1.
      go to 120
  110 sth=-1.
      cth=0.
  120 dxb=-.1*size
      dyb=.15*size*a-.05*size
      xn=xstart+dxb*cth-dyb*sth
      yn=ystart+dyb*cth+dxb*sth
      ntic=axl+1.
      nt=ntic/2
c
c     generate the labeled axis with tick marks
c
      do 200 i=1,ntic
c
c     Is the unit system enabled metric ?
c
        if(munit.eq.0) go to 130
c
c     yes, label only every other tic mark
c
        mtic=mod(i,2)
        if(mtic.ne.0) go to 140
        call number(xn,yn,0.075*size,xval,ang,62)
        go to 140
  130   call number(xn,yn,0.105,xval,ang,62)
  140   xval=xval+adx
        xn=xn+cth
        yn=yn+sth
        if(nt) 190,150,190
  150   z=kn
        if(ex) 160,170,160
  160   z=z+7.
  170   dxb=-.07*size*z+axl*.5
        dyb=.325*size*a-.075*size
        xt=xstart+dxb*cth-dyb*sth
        yt=ystart+dyb*cth+dxb*sth
        call symbol(xt,yt,.14*size,laray(1),ang,kn)
        if(ex) 180,190,180
  180   z=kn+2
        xt=xt+z*cth*.14*size
        yt=yt+z*sth*.14*size
        call symbol(xt,yt,.14*size,mlabel,ang,3)
        xt=xt+(3.*cth-.8*size*sth)*.14*size
        yt=yt+(3.*sth+.8*size*cth)*.14*size
        call number(xt,yt,.07*size,ex,ang,-5)
  190   nt=nt-1
  200 continue
      call plot(xstart+axl*cth,ystart+axl*sth,3)
      dxb=-.07*size*a*sth
      dyb=.07*size*a*cth
      a=ntic-1
      xn=xstart+a*cth
      yn=ystart+a*sth
      do 210 i=1,ntic
        call plot(xn,yn,2)
        call plot(xn+dxb,yn+dyb,2)
        call plot(xn,yn,2)
        xn=xn-cth
        yn=yn-sth
  210 continue
      return
      end
c
      subroutine dashl(x,y,npts,inc)
c
c     x    : array containing abscissa (x) values and
c            scaling parameters
c     y    : array containing ordinate (y) values and
c            scaling parameters
c     npts : number of data points in each of these arrays,
c            but not including the two extra locations for
c            the scaling parameters
c     inc  : increment to use in gathering data from the two arrays
c
      dimension x(1),y(1)
      lintyp=0
      inteq=0
c
c     store scaling parameters
c
      nmin=npts*inc+1
      nd=nmin+inc
      xmin=x(nmin)
      dx=x(nd)
      ymin=y(nmin)
      dy=y(nd)
c
c     store end points of line
c
      nend=nmin-inc
      x1=x(1)
      x2=x(nend)
      y1=y(1)
      y2=y(nend)
c
c     locate pen
c     and find maximum of coordinates of end points of line
c
      call where(x0,y0,fact)
      d1=amax1(abs((x1-xmin)/dx-x0),abs((y1-ymin)/dy-y0))
      d2=amax1(abs((x2-xmin)/dx-x0),abs((y2-ymin)/dy-y0))
c
c     set constants for point plot, line plot, or line and symbol plot
c
c     ic      pen up/down for plot
c     is      pen up/down for symbol
c     na      step from 1 to nt
c     nt      when na=nt, use symbol
c     nf      subscript of array value to be plotted
c     kk      step nf forward or backward through arrays
c     ica,isa values of ic and is after first point plotted
c     lsw     flag to skip plot call for point plot only
c
      ic=3
      is=-1
      nt=iabs(lintyp)
      if(lintyp.eq.0) nt=1
      if(d1.le.d2) go to 100
      nf=nend
      na=((npts-1)/nt)*nt+nt-(npts-1)
      kk=-inc
      go to 110
 100  nf=1
      na=nt
      kk=inc
 110  if(lintyp) 120,130,140
 120  ica=3
      isa=-1
      lsw=1
      go to 150
 130  na=nd
 140  ica=2
      isa=-2
      lsw=0
c
c     begin do loop for plotting
c
 150  do 210 i=1,npts
c
c     calculate page coordinates of data point
c
        xn=(x(nf)-xmin)/dx
        yn=(y(nf)-ymin)/dy
c
c     test for symbol or plot call
c
        if(na-nt) 160,170,180
c
c     test for plot or no plot
c
 160    if(lsw) 190,180,190
 170    if(is.eq.(-2)) call dashp(xn,yn,0.254)
        call symbol(xn,yn,0.08,inteq,0.0,-1)
        na=1
        go to 200
 180    if(ic.eq.2) call dashp(xn,yn,0.254)
        call plot(xn,yn,3)
c
c     reset constants
c
 190    na=na+1
 200    nf=nf+kk
        is=isa
        ic=ica
 210  continue
      return
      end
c
      subroutine dashp(x,y,dash)
c
c     x,y  : coordinates of point to which dashed line is to be drawn
c     dash : length of each dash and of the space between dashes
c
      if(dash.le.1.e-20) then
        call plot(x,y,2)
        return
      endif
      call where(x0,y0,fact)
      dist=sqrt((x-x0)**2+(y-y0)**2)
      d=dash
      if(dist.lt.dash*2.) d=dist/2.
      if(dist.lt.1.e-20) return
      n=dist/d
      dx=(x-x0)/n
      dy=(y-y0)/n
      ipen=2
      do 100 i=1,n
        x0=x0+dx
        y0=y0+dy
        call plot(x0,y0,ipen)
        ipen=ipen+1
        if(ipen.ge.4) ipen=2
 100  continue
      call plot(x,y,ipen)
      return
      end
c
      subroutine line(xaray,yaray,nscale,npoint,lintyp,inteq)
c
c     produces a line plot of the pairs of data values in the
c     two arrays
c
c      xaray  : name of array containing abscissa or x values
c      yaray  : name of array containing ordinate or y values
c      nscale : number of points to be plotted
c      npoint : increment of location of successive points
c      lintyp : control type of line-symbol, line, or combination
c      inteq  : integer equivalent of symbol to be used, if any
c
      dimension xaray(1),yaray(1),label(1)
      lmin=nscale*npoint+1
      ldx=lmin+npoint
      nl=lmin-npoint
      firstx=xaray(lmin)
      deltax=xaray(ldx)
      firsty=yaray(lmin)
      deltay=yaray(ldx)
      label(1)=inteq
c
c     define centered-symbol-height
c
      cshigh=.08*2.54
c
c     check for valid centered symbol
c
      if(label(1).lt.0.or.label(1).gt.14) label(1)=0
      ipen=3
      icode=-1
      nt=iabs(lintyp)
c
c     What type of line has been specified ?
c
      if (lintyp.ne.0) go to 40
      nt=1
c
   40 nf=1
      na=nt
      if(lintyp) 60,70,80
   60 ipena=3
      icodea=-1
      lsw=1
      go to 90
   70 na=ldx
   80 ipena=2
      icodea=-2
      lsw=0
c
c     plot the data points
c
   90 do 150 i=1,nscale
c
c     calculate the coordinates of the current data poiint
c
        xn=(xaray(nf)-firstx)/deltax
        yn=(yaray(nf)-firsty)/deltay
        if(na-nt) 100,110,120
  100   if(lsw) 130,120,130
c
c     generate a special centered symbol
c
  110   call symbol(xn,yn,cshigh,label,0.,icode)
        na=1
        go to 140
  120   call plot(xn,yn,ipen)
  130   na=na+1
  140   nf=nf+npoint
        icode=icodea
        ipen=ipena
  150 continue
      return
      end
c
      subroutine newpen(ipen)
c
c     calcomp compatible interface to subroutine pen
c
      call pen(ipen,ivel)
      return
      end
c
      subroutine plot(x,y,ipen)
c
      common/p00000/lplot,irot,il34,a,b,c,d,asp,thet
      common/p00001/xorig,yorig
      common/a00000/psca,ixo,iyo,iox,ioy
c
c     Modified by S.Hori
c
      if(ipen.eq.999) then
        call hplots(0,0,0,0)
      elseif(ipen.lt.0) then
        call origin(x,y,1)
        iqen=-ipen
        call xplot(0.,0.,iqen)
      else
        iqen=ipen
        call xplot(x,y,iqen)
      endif
c
      return
      end
c
      subroutine scale(aray,axlen,nscale,npoint)
c
c     examines values in an array and determines a starting value
c     and scaling factor and appends them to the end of the array
c
c      aray   : name of array containing values to be scaled
c      axlen  : length in current units over which array is to be scaled
c      nscale : number of points to be scaled
c      npoint : increment of location of successive points
c
      dimension aray(1),save(7)
      save(1)=1.
      save(2)=2.
      save(3)=4.
      save(4)=5.
      save(5)=8.
      save(6)=10.
      save(7)=20.
      fad=.01
c
c     check axis length
c
      axl=axlen
      if(axl.lt.0.) axl=1.
      if(axl.gt.32767.) axl=32767.
c
c     find last array location containing data to be scaled
c
      k=iabs(npoint)
      n=nscale*k
      y0=aray(1)
      yn=y0
c
c    find minimum and maximum values among data points to be scaled
c
      do 40 i=1,n,k
        ys=aray(i)
        if(y0-ys) 20,20,10
   10   y0=ys
        go to 40
   20   if(ys-yn) 40,40,30
   30   yn=ys
   40 continue
      firstv=y0
      if(y0) 50,60,60
   50 fad=fad-1.
c
c     calculate the number of data units per npointh
c
   60 deltav=(yn-firstv)/axl
      if(deltav) 180,180,70
   70 i=alog(deltav)*.4343+1000.
      p=10.**(i-1000)
      deltav=deltav/p-.01
      do 80 i=1,6
        is=i
        if(save(i)-deltav) 80,90,90
   80 continue
c
c     calculate the adjusted delta value
c
   90 deltav=save(is)*p
      firstv=deltav*aint(y0/deltav+fad)
      t=firstv+(axl+.01)*deltav
      if(t-yn) 100,120,120
c
c     calculate the adjusted minimum value
c
  100 firstv=p*aint(y0/p+fad)
      t=firstv+(axl+.01)*deltav
      if(t-yn) 110,120,120
  110 is=is+1
      go to 90
  120 firstv=firstv-aint((axl+(firstv-yn)/deltav)/2.)*deltav
      if(y0*firstv) 130,130,140
  130 firstv=0.
  140 if(npoint) 150,150,160
  150 firstv=firstv+aint(axl+.5)*deltav
      deltav=-deltav
  160 n=n+1
c
c     save the adjusted minimum value
c
      aray(n)=firstv
      n=n+k
c
c     save the adjusted delta value
c
      aray(n)=deltav
  170 go to 190
  180 deltav=2.*firstv
      deltav=abs(deltav/axl)+1.
      go to 70
  190 return
      end
c
      subroutine symbol(x,y,height,itext,theta,ntext)
 
c     plug in replacement for subroutine symbol of pen plotter fame
c     with additional features:
c
c 1) four hershey letter fonts-simplex,complex,italic, and duplex-
c    are provided in upper and lower case roman
c 2) two hershey letter fonts-simplex and complex--are provided in
c    upper and lower case greek
c 3) 47 special mathematical symbols, e.g. integral sign, del, are
c    provided
c 4) super- and sub-scripting is possible within a character string
c    without separate calls to symbol
c
c  Change of font is made by enclosing the name of the font in upper
c  case in backslashes, e.g \simplex\.  Three letters suffice to
c  specify the font.  Simplex is the default font on the initial call
c  to symbol.  A font remains in effect until explicitly changed.
c  Super- or sub-scripting is accomplished by enclosing the expression
c  to be super- or sub-scripted in curly brackets and preceding it by
c  sup or sub. The closing curly bracket terminates the
c  super- or sub-scripting and returns to normal character plotting.
c  Note that super- and sub-script letters are plotted with a
c  different character size.
c  Greek letters are drawn  by enclosing the english name of the
c  letter in backslashes, e.g. \alpha\.  The case of the first letter
c  determines the case of the greek letter.  The closing backslash must
c  be included.
c  Any symbol may be called by enclosing the symbol number+1000 in
c  backslashes and using ntext=6.  This is the only way to call some
c  symbols, especially special mathematical symbols (not to be confused
c  with special centred symbols which are identified by a integer 0-22
c  in itext and a negative ntext).
c  The symbol numbers are
c  1-26    upper case roman simplex
c  27-52   lower case roman simplex
c  53-72   simplex numbers and symbols
c  73-96   upper case greek simplex
c  97-120  lower case greek simplex
c  121-146 upper case roman complex
c  147-172 lower case roman complex
c  173-192 complex numbers and symbols
c  193-216 upper case greek complex
c  217-240 lower case greek complex
c  241-266 upper case roman italic
c  267-292 lower case roman italic
c  293-312 italic numbers and symbols
c  313-338 upper case roman duplex
c  339-364 lower case roman duplex
c  365-384 duplex numbers and symbols
c  385-432 special mathematical symbols
c
c  Additional features added Feb., 1982
c
c  The pen may be moved back to the start point for the previous
c  character by \bs\.  This is useful, for example, in writing
c  integral signs with limits above and below them.
c
c  Symbol parameters taken from n.m.wolcott, fortran iv enhanced
c  character graphics, nbs
c
c  *x,y are the coordinates in inches from the current origin to the
c  lower left corner of the 1st character to be plotted.  If either
c  is set to 999.0 then saved next character position is used.
c  *height is the character height in inches
c  *itext is an integer array containing the text to be plotted
c  *theta is the positive ccw angle w.r.t. the x-axis
c  *ntext is the number of characters in itext to plot
c  If ntext.lt.-1 the pen is down to (x,y) and a single special
c  centered symbol is plotted. If ntext.eq.-1 the pen is up to
c  (x,y) and a single special centered symbol is plotted. If
c  ntext=0 a single simplex roman character from itext, left-
c  justified, is plotted. If ntext.gt.0 ntext characters from
c  itext are decoded and nchr characters are plotted where
c  nchr.le.ntext to remove backslashes, command codes, etc.
c
c  Written by A.Chave IGPP/UCSD Aug., 1981
c  Modified Feb., 1982 by A.Chave, R.L.Parker, and L.Shure
c  Programmed in fortran-77
c
      character text*350
      integer itext(1)
      integer istart(432),isstar(22),symbcd(4711),ssymbc(128)
      real width(432),supsub(2),raise(20)
      common /offset/ioff,just1,just2
      common /ajust/nchr,ichr(350)
      common /ialph/symbcd,istart,ssymbc,isstar
      common /iwid/width
      parameter(pi=3.1415926,rad=pi/180.)
      save xo,yo
      data factor/.75/,supsub/.50,-.50/,iup,idown/3,2/
      data cmcon/2.54/
c
c  ichr(j) contains the symbol number of the jth symbol or a
c  code to indicate space (1000),begin super-scripting (1001),
c  begin sub-scripting (1002), or end super/sub-scripting (1003),
c  or back-space (1004).
c  istart(ichr(j)) contains the address in symbol of the jth
c  character.  symbcd contains the pen instructions stored in a
c  special format.  isstar and ssymbc contain addresses and pen
c  instructions for the special centered symbols.  width contains
c  the widths of the characters.
c
c  ixtrct gets nbits from iword starting at the nstart bit from the
c  right
c
      ixtrct(nstart,nbits,iword)=mod(iword/(2**(nstart-nbits)),
     a   2**nbits)+((1-isign(1,iword))/2)*
     b   (2**nbits-min0(1,mod(-iword,
     c   2**(nstart-nbits))))
c
      yoff=0.
      si=sin(rad*theta)
      co=cos(rad*theta)
      scale=height/21.
      if(scale.eq.0.) return
      if(x.ge.999.) then
        xi=xo
      else
        xi=x
      endif
      if(y.ge.999.) then
        yi=yo
      else
        yi=y
      endif
      if(ntext.lt.0) then
c
c     plot a single special centered symbol
c
        if(ntext.lt.-1) call plot(xi,yi,idown)
        ia=itext(1)+1
        is=isstar(ia)
        ib=30
   20   ipen=ixtrct(ib,3,ssymbc(is))
        if(ipen.eq.0)then
          call plot(xi,yi,iup)
          xi=xi+20.*co
          yi=yi+20.*si
          xo=xi
          yo=yi
          return
        endif
        ix=ixtrct(ib-3,6,ssymbc(is))
        iy=ixtrct(ib-9,6,ssymbc(is))
        xx=scale*(ix-32)
        yy=scale*(iy-32)
        call plot(xi+xx*co-yy*si,yi+xx*si+yy*co,ipen)
        ib=45-ib
        if(ib.eq.30) is=is+1
        go to 20
      elseif(ntext.eq.0) then
c
c     plot a single simplex roman character
c
        isav=ioff
        ioff=0
        write(text(1:1),25)itext(1)
   25   format(a1)
        call chrcod(text,1)
        ioff=isav
        is=istart(ichr(1))
        ib=30
   40   ipen=ixtrct(ib,3,symbcd(is))
        if(ipen.eq.0) then
          xi=xi+co*scale*width(ichr(1))
          yi=yi+si*scale*width(ichr(1))
          xo=xi
          yo=yi
          return
        endif
        ix=ixtrct(ib-3,6,symbcd(is))
        iy=ixtrct(ib-9,6,symbcd(is))
        xx=(ix-10)*scale
        yy=(iy-11)*scale
        call plot(xi+co*xx-si*yy,yi+co*yy+si*xx,ipen)
        ib=45-ib
        if(ib.eq.30) is=is+1
        go to 40
      else
c
c     plot a character string
c     first find pointer array ichr containing the starts of
c     characters but only if just1 and just2 are not 1,
c     when ichr is assumed correctly transmitted through
c     common /ajust/.
c
        if(just1.ne.1.or.just2.ne.1) then
          n=ntext
          k=1
          do 50 i=1,n,4
            write(text(i:i+3),55)itext(k)
   50     k=k+1
   55     format(a4)
          call chrcod(text,n)
        endif
        just2=2
        oldwid=0.
        l=1
        rscale=scale
c
c     plot each character
c
        do 100 i=1,nchr
        ic=ichr(i)
        if(ic.eq.1000) then
c
c     plot a space
c
          xi=xi+20.*rscale*co
          yi=yi+20.*rscale*si
          xo=xi
          yo=yi
          call plot(xi,yi,iup)
        elseif((ic.eq.1001).or.(ic.eq.1002)) then
c
c     begin super-scripting or sub-scripting
c
          raise(l)=supsub(ic-1000)*height*rscale/scale
          rscale=factor*rscale
          yoff=raise(l)+yoff
          l=l+1
        elseif(ic.eq.1003) then
c
c     end super/sub-scripting
c
          rscale=rscale/factor
          l=l-1
          yoff=yoff-raise(l)
        elseif(ic.eq.1004) then
c
c     backspace-use the width of the previous letter in oldwid
c
          xi=xi-co*oldwid
          yi=yi-si*oldwid
          xo=xi
          yo=yi
        else
c
c     plot a single symbol
c
          is=istart(ic)
          ib=30
   70     ipen=ixtrct(ib,3,symbcd(is))
          if(ipen.eq.0) then
            xi=xi+co*rscale*width(ic)
            yi=yi+si*rscale*width(ic)
            xo=xi
            yo=yi
            oldwid=width(ic)*rscale
            go to 100
          endif
          ix=ixtrct(ib-3,6,symbcd(is))
          iy=ixtrct(ib-9,6,symbcd(is))
          xx=(ix-10)*rscale
          yy=(iy-11)*rscale+yoff
          call plot(xi+co*xx-si*yy,yi+co*yy+si*xx,ipen)
          ib=45-ib
          if(ib.eq.30)is=is+1
          go to 70
        endif
  100   continue
      endif
      return
      end
c
      subroutine chrcod(text,ntext)
c
c     given text string in text, ntext characters
c     returns ichr containing nchr symbol numbers or codes for
c     space (1000), begin superscripting (1001), begin
c     subscripting (1002), end super/sub-scripting (1003)
c     backspace (1004), vector (1005), or hat (1006)
c     change of font commands are decoded and executed internally
c
      common /offset/ioff,just1,just2
      common /ajust/nchr,ichr(350)
      character*(*) text
      integer irlu(95),iilu(95),iglu(26)
      data ioff/0/
c
c  irlu is a look-up table for roman characters arranged by
c  integer value for the ascii character set with an
c  offset to remove the 31 nonprinting control characters.
c  irlu returns with the symbol number or, if no symbol
c  exists, the code for space.
c
      data irlu/1000,416,428,411,72,418,419,432,67,68,69,63,70,
     a   64,71,65,53,54,55,56,57,58,59,60,61,62,414,415,
     b   385,66,386,417,407,1,2,3,4,5,6,7,8,9,10,11,12,13,
     c   14,15,16,17,18,19,20,21,22,23,24,25,26,409,1000,
     d   410,408,1000,1000,27,28,29,30,31,32,33,34,35,36,
     e   37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,
     f   405,427,406,424/
c
c  iilu is a look-up table for italic characters only.  it is
c  identical to irlu with four italic special symbols substituted
c  for regular ones.
c
      data iilu/1000,422,1000,411,72,418,419,1000,67,68,69,63,70,
     a   64,71,65,53,54,55,56,57,58,59,60,61,62,420,421,
     b   385,66,386,423,407,1,2,3,4,5,6,7,8,9,10,11,12,13,
     c   14,15,16,17,18,19,20,21,22,23,24,25,26,409,1000,
     d   410,1000,1000,1000,27,28,29,30,31,32,33,34,35,36,
     e   37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,
     f   405,427,406,424/
c
c  iglu is a look-up table for greek characters arranged by the
c  integer value of their roman expression with a=1, b=2, etc.
c  ambiguous cases give 25 for epsilon or eta, 26 for omega or
c  omicron, 27 for phi,pi,or psi, and 28 for tau or theta.  additional
c  letters must be checked for these case.  a value of 50 is returned
c  for those roman letters which have no corresponding greek letter.
c
      data iglu/1,2,22,4,25,50,3,50,9,50,10,11,12,13,26,27,50,17,18,
     a   28,20,50,50,14,50,6/
c
c     find length of string with blanks trimmed from right end
c
      do 10 n=ntext,1,-1
 10   if(text(n:n).ne.' ') go to 15
      nchr=0
      return
 15   nt=n
c
c     scan text character by character
c
      k=1
      j=1
c
c     k is current address of character in text
c     j is index of next symbol code in ichr
c
   20 if(k.gt.n) then
        nchr=j-1
        return
      endif
c
c     note char(92) is backslash
c
      if(text(k:k).ne.char(92)) then
c
c     roman character or keyboard symbol
c
        if(text(k:k).eq.'}')then
c
c     check for closing curly bracket-if found, return 1003
c
          ichr(j)=1003
          j=j+1
          k=k+1
          go to 20
        endif
c
c     ichar returns integer ascii value of character
c     offset by nonprinting characters to get entry
c     in look-up table
c
        ic=ichar(text(k:k))-ichar(' ')+1
        if(ic.le.0) then
c
c     nonprinting control character-error return
c
          ichr(j)=1000
        elseif(ioff.ne.240) then
c
c     not italic font
c
          ichr(j)=irlu(ic)
        else
c
c     italic font
c
          ichr(j)=iilu(ic)
        endif
c
c     add offset for font if not a special symbol
c
        if(ichr(j).lt.385) ichr(j)=ichr(j)+ioff
          j=j+1
          k=k+1
          go to 20
        else
c
c     backslash found
c     check next four characters for four digit number
c
          k=k+1
          read(text(k:k+3),25,err=50) number
   25     format(i4)
c
c     number found-check its validity
c
          ic=number-1000
          if((ic.gt.0).and.(ic.lt.433)) then
c
c     valid symbol code
c
            ichr(j)=ic
          elseif((ic.gt.999).and.(ic.lt.1004)) then
c
c     valid command code
c
            ichr(j)=ic
          else
c
c     not recognized-error return
c
            ichr(j)=1000
          endif
          j=j+1
c
c     move beyond closing backslash-ignore extra characters
c     function index returns offset of second substring in first
c     returns 0 if substring not found
c
          l=index(text(k:nt),char(92))
          if(l.eq.0)then
            k=nt+1
          else
            k=k+l
          endif
          go to 20
   50     continue
c
c     not a number
c     check for font change command
c
         if(text(k:k+2).eq.'sim'.or.text(k:k+2).eq.'sim') then
c
c     simplex font
c
           ioff=0
         elseif(text(k:k+1).eq.'co'.or.text(k:k+1).eq.'co') then
c
c     complex font
c
           ioff=120
         elseif(text(k:k+1).eq.'it'.or.text(k:k+1).eq.'it') then
c
c     italic font
c
           ioff=240
         elseif (text(k:k+1).eq.'du'.or.text(k:k+1).eq.'du') then
c
c     duplex font
c
           ioff=312
c
c     found the back-space code
c
         elseif(text(k:k+1).eq.'bs'.or.text(k:k+1).eq.'bs') then
           ichr(j)=1004
           j=j+1
           k=k+3
           go to 20
c
c     check for super/sub-script command
c
         elseif(text(k:k+3).eq.'sup{'.or.text(k:k+3).eq.'sup{') then
c
c     begin superscripting
c
           ichr(j)=1001
           j=j+1
           k=k+4
           go to 20
         elseif (text(k:k+3).eq.'sub{'.or.text(k:k+3).eq.'sub{') then
c
c     begin subscripting
           ichr(j)=1002
           j=j+1
           k=k+4
           go to 20
         else
c
c     Greek character or invalid character
c
           ic=ichar(text(k:k))
           igoff=min0(ioff, 120)
           if(ioff.eq.312)igoff=0
           if((ic.ge.ichar('A')).and.(ic.le.ichar('Z'))) then
c
c     upper case
c
             igr=72
             ico=ichar('A')-1
           elseif((ic.ge.ichar('a')).and.(ic.le.ichar('z'))) then
c
c     lower case
c
             igr=96
             ico=ichar('a')-1
           else
c
c     not a letter-error return
c
             ichr(j)=1000
             j=j+1
             l=index(text(k:nt),char(92))
             if(l.eq.0)then
               k=nt+1
             else
               k=k+l
             endif
             go to 20
           endif
c
c     look up the character
c
           ig=iglu(ic-ico)
           if(ig.lt.25) then
c
c     unambiguous greek letter
c
             ichr(j)=ig+igr+igoff
           elseif (ig.eq.25) then
c
c     epsilon or eta
c
             ib=ichar(text(k+1:k+1))-ico
             if(ib.eq.16) then
c
c     epsilon
c
               ichr(j)=5+igr+igoff
             elseif (ib.eq.20)then
c
c     eta
c
               ichr(j)=7+igr+igoff
             else
c
c     not a greek character-error return
c
               ichr(j)=1000
             endif
         elseif(ig.eq.26) then
c
c     omega or omicron
c
           ib=ichar(text(k+1:k+1))-ico
           if(ib.ne.13) then
c
c     not a greek character-error return
c
             ichr(j)=1000
           else
             ic=ichar(text(k+2:k+2))-ico
             if(ic.eq.5) then
c
c     omega
c
               ichr(j)=24+igr+igoff
             elseif(ic.eq.9) then
c
c     omicron
c
               ichr(j)=15+igr+igoff
             else
c
c     not a Greek character-error return
c
               ichr(j)=1000
             endif
           endif
         elseif(ig.eq.27) then
c
c     phi,pi, or psi
c
           ib=ichar(text(k+1:k+1))-ico
           if(ib.eq.8) then
c
c     phi
c
             ichr(j)=21+igr+igoff
           elseif(ib.eq.9) then
c
c     pi
c
             ichr(j)=16+igr+igoff
           elseif(ib.eq.19) then
c
c     psi
c
             ichr(j)=23+igr+igoff
           else
c
c     not a Greek character-error return
c
             ichr(j)=1000
           endif
           elseif(ig.eq.28) then
c
c    tau or theta
c
             ib=ichar(text(k+1:k+1))-ico
             if(ib.eq.1) then
c
c     tau
c
               ichr(j)=19+igr+igoff
             elseif(ib.eq.8) then
c
c     theta
c
               ichr(j)=8+igr+igoff
             else
c
c     not a Greek character-error return
c
               ichr(j)=1000
             endif
           else
c
c     not a Greek character-error return
c
             ichr(j)=1000
           endif
          j=j+1
        endif
        l=index(text(k:nt),char(92))
        if(l.eq.0) then
          k=nt+1
        else
          k=k+l
        endif
        go to 20
      endif
      end
c
      subroutine justfy(s,height,itext,ntext)
c
c     calls chrcod
c  given the text string itext with ntext characters, height height,
c  this routine
c  gives 4 distances in inches, all from the left end of the string -
c  s(1)  to the left edge of the 1st nonblank character
c  s(2)  to the center of the the string, blanks removed from the ends
c  s(3)  to the right edge of the last nonblank character
c  s(4)  to the right edge of the last character of the string.
c
      character*350 text
      dimension s(4),ipower(3),itext(350),width(432)
      common /iwid/ width
      common /offset/ ioff,just1,just2
      common /ajust/nchr,ichr(350)
      data ipower/1,1,-1/,factor/.75/
c
      ntxt=ntext
      scale=height/21.
      jquart=(ntext+3)/4
c
c     translate integer string into character variable,
c     then get pointers into the array ichr
c
      k=1
      do 90 j=1,jquart
        write(text(k:k+3),100)itext(j)
  90  k=k+4
 100  format(a4)
      call chrcod(text,ntxt)
c
c     count leading blanks.
c
      do 1100 lead=1,nchr
 1100 if(ichr(lead).ne.1000)goto 1110
      lead=ntxt
 1110 s(1)=20.0*scale*(lead-1)
      s(3)=s(1)
c
c     sum the widths of the remaining text,
c     recalling that trailing blanks
c     were lopped off by  chrcod.
c
      oldwid=0.
      do 1200 i=lead,nchr
        l=ichr(i)
        if (l.lt.1000) then
          oldwid=width(l)*scale
          s(3)=s(3) + oldwid
        endif
        if(l.eq.1000)s(3)=s(3)+20.0*scale
        if(l.ge.1001.and.l.le.1003)
     a     scale=scale*factor**ipower(l-1000)
 1200 if(l.eq.1004) s(3)=s(3)-oldwid
c
c     add on width of surplus trailing blanks.
c
      s(4)=s(3)+20.*scale*(ntxt-nchr)
c
c  find center of nonblank text.
c
      s(2)=(s(1)+s(3))/2.
      just2=1
      return
      end
c
      blockdata
c
c     block data for subroutine symbol providing 4 fonts, special
c     mathematical symbols, and centered symbols for data point
c     plotting
c     taken from Wolcott, NBS Publication
c     Modified by A.Chave, R.L.Parker, and L.Shure, IGPP/USC
c     Aug., 1981, Feb., 1982
c
c     Modified Feb. 20, 1984 by R.L.Parker and R.G.Adair
c     special symbol characters (boxes, crosses, etc.)
c     modified : removed slashes through symbols
c
c  The symbol numbers are
c  1-26    upper case roman simplex
c  27-52   lower case roman simplex
c  53-72   simplex numbers and symbols
c  73-96   upper case greek simplex
c  97-120  lower case greek simplex
c  121-146 upper case roman complex
c  147-172 lower case roman complex
c  173-192 complex numbers and symbols
c  193-216 upper case greek complex
c  217-240 lower case greek complex
c  241-266 upper case roman italic
c  267-292 lower case roman italic
c  293-312 italic numbers and symbols
c  313-338 upper case roman duplex
c  339-364 lower case roman duplex
c  365-384 duplex numbers and symbols
c  385-432 special mathematical symbolsa
c
      integer symbcd(4711),istart(432),ssymbc(128),isstar(22)
      real width(432)
      common /ialph/symbcd,istart,ssymbc,isstar
      common /iwid/width
      common /offset/ioff,just1,just2
c      data ioff,just1,just2/0,0,0/
      data(symbcd(i),i=1,114)/
     $443556555,443557579,432612882,        0,433070987,433071584,
     $323987166,328083226,325854871,317404054,317400725,325723922,
     $327657165,323364299,298156032,462268125,321889760,309339231,
     $300852123,296493907,298329038,304489675,317040204,325527312,
     $        0,433070987,433071456,319792797,325953304,327788240,
     $323429900,312845195,        0,433070987,433071840,432743830,
     $432383691,        0,433070987,433071840,432743830,        0,
     $462268125,321889760,309339231,300852123,296493907,298329038,
     $304489675,317040204,325527312,327792083,327778304,433070987,
     $462432011,432744214,        0,433070987,        0,449848720,
     $312911116,306553867,298197837,294134546,        0,433070987,
     $462431122,443262731,        0,433070987,432383627,        0,
     $433070987,433071499,466625931,466626443,        0,433070987,
     $433071883,462432011,        0,443556959,300852123,296493907,
     $298329038,304489675,317040204,325527312,329885528,328050397,
     $321889760,309329920,433070987,433071584,323987166,328083225,
     $325822102,317367189,        0,443556959,300852123,296493907,
     $298329038,304489675,317040204,325527312,329885528,328050397,
     $321889760,309343631,327450624,433070987,433071584,323987166/
      data(symbcd(i),i=115,228)/
     $328083226,325854871,317399958,447424267,        0,460236383,
     $315630752,300917597,296592281,300688471,317367892,323593937,
     $325527116,314942603,300294990,        0,441459851,426780256,
     $        0,433070993,300360780,310748555,321267406,327722784,
     $        0,426779851,460334283,        0,428876875,449848395,
     $449849035,470820555,        0,430974667,460333899,        0,
     $426779862,308655840,309002240,460333899,430974688,430286539,
     $        0,443556555,443557579,432612882,        0,433070987,
     $433071584,323987166,328083226,325854871,317404054,317400725,
     $325723922,327657165,323364299,298156032,433070987,433071776,
     $        0,443556555,443557579,426092235,        0,433070987,
     $433071840,432743830,432383691,        0,460333899,430974688,
     $430286539,        0,433070987,462432011,432744214,        0,
     $443556959,300852123,296493907,298329038,304489675,317040204,
     $325527312,329885528,328050397,321889760,309343382,319488000,
     $433070987,        0,433070987,462431122,443262731,        0,
     $443556555,443557579,        0,433070987,433071499,466625931,
     $466626443,        0,433070987,433071883,462432011,        0,
     $428877472,436938134,428189323,        0,443556959,300852123/
      data(symbcd(i),i= 229, 342)/
     $296493907,298329038,304489675,317040204,325527312,329885528,
     $328050397,321889760,309329920,433070987,462432011,433071904,
     $        0,433070987,433071584,323987166,328083225,325822102,
     $317367189,        0,428877014,293974816,324023051,323321856,
     $441459851,426780256,        0,428712733,296723360,303047775,
     $307143897,308655771,323921503,319825312,313500957,309100544,
     $445654283,441295834,298623831,296362898,300459152,315106897,
     $323561172,325822105,321725851,307068928,430974667,430286560,
     $        0,447751499,428680026,298623957,302621778,310945169,
     $321463955,325756697,330114970,        0,430285899,298394454,
     $296559517,303015136,313533983,323921626,325789330,317040331,
     $        0,455910987,455812568,313304217,302785430,296330065,
     $298263564,306554187,317072974,        0,433070987,432743448,
     $307012953,317466198,323593873,321332684,312845451,302392206,
     $        0,455812568,313304217,302785430,296330065,298263564,
     $306554187,317072974,        0,456140363,455812568,313304217,
     $302785430,296330065,298263564,306554187,317072974,        0,
     $430548563,321562135,317465945,307012632,298525523,296264590,
     $302392459,312845772,321323008,445654176,303014876,300266265/
      data(symbcd(i),i=343,456)/
     $309100544,455910985,318973381,312616068,302167638,317465945,
     $307012632,298525523,296264590,302392459,312845772,321323008,
     $433070987,432710744,309110169,319563349,321224704,430973855,
     $300950433,296760217,298156032,435168287,305144865,300954649,
     $302261189,295838404,        0,433070987,453813135,441034315,
     $        0,433070987,        0,432841611,432710744,309110169,
     $319563349,321238613,327952281,338471128,344631563,        0,
     $432841611,432710744,309110169,319563349,321224704,441230360,
     $298525523,296264590,302392459,312845772,321332881,323593814,
     $317465945,307003392,432841604,432743448,307012953,317466198,
     $323593873,321332684,312845451,302392206,        0,455910980,
     $455812568,313304217,302785430,296330065,298263564,306554187,
     $317072974,        0,432841611,432645078,304882905,315392000,
     $453715416,311207001,298591062,298460179,313075153,319268366,
     $317072651,304456588,296157184,435168207,302392459,310752025,
     $309100544,432841615,300295243,310748556,321369689,321224704,
     $428647563,453813387,        0,430744651,447521867,447522379,
     $464299595,        0,430745099,453813067,        0,428647563,
     $453813387,302228357,293741252,        0,453813067,430745113/
      data(symbcd(i),i=457,570)/
     $430286347,        0,443327576,300622740,296264526,298198027,
     $306554124,317171282,325789465,443327833,315368918,321332876,
     $325429003,        0,449848607,307143705,300622738,296100612,
     $449848864,323954331,321693208,315335895,443262294,317335058,
     $319268301,314975499,306553868,300327824,        0,426451800,
     $300721177,306980055,311043344,308655833,323692116,308651079,
     $302120960,447521945,302785430,296330064,298230732,304456907,
     $312878542,319333908,317433177,309175453,307209440,313533919,
     $321814528,451650968,311207001,300688342,302654675,443130834,
     $296231758,298198027,308651340,317128704,445654175,305079389,
     $307111259,319665691,311206999,298459985,296199053,302359753,
     $310617349,308421700,302186496,426418967,298624025,304882774,
     $302588811,436806806,311174553,319596183,323626575,314703872,
     $426418967,298624025,304882774,302556174,304489611,310748556,
     $319268433,323626713,325985951,319825312,313468252,315401750,
     $323626834,        0,437035922,296166220,298165259,306619599,
     $        0,437035787,457975385,319595928,306848787,300528595,
     $304686225,310781259,314942924,        0,426779488,300917790,
     $319141017,293961728,439132868,436904912,300328011,308651340/
      data(symbcd(i),i=571,684)/
     $317138514,460105298,319235596,321234635,329688975,        0,
     $430744601,300524430,296072857,321594900,315139278,302392139,
     $        0,445654175,305079389,307111259,319665499,307045401,
     $300655573,304719122,315176210,302556048,296166220,300229832,
     $310617349,306324484,        0,441230360,298525523,296231821,
     $300295243,308651340,317138449,319432151,315368729,307003392,
     $443327435,453813843,323430091,428549016,304916377,        0,
     $432645008,300327948,306554123,314975758,321431124,319530456,
     $313304281,304882646,298427012,        0,462202009,302785430,
     $296330064,298230732,304456907,312878542,319333908,317433240,
     $311197696,447521931,428549016,304916249,        0,426418967,
     $298624025,304882774,300426189,304456907,314975758,323561174,
     $325877760,441197591,298492754,296199053,300295243,310748620,
     $323430161,329918295,325887577,317433171,308749316,        0,
     $428647321,302753158,318908036,460105367,319431561,293806788,
     $        0,458237060,426418967,298624025,304882774,302556174,
     $304489675,312845836,323430161,332081113,        0,441230360,
     $298492754,296199052,300262475,308684111,449422671,314975691,
     $321234636,329754514,332048216,327974912,445653835,445654731/
      data(symbcd(i),i=685,798)/
     $445556363,434677265,426091595,451258187,        0,435168203,
     $437265419,428877344,326084382,330180442,327952087,319501856,
     $323987166,328083226,325854871,319501334,319497941,327821138,
     $329754381,325461515,293975574,323659476,327755535,325494412,
     $319127552,460236570,328214237,321889696,311436383,300852123,
     $296493907,298329038,304489739,314943052,325527312,445654175,
     $302949339,298591123,300426254,306586891,        0,435168203,
     $437265419,428877216,321890013,328050520,329885456,325527116,
     $314942219,449848863,323921627,327952147,325592718,319169931,
     $        0,435168203,437265419,449652114,428877600,328017632,
     $436938134,428189451,327722699,        0,435168203,437265419,
     $449652114,428877600,328017632,436938134,428188875,        0,
     $460236570,328214237,321889696,311436383,300852123,296493907,
     $298329038,304489739,314943052,325530912,307209245,300786584,
     $298427344,302457996,310752979,325433107,327530003,334069760,
     $435168203,437265419,462432011,464529227,428877024,456140832,
     $436938518,428188875,455452683,        0,435168203,437265419,
     $428877024,428188875,        0,445654287,308683851,300262220,
     $294069008,296264592,296203488,308782220,304460832,317718528/
      data(symbcd(i),i=799,912)/
     $435168203,437265419,464528403,447457099,445359883,428877024,
     $456140768,428188875,455452619,        0,435168203,437265419,
     $428877024,428189387,325625483,        0,435168203,437265806,
     $435168651,464528779,464529227,466626443,428876832,464529504,
     $428188811,457549899,        0,435168203,437266189,437200651,
     $462432011,428876832,456140768,428188811,        0,445654111,
     $300852123,296461140,298329038,304489739,314943052,325527312,
     $329918295,328050397,321889696,311440672,307209245,300786583,
     $298460112,302457996,310752651,319170190,325592852,327919323,
     $323921439,315621376,435168203,437265419,428877344,326084382,
     $330180441,327919318,319464469,454043295,326051612,327984855,
     $323692053,428188875,        0,445654111,300852123,296461140,
     $298329038,304489739,314943052,325527312,329918295,328050397,
     $321889696,311440672,307209245,300786583,298460112,302457996,
     $310752651,319170190,325592852,327919323,323921439,315634765,
     $304555152,310945105,317203982,321103494,327362376,329561614,
     $321201800,325297927,329515008,435168203,437265419,428877344,
     $326084382,330180442,327952087,319497238,454043295,326051612,
     $328017624,323724822,428188875,447423957,319432397,327558988/
      data(symbcd(i),i=913,1026)/
     $331789781,319399564,325429067,331786126,        0,458139360,
     $325920413,319792480,307241951,296657755,298623960,304850389,
     $321529554,430810073,304883158,321562260,325658318,321267083,
     $308651020,298263377,296067982,        0,443557067,445654283,
     $430973722,294659808,325920416,436577739,        0,435168209,
     $302457996,312845771,323364622,329820000,437265425,304555212,
     $312849184,309343904,336592896,430974219,433071374,460334347,
     $426779744,451946336,        0,433071243,435168400,449848459,
     $449848971,451946128,466626187,426779808,460335200,        0,
     $430974603,433071819,460333899,426779744,451946336,426091595,
     $451258187,        0,430974229,310752160,313173323,462431573,
     $426779744,454043552,438674955,        0,458236747,460333963,
     $433070938,296756960,430286539,325625483,        0,445653835,
     $445654731,445556363,434677265,426091595,451258187,        0,
     $435168203,437265419,428877344,326084382,330180442,327952087,
     $319501856,323987166,328083226,325854871,319501334,319497941,
     $327821138,329754381,325461515,293975574,323659476,327755535,
     $325494412,319127552,435168203,437265419,428877536,325920416,
     $428188875,        0,445653771,445654795,445556427,430319308/
      data(symbcd(i),i=1027,1140)/
     $428189451,        0,435168203,437265419,449652114,428877600,
     $328017632,436938134,428189451,327722699,        0,458236747,
     $460333963,433070938,296756960,430286539,325625483,        0,
     $435168203,437265419,462432011,464529227,428877024,456140832,
     $436938518,428188875,455452683,        0,445654111,300852123,
     $296461140,298329038,304489739,314943052,325527312,329918295,
     $328050397,321889696,311440672,307209245,300786583,298460112,
     $302457996,310752651,319170190,325592852,327919323,323921439,
     $315634841,306787865,319370390,319501461,319455232,435168203,
     $437265419,428877024,428188875,        0,435168203,437265419,
     $464528403,447457099,445359883,428877024,456140768,428188875,
     $455452619,        0,445653835,445654731,445556363,426091595,
     $451258187,        0,435168203,437265806,435168651,464528779,
     $464529227,466626443,428876832,464529504,428188811,457549899,
     $        0,435168203,437266189,437200651,462432011,428876832,
     $456140768,428188811,        0,433103708,464561948,441197651,
     $455878163,432513866,463972106,433039135,433006366,441132566,
     $441099797,432449293,432416524,        0,445654111,300852123,
     $296461140,298329038,304489739,314943052,325527312,329918295/
      data(symbcd(i),i=1141,1254)/
     $328050397,321889696,311440672,307209245,300786583,298460112,
     $302457996,310752651,319170190,325592852,327919323,323921439,
     $315621376,435168203,437265419,462432011,464529227,428877856,
     $428188875,455452683,        0,435168203,437265419,428877344,
     $326084382,330180441,327919318,319464469,454043295,326051612,
     $327984855,323692053,428188875,        0,430974230,293974816,
     $309015328,326117146,324023116,323367691,325429009,323321856,
     $443557067,445654283,430973722,294659808,325920416,436577739,
     $        0,428712733,296723360,303047775,307143897,308654877,
     $298820639,307148507,326018719,321922528,315598173,311207179,
     $460236383,317695325,436577739,        0,445654283,447751499,
     $441295834,298623831,296362898,300459152,317204113,325658388,
     $327919321,323823067,307082395,302851033,298558356,300491793,
     $306722256,321431186,325723863,323790426,317568096,319829067,
     $319127552,430974603,433071819,460333899,426779744,451946336,
     $426091595,451258187,        0,447751499,449848715,428647258,
     $300721173,304718994,310948698,298623957,302621778,310945233,
     $323561171,327853913,332215761,321463955,325756697,332212185,
     $441460320,440772171,        0,430384011,306553871,298427222/
      data(symbcd(i),i=1255,1368)/
     $296559517,303015136,317728415,328116058,329983763,323462667,
     $327526222,436708306,298525594,300852319,309343712,321890013,
     $328017686,325658255,432415820,455485196,        0,434873302,
     $298525591,300688473,313304536,319530581,321332876,325432855,
     $319235660,325429003,453682644,304718738,296231758,298198091,
     $310748556,319239251,300491664,298263500,304447488,435168203,
     $437265419,436937880,311207321,321660630,327788305,325527116,
     $314942731,306586638,449619480,323692243,325625486,319169931,
     $428876832,        0,455812629,321529493,323692056,315401433,
     $302785430,296330065,298263564,308651339,319170190,443327576,
     $300622739,298361806,304489675,        0,456140363,458237579,
     $455812568,313304281,302785430,296330065,298263564,308651339,
     $317072974,443327576,300622739,298361806,304489675,449848992,
     $455452491,        0,432645779,323659351,319563161,309109784,
     $298525523,296264590,302392523,312845836,323434067,321594904,
     $443327576,300622739,298361806,304489675,        0,445621470,
     $311338334,313500960,307242015,300852171,441459807,302949387,
     $428647705,428188875,        0,441230360,300655509,298427345,
     $302523535,310879632,317236755,319464919,315368729,307016728/
      data(symbcd(i),i=1369,1482)/
     $300622802,302527888,317269462,315373015,319563417,323757592,
     $434676624,296166221,298165322,314910281,323236685,298198091,
     $314943050,323233415,321037700,302129989,293839624,296035339,
     $        0,435168203,437265419,436937880,313304537,323757782,
     $325432793,321660566,323334944,303051531,308655563,331710464,
     $435168159,300885023,300954585,300266521,302363417,302822155,
     $308641792,437265375,302982239,303051865,304325637,297935620,
     $291676870,293839686,293778457,302228421,297939801,304906240,
     $435168203,437265419,458007567,447325899,445228683,428876832,
     $451716953,428188875,451258187,        0,435168203,437265419,
     $428876832,428188875,        0,434938827,437036043,436937880,
     $313304537,323757782,325432793,321660566,323335894,330049561,
     $340568408,348858763,474786072,346761547,428647449,428188875,
     $451258251,474327627,        0,434938827,437036043,436937880,
     $313304537,323757782,325432793,321660566,323334937,302822155,
     $308655563,331710464,443327512,298525523,296264590,302392523,
     $312845836,323430097,325691030,319563097,309114073,304882646,
     $298427281,300360780,308655435,317072974,323528339,321594840,
     $313294848,434938820,437036036,436937880,311207321,321660630/
      data(symbcd(i),i=1483,1596)/
     $327788305,325527116,314942731,306586638,449619480,323692243,
     $325625486,319169931,428647449,427959492,        0,455910980,
     $458008196,455812568,313304281,302785430,296330065,298263564,
     $308651339,317072974,443327576,300622739,298361806,304489675,
     $448931652,        0,434938827,437036043,436839510,309077337,
     $319596120,321627670,317433368,428647449,428188875,        0,
     $451651097,319464919,315368729,302818200,296461141,298460179,
     $313042384,319271766,298492948,313075153,319301133,317072715,
     $304456652,298230607,296067981,        0,435168207,302392459,
     $310748556,317142048,302490700,306557721,311197696,434938830,
     $302392523,312845836,323433497,302457932,308655769,323335897,
     $325432089,302822873,325891723,331710464,430744779,432841933,
     $455910603,426550361,447522521,        0,432841867,434939022,
     $449619083,449619595,451716750,466396811,426550425,460105817,
     $        0,432842315,434939531,458007435,428647577,449619737,
     $428188811,449160971,        0,432841995,434939149,458007819,
     $306422789,297935684,293774150,297972505,307017113,327974912,
     $453813067,455910283,432841557,296527449,430286411,321365515,
     $        0,445424728,300622740,296264526,298198091,308651340/
      data(symbcd(i),i=1597,1710)/
     $319268498,327886681,445424792,302719956,298361742,300295243,
     $445425049,319563350,325527308,329627033,317466134,323430092,
     $329623435,        0,451945759,307143705,300622738,296100612,
     $451945823,309240921,302719954,298197828,451946080,326084382,
     $328050393,323757527,309048928,326051547,323790424,317437143,
     $317400660,323561103,321299980,312845515,304489485,300430551,
     $315303444,321463887,319202764,312836096,426451800,300721241,
     $309077271,313140560,310780996,428581784,306980119,462202582,
     $323626317,306455556,460105366,321529165,        0,451683673,
     $309109784,298492754,296199053,300295243,308651404,319268434,
     $321562135,311305438,309339425,315663904,323957977,304882645,
     $298394510,300299467,312878543,319366678,317465947,311338271,
     $313533920,323944448,455812568,313304153,300688342,304751891,
     $439133208,302720148,311014675,300491600,296166284,304456971,
     $314975758,445228050,298328974,300295243,        0,447751391,
     $307176605,309208475,325953244,319661337,304849812,296264527,
     $298230859,310682951,312648964,306324549,449651863,300557201,
     $298296269,304447488,426418967,298624089,306979990,304686027,
     $437036120,304817170,298169426,309011800,317498969,325854999/
      data(symbcd(i),i=1711,1824)/
     $327821007,318912089,325822164,323462596,        0,426418967,
     $298624089,306979990,304653390,306586827,437036120,304817169,
     $302457932,308651339,317072974,325625620,330082141,328181408,
     $319825310,315499993,321595092,331953612,321365649,325723929,
     $328115935,324009984,437035922,296166220,298165323,308716815,
     $439133138,298263436,300253184,437035787,439133003,458008280,
     $327952089,321693144,308946003,300528723,308880716,314946643,
     $306783500,312845771,321267407,        0,430973920,305112222,
     $309208654,323364555,435168350,307111438,321267403,327529753,
     $293975321,296058880,439132868,441230084,439034896,302425227,
     $310748556,319235729,462202446,321267339,329623501,336050009,
     $323430028,325419008,437035915,439133203,300360587,460105365,
     $319338265,325789332,319333775,308716620,298169177,304906240,
     $447751391,307176605,309208475,321762715,307045401,300655573,
     $304719122,317273499,309142617,302752789,306816274,445195281,
     $298328910,296100810,310650183,312648900,304231698,304653264,
     $298263436,302327048,        0,443327512,298492754,296199053,
     $300295243,308651404,319268434,321562135,317465945,309114073,
     $304882645,298394510,300299467,312878543,319366678,317456384/
      data(symbcd(i),i=1825,1938)/
     $443294667,443294731,455878219,455878283,428549016,304916377,
     $428549015,304883608,        0,432546765,302392459,310748620,
     $321365650,323659351,319563161,311207000,300589970,289551627,
     $314975759,321463894,319567129,306979861,300491460,        0,
     $464299225,302785429,296297295,298230732,304456907,314975759,
     $321463893,319530456,313308377,304882645,298394510,300299467,
     $312878543,319366678,317470168,330039296,447489163,447489227,
     $428549016,304916249,428549015,304883480,        0,426418967,
     $298624089,306979990,302523405,306557977,304882774,300426189,
     $302392459,308651404,319235729,325723863,323790424,323725012,
     $457746135,        0,441197591,298492754,296199053,300295243,
     $310748620,323430161,329918295,325887577,317433171,308749316,
     $430416845,304489740,317105807,327726935,325854808,317400403,
     $308716612,        0,428647321,302785622,314811845,318911385,
     $300688406,312714629,318908036,460105367,319431561,293806788,
     $        0,456139972,458237060,426418967,298624089,306979990,
     $304653390,308684172,319203024,329888793,304882774,302556174,
     $304489675,314942988,323430161,329885657,        0,432710679,
     $309077145,302785429,296297295,298197963,304456908,312976786/
      data(symbcd(i),i=1939,2052)/
     $430416781,300295244,308716879,447292751,314975691,321234636,
     $329754514,332048216,327984856,330016661,447194509,317072972,
     $325494607,        0,451945099,451945995,449783243,432580049,
     $419799947,444966539,        0,443556683,445653899,437266144,
     $332376029,334342040,330016406,460334943,332310427,330049303,
     $323695702,323692309,329885521,327624332,314942091,457909973,
     $327788305,325527116,314933248,462366558,332408666,330180382,
     $326084192,315630815,305046490,298558291,296231821,300295307,
     $312845772,321332880,449848607,307143706,300655507,298329037,
     $302392459,        0,443556683,445653899,437266016,328181598,
     $332244887,329885391,321299916,308650635,456140511,328148827,
     $330016531,323462669,314975435,        0,443556683,445653899,
     $453846418,437266400,332212128,439035350,423994955,325592587,
     $        0,443556683,445653899,453846418,437266400,332212128,
     $439035350,423994443,        0,462366558,332408666,330180382,
     $326084192,315630815,305046490,298558291,296231821,300295307,
     $310748620,321332946,449848607,307143706,300655507,298329037,
     $302392459,444966284,319235730,451487634,        0,443556683,
     $445653899,470820491,472917707,437265888,464529696,439035734/
      data(symbcd(i),i=2053,2166)/
     $423994443,451258251,        0,443556683,445653899,437265888,
     $423994443,        0,456140047,308716684,302359435,294003406,
     $292037393,296231695,454042831,306619403,447751968,        0,
     $443556683,445653899,472917011,451651275,449554059,437265888,
     $464529632,423994443,451258187,        0,443556683,445653899,
     $437265888,423994955,325625355,        0,443556683,443557131,
     $445654349,472917259,472917707,475014923,437265696,472918368,
     $423994379,453355467,        0,443556683,443557518,443459211,
     $470820491,437265632,464529632,423994379,        0,449848543,
     $305046490,298558291,296231821,300295243,310748620,321332945,
     $327821144,330147614,326084192,315635104,311403677,302851031,
     $298427280,300328011,444966284,319235729,325723928,328050398,
     $321912832,443556683,445653899,437266208,334473245,336439256,
     $329983573,304789280,332376029,334342040,327886421,423994443,
     $        0,449848543,305046490,298558291,296231821,300295243,
     $310748620,321332945,327821144,330147614,326084192,315635104,
     $311403677,302851031,298427280,300328011,444966284,319235729,
     $325723928,328050398,321926093,300360720,306750673,313009550,
     $314811846,321070728,323270030,316941831,321103496,        0/
      data(symbcd(i),i=2167,2280)/
     $443556683,445653899,437266144,332376029,334342040,330016406,
     $304821984,330278813,332244824,327919254,449521173,321529484,
     $325429067,331786126,455747277,327558988,331788939,304447488,
     $464463774,334505882,332277598,328181344,313533599,302949403,
     $304915608,321529554,437101721,321562260,325658319,323397196,
     $314942603,300295053,296198993,293970765,298221568,451945547,
     $454042763,439362458,303048672,332212128,432383307,        0,
     $441459669,298361742,300295307,314943052,325527313,336606432,
     $302687185,300360716,306557920,315635552,342884352,437265483,
     $439362701,466625611,433071392,458237984,        0,441459723,
     $443556941,458236939,458237451,460334669,475014667,435168672,
     $468724064,        0,439363083,441460299,468722379,435168608,
     $460335200,421897163,447063755,        0,437265686,304460896,
     $313205899,468723030,433071392,460335200,432383307,        0,
     $466625227,468722443,441459674,305145824,426092107,325625355,
     $        0,466527124,331710464,432973716,298156032,455747095,
     $317465945,309109784,298492754,296199053,300295243,308651404,
     $319235665,323692187,321857055,315630816,305112094,302949469,
     $305083609,304882645,298394510,300299467,312878542,319333974/
      data(symbcd(i),i=2281,2394)/
     $321758750,315621376,428877067,430974221,462431499,428877600,
     $430941919,        0,453780889,309109784,298525523,296231821,
     $300295307,312845772,443327576,300622739,298329037,302392459,
     $432612754,        0,466625433,331953040,331887499,331710464,
     $433072025,298398608,331887499,331710464,468166479,325592658,
     $315303255,309077080,300655509,298427345,304620752,313042322,
     $321595096,330082265,        0,468821922,334538786,336701412,
     $330442467,321955359,317597080,310781128,306394786,321922588,
     $315106636,310682823,304260036,295838469,293806919,298001221,
     $        0,468821922,334538786,336701412,330442467,321955359,
     $317597080,310781128,306394786,321922588,315106636,310682823,
     $304260036,295838469,293806919,298001221,447587482,302785493,
     $300524560,306652493,317105806,327690067,329951000,323823067,
     $313360384,470394833,329787088,321431058,313206039,306979864,
     $298558293,296330129,302523536,310945106,319497815,325855064,
     $334211093,336166912,449717643,432678804,432383883,        0,
     $449717643,432940956,432678804,        0,432908045,462267277,
     $        0,451847580,317564444,317633428,336213453,314975691,
     $319169997,        0,439493700,441590916,479340804,481438020/
      data(symbcd(i),i=2395,2508)/
     $431106660,430056836,469903940,        0,434807700,300524564,
     $300580864,430744665,317109273,317044772,317030400,435299926,
     $297939876,319501156,319468388,345123229,343028677,344109956,
     $344074635,341966848,447751327,302916570,298558290,296166284,
     $302359691,312878543,319333972,323790493,321889760,313537888,
     $309306460,302851031,298394510,300295179,440771852,315074001,
     $319432281,321824287,317731798,319488000,443688035,303113184,
     $300885020,304981145,306947093,439460897,303015005,307111130,
     $309077142,298460306,308815054,306586699,302294023,304264211,
     $306750607,304522252,300229576,302195781,308412416,435299427,
     $307307744,309273756,304981017,302752917,439461025,307209309,
     $302916570,300688406,311043090,300426190,302392395,306488455,
     $304264339,302556175,304522380,308618440,306390085,300023808,
     $462169818,321758619,311239897,306914451,308847952,319301265,
     $325694875,311207126,308913425,313014043,325691089,329787344,
     $338241685,340502618,336471966,328181344,315630815,305079260,
     $298656599,296362897,300393549,308684171,321234700,331786190,
     $464365331,327722832,        0,426321109,325661394,309012178,
     $        0,298394766,308651209,306390020,300032901,295936842/
      data(symbcd(i),i=2509,2622)/
     $298263570,306881880,317498969,327952214,329852686,323364363,
     $317040012,315041231,319235533,455911128,327886610,325527180,
     $        0,458008082,317138380,319137483,329688975,460105298,
     $319235596,321238546,319464920,313304281,302785429,296297295,
     $298230732,304456907,312878543,319370457,304882645,298394510,
     $300285952,441459603,298329037,302396640,300528595,302720152,
     $311207321,319563351,323659410,321365452,310748299,302392271,
     $300529176,321594962,319268236,310752224,309329920,453715477,
     $321562198,319563161,309109784,298492754,296199053,300295243,
     $308651404,319272153,304882645,298394510,300285952,462431762,
     $317138380,319137483,329688975,464528978,319235596,321238546,
     $319464920,313304281,302785429,296297295,298230732,304456907,
     $312878543,319370457,304882645,298394510,300299872,330301440,
     $432546961,313075220,321594904,315401433,302785429,296297295,
     $298230732,304456907,314975758,443327576,300589970,298263500,
     $        0,456107550,321824414,323987040,317728095,311370972,
     $307012555,298033989,451945822,311305432,304587787,300163974,
     $295871172,287449605,285418055,289612357,432842265,        0,
     $460105163,314844421,304227204,293774022,291742472,295936774/
      data(symbcd(i),i=2623,2736)/
     $458007947,312747205,304231954,319464920,313304281,302785429,
     $296297295,298230732,304456907,312878543,319370457,304882645,
     $298394510,300285952,441459467,443556683,434709590,309077337,
     $317498968,323724949,319268364,321238489,321627733,317171148,
     $319137483,329688975,435168480,        0,443557023,309273887,
     $309342933,294364057,304915608,306881551,302392395,437036120,
     $304784335,300295179,308651341,315064320,445654239,311371103,
     $311440149,296461273,307012824,308978699,300163974,295871172,
     $287449605,285418055,289612357,439133336,306881483,298066758,
     $291635200,441459467,443556683,457975383,323692247,325854873,
     $321693144,308946003,300528723,308880716,314946643,306783500,
     $312845771,321267407,435168480,        0,441459602,296166220,
     $298165323,308716815,443556818,298263436,300266464,309329920,
     $426418967,298624089,306979990,304686027,437036120,304817170,
     $298169426,309011800,317498969,325854999,327853643,455911127,
     $325756427,459876182,334243929,342665560,348891541,344434956,
     $346405081,346794325,342337740,344304075,354855567,        0,
     $426418967,298624089,306979990,304686027,437036120,304817170,
     $298169426,309011800,317498969,325854999,327853711,323364555/
      data(symbcd(i),i=2737,2850)/
     $455911127,325756495,321267339,329623501,336035840,443327512,
     $298492754,296199053,300295243,308651404,319268434,321562135,
     $317465945,309114073,304882645,298394510,300299467,312878543,
     $319366678,317456384,426418967,298624089,306979990,304685892,
     $437036120,304817170,293745746,306881816,315401753,323757783,
     $327853842,325559884,314942731,306586703,304690840,325789394,
     $323462668,314946116,302120960,458007812,460105028,453584405,
     $317465945,309109784,298492754,296199053,300295243,308651340,
     $317171218,443327576,300589970,298263500,438445572,        0,
     $426418967,298624089,306979990,304686027,437036120,304817170,
     $298169426,309011800,317498969,323757719,321594903,321650688,
     $453748246,321594967,319563097,307012568,298558357,300557712,
     $317174678,300590481,317203917,314975435,302359372,294036238,
     $296166221,        0,443556818,298263436,300262539,310814031,
     $445654034,300360652,302363481,315392000,426418967,298624089,
     $306979989,302490637,306557977,304882773,300393421,302392459,
     $310748556,319235730,462202514,321332812,323331915,333883407,
     $464299730,323430028,325419008,426418967,298624089,306979989,
     $302490637,306557977,304882773,300393421,302392459,308651404/
      data(symbcd(i),i=2851,2964)/
     $319235729,325756633,323790551,        0,426418967,298624089,
     $306979989,302490637,306557977,304882773,300393421,302392459,
     $310748556,319235664,460105296,321300108,327526283,335947918,
     $342370580,344762585,344700697,323495565,327516160,430613464,
     $304915737,313238868,443327767,311043280,306652172,298165067,
     $294003469,296166285,296105168,308716811,317040204,325564120,
     $323725014,327919384,325887641,319563158,313140496,310814027,
     $        0,426418967,298624089,306979989,302490637,306557977,
     $304882773,300393421,302392459,310748556,319235730,464299595,
     $319038853,308421636,297968454,295936904,300131206,462202379,
     $316941637,308412416,460105367,319464463,298230603,432710615,
     $304915737,319534039,304882968,319530647,432448525,310781388,
     $321303565,310748619,321300111,        0,433202052,435299268,
     $433202532,432153924,        0,443688132,445785348,431105316,
     $430056708,        0,447751044,460334340,432711445,430417615,
     $        0,447653148,313370012,315532639,309339232,300917661,
     $298689497,304850324,434939158,315237842,317203854,310785048,
     $298525524,296297360,302458187,432547021,312845705,314811717,
     $308421700,300065671,298066889,302261191,        0,441459806/
      data(symbcd(i),i=2965,3078)/
     $307111134,307246240,306328725,304686212,308880533,428647320,
     $302818202,294433561,319599897,315368985,315434265,        0,
     $434938776,300655640,300725197,298197963,302392269,        0,
     $434938776,300655640,300725195,298197965,302392330,300163975,
     $        0,435168158,300491806,300954590,300692429,298197963,
     $302392269,        0,432939995,298656603,296625054,300917856,
     $311436767,319759964,321725976,317433045,308884768,315598302,
     $319694362,317465942,442934412,308651276,308707328,468722507,
     $441459998,311305434,304915417,296592221,298820640,307242271,
     $317662878,330278880,459875921,319268365,323331851,331753422,
     $333981522,325648384,468461463,334178327,336340953,332179288,
     $327886481,319235468,310748235,298197838,296264595,311141785,
     $317564381,315598112,307209309,304981144,311076430,325461899,
     $333817868,335983691,300295054,298361811,304788571,307013262,
     $327559051,        0,437035992,302752856,302822221,294003531,
     $298188800,437035992,302752856,302822219,294003533,298197899,
     $296002247,        0,441459807,300528799,300528800,309306323,
     $430351116,296067980,296124416,439231643,304948251,302916702,
     $307209568,321922847,330213211,327984856,313205973,308913426/
      data(symbcd(i),i=3079,3192)/
     $315176544,326084381,328050393,323757591,440837196,306554060,
     $306610176,430482259,298525719,306947350,319399570,327755667,
     $334148435,298492950,306914581,319366801,327722898,334145495,
     $        0,445784916,310509568,433202516,297926656,433202052,
     $        0,435168153,437265305,451945881,454043033,        0,
     $323397323,441131922,296231758,298197835,430449612,432612240,
     $300360652,296072531,323761693,319628888,325854938,321758749,
     $453944922,325844992,437265311,296657755,298624024,306980121,
     $313369949,311403680,303038464,464201748,329856665,334112399,
     $432678868,        0,454042756,456139844,445424664,298525523,
     $296231822,302392523,314943116,327624529,329918230,323757529,
     $311211289,304882646,298427280,300360780,308655499,321267406,
     $327722772,325789272,317489152,443557017,445654169,        0,
     $306787478,304751824,306652240,308946070,441001092,440673350,
     $306324678,306459417,298591257,298656537,428647961,445425048,
     $319595930,311210763,298132491,298197771,428189195,444966282,
     $319137164,310738944,443556895,298722135,296362895,302392523,
     $312845836,323462868,325822108,319792480,309329920,437134493,
     $313533771,        0,432907164,300885023,307242400,319792734/
      data(symbcd(i),i=3193,3306)/
     $323888794,321660373,296068811,        0,435168928,311174616,
     $321627798,325691089,323429900,312845451,300295053,296189952,
     $451945298,327759328,317030400,456139744,298558424,307012953,
     $319563414,325691089,323429900,312845451,300295053,296189952,
     $458139231,315630880,305112028,298558354,300360780,310748491,
     $319170190,325625554,323659287,313271576,304849877,298385408,
     $460334155,430974688,        0,441459679,298754971,300721240,
     $313239062,323626706,325559949,321267083,306553804,298230607,
     $296297364,302720215,317466201,323856029,321889696,307232768,
     $458008150,317334803,308913172,298525529,296559517,303015136,
     $311436767,321824409,323626575,317072651,306553804,298254336,
     $451847627,432678932,        0,432678932,        0,466756356,
     $        0,432777239,432580625,        0,447882466,305112027,
     $298525586,300328009,308487492,        0,431104994,305112283,
     $311108882,308716617,300098372,        0,441263246,430679505,
     $451650385,        0,436609995,298197965,302392330,300163975,
     $        0,434545548,300262412,300318720,441590919,449979783,
     $460236383,315630752,300917597,296592281,300688471,317367892,
     $323593937,325527116,314942603,300294990,        0,443556895/
      data(symbcd(i),i=3307,3420)/
     $298722135,296362895,302392523,312845836,323462868,325822108,
     $319792480,309343456,305112094,300819351,298460111,302425164,
     $308655435,317072909,321365652,323724892,319759839,313524224,
     $437134493,313533771,445621515,436577867,        0,432939995,
     $298656603,296625054,300917920,315631199,323954396,325920408,
     $317400212,302621585,296166219,449848863,321857180,323823192,
     $315303060,430351246,302458188,319170189,325530638,312845899,
     $323364558,325582848,432939995,298656603,296625054,300917920,
     $315631199,323921562,321660311,309048736,319792733,321725976,
     $315340183,319497876,325658319,323397196,314942603,300295053,
     $296198992,298361808,298301013,323561103,321299980,314933248,
     $449783179,451945931,451945233,327726283,323321856,435168086,
     $430646232,307012953,319563414,325691089,323429900,312845451,
     $300295053,296198992,298361808,298300761,317466198,323593873,
     $321332684,312849376,321926111,311404128,        0,456042012,
     $321758876,323921503,317728032,305112029,298689367,296264590,
     $302392523,312845836,323430097,325658261,319530328,311174231,
     $300589970,445654175,302949339,298558353,300360780,308655435,
     $317072974,323528338,321562071,313262080,430973786,430842782/
      data(symbcd(i),i=3421,3534)/
     $303047840,317630045,323954400,433005599,307209693,460334813,
     $323822997,313107728,310752922,313173267,308815051,        0,
     $441459679,298754970,300688535,315336280,323823261,321889696,
     $307246240,303014877,300753944,306951575,319563354,321824287,
     $315634839,300622741,296330063,298230732,306554251,321267341,
     $325560019,323659350,315339927,302719957,298427279,300327948,
     $306558347,319170125,323462803,321562134,315326464,458008150,
     $317334803,308913172,298525529,296559517,303015136,313533983,
     $323921626,325723792,321332684,310748235,300295054,298296272,
     $302490574,443130964,300622745,298656733,305112288,447751647,
     $321824410,323626576,319235468,310738944,451847627,432678932,
     $        0,432678932,        0,466756356,        0,432777239,
     $432580625,        0,447882466,305112027,298525586,300328009,
     $308487492,443622494,302883798,300491789,304424134,        0,
     $431104994,305112283,311108882,308716617,300098372,435233886,
     $307078358,308880525,304423878,        0,441459860,430876119,
     $451846999,        0,434480012,300327948,302326728,298024960,
     $434545548,300262412,300318720,441590919,449979783,458139228,
     $323856092,326018655,315630752,300917597,296592281,300688471/
      data(symbcd(i),i=3535,3648)/
     $317367892,325661531,300721240,317400661,323626706,325527116,
     $314942603,300294990,296199056,300393358,        0,449848543,
     $305046490,298558291,296231821,300295243,308651404,319235729,
     $325723928,328050398,323986976,315635104,311403677,302851031,
     $298427280,300328011,442869068,317138513,323626712,325953182,
     $319815680,449717323,454042763,454042973,307078170,451847387,
     $302841856,439231643,304948251,302916702,307209568,319825631,
     $328115995,325887575,315270291,300458831,291878432,323987165,
     $325953177,319530131,428254030,300360972,317072973,323466190,
     $310748619,321267343,        0,439231643,304948251,302916702,
     $307209568,319825631,328115995,325887511,313210400,323987165,
     $325953177,319534294,313206293,321529490,323462733,319169867,
     $304456588,296133391,294134609,298328911,447423957,319432274,
     $321365517,317072715,        0,458204427,460334411,460333841,
     $327712768,443556758,443557728,443524639,330314646,300655768,
     $313271831,321595028,323528270,317072651,304456588,296133391,
     $294134609,298328911,447489495,319497812,321431054,314975499,
     $        0,460236444,325953308,328115935,321922464,309306461,
     $300753815,296330063,298230732,304456971,317072974,323495571/
      data(symbcd(i),i=3649,3762)/
     $321562134,315335895,304817108,298399136,311403677,302851031,
     $298427278,300299531,314975758,321398356,319488000,437265306,
     $464529181,323822932,308847759,304461466,311043217,304587787,
     $435070112,311436893,437200031,311404125,326018846,330301440,
     $447751327,305079324,302818391,309011862,323725016,328017693,
     $326084128,313537888,309306526,305013849,306947286,449521239,
     $323757786,326018719,319829206,300589907,294167310,296100875,
     $310748684,321300111,323561044,319464854,443229205,298427217,
     $296166284,302363915,317072909,321365587,319455232,460105367,
     $319464852,308946005,302719960,300786717,307209568,319825567,
     $326051612,327952084,323528206,314975435,302359436,296166223,
     $298329039,298267733,302752795,305046751,313538207,326018776,
     $323626577,317138252,308641792,451847627,432678932,        0,
     $432678932,        0,475144708,        0,432777239,432580625,
     $        0,456271201,307176475,298558290,296166281,300098564,
     $447784093,302818262,298361740,300131332,        0,443688226,
     $313501082,315303249,308716618,298033796,443688225,313402711,
     $310977743,304456583,        0,445654292,435070551,456041431,
     $        0,430285580,296133516,298165065,291733504,430351116/
      data(symbcd(i),i=3763,3876)/
     $296067980,296124416,449979271,460465351,462300891,328017755,
     $330180382,326084128,311436383,300852187,302818392,319432338,
     $435004505,319465044,323561103,321299980,312845387,298197837,
     $294101776,296264592,296189952,443556895,298722135,296362895,
     $302392523,312845836,323462868,325822108,319792480,309343327,
     $300819351,298460111,304493581,308684108,319206860,321365652,
     $323724892,317699614,313500895,302972928,437134493,313533771,
     $437134363,307111198,310748491,        0,432907164,300885023,
     $307242400,319792734,323888794,321660373,298169243,300786652,
     $302982303,315598366,321791578,319563157,296072076,325461707,
     $430286539,        0,435168928,309048288,300918367,456139927,
     $443295064,319530645,325658321,323429900,312845451,300295053,
     $296199055,441165143,319497875,449554005,323561105,321332620,
     $457713165,312878220,300327823,438707086,        0,451847627,
     $319141408,319141408,296232720,451847056,432580369,327680000,
     $435168151,437232600,435168864,321893407,321893336,307012953,
     $319563414,325691089,323429900,312845451,300295053,296199055,
     $432776151,304883032,319530644,449586774,323593873,321332620,
     $457713165,312878220,300327823,438707086,        0,454010461/
      data(symbcd(i),i=3877,3990)/
     $323921503,315630880,305112028,298558354,300360780,310748491,
     $319170190,325625554,323659287,313271576,304849877,456074655,
     $311403614,441426972,300655570,302458060,434644045,310781260,
     $319202960,449193550,323528338,321562007,457811478,313238807,
     $304817107,443261973,300482560,430974688,304460640,296724127,
     $458236939,304447488,441459679,298754971,300721176,306947478,
     $319465044,323561103,321299852,306586573,298296210,300557333,
     $306914711,319563353,323856029,321889696,307246111,300852187,
     $302818456,315336214,323626706,325559949,321267083,306553804,
     $298230607,296297364,302720151,315368985,321758813,319796830,
     $315597983,300888974,304494028,323420160,455812564,311010515,
     $302654358,296526682,298755103,309339424,317695581,323790484,
     $321365452,310748299,300295054,300360716,455910934,313144920,
     $317367572,308945941,298595476,300622745,298656733,307213211,
     $302982367,311403998,321762655,319727193,321529359,314979789,
     $310781068,300318720,449750412,317076893,317629900,432711637,
     $334115733,298461140,        0,432711637,334115733,298461140,
     $        0,466756356,295843748,334635844,        0,432842713,
     $334246809,298592216,432580561,333984657,298330064,        0/
      data(symbcd(i),i=3991,4104)/
     $445785250,303014811,296428370,298230793,306390276,312620324,
     $313664738,305112027,298525586,300328009,308487492,        0,
     $431104994,305112283,311108882,308716617,300098372,297939812,
     $298984482,307209499,313206098,310813833,302195588,        0,
     $441459807,308978836,441459860,441459935,304784532,430875549,
     $315336151,430876119,430875484,317466071,451847581,298558295,
     $451846999,451847644,296493911,        0,438707211,300262284,
     $298230734,302457933,304423944,298038221,300295180,302425037,
     $436577354,438707208,        0,434578317,298197963,302359628,
     $304522254,300364749,300295180,302425037,        0,443688135,
     $310621412,311567623,453944989,319792480,307241951,296657755,
     $298623960,317335059,321431119,319202636,306586637,300365341,
     $317662559,307209182,298754971,300721621,321496721,323462733,
     $319169867,306553804,296166350,455550348,        0,445653771,
     $445555531,293975325,325429003,445654795,434677329,432547472,
     $        0,433070987,435135436,433071520,321889950,325986009,
     $323724886,315274207,315598430,323888793,321627542,434840982,
     $321562260,325658319,323397196,314942347,434808213,321529490,
     $323462733,314975180,        0,462268125,321889760,309339231/
      data(symbcd(i),i=4105,4218)/
     $300852123,296493907,298329038,304489675,317040204,325527312,
     $462268123,323921502,317695199,305079259,298591123,300426317,
     $308684236,321300110,325592848,        0,433070987,435135436,
     $433071456,319792797,325953304,327788240,323429900,312845195,
     $435135839,319759965,323856088,325691024,321332749,312878028,
     $        0,433070987,435135436,433071776,435136159,324023254,
     $313206101,434808149,434513548,323335051,323321856,433070987,
     $435135435,298169248,324023263,323987104,434840918,313177045,
     $313163776,462268125,321889760,309339231,300852123,296493907,
     $298329038,304489675,317040204,325527312,327820756,462268123,
     $323921502,317695199,305079325,300786584,298427344,302457933,
     $308684236,321300110,325592787,317302228,        0,433070987,
     $433071072,300262283,462431968,325429003,462432011,434841302,
     $434808533,        0,433070987,300266400,300950475,        0,
     $449848720,312911052,304489421,298328912,449848800,317203853,
     $312878283,304456652,298230608,        0,433070987,300266400,
     $300950475,462431968,300562208,300528791,325429003,443262731,
     $        0,433070987,433071072,300299212,323364491,432383627,
     $        0,433070987,435004363,298169307,314946464,315045792/
      data(symbcd(i),i=4219,4332)/
     $315045723,314947419,329623435,466626443,        0,433070987,
     $435069899,298169309,327529376,325531360,325531360,328214283,
     $        0,443556959,300852123,296493907,298329038,304489675,
     $317040204,325527312,329885528,328050397,321889760,309343519,
     $305079259,298591123,300426317,310781324,321300176,327788312,
     $325953118,315598111,        0,433070987,435135435,298169248,
     $317728351,323954396,325887639,321594837,300594143,317695582,
     $323888793,321627606,300613632,443556959,300852123,296493907,
     $298329038,304489675,317040204,325527312,329885528,328050397,
     $321889760,309343519,305079259,298591123,300426317,310781324,
     $321300176,327788312,325953118,315598111,449259209,327464334,
     $317138697,        0,433070987,435135435,298169248,315631199,
     $323954396,325887639,321594773,300594143,315598430,323888793,
     $321627542,300627221,323331787,447391435,        0,460236383,
     $315630752,300917597,296592281,300688471,315270676,321496721,
     $323429965,314975372,302425038,296171229,321824286,315597983,
     $300884893,298689497,304883094,319465107,325625550,321267083,
     $306553804,296157184,441427083,443524299,306557728,321922655,
     $428876575,321880064,433070993,300360780,310748555,321267406/
      data(symbcd(i),i=4333,4446)/
     $327722784,433071072,300459022,304522508,314975821,323430097,
     $326117152,        0,428877067,428876640,310851360,326116622,
     $462431499,        0,428876939,428876640,306656736,306656733,
     $306558429,327529952,327628960,338700046,475014923,        0,
     $430974603,325432160,298854091,460334752,296072928,298165067,
     $        0,428877014,308651275,428876640,311113440,324019414,
     $460334358,310738944,458236747,460333963,430974688,430973791,
     $323990412,325461707,430286539,        0,455910987,323335769,
     $323790475,455812568,313304217,302785430,296330065,298263564,
     $306554187,317072974,455812440,306979863,300622739,298361806,
     $302425228,312878670,        0,433070987,300266400,300950475,
     $434840664,309110169,319563414,325691089,323429900,314942667,
     $304489422,434840792,315368983,321595027,323528270,319202700,
     $308683726,        0,455812568,313304217,302785430,296330065,
     $298263564,306554187,317072974,455812629,317433176,306979863,
     $300622739,298361806,302425228,312878541,319268430,        0,
     $456140363,323335776,324019851,455812568,313304217,302785430,
     $296330065,298263564,306554187,317072974,455812440,306979863,
     $300622739,298361806,302425228,312878670,        0,432612946/
      data(symbcd(i),i=4447,4560)/
     $321562135,317465945,307012632,298525523,296264590,302392459,
     $312845772,321336211,319399445,317433176,306979863,300622739,
     $298361806,302425228,312878541,319268430,        0,447751392,
     $305112092,302359627,447751519,309306462,441427036,304460633,
     $311207192,430744408,311164928,458008153,321201671,316876101,
     $308454470,302228359,458008202,321103301,312616068,302162823,
     $455812568,313304217,302785430,296330065,298263564,306554187,
     $317072974,455812440,306979863,300622739,298361806,302425228,
     $312878670,        0,433070987,300266400,300950475,434807960,
     $311207385,321660565,323335125,306947352,315368983,321562187,
     $323321856,433070943,296690589,300852254,303014880,298857375,
     $298787806,300917663,432841611,300266393,300721099,        0,
     $433070943,296690589,300852254,303014880,298857375,298787806,
     $300917663,432841604,300037017,300721092,        0,433070987,
     $300266400,300950475,458008153,300398233,300364946,319137419,
     $443131531,        0,433070987,300266400,300950475,        0,
     $432841611,300266393,300721099,434807960,311207385,321660565,
     $323335125,306947352,315368983,321562187,323335829,330049497,
     $340568344,346728779,457877335,334243928,342599957,344303947/
      data(symbcd(i),i=4561,4674)/
     $        0,432841611,300266393,300721099,434807960,311207385,
     $321660565,323335125,306947352,315368983,321562187,323321856,
     $441230360,298525523,296264590,302392459,312845772,321332881,
     $323593814,317465945,307016856,302752726,298427281,300360717,
     $306586956,317105678,321431123,319497687,313271448,        0,
     $432841604,300037017,300721092,434840664,309110169,319563414,
     $325691089,323429900,314942667,304489422,434840792,315368983,
     $321595027,323528270,319202700,308683726,        0,455910980,
     $323106393,323790468,455812568,313304217,302785430,296330065,
     $298263564,306554187,317072974,455812440,306979863,300622739,
     $298361806,302425228,312878670,        0,432841611,300266393,
     $300721099,434742294,306980121,317502419,302687383,311174616,
     $317489152,453715416,311207001,298591062,298460179,313042384,
     $449357263,317138316,451323148,304489357,434512782,296171030,
     $317400472,451650840,304882583,434906006,300561301,302654802,
     $317236751,319235532,310748235,298197838,        0,435168203,
     $302363616,303047691,428647641,309080857,294397144,        0,
     $432841615,300295243,310748556,321368985,300721103,302425228,
     $310781325,321369689,321234571,455911065,323321856,428647563/
      data(symbcd(i),i=4675,4711)/
     $428647257,306624025,317498509,453813387,        0,430744715,
     $430744473,306656665,306656662,306558358,323335577,323434457,
     $332179086,468493963,        0,430745099,321237849,298624587,
     $455910937,296072793,298165067,        0,428647563,428647257,
     $306624025,317498509,297940505,306553796,297926656,451683147,
     $455910348,430745177,430744408,317469644,321267275,430286411,
     $        0/
      data (istart(i),i=1,229)/
     $   1,   5,  16,  26,  34,  39,  43,  54,  58,  60,  66,  70,  73,
     $78,  82,  93, 100, 112, 120, 131, 134, 140, 143, 148, 151, 154,
     $ 296, 305, 314, 322, 331, 340, 344, 355, 360, 364, 370, 374, 376,
     $385, 390, 399, 408, 417, 421, 430, 434, 439, 442, 447, 450, 455,
     $3177,3186,3189,3197,3205,3208,3217,3229,3232,3247,3259,3262,3264,
     $3266,3269,3275,3281,3285,3290,3293,
     $ 158, 162, 173, 176, 180, 185, 189, 193, 205, 207, 211, 214, 219,
     $223, 227, 238, 242, 249, 253, 256, 265, 275, 278, 287,
     $ 459, 471, 486, 494, 506, 515, 526, 535, 549, 554, 563, 567, 577,
     $584, 598, 607, 613, 623, 632, 636, 644, 655, 662, 672,
     $ 683, 690, 710, 726, 740, 749, 757, 775, 785, 790, 799, 809, 815,
     $826, 834, 855, 868, 898, 918, 935, 942, 952, 958, 967, 975, 983,
     $1272,1290,1305,1319,1335,1350,1360,1388,1399,1406,1417,1427,1432,
     $1450,1461,1478,1494,1509,1519,1535,1542,1553,1559,1568,1576,1585,
     $3306,3325,3330,3351,3373,3378,3396,3419,3433,3462,3485,3488,3490,
     $3492,3495,3505,3515,3519,3523,3526,
     $ 990, 997,1017,1023,1029,1038,1045,1055,1080,1085,1095,1101,1112,
     $1120,1133,1154,1162,1175,1183,1190,1205,1226,1234,1252,
     $1592,1611,1637,1650,1671,1686,1701,1716,1737,1744,1757,1767,1779/
      data (istart(i),i=230,432)/
     $1789,1810,1825,1834,1849,1865,1872,1887,1905,1916,1932,
     $1953,1960,1978,1995,2009,2018,2026,2046,2056,2061,2071,2081,2087,
     $2098,2106,2126,2138,2167,2185,2202,2209,2220,2226,2235,2243,2251,
     $2522,2540,2556,2568,2587,2600,2617,2637,2651,2663,2678,2693,2701,
     $2725,2742,2757,2776,2791,2803,2817,2825,2842,2855,2874,2894,2913,
     $3546,3566,3572,3592,3616,3620,3638,3660,3673,3702,3724,3727,3729,
     $3731,3734,3744,3754,3758,3762,3765,
     $4074,4082,4102,4121,4136,4146,4154,4176,4185,4189,4199,4208,4214,
     $4224,4232,4252,4264,4287,4302,4323,4329,4341,4347,4357,4364,4371,
     $4379,4396,4413,4429,4446,4464,4474,4497,4508,4519,4530,4539,4543,
     $4562,4573,4591,4608,4625,4634,4656,4663,4674,4680,4690,4697,4704,
     $3784,3803,3809,3825,3846,3853,3876,3904,3909,3941,3969,3976,3980,
     $3984,3991,4003,4015,4031,4042,4050,
     $2258,2260,2262,2283,2289,2301,2305,2309,2320,2336,2360,2373,2377,
     $2381,2384,2391,2399,2402,2406,2415,2435,2454,2473,2500,
     $2927,2932,2937,2942,2964,2977,2983,2990,2997,3012,3027,3051,3056,
     $3063,3070,3086,3098,3100,3102,3104,3123,3130,3135,3154/
      data (ssymbc(i),i=1,120)/
     1             471149226,357246358,315959338, 68157440,470825002,
     2 345320100,357443862,327886236,315762474,336920576,470825002,
     3 355313115,336920576,470493226,449850016,0,455911911,456370649,0,
     4 471149216,336274848,336922646,0,470493226,357574048,336920576,
     5 449522346,315959958,0,470825002,355641947,336274907,317892650,0,
     6 456370208,336279584,351502336,481470811,325953253,347256234,
     7 326284694,325958294,346929184,357892096,449850016,470493226,
     8 455911911,485271143,0,450177706,315304598,315949056,470493226,0,
     9 470825002,355313115,336935525,336274917,355631104,470853600,
     $             336570464,336625664,468592477,328181537,330409956,
     2 338831587,345024799,342796380,334364672,466265814,319563163,
     3 313468258,315794984,326444971,341158250,353643173,359738078,
     4 357411352,346761365,332038144,465905227,312910991,300491605,
     5 292332190,290530023,297116654,307799411,322611126,341518837,
     6 360295345,372714731,380874146,382676313,376089682,365406925,
     7 350595210,331677696,468592477,328181537,330409956,338831587,
     8 345024799,342796380,334378847,330344289,466560930,468625379,
     9 470722595,472819811,474949794,477079777,0,462300964,345123100,
     * 328087389,330413981,332511197,334608413,336705629,338802845/
      data (ssymbc(i),i=121,128)/
     $             340900061,342982656,470623971,347187226,464594973,
     2 342964256,334571552,338755584/
      data isstar /1,5,11,14,17,20,24,27,30,35,38,45,50,53,55,60,63,70,
     2 81,98,113,123/
      data (width(i),i=1,232)/
     $18.,21.,21.,21.,19.,18.,21.,22., 8.,16.,21.,17.,24.,22.,22.,21.,
     $22.,21.,20.,16.,22.,18.,24.,20.,18.,20.,
     $19.,19.,18.,19.,18.,12.,19.,19., 8.,10.,17., 8.,30.,19.,19.,19.,
     $19.,13.,17.,12.,19.,16.,22.,17.,16.,17.,
     $20.,20.,20.,20.,20.,20.,20.,20.,20.,20.,26.,26.,22.,26.,14.,14.,
     $16.,10.,10.,20.,
     $18.,21.,17.,18.,19.,20.,22.,22., 8.,21.,18.,24.,22.,18.,22.,22.,
     $21.,18.,16.,18.,20.,20.,22.,20.,
     $21.,19.,19.,18.,16.,15.,20.,21.,11.,18.,16.,21.,18.,16.,17.,22.,
     $18.,20.,20.,20.,22.,18.,23.,23.,
     $20.,22.,21.,22.,21.,20.,23.,24.,11.,15.,22.,18.,25.,23.,22.,22.,
     $22.,22.,20.,19.,24.,20.,24.,20.,21.,20.,
     $20.,21.,19.,21.,19.,13.,19.,22.,11.,11.,21.,11.,33.,22.,20.,21.,
     $20.,17.,17.,15.,22.,18.,24.,20.,19.,18.,
     $20.,20.,20.,20.,20.,20.,20.,20.,20.,20.,26.,26.,22.,26.,14.,14.,
     $16.,10.,10.,20.,
     $20.,22.,18.,20.,21.,20.,24.,22.,11.,22.,20.,25.,23.,22.,22.,24.,
     $22.,21.,19.,19.,21.,20.,23.,22.,
     $23.,21.,20.,19.,18.,18.,22.,23.,12.,20.,20.,23.,20.,17.,18.,22./
      data (width(i),i=233,432)/
     $19.,21.,20.,20.,22.,18.,23.,23.,
     $20.,24.,21.,23.,23.,22.,22.,26.,13.,18.,23.,20.,27.,25.,22.,23.,
     $22.,24.,23.,21.,25.,20.,26.,22.,21.,22.,
     $21.,19.,18.,21.,18.,15.,20.,21.,13.,13.,20.,12.,33.,23.,18.,21.,
     $20.,17.,17.,14.,23.,20.,29.,20.,21.,20.,
     $21.,21.,21.,21.,21.,21.,21.,21.,21.,21.,26.,26.,22.,26.,15.,15.,
     $17.,11.,11.,21.,
     $20.,20.,21.,21.,19.,18.,21.,22., 9.,17.,21.,17.,24.,22.,22.,20.,
     $22.,20.,20.,17.,22.,20.,26.,20.,19.,20.,
     $20.,20.,18.,20.,18.,14.,20.,20., 9., 9.,19., 9.,31.,20.,19.,20.,
     $20.,14.,17.,11.,20.,16.,24.,18.,16.,18.,
     $20.,20.,20.,20.,20.,20.,20.,20.,20.,20.,25.,25.,23.,25.,14.,14.,
     $16.,11.,11.,19.,
     $24.,24.,19.,20.,17.,24.,24.,25.,24.,24.,25.,24.,24.,22.,26.,34.,
     $10.,22.,31.,19.,14.,14.,27.,22.,
     $14.,14.,21.,16.,16.,10.,10.,10.,18.,24.,25.,11.,11.,11.,21.,24.,
     $14.,14., 8.,16.,14.,26.,22., 8./
      end
