# Domino ODP Repository Helper (dora)

Dora's primary purpose is to assist in setting up **DXL Metadata filters** for a Git Repository for an IBM Notes/Domino nsf On-Disk Project.

> Project is under beta-testing, please do not use this on live databases unless
> you understand what is happening and are comfortable with it

This project is only in it's beginning. Currently dora is implemented as a Perl script which runs in a bash-like terminal e.g. *Git Bash* on Windows, SourceTree's Terminal or the Mac Terminal

*note* You can set up DXL Metadata filters manually, so if you don't want to use dora and just want to manually configure the Git Metadata filters yourself please see the [Manually Configuring the DXL Metadata Filters](#manually-configuring-the-dxl-metadata-filters) section below.

## Usage

To use dora, you must first install it. Then you open a terminal, navigate to a git repository's root directory and issue the command `dora`
This will open a menu in the terminal which will allow you to configure the current repository for DXL Metadata filters.

### Setting up DXL Metadata Filters

To set up the DXL Metadata filters for a repository:

1. open a bash-like terminal
2. navigate to the repository root directory
3. run `dora`
4. Choose 1. for *Install Something*
5. Choose 1. for *Install Everything*
6. Follow the prompts!

If you encounter any issues (please report them!) you can set up the DXL Metadata filters manually, please see the [Manually Configuring the DXL Metadata Filters](#manually-configuring-the-dxl-metadata-filters) section below..

### Removing the DXL Metadata Filters

To remove the Metadata Filters from a repository

1. Open a bash-like terminal
2. Navigate to the Repository root directory
3. Run `dora`
4. Choose 2. for *Uninstall Something*
5. Choose 1. for *Uninstall Everything*

Again, if you have any issues please report them 

## Installation

To install Dora, the first step is to obtain the latest release. You can do this 3 ways:

* Download the latest release from camac/dora project on github.com
* Download the latest release from the releases section in the OpenNTF Project
* Clone the repository from https://github.com/camac/dora.git and checkout the master branch

The installation process simply copies the required executables and resources to 2 different directories in your [home directory](http://en.wikipedia.org/wiki/Home_directory). 
On windows your home directory should be something like `C:\Users\Cameron`, on a mac `/Users/Cameron`
From this point on I will use the symbol ~ to refer to the home dir

Target Executables directory : ~/bin  
Target Resources directory   : ~/dora

The reason that ~/bin was chosen is that it is already included on the PATH environment variable when using Git Bash. This means that executables placed in this directory can be run from any other location.

Executables that are copied

  - dora.pl (The Dora Helper Script) copied as dora
  - libxslt win 32 Binaries which are \*.dll's and \*.exe's required for running xsltproc (windows only, should already be on mac)

Resources that are copied

  - \*.xsl files used in DXL Metadata filter

### Windows + Git Bash / Git Gui

Open Git Bash, Navigate to the unzipped dora release (or the cloned camac/dora.git repository) and run `./Install.pl`
Follow the prompts

### Windows using SourceTree

When using Sourcetree, these instructions assume you have enabled the setting:

Tools -> Options -> Git -> 'Use Git Bash as Terminal'

Open the terminal using the Terminal Icon in the SourceTree 'ribbon' menu. You will need to have a repository open (any will do) to access the terminal.
Once in the terminal, navigate to wherever you unzipped the release of Dora.

Then issued the command `./Install.pl`

Move the installed folder $homeDir/bin to */Desktop/bin where * is the path to your Desktop

Edit the file $homeDir/dora to set $scriptDir = */Desktop/bin where * is the path to your Desktop

### Mac

Open a terminal, navigate to the directory that you unzipped the Dora release to, and run `./Install.pl`
Follow the prompts
libxslt should already installed on a Mac, so installing these binaries is not required. 
The Installation script should detect that you are using Mac, and skip that step for you.
If you find that the Install.pl script does not detect the mac properly, then run the install script with the option *--os-mac*

## Requirements

I plan to detail this section a bit better after beta testing.

This project has been tested using Windows 7 64-bit and Windows 8 64-bit, using Git for Windows and the Git Bash Terminal
When you are given the choice of which command line method, I chose 'Use Git Bash Only'

I was using Git Bash v 1.8.1.2-preview20130201 which includes Perl 5.8.8

It also needs libxslt which is mentioned in other sections of this readme.

## Contributing

Contributions can be made in varying forms. You can give feedback, opinions, bug reports, feature requests or even make coding contributions by forking the project and then submitting pull requests.

### Evaluating the Correctness/Effectiveness of DXLClean.xsl 

The DXLClean.xsl file is the *recipe* for choosing which elements and attributes we want to filter from the DXL.
The version of DXLClean.xsl included in this repository is only a result of what I (Cameron Gregor) have been using so far, and not necessarily a proclamation of what is a good idea by many.

One of the outcomes I am hoping to get from collaboration, is an agreed *safe version* of DXLClean.xsl that is considered safe to recommend to people. Riskier options for this filtering may then be provided in a separate optional xsl, or contained within the same \*.xsl file, and activated by parameters.

So, I would really appreciate feedback on the contents of DXLClean.xsl, and whether you think that it needs some modification. 

To help inform your decision, you can read through the Domino DTD (search from Designer Help for 'DTD') which theoretically documents the possible elements and attributes and whether or not they are optional (implied which is denoted by a Question Mark ?)

Also if you have not done XPath or XSLT before or need a refresher, the tutorials at www.w3schools.com were helpful to me, and may be of use to you too.

### Reporting Bugs

Please report bugs through [Dora's OpenNTF project page](http://www.openntf.org/internal/home.nsf/project.xsp?action=openDocument&name=Dora) 'Defects' page.
As usual, the more info the better.

### Feature Requests

Feature requests can be made through [Dora's OpenNTF project page](http://www.openntf.org/internal/home.nsf/project.xsp?action=openDocument&name=Dora) 'Feature Requests' page.Please feel free to fork this project and have a go at any new features yourself! 

## Testing

### Testing an XSL Transformation Stylesheet

To test an XSL Transformation Stylesheet, you will 2 files, the source xml file that you want to manipulate, and the xsl file that contains the instructions for the transformation.
You then use the xsltproc program from a terminal as follows:

    xsltproc.exe *xslfile* *sourcexmlfile*

This will output the resulting xml to the terminal.

If you would like to capture the output in a file instead, you can use the *-o* option like so

    xsltproc.exe -o *outputfile* *xslfile* *sourcexmlfile*

For a full list of parameters for xsltproc.exe just run xsltproc.exe with no parameters.

## Licence

See LICENCE file

This project contains a set of git filters and scripts which assist when collaborating on a Domino Project.

The set up information describes how to install and use them when using Git Bash which is the linux-like command prompt tool for using git under windows.

## Manual Installation

### Manual Installation of Dora

If the *Install.pl* script fails for any reason (please report bugs!) you can still install Dora manually 

1.  Create 2 directories in your home directory
    * ~/bin
    * ~/dora
2.  Copy the dora.pl file to ~/bin/dora (rename with no .pl extension)
3.  (For windows only) Copy the libxslt binaries (\*.dll's and \*.exe's) from within the /bin directories under libxslt/ to ~/bin
4.  Copy the XSL Files from xsl/ to ~/dora

### Installing libxslt from Original project

To run the DXL Metadata filters you need to have libxslt installed. If you are on a mac, libxslt should already be installed. If you are running windows, Dora will install these necessary files for you, however if you would like to install it manually yourself, follow these steps.

[libxslt](http://xmlsoft.org/XSLT/) is the XSLT C library developed for the GNOME project. If you go to the downloads section of the project page, you can find a link to the Windows versions, which are currently maintained by Igor Zlatkovic.

1.  Download the necessary files from Igor's [download area](ftp://ftp.zlatkovic.com/libxml/). If you read the [documentation](http://www.zlatkovic.com/libxml.en.html)
 it will tell you that to use libxslt you need to download the following packages:
    * iconv
    * libxml2
    * libxslt
    * zlib
2.  Extract the contents of the downloaded files
3.  Make a directory called *bin* in your HOME directory
    e,g. C:\Users\Cameron\*bin*
4.  Copy the contents of each of the download's *bin* directories to your HOME\bin directory 
    For example, at the time of writing this, the contents I needed to copy were:
    * iconv.dll
    * iconv.exe
    * libexslt.dll
    * libxml2.dll
    * libxslt.dll
    * minigzip.exe
    * xmlcatalog.exe
    * xmllint.exe
    * xsltproc.exe
    * zlib1.dll

<a id="manualDXL"></a>
### Manually Configuring the DXL Metadata Filters 

#### Installing Filters

If you cannot configure the filters for a repository due to any problems when running the Dora Helper script (please report bugs!), you can still manually configure your repository to run the DXL Metadata Filters.

1. 	(windows only) Make sure libxslt binaries are installed to a directory that is on your PATH environment variable
    See the section below on manually installed libxslt binaries.
2.  Install the DXL Metadata filter to the git config file
    You can do this either by issuing git config commands or by editing the .git/config file in your repository.
    To do this using git config commands run the following:

        git config --local filter.dxlmetadata.clean    xsltproc xsl\DXLClean.xsl -
        git config --local filter.dxlmetadata.smudge   xsltproc xsl\DXLSmudge.xsl - 
        git config --local filter.dxlmetadata.required true

    or to do this via editing the .git/config file, make sure it has this section

        [filter "dxlmetadata"]
          clean = xsltproc xsl/DXLClean.xsl -
          smudge = xsltproc xsl/DXLSmudge.xsl -
          required = true

3.  Create a directory called *xsl* within your repository for your XSL Stylesheets
4.  Copy the XSL Transform Stylesheets DXLClean.xsl and DXLSmudge.xsl to the newly created xsl directory
5.  Add the entry *xsl/* to your .gitignore file
6.  Configure the .gitattributes file to select which files to filter
    If you don't have one, Create a *.gitattributes* file in the root of your repository
    add the following entry for each file extension you want to filter
        *.<ext> filter=dxlmetadata text eol=lf
    Here is some entries you can use as a starting point
        *.aa filter=dxlmetadata text eol=lf  
        *.column filter=dxlmetadata text eol=lf  
        *.dcr filter=dxlmetadata text eol=lf  
        *.fa filter=dxlmetadata text eol=lf  
        *.field filter=dxlmetadata text eol=lf  
        *.folder filter=dxlmetadata text eol=lf  
        *.form filter=dxlmetadata text eol=lf  
        *.frameset filter=dxlmetadata text eol=lf  
        *.ija filter=dxlmetadata text eol=lf  
        *.ja filter=dxlmetadata text eol=lf  
        *.javalib filter=dxlmetadata text eol=lf  
        *.lsa filter=dxlmetadata text eol=lf  
        *.lsdb filter=dxlmetadata text eol=lf  
        *.metadata filter=dxlmetadata text eol=lf  
        *.navigator filter=dxlmetadata text eol=lf  
        *.outline filter=dxlmetadata text eol=lf  
        *.page filter=dxlmetadata text eol=lf  
        *.subform filter=dxlmetadata text eol=lf  
        *.view filter=dxlmetadata text eol=lf  
        AboutDocument filter=dxlmetadata text eol=lf  
        database.properties filter=dxlmetadata text eol=lf  
        IconNote filter=dxlmetadata text eol=lf  
        Shared?Actions filter=dxlmetadata text eol=lf  
        UsingDocument filter=dxlmetadata text eol=lf  

#### Manually Uninstalling Filters

1.  Remove the filter from the config file 
    You can do this either by issuing `git config` commands or by editing the .git/config file in your repository
    To do this using git config commands run the following

        git config --local --remove-section filter.dxlmetadata

    or to do this via editing the .git/config file, remove the following section manually and save

        [filter "dxlmetadata"]
          clean = xsltproc xsl/DXLClean.xsl -
          smudge = xsltproc xsl/DXLSmudge.xsl -
          required = true

2.  Remove the directory xsl/ and all the \*.xsl files
3.  Remove the xsl/ entry from your .gitignore 
4.  Remove the entries that mention `filter=dxlmetadata` from your .gitattributes file, or just delete this file if you were not using it for any other purpose

## Ideas for future

* Tell Domino Designer team to give us the option to filter this stuff for us so we don't have to :)
* Update EGit to replicate Filter functionality 
* Somebody with Java and Domino Designer Extension plugin experience could investigate if you can extend NsfToPhysical and filter at this point?
* re-write Dora as a Domino Designer Plugin instead of a Perl Script, with Eclipse based User Interface
* Helper functionality to do bulk updates on design elements, e.g. Make sure all view Column Headers are certain font.
* Install xsl files as tagged blobs in the git repo, instead of committed to a branch
* Better identification of which version of filter was used on a file
* Ability to choose where to install binaries and dora resources


## Known Issues

*   DXL Metadata filter throws an error if the source is not well formed xml. This happens during a merge conflict.
*   DXL Metadata filter throws an error if file is empty then will fail. The following design elements:
    * AppProperties/database.properties
    * Code/dbscript.lsdb
    * Resources/AboutDocument
    * Resources/UsingDocument  
    Are all blank when you create a new nsf and the filter will fail until you save them in designer for the first time since setting up source control.

### About Line Endings

You probably know that there is a difference in the way Mac Linux and Windows save line endings in files. 

* Mac and Linux/Unix use the line-feed character, LF or `\n`
* Windows uses carriage-return and line-feed, CRLF or `\r\n`

You may not know however, that even if you are using Domino Designer on Windows, it actually saves the On-Disk Project files with LF line endings.

Git has a setting called core.autocrlf which when set to true (often this is the default), will convert CRLF to LF on the way into the repository, 
and then when you check out a LF file, it will convert it back to CRLF if you are on windows. 
So, if it does this for a Design Element you can end up with CRLF line-endings when you check out even though it originally had LF.

When using the DXL Metadata filters on Windows, the design element is processed through the program `xsltproc`. The output of this program is 
given CRLF endings due to the fact that `xsltproc` actually is running as a windows program. 
You can see in the .gitattributes file that I have put a setting `text eol=lf` which tells git to convert this back to LF when commiting, 
and this also tells git to keep it as LF when it checks the file out again.

A side-effect of CRLF conversion is an annoying warning that pops up for every file that is converted:

    warning: CRLF will be replaced by LF in <filename>.
    The file will have its orignal line endings in your working directory.

If you don't want to see this warning everytime, you can set core.safecrlf to false like so:

    git config core.safecrlf false

and it will no longer warn you about CRLF conversions.

### DXL Notes

* Actionbar on a view had no *bordercolor* attribute but after re-import was given bordercolor="system"
* Frameset frame also got bordercolor attribute (i think) 
* Forms don't like it when Background element is indented (dxl.parse error text node), thus the need to 'deflate' on checkout
* Forms without action bar get a default set of system actions, maybe for views too?

