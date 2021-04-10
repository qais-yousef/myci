def call(cmd) {
	switch (env.MYCI_NODE_TYPE) {
	case "android":
		if (env.IPADDRESS && env.PORT) {
			sh """
				adb -s ${IPADDRESS}:${PORT} shell \"${cmd}\"
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
