%% (c) 2014 Benjamin Steinwender KAI GmbH
%% 
%% This LaTeX class provides the style for a KAI software documentation LaTeX
%% project.
%% 

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{bib/kai_documentation}[2015/11/25 KAI Documentation]

%% scrreprt options
\DeclareOption{11pt}{
  \PassOptionsToClass{\CurrentOption}{scrreprt}
}

%% Fallback
\DeclareOption*{
  \ClassWarning{kai_documentation}{Unknown option '\CurrentOption'}
}

%% Execute default options
\ExecuteOptions{11pt}

%% Process given options
\ProcessOptions\relax

%% Load base
\LoadClass[
	a4paper,
	toc=bib,
	toc=listof,
]{scrreprt}


%% Load additional packages and commands. ==============================

% encoding
\RequirePackage[utf8]{inputenc}
\RequirePackage[T1]{fontenc}

% font
%\usepackage{fourier}
\RequirePackage{lmodern}

\RequirePackage[
	usenames,
	dvipsnames,
	svgnames,
	table,
]{xcolor}

\RequirePackage{longtable}
\RequirePackage{tabularx}

\RequirePackage[english]{babel}
\RequirePackage{cite}

\RequirePackage[bf,ruled]{caption}
\RequirePackage[pdftex]{graphicx}
\RequirePackage{wrapfig}
\RequirePackage{subcaption}

\renewcommand{\subfigureautorefname}{\figureautorefname}

\graphicspath{ {./pictures/} }

\RequirePackage[
	version-1-compatibility,
	alsoload=binary,
	binary-units,
]{siunitx}
\sisetup{
%	inter-unit-product = $\cdot$,
	list-final-separator = { \translate{and} },
	list-pair-separator = { \translate{and} },
	range-phrase = { \translate{to (numerical range)} },
}
\RequirePackage{microtype}

\RequirePackage{quotchap}
\RequirePackage{lettrine}

%	for warning box
\RequirePackage[tikz]{bclogo}

\newenvironment{info}{\begin{bclogo}[logo=\bcinfo,noborder=true,couleurBarre=orange!70!yellow!100,barre=snake,tailleOndu=3.5]{Information}}{\end{bclogo}}
\newenvironment{instruction}{\begin{bclogo}[logo=\bcbook,noborder=true,couleurBarre=green!100,barre=snake,tailleOndu=3.5]{Instructions}}{\end{bclogo}}
\newenvironment{warning}{\begin{bclogo}[logo=\bcattention,noborder=true,couleurBarre=red!90,barre=snake,tailleOndu=3.5]{Warning}}{\end{bclogo}}

\RequirePackage{enumitem}
\RequirePackage{datetime}

\RequirePackage{makeidx}

% \RequirePackage{listings}	%	listings is not compliant to koma-script :(
% \lstdefinestyle{customc}{
% 	belowcaptionskip=1\baselineskip,
% 	breaklines=true,
% 	frame=L,
% 	xleftmargin=\parindent,
% 	language=C,
% 	showstringspaces=false,
% 	basicstyle=\footnotesize\ttfamily,
% 	keywordstyle=\bfseries\color{green!40!black},
% 	commentstyle=\itshape\color{purple!40!black},
% 	identifierstyle=\color{blue},
% 	stringstyle=\color{orange},
% }

\RequirePackage[
	unicode=true,		%	non-Latin characters in Acrobat’s bookmarks
	hypertexnames=true,	%	fixes ``destination with the same identifier'' warning
	bookmarks=true,		%	show bookmarks bar?
	bookmarksnumbered=true,
	bookmarksopen=false,
%	breaklinks=false,	%	set true to word wrap long lines in listof* properly
	pdfborder={0 0 0},
	pagebackref=true,	%	true|false
	colorlinks=true,	%	true: colored links; false: boxes around the link
    linkcolor=red,		%	color of internal links (change box color with linkbordercolor)
    citecolor=green,	%	color of links to bibliography
    filecolor=magenta,	%	color of file links
    urlcolor=cyan,		%	color of external links
]{hyperref}
\hypersetup{
%	pdftoolbar=true,        % show Acrobat’s toolbar?
%	pdfmenubar=true,        % show Acrobat’s menu?
    pdffitwindow=true,     % window fit to page when opened
    pdfstartview={FitH},    % fits the width of the page to the window
%	pdfsubject={Subject},   % subject of the document
%	pdfcreator={Creator},   % creator of the document
%	pdfproducer={Producer}, % producer of the document
%	pdfkeywords={keyword1, key2, key3}, % list of keywords
    pdfnewwindow=true,      % links in new PDF window
	pdfauthor={steinwender},
}

%	glossaries must be loaded after hyperref
\RequirePackage[
	toc,			%	include in table of contents
	nonumberlist,	%	suppress the location list
%	nogroupskip,	%	suppress alphabetic grouping of entries
	nopostdot,		%	suppress terminating dot
	acronym,		%	add acronyms
]{glossaries}
\newglossary[slg]{symbolslist}{syi}{syg}{Symbols}

%	cleveref must be loaded after hyperref
\RequirePackage[
	capitalize,
	nameinlink,
	noabbrev,
]{cleveref}

%% header style
\RequirePackage[automark,headsepline]{scrlayer-scrpage}
\clearpairofpagestyles
\cfoot[\pagemark]{\pagemark}
\lehead{\headmark}
\rohead{\headmark}
\pagestyle{scrheadings}


% paragraph settings
%\parindent=0cm
%\setlength{\parskip}{3ex plus 2ex minus 2ex}
\linespread{1.1}

\makeglossaries
\makeindex


\endinput
