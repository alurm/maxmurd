DICK='
             ╔===3
8====╗   ╔===╝
     ╚===╝
'

if [[ ! -v NOTIFY ]]; then
  NOTIFY=notify-send
fi

$NOTIFY DICK "$DICK"
