$pdf_mode = 1; # Generate PDF
$out_dir = 'build'; # Output directory
$pdflatex = 'pdflatex -halt-on-error %O %S'; # Engine command
$bibtex_use = 0; # Disable bibtex if not needed, set to 2 to use if needed
$makeindex = 'makeindex %O -o %D %S';
$clean_ext = 'synctex.gz fdb_latexmk fls xmpi'; # Extra extensions to clean

# Add the style directory to the search path
$ENV{'TEXINPUTS'} = ".:./code/style//:" . ($ENV{'TEXINPUTS'} // "");
