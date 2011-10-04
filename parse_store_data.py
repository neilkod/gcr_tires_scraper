#!/usr/bin/python

import os
import os.path
from BeautifulSoup import BeautifulSoup


files = os.listdir('stores')
os.chdir('stores')
for html_file in files:
	# test that we're dealing with an .html file
	if os.path.splitext(html_file)[1] == '.html':
		
		# read the file and convert it into a beautifulsoup object
		thefile=open(html_file).read()
		soup = BeautifulSoup(thefile)

		# find the table that contains the store address 
		address_table = soup.findAll('table',{'class':'plain'})
		
		# now that we found the table that contains the address
		# grab the table rows
		rows = address_table[0].findAll('tr')
		
		# this part takes trial and error
		# we examine the table and find out wher all of
		# the relevant pieces are located within the table
		# from there it's just a matter of grabbing what we want
		
		store_name = rows[1].findAll('td')[1].text
		address = rows[2].findAll('td')[1].text
		city_state_zip = rows[3].findAll('td')[1].text
		city = city_state_zip.split(',')[0]
		phone = rows[6].findAll('td')[1].text
		manager = rows[4].findAll('td')[1].text
		email = rows[5].findAll('td')[1].text
	
		# two of the locations had multiple commas in the city/state/zip.
		# for the purposes of this script, we're going to ignore them
	
		try:
			(state,zip_code) = city_state_zip.split(',')[1].split()
		except:
			None

		# output to stdout
		print '\t'.join([store_name,address,city,state,zip_code,phone,manager,email])

