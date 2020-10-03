
#ifndef OTAWA_CACHE_MAMBLOCKSET_H
#define OTAWA_CACHE_MAMBLOCKSET_H

#include "MAMBlock.h"

#include <assert.h>
#include <otawa/properties.h>
#include <otawa/instruction.h>
//#include <elm/Collection.h>
#include <elm/genstruct/Vector.h>
#include <elm/genstruct/Table.h>
//#include <elm/Iterator.h>

using namespace elm;

namespace otawa {

// Extern classes
class MAMBlock;

// MAMBlockSet class
class MAMBlockSet {
	friend class AbsMAMBlockBuilder;
	elm::genstruct::Vector<MAMBlock *> listemls;
	int _mamBlockIDs;

public:

	// Iterator class
	class Iterator:  public elm::genstruct::Vector<MAMBlock *>::Iterator {
	public:
		inline Iterator(MAMBlockSet& mlset);
	};
	
	// Methods
	inline MAMBlockSet();
	//inline IteratorInst<MAMBlock *> *visit(void);
	int add (MAMBlock *node);
	int count(void);
	int mamBlockIDCount(void);
	int newMamBlockID(void);
	MAMBlock *mblock(int idx);
	
};

// Properties
extern Identifier<MAMBlockSet *> MAMBLOCKS;
extern Identifier<genstruct::AllocatedTable<MAMBlock* >* > BB_MAMBLOCKS;
 

// Inlines
inline MAMBlockSet::MAMBlockSet() : _mamBlockIDs(0) {
}

/*inline IteratorInst<MAMBlock *> *MAMBlockSet::visit(void) {
	Iterator iter(*this);
	return new IteratorObject<Iterator, MAMBlock *>(iter); 
}*/

// MAMBlockSet::Iterator inlines
inline MAMBlockSet::Iterator::Iterator(MAMBlockSet& mlset)
: elm::genstruct::Vector<MAMBlock *>::Iterator(mlset.listemls) {
}

} //otawa

#endif // OTAWA_CACHE_MAMBLOCKSET_H
