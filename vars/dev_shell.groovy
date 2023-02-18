def call(cmd) {
	switch (env.MYCI_NODE_TYPE) {
	case "android":
		if (env.ANDROID_SERIAL) {
			sh """
				adb shell \"${cmd}\"
			"""
		} else {
			error "Missing ANDROID_SERIAL"
		}
		break
	default:
		error "Not implemented for this node type: " + env.MYCI_NODE_TYPE
		break
	}
}
