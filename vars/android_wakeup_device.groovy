def call() {
	switch (env.MYCI_NODE_TYPE) {
	case "android":
		if (env.IPADDRESS && env.PORT) {
			sh '''
				state=`adb -s ${IPADDRESS}:${PORT} shell dumpsys power | grep -i wakefulness= | awk -F = '{print \$2}'`

				if [ "\$state" != "Awake" ]; then
					adb -s ${IPADDRESS}:${PORT} shell input keyevent 26
					sleep 1
					adb -s ${IPADDRESS}:${PORT} shell input touchscreen swipe 200 800 200 100
				fi

				# Set timeout to 30 mins if not already set to that
				timeout=`adb -s ${IPADDRESS}:${PORT} shell settings get system screen_off_timeout`

				if [ "\$timeout" != "1800000" ]; then
					adb -s ${IPADDRESS}:${PORT} shell settings put system screen_off_timeout 1800000
					echo \$timeout > .myci_android_display_timeout
				fi
			'''
		} else {
			error "Missing IPADDRESS and/or PORT info"
		}
		break
	default:
		break
	}
}
