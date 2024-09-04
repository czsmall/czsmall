#!/bin/bash

# 定义粗绿色虚线和红色文本格式
green_line="\e[32m========================================================\e[0m"
red_text="\e[31m"
reset_text="\e[0m"

# 输出开头的绿色虚线
echo -e "$green_line"

# 第一行：显示主机名
printf "%-20s: ${red_text}%s${reset_text}\n" "Hostname" "$(hostname)"

# 第二行：显示IP地址
ip_address=$(hostname -I | awk '{print $1}')
printf "%-20s: ${red_text}%s${reset_text}\n" "IP Address" "$ip_address"

# 第三行：显示DNS
dns_servers=$(grep 'nameserver' /etc/resolv.conf | awk '{print $2}' | paste -sd ", ")
printf "%-20s: ${red_text}%s${reset_text}\n" "DNS Servers" "$dns_servers"

# 第四行：显示系统版本号
os_version=$(cat /etc/os-release | grep "PRETTY_NAME" | cut -d '"' -f 2)
printf "%-20s: ${red_text}%s${reset_text}\n" "OS Version" "$os_version"

# 第五行：显示Linux内核版本
kernel_version=$(uname -r)
printf "%-20s: ${red_text}%s${reset_text}\n" "Kernel Version" "$kernel_version"

# 第六行：显示CPU型号
cpu_model=$(LC_ALL=C lscpu | grep "Model name" | awk -F ':' '{print $2}' | sed 's/^[ \t]*//')
if [ -z "$cpu_model" ]; then
  cpu_model=$(grep -m 1 'model name' /proc/cpuinfo | awk -F ':' '{print $2}' | sed 's/^[ \t]*//')
fi
printf "%-20s: ${red_text}%s${reset_text}\n" "CPU Model" "$cpu_model"

# 第七行：显示内存容量
memory_total=$(grep MemTotal /proc/meminfo | awk '{print $2}')
memory_total_gb=$(echo "scale=2; $memory_total/1024/1024" | bc)
printf "%-20s: ${red_text}%s GB${reset_text}\n" "Memory" "$memory_total_gb"

# 显示内存使用百分比
memory_info=$(free -m)
total_memory=$(echo "$memory_info" | grep "Mem:" | awk '{print $2}')
used_memory=$(echo "$memory_info" | grep "Mem:" | awk '{print $3}')
