
#include "ParamExeGraph.h"
#include <otawa/graph/PreorderIterator.h>

using namespace  otawa;
using namespace otawa::gensim;

namespace otawa { namespace lpc2138 {

// --------------------------------------------------------------------------------------------------
int ParamExeGraph::Delta(ParamExeNode *a, Resource *res) {
  int r = res->index();
  if (!a->e(r))
    return(0);

  ParamExeNode *lp = _last_node[PROLOGUE];
  *_trace << L8 << "\tNewDelta(" << a->name() << " , " << res->name() << ")\n";

  int default_lp = lp->d(_latest_resource_index) + res->offset();
  if (res->type() == QUEUE) {
    StageResource * upper_bound = ((QueueResource *)(res))->upperBound();
    int u = upper_bound->index();
    if (lp->e(u)){
      int tmp = lp->d(u) + ((QueueResource *)(res))->upperBoundOffset();
      if (tmp < default_lp)
	default_lp = tmp;
    }
  }

  int delta;
  if (lp->e(r))
    delta = a->d(r) - lp->d(r);
  else {
    delta = a->d(r) - default_lp;
  }
  *_trace << L8 << "\t\tbase value is " << delta << "\n";

  for (elm::genstruct::Vector<Resource *>::Iterator resource(_resources) ; resource ; resource++) {
    if (resource->type() == INTERNAL_CONFLICT) {
      int s = resource->index();
      ParamExeNode * S = ((InternalConflictResource *) *resource)->node();
      if (a->e(s) && S->e(r)) {
	*_trace << L8 << "\t\tS=" << S->name();

	if (lp->e(s)){
	  *_trace << L8 << ": both a and lp depend on it ";
	  int tmp = a->d(s) - lp->d(s);
	  if (tmp > delta) {
	    delta = tmp;
	    *_trace << L8 << " - new delta is " << delta;
	  }
	  *_trace << L8 << "\n";
	} // end: is lp depends on S

	else { //lp does not depend on S

	  *_trace << L8 << ": lp does not depend on it \n";
	  for (elm::genstruct::SLList<elm::BitVector *>::Iterator mask(*(S->contendersMasksList())) ; mask ; mask++) {
	    int tmp = a->d(s);
	    tmp += (((mask->countBits()+S->lateContenders())/S->pipelineStage()->width())*S->latency());
	    int tmp2 = 0;
	    int tmp3;

	    if (mask->countBits() == 0) { // mask is null == no early contenders
	      if (!lp->e(r))
		tmp3 = tmp + S->d(r) - /*lp->d(_latest_resource_index) - res->offset()*/default_lp;
	      else
		tmp3 = tmp + S->d(r) - lp->d(r);
	      if (tmp3 > delta) {
		delta = tmp3;
		*_trace << L8 << "\t\t\t\tno contenders - new delta is " << delta << "\n";
	      }
	    }
	    else { // mask is not null
	      StringBuffer buffer;
	      for (elm::BitVector::OneIterator one(**mask) ; one ; one++) {
		ParamExeNode *C = S->pipelineStage()->node(one.item());
		buffer << C->name() << "-";
		int c = -1;
		for (elm::genstruct::Vector<Resource *>::Iterator ic(_resources) ; ic ; ic++) {
		  if (ic->type() == INTERNAL_CONFLICT) {
		    if (((InternalConflictResource *) *ic)->node() == C) {
		      c = ((InternalConflictResource *) *ic)->index();
		    }
		  }
		}
		assert(c != -1);
		assert(lp->e(c));
		if (lp->d(c) > tmp2)
		  tmp2 = lp->d(c);

	      }// end: foreach one in mask
	      if (lp->e(r)) {
		if (lp->d(r) - S->d(r) > tmp2) {
		  tmp2 = lp->d(r) - S->d(r);
		}
	      }
	      else {
		if (lp->d(_latest_resource_index) + res->offset()  - S->d(r) > tmp2) {
		  tmp2 = /*lp->d(_latest_resource_index) + res->offset()*/default_lp - S->d(r);
		}
	      }
	      tmp2 = tmp - tmp2;
	      if (tmp2 > delta) {
		delta = tmp2;
		*_trace << L8 << "\t\t\t\tcontenders:";
		*_trace << L8 << buffer.toString() << " new delta is " << delta << "\n";;
	      }
	    } // if mask not null
	  }
 	}
      }
    } // if resource is INTERNAL_CONFLICT
  } // end: foreach resource
  return(delta);
}


// --------------------------------------------------------------------------------------------------

int ParamExeGraph::cost() {
  int _cost = 0;
  int _start_cost = 0;
  int offset;
  ParamExeNode *a = _last_node[BODY];
  ParamExeNode *b = _last_node[PROLOGUE];
  for (elm::genstruct::Vector<Resource *>::Iterator res(_resources) ; res ; res++) {
    offset = 0;
    if (res->type() != INTERNAL_CONFLICT) {
      int r = res->index();
      if (res->type() == QUEUE) {
	StageResource * upper_bound = ((QueueResource *)(*res))->upperBound();
	int u = upper_bound->index();
	*_trace << L3 << "computing cost for resource " << res->name() << " (upperBound is " << upper_bound->name() << ")\n";
	*_trace << L3 << "\tupperBoundOffset = " << ((QueueResource *)(*res))->upperBoundOffset() << " \n";
        if ((a->e(r)) && (a->e(u))){
	  *_trace << L3 << "\ta->d(r)=" << a->d(r) << " - a->d(u)=" << a->d(u) << "\n";
	  if (a->d(r) <= a->d(u)
	      + ((QueueResource *)(*res))->upperBoundOffset()) {
	    continue;
	  }
        }
      }
      int tmp = Delta(a,res);
      if (res->type() == BLOCK_START) {
	_start_cost = tmp;
	_cost = tmp;
      }
      else {
	if (tmp > _cost) {
	  _cost = tmp;
	  if (tmp > _start_cost)
	    *_trace << L3 << "cost IS DUE to resource " << res->name() << " (" << tmp << ")\n";
	}
      }
    }
  }
  return(_cost);
}

// --------------------------------------------------------------------------------------------------

void ParamExeGraph::analyzeContentions() {

  for(Microprocessor<ParamExeNode>::PipelineIterator st(_microprocessor); st; st++){
    if (st->orderPolicy() == PipelineStage<ParamExeNode>::OUT_OF_ORDER) {
      assert(st->usesFunctionalUnits());
      for(FunctionalUnitIterator fu(st); fu; fu++) {
	PipelineStage<ParamExeNode>* stage = fu->firstStage();
	for (StageNodeIterator node(stage) ; node ; node++) {
	  bool stop = false;
	  int num_possible_contenders = 0;
	  if (node->latency() > 1)
	    num_possible_contenders = 1; // possible late contender
	  int num_early_contenders = 0;

	  int index = 0;
	  int size = stage->numberOfNodes();
	  node->initContenders(size);
	  stop = false;
	  for (StageNodeIterator cont(stage) ; cont && !stop ; cont++) {
	    if (cont->inst()->index() >= node->inst()->index())
	      stop = true;
	    else {
	      if (cont->inst()->index() >= node->inst()->index() - _capacity ) {
		// if cont finishes surely before node, it is not contemp
		// if cont is ready after node, it is not contemp
		bool finishes_before = true;
		bool ready_after = true;
		for (ResourceIterator res(this) ; res ; res++) {
		  int r = res->index();
		  if ((res->type() != INTERNAL_CONFLICT)
		      &&
		      ((res->type() != EXTERNAL_CONFLICT))) {
		    if (cont->e(r)) {
		      if (!node->e(r)) {
			finishes_before = false;
		      }
		      else {
			int cont_contention_delay =
			  ((cont->lateContenders() + cont->possibleContenders()->countBits()) / stage->width())
			     * node->latency();
			if (1 /*node->d(r) < cont->d(r) + cont->latency() + cont_contention_delay*/)
			  finishes_before = false;
		      }
		    }
		    if (node->e(r)) {
		      if (!cont->e(r))
			ready_after = false;
		      else {
			int node_contention_delay = (num_possible_contenders / stage->width()) * node->latency();
			if (cont->d(r) <= node->d(r) + node_contention_delay)
			  ready_after = false;
		      }
		    }
		  }
		  if (!finishes_before && !ready_after){
		    *_trace << L9 << "\t" << node->name() << " might be in conflict with " << cont->name();
		     *_trace << L9 << " because of " << res->name() << "\n";
		    if (_last_node[PROLOGUE] && (cont->inst()->index() <= _last_node[PROLOGUE]->inst()->index()))
		      *_trace << L9 << "\tbut is also a contender of node Lp !\n";
		    num_possible_contenders++;
		    if (_last_node[PROLOGUE] && (cont->inst()->index() <= _last_node[PROLOGUE]->inst()->index())) {
		      num_early_contenders++;
		      node->setContender(index);
		    }
		    break;
		  }
		}
	      }
	    }
	    index++;
	  } // end: foreach possible contender
	  node->setLateContenders(num_possible_contenders - num_early_contenders);
	  node->buildContendersMasks();
	} // end: foreach node of the stage
      } //end: foreach functional unit
    }
  } // end: foreach stage
}

// --------------------------------------------
void ParamExeNode::buildContendersMasks(){
  if (_possible_contenders->countBits() == 0) {
    elm::BitVector *mask = new elm::BitVector(_possible_contenders->size());
    _contenders_masks_list.addLast(mask);
  }
  for (elm::BitVector::OneIterator one(*_possible_contenders) ; one ; one++) {
    if (_contenders_masks_list.isEmpty()) {
      elm::BitVector *mask = new elm::BitVector(_possible_contenders->size());
      assert(mask->size() == _possible_contenders->size());
      _contenders_masks_list.addLast(mask);
      mask = new elm::BitVector(_possible_contenders->size());
      assert(mask->size() == _possible_contenders->size());
      mask->set(one.item());
      _contenders_masks_list.addLast(mask);
    }
    else {
      elm::genstruct::SLList<elm::BitVector *> new_masks;
      for (elm::genstruct::SLList<elm::BitVector *>::Iterator mask(_contenders_masks_list) ;
	   mask ; mask++) {
	assert(mask->size() == _possible_contenders->size());
	elm::BitVector *new_mask = new elm::BitVector(**mask);
	assert(new_mask->size() == _possible_contenders->size());
	new_mask->set(one.item());
	new_masks.addLast(new_mask);
      }
      for (elm::genstruct::SLList<elm::BitVector *>::Iterator new_mask(new_masks) ;
	   new_mask ; new_mask++)
	_contenders_masks_list.addLast(new_mask);
    }
  }
}



// --------------------------------------------
void ParamExeGraph::initDelays() {
  int index = 0;
  for (elm::genstruct::Vector<Resource *>::Iterator res(_resources) ; res ; res++) {
    switch ( res->type() ) {
    case BLOCK_START: {
      ParamExeNode * node = _first_node[PROLOGUE];
      if (!node) {
	node = _first_node[BODY];

      }
      node->setE(index,true);
    }
      break;
    case STAGE: {
      PipelineStage<ParamExeNode> * stage = ((StageResource *) *res)->stage();
      int slot = ((StageResource *) *res)->slot();
      ParamExeNode * node = stage->node(slot);
      if (node) {
	node->setE(index,true);
      }
    }
      break;
    case FU : {
      PipelineStage<ParamExeNode> * stage = ((FuResource *) *res)->fu()->firstStage();
      int slot = ((FuResource *) *res)->slot();
      ParamExeNode * node = stage->node(slot);
      if (node) {
	node->setE(index,true);
      }
    }
      break;
    case QUEUE : {
      Queue<ParamExeNode> *queue = ((QueueResource *) *res)->queue();
      PipelineStage<ParamExeNode> * stage = queue->fillingStage();
      int slot = ((QueueResource *) *res)->slot();
      ParamExeNode * node = stage->node(slot);
      if (node) {
	node->setE(index,true);
      }
    }
      break;
    case REG : {
      for (RegResource::UsingInstIterator inst( (RegResource *) *res ) ; inst ; inst++) {
	for (InstNodeIterator node(inst) ; node ; node++) {
	  if (node->needsOperands()) {
	    node->setE(index,true);
	  }
	}
      }
    }
      break;
    case EXTERNAL_CONFLICT:{
      ExeInst<ParamExeNode> * inst = ((ExternalConflictResource *) *res)->instruction();
      for (InstNodeIterator node(inst) ; node ; node++) {
	if ( node->needsOperands()
	     &&
	     (node->pipelineStage()->orderPolicy() == PipelineStage<ParamExeNode>::OUT_OF_ORDER) ) {
	  node->setE(index,true);
	  node->setContentionDep(inst->index());
	  //node->setContentionDep(inst->index());
	}
      }
    }
      break;
    case INTERNAL_CONFLICT: {
      ExeInst<ParamExeNode> * inst = ((InternalConflictResource *) *res)->instruction();
      for (InstNodeIterator node(inst) ; node ; node++) {
	if ( node->needsOperands()
	     &&
	     (node->pipelineStage()->orderPolicy() == PipelineStage<ParamExeNode>::OUT_OF_ORDER) ) {
	  node->setE(index,true);
	  ((InternalConflictResource *) *res)->setNode(node);
	}
      }
    }
      break;
    }
    index++;
  }
}


// -----------------------------------------------------------------
void ParamExeGraph::propagate() {
	typedef graph::PreorderIterator<GenGraph<ParamExeNode, ExeEdge> > PreOrderIter;
	for(PreOrderIter node(_graph, this->_entry_node);
	node; node++) {
		if(node->hasPred()) {
			for(Predecessor pred(node) ; pred ; pred++) {
				int _latency;
				if(pred->type() == ExeEdge::SOLID)
					_latency = pred->source()->latency() + pred->latency();
				else
					_latency = 0;
				for(elm::genstruct::Vector<Resource *>::Iterator resource(_resources) ; resource ; resource++) {
					int index = resource->index();
					if(pred->source()->e(index)) {
						node->setE(index, true);
						int _delay = pred->source()->d(index) + _latency;
						if (_delay > node->d(index))
							node->setD(index, _delay);
					}
				}
			}
		}
	}
}

// --------------------------------------------------------------------------------------------------

int ParamExeGraph::analyze() {

  this->initDelays();

  _capacity = 0;
  for(Microprocessor<ParamExeNode>::QueueIterator queue(_microprocessor); queue; queue++){
    //capacity += queue->size();
    _capacity = queue->size();		//FIXME: capacity should be the size of the queue where instructions can be in conflict to access to FUs
  }

  this->propagate();
  this->analyzeContentions();


  for (int i=0 ; i<RES_TYPE_NUM ; i++) {
    res_dep[i] = false;
    res_dep_impact[i] = 0;
  }

  if (_last_node[PROLOGUE])
    return(cost());
  else
    return (_last_node[BODY]->d(0) + _last_node[BODY]->latency());  // resource 0 is BLOCK_START
}

// ---------------------------------------
void ParamExeGraph::dump(elm::io::Output& dotFile) {

  dotFile << "digraph G {\n";
  dotFile << "\"legend\" [shape=record, label= \"{ ";
  int i=0;
  bool first_line = true;
  int width = 5;
  for (elm::genstruct::Vector<Resource *>::Iterator res(_resources) ; res ; res++) {
    if (i == 0) {
      if (!first_line)
	dotFile << " | ";
      first_line = false;
      dotFile << "{ ";
    }
    dotFile << res->name();
    if (i < width-1){
      dotFile << " | ";
      i++;
    }
    else {
      dotFile << "} ";
      i = 0;
    }
  }
  if (i!= 0)
    dotFile << "} ";
  dotFile << "} ";
  dotFile << "\"] ; \n";

    dotFile << "\"code\" [shape=record, label= \"";
  for (InstIterator inst(_sequence) ; inst ; inst++) {
  	dotFile << "0x" << inst->inst()->address() << ":  ";
  	inst->inst()->dump(dotFile);
  	dotFile << "\\" << "n" ;
  }
  dotFile << "\"] ; \n";


  for (InstIterator inst(_sequence) ; inst ; inst++) {
    // dump nodes
    dotFile << "{ rank = same ; ";
    for (InstNodeIterator node(inst) ; node ; node++) {
      dotFile << "\"" << node->pipelineStage()->shortName();
      dotFile << "I" << node->inst()->index() << "\" ; ";
    }
    dotFile << "}\n";
    // again to specify labels
    for (InstNodeIterator node(inst) ; node ; node++) {
      dotFile << "\"" << node->pipelineStage()->shortName();
      dotFile << "I" << node->inst()->index() << "\"";
      dotFile << " [shape=record, ";
      if (node->inst()->codePart() == BODY)
	dotFile << "color=blue, ";
      dotFile << "label=\"" << node->pipelineStage()->shortName();
      dotFile << "(I" << node->inst()->index() << ") ";
      dotFile << "| { ";
      int i=0;
      int num = _resources.length();
      while (i < num) {
	int j=0;
	dotFile << "{ ";
	while ( j<width ) {
	  if ( (i<num) && (j<num) ) {
	    if (node->e(i))
	      dotFile << node->d(i, ExeGraph<ParamExeNode>::MIN);
	  }
	  if (j<width-1)
	    dotFile << " | ";
	  i++;
	  j++;
	}
	dotFile << "} ";
	if (i<num)
	  dotFile << " | ";
      }
      dotFile << "} ";
      dotFile << "\"] ; \n";
    }
    dotFile << "\n";
  }


  int group_number = 0;
  for (InstIterator inst(_sequence) ; inst ; inst++) {
    // dump edges
    for (InstNodeIterator node(inst) ; node ; node++) {
      for (Successor next(node) ; next ; next++) {
	if ( node != inst->firstNode()
	     ||
	     (!node->producesOperands())
	     || (node->inst()->index() == next->target()->inst()->index()) ) {
	  dotFile << "\"" << node->pipelineStage()->shortName();
	  dotFile << "I" << node->inst()->index() << "\"";
	  dotFile << " -> ";
	  dotFile << "\"" << next->target()->pipelineStage()->shortName();
	  dotFile << "I" << next->target()->inst()->index() << "\"";
	  switch( next->type()) {
	  case ExeEdge::SOLID:
	    if (node->inst()->index() == next->target()->inst()->index())
	      dotFile << "[minlen=4]";
	    dotFile << " ;\n";
	    break;
	  case ExeEdge::SLASHED:
	    dotFile << " [style=dotted";
	    if (node->inst()->index() == next->target()->inst()->index())
	      dotFile << ", minlen=4";
	    dotFile << "] ;\n";
	    break;
	  default:
	    break;
	  }
	  if ((node->inst()->index() == next->target()->inst()->index())
	      || ((node->pipelineStage()->index() == next->target()->pipelineStage()->index())
		  && (node->inst()->index() == next->target()->inst()->index()-1)) ) {
	    dotFile << "\"" << node->pipelineStage()->shortName();
	    dotFile << "I" << node->inst()->index() << "\"  [group=" << group_number << "] ;\n";
	    dotFile << "\"" << next->target()->pipelineStage()->shortName();
	    dotFile << "I" << next->target()->inst()->index() << "\" [group=" << group_number << "] ;\n";
	    group_number++;
	  }
	}
      }
    }
    dotFile << "\n";
  }
  dotFile << "}\n";
}

void ParamExeGraph::dumpSimple(elm::io::Output& dotFile) {

  dotFile << "digraph G {\n";

  dotFile << "\"legend\" [shape=record, label= \"";
  for (InstIterator inst(_sequence) ; inst ; inst++) {
  	dotFile << "0x" << inst->inst()->address() << ":  ";
  	inst->inst()->dump(dotFile);
  	dotFile << "\\" << "n" ;
  }
  dotFile << "\"] ; \n";

  for (InstIterator inst(_sequence) ; inst ; inst++) {
    // dump nodes
    dotFile << "{ rank = same ; ";
    for (InstNodeIterator node(inst) ; node ; node++) {
      dotFile << "\"" << node->pipelineStage()->shortName();
      dotFile << "I" << node->inst()->index() << "\" ; ";
    }
    dotFile << "}\n";

    // again to specify labels
    for (InstNodeIterator node(inst) ; node ; node++) {
      dotFile << "\"" << node->pipelineStage()->shortName();
      dotFile << "I" << node->inst()->index() << "\"";
      dotFile << " [shape=record, ";
      if (node->inst()->codePart() == BODY)
				dotFile << "color=blue, ";
      dotFile << "label=\"" << node->pipelineStage()->shortName();
      dotFile << "(I" << node->inst()->index() << ") ";
      dotFile << "\\" << "n " << instCategory(node->inst()->inst()) << " [" << node->latency(MIN) << "]";
      dotFile << "\"] ; \n";
    }
    dotFile << "\n";
  }


  int group_number = 0;
  for (InstIterator inst(_sequence) ; inst ; inst++) {
    // dump edges
    for (InstNodeIterator node(inst) ; node ; node++) {
      for (Successor next(node) ; next ; next++) {
	if ( node != inst->firstNode()
	     ||
	     (!node->producesOperands())
	     || (node->inst()->index() == next->target()->inst()->index()) ) {
	  dotFile << "\"" << node->pipelineStage()->shortName();
	  dotFile << "I" << node->inst()->index() << "\"";
	  dotFile << " -> ";
	  dotFile << "\"" << next->target()->pipelineStage()->shortName();
	  dotFile << "I" << next->target()->inst()->index() << "\"";
	  switch( next->type()) {
	  case ExeEdge::SOLID:
	    if (node->inst()->index() == next->target()->inst()->index())
	      dotFile << "[minlen=4]";
	    dotFile << " ;\n";
	    break;
	  case ExeEdge::SLASHED:
	    dotFile << " [style=dotted";
	    if (node->inst()->index() == next->target()->inst()->index())
	      dotFile << ", minlen=4";
	    dotFile << "] ;\n";
	    break;
	  default:
	    break;
	  }
	  if ((node->inst()->index() == next->target()->inst()->index())
	      || ((node->pipelineStage()->index() == next->target()->pipelineStage()->index())
		  && (node->inst()->index() == next->target()->inst()->index()-1)) ) {
	    dotFile << "\"" << node->pipelineStage()->shortName();
	    dotFile << "I" << node->inst()->index() << "\"  [group=" << group_number << "] ;\n";
	    dotFile << "\"" << next->target()->pipelineStage()->shortName();
	    dotFile << "I" << next->target()->inst()->index() << "\" [group=" << group_number << "] ;\n";
	    group_number++;
	  }
	}
      }
    }
    dotFile << "\n";
  }
  dotFile << "}\n";
}

} }		// otawa::lpc2138
