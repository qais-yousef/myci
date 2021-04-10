def call() {
	switch (env.MYCI_NODE_TYPE) {
	case "android":
		if (!env.IPADDRESS || !env.PORT) {
			error "Missing IPADDRESS and/or PORT info"
		}
		break
	default:
		error "Not an Android node!"
		break
	}
}
