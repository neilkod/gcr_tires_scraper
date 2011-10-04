import os
from BeautifulSoup import BeautifulSoup
files = os.listdir('/tmp/stores')
os.chdir('/tmp/stores')
for file in files:
	thefile=open(file).read()
	soup = BeautifulSoup(thefile)
	soup.prettify()

	xx=soup.findAll('table',{'class':'plain'})
	rows=xx[0].findAll('tr')
	address_row=xx[0].findAll('tr')[3]

	# get the store name
	rows=xx[0].findAll('tr')
	store_name = rows[1].findAll('td')[1].text
	address = rows[2].findAll('td')[1].text
	city_state_zip = rows[3].findAll('td')[1].text
	city = city_state_zip.split(',')[0]
	phone = rows[6].findAll('td')[1].text
	manager = rows[4].findAll('td')[1].text
	email = rows[5].findAll('td')[1].text
	try:
		(state,zip_code) = city_state_zip.split(',')[1].split()
	except:
#		print "error!! %s " % city_state_zip
		None
	print '\t'.join([store_name,address,city,state,zip_code,phone,manager,email])

