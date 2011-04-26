%%
%% This is file `thesis.cls',
%%
%% which is made bsed on class 'report.cls'
%%
%% AUTHOR: Pedro Tomás
%% MODIFIED BY: Rui Santos Cruz on the 4th August 2009

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{thesis}[2007/07/27]

\typeout{}
\typeout{----------------------------------------------------------------------}
\typeout{ +---+ Thesis Style (thesis.cls)                                         }
\typeout{ +---+      Version 1.0, January 2006                               }
\typeout{ +---+      Version 1.1, July 2007                                      }
\typeout{ +---+      Version 2.0, July 2007 (new IST stylesheet)}
\typeout{ +---+      Version 3.0, August 2009                                }
\typeout{ +---+  for Instituto Superior Tecnico (IST),                   }
\typeout{ +---+  Universidade Ténica de Lisboa                         }
\typeout{ * Modified from 'report.cls'                                              }
\typeout{ * Created to write Dissertations                                    }
\typeout{ * Conforms with IST Master Degree format                     }
\typeout{ * Should conform with IST PhD Degree format (not verified)   }
\typeout{                                                              }
\typeout{ AUTHOR: Pedro Tomás                                          }
\typeout{ MODIFIED BY: Rui Santos Cruz on the 4th August 2009 }
\typeout{--------------------------------------------------------------}
\typeout{}

% Certain options are not handled here but are passed on to report.cls
% by \PassOptionToClass.

\DeclareOption{fleqn}{ \PassOptionsToClass{fleqn}{report} }
\DeclareOption{leqno}{ \PassOptionsToClass{leqno}{report} }
\DeclareOption{openbib}{ \PassOptionsToClass{openbib}{report} }
\DeclareOption{draft}{ \PassOptionsToClass{draft}{report} }
\DeclareOption{final}{ \PassOptionsToClass{final}{report} }
\DeclareOption{openright}{ \PassOptionsToClass{openright}{report} }
\DeclareOption{openany}{ \PassOptionsToClass{openany}{report} }
\DeclareOption{10pt}{ \PassOptionsToClass{10pt}{report} }
\DeclareOption{11pt}{ \PassOptionsToClass{11pt}{report} }
\DeclareOption{12pt}{ \PassOptionsToClass{12pt}{report} }
\DeclareOption{oneside}{ \PassOptionsToClass{oneside}{report} }
\DeclareOption{twoside}{ \PassOptionsToClass{twoside}{report} }
\DeclareOption{a4paper}{ \PassOptionsToClass{a4paper}{report} }
\DeclareOption{a5paper}{ \PassOptionsToClass{a5paper}{report} }
\DeclareOption{b5paper}{ \PassOptionsToClass{b5paper}{report} }
\DeclareOption{letterpaper}{ \PassOptionsToClass{letterpaper}{report} }
\DeclareOption{executivepaper}{ \PassOptionsToClass{executivepaper}{report} }
\DeclareOption{letterpaper}{ \PassOptionsToClass{letterpaper}{report} }
\DeclareOption{letterpaper}{ \PassOptionsToClass{letterpaper}{report} }
\DeclareOption{letterpaper}{ \PassOptionsToClass{letterpaper}{report} }

% Invalid options - normally used in report.cls and others, but not here:

\DeclareOption{titlepage}
   {\ClassWarning{thesis}{Title page always generated. Option ignored.}}
\DeclareOption{notitlepage}
   {\ClassWarning{thesis}{Option 'notitlepage' not available for thesis.}}
\DeclareOption{twocolumn}
   {\ClassWarning{thesis}{Option 'twocolumn' not available for thesis.}}
\DeclareOption{landscape}
   {\ClassWarning{thesis}{Option 'landscape' not available for thesis.}}
\DeclareOption{onecolumn}
   {\ClassWarning{thesis}{Option 'onecolumn' superfluous.  Ignored.}}

%%%%%%%%%%% CUSTOM OPTIONS:
% Options for no decimal numbering, or decimal number nested over 3 deep:
\newif\if@AllHeadings
\newif\if@NumberStdHeadings
\newif\if@PerChptrNumbering
\newif\if@emphisbold
\newif\if@boldhead
\newif\if@fixedHeadSz
\newif\if@headSizeTwelvePt
\newif\if@ChapterDefault
\newif\if@SectionDefault
\newif\if@SubSectionDefault
\newif\if@OtherHeadingDefault
\newif\if@centerChapter
\newif\if@centerSection
\newif\if@inlineSubSubSection
\newif\if@numberSubSubSection
\newif\if@chapterCaps
\@AllHeadingsfalse
\@NumberStdHeadingstrue
\@PerChptrNumberingtrue
\@emphisboldtrue
\@boldheadtrue
\@fixedHeadSzfalse
\@centerChaptertrue
\@centerSectionfalse
\@inlineSubSubSectionfalse
\@numberSubSubSectiontrue
\@chapterCapsfalse
\@headSizeTwelvePttrue
\DeclareOption{consecutivenumbering}{ \@PerChptrNumberingfalse }
\DeclareOption{inlineh4}{ \@inlineSubSubSectiontrue }
\DeclareOption{nonumh4}{ \@numberSubSubSectionfalse }
\DeclareOption{centerh1}{ \@centerSectiontrue }
\DeclareOption{chapleft}{ \@centerSectiontrue }
\DeclareOption{chapup}{ \@chapterCapstrue }
\DeclareOption{emph2underline}{ \@emphisboldfalse }
\DeclareOption{plainhead}{ \@boldheadfalse }
\DeclareOption{fixedheadsize}{ \@fixedHeadSztrue }
\DeclareOption{varheadsize}{\@headSizeTwelvePtfalse}% Hidden option.  Don't use.
\DeclareOption{numberchapteronly}{
	\@PerChptrNumberingfalse\@NumberStdHeadingsfalse\@AllHeadingsfalse
	\@centerChaptertrue\@centerSectiontrue
	\@inlineSubSubSectiontrue\@numberSubSubSectionfalse }
\DeclareOption{allheadings}{
	\@PerChptrNumberingtrue\@NumberStdHeadingstrue\@AllHeadingstrue
	\@centerChaptertrue\@centerSectionfalse
	\@inlineSubSubSectionfalse\@numberSubSubSectiontrue}
\DeclareOption{typewriterstyle}{ \@emphisboldfalse
	\@PerChptrNumberingfalse\@NumberStdHeadingsfalse\@AllHeadingsfalse
	\@centerChaptertrue\@centerSectiontrue\@chapterCapstrue
	\@inlineSubSubSectiontrue\@numberSubSubSectionfalse
	\@boldheadfalse\@fixedHeadSztrue}
\DeclareOption{modernstyle}{ \@emphisboldtrue
	\@PerChptrNumberingtrue\@NumberStdHeadingstrue\@AllHeadingsfalse
	\@centerChaptertrue\@centerSectionfalse\@chapterCapsfalse
	\@inlineSubSubSectiontrue\@numberSubSubSectionfalse
	\@boldheadtrue\@fixedHeadSzfalse}
\DeclareOption{defaultstyle}{ \@emphisboldtrue
	\@PerChptrNumberingtrue\@NumberStdHeadingstrue\@AllHeadingsfalse
	\@centerChaptertrue\@centerSectionfalse\@chapterCapsfalse
	\@inlineSubSubSectionfalse\@numberSubSubSectiontrue
	\@boldheadtrue\@fixedHeadSzfalse}
% Declare font options
\DeclareOption{Helvetica}{\renewcommand{\rmdefault}{phv}}
\DeclareOption{AvantGarde}{\renewcommand{\rmdefault}{pag}}

\DeclareOption{master}
   {% DEFINE COMMAND FOR: thesistype
   \newcommand*{\thesistype}[1]{\th@StoreIn{\th@thesistype}{#1}}
   \newcommand*{\th@thesistype}
        {Disserta\c{c}\~{a}o para obten\c{c}\~{a}o do Grau de Mestre em}
    }
    
\DeclareOption{phd}
   {% DEFINE COMMAND FOR: thesistype
   \newcommand*{\thesistype}[1]{\th@StoreIn{\th@thesistype}{#1}}
   \newcommand*{\th@thesistype}
        {Disserta\c{c}\~{a}o para obten\c{c}\~{a}o do Grau de Doutor em}
    }

% Now we load the report class with certain options by default.  It
% will process any other options specified.  Then, we process the
% options for this class file.  Lastly, we load in the font option
% file for the given font size.

\ProcessOptions
\LoadClass[a4paper,twoside,onecolumn]{report}

% Other required LaTeX2e packages: if your computer doesn't already
% have these, you can copy them to your own directory (URL above):
\RequirePackage{indentfirst}
\RequirePackage{ifthen}
\RequirePackage[ULforem,normalbf]{ulem}
\RequirePackage{graphicx}
\RequirePackage{epsf}
\RequirePackage[absolute]{textpos}
\RequirePackage{helvet}

%%%%%% SPECIAL INTERNAL COMMANDS.  Needed by later routines.

% Create a command to be used for default arguments.
\newcommand*{\th@DefArg}{aWfdRvV11f66GL00K5}

% Now create a command to check for the default argument, and call the
% command [in the first arg] appropriately.  Used for section heading
% commands.

\newcommand{\th@ExecChkOptArg}[3]{
\ifthenelse{\equal{\th@DefArg}{#2}}{
	#1{#3}
	}{
	#1[#2]{#3}}
}
\newcommand{\th@StoreIn}[2]{ \gdef#1{#2} }

\newenvironment{setfont}[1]{\fontsize{#1}{#1}\selectfont}{}

% Define titlepage commands

% DEFINE COMMAND FOR: univlogo -> UNIVERISTY LOGO
\newcommand*{\univlogo}[3]{\th@StoreIn{\th@univlogo}{#3} \th@StoreIn{\th@univlogopsx}{#1} \th@StoreIn{\th@univlogopsy}{#2}}
\newcommand*{\th@univlogo}{
	\ClassError{thesis}{
		You must specify the university image logo}
	{Use the \protect\univlogo{} command in the preamble.}
}
\newcommand*{\th@univlogopsx}{2}
\newcommand*{\th@univlogopsy}{2}

% DEFINE COMMAND FOR: thesislogo -> THESIS LOGO
\newcommand*{\thesislogo}[3]{\th@StoreIn{\th@thesislogo}{#3} \th@StoreIn{\th@thesislogopsx}{#1} \th@StoreIn{\th@thesislogopsy}{#2}}
\newcommand*{\th@thesislogo}{\relax}
\newcommand*{\th@thesislogopsx}{2}
\newcommand*{\th@thesislogopsy}{2}

% DEFINE COMMAND FOR: degree -> DEGREE OF AUTHOR
\newcommand*{\degree}[1]{\th@StoreIn{\th@degree}{#1}}
\newcommand*{\th@degree}{ % command is required
	\ClassError{thesis}{
		You must specify the degree you are applying}
	{Use the \protect\degree{} command in the preamble.}
}

% DEFINE COMMAND FOR: otherdegree -> OTHER DEGREE OF AUTHOR
\newcommand*{\otherdegree}[1]{\th@StoreIn{\th@otherdegree}{#1}}
\newcommand*{\th@otherdegree}{\relax} % command is optional

% DEFINE COMMAND FOR: supervisor -> NAME OF THESIS SCIENTIFIC SUPERVISOR
\newcommand*{\supervisor}[1]{\th@StoreIn{\th@supervisor}{#1}}
\newcommand*{\th@supervisor}{ % command is required
	\ClassError{thesis}{
		You must specify the scientific supervisor}
	{Use the \protect\supervisor{} command in the preamble.}
}
% DEFINE COMMAND FOR: othersupervisorone -> NAME OF THESIS SCIENTIFIC CO-SUPERVISOR
\newcommand*{\othersupervisorone}[1]{\th@StoreIn{\th@othersupervisorone}{#1}}
\newcommand*{\th@othersupervisorone}{\relax} % command is optional

% DEFINE COMMAND FOR: othersupervisortwo -> NAME OF THESIS SCIENTIFIC CO-SUPERVISOR
\newcommand*{\othersupervisortwo}[1]{\th@StoreIn{\th@othersupervisortwo}{#1}}
\newcommand*{\th@othersupervisortwo}{\relax} % command is optional

% President of Juri
\newcommand*{\presidentofjury}[1]{\th@StoreIn{\th@presidentofjury}{#1}}
\newcommand*{\th@presidentofjury}{\relax} % command is optional
% Vogal 1
\newcommand*{\vogalone}[1]{\th@StoreIn{\th@vogalofjuryone}{#1}}
\newcommand*{\th@vogalofjuryone}{\relax} % command is optional
% Vogal 2
\newcommand*{\vogaltwo}[1]{\th@StoreIn{\th@vogalofjurytwo}{#1}}
\newcommand*{\th@vogalofjurytwo}{\relax} % command is optional
% Vogal 3
\newcommand*{\vogalthree}[1]{\th@StoreIn{\th@vogalofjurythree}{#1}}
\newcommand*{\th@vogalofjurythree}{\relax} % command is optional
% Vogal 4
\newcommand*{\vogalfour}[1]{\th@StoreIn{\th@vogalofjuryfour}{#1}}
\newcommand*{\th@vogalofjuryfour}{\relax} % command is optional
% Vogal 5
\newcommand*{\vogalfive}[1]{\th@StoreIn{\th@vogalofjuryfive}{#1}}
\newcommand*{\th@vogalofjuryfive}{\relax} % command is optional

% DEFINE COMMAND FOR: finalthesis
\newcommand*{\finalthesis}[1]{\th@StoreIn{\th@finalthesis}{#1}}
\newcommand*{\th@finalthesis}{true}

% DEFINE COMMAND FOR: subtitle
\newcommand*{\subtitle}[1]{\th@StoreIn{\th@subtitle}{#1}}
\newcommand*{\th@subtitle}{\relax} % command is optional


\setlength{\headheight}{14.5pt}
\setlength\oddsidemargin{2cm}
\setlength\evensidemargin{2cm}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% CREATING A TITLE PAGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\renewcommand\maketitle{
  \begin{titlepage}
    \baselineskip=24pt 
    % printing UNIVERSITY LOGO
    \textblockorigin{-18pt}{-2pt}
    \begin{textblock*}{10cm}(\th@univlogopsx,\th@univlogopsy)
    \includegraphics[width=9cm]{\th@univlogo}
    \end{textblock*}
    % printing THESIS LOGO
    \ifthenelse{\equal{\th@thesislogo}{\relax}}{\relax}{
       \textblockorigin{-18pt}{-2pt}
       \begin{textblock*}{17cm}(\th@thesislogopsx,\th@thesislogopsy)
       \centering
       \includegraphics{\th@thesislogo}
       \end{textblock*}
    }
    \vspace*{8cm}
    {
        % printing thesis TITLE
        \centering
        \begin{setfont}{16}
        \bfseries\@title
        \end{setfont}
        \\ 
        % printing thesis SUB-TITLE (if any)
        \ifthenelse{\equal{\th@subtitle}{\relax}}{\relax}{
           \centering
           \begin{setfont}{14}
           \th@subtitle
           \end{setfont}
           \\
        }
        \vfill
        % printing AUTHOR NAME AND CURRENT DEGREE (IF ANY)
        \centering
        \begin{setfont}{14}
        \bfseries\@author
        \end{setfont}
        \\ 
        \ifthenelse{\equal{\th@otherdegree}{\relax}}{\relax}{
           \centering
           \begin{setfont}{12}
           (\th@otherdegree)
           \end{setfont}
           \\
        }
        \vfill
        % printing applying DEGREE
        \centering
        \begin{setfont}{16}
		\th@thesistype\\
        \bfseries\th@degree
        \end{setfont}
        \\ 
        \vfill
        % printing JURI
        \centering
        \begin{setfont}{14}
           \renewcommand{\arraystretch}{1.2}
           \begin{tabular}{r@{~}l l}
               \multicolumn{3}{c}{\bfseries\textbf{J\'uri}} \\
               \ifthenelse{\equal{\th@presidentofjury}{\relax}}{\relax}{& Presidente: & \th@presidentofjury \\}
               & Orientador: & \th@supervisor \\
               \ifthenelse{\equal{\th@othersupervisorone}{\relax}}{\relax}{& Co-Orientador: &\th@othersupervisorone \\}
               \ifthenelse{\equal{\th@othersupervisortwo}{\relax}}{\relax}{&  &\th@othersupervisortwo \\}
               \ifthenelse{\equal{\th@vogalofjuryone}{\relax}}{\relax}{& Vogais: & \th@vogalofjuryone \\} 
               \ifthenelse{\equal{\th@vogalofjurytwo}{\relax}}{\relax}{&         & \th@vogalofjurytwo \\} 
               \ifthenelse{\equal{\th@vogalofjurythree}{\relax}}{\relax}{&       & \th@vogalofjurythree \\} 
               \ifthenelse{\equal{\th@vogalofjuryfour}{\relax}}{\relax}{&        & \th@vogalofjuryfour \\} 
               \ifthenelse{\equal{\th@vogalofjuryfive}{\relax}}{\relax}{&        & \th@vogalofjuryfive \\} 
           \end{tabular}
        \end{setfont}
        \\ 
        \vfil
        % printing DATE
        \centering
        \begin{setfont}{14}
        \bfseries\@date
        \end{setfont}
        \\ 
    }
  \end{titlepage}
  \setcounter{footnote}{0}
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@author\@empty
  \global\let\@date\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
  \clearpage
  \thispagestyle{empty}
  \cleardoublepage
}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% REDEFINE ABSTRACT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
\newenvironment{keywords}{\vspace*{3cm}
    {\parindent \z@ \raggedright \normalfont
        \hspace*{0\p@}\huge\bfseries Keywords
        \par\nobreak
        \vspace*{1cm}
    }
}

\renewenvironment{abstract}{
	\pdfbookmark{Abstract}{Abstract}
	\chapter*{Abstract}}

\newenvironment{acknowledgments}{\vspace*{3cm}
    {\parindent \z@ \raggedright \normalfont
        \hspace*{0\p@}\huge\bfseries Acknowledgments
        \par\nobreak
        \vspace*{1cm}
    }
}{
	\clearpage
	\thispagestyle{empty}
	\cleardoublepage
}

\newenvironment{resumo}{
	\pdfbookmark{Resumo}{Resumo}
	\chapter*{Resumo}}

\newenvironment{palavraschave}{\vspace*{3cm}
    {\parindent \z@ \raggedright \normalfont
        \hspace*{0\p@}\huge\bfseries Palavras Chave
        \par\nobreak
        \vspace*{1cm}
    }
}

\RequirePackage{amsmath, amsthm, amssymb}
% \renewenvironment{proof}[1][\proofname]{\par
%   \pushQED{\qed}%
%   \normalfont \topsep6\p@\@plus6\p@\relax
%   \trivlist
%   \leftskip20\p@\item[\hskip\labelsep
%         \itshape
%     #1\@addpunct{.}]\rightskip20\p@\ignorespaces
% }{%
%   \popQED\endtrivlist\@endpefalse
% }

\newcommand{\tblc}[1]{\makebox[\linewidth][c]{#1}}

\let\@afterindentfalse\@afterindenttrue
\@afterindenttrue

\endinput
%%
%% End of file `report.cls'.
