/* source: http://www.codemadness.nl/
 * Add the following to dwm.c:
 *	static void nextlayout(const Arg *arg);
 *	static void prevlayout(const Arg *arg);
 *
 * and after '#include "config.h"':
 *	#include "cycle.c"
 */

void
nextlayout(const Arg *arg) {
	Layout *l;
	for(l = (Layout *)layouts; l != selmon->lt[selmon->sellt]; l++);
	if(l->symbol && (l + 1)->symbol)
		setlayout(&((Arg) { .v = (l + 1) }));
	else
		setlayout(&((Arg) { .v = layouts }));
}

void
prevlayout(const Arg *arg) {
	Layout *l;
	for(l = (Layout *)layouts; l != selmon->lt[selmon->sellt]; l++);
	if(l != layouts && (l - 1)->symbol)
		setlayout(&((Arg) { .v = (l - 1) }));
	else
		setlayout(&((Arg) { .v = &layouts[LENGTH(layouts) - 2] }));
}
