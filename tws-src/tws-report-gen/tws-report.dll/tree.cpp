#include "tree.h"
#include "node.h"
#include <string>
#include <vector>
using namespace std;

tree::tree(){
    Root=new node(".",node::ntRoot);
}

tree::~tree(){        
    delete Root;
}

void tree::AddNode(string Path,node::nodetype NodeType){
    size_t  prev=1,next=0; // 前后路径分隔符的位置
    string  nodename;
    node*   Node=Root,*tmpNode;
    do{
        next=Path.find("\\",prev+1);

        if(next==string::npos){
            nodename=Path.substr(prev+1);
            Node=Node->AddChild(nodename,NodeType);
        }else{
            nodename=Path.substr(prev+1,next-prev-1);
            prev=next;
            if( (tmpNode=Node->FindChildByName(nodename)) )
                Node=tmpNode;
            else
                Node=Node->AddChild(nodename,node::ntRoot);
        }
    }while(next!=string::npos);
}

bool tree::ReportTree(string ofpath,string left,string right,string time){
    outfile.open(ofpath.c_str());
    if(!outfile)
        return false;
    outfile<< \
   "<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">"<<endl<< \
   "<html>"<<endl<< \
   "<head>"<<endl<< \
   "    <title>比对报告</title>"<<endl<< \
   "    <meta http-equiv=\"content-type\" content=\"text/html; charset=utf-8\">"<<endl<< \
   "    <link rel=\"StyleSheet\" href=\"dtree.css\" type=\"text/css\"/>"<<endl<< \
   "    <script type=\"text/javascript\" src=\"dtree.js\"></script>"<<endl<< \
   "</head>"<<endl<< \
   "<body>"<<endl<< \
   "    <h3>比对报告@"<<time<<"</h3>"<<endl<< \
   "    <h4>左侧="<<left<<" | 右侧="<<right<<"</h4>"<<endl<< \
   "    <div class=\"dtree\">"<<endl<< \
   "        <p><a href=\"javascript: d.openAll();\">全部展开</a> | <a href=\"javascript: d.closeAll();\">全部收起</a></p>"<<endl<< \
   "        <script type=\"text/javascript\">"<<endl<< \
   "            <!--"<<endl<< \
   "            d = new dTree(\'d\');"<<endl;
   
    ReportSubTree(Root,(-1));
    
    outfile << \
   "            document.write(d);"<<endl<< \
   "            //-->"<<endl<< \
   "        </script>"<<endl<< \
   "    </div>"<<endl<< \
   "    <p>By Ricyn Lee 李銳森 2017</p>"<<endl<< \
   "    <div class=\"dtree\">"<<endl<< \
   "        <p><img src=\"extra-img/folder-l-only.png\">:左侧独有文件夹</p>"<<endl<< \
   "        <p><img src=\"extra-img/folder-r-only.png\">:右侧独有文件夹</p>"<<endl<< \
   "        <p><img src=\"extra-img/file-l-only.png\">:左侧独有文件</p>"<<endl<< \
   "        <p><img src=\"extra-img/file-r-only.png\">:右侧独有文件</p>"<<endl<< \
   "        <p><img src=\"extra-img/file-l-newer.png\">:左侧较新的同名文件</p>"<<endl<< \
   "        <p><img src=\"extra-img/file-r-newer.png\">:右侧较新的同名文件</p>"<<endl<< \
   "    </div>"<<endl<< \
   "</body>"<<endl<< \
   "</html>"<<endl;
    outfile.close();
    return true;
}

void tree::ReportSubTree(node* Node,int PID){
    static int ID;
    if(PID==(-1)){
        Node=Root;
        ID=0;
        if(Node->Child.size()/*>0*/)
            outfile << "            d.add(0,-1,\'比对顶层\',\'\',\'\',\'\',"<< \
                    "\'extra-img/folder.png\',\'extra-img/folder.png\');"<<endl;
        else
            outfile << "            d.add(0,-1,\'比对顶层(左右完全一致)\',\'\',\'\',\'\',"<< \
                    "\'extra-img/folder.png\',\'extra-img/folder.png\');"<<endl;
    }else{
        ID++;
        switch(Node->NodeType){
        case (node::ntFolderLeftOnly):
            outfile << "            d.add("<<ID<<","<<PID<<", \'"<<Node->Name<< \
                    "\',\'\',\'左侧独有\',\'\',"<< \
                    "\'extra-img/folder-l-only.png\',"<< \
                    "\'extra-img/folder-l-only.png\');"<<endl;
            break;
        case (node::ntFolderRightOnly):
            outfile << "            d.add("<<ID<<","<<PID<<", \'"<<Node->Name<< \
                    "\',\'\',\'右侧独有\',\'\',"<< \
                    "\'extra-img/folder-r-only.png\',"<< \
                    "\'extra-img/folder-r-only.png\');"<<endl;
            break;
        case (node::ntFileLeftOnly):
            outfile << "            d.add("<<ID<<","<<PID<<", \'"<<Node->Name<< \
                    "\',\'\',\'左侧独有\',\'\',"<< \
                    "\'extra-img/file-l-only.png\',"<< \
                    "\'extra-img/file-l-only.png\');"<<endl;
            break;
        case (node::ntFileRightOnly):
            outfile << "            d.add("<<ID<<","<<PID<<", \'"<<Node->Name<< \
                    "\',\'\',\'右侧独有\',\'\',"<< \
                    "\'extra-img/file-r-only.png\',"<< \
                    "\'extra-img/file-r-only.png\');"<<endl;
            break;
        case (node::ntFileLeftNewer):
            outfile << "            d.add("<<ID<<","<<PID<<", \'"<<Node->Name<< \
                    "\',\'\',\'左侧较新\',\'\',"<< \
                    "\'extra-img/file-l-newer.png\',"<< \
                    "\'extra-img/file-l-newer.png\');"<<endl;
            break;
        case (node::ntFileRightNewer):
            outfile << "            d.add("<<ID<<","<<PID<<", \'"<<Node->Name<< \
                    "\',\'\',\'右侧较新\',\'\',"<< \
                    "\'extra-img/file-r-newer.png\',"<< \
                    "\'extra-img/file-r-newer.png\');"<<endl;
            break;
        default:
            outfile << "            d.add("<<ID<<","<<PID<<", \'"<<Node->Name<< \
                    "\',\'\',\'\',\'\',"<< \
                    "\'extra-img/folder.png\',"<< \
                    "\'extra-img/folder.png\');"<<endl;
        }
    }
    PID=ID;
    for(vector<node*>::iterator i=Node->Child.begin();i!=Node->Child.end();i++)
        ReportSubTree(*i,PID);
}
