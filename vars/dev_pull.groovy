def call(src, dst) {
	switch (env.MYCI_NODE_TYPE) {
	case "android":
		if (env.IPADDRESS && env.PORT) {
			sh """
				adb -s ${IPADDRESS}:${PORT} pull \"${src}\" \"${dst}\"
			"""
		} else {
			error "Missing IPADDRESS and/or PORT info"
		}
		break
	default:
		error "Not implemented for this node type: " + env.MYCI_NODE_TYPE
		break
	}
}
