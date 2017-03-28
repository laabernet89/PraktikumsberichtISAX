#!/bin/sh
pwd=$(pwd)
#~ twd="$(echo $pwd|rev|cut -d'/' -f1|rev)"
#~ if [ "${twd}" = "PH" ]; then	DOCNAME=Pflichtenheft ; fi
#~ if [ "${twd}" = "RFC" ]; then	DOCNAME=Entwicklerdokumentation ; fi
#~ if [ "${twd}" = "MAN" ]; then	DOCNAME=Benutzerhandbuch ; fi
#~ if [ "${twd}" = "CR" ]; then	DOCNAME=Änderungensnachweise ; fi
#~ if [ "${twd}" = "prot" ]; then  DOCNAME=Protokolle ; fi
#~ if [ "${twd}" = "PD" ]; then	DOCNAME=Projektdokumentation ; fi
#~ if [ "${DOCNAME}" = "" ]; then
	#~ echo ERROR: no doc name
	#~ exit 1
#~ fi
DOCNAME=Projektdokumentation
ProjTitle="Social Tagging, Folksonomien und Tag-Clouds in ERP-Systemen"
export DOCNAME
export ProjTitle
wrapper=00_Manteldokument
titlepg=titlepage
inv=inventory
mdext=markdown
md2tex=pandoc
sed=sed
tex2pdf=pdflatex
bib2tex=biber
doc="./"
#~ img=${doc}/img
pub=${doc}/pub
#~ raw=${doc}/raw
# prepare directories for usage in document
#~ if [ ! -h raw ]; then
	#~ ln -s ${raw} raw
#~ fi
#~ if [ ! -h img ]; then
	#~ ln -s ${img} img
#~ fi
cd ./img/
if [ $? -eq 0 ]; then
	./convert-svg2pdf.sh
	cd ${pwd}
fi
#~ x="PersonenAufgabenbereiche"
#~ ${md2tex} -f markdown -t latex -o ./${x}.tex ${doc}/${x}.md
for i in $(ls *.${mdext}); do
	x=$(echo "${i}" | rev | cut -d"." -f2- | rev)
	${md2tex} -f markdown -t latex -o ${x}.tex ${x}.${mdext}
	${sed} -i 's/\includegraphics{/\scalegraphics{/g' ${x}.tex
	#~ ${sed} -i 's/{Shaded}/{shaded}/g' ${x}.tex
	#~ ${sed} -i 's/\begin{Highlighting}\[\]//g' ${x}.tex
	#~ ${sed} -i 's/\end{Highlighting}//g' ${x}.tex
	#~ ${sed} -i 's/\[htbp\]/\[\!htbp\]/g' ${x}.tex
	${sed} -i 's/\[htbp\]//g' ${x}.tex
done
#~ cp ${doc}/${wrapper}.tex ./
#cp ${doc}/${inv}.tex ./

#~ ${tex2pdf} ${wrapper}.tex && ${bib2tex} ${wrapper} && ${tex2pdf} ${wrapper}.tex && ${tex2pdf} ${wrapper}.tex
${tex2pdf} ${wrapper}.tex 
${bib2tex} ${wrapper}
${tex2pdf} ${wrapper}.tex 
${tex2pdf} ${wrapper}.tex

datum=$( date +"%y%m%d-%H%M" )
mkdir -p ${pub}

mv ${wrapper}.pdf ${pub}/00_${DOCNAME}-draft${datum}.pdf && xdg-open ${pub}/00_${DOCNAME}-draft${datum}.pdf

rm -f *.aux *.bbl *.bcf *.blg *.blg *.mtc *.mtc0 *.xml *.toc *.lof *.lot *.glo *.xdy *.log
rm -f $(ls *.tex  |grep -v ${wrapper}".tex" | grep -v ${titlepg}".tex" )
#~ rm -f ${img}/*.pdf
