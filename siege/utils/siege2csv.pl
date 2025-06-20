#!/usr/bin/perl
#siege2csv.pl is a perl script that parses the output from bombardmnet.sh
#into comma separated values for easy use with spreadsheets.
#Copyright (C) 2001 Peter J. Hutnick

#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
 
#You should have received a copy of the GNU General Public License
#along with this program; if not, write to the Free Software
#Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, US
 
#For information, write the author, Peter Hutnick at phutnick@aperian.com.

open (INPUT, "< $ARGV[0]")
        or die "Can't open data file or no data file specified.\n";

{

local $/ = undef;
@list = split('\n', <INPUT>); # each line becomes an string in array list

}

close(INPUT);                                                                   

$numchunks = scalar(@list); 	# Find out how many strings, so we can drive
				# loops


# This ugly thing is where all the work gets done.  It maintains data
# associtivity by relying on the coinidence that all the data "just ends
# up" in order.  I may try to clean this up at a future date.

$usersub=0;
$transub=0;
$elapsub=0;
$datasub=0;
$respsub=0;
$tratesub=0;
$tputsub=0;
$consub=0;
$codesub=0;

for ($i=0; $numchunks > $i; $i++)
{

#       print $list[$i];
#       print "\n";
        if ($list[$i] =~ /.. Preparing \d* concurrent users.*/ )
        {
#                print $list[$i]; print "\n";
                $numusers[$usersub] = $list[$i];
                $usersub++;
        }
        elsif ($list[$i] =~ /Transactions.*/)
        {
                $transactions[$transub] = $list[$i];
                $transub++;
        }
        elsif ($list[$i] =~ /Elapsed.*/)
        {
                $elapsed[$elapsub] = $list[$i];
                $elapsub++;
        }
        elsif ($list[$i] =~ /Data transferred.*/)
        {
                $data[$datasub] = $list[$i];
                $datasub++;
        }
        elsif ($list[$i] =~ /Response.*/)
        {
                $response[$respsub] = $list[$i];
                $respsub++;
        }
        elsif ($list[$i] =~ /Transaction rate.*/)
        {
                $trate[$tratesub] = $list[$i];
                $tratesub++;
        }
        elsif ($list[$i] =~ /Throughput.*/)
        {
                $tput[$tputsub] = $list[$i];
                $tputsub++;
        }
	elsif ($list[$i] =~ /Concurrency.*/)
        {
                $concurr[$consub] = $list[$i];
                $consub++;
        }
	elsif ($list[$i] =~ /Successful transactions.*/)
        {
                $code200[$codesub] = $list[$i];
                $codesub++;
        }
 
 
}



for ($i=0; $usersub > $i; $i++)
{
#	print "Number of Users\n";	

	$numusers[$i] =~ tr/a-zA-Z//d;
	$numusers[$i] =~ tr/://d;
	$numusers[$i] =~ tr/\.//d;
	$numusers[$i] =~ tr/\*//d;
	$numusers[$i] =~ tr/\t//d;
	$numusers[$i] =~ tr/ //s;
#	print $numusers[$i];
}

# These for loops _try_ to prune the strings down to the numeric
# values.  The last one (code 200) does not work well because of the
# numeric elemnet of the description.

# Also, I can't get rid of that last leading space.  Doesn't seem to
# bother Excel 2000, but for neatness this should be addressed.

# I don't know how to do perl functions.  Clearly a function would be 
# better here.

for ($i=0; $transub > $i; $i++)
{
#	print "Number of Hits\n";

	$transactions[$i] =~ tr/a-zA-Z//d;
	$transactions[$i] =~ tr/://d;
	$transactions[$i] =~ tr/\t//d;
	$transactions[$i] =~ tr/ //s;
#	print $transactions[$i];
}


for ($i=0; $elapsub > $i; $i++)
{
#	print "Elapsed Time\n";
	
	$elapsed[$i] =~ tr/a-zA-Z//d;
	$elapsed[$i] =~ tr/://d;
	$elapsed[$i] =~ tr/\t//d;
	$elapsed[$i] =~ tr/ //s;
#	print $elapsed[$i];
}


for ($i=0; $datasub > $i; $i++)
{
#	print "Data Transferred\n";

	$data[$i] =~ tr/a-zA-Z//d;
	$data[$i] =~ tr/://d;
	$data[$i] =~ tr/\t//d;
	$data[$i] =~ tr/ //s;
#	print $data[$i];
}


for ($i=0; $respsub > $i; $i++)
{
#	print "Response Time\n";

	$response[$i] =~ tr/a-zA-Z//d;
	$response[$i] =~ tr/://d;
	$response[$i] =~ tr/\t//d;
	$response[$i] =~ tr/ //s;
#	print $response[$i];
}


for ($i=0; $tratesub > $i; $i++)
{
#	print "Transaction Rate\n";

	$trate[$i] =~ tr/a-zA-Z//d;
	$trate[$i] =~ tr/://d;
	$trate[$i] =~ tr/\///d;
	$trate[$i] =~ tr/\t//d;
	$trate[$i] =~ tr/ //s;
#	print $trate[$i];
}


for ($i=0; $tputsub > $i; $i++)
{
#	print "Throughput\n";

	$tput[$i] =~ tr/a-zA-Z//d;
	$tput[$i] =~ tr/://d;
	$tput[$i] =~ tr/\///d;
	$tput[$i] =~ tr/\t//d;
	$tput[$i] =~ tr/ //s;
#	print $tput[$i];
}


for ($i=0; $consub > $i; $i++)
{
#	print "Concurrency\n";

	$concurr[$i] =~ tr/a-zA-Z//d;
	$concurr[$i] =~ tr/://d;
	$concurr[$i] =~ tr/\t//d;
	$concurr[$i] =~ tr/ //s;
#	print $concurr[$i];
}
for ($i=0; $codesub > $i; $i++)
{
#	print "Code 200\n";

	$code200[$i] =~ tr/a-zA-Z//d;
	$code200[$i] =~ tr/200/ /d;
	$code200[$i] =~ tr/\t//d;
	$code200[$i] =~ tr/://d;
	$code200[$i] =~ tr/ //s;
#	print $code200[$i];
}

# Okay, data is as good as it is going to get.  Let's start writing the 
# output CSV file.

open (OUTFILE, "> $ARGV[0].csv")
        or die "Cannot write to designated output file: $!\n"; 
# The next line sets up the colum titles.
# The leading comma in ",Transactions" causes the number of users colum to
# be titleless.  I suppose it could be Users in front instead . . . 
print OUTFILE ",Transactions,Elapsed Time,Data Transferred,Response Time,Transaction Rate,Throughput,Concurrency,Code 200 (note that this is horribly broken.) \n"; 

# Here we fill the data in the colums.
for ($i=0; $transub > $i; $i++)
{
	print OUTFILE $numusers[$i], ",", $transactions[$i], ",",
$elapsed[$i], ",", $data[$i], ",", $response[$i], ",", $trate[$i], ",", $tput[$i], ",", $concurr[$i], ",", $code200[$i]; 
	print OUTFILE "\n"; 
}


close (OUTFILE);
