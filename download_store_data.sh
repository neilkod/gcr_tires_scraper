#!/bin/sh

# create the directories if they don't already exist
if [ ! -d stores ]; then
  mkdir stores
fi

if [ ! -d states ]; then
  mkdir states
fi

# download the list of states that gcr tires does business in
# we'll then go state-by-state and download locations for each state
STATES_FILE=gcr_states.txt
STORE_IDS_FILE=store_ids.txt

curl -s http://www.gcrtires.com/locations.php|grep -o "store_results.php?state=[A-Z][A-Z]"|awk -F= '{print $2}' > $STATES_FILE

BASE_URL='http://www.gcrtires.com/store_results.php?state='
STORE_URL='http://www.gcrtires.com/viewstore.php?id='
while read p; do 
    state_page=$BASE_URL$p
    echo $state_page
    curl -s $state_page > states/$p.html
done < $STATES_FILE

# build a list of store ids
grep -o 'viewstore.php?id=[0-9]*' states/*.html |awk -F= '{print $2}' > $STORE_IDS_FILE

# now that we have the list of store ids, download the store data
# from the site
while read p; do
  store_page=$STORE_URL$p
  echo $store_page
  curl -s $store_page > stores/store_$p.html
done < $STORE_IDS_FILE

