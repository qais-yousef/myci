def call() {
	switch (env.MYCI_NODE_TYPE) {
	case "android":
		if (!env.ANDROID_SERIAL) {
			error "Missing ANDROID_SERIAL"
		}
		break
	default:
		error "Not an Android node!"
		break
	}
}
