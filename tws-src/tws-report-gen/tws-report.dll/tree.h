#ifndef _TWS_REPORT_TREE_H
#define _TWS_REPORT_TREE_H

#include "node.h"
#include <string>
#include <fstream>
using namespace std;

class tree {
private:
    node*       Root;
    string      LeftPath;
    string      RightPath; 
private:
    ofstream    outfile;
public:
    tree();
    ~tree();
public:
    void AddNode(string Path,node::nodetype NodeType);
    bool ReportTree(string ofpath,string left,string right,string time);
private:
    void ReportSubTree(node* PNode,int PID);
};

#endif // _TWS_REPORT_TREE_H
