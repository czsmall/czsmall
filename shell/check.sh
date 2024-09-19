#!/bin/bash

# 邮件配置
MAIL_TO="171219287@qq.com"
MAIL_SUBJECT="磁盘空间超过报警阈值"
MAIL_BODY="/tmp/disk_usage_alert.txt"

# 检查磁盘使用情况
df -h | awk 'NR>1 {print $5 " " $1}' | while read usage partition; do
    # 去掉百分号
    usage=${usage%?}
    
    # 如果使用率超过80%
    if [ "$usage" -gt 80 ]; then
        echo "磁盘分区： $partition 利用率达到： ${usage}%." >> "$MAIL_BODY"
    fi
done

# 如果 $MAIL_BODY 文件中有内容，发送邮件
if [ -s "$MAIL_BODY" ]; then
    mailx -s "$MAIL_SUBJECT" "$MAIL_TO" < "$MAIL_BODY"
fi

# 清理临时文件
rm -f "$MAIL_BODY"

