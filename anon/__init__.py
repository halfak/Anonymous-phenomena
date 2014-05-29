"""
Parse user-agents.  Converts a TSV with a "user_agent" column into a TSV
with the same columns, but addition information about user agents 
(e.g. os_family, browser_family and browser_version).

Usage:
  parse_ua [--out=<path>]
  parse_ua -h | --help
  parse_ua --version

Options:
  -h --help     Show this screen.
  --version     Show version.
"""