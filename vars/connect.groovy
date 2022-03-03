def call() {
	switch (env.MYCI_NODE_TYPE) {
	case "android":
		if (env.IPADDRESS && env.PORT) {
			sh '''
				adb connect ${IPADDRESS}:${PORT}
				adb -s ${IPADDRESS}:${PORT} root || true
				adb -s ${IPADDRESS}:${PORT} remount || true
				adb -s ${IPADDRESS}:${PORT} shell "echo temp > /sys/power/wake_lock" || true
			'''
		} else {
			error "Missing IPADDRESS and/or PORT info"
		}
		break
	default:
		break
	}
}
