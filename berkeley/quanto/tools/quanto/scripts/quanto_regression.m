#! /sw/bin/octave -qf

% Script that loads a .pwr file and does a weighted regression
% to find the icount consumption rate per power state.
% Expects the (edited) output of read_log_staged.py
% Editing the .pwr file:
%  1. remove the columns that are always 0 
%  2. remove the columns that are all '-'
%  3. remove the lines that aren't fully defined
%  4. remove, from the 'states' line, the names of the states 
%     that were removed in 1 and 2.
% You may have to adjust the constants regarding voltage and
% either mJ_per_iC or mA_per_iC.

% Fix the executable above to whatever you have in your system
% This may work in Matlab, but I haven't tested it.


voltage = 3.35
mJ_per_iC = 4.1734
mA_per_iC = mJ_per_iC/voltage


if ( nargin != 2 )
    printf( "Usage: %s <file_name> <add_const:1|0>\n", program_name );
    return
endif

fname = argv(){1}
add_const = str2num(argv(){2})

f = load(fname)
nvar = size(f,2)-2
X = f(:,1:end-2)

% read names: a line with the string 'stages'
fh = fopen(fname)

while (l = fgetl(fh))
    if (l == -1)
        break
    endif
    if (regexp(l,'states','once','start'))
        states = l
        break 
    endif
endwhile
fclose(fh)

if ( add_const)
    X = [X ones(size(X),1)]
    if (states)
        states = [states, " const"]
    endif
endif

dt = f(:,end-1)
dE = f(:,end)
p = dE./dt * 1000;
W = diag (sqrt(dt .* dE))

a = inv(X'*W*X) * X'*W*p


a_mA = a * mA_per_iC
a_mW = a * mJ_per_iC

outname = [fname , ".reg"]
fh = fopen(outname,'w')
if (states)
    fdisp(fh,states)
endif
fdisp(fh,'Regression results in iC/s')
fdisp(fh,a)
fprintf(fh,"Regression results in mA (assuming mA_per_iC = %f)\n",mA_per_iC)
fdisp(fh,a_mA)
fprintf(fh,"Regression results in mJ (assuming mJ_per_iC = %f)\n",mJ_per_iC)
fdisp(fh,a_mW)
fclose(fh)
