#
# Set the maximum allowed line length for Python code to 99 characters
########################################################################

.Make PEP 8 MAX_LINE_LENGTH equal 99:
  file.replace:
    - name: /usr/local/lib/python2.7/dist-packages/pep8.py
    - pattern: MAX_LINE_LENGTH =.*
    - repl: MAX_LINE_LENGTH = 99
    - backup: False
