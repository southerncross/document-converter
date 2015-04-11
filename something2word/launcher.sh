#!/usr/bin/bash

dirs=`ls -d 1*`
python_script='raw2utf.py'
php_script='utf2word.php'

for dir in $dirs
do
    mkdir $dir/output
    files=`ls $dir | grep -x '.*[0-9]'`
    for file in $files
    do
        iconv -c -f gb18030 -t gb18030 $dir/$file > $dir/${file}_tmp
        echo $dir/${file}_tmp | python $python_script
        mv $dir/${file}_tmp_res $dir/output/${file}.txt
		echo $dir/output/${file}.txt | php $php_script
		#rm $dir/output/${file}.txt
        rm $dir/${file}_tmp
        echo $dir/$file ok
    done
done
