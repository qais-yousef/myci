def call() {
	switch (env.MYCI_NODE_TYPE) {
	case "android":
		if (env.ANDROID_SERIAL) {
			sh '''
				IPADDRESS=\$(echo ${ANDROID_SERIAL} | awk -F : '{print \$1}')
				PORT=\$(echo ${ANDROID_SERIAL} | awk -F : '{print \$2}')

				if [ "x\$PORT" != "x" ]; then
					retry=5
					for i in \$(seq \$retry)
					do
						adb connect \$IPADDRESS:\$PORT

						status=`adb devices | grep \$IPADDRESS | awk '{print \$2}'`

						if [ "x\$status" == "xdevice" ]; then
							break
						fi

						adb disconnect \$IPADDRESS:\$PORT || true

						sleep 3
					done
				fi
				adb root || true
				adb remount || true
				adb shell "echo temp > /sys/power/wake_lock" || true
			'''
		} else {
			error "Missing ANDROID_SERIAL"
		}
		break
	default:
		break
	}
}
