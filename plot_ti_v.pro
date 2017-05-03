;@clr_win
close,1
;rundir = './'
rundir = '/Volumes/MacD97-2/hybrid/SWAP_2d/'
;f_read_coord,rundir+'/coord.dat',x,y,z,dzc,dzg,nx,ny,nz
;@gops
;@x6x9
;device,/color
;device,filename='t_v_pickup.ps'
!p.charsize=1.2
!x.charsize=1.2
!y.charsize=1.2
!p.multi=[0,2,5]
!p.multi=[0,1,2]
loadct,0
nfm = 10

;window,0
read_para,rundir
restore,filename=rundir+'para.sav'
read_coords,rundir,x,y,z

!p.multi=[0,2,5]
;window,1

cwpi = x(1)-x(0)
dx = 100.
xarr = findgen(nx)*dx/cwpi
yarr = findgen(nz)*dx/cwpi

x = x/cwpi
z = z/cwpi

w1 = window(dimensions=[1200,1000])
cnt = 1
for i = 1,nfm,1 do begin
nfrm = i
   c_read_3d_m_32,rundir,'c.np',nfrm,np
   c_read_3d_m_32,rundir,'c.temp_p',nfrm,tp
   c_read_3d_vec_m_32,rundir,'c.up',nfrm,up
;   wset,1
;   loadct,39

tp = tp*11604.
np = np/1e15
np = tp
   

   im = plot(x,smooth(reform(np(*,1,1)),2),layout=[2,5,cnt],/current,/xsty,/ylog,axis_style=1,$
             margin=[0.1,0.2,0.2,0.1],font_size=12)
   
   ;im = image(reform(np(*,1,*)),x,z,layout=[2,5,cnt],/current,rgb_table=33)
   xax = axis('x',location='top',showtext=0,target=im)
   im.ytitle='Average Energy (K)'
;   im.ytitle='Density (cm$^{-3}$)'


;   xax = axis('x',axis_range=[min(x),max(x)],location=[0,min(z(*))],thick=2,tickdir=1,target=im,tickfont_size=12)
;   yax = axis('y',axis_range=[min(z),max(z)],location=[0,min(z(*))],thick=2,tickdir=1,target=im,tickfont_size=12)
   im.xtitle='x (c/$\omega_{pi}$)'

;   im.ytitle='y (c/$\omega_{pi}$)'
  
;   cnt = cnt+1
    
   im1 = plot(x,reform(up(*,1,1,0)),'b',layout=[2,5,cnt],/current,/xsty,axis_style=4,$
              margin=[0.1,0.2,0.2,0.1],font_size=12)
   ;im = image(reform(up(*,1,*,0)),x,z,layout=[2,5,cnt],/current,rgb_table=33)
   im1.ytitle='Flow speed (km/s)'
   yax = axis('y',location='right',showtext=1,target=im1,color='blue')
   yax.title='flow speed (km/s)'

;   xax = axis('x',axis_range=[min(x),max(x)],location=[0,min(z(*))],thick=2,tickdir=1,target=im,tickfont_size=12)
;   yax = axis('y',axis_range=[min(z),max(z)],location=[0,min(z(*))],thick=2,tickdir=1,target=im,tickfont_size=12)
   im.xtitle='x (c/$\omega_{pi}$)'
;   im.ytitle='y (c/$\omega_{pi}$)'

;   im.save,'initial.png'
;stop

   cnt= cnt+1
;   contour,bytscl(reform(np(*,1,*))),xarr,yarr,/fill,nlev=255,/xsty,/ysty,$
;     /isotropic,$
;     xtitle='x (c/!9w!3!dpi!n)',ytitle='y (c/!9w!3!dpi!n)'
endfor

w1.save,'t_v.png'

w = WINDOW(WINDOW_TITLE="My Window", $
    DIMENSIONS=[1200,1000])

varr = findgen(800)+200
tarr = 2*33200.268*(varr-250) - 9.65e5

cnt=1
for nf = 1,nfm,1 do begin
   nfrm = nf
   c_read_3d_m_32,rundir,'/c.temp_p',nfrm,ti
   c_read_3d_m_32,rundir,'/c.np',nfrm,np
   c_read_3d_vec_m_32,rundir,'c.up',nfrm,up
   
;surface,reform(ti(*,1,0:nz-4)),charsize=0.5
   
 
   up2 = reform(sqrt(up(*,1,*,0)^2 + up(*,1,*,1)^2 + up(*,1,*,2)^2))
   
;   ti = smooth(ti,2)
   ti = reform(ti(*,1,*))

   p=plot([0,800],[50,10000]*11604.,/ylog,/nodata,/ysty,/xsty,xtitle='flow speed (km/s)',$
          ytitle='Average Energy (K)',layout=[2,5,cnt],/current,font_size=12,$
          margin=[0.1,0.2,0.1,0.1])
   
   cnt = cnt+1
;   for i = 0,nx-1 do begin
;      for k = 0,nz-1 do begin
         ;if (cnt eq 10) then begin
            p=plot(up2,ti*11604.,'b.',/overplot)
            p.xrange=[150,800]
            p.yrange=[1e4,1e7]
         ;endif
;         cnt = cnt+1
;      endfor
;   endfor
;            pf = plot(varr,tarr,'pink',/overplot,/current)


   

;uarr = 200+findgen(800) 
;oplot,uarr,550.*uarr +1e6,linestyle=1
   
endfor
w.save,'t_v_scatter.png

;p = poly_fit(up2(*,0,*),ti(*,1,*),1)+
;print,p

;device,/close
end
