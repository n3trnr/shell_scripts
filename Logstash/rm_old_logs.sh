#Logstash logs ex)logstash_plain-YYYY-MM-DD.log.gz

for i in $(find *.log.gz)
do
        date_now=$(date "+%Y-%m-%d")
        touch /var/log/logstash/s3_upload_log/logstash_log/logstash_$date_now.log
        aws s3 cp $i s3://refine-logs.s3.mng.refinehub.com/logstash_logs_and_files/logstash_plain_logs/ >> /var/log/logstash/s3_upload_log/logstash_log/logstash_$date_now.log
        rm -rf $i #Deletes logstash_plain_logs.log.gz
done

#SYSLOG Files

date_now=$(date "+%Y-%m-%d")
touch /var/log/logstash/s3_upload_log/rm_logs_data/removed_logs_$date_now.log
cd /var/log/logstash/data/

mon=`date -d '1 month ago' '+%Y-%m'` # Get the 1 month ago date
weeks=`date -d '1 week ago' '+%Y-%m'` # Get the 1 week ago date

find . -name "*$mon*" >> /var/log/logstash/s3_upload_log/rm_logs_data/removed_logs_$date_now.log
find . -name "*$mon*" -delete >> /var/log/logstash/s3_upload_log/rm_logs_data/removed_logs_$date_now.log