def call() {
	switch (env.MYCI_NODE_TYPE) {
	case "android":
		if (env.IPADDRESS && env.PORT) {
			sh '''
				state=`adb -s ${IPADDRESS}:${PORT} shell dumpsys power | grep -i wakefulness= | awk -F = '{print \$2}'`

				if [ "\$state" == "Awake" ]; then
					adb -s ${IPADDRESS}:${PORT} shell input keyevent 26
				fi

				if [ -e .myci_android_display_timeout ]; then
					adb -s ${IPADDRESS}:${PORT} shell settings put system screen_off_timeout \$(cat .myci_android_display_timeout)
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
