load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"  
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/wrf/WRFUserARW.ncl"
begin
f1 = addfile("wrfout path","r")
times = wrf_user_list_times(f1)
rh = wrf_user_getvar(f1,"rh",-1)
u10 = wrf_user_getvar(f1,"U10",-1)
v10 = wrf_user_getvar(f1,"V10",-1)
printVarSummary(rh)
lat = wrf_user_getvar(f1,"lat",0)
lon = f1->XLONG(0,:,:)
ds = dimsizes(lat)
print(ds)
nrow = ds(0)-1
ncol = ds(1)-1

wks = gsn_open_wks("png","wrf-rh")
gsn_define_colormap(wks,"wh-bl-gr-ye-re")

res                        = True

;;;;;;;;;;;;;;;;;;;;;;;;填色图;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
res@cnFillOn               = True ;填色
res@cnLinesOn              = False ;在不同颜色交汇处加上实线
res@mpFillOn               = False ;背景地图填色
res@mpDataSetName          = "Earth..4"
res@mpDataBaseVersion      = "MediumRes" ;与省界边界线有关
res@mpOutlineOn            = True ;边界线开关
res@mpOutlineSpecifiers    = "china:states" ;边界线为中国省界

res@mpProjection           ="LambertConformal" ;地图投影方式
res@mpLambertMeridianF     = 112.39 ;投影中间经度线
res@mpLambertParallel1F    = 30. ;=namelist.wps->TRUELAT1
res@mpLambertParallel2F    = 60. ;=namelist.wps->TRUELAT2
res@mpLimitMode            = "Corners"
res@mpLeftCornerLatF       = lat(0,0) ;地图左下角纬度
res@mpLeftCornerLonF       = lon(0,0) ;地图左下角经度
res@mpRightCornerLatF      = lat(nrow,ncol) ;地图右上角纬度
res@mpRightCornerLonF      = lon(nrow,ncol) ;地图左上角经度
res@mpGeophysicalLineColor = "red" ;大陆轮廓颜色  
res@mpPerimOn              = True ;在地图周围画方框
res@mpGridLineDashPattern  = 2 ;以虚线表示经纬线

res@gsnAddCyclic           = False
res@tfDoNDCOverlay         = True ;与经纬度读取有关
res@pmTickMarkDisplayMode  = "Always" ;在图片四周加上刻度

;;;;;;;;;;;;;;;;;;;;;;;叠加风场;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
res@gsnScalarContour       = True ;true:将第三个绘图变量作为填色图绘制;false:风场箭头将根据第三个变量的数值大小来设置颜色 

res@vcRefMagnitudeF        = 8 ;控制矢量箭头的单位长度所表示的数值大小
res@vcRefAnnoString1       = "8 m/s" ;图例标注
res@vcRefLengthF           = 0.025 ;矢量箭头的单位长度
res@vcRefAnnoSide          = "Top" ;矢量图例在图中的位置,默认在底部
res@vcRefAnnoOrthogonalPosF  = -1.0 ;调节图例的上下位置，正为与res@vcRefAnnoSide或默认方向相同
res@vcRefAnnoParallelPosF    = 1.0 ;调节图例的左右位置，正为向左
res@vcGlyphStyle           ="CurlyVector" ;控制矢量箭头的形式
res@vcMinDistanceF         = 0.03 ;风场箭头疏密
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

res@tiMainString           = "surface RH and wind at 10m" ;标题名称
res@tiMainFontHeightF      = .018 ;标题大小

plot = gsn_csm_vector_scalar_map(wks,u10(0,:,:),v10(0,:,:),rh(0,0,:,:),res)

end
