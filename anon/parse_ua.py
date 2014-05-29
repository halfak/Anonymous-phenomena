"""
Finds and expands a user_agent column in a TSV into parsed fields:

* browser_family
* browser_version_major
* os_family
* device_family
"""
import user_agents, sys, traceback
from menagerie.formatting import tsv

def main():
	
	reader = tsv.Reader(sys.stdin)
	
	writer = tsv.Writer(sys.stdout,
	                    headers=reader.headers + ['browser_family',
	                                              'browser_version_major',
	                                              'os_family',
	                                              'device_family'])
	
	for row in reader:
		try:
			ua = user_agents.parse(row.user_agent)
		except Exception as e:
			sys.stderr.write(traceback.format_exc() + "\n")
			ua = user_agents.parse("")
		
		if len(ua.browser.version) > 0:
			major_version = ua.browser.version[0]
		else:
			major_version = "unknown"
		
		writer.write(list(row.values()) + \
		             [ua.browser.family, major_version, ua.os.family, ua.device.family])
		
