#include "node.h"
#include <string>
#include <vector>
using namespace std;

node::node(string Name,nodetype NodeType){
    this->Name=Name;
    this->NodeType=NodeType;
}

node::~node(){ // 后序析构 
    for(vector<node*>::iterator i=Child.begin();i!=Child.end();i++)
        delete (*i);
}

node* node::FindChildByName(string Name){
    int i;
    node* ChildNode;
    for(i=0;i<Child.size();i++)
        if(Child[i]->Name==Name){
            ChildNode=Child[i];
            break;
        }
    if(Child.size()==i){
        ChildNode=NULL;
    }
    return ChildNode;
}

node* node::AddChild(string Name,node::nodetype NodeType){
    node* ChildNode=new node(Name,NodeType);
    Child.push_back(ChildNode);
    return ChildNode;
}

