"""
Reads a list of revisions from stdin and writes the same list of revisions
to stdout with two new columns:
    "reverted" : Boolean
        Was the revision reverted?
    "archived" : Boolean
        Was the revision archived?

Usage:
  revision_status [--revert-radius=<radius>] [--revert-cutoff=<cutoff>]
  revision_status -h | --help
  revision_status --version

Options:
  -h --help                 Show this screen.
  --version                 Show version.
  --revert-radius=<radius>  Set the maximum distance the revert can travel 
                            [default: 15]
  --revert-cutoff=<radius>  Set the maximum time (seconds) to wait for a revert
                            [default: 172800]
"""
from docopt import docopt
from menagerie.formatting import tsv
from menagerie.iteration import aggregate
import sys

from mw import Timestamp
from mw.database import DB
from mw.lib import reverts

def read_revisions(f):
	if not f.isatty():
		return tsv.Reader(f)

def main():
	args = docopt(__doc__, version="0.0.1")
	
	run(read_revisions(sys.stdin),
	    int(args['--revert-radius']),
	    int(args['--revert-cutoff']))

def run(revs, radius, cutoff):
	writer = None
	for wiki, revs in aggregate(revs, by=lambda r: r.wiki):
		
		sys.stderr.write("Conn({0}): ".format(wiki))
		db = DB.from_params(
			host="analytics-store.eqiad.wmnet",
			user="research",
			read_default_file="~/.my.research.cnf",
			db=wiki
		)
		for rev in revs:
			if writer == None:
				writer = tsv.Writer(sys.stdout, headers=rev.keys() + ['reverted', 'archived'])
			
			rev_doc = dict(rev)
			
			try:
				#sys.stderr.write("<");sys.stderr.flush()
				rev_row = db.revisions.get(int(rev.rev_id))
				#sys.stderr.write(str(int(rev_row==None)))
				#sys.stderr.write("|");sys.stderr.flush()
				rev_doc['archived'] = False
				
				revert = reverts.database.check_row(
					db,
					rev_row,
					radius=radius,
					before=Timestamp(rev_row['rev_timestamp']) + cutoff
				)
				if revert != None:
					rev_doc['reverted'] = True
					sys.stderr.write("r");sys.stderr.flush()
				else:
					rev_doc['reverted'] = False
					sys.stderr.write(".");sys.stderr.flush()
			
			except KeyError:
				rev_doc['archived'] = False
				rev_doc['reverted'] = None
				sys.stderr.write("a");sys.stderr.flush()
			finally:
				#sys.stderr.write(">");sys.stderr.flush()
				pass
			
			writer.write([rev_doc[k] 
			              for k in rev.keys() + ['reverted', 'archived']])
			
			sys.stderr.flush()
		
		sys.stderr.write("\n");sys.stderr.flush()
		
	
