def call() {
	switch (env.MYCI_NODE_TYPE) {
	case "android":
		if (env.IPADDRESS && env.PORT) {
			sh '''
				retry=5
				for i in \$(seq \$retry)
				do
					adb connect ${IPADDRESS}:${PORT}

					status=`adb devices | grep ${IPADDRESS} | awk '{print $2}'`

					if [ "x\$status" == "xdevice" ]; then
						break
					fi

					adb disconnect ${IPADDRESS}:${PORT} || true

					sleep 3
				done
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
