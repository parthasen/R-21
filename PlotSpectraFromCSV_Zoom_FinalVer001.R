#decomposition of sucrose, overlaid spectra for zoomed area
#all spectra in one graph
############################################
############################################
library("RColorBrewer")
library("colorspace")
path <- file.choose()
############################################ -> path of the file (csv)

decoS <- read.csv(path, skip = 3, header = T, sep=";")
############################################ -> read csv into decoS
z <- dim(decoS)[2] - 1
#c <- colors(z)
c <- diverge_hcl(z)
#cb <- brewer.pal(11, "Spectral")
############################################ -> put random colors into c

wave_zoom <- seq(1850,2000,by=0.5)
############################################ -> sequence for visible wavelengths

#matplot(wave_vis, decoS[1:801,-1], xlab = "Wavelength in nm", ylab = "Absorbance", main = "Overlaid vis spectra", type = "l", col = c)
############################################ -> plot vis spectra in different & random colors
postscript("Zoomspectra.eps", horizontal = TRUE, onefile = FALSE, paper = "special", height = 8.26771654, width = 11.6929134)
matplot(wave_zoom, decoS[2905:3205,-1], xlab = "Wavelength in nm", ylab = "Absorbance", main = "Overlaid zoom spectra", type = "l", col = c)
dev.off()
png("Zoomspectra.png", height = 2480, width = 3508, res = 300)
matplot(wave_zoom, decoS[2905:3205,-1], xlab = "Wavelength in nm", ylab = "Absorbance", main = "Overlaid zoom spectra", type = "l", col = c)
dev.off()
matplot(wave_zoom, decoS[2905:3205,-1], xlab = "Wavelength in nm", ylab = "Absorbance", main = "Overlaid zoom spectra", type = "l", col = c)
