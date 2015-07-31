#!/usr/bin/python

import math

def checkFixes(fixes, max_err=1.0/3600, warn_dist=1.0):
	import itertools

	for fix_id in sorted(fixes.keys()):
		for (coord, index) in zip(fixes[fix_id], itertools.count(1)):
			for (coord2, index2) in zip(fixes[fix_id][index:], itertools.count(index)):
				dist = (coord[0]-coord2[0], coord[1]-coord2[1])
				
				f = math.cos(math.radians(coord[0]+dist[0]/2))

				if abs(dist[0]) < max_err and abs(dist[1]) < max_err / f:
					# delete duplicate (this is a duplicate for sure!)
					fixes[fix_id][index] = (coord[0]+dist[0]/2, coord[1]+dist[1]/2)
					
					print("WARNING: fixing duplicate %s: %s %s" % (fix_id, str(coord), str(coord2)))
					
					del fixes[fix_id][index2]
				
				elif abs(dist[0]) < warn_dist and abs(dist[1]) < warn_dist / f:
					# fixes with the same name are close to each other but not duplicates
					print("WARNING: possible duplicate: %s %s" % (fix_id, str(coord)))


def csv2dat(csv_path, dat_path):
	if type(csv_path) == str:
		csv_path = [csv_path]
	
	fixes = {}
	
	for csv_file in csv_path:
		with open(csv_file, 'r') as csv:
			for line in csv:
				els = line.split(',')
				coord = ( float(els[1]), float(els[2]) )

				try:
					fixes[els[0]].append(coord)
				except KeyError:
					fixes[els[0]] = [coord]

	checkFixes(fixes, max_err=0.5/3600)

	with open(dat_path, 'w') as dat:
		for fix_id in sorted(fixes.keys()):
			for (lat,lon) in fixes[fix_id]:
				dat.write('%10.6f %11.6f %5s\n' % (lat, lon, fix_id))

if __name__ == '__main__':
	import sys
	
	csv2dat(sys.argv[1:-1], sys.argv[-1])

