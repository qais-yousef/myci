adb_serial = "${env.IPADDRESS}:${env.PORT}"

def connect_android() {
	sh '''
		adb shell connect ${adb_serial}
		adb shell -s ${adb_serial} "echo temp > /sys/power/wake_lock"
	'''
}

def disconnect_android() {
	sh '''
		adb shell -s ${adb_serial} "echo temp > /sys/power/wake_unlock"
		adb shell disconnect ${adb_serial}
	'''
}
