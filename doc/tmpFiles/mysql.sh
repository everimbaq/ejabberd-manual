#!/bin/bash
#检查命令是否执行成功
# innobackupex --user=root --password=123456 /home/projects/mysql_backup
if_sucess(){
local command="$1"
$command
if [ $? -ne 0 ];then
echo "error."
touch $error_lock_file
exit 1
fi
}
#检查是否存在锁文件，如果存在就退出。
check_locked(){
if [ -f  "$error_lock_file" ];then
echo "error_lock_file found"
exit 1
fi
}
 
#压缩备份一周的完整与增量备份
compress_old_backup(){
if_sucess "tar czf $old_backup_file_temp $full_dir $incr_dir"
rm -f $old_backup_file
if_sucess "mv $old_backup_file_temp $old_backup_file"
rm -rf $full_dir $incr_dir/*
}



#定义相关变量
user=root
password=Innodealing
db_name="innodealing"
include_db="*.*"

backup_base=/home/Innodealing/share/package/mysql
full_dir=$backup_base/full
incr_dir=$backup_base/incr
old_backup_file=$backup_base/old/old.tar.gz
old_backup_file_temp=$backup_base/old/temp.tar.gz
error_lock_file=$backup_base/error.locked
defaults_file=/etc/my.cnf
sub_incr_dir=$(date +%w)


#程序从这里开始
check_locked
mkdir -p  $full_dir $incr_dir $backup_base/old
 
#周六就作完整备份，其它时间增量备份。
if [ $sub_incr_dir -eq 6 ];then
[ -d "$full_dir" ] && compress_old_backup
if_sucess "innobackupex --user=$user --defaults-file=$defaults_file --no-timestamp --no-lock --database=$db_name  $full_dir"
echo "incr_base_dir=$full_dir" > $full_dir/incr_base_dir.txt
else
[ -f "$full_dir/incr_base_dir.txt" ] && . $full_dir/incr_base_dir.txt || exit 1
if_sucess "innobackupex --user=$user --defaults-file=$defaults_file --database=$db_name --no-lock --incremental $incr_dir/$sub_incr_dir --incremental-force-scan --no-timestamp  --incremental-basedir=$incr_base_dir"
echo "incr_base_dir=$incr_dir/$sub_incr_dir" > $full_dir/incr_base_dir.txt
fi
