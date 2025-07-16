Author: Dilshan Morawaliyadda (morawald@myumanitoba.ca)

This package contains a complete Matlab implementation of a data-driven image codec, based on coding-optimized Givens factorization-based fast transforms (CO-GFFT) as described in the paper. An image can be encoded into a compressed binary file using the function Encode_CO_GFFT(). A compressed file can be decoded using the function Decode_CO_GFFT(). Only grey-scale images are supported.

Note that, even though the encoder and decoder incorporate fast transforms whose speeds are comparable to an FFT-based implementation of a 2D-DCT for 8x8 blocks, the reset of the Matlab code (e.g., RD-optimization loop and entropy coding workflow) has not been optimized for speed.

Usage:

Encode_CO_GFFT(input_image_path,coded_file,QP)
input_image_path --> Input image file in .tif format
coded_file       --> Name of the binary output file (.bin extension will be added by the function)
QP               --> Quality parameter. Must be a value in the [0,100] interval (100 gives the best quality)

Decode_CO_GFFT(coded_file,output_file)
coded_file --> .bin file produced by  Encode_CO_GFFT() 	
output_fle -->  decoded image file in .tif format (.tif extension will be added by the function) 	


