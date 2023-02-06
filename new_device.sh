aws s3 ls s3://refine-logs.s3.mng.refinehub.com/syslog/ | cut -c 2- | cut -c31- | tr -d '/' > s3_temp.txt #Reads and make list file of directory names in AWS S3 path
sed '/^$/d' s3_temp.txt > s3_list.txt #Removes null values in the list
rm -rf s3_temp.txt #Remove temporary file

ls data | grep [*.*.*.*] > local_list.txt # Get the local directory name list and make it as file

comm -3 s3_list.txt local_list.txt | cut -c 2- > result_temp.txt #Compare both S3_list.txt and local_list.txt files, put its result in result_temp.txt

sed '1,2d' result_temp.txt > result.txt #Removes unnecessary lines in result_temp.txt

rm -rf s3_list.txt | rm -rf local_list.txt | rm -rf result_temp.txt #Removes every

#cat result.txt

leng=`cat -E result.txt | grep  "$" | wc -w`

if [ $leng > 0 ]
then
        for ((i=1 ; i<=$leng ; i++))
        do
                #echo $i
                new_dir=`awk 'NR == '$i' {print $0; exit}' result.txt`
                echo $new_dir
                aws s3 cp /var/log/logstash/data/$new_dir  s3://refine-logs.s3.mng.refinehub.com/syslog/$new_dir --recursive
                echo "uploading " $1
                echo $new_dir "is done"
        done
fi

rm -rf result.txt