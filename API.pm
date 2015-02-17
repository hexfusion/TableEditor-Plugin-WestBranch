package TableEdit::Plugins::WestBranch::API;
use Dancer ':syntax';
use POSIX;
use Dancer::Plugin::DBIC qw(schema resultset rset);

sub schema_info {return TableEdit::Routes::API->schema_info;}

sub menu {
	my ($self, $menu) = @_;
	$menu->{'Bulk tools'} = {sort => 120, items => [
		{name => 'Product images', url => '#Product/images/bulkImageUpload'},
		{name => 'Product navigation assign', url => '#Product/navigations/bulkAssign'},
	]};
	return $menu;
}

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
