#!/bin/zsh

while true
do
  totalBalance=0
  while read p; do
    wget https://www.blockchain.com/btc/address/"$p" -q -O - >> "$p".html
    balance=$(awk '{for(i=1;i<=NF;i++)if($i~/address/ && $(i+1)~/is/ && $(i+3)~/BTC/){print $(i+2); exit}}' "$p".html)
    rm $p.html
    echo "$p $balance BTC"
    totalBalance=$(bc <<< "$totalBalance + $balance")
    sleep 1
  done < addresses
  echo "Total balance of all addresses is $totalBalance BTC"
  sleep 3600
done
