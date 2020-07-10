use IO::Socket;
$| = 1;
@ships=();
%hash = ('a'=>1 ,'b'=>2,'c'=>3,'d'=>4,'e'=>5);
$socket = new IO::Socket::INET (PeerAddr  => '127.0.0.1', PeerPort  =>  8888, Proto => 'tcp',)                
or die "Can't connect to the server!\n";


sub conv2{
	$string = $_[0];
	@nums = ();
	@nums = split (" ",$string);
	@a = ();
	@result = ([0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0],[0,0,0,0,0]);
	for($i = 0;$i<5;$i++)
	{
		for($j = 0;$j<5;$j++)
		{
			$result[$i][$j] = $nums[$i*5+$j];
		}
	}
	return @result;
}

sub conv1
{
	$string = $_[0];
	@hp = split (" ",$string);
}

sub isValid
{
	$x = $_[0];
	$y = $_[1];
	if($x<1||$x>5||$y<1||$y>5)
	{
		return 0;
	}
	else
	{
		return 1;
	}
}

sub shoot
{
	$x = 0;
	$y = 0;
	while(1)
	{
		print "Input shoot coordinate row: ";
		$x=<>; 
		chop($x);
		print "\n";
		print "Input shoot coordinate column: ";
		$y=<>;
		chop($y);
		print "\n";
		if(!exists($hash{$y}))
		{
			print "Wrong coordinate!\n";
			next;
		}
		else
		{
			$y = $hash{$y};
		}
		if(isValid($x,$y) != 1 )
		{
			print "Wrong coordinate!\n";
		} 
		elsif($ships[$x-1][$y-1] != 0)
		{
			print "You can't fire your own ship!\n";
		}
		else
		{

			last;
		}
	}
	$socket->send($x);
	sleep(0.5);
	$socket->send($y);
}

sub visualization
{
	$header = "  a b c d e\n";
	print $header;
	for($i = 0;$i<5;$i++)
	{
		print $i+1;
		print " ";
		for($j = 0;$j<5;$j++){
			print "$ships[$i][$j] ";
		}
		print "\n";
	}
}

sub printHP
{
	print "Ships' HP\n";
	$string = $_[0];
	@hp = conv2($string);
	$header = "  a b c d e\n";
	print $header;
	for($i = 0;$i<5;$i++)
	{
		print $i+1;
		print " ";
		for($j = 0;$j<5;$j++)
		{
			print "$hp[$i][$j] ";
		}
		print "\n";
	}
}
$socket->recv($received_data,1024);
print $received_data;
$socket->recv($playerID,1024);
while(1)
{
	$socket->recv($received_data,1024);
	@ships = conv2($received_data);
	visualization();
	$socket->recv($received_data,1024);
	printHP($received_data);
	if($playerID == 2)
	{
		print "Player 1's turn!\n";
		$socket->recv($received_data,1024);
		printHP($received_data);
		$socket->recv($received_data,1024);
		if($received_data eq "Game is still going\n")
		{
			print $received_data;
		}
		else
		{
			print $received_data;
			close $socket;
			last;
		}
	}
	$socket->recv($received_data,1024);
	if($received_data eq "Your turn!\n")
	{
		print $received_data;
		$socket->send(0);

		shoot();
		$socket->recv($received_data,1024);
		print $received_data;
		$socket->recv($received_data,1024);
		print $received_data;
		if($received_data eq "Game is still going\n")
		{
			print 1;
		}
		else
		{
			close $socket;
			last;
		}
	}
	if($playerID == 1)
	{
		print "Player 2's turn!\n";
		$socket->recv($received_data,1024);
		printHP($received_data);
		$socket->recv($received_data,1024);
		if($received_data eq "Game is still going\n")
		{
			print $received_data;
		}
		else
		{
			print $received_data;
			close $socket;
			last;
		}
	}
}
