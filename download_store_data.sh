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
# from the site and save it in the stores directory.
# stores are numbered by id and the numbers don't seem to follow
# any easily-identifiable pattern. There are 200+ stores and the 
# ids range from 200 to 91000. yes, really.
# we'll iterate through the ids that we saved in the above step and then
# download the page's html to the stores directory

while read p; do
  store_page=$STORE_URL$p
  echo $store_page
  curl -s $store_page > stores/store_$p.html
done < $STORE_IDS_FILE

