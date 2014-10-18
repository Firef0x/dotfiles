#  Written by Xiaohong Zheng. Email:xhzheng@foxmail.com

#! /bin/sh
if [ $# != 1 ]; then
	echo 'Usage:  endnote2bibtex.sh input_file'
	exit  1
fi

rm -f ref.bib
awk '{if($1=="author") print NR}' $1  >11
awk '{if($1=="year") print NR}' $1  >22
paste 11 22 >33
rm 11 22
nn=`awk 'END{print NR}' 33`
for((i=1;i<=nn;i++)); do
	echo 'Adding a label for item: '$i
	sed -n ''$i','$i'p' 33 >tmp
	n1=`awk '{print $1}' tmp`
	n2=`awk '{print $2}' tmp`
	sed -n ''$n1','$n2'p' $1 >tmp
	awk '{if($1=="author") printf "%s_", $3}' tmp >ttt
	awk '{if($1=="year") printf "%s_", $3}' tmp >>ttt
	awk '{if($1=="pages") printf "%s", $3}' tmp |sed 's/-/  /' |awk '{print $1}'>>ttt
	sed 's///g' ttt > ttt2
	mv ttt2 ttt
	aa=`cat ttt |sed 's/{//g' |sed 's/,//g' |sed 's/}//g'`
	echo '@article{'$aa',' >> ref.bib
	cat tmp >>ref.bib
	echo '}' >> ref.bib
	echo '' >>ref.bib
done

rm 33 tmp ttt

sed 's///g' ref.bib > ref.bib2
mv ref.bib2 ref.bib

echo 'The output file: ref.bib'
