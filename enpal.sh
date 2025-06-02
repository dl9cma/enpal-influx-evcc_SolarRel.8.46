#!/bin/sh

# Zugangsdaten InfluxDB
# @ see https://github.com/weldan84/enpal-influx-evcc
INFLUX_HOST="ip-adresse:8086"
INFLUX_ORG_ID="orgidausinfluxdb"
INFLUX_BUCKET="solar"
INFLUX_TOKEN="einelangekryptischezeichenkette"
INFLUX_API="${INFLUX_HOST}/api/v2/query?orgID=${INFLUX_ORG_ID}"
QUERY_RANGE_START="-5m"


case $1 in
	battery)
	    if [ -z "$2" ]; then
	    echo >&2 "Geben Sie ein gültigen Sensor Namen für ihre Messung an."
	    echo >&2 "Schauen Sie hierzu in die InfluxDB oder Webseite ihrer EnpalBox"
	    exit 1
	    else
		var=$(curl -f -s "${INFLUX_API}" \
		    --header "Authorization: Token ${INFLUX_TOKEN}" \
		    --header "Accept: application/json" \
		    --header "Content-type: application/vnd.flux" \
		    --data "from(bucket: \"$INFLUX_BUCKET\")
			|> range(start: $QUERY_RANGE_START)
			|> filter(fn: (r) => r._measurement == \"battery\")
			|> filter(fn: (r) => r._field == \"$2\")
			|> keep(columns: [\"_value\"])
			|> last()")
		status="$?"
		var="${var##*,}"
	    fi
	    ;;
	inverter)
	    if [ -z "$2" ]; then
	    echo >&2 "Geben Sie ein gültigen Sensor Namen für ihre Messung an."
	    echo >&2 "Schauen Sie hierzu in ihrer InfluxDB oder Webseite ihrer EnpalBox"
	    exit 1
        else
		var=$(curl -f -s "${INFLUX_API}" \
		    --header "Authorization: Token ${INFLUX_TOKEN}" \
		    --header "Accept: application/json" \
		    --header "Content-type: application/vnd.flux" \
		    --data "from(bucket: \"$INFLUX_BUCKET\")
			|> range(start: $QUERY_RANGE_START)
			|> filter(fn: (r) => r._measurement == \"inverter\")
			|> filter(fn: (r) => r._field == \"$2\")
			|> keep(columns: [\"_value\"])
			|> last()")
		status="$?"
		var="${var##*,}"
	    fi
	;;
	iot)
	    if [ -z "$2" ]; then
	    echo >&2 "Geben Sie ein gueltigen Sensor Namen fuer ihre Messung an."
	    echo >&2 "Schauen Sie hierzu in ihrer InfluxDB oder Webseite ihrer EnpalBox"
	    exit 1
	    else
		var=$(curl -f -s "${INFLUX_API}" \
		    --header "Authorization: Token ${INFLUX_TOKEN}" \
		    --header "Accept: application/json" \
		    --header "Content-type: application/vnd.flux" \
		    --data "from(bucket: \"$INFLUX_BUCKET\")
			|> range(start: $QUERY_RANGE_START)
			|> filter(fn: (r) => r._measurement == \"iot\")
			|> filter(fn: (r) => r._field == \"$2\")
			|> keep(columns: [\"_value\"])
			|> last()")
		status="$?"
		var="${var##*,}"
	    fi
	;;
	powerSensor)
	    if [ -z "$2" ]; then
	    echo >&2 "Geben Sie ein gültigen Sensor Namen für ihre Messung an."
	    echo >&2 "Schauen Sie hierzu in ihrer InfluxDB oder Webseite ihrer EnpalBox"
	    exit 1
	    else
		var=$(curl -f -s "${INFLUX_API}" \
		    --header "Authorization: Token ${INFLUX_TOKEN}" \
		    --header "Accept: application/json" \
		    --header "Content-type: application/vnd.flux" \
		    --data "from(bucket: \"$INFLUX_BUCKET\")
			|> range(start: $QUERY_RANGE_START)
			|> filter(fn: (r) => r._measurement == \"powerSensor\")
			|> filter(fn: (r) => r._field == \"$2\")
			|> keep(columns: [\"_value\"])
			|> last()")
		status="$?"
		var="${var##*,}"
	    fi
	;;
	system)
	    if [ -z "$2" ]; then
	    echo >&2 "Geben Sie ein gültigen Sensor Namen für ihre Messung an."
	    echo >&2 "Schauen Sie hierzu in ihrer InfluxDB oder Webseite ihrer EnpalBox"
	    exit 1
	    else
		var=$(curl -f -s "${INFLUX_API}" \
		    --header "Authorization: Token ${INFLUX_TOKEN}" \
		    --header "Accept: application/json" \
		    --header "Content-type: application/vnd.flux" \
		    --data "from(bucket: \"$INFLUX_BUCKET\")
			|> range(start: $QUERY_RANGE_START)
			|> filter(fn: (r) => r._measurement == \"system\")
			|> filter(fn: (r) => r._field == \"$2\")
			|> keep(columns: [\"_value\"])
			|> last()")
		status="$?"
		var="${var##*,}"
	    fi
	;;
	evcc-battery)
		var=$(curl -f -s "${INFLUX_API}" \
		    --header "Authorization: Token ${INFLUX_TOKEN}" \
		    --header "Accept: application/json" \
		    --header "Content-type: application/vnd.flux" \
		    --data "from(bucket: \"$INFLUX_BUCKET\")
			|> range(start: $QUERY_RANGE_START)
			|> filter(fn: (r) => r._measurement == \"battery\")
			|> filter(fn: (r) => r._field == \"Power.Battery.Charge.Discharge\")
			|> keep(columns: [\"_value\"])
			|> last()")
		status="$?"
		var="${var##*,}"
                echo $((var * -1))    
		exit "$status"
	;;
	evcc-gridpower)
		var=$(curl -f -s "${INFLUX_API}" \
		    --header "Authorization: Token ${INFLUX_TOKEN}" \
		    --header "Accept: application/json" \
		    --header "Content-type: application/vnd.flux" \
		    --data "from(bucket: \"$INFLUX_BUCKET\")
			|> range(start: $QUERY_RANGE_START)
			|> filter(fn: (r) => r._measurement == \"inverter\")
			|> filter(fn: (r) => r._field == \"Power.Grid.Export\")
			|> keep(columns: [\"_value\"])
			|> last()")
		status="$?"
                var="${var##*,}"
                echo $((var * -1))
                exit "$status"
	;;
	*)
	echo >&2 "Geben Sie eine gültige Messung (_measurement) und den dazugehören Sensornamen (_field) aus ihrer InfluxDB an."
	echo >&2 ""
	echo >&2 "enpal <_measurement> <_field>"
	echo >&2 ""
	echo >&2 "Derzeit stehen Ihnen mit der 'Enpal Solar Rel.8.46.4' folgende measurements zur verfügung:"
	echo <&2 "'battery', 'inverter', 'iot', 'powerSensor' und 'system'"
        exit 1
	;;
	*)
	echo >&2 "Geben Sie eine gültige Messung (_measurement) und den dazugehören Sensornamen (_field) aus ihrer InfluxDB an."
	echo >&2 ""
	echo >&2 "enpal <_measurement> <_field>"
	echo >&2 ""
	echo >&2 "Derzeit stehen Ihnen mit der 'Enpal Solar Rel.8.46.4' folgende measurements zur verfügung:"
	echo <&2 "'battery', 'inverter', 'iot', 'powerSensor' und 'system'"
        exit 1
	;;
esac

# Konvertierung
var="${var%.*}"
echo $((var))
exit "$status"
