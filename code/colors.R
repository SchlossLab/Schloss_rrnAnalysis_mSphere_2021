custom_color_scale <- function(){
	
	scale_color_manual(name = NULL,
										 breaks = c("v19", "v34", "v4", "v45"),
										 values = c("black", "#1b9e77", "#d95f02", "#7570b3"),
										 labels = c("V1-V9", "V3-V4", "V4", "V4-V5"))
	
}