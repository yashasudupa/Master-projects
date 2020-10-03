
#ifndef OTAWA_CACHE_MAMBLOCK_H
#define OTAWA_CACHE_MAMBLOCK_H

#include "MAMBlockSet.h"

// a trier
#include <elm/string.h>
#include <elm/genstruct/SLList.h>
#include <elm/genstruct/HashTable.h>
#include <elm/inhstruct/DLList.h>
//#include <elm/Iterator.h>
#include <otawa/instruction.h>
#include <otawa/ccg/Node.h>
#include <otawa/cfg/BasicBlock.h>
#include <otawa/ilp/Var.h>
#include <otawa/cat/CATNode.h>
#include <otawa/hard/Cache.h>


namespace otawa {

// Extern classes
class MAMBlockSet;

// MAMBlock class
class MAMBlock: public elm::inhstruct::DLNode, public PropList {
	friend class MAMBlockSet;
	
	address_t addr;
	int indice;
	int ident;
	int _mamBlockID;
	BasicBlock *_bb;
	t::uint32 _size;
	
	// Private methods
	~MAMBlock(void) { delete this; };
	
public :
	
	MAMBlock(MAMBlockSet *mlset, address_t head, size_t size, int _mamblockID);
	
	// methodes
	int id(void);
	int mamBlockID(void);
	inline address_t address(void);
	inline BasicBlock *bb(void);
	void setBB(BasicBlock *bb);
	int countInsts(void);
	inline size_t size(void) const;
	
	//public members 
	int next;
};

// Properties
extern Identifier<MAMBlock *> INST_MAMBLOCK;


// Inlines

inline size_t MAMBlock::size(void) const {
	return _size;
}

inline address_t MAMBlock::address(void) {
	return addr;
}

inline BasicBlock *MAMBlock::bb(void) {
	return _bb;
}



} // otawa

#endif // OTAWA_CACHE_MAMBLOCK_H

