package TableEdit::Plugins::WestBranch::API;
use Dancer ':syntax';
use POSIX;
use Dancer::Plugin::DBIC qw(schema resultset rset);

prefix '/';

get '/' => sub {
	my $file = '../../lib/TableEdit/Plugins/WestBranch/public/views/index.html';

    template $file, {
    	base_url => config->{base_url}, 
    	plugins => TableEdit::Plugins::attr('plugins'),
    };
};


prefix '/api';



1;
