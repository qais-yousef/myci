def call() {
	switch (env.MYCI_NODE_TYPE) {
	case "android":
		if (env.IPADDRESS && env.PORT) {
			sh '''
				adb -s ${IPADDRESS}:${PORT} shell "echo temp > /sys/power/wake_unlock"
				adb disconnect ${IPADDRESS}:${PORT}
			'''
		} else {
			error "Missing IPADDRESS and/or PORT info"
		}
		break
	default:
		break
	}
}
