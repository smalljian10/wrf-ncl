load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
files = systemfunc("ls wrfout-path")
f1  = addfiles(files, "r")
ListSetType(f1,"cat")
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
times = wrf_user_getvar(f1,"times",-1)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
ntime = dimsizes(times)
outime = times
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
do i = 0,ntime-1,1
utime  =    (/stringtofloat(str_get_cols(times(i),8,9)),stringtofloat(str_get_cols(times(i),11,12))/)
jtime  =    (/utime(0),utime(1)+8/)
if (jtime(1).ge.24)then
j=jtime(0)+1
k=jtime(1)-24
btime  =    (/j,k/)
else
btime  =   jtime
end if
if (btime(1).lt.10)then
bjtime  =   (/flt2string(btime(0)),"0"+flt2string(btime(1))/)
else
bjtime  =   (/flt2string(btime(0)),flt2string(btime(1))/)
end if
uttime  =   (/str_get_cols(times(i),8,9),str_get_cols(times(i),11,12)/)
outime(i)  =   str_sub_str(times(i),"-"+uttime(0)+"_","-"+bjtime(0)+"_")
outime(i)  =   str_sub_str(outime(i),"_"+uttime(1)+":","_"+bjtime(1)+":")
end do
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
print(times(:))
print(outime(:))
end

