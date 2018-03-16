import mirror, { actions } from "mirrorx";
import cache from "./cache";
mirror.hook((action, getState) => {
	const { routing: { location } } = getState();
	if (!cache.getAccessToken() && (!location || location.pathname != "/login")) {
		actions.routing.replace("/login");
		// window.location.href = '/login'
	}
});
