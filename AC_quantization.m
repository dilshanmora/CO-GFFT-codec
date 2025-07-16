function [coefficients_qua,index]=AC_quantization(coefficients,Step_size)
        index=round(coefficients/Step_size);
        coefficients_qua=index*Step_size;
end