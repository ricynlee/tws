#ifndef _TWS_REPORT_NODE_H
#define _TWS_REPORT_NODE_H

#include <string>
#include <vector>
using namespace std;

class node {
public:
    typedef enum {
        ntRoot,
        ntFolderLeftOnly,
        ntFolderRightOnly,
        ntFileLeftOnly,
        ntFileRightOnly,
        ntFileLeftNewer,
        ntFileRightNewer
    } nodetype;
private:
    string                  Name;
    nodetype                NodeType;
    vector<struct node*>    Child;
public:
    node();
    node(string Name,nodetype NodeType);
    ~node();
    friend class tree;
public:
    node* FindChildByName(string Name);
    node* AddChild(string Name,nodetype NodeType);
};

#endif // _TWS_REPORT_NODE_H
