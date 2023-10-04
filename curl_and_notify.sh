#!/bin/sh
# Check the current processing times for my immigration form

notify-send "`curl -s 'https://egov.uscis.gov/processing-times/api/processingtime/I-129F/CSC' --compressed -H 'Referer: https://egov.uscis.gov/processing-times/' | sed 's/.*service_request_date_en":"//' | cut -d '"' -f1`"
