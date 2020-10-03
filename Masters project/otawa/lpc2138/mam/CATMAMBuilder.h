#ifndef CATMAMBUILDER_H
#define CATMAMBUILDER_H

#include <otawa/proc/CFGProcessor.h>
#include "MAMBlockSet.h"

using namespace otawa;

namespace otawa {

	typedef enum mam_category_t {
	MAM_INVALID,
	MAM_ALWAYS_HIT,
	MAM_ALWAYS_MISS_STRONG,
	MAM_ALWAYS_MISS_WEAK,
	MAM_ALWAYS_MISS_NC,
	MAM_NOT_CLASSIFIED
	} mam_category_t;

class CATMAMBuilder: public CFGProcessor {
public:
	virtual void 	configure (const PropList &props);
	CATMAMBuilder();
	static Registration<CATMAMBuilder> reg;

protected:
	virtual void processCFG(WorkSpace *ws, CFG *cfg);
private:
	bool perfect_mam;
};

extern Identifier<mam_category_t> MAM_CATEGORY;
extern Identifier<address_t> MAM_PREFETCH_FROM;
extern Feature<CATMAMBuilder> MAM_CAT_FEATURE;
extern Identifier<bool> PERFECT_MAM;
} // otawa

#endif // CATMAMBUILDER_H
