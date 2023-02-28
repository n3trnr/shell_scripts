remote_s3=$(aws s3 ls s3://refine-logs.s3.mng.refinehub.com/syslog/ | cut -c 2- | cut -c31-) #Reads directory names in S3 path
s3_list=`echo $remote_s3 | cut -c 3-` #Removes / in the front (I've tried to put this line on remote var but it doesnt work)

loc=$(ls data | grep [*.*.*.*]) # get the local directory list

leng=$(echo $s3_list | grep / | wc -w) # counts number of directories in S3
loc_leng=$(echo $loc | grep " " | wc -w) #counts number of directories in local server

if [ $leng -ge $loc_leng ] #if directories in S3 is less than local one
then
        for i in /var/log/logstash/data/*
        do
                date_now=$(date "+%Y-%m-%d")
                device=$(echo $i | awk -F "/" '{print $6}')

                aws s3 cp $i/$date_now.log s3://refine-logs.s3.mng.refinehub.com/syslog/$device/ >> /var/log/logstash/s3_upload_log/s3_upload_$date_now.success

        done
else
        sh /var/log/logstash/new_device.sh
fi