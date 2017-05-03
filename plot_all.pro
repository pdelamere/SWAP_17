pro plot_all,nframe

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
nfm = nframe
xsz = 1200
ysz = 1000


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

XINTERANIMATE, SET=[xsz,ysz, nfm], /SHOWLOAD 
w1 = window(dimensions=[xsz,ysz],/buffer)
video_file = 'KAW.mp4'
video = idlffvideowrite(video_file)
framerate = 7.5
;wdims = w.window.dimensions
stream = video.addvideostream(xsz, ysz, framerate)

varr = findgen(800)+200
tarr = 2*33200.268*(varr-250) - 9.65e5


cnt = 1
for i = 1,nfm,1 do begin
nfrm = i
   c_read_3d_m_32,rundir,'c.np',nfrm,np
   c_read_3d_m_32,rundir,'c.temp_p',nfrm,tp
   c_read_3d_vec_m_32,rundir,'c.up',nfrm,up
   c_read_3d_vec_m_32,rundir,'c.b1',nfrm,b1
;   wset,1
;   loadct,39

   tp = tp*11604.
   np = np/1e15
   np = tp
   
   w1.erase

   im = plot(x,smooth(reform(np(*,1,1)),2),layout=[2,2,1],/current,/xsty,/ylog,axis_style=1,$
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
    
   im1 = plot(x,reform(up(*,1,1,0)),'b',layout=[2,2,1],/current,/xsty,axis_style=4,$
              margin=[0.1,0.2,0.2,0.1],font_size=12,/buffer)
   ;im = image(reform(up(*,1,*,0)),x,z,layout=[2,5,cnt],/current,rgb_table=33)
   im1.ytitle='Flow speed (km/s)'
   im1.yrange=[150,800]
   yax = axis('y',location='right',showtext=1,target=im1,color='blue')
   yax.title='flow speed (km/s)'

   im.xtitle='x (c/$\omega_{pi}$)'

   up2 = reform(sqrt(up(*,1,*,0)^2 + up(*,1,*,1)^2 + up(*,1,*,2)^2))
   
   ti = reform(tp(*,1,*))

   p=plot(up2,ti,'2b.',/ylog,/ysty,/xsty,xtitle='flow speed (km/s)',$
          ytitle='Average Energy (K)',layout=[2,2,2],/current,font_size=12,$
          margin=[0.1,0.2,0.1,0.1],/buffer)
   p.xrange=[150,800]
   p.yrange=[1e4,1e7]

   px = plot(x,reform(b1(*,1,1,0)),'g',/xsty,/ysty,layout=[2,2,3],/buffer,/current,name='Bx',$
             margin=[0.15,0.2,0.1,0.1])
   px.yrange=[-0.1,0.1]
   py = plot(x,reform(b1(*,1,1,1)),'b',layout=[2,2,3],/buffer,/current,/overplot,name='By')
   pz = plot(x,reform(b1(*,1,1,2)),'r',layout=[2,2,3],/buffer,/current,/overplot,name='Bz')
   px.ytitle='Magnetic field'
   l = legend(target=[px,py,pz])

   p = plot(x,reform(np(*,1,1)),/ylog,/xsty,/ysty,layout=[2,2,4],/buffer,/current,$
            margin=[0.1,0.2,0.1,0.1])
   p.ytitle='Density'

   cnt= cnt+1

   img = w1.CopyWindow()

   print, 'Time:', video.put(stream, w1.copywindow())
   xinteranimate, frame = nfrm-1, image = img

endfor


video.cleanup
xinteranimate,/keep_pixmaps

return
end
