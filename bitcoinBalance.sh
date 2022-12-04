#!/bin/zsh

while true
do
  totalBalance=0

  while read p; do
    wget https://www.blockchain.com/btc/address/"$p" -q -O - >> "$p".html
    balance=$(awk '{for(i=1;i<=NF;i++)if($i~/address/ && $(i+1)~/is/ && $(i+3)~/BTC/){print $(i+2); exit}}' "$p".html)
    rm $p.html
    echo "$p $(printf "%.8f" $balance) BTC"
    totalBalance=$(bc <<< "$totalBalance + $balance")
    sleep 0.5
  done < addresses

  wget https://bitcoinwisdom.io/ -q -O - >> mainPage.html
  btcPrice=$(awk 'BEGIN { FS="\""}{for(i=1;i<=NF;i++)if($i~/BTC\\\/USD/ && $(i+2)~/last_price/){print $(i+4)}}' mainPage.html)
  totalBalanceUSD=$(bc <<< "$totalBalance * $btcPrice")
  rm mainPage.html
  echo "Total balance of all addresses is $(printf "%.8f" $totalBalance) BTC or $(printf "%.1f" $totalBalanceUSD) $"
  echo
  sleep 3600

done
