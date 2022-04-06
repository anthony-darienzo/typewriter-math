\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{typewriter-math}[2022/04/05 Typewriter math class]

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{memoir}}
\ProcessOptions\relax

\LoadClass[ms]{memoir}

% Customize memoir class
\chapterstyle{dash}

\RequirePackage{fancyhdr}
\renewcommand{\headrulewidth}{0pt}
\RequirePackage{etoolbox}
\RequirePackage{graphicx}
\RequirePackage{tikz,tikz-cd}
\usetikzlibrary{%
	shapes, arrows, calc, positioning, shapes.geometric,%
	decorations.pathreplacing, decorations.markings, mindmap,%
	decorations, patterns, decorations.pathmorphing%
}%
\RequirePackage{mathtools}
\RequirePackage{amsthm,amsmath}
\RequirePackage{faktor}
\RequirePackage{stackengine}

\RequirePackage{hyperref}
\RequirePackage[shortcuts]{extdash}

\RequirePackage{xcolor}
\RequirePackage{tcolorbox}

% Add this package to count the number of exercises in the document.
\RequirePackage{totcount}

\def\@subtitle{}%
\def\subtitle#1{\gdef\@subtitle{#1}}

% tikz magic from:
% https://tex.stackexchange.com/questions/39296/simulating-hand-drawn-lines

\pgfset{
	/pgf/decoration/randomness/.initial=2,
	/pgf/decoration/wavelength/.initial=100
}
\pgfdeclaredecoration{sketch}{init}{
  \state{init}[width=0pt,next state=draw,persistent precomputation={
    \pgfmathsetmacro\pgf@lib@dec@sketch@t0
  }]{}
  \state{draw}[width=\pgfdecorationsegmentlength,
  auto corner on length=\pgfdecorationsegmentlength,
  persistent precomputation={
    \pgfmathsetmacro\pgf@lib@dec@sketch@t{mod(\pgf@lib@dec@sketch@t+pow(\pgfkeysvalueof{/pgf/decoration/randomness},rand),\pgfkeysvalueof{/pgf/decoration/wavelength})}
  }]{
    \pgfmathparse{sin(2*\pgf@lib@dec@sketch@t*pi/\pgfkeysvalueof{/pgf/decoration/wavelength} r)}
    \pgfpathlineto{\pgfqpoint{\pgfdecorationsegmentlength}{\pgfmathresult\pgfdecorationsegmentamplitude}}
  }
  \state{final}{}
}
\tikzset{
	xkcd/.style={decorate,decoration={sketch,segment length=0.5pt,amplitude=0.5pt}}
}
\tikzcdset{
	arrows=xkcd
}
\pgfmathsetseed{1}
% End tikz magic

\AtEndPreamble{%
	\pagestyle{fancy}
	\rhead{\@subtitle}
	\lhead{\@title}
	\cfoot{\thepage}
	\RequirePackage[upright]{fourier}
	\RequirePackage[frenchmath, italic,nosmalldelims]{mathastext}
}%

% Now useful style macros
\def\sectionrule{%
	\fancybreak{* * * * *}
}%

\newenvironment{indented}{%
  \par%
  \medskip
  \leftskip=4em\rightskip=2em%
  \noindent\ignorespaces}{%
  \par\medskip
}

\newenvironment{warning_box*}{%
	\fancybreak{***}
	\begin{indented}
}%
{%
	\end{indented}%
	\fancybreak{***}
}

% ABBREVIATIONS
% For declaring objects in a category (in a Haskell-like manner)
\providecommand{\catin}{\mathrel{::}}

\providecommand{\ul}[1]{\underline{#1}}
\providecommand{\hw}[1]{\widehat{#1}}
\providecommand{\bvec}[1]{\overrightarrow{#1}}

% Groupings macros.
\providecommand{\fb}[1]{{\left[#1\right]}}
\providecommand{\pwrap}[1]{{\left(#1\right)}}
\providecommand{\bwrap}[1]{{\left\{#1\right\}}}
\providecommand{\abs}[1]{{\left|#1\right|}}
\providecommand{\norm}[1]{{\left\|#1\right\|}}
\providecommand{\brak}[1]{{\left\langle#1\right\rangle}}

\providecommand\restr[2]{{% we make the whole thing an ordinary symbol
   \left.\kern-\nulldelimiterspace % automatically resize the bar with \right
    #1 % the function
    \vphantom{\big| } % pretend it's a little taller at normal size
    \right|_{#2} % this is the delimiter
}}

\providecommand{\eqdef}{\overset{\normalfont{\text{def}}}{=}}
\providecommand{\equivdef}{\overset{\normalfont{\text{def}}}{\equiv}}

\renewcommand{\leq}{\leqslant}
\renewcommand{\geq}{\geqslant}

% fg for "function group"
\providecommand{\fg}[2]{{#2}^{\scalebox{0.75}{#1}}}
\providecommand{\minisub}[2]{#1_{\scalebox{0.65}{#2}}}
\providecommand{\id}{\mathsf{id}}

\DeclareMathOperator{\Dom}{Dom}
\DeclareMathOperator{\dom}{dom}
\DeclareMathOperator{\Range}{Range}
\DeclareMathOperator{\Hom}{\normalfont{\text{Hom}}}
\DeclareMathOperator{\Sub}{\normalfont{\text{Sub}}}

\providecommand{\expo}[1]{{%
  \text{\normalfont{exp}}\left(#1\right)%
}}%

\providecommand{\interior}[1]{{#1\degree}}
\providecommand{\closure}[1]{{\lbar{#1}}}

\DeclareRobustCommand{\actson}{\mathrel{\rotatebox[origin=c]{90}{\(\curvearrowleft\)}}}

\providecommand{\ep}{\varepsilon}
\providecommand{\R}{\mathbb{R}}
\providecommand{\N}{\mathbb{N}}
\providecommand{\Q}{\mathbb{Q}}
\providecommand{\C}{\mathbb{C}}
\providecommand{\Z}{\mathbb{Z}}
\providecommand\op{{\mathit{op}}}

\providecommand\cdsquare[8]{%
  \begin{tikzcd}[ampersand replacement=\&]%
    #1 \arrow[r,"#2"] \arrow[d,"#4"] \& #3 \arrow[d,"#5"]\\
    #6 \arrow[r,"#7"] \& #8
  \end{tikzcd}%
}%

\providecommand\cdlift[6]{%
  \begin{tikzcd}[ampersand replacement=\&]%
    \& #5 \arrow[d,"#6"] \\
    #1 \arrow[r,"#2"] \arrow[ur,"#4",dashed] \& #3
  \end{tikzcd}%
}%

\providecommand\cddescend[6]{%
  \begin{tikzcd}[ampersand replacement=\&]%
    #1 \arrow[r,"#2"] \arrow[dr,"#6",dashed] \& #3 \arrow[d,"#4"]\\
    \& #5
  \end{tikzcd}%
}%

\def\comment#1{{\color{magenta} [#1]}}

\newcounter{exctr}
\setcounter{exctr}{0}
\renewcommand\theexctr{\arabic{exctr}}%
\renewcommand\theequation{\theexctr.\arabic{equation}}%
\regtotcounter{exctr}

\newenvironment{exercise}[1][]{%
\refstepcounter{exctr}%
\label{ex:\theexctr}%
\addcontentsline{toc}{section}{Exercise \theexctr~#1}%
\noindent\textbf{Exercise \theexctr~#1:~}%
}%
{%
	\ifnum\theexctr<\totvalue{exctr} %
		\sectionrule
	\fi %
}%
\newenvironment{exercise*}{%
\noindent\textbf{Exercise:}%
}%
{%
\sectionrule
}%
\newenvironment{last_exercise}[1][]{%
\refstepcounter{exctr}%
\label{ex:\theexctr}%
\addcontentsline{toc}{section}{Exercise \theexctr~#1}%
\noindent\textbf{Exercise \theexctr~#1:~}%
}%
{%
\par\vspace{\baselineskip}
}%
\newenvironment{last_exercise*}{%
\noindent\textbf{Exercise:}%
}%
{%
\par\vspace{\baselineskip}
}%

% New theorem-like environments
% These will be typeset in italics
\newtheorem{theorem}{Theorem}[exctr]
\newtheorem*{theorem*}{Theorem}
\newtheorem{proposition}[theorem]{Proposition}
\newtheorem*{proposition*}{Proposition}
\newtheorem{lemma}[theorem]{Lemma}
\newtheorem*{lemma*}{Lemma}
\newtheorem{claim}[theorem]{Claim}
\newtheorem*{claim*}{Claim}
\newtheorem{corollary}[theorem]{Corollary}
\newtheorem*{corollary*}{Corollary}
\newtheorem{remark}[theorem]{Remark}
\newtheorem*{remark*}{Remark}
\newtheorem{question}[theorem]{Question}
\newtheorem*{question*}{Question}
\newtheorem{researchquestion}[theorem]{Further Research}
\newtheorem*{researchquestion*}{Further Research}
\newtheorem{mathrule}[theorem]{Rule}

% These will be typeset in Roman
\theoremstyle{definition}
\newtheorem{definition}[theorem]{Definition}
\newtheorem*{definition*}{Definition}
\newtheorem{example}[theorem]{Example}
\newtheorem*{example*}{Example}
\newtheorem{fact}[theorem]{Fact}
\newtheorem{conjecture}[theorem]{Conjecture}
\newtheorem*{conjecture*}{Conjecture}
\newtheorem{definitionprop}[theorem]{Definition/Proposition}
\newtheorem*{definitionprop*}{Definition/Proposition}
\newtheorem*{bigremark*}{Remark}

