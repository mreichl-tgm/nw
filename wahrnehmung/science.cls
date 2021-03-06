\ProvidesClass{science}

% # Options
% ## Use landscape orientation
\newif\iflandscape\landscapefalse
\DeclareOption{landscape}{\landscapetrue\PassOptionsToClass{landscape}{article}}

% ## Do not print title page
\newif\iftitle\titletrue
\DeclareOption{notitle}{\titlefalse}

% ## Do not print table of contents
\newif\iftoc\toctrue
\DeclareOption{notoc}{\tocfalse}

% ## Use default latex fonts
\newif\iffonts\fontstrue
\DeclareOption{nofonts}{\fontsfalse}

% ## Do not except glossaries
\newif\ifglo\glotrue
\DeclareOption{noglo}{\glofalse}

% ## Do not except bibliography
\newif\ifbib\bibtrue
\DeclareOption{nobib}{\bibfalse}

% ## Skip line instead of indent after blank line
\newif\ifparskip\parskipfalse
\DeclareOption{parskip}{\parskiptrue}

% ## Use minted package
\newif\ifminted\mintedfalse
\DeclareOption{minted}{\mintedtrue}

% ## Use natbib package
\newif\ifnatbib\natbibfalse
\DeclareOption{natbib}{\bibtrue\natbibtrue}

% # Pass options
% \DeclareOption*{\PassOptionsToClass{\CurrentOption}{article}}
\ProcessOptions \relax
% ## Load article class
\IfFileExists{crimson.sty}{
    \LoadClass[a4paper,11pt]{article}   % Crimson
}{  \LoadClass[a4paper,10pt]{article}}  % Default

% # Packages
% ## Require landscape geometry
\iflandscape\RequirePackage[landscape,margin=1in]{geometry}
\else\RequirePackage{a4wide}\fi

% ## Fonts
\iffonts
    \IfFileExists{crimson.sty}{\RequirePackage{crimson}}{}
    \IfFileExists{crimson.sty}{\RequirePackage{inconsolata}}{}
\fi

\RequirePackage[T1]{fontenc}
\RequirePackage[utf8]{inputenc}
\RequirePackage[ngerman]{babel}
\RequirePackage{ccicons, amssymb, mathtools, siunitx}

\RequirePackage{fancyhdr, float, multicol, multirow, titling}
\RequirePackage[marginal, norule, perpage]{footmisc}
\RequirePackage[dvipsnames]{xcolor}
\RequirePackage{hyperref, url, pageslts}
\RequirePackage{outlines, enumitem}
\RequirePackage{booktabs, tabularx}
\RequirePackage{graphicx, subcaption, wrapfig}
\RequirePackage[font=small]{caption}
\RequirePackage{accsupp}    % [1]

% ## Count list items for lists
\RequirePackage[figure,table,listing]{totalcount}

% ## Skip lines instead of indents after a blank line
\ifparskip\RequirePackage[parfill]{parskip}\fi

% ## Glossaries
\ifglo
    \RequirePackage[acronym, xindy, toc, nohypertypes={acronym,notation}]{glossaries}
    \makeglossaries
\fi

% ## Bibliography
\ifbib  \ifnatbib\RequirePackage{natbib}\bibliographystyle{ieeetr}  % Choose backend
        \else\RequirePackage[backend=bibtex, style=numeric]{biblatex}\fi\fi

% ## Colors
% https://coolors.co/05668d-028090-00a896-02c39a-f0f3bd
\definecolor{MyLightGray}{RGB}{252,252,252}
\definecolor{MyBlue}{RGB}{5,102,141}
\definecolor{MyGreen}{RGB}{0,168,150}
\definecolor{MyBrown}{RGB}{143,89,3}
\definecolor{MyOrange}{RGB}{213,111,30}

% ## Require and configure minted or listings
\ifminted
    \RequirePackage[newfloat]{minted}
    \floatplacement{listing}{H} % Override default listing float
    \usemintedstyle{tango}      % autumn, rainbow_dash, tango, trac
    \setminted{ fontsize=\small,
                linenos=true,
                breakanywhere=true,
                breaklines=true,
                framesep=2mm,
                tabsize=4}

    % ## [1] Avoid copying line numbers on listings
    \renewcommand\theFancyVerbLine{
        \BeginAccSupp{method=escape,ActualText={}}
        {\rmfamily\tiny\arabic{FancyVerbLine}}
        \EndAccSupp{}
    }
    \SetupFloatingEnvironment{listing}{listname=Auflistungsverzeichnis,name=Auflistung}
\else
    \RequirePackage{listing}                % Already defined by minted itself
    \RequirePackage{listings}
    \RequirePackage{listingsutf8}           % UTF-8 Input support for listings
    \IfFileExists{.lst.tex}{\input{.lst}}{} % Load lstlistings config if exists
\fi

\RequirePackage{csquotes}	% csquotes should be loaded after fvextra, to avoid a warning from the lineno package

% # Variables
\newcommand\@mysubtitle{}   % A subtitle
\newcommand\mysubtitle[1]{\renewcommand\@mysubtitle{#1}}

\newcommand\@mysubject{}    % A subject
\newcommand\mysubject[1]{\renewcommand\@mysubject{#1}}

% # Package configuration
\newcolumntype{Y}{p{.5\textwidth}}  % TabularX

\floatplacement{table}{H}   % Override default table float
\floatplacement{figure}{H}  % Override default figure float

\hypersetup{breaklinks=true, colorlinks=true,   % Hyperlinks
            linkcolor=MyBlue, urlcolor=MyBlue, citecolor=MyBlue}

\sisetup{locale=DE, per-mode=symbol}

% ## Footnotes
\def\arraystretch{1.5}
\renewcommand\thefootnote{\Roman{footnote}}

% ## Header
\pagestyle{fancy}\fancyhf{}

\makeatletter
\fancyhead[L]{\small \thetitle}
\fancyhead[C]{\small \@mysubject}
\fancyhead[R]{\small \@date}
\fancyfoot[L]{\small \theauthor ~ {\footnotesize\ccby}}
\fancyfoot[R]{\small \thepage~/~{\lastpageref*{VeryLastPage}}}
\makeatother

\renewcommand{\footrulewidth}{\headrulewidth}


% ## Add glossary / bibliography entries if they exist
\IfFileExists{glossaries.tex}{\input{glossaries}}{}
\IfFileExists{bibliography.bib}{\addbibresource{bibliography}}{}

% # Makros
% ## Title
\makeatletter
\renewcommand\@maketitle{
    \vskip 1cm                      % Minimum margin
    \iflandscape\else\vskip 1cm\fi  % Do not increase margin on landscape
    % Content
    \begin{center}
        \if\relax\@mysubject\relax\else     {\Large\@mysubject}     ~\\\vspace{0.5em}\fi
        {\Huge\textbf\thetitle}                                     ~\\\vspace{1em}
        \if\relax\@mysubtitle\relax\else    {\LARGE\@mysubtitle}\fi ~\\\vspace{2em}
        \theauthor                                                  ~\\\vspace{0.5em}
        \@date
    \end{center}
    \vskip 1cm  % Minimum margin
}\makeatother

% ## Basic centered figure
% \makefig{path}{width}{caption}{label}
\newcommand\makefig[4]{
    \begin{figure}[H]
        \centering
        \includegraphics[#2]{#1}
        \ifx\relax#3\relax
        \else\caption{#3}\fi
        \ifx\relax#4\relax
        \else\label{#4}\fi
    \end{figure}
}

% ## Math variable declaration
\newenvironment{vardef}{
	\center \small
	\begin{tabular}{l l l}
}{\end{tabular} \normalsize \endcenter}
\newcommand\addvardef[2]{
    {#1} & \dots & {#2}\\
}


% ## Code environments
% Extra % is used as a linefix for the code interpreter
\ifminted   % Minted goes here
    \newcommand\setcode[1]{\setminted{#1}}  % Code settings
    \newenvironment{code}[2][]{             % Code environment
        \VerbatimEnvironment%
        \begin{minted}[#1]{#2}%
    }{  \end{minted}}

    \newcommand\codein{\mintinline}         % Inline code (alias)
    \newcommand\codeinline{\codein}         % Alias for @kevsoft

    \newcommand\inputcode{\inputminted}     % Input code (alias)

    \newcommand\codeline[3][]{\mint[#1]{#2}\relax#3\relax}  % Single line of code
\else       % Listings goes here
    \newcommand\setcode[1]{\lstset{#1}}                         % Code settings
    \lstnewenvironment{code}[2][]{\lstset{language={#2},#1}}{}  % Code environment

    \newcommand\codein[3][]{\lstinline[language=#2,#1]\relax#3\relax}   % Inline code
    \newcommand\codeinline{\codein}                                     % Alias for @kevsoft
    \newcommand\inputcode[3][]{\lstinputlisting[language=#2,#1]{\detokenize{#3}}}   % Input code

    \newcommand\codeline[3][]{\begin{flushleft}
        \lstinline[language=#2,#1]\relax#3\relax            % Single line of code
    \end{flushleft}}
\fi

% ## Add common commands at the beginning of the document
\AtBeginDocument{
    \pagenumbering{arabic}                      % Required by pageslts
    \iftitle\maketitle\thispagestyle{empty}\fi  % Titlepage
    \iftoc\tableofcontents\glsresetall\fi       % Table of contents
}

% ## Add common commands at the end of the document
\AtEndDocument{
    \ifglo  % Print glossaries
        % \glsaddall                % Also list unused glossary entries
        \printglossaries\fi         % List used glossary entries

    \ifbib  % Print bibliography
        \ifnatbib\bibliography{bib} % List bibliography entries with natbib
        \else\printbibliography[heading=bibintoc, title={Literaturverzeichnis}]\fi\fi
    % List lists if not empty
    \iftotalfigures\listoffigures\fi
    \iftotaltables\listoftables\fi
    \iftotallistings\listoflistings\fi
}
