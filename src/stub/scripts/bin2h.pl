#! /usr/bin/perl -w
#
#  bin2h.pl --
#
#  This file is part of the UPX executable compressor.
#
#  Copyright (C) 1996-2000 Markus Franz Xaver Johannes Oberhumer
#  Copyright (C) 1996-2000 Laszlo Molnar
#
#  UPX and the UCL library are free software; you can redistribute them
#  and/or modify them under the terms of the GNU General Public License as
#  published by the Free Software Foundation; either version 2 of
#  the License, or (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; see the file COPYING.
#  If not, write to the Free Software Foundation, Inc.,
#  59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#
#  Markus F.X.J. Oberhumer                   Laszlo Molnar
#  markus.oberhumer@jk.uni-linz.ac.at        ml1050@cdata.tvnet.hu
#


$delim = $/;
undef $/;       # undef input record separator - read file as a whole

$ifile = shift || die;
$ident = shift || die;
$ofile = shift || die;

open(INFILE,$ifile) || die "$ifile\n";
binmode(INFILE);
open(OUTFILE,">$ofile") || die "$ofile\n";
binmode(OUTFILE);

# read whole file
$data = <INFILE>;
close(INFILE);
$n = length($data);

# print
select(OUTFILE);

$o = $ofile;
$o =~ s/.*[\/\\]//;

print <<"EOF";
/* $o -- created from $ifile, $n bytes

   This file is part of the UPX executable compressor.

   Copyright (C) 1996-2000 Markus Franz Xaver Johannes Oberhumer
   Copyright (C) 1996-2000 Laszlo Molnar

   UPX and the UCL library are free software; you can redistribute them
   and/or modify them under the terms of the GNU General Public License as
   published by the Free Software Foundation; either version 2 of
   the License, or (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; see the file COPYING.
   If not, write to the Free Software Foundation, Inc.,
   59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.

   Markus F.X.J. Oberhumer                   Laszlo Molnar
   markus.oberhumer\@jk.uni-linz.ac.at        ml1050\@cdata.tvnet.hu
 */


EOF

printf("unsigned char %s[%d] = {", $ident, $n);
for ($i = 0; $i < $n; $i++) {
    if ($i % 16 == 0) {
        printf("   /* 0x%4x */", $i - 16) if $i > 0;
        print "\n";
    }
    printf("%3d", ord(substr($data, $i, 1)));
    print "," if ($i != $n - 1);
}
print "\n};\n";

close(OUTFILE) || die;
select(STDOUT);

undef $delim;
exit(0);

# vi:ts=4:et
