package Badge::GoogleTalk;

use warnings;
use strict;
use Carp;

use version;
my $VERSION = qv('0.0.1');

use Data::Dumper;
use WWW::Mechanize;
use HTTP::Request;
use LWP::UserAgent;
use Exporter();

our @EXPORT_OK = (
	qw/
		is_online
		is_away
		get_status
		get_badge
		get_chat_box_link
	  /
);

sub new
{
	my($class,%args) = @_;
	
	my $query_link = 'http://www.google.com/talk/service/badge/Show?tk=';
	
	my $self = { %args };
	
	if(!defined $self->{'key'})
	{
		_warn_user("User key is must to use this module :".
				   "For more info please see the module pod");
		exit;
	}
	$self->{'talk_url'} = $query_link.$self->{'key'};
	
	bless $self, $class or die "Can't bless $class: $!";
	return $self;
}

sub _get_contents
{
	my $self = shift;
	
	my $mech       = WWW::Mechanize->new();
	$mech->get($self->{'talk_url'});

	my $page_contents = $mech->content();

	if ($page_contents =~ /Bad Request/ig)
	{
		_warn_user('Provided user key is in-valid !');
		return 0;
	}

	return $page_contents;
}

sub get_status {
	my $self = shift;
	my $contents = $self->_get_contents();
	$contents =~ /<div class=\"r\".*? src="\/talk\/service\/resources\/.*?">\s*(.*?)\s*<\/div><\/div>/;
	return $1;
}

sub is_online{
	my $self = shift;
	my $content = $self->get_status();
	if($content =~/Offline/)
	{
		return 0;
	}
	return 1;
}

sub get_chat_box_link{
	my $self = shift;
	my $url = $self->{'talk_url'} ;
	$url =~ s/Show/Start/ig;
	return $url;
}

sub is_away{
	my $self = shift;
	my $content = $self->get_status();
	if($content =~/Away/ig)
	{
		return 1;
	}
	return 0;
}

sub get_badge{
	my $self 	= shift;
	my $badge 	= '<iframe src="http://www.google.com/talk/service/badge/Show?tk='.
					$self->{'key'}.
					'&amp;w=200&amp;h=60" allowtransparency="true" width="200" frameborder="0" height="60"></iframe>';
	return $badge;
}

sub _warn_user {
    my($msg) = @_;
    print "Error\t: $msg \n";
}



1; # Magic true value required at end of module
__END__

=head1 NAME

Badge::GoogleTalk - To get your status message/online status/chat link from google talk badge for website live chat.

=head1 VERSION

version 0.0.1


=head1 SYNOPSIS

    use Badge::GoogleTalk;
	my $my_object = Badge::GoogleTalk->new(
			key => "your identification key",
	);

	# get you google talk status message	
	my $status = $my_object->get_status();

	# get your online status
	my $online_status = $my_object->is_online();
	my $ol_status = $online_status == 0 ? "Offline" : "Online";
	
	# check your away status
	my $away_status = $my_object->is_away();
	my $aw_status = $away_status == 1 ? "Away" : "Online";
	
	# get you badge for you website
	my $badge = $my_object->get_badge();

	# get you chat link for you website
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

=head2 is_online

	Title   : is_online
					      
    Function: this will return your online status
	
	return : 1 if online, 0 if offline

=head2 is_away

	Title   : is_away
					      
    Function: this will return your away status
	
	return : 1 if away

=head2 get_status

	Title   : get_status
					      
    Function: this will return your status message
	
	return : 1 if away

=head2 get_chat_box_link

	Title   : get_chat_box_link
					      
    Function: this will return you the link of you chat box


=head2 get_badge

	Title   : get_badge
					      
    Function: this will return you the badge iframe to use for your website


=head1 DIAGNOSTICS

	This module depends on the output from a hosted web page by Google. If Google
	decides at any time to change this output, the module will likely fail.
	Please e-mail me if this is the case, so we can get it working again.

=over

=item C<< Error message here, perhaps with %s placeholders >>

[Description of error here]

=item C<< Another error message here >>

[Description of error here]

[Et cetera, et cetera]

=back


=head1 CONFIGURATION AND ENVIRONMENT
  
Badge::GoogleTalk requires no configuration files or environment variables.


=head1 DEPENDENCIES

	This module have the dependencies with the following modules
	Data::Dumper
	WWW::Mechanize
	HTTP::Request
	LWP::UserAgent
	Exporter


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
