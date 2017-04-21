//This cpp implements export functions of Dll
#include "commom.h"
#include "export.h"

#include "tree.h"
#include "node.h"
#include <iostream>
#include <fstream>
#include <cstring>
using namespace std;

CALL long report(LPCSTR src, LPCSTR dst){
    string Src=src;
    string Dst=dst;
    
    tree Tree;
    char buf[1024];
    int  linelen;
    typedef enum{rsLO,rsRO,rsDF}ReadState;
    ReadState rs;
    string LeftPath;
    string RightPath;
    string ReportTime;
    ifstream in(Src.c_str());
    if(!in)
        return (-2);
    while(!in.eof()){
        in.getline(buf,1024);
        if(buf[0]=='.'){
            linelen=strlen(buf);
            buf[linelen-2]='\0';
            if(rs==rsLO){
                if(buf[linelen-1]=='F')
                    Tree.AddNode(buf,node::ntFileLeftOnly);
                else if(buf[linelen-1]=='D')
                    Tree.AddNode(buf,node::ntFolderLeftOnly);
            }else if(rs==rsRO){
                if(buf[linelen-1]=='F')
                    Tree.AddNode(buf,node::ntFileRightOnly);
                else if(buf[linelen-1]=='D')
                    Tree.AddNode(buf,node::ntFolderRightOnly);
            }else /*rsDF*/{
                if(buf[linelen-1]=='L')
                    Tree.AddNode(buf,node::ntFileLeftNewer);
                else if(buf[linelen-1]=='R')
                    Tree.AddNode(buf,node::ntFileRightNewer);
            }
        }else if(strcmp(buf,"LEFT-ONLY ITEMS:")==0){
            rs=rsLO; // Left-only
        }else if(strcmp(buf,"RIGHT-ONLY ITEMS:")==0){
            rs=rsRO; // Right-only
        }else if(strcmp(buf,"DIFFERENT FILES:")==0){
            rs=rsDF; // Diff files
        }else if(strncmp(buf,"LEFT=",5)==0){
            LeftPath=buf+5;
        }else if(strncmp(buf,"RIGHT=",6)==0){
            RightPath=buf+6;
        }else if(strncmp(buf,"REPORT@",7)==0){
            ReportTime=buf+7;
        }
    }
    in.close();
    if(!Tree.ReportTree(Dst,LeftPath,RightPath,ReportTime))
        return (-3);
    return 0;
}
