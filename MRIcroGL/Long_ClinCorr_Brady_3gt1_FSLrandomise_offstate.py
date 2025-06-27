# Basic setup
import gl
import sys
print(sys.version)
print(gl.version())
gl.resetdefaults()
gl.linewidth(2)
gl.linecolor(255,255,255)

# Open background image
gl.loadimage('/Applications/MRIcroGL.app/Contents/Resources/standard')

# Set position
#gl.orthoviewmm(-27,-46,3)

# Set mosaic
gl.mosaic("A L- H 0 V 0 -18 0 52; 60 68 S X R 0");

# Smooth interpolation of overlay 
gl.overlayloadsmooth(1)

# Sharpen
gl.sharpen()

# Open overlay
gl.overlayload('/Volumes/project/3024006.02/Analyses/motor_task/Group/Longitudinal/FSL_OFF/stats/con_0007/vals/rand_delta_clincorr_all_vxlEV_tfce_corrp_tstat2_stats_full_t.nii.gz')
gl.overlayload('/Volumes/project/3024006.02/Analyses/motor_task/Group/Longitudinal/FSL_OFF/stats/con_0007/vals/rand_delta_clincorr_all_vxlEV_tfce_corrp_tstat2_stats_mask_t.nii.gz')

# Set overlay display parameters; 1 indicates 1st overlay
gl.colorname(1,"6bluegrn")
gl.minmax(1, 200, 4000)
gl.opacity(1, 20)
gl.colorname(2,"7cool")
gl.minmax(2, 2000, 4000)
gl.opacity(2, 100)

# Set color bar options 
gl.colorbarposition(1)
gl.colorbarsize(0.05)

# Set background color
gl.backcolor(255, 255, 255)

# Set shader
gl.shadername('OverlaySurface')
#gl.shaderquality(10)

# Save the image 
gl.savebmp('/Volumes/home/sysneu/marjoh/Visualization/R_LongitudinalComparisonFmri/FSL/rand_delta_clincorr_all_vxlEV_tstat2_OFFSTATE.png')
