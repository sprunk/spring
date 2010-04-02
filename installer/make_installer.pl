#!/usr/bin/perl -w
#
# @param distributionDir
#

use strict;
use File::Basename;
use Cwd 'abs_path';
use File::Spec::Functions;


# Evaluate installer and root dirs
my $installerDir=$0;
$installerDir=$ENV{PWD}."/".$installerDir unless($installerDir =~ /^\//);
$installerDir=dirname($installerDir);

chdir("$installerDir/..");
die "Unable to find \"installer\" directory." unless(-d "installer");


# Aquire AI Interfaces and Skirmish AI versions
sub getSubDirsVersion {
  my $baseDir=shift;
  my %dirVersions;

  die("Cannot open directory \"$baseDir\": $!") unless(opendir(IMD, $baseDir));
  my @subDirs=grep {-d "$baseDir/$_" && $_ ne "." && $_ ne ".."} readdir(IMD);
  close(IMD);
  foreach my $subDir (@subDirs) {
    if(open(DAT,"$baseDir/$subDir/VERSION")) {
      my $dirVersion=<DAT>;
      close(DAT);
      chomp($dirVersion);
      $dirVersions{$subDir}=$dirVersion;
    }
  }
  return \%dirVersions;
}

sub getVersionVarsString {
  my ($baseDir,$varPrefix)=@_;
  my @vars;

  my $p_dirVersions=getSubDirsVersion($baseDir);
  foreach my $subDir (keys %{$p_dirVersions}) {
    push(@vars,"-D$varPrefix$subDir=$p_dirVersions->{$subDir}");
  }
  my $varsString=join(" ",@vars);
  return $varsString;
}

my $allVersStr= getVersionVarsString("AI/Interfaces/", "AI_INT_VERS_");
$allVersStr= $allVersStr." ".getVersionVarsString("AI/Skirmish/", "SKIRM_AI_VERS_");


# Evaluate the engines version
my $testBuildString="";
my $tag=`git describe --candidate=0 --tags 2>/dev/null`;
if ($?) {
  $testBuildString="-DTEST_BUILD";
  $tag=`git describe --tags`;
  die "Unable to run \"git describe\"." if($?);
  chomp($tag);
  print "Creating test installer for revision $tag\n";
} else {
  chomp($tag);
  print "Creating installer for release $tag\n";
}


# Download some files to be included in the installer
system("sh", "installer/springlobby_download.sh");
chdir("$installerDir/downloads");
system("wget", "-N", "http://springrts.com/dl/TASServer.jar");
system("wget", "-N", "http://www.springlobby.info/installer/springsettings.exe");
system("wget", "-N", "http://files.caspring.org/caupdater/SpringDownloader.exe");
chdir("$installerDir/..");


# Evaluate the distribution dir
# This is where the build system installed Spring,
# and where the installer generater will grab files from.

my $distDir="";
foreach my $dd ("$1", "dist", "game") {
	if (($dd eq "") or (not -d $dd)) {
		print("Distribution directory not found: \"$dd\"\n");
	} else {
		$distDir=abs_path($dd);
		print("Using distribution directory \"$distDir\"\n");
		last; # like break in other languages
	}
}
die "Unable to find a distribution directory." if ($distDir eq "");
my $distDirRel = File::Spec->abs2rel($distDir, "installer");
$distDirRel =~ tr/\//\\/d;


# Generate the installer
system("makensis -V3 $testBuildString -DVERSION_TAG=\"$tag\" -DDIST_DIR=\"$distDirRel\" $allVersStr installer/spring.nsi");
