package TableEdit::Plugins::WestBranch::API;
use Dancer ':syntax';
use POSIX;
use Dancer::Plugin::DBIC qw(schema resultset rset);
use File::Copy;

sub schema_info {return TableEdit::Routes::API->schema_info;}
my $appdir = TableEdit::Config::appdir();

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


post '/bulkUploadImages/temp' => sub {
	my $body = from_json request->body;

	# Move product images to supplier dir
	if ($body->{move}){
		
		my $class_info = schema_info->class($body->{class});
		my $column_info = $class_info->column($body->{column});
		my $media = $class_info->find_with_delimiter($body->{id});	
		pass unless $media;
		my $product = $media->products->first if $media->products;
		pass unless $product;
		my $manufacturer;
		
		my $nav = $product->navigations->first;
		next unless defined $nav and $nav->type eq 'manufacturer';
		$manufacturer = $nav->uri;
		
		my $path = $column_info->upload_dir;
		my $dir = "$appdir/public/$path";
		my $old_file = $media->file;
		my $new_file = $manufacturer.'_'.$media->file;
		$media->file($new_file);
		move($dir.$old_file, $dir.$new_file);
		$media->update;
		
		return 1;
	}
	
	pass;
};

1;
