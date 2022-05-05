def call() {
	switch (env.MYCI_NODE_TYPE) {
	case "android":
		if (env.IPADDRESS && env.PORT) {
			sh '''
				adb -s ${IPADDRESS}:${PORT} shell "echo temp > /sys/power/wake_unlock" || true
				adb disconnect ${IPADDRESS}:${PORT}

				# Force a fresh start-server on next start if
				# no devices are connected.
				# After a while some weird connection issues
				# occur for a long running server daemon..
				status=`adb devices | grep -v 'List of devices attached' | awk '{print $2}'`
				if [ "x\$status" == "x" ]; then
					adb kill-server
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
