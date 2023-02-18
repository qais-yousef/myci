def call(src, dst) {
	switch (env.MYCI_NODE_TYPE) {
	case "android":
		if (env.ANDROID_SERIAL) {
			sh """
				adb pull \"${src}\" \"${dst}\"
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
