#!stateconf -o yaml . jinja
#
# Set the maximum allowed line length for Python code to 99 characters
########################################################################

# TODO: Maybe separate these out, now that we have 'onlyif' for the actual state :P
.System-Pip installed:
  pkg.installed:
    - name: python-pip

.Pep8 package installed in system-Python:
  pip.installed:
    - name: pep8

.Make PEP 8 MAX_LINE_LENGTH equal 99:
  file.replace:
    - name: /usr/local/lib/python2.7/dist-packages/pep8.py
    - pattern: MAX_LINE_LENGTH =.*
    - repl: MAX_LINE_LENGTH = 99
    - backup: False
    - onlyif: -f /usr/local/lib/python2.7/dist-packages/pep8.py
