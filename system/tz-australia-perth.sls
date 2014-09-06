#!stateconf -o yaml . jinja
#
# Set system timezone to Australia/Perth
########################################################################

.Set hardware clock to UTC and system clock to Australia/Perth:
  timezone.system:
    - name: Australia/Perth
    - utc: True
