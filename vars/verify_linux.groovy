def call() {
	switch (env.MYCI_NODE_TYPE) {
	case "linux":
		break
	default:
		error "Not a Linux node!"
		break
	}
}
