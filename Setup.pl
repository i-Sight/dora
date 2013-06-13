#!/bin/perl

use strict;
use Term::ANSIColor;

package GitFiltersForNSF;

our $useColours = 1;
our $verbose    = 0;
our $scriptDir  = '~/GitFiltersForNSF/';
our $xslDir     = '~/GitFiltersForNSF/xsl/';

use File::Basename;
my $dirname = dirname(__FILE__);

print $dirname;

exit 0;

processArgs();

introduction();
setupNewNSFFolder();
checkInGitRepo();
specifyScriptDir();
addFiltersToGitConfig();
#setSigner();
updateGitAttributes();
updateGitIgnore();
finish();

sub mycls {

  system("clear");
  
}

sub heading {

  my $maxwidth  = 50;
  my $fillerChar = "*";

  # Get the Title from the sub arguments
  my ($title) = @_;;

  # Determine number of Asterixes either side
  my $tlength = length($title);
  my $totFillers = $maxwidth - $tlength - 4;
  if ($totFillers < 0) { print "Error: Title too long... exiting";exit -1; };
  my $fillers = int($totFillers / 2);

  # Give me some space
  print "\n";
  mycls();

  # If we are using colours, Set up the colour
  if ($useColours) {
    print Term::ANSIColor::color("bold white");
    print Term::ANSIColor::color("on_blue");
  }

  # Print first asterixes
  for (my $i = 0; $i < $fillers; $i++) { print $fillerChar; }

  # print Heading with space either side
  print " $title ";

  # Print last asterixes
  for (my $i = 0; $i < $fillers; $i++) { print $fillerChar; }
  # Print an extra one if there was an odd number
  if (($totFillers % 2) > 0) { print $fillerChar; }

  # If we are using colours, reset them
  if($useColours) {
    print Term::ANSIColor::color("reset");
  }

  # Print new line
  print "\n\n";

}

sub setupNewNSFFolder {
  
  # Ask for the Application name
  heading("Setup New NSF Git Folder");

  print "This step will create a new folder for an NSF\n\n";
  print "What is the name of the Folder?\n\n";

  my $opt = <>;
  chomp($opt);

  if ($opt =~ /[a-zA-Z]/) {

    # Make the new Directory
    mkdir($opt);

    # Set up the NSF Folder
    mkdir("$opt/nsf");
    mkdir("$opt/xsl");

    # TODO Initialise the GitIgnore file

    # Initialise a Git Repository
    chdir($opt);
    my @args = ('init');
    system('git',@args);

  }
  
  chdir($opt);

}

sub specifyScriptDir {

  # Check the location of the GitFiltersForNSF folder
  heading("Location of XSL Files");
  print "Where have you put the GitFiltersForNSF xsl files: \n\n";
  print "1. In the xsl/ directory in the root of this repository\n";
  print "2. In the default directory under my HOME path accessibly by " . $xslDir . "\n";

  print "\nEnter Choice: ";

  my $opt = <>; 
  chomp($opt);

  exit 0 if $opt =~ m/^q/i;

    if ($opt eq "2") {

    } elsif ($opt eq "1" || $opt eq "") {
      $scriptDir = "xsl/";      
    } else {
      print "\nInvalid menu option\n";
      exit 0;
    }

}

sub checkInGitRepo {

  # make sure in we are in a Git Repo

  if ($verbose) { print "\nChecking if we are in a git repository: "};

  my @args = ('rev-parse','--git-dir');
  system('git',@args);

  if ($? == -1) {
    if ($verbose) { print 'git rev-parse failed, please run this operation from a Git Repository\n'; }
  } else {

    # Must shift the result to get the error code
    my $result = $? >> 8;

    if ($result != 0) {
      printf "\nNot in a Git Repo command exited with value %d\n", $result;
      exit -1;
    }

  }  

}

sub addFiltersToGitConfig {

  heading("Add NSF Filter to Git Config");

  print "This step will add a new filter to the local .gitconfig file\n";
  print "It does this by adding two entries filter.nsf.clean and filter.nsf.smudge\n";
  print "These entries point to the location of 2 corresponding perl scripts in the GitFiltersForNSF directory\n\n"; 

  print "1. Add the nsf filter to local .gitconfig\n";
  print "2. Remove nsf filter from local .gitconfig\n";
  print "3. Skip this step\n";

  print "\nEnter Choice: ";

  my $setUpGitConfig = <STDIN>;
  chomp($setUpGitConfig);

  my @args = ();

  exit 0 if $setUpGitConfig =~ /^q/i;

  if ($setUpGitConfig eq "1" || $setUpGitConfig eq "") {

    my $cleanScript   = 'xsltproc ' . $scriptDir . 'transform.xsl -';
    my $smudgeScript  = 'cat';

    #TODO check the return status of these system commands

    @args = ('config','--local','filter.nsf.clean',$cleanScript);
    system('git',@args);

    @args = ('config','--local','filter.nsf.smudge',$smudgeScript);
    system('git',@args);

    @args = ('config','--local','filter.nsf.required','true');
    system('git',@args);

    print "\nAdded git filters\n";

  } elsif ($setUpGitConfig eq "2") {

    #TODO Check the return status of these system commands

    @args = ('config','--local','--unset','filter.nsf.clean');
    system('git',@args);

    @args = ('config','--local','--unset','filter.nsf.smudge');
    system('git',@args);

    @args = ('config','--local','--unset','filter.nsf.required');
    system('git',@args);

    print "\nRemoved Git Filters\n";

  }

}

sub setSigner {
  
  # Ask for behaviour to do with wassignedby Tag
  heading("Design Element Signer");

  print "This step will configure the nsf filter to replace the <wassignedby> Note item\n";
  print "Please note this could be a bad idea from a security point of view.\n";
  print "If you pull changes from other contributors, the changes will appear as already signed by the ID you specify here\n\n";
  print "1. No Action. Leave in current configuration\n";
  print "2. Set up the default signer\n";
  print "3. Remove the default signer\n";
  print "\nEnter Choice: ";


  our $useSigner = <>;
  chomp($useSigner);

  exit 0 if $useSigner =~ /^q/i;

  if ($useSigner eq "2") {

    print "\nThe NotesName will be saved in format 'CN=<Common Name>/O=<Organisation>' in the local .gitconfig under the entry 'nsf.signer'\n";


    print "\nPlease type the Common Name : ";
    my $signerCN = <STDIN>;
    chomp($signerCN);
    $signerCN =~ s/^\s*(.*?)\s*$/$1/;

    print "Please type the Organisation: ";
    my $signerOrg = <STDIN>;
    chomp($signerOrg);
    $signerOrg =~ s/^\s*(.*?)\s*$/$1/;

    my $signer = "CN=" . $signerCN . "/O=" . $signerOrg;

    print "Signer will be set as a local git config variable nsf.signer as:\n";
    print "\"$signer\"" . "\n";
    print "\nPlease confirm if ok (y/n): ";
    my $confirm = <STDIN>;

    if ($confirm =~ m/^y/i) {

      #TODO test for return value

      my @args = ('config','--local','nsf.signer',"\"$signer\"");
      system('git', @args);

      if ($? == -1) {  

        print 'git config command failed, please check Git is installed\n';    

      } else {

        my $result = $? >> 8;

        if ($result == 0) {
          print "\nnsf.signer successfully Added\n";
        } elsif ($result == 3) {
          print "\nThe .gitconfig file is invalid\n";
        } else {
          print "\nFAIL: git config returned error code " . $result;
        }

      }

    }

  } elsif ($useSigner eq "3") {

    my @args = ('config','--local','--unset-all','nsf.signer');
    system('git',@args);

    if ($? == -1) {
      print 'git config command failed, please check Git is installed\n';
    } else {
  
  
      my $result = $? >> 8;

      if ($result == 0) {
        print "\nnsf.signer was successfully removed from local .gitconfig\n";
      } elsif($result == 5) {
        print "\nnsf.signer did not exist in .gitconfig anyway\n";
      } else {        
        printf "FAIL: git config exited with return value %d", $? >> 8;
      }

    }

  }

}

sub updateGitAttributes {

  my $gitattrfile = ".gitattributes";
  my $tmpattrfile = ".gitattributestemp";

  heading("Associate File Extensions with Filter");

  print "This step will update the .gitattributes of the current repository.\n";
  print "WARNING: This function will sort and deduplicate your .gitattributes file.\n";
  print "If you have comments or keep your .gitattributes in a particular order, this will destroy that order\n";
  print "It will associate certain files with the nsf filter that was configure in the .gitconfig file.\n\n";

  checkInGitRepo();

  print "1. Add All Associations\n";
  print "2. Remove all associations\n";
  print "3. Skip this step\n";

  print "\nEnter Choice: ";

  my @exts = (
    '*.column',
    '*.dcr',
    '*.fa',
    '*.field',
    '*.folder',
    '*.form',
    '*.frameset',
    '*.ja',
    '*.lsa',
    '*.lsdb',
    '*.metadata',
    '*.navigator',
    '*.outline',
    '*.page',
    '*.subform',
    '*.view',
    'AboutDocument',
    'database.properties',
    'IconNote',
    'Shared Action',
    'UsingDocument' );

  my $addAssoc = <STDIN>;  
  chomp($addAssoc);

  exit 0 if $addAssoc =~ /^q/i;

  if ($addAssoc eq "1" || $addAssoc eq "") {

    # Add any of the patterns that were not found
    open (GITATTR, ">>$gitattrfile") or die "Can't Open .gitattributes file for appending: $!";

    foreach (@exts) {

      my $pattern = "$_ filter=nsf\n";
      print GITATTR $pattern;

    }

    close (GITATTR);

    system("sort -u $gitattrfile > $tmpattrfile");
    system("mv $tmpattrfile $gitattrfile");


  } elsif ($addAssoc eq "2") {
    
    foreach (@exts) {

      my $pattern = "/$_ filter=nsf/d";
      my @sedargs = ('-i', $pattern, $gitattrfile);
      system('sed', @sedargs);      

    }

  }

}

sub updateGitIgnore {

  heading("Initialise Git Ignore File");

  my $gitignorefile = ".gitignore";

  print "This step will update the .gitignore file in the root of the current repository.\n";
  print "It will ignore some files.\n\n";

  print "1. Add Git Ignore entries\n";
  print "2. Remove Git Ignore Entries\n";
  print "3. Skip this step\n";

  print "\nEnter Choice: ";

  my @ents = ('nsf/.classpath','nsf/.project','nsf/plugin.xml','nsf/.settings','database.properties','IconNote');

  my $addAssoc = <STDIN>;
  chomp($addAssoc);

  exit 0 if $addAssoc =~ /^q/i;

  if ($addAssoc eq "1" || $addAssoc eq "") {

    # Add to gitattributes file
    open (GITATTR, ">>$gitignorefile");

    print GITATTR "\n# GitNSF Start\n";

    foreach (@ents) {
      print GITATTR "$_\n";
    }

    print GITATTR "# GitNSF End\n";


    close (GITATTR);

  } elsif ($addAssoc eq "2") {

    my @sedargs = ('-i', "/# GitNSF Start/,/#GitNSF End/d", $gitignorefile);
    system('sed', @sedargs);

  } 

}



sub introduction {

  print "\n===================================\n";
  print " Git Filters for NSF setup script\n";
  print "-----------------------------------\n\n";

  print "This script will set up the Git Filters for NSF for the current Git Repository\n";
  print "The script will do the following:\n\n";

  print " * Add the 'nsf' clean and smudge filters to the local Git config file .gitconfig\n";
  print " * Associate the 'nsf' filter with form view page files etc. in .gitattributes\n";
  print " * Add your default signer as another variable in .gitconfig 'nsf.signer'\n";

  print "\nOption 1 is the default choice for all questions. Enter q to quit at any point.\n\n";

  print "Press Enter to begin: ";

  my $opt = <>;

  exit 0 if $opt =~ m/^q/i;
}

sub finish {

  heading("Setup Complete");
  print "Details of action performed\n\n";


  print "You can check the result of the setup using the following commands:\n\n";
  print "Check the git config:\n";
  print "git config --list | grep nsf\n\n";

  print "Check the git attributes file for the file associations\n";
  print "grep nsf .gitattributes\n\n";



}

sub processArgs {

  my $numArgs = $#ARGV + 1;

  foreach my $argnum (0 .. $#ARGV) {
    if ($ARGV[$argnum] eq '--no-color') {
      $useColours = 0;
    }

    if ($ARGV[$argnum] eq '--update-attributes') {
      updateGitAttributes();
      exit 0;
    }

    if ($ARGV[$argnum] eq '--update-ignore') {
      updateGitIgnore();
      exit 0;
    }

    if ($ARGV[$argnum] eq '-v') {
      $verbose = 1;
    }

    print "$ARGV[$argnum]\n";
  }

}