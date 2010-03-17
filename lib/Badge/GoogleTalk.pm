package Badge::GoogleTalk;

use warnings;
use strict;

use version;
our $VERSION = qv('0.3');

use WWW::Mechanize;

=head2
New
=cut
sub new
{
	my($class,%args) = @_;
	
	my $query_link = 'http://www.google.com/talk/service/badge/Show?tk=';
	
	my $self = { %args };
	
	_warn_user('Error',"User key is must to use this module :".
				   "For more info please see the module pod") if(!defined $self->{'key'});
	
	$self->{'talk_url'} = $query_link.$self->{'key'};
	
	bless $self, $class or die "Can't bless $class: $!";
	return $self;
}

=head2
private method to get content
=cut
sub _get_contents
{
	my $self = shift;
	
	my $mech       = WWW::Mechanize->new();
	$mech->get($self->{'talk_url'});

	my $page_contents 	= $mech->content();
	my $content_type 	= $mech->ct();
	my $response 		= $mech->status();

	_warn_user('Error','Provided user key is in-valid !') if($response == '400');
		
	$self->{'is_badge_html'} = $mech->is_html() ? 1 : 0 ;
	
	_warn_user('Warning',"Your Badge's is Hyperlink and status icon style".
				   "sorry can't process for this style") if(!$self->{'is_badge_html'});
	
	return $page_contents;
}

=head2
	Title   : is_online			      
	Function: this will return your online status
	return : 1 if online, 0 if offline
=cut
sub is_online{
	my $self = shift;
	my $content = $self->get_status();
	if($content =~/Offline/)
	{
		return 0;
	}
	return 1;
}

=head2
	Title   : get_status
	Function: this will return your status message
	return : 1 if away
=cut
sub get_status {
	my $self = shift;
	my $contents = $self->_get_contents();
	$contents =~ /<div class=\"r\".*? src="\/talk\/service\/resources\/.*?">\s*(.*?)\s*<\/div><\/div>/;
	$contents =~ /<a name=\"s\".*? onclick="_click.*?">\s*(.*?)\s*<\/a><\/div><\/body>/;
	$contents =~ /<div class=\"r\".*? style=".*?<\/span>\s*(.*?)\s*<\/div><\/div><\/body>/;
	return $1;
}

=head2
	Title   : get_chat_box_link
	Function: this will return you the link of you chat box
=cut
sub get_chat_box_link{
	my $self = shift;
	my $url = $self->{'talk_url'} ;
	$url =~ s/Show/Start/ig;
	return $url;
}

=head2
	Title   : is_away
	Function: this will return your away status
	return : 1 if away
=cut
sub is_away{
	my $self = shift;
	my $content = $self->get_status();
	if($content =~/Away/ig)
	{
		return 1;
	}
	return 0;
}

=head2
	Title   : get_badge
	Function: this will return you the badge iframe to use for your website
=cut
sub get_badge{
	my $self 	= shift;
	my $badge 	= '<iframe src="http://www.google.com/talk/service/badge/Show?tk='.
					$self->{'key'}.
					'&amp;w=200&amp;h=60" allowtransparency="true" width="200" frameborder="0" height="60"></iframe>';
	return $badge;
}

=head2
	Title   : is_classic_style
	Function: this will return your badge style
	return : 1 if Classic badge or one/two line style, 0 if Hyperlink and status icon style
=cut
sub is_classic_style {
	my $self	= shift;
	return $self->{'is_badge_html'};
}

=head2
private method to warn user
=cut
sub _warn_user {
    my($type,$msg) = @_;
    print "[ $type ] $msg \n";
	exit;
}


1; # Magic true value required at end of module
__END__

=head1 NAME

Badge::GoogleTalk - To get your status message/online status/chat link from google talk badge for website live chat.

=head1 VERSION

version 0.3


=head1 SYNOPSIS

    use Badge::GoogleTalk;
	my $my_object = Badge::GoogleTalk->new(
			key => "your identification key",
	);

	# Get Your Badge's online status
	my $online_status = $my_object->is_online();
	my $ol_status = $online_status == 0 ? "Offline" : "Online";
	
	# Get Your Badge's status message	
	my $status = $my_object->get_status();

	# Check Your Badge's away status
	my $away_status = $my_object->is_away();
	my $aw_status = $away_status == 1 ? "Away" : "Online";
	
	# Check Your Badge's Style
	my $style = $my_object->is_classic_style();
	my $style_status = $style == 1 ? "Classic badge or one/two line style" : "Hyperlink and status icon style";
	
	# Your Badge's in HTML format
	my $badge = $my_object->get_badge();

	# Your chat link for your website
	my $chat_link = $my_object->get_chat_box_link();

	To create a simple Badge::GoogleTalk you must pass the key;
	key is your identification from the google authentication.
	
	To create your chatback badge, visit http://www.google.com/talk/service/badge/New.
	If you're using a Google Apps account,
	you can create a chatback badge by visiting http://www.google.com/talk/service/a/DOMAIN/badge/New where DOMAIN is the name of your domain.
 
	Use the alphanumeric account hash to pass as key in constructor
  
=head1 DESCRIPTION

	A simple perl module for retrieving a user's Google Talk status
	Google does provide a badge, to post your status/images/links to your
	website to start a chat. Using this code, we can extract the status messages, online status,
	chat box link and return that information to our perl application to keep up the live chat.

=head1 METHODS

=head1 DIAGNOSTICS

	This module depends on the output from a hosted web page by Google. If Google
	decides at any time to change this output, the module will likely fail.
	Please e-mail me if this is the case, so we can get it working again.

=over

=back


=head1 CONFIGURATION AND ENVIRONMENT
  
Badge::GoogleTalk requires no configuration files or environment variables.


=head1 DEPENDENCIES

	This module have the dependencies with the following modules
	WWW::Mechanize

=head1 BUGS AND LIMITATIONS

	No bugs have been reported.
	
	Please report any bugs or feature requests to
	C<bug-badge-googletalk@rt.cpan.org>, or through the web interface at
	L<http://rt.cpan.org>.


=head1 AUTHOR

Rakesh Kumar Shardiwal  C<< <rakesh.shardiwal@gmail.com> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2009, Rakesh Kumar Shardiwal C<< <rakesh.shardiwal@gmail.com> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
